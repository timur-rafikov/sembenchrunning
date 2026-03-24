(define (domain failed_capstone_recovery_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types institutional_entity - object artifact - object document_category - object case_root_category - object capstone_case - case_root_category institutional_resource - institutional_entity faculty_evaluator - institutional_entity review_panel - institutional_entity policy_exception_document - institutional_entity administrative_form - institutional_entity official_record_document - institutional_entity external_evaluator - institutional_entity accreditation_marker - institutional_entity supplemental_element - artifact evidence_artifact - artifact endorsement_token - artifact student_schedule_slot - document_category supervisor_schedule_slot - document_category recovery_plan_document - document_category student_case_category - capstone_case program_case_category - capstone_case student_case_record - student_case_category supervisor_case_record - student_case_category program_case_record - program_case_category)
  (:predicates
    (case_intake_flag ?capstone_case - capstone_case)
    (triage_complete ?capstone_case - capstone_case)
    (remediation_assigned ?capstone_case - capstone_case)
    (case_closed_recorded ?capstone_case - capstone_case)
    (ready_for_recovery_actions ?capstone_case - capstone_case)
    (recovery_plan_needed_flag ?capstone_case - capstone_case)
    (resource_available ?institutional_resource - institutional_resource)
    (resource_allocated_to_case ?capstone_case - capstone_case ?institutional_resource - institutional_resource)
    (evaluator_available ?faculty_evaluator - faculty_evaluator)
    (faculty_evaluator_assigned_to_case ?capstone_case - capstone_case ?faculty_evaluator - faculty_evaluator)
    (panel_available ?review_panel - review_panel)
    (panel_assigned_to_case ?capstone_case - capstone_case ?review_panel - review_panel)
    (supplemental_element_available ?supplemental_element - supplemental_element)
    (student_record_attached_element ?student_case_record - student_case_record ?supplemental_element - supplemental_element)
    (supervisor_record_attached_element ?supervisor_case_record - supervisor_case_record ?supplemental_element - supplemental_element)
    (student_slot_link ?student_case_record - student_case_record ?student_schedule_slot - student_schedule_slot)
    (student_slot_confirmed ?student_schedule_slot - student_schedule_slot)
    (student_alternate_slot_confirmed ?student_schedule_slot - student_schedule_slot)
    (student_preconditions_met ?student_case_record - student_case_record)
    (supervisor_slot_link ?supervisor_case_record - supervisor_case_record ?supervisor_schedule_slot - supervisor_schedule_slot)
    (supervisor_slot_confirmed ?supervisor_schedule_slot - supervisor_schedule_slot)
    (supervisor_alternate_slot_confirmed ?supervisor_schedule_slot - supervisor_schedule_slot)
    (supervisor_preconditions_met ?supervisor_case_record - supervisor_case_record)
    (plan_slot_reserved ?recovery_plan_document - recovery_plan_document)
    (plan_populated ?recovery_plan_document - recovery_plan_document)
    (plan_links_student_slot ?recovery_plan_document - recovery_plan_document ?student_schedule_slot - student_schedule_slot)
    (plan_links_supervisor_slot ?recovery_plan_document - recovery_plan_document ?supervisor_schedule_slot - supervisor_schedule_slot)
    (plan_includes_student_contingency ?recovery_plan_document - recovery_plan_document)
    (plan_includes_supervisor_contingency ?recovery_plan_document - recovery_plan_document)
    (plan_activated ?recovery_plan_document - recovery_plan_document)
    (program_links_student_record ?program_case_record - program_case_record ?student_case_record - student_case_record)
    (program_links_supervisor_record ?program_case_record - program_case_record ?supervisor_case_record - supervisor_case_record)
    (program_has_plan_reference ?program_case_record - program_case_record ?recovery_plan_document - recovery_plan_document)
    (artifact_available ?evidence_artifact - evidence_artifact)
    (program_attached_artifact ?program_case_record - program_case_record ?evidence_artifact - evidence_artifact)
    (artifact_validated ?evidence_artifact - evidence_artifact)
    (artifact_linked_to_plan ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document)
    (program_prepared_for_external_review ?program_case_record - program_case_record)
    (external_review_requested ?program_case_record - program_case_record)
    (external_review_completed ?program_case_record - program_case_record)
    (policy_exception_available ?program_case_record - program_case_record)
    (policy_exception_registered ?program_case_record - program_case_record)
    (endorsements_collected ?program_case_record - program_case_record)
    (final_verification_passed ?program_case_record - program_case_record)
    (endorsement_available ?endorsement_token - endorsement_token)
    (program_has_endorsement ?program_case_record - program_case_record ?endorsement_token - endorsement_token)
    (special_adjudication_flag ?program_case_record - program_case_record)
    (adjudication_stage_one_complete ?program_case_record - program_case_record)
    (adjudication_stage_two_complete ?program_case_record - program_case_record)
    (policy_document_available ?policy_exception_document - policy_exception_document)
    (policy_document_used ?program_case_record - program_case_record ?policy_exception_document - policy_exception_document)
    (administrative_form_available ?administrative_form - administrative_form)
    (administrative_form_attached ?program_case_record - program_case_record ?administrative_form - administrative_form)
    (external_evaluator_available ?external_evaluator - external_evaluator)
    (external_evaluator_assigned_to_case ?program_case_record - program_case_record ?external_evaluator - external_evaluator)
    (accreditation_marker_available ?accreditation_marker - accreditation_marker)
    (accreditation_marker_attached ?program_case_record - program_case_record ?accreditation_marker - accreditation_marker)
    (official_record_document_available ?official_record_document - official_record_document)
    (official_record_linked ?capstone_case - capstone_case ?official_record_document - official_record_document)
    (student_ready_for_closure ?student_case_record - student_case_record)
    (supervisor_ready_for_closure ?supervisor_case_record - supervisor_case_record)
    (program_ready_for_administrative_closure ?program_case_record - program_case_record)
  )
  (:action register_case_intake
    :parameters (?capstone_case - capstone_case)
    :precondition
      (and
        (not
          (case_intake_flag ?capstone_case)
        )
        (not
          (case_closed_recorded ?capstone_case)
        )
      )
    :effect (case_intake_flag ?capstone_case)
  )
  (:action assign_resource_to_case
    :parameters (?capstone_case - capstone_case ?institutional_resource - institutional_resource)
    :precondition
      (and
        (case_intake_flag ?capstone_case)
        (not
          (remediation_assigned ?capstone_case)
        )
        (resource_available ?institutional_resource)
      )
    :effect
      (and
        (remediation_assigned ?capstone_case)
        (resource_allocated_to_case ?capstone_case ?institutional_resource)
        (not
          (resource_available ?institutional_resource)
        )
      )
  )
  (:action assign_faculty_evaluator
    :parameters (?capstone_case - capstone_case ?faculty_evaluator - faculty_evaluator)
    :precondition
      (and
        (case_intake_flag ?capstone_case)
        (remediation_assigned ?capstone_case)
        (evaluator_available ?faculty_evaluator)
      )
    :effect
      (and
        (faculty_evaluator_assigned_to_case ?capstone_case ?faculty_evaluator)
        (not
          (evaluator_available ?faculty_evaluator)
        )
      )
  )
  (:action confirm_evaluator_assignment
    :parameters (?capstone_case - capstone_case ?faculty_evaluator - faculty_evaluator)
    :precondition
      (and
        (case_intake_flag ?capstone_case)
        (remediation_assigned ?capstone_case)
        (faculty_evaluator_assigned_to_case ?capstone_case ?faculty_evaluator)
        (not
          (triage_complete ?capstone_case)
        )
      )
    :effect (triage_complete ?capstone_case)
  )
  (:action release_assigned_evaluator
    :parameters (?capstone_case - capstone_case ?faculty_evaluator - faculty_evaluator)
    :precondition
      (and
        (faculty_evaluator_assigned_to_case ?capstone_case ?faculty_evaluator)
      )
    :effect
      (and
        (evaluator_available ?faculty_evaluator)
        (not
          (faculty_evaluator_assigned_to_case ?capstone_case ?faculty_evaluator)
        )
      )
  )
  (:action assign_review_panel
    :parameters (?capstone_case - capstone_case ?review_panel - review_panel)
    :precondition
      (and
        (triage_complete ?capstone_case)
        (panel_available ?review_panel)
      )
    :effect
      (and
        (panel_assigned_to_case ?capstone_case ?review_panel)
        (not
          (panel_available ?review_panel)
        )
      )
  )
  (:action release_review_panel
    :parameters (?capstone_case - capstone_case ?review_panel - review_panel)
    :precondition
      (and
        (panel_assigned_to_case ?capstone_case ?review_panel)
      )
    :effect
      (and
        (panel_available ?review_panel)
        (not
          (panel_assigned_to_case ?capstone_case ?review_panel)
        )
      )
  )
  (:action assign_external_evaluator
    :parameters (?program_case_record - program_case_record ?external_evaluator - external_evaluator)
    :precondition
      (and
        (triage_complete ?program_case_record)
        (external_evaluator_available ?external_evaluator)
      )
    :effect
      (and
        (external_evaluator_assigned_to_case ?program_case_record ?external_evaluator)
        (not
          (external_evaluator_available ?external_evaluator)
        )
      )
  )
  (:action release_external_evaluator
    :parameters (?program_case_record - program_case_record ?external_evaluator - external_evaluator)
    :precondition
      (and
        (external_evaluator_assigned_to_case ?program_case_record ?external_evaluator)
      )
    :effect
      (and
        (external_evaluator_available ?external_evaluator)
        (not
          (external_evaluator_assigned_to_case ?program_case_record ?external_evaluator)
        )
      )
  )
  (:action attach_accreditation_marker
    :parameters (?program_case_record - program_case_record ?accreditation_marker - accreditation_marker)
    :precondition
      (and
        (triage_complete ?program_case_record)
        (accreditation_marker_available ?accreditation_marker)
      )
    :effect
      (and
        (accreditation_marker_attached ?program_case_record ?accreditation_marker)
        (not
          (accreditation_marker_available ?accreditation_marker)
        )
      )
  )
  (:action detach_accreditation_marker
    :parameters (?program_case_record - program_case_record ?accreditation_marker - accreditation_marker)
    :precondition
      (and
        (accreditation_marker_attached ?program_case_record ?accreditation_marker)
      )
    :effect
      (and
        (accreditation_marker_available ?accreditation_marker)
        (not
          (accreditation_marker_attached ?program_case_record ?accreditation_marker)
        )
      )
  )
  (:action confirm_student_schedule_slot
    :parameters (?student_case_record - student_case_record ?student_schedule_slot - student_schedule_slot ?faculty_evaluator - faculty_evaluator)
    :precondition
      (and
        (triage_complete ?student_case_record)
        (faculty_evaluator_assigned_to_case ?student_case_record ?faculty_evaluator)
        (student_slot_link ?student_case_record ?student_schedule_slot)
        (not
          (student_slot_confirmed ?student_schedule_slot)
        )
        (not
          (student_alternate_slot_confirmed ?student_schedule_slot)
        )
      )
    :effect (student_slot_confirmed ?student_schedule_slot)
  )
  (:action validate_student_preconditions
    :parameters (?student_case_record - student_case_record ?student_schedule_slot - student_schedule_slot ?review_panel - review_panel)
    :precondition
      (and
        (triage_complete ?student_case_record)
        (panel_assigned_to_case ?student_case_record ?review_panel)
        (student_slot_link ?student_case_record ?student_schedule_slot)
        (student_slot_confirmed ?student_schedule_slot)
        (not
          (student_ready_for_closure ?student_case_record)
        )
      )
    :effect
      (and
        (student_ready_for_closure ?student_case_record)
        (student_preconditions_met ?student_case_record)
      )
  )
  (:action attach_supplemental_element_to_student
    :parameters (?student_case_record - student_case_record ?student_schedule_slot - student_schedule_slot ?supplemental_element - supplemental_element)
    :precondition
      (and
        (triage_complete ?student_case_record)
        (student_slot_link ?student_case_record ?student_schedule_slot)
        (supplemental_element_available ?supplemental_element)
        (not
          (student_ready_for_closure ?student_case_record)
        )
      )
    :effect
      (and
        (student_alternate_slot_confirmed ?student_schedule_slot)
        (student_ready_for_closure ?student_case_record)
        (student_record_attached_element ?student_case_record ?supplemental_element)
        (not
          (supplemental_element_available ?supplemental_element)
        )
      )
  )
  (:action finalize_student_supplemental_usage
    :parameters (?student_case_record - student_case_record ?student_schedule_slot - student_schedule_slot ?faculty_evaluator - faculty_evaluator ?supplemental_element - supplemental_element)
    :precondition
      (and
        (triage_complete ?student_case_record)
        (faculty_evaluator_assigned_to_case ?student_case_record ?faculty_evaluator)
        (student_slot_link ?student_case_record ?student_schedule_slot)
        (student_alternate_slot_confirmed ?student_schedule_slot)
        (student_record_attached_element ?student_case_record ?supplemental_element)
        (not
          (student_preconditions_met ?student_case_record)
        )
      )
    :effect
      (and
        (student_slot_confirmed ?student_schedule_slot)
        (student_preconditions_met ?student_case_record)
        (supplemental_element_available ?supplemental_element)
        (not
          (student_record_attached_element ?student_case_record ?supplemental_element)
        )
      )
  )
  (:action confirm_supervisor_schedule_slot
    :parameters (?supervisor_case_record - supervisor_case_record ?supervisor_schedule_slot - supervisor_schedule_slot ?faculty_evaluator - faculty_evaluator)
    :precondition
      (and
        (triage_complete ?supervisor_case_record)
        (faculty_evaluator_assigned_to_case ?supervisor_case_record ?faculty_evaluator)
        (supervisor_slot_link ?supervisor_case_record ?supervisor_schedule_slot)
        (not
          (supervisor_slot_confirmed ?supervisor_schedule_slot)
        )
        (not
          (supervisor_alternate_slot_confirmed ?supervisor_schedule_slot)
        )
      )
    :effect (supervisor_slot_confirmed ?supervisor_schedule_slot)
  )
  (:action validate_supervisor_preconditions
    :parameters (?supervisor_case_record - supervisor_case_record ?supervisor_schedule_slot - supervisor_schedule_slot ?review_panel - review_panel)
    :precondition
      (and
        (triage_complete ?supervisor_case_record)
        (panel_assigned_to_case ?supervisor_case_record ?review_panel)
        (supervisor_slot_link ?supervisor_case_record ?supervisor_schedule_slot)
        (supervisor_slot_confirmed ?supervisor_schedule_slot)
        (not
          (supervisor_ready_for_closure ?supervisor_case_record)
        )
      )
    :effect
      (and
        (supervisor_ready_for_closure ?supervisor_case_record)
        (supervisor_preconditions_met ?supervisor_case_record)
      )
  )
  (:action attach_supplemental_element_to_supervisor
    :parameters (?supervisor_case_record - supervisor_case_record ?supervisor_schedule_slot - supervisor_schedule_slot ?supplemental_element - supplemental_element)
    :precondition
      (and
        (triage_complete ?supervisor_case_record)
        (supervisor_slot_link ?supervisor_case_record ?supervisor_schedule_slot)
        (supplemental_element_available ?supplemental_element)
        (not
          (supervisor_ready_for_closure ?supervisor_case_record)
        )
      )
    :effect
      (and
        (supervisor_alternate_slot_confirmed ?supervisor_schedule_slot)
        (supervisor_ready_for_closure ?supervisor_case_record)
        (supervisor_record_attached_element ?supervisor_case_record ?supplemental_element)
        (not
          (supplemental_element_available ?supplemental_element)
        )
      )
  )
  (:action finalize_supervisor_supplemental_usage
    :parameters (?supervisor_case_record - supervisor_case_record ?supervisor_schedule_slot - supervisor_schedule_slot ?faculty_evaluator - faculty_evaluator ?supplemental_element - supplemental_element)
    :precondition
      (and
        (triage_complete ?supervisor_case_record)
        (faculty_evaluator_assigned_to_case ?supervisor_case_record ?faculty_evaluator)
        (supervisor_slot_link ?supervisor_case_record ?supervisor_schedule_slot)
        (supervisor_alternate_slot_confirmed ?supervisor_schedule_slot)
        (supervisor_record_attached_element ?supervisor_case_record ?supplemental_element)
        (not
          (supervisor_preconditions_met ?supervisor_case_record)
        )
      )
    :effect
      (and
        (supervisor_slot_confirmed ?supervisor_schedule_slot)
        (supervisor_preconditions_met ?supervisor_case_record)
        (supplemental_element_available ?supplemental_element)
        (not
          (supervisor_record_attached_element ?supervisor_case_record ?supplemental_element)
        )
      )
  )
  (:action populate_recovery_plan
    :parameters (?student_case_record - student_case_record ?supervisor_case_record - supervisor_case_record ?student_schedule_slot - student_schedule_slot ?supervisor_schedule_slot - supervisor_schedule_slot ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (student_ready_for_closure ?student_case_record)
        (supervisor_ready_for_closure ?supervisor_case_record)
        (student_slot_link ?student_case_record ?student_schedule_slot)
        (supervisor_slot_link ?supervisor_case_record ?supervisor_schedule_slot)
        (student_slot_confirmed ?student_schedule_slot)
        (supervisor_slot_confirmed ?supervisor_schedule_slot)
        (student_preconditions_met ?student_case_record)
        (supervisor_preconditions_met ?supervisor_case_record)
        (plan_slot_reserved ?recovery_plan_document)
      )
    :effect
      (and
        (plan_populated ?recovery_plan_document)
        (plan_links_student_slot ?recovery_plan_document ?student_schedule_slot)
        (plan_links_supervisor_slot ?recovery_plan_document ?supervisor_schedule_slot)
        (not
          (plan_slot_reserved ?recovery_plan_document)
        )
      )
  )
  (:action populate_recovery_plan_with_student_contingency
    :parameters (?student_case_record - student_case_record ?supervisor_case_record - supervisor_case_record ?student_schedule_slot - student_schedule_slot ?supervisor_schedule_slot - supervisor_schedule_slot ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (student_ready_for_closure ?student_case_record)
        (supervisor_ready_for_closure ?supervisor_case_record)
        (student_slot_link ?student_case_record ?student_schedule_slot)
        (supervisor_slot_link ?supervisor_case_record ?supervisor_schedule_slot)
        (student_alternate_slot_confirmed ?student_schedule_slot)
        (supervisor_slot_confirmed ?supervisor_schedule_slot)
        (not
          (student_preconditions_met ?student_case_record)
        )
        (supervisor_preconditions_met ?supervisor_case_record)
        (plan_slot_reserved ?recovery_plan_document)
      )
    :effect
      (and
        (plan_populated ?recovery_plan_document)
        (plan_links_student_slot ?recovery_plan_document ?student_schedule_slot)
        (plan_links_supervisor_slot ?recovery_plan_document ?supervisor_schedule_slot)
        (plan_includes_student_contingency ?recovery_plan_document)
        (not
          (plan_slot_reserved ?recovery_plan_document)
        )
      )
  )
  (:action populate_recovery_plan_with_supervisor_contingency
    :parameters (?student_case_record - student_case_record ?supervisor_case_record - supervisor_case_record ?student_schedule_slot - student_schedule_slot ?supervisor_schedule_slot - supervisor_schedule_slot ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (student_ready_for_closure ?student_case_record)
        (supervisor_ready_for_closure ?supervisor_case_record)
        (student_slot_link ?student_case_record ?student_schedule_slot)
        (supervisor_slot_link ?supervisor_case_record ?supervisor_schedule_slot)
        (student_slot_confirmed ?student_schedule_slot)
        (supervisor_alternate_slot_confirmed ?supervisor_schedule_slot)
        (student_preconditions_met ?student_case_record)
        (not
          (supervisor_preconditions_met ?supervisor_case_record)
        )
        (plan_slot_reserved ?recovery_plan_document)
      )
    :effect
      (and
        (plan_populated ?recovery_plan_document)
        (plan_links_student_slot ?recovery_plan_document ?student_schedule_slot)
        (plan_links_supervisor_slot ?recovery_plan_document ?supervisor_schedule_slot)
        (plan_includes_supervisor_contingency ?recovery_plan_document)
        (not
          (plan_slot_reserved ?recovery_plan_document)
        )
      )
  )
  (:action populate_recovery_plan_with_contingencies
    :parameters (?student_case_record - student_case_record ?supervisor_case_record - supervisor_case_record ?student_schedule_slot - student_schedule_slot ?supervisor_schedule_slot - supervisor_schedule_slot ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (student_ready_for_closure ?student_case_record)
        (supervisor_ready_for_closure ?supervisor_case_record)
        (student_slot_link ?student_case_record ?student_schedule_slot)
        (supervisor_slot_link ?supervisor_case_record ?supervisor_schedule_slot)
        (student_alternate_slot_confirmed ?student_schedule_slot)
        (supervisor_alternate_slot_confirmed ?supervisor_schedule_slot)
        (not
          (student_preconditions_met ?student_case_record)
        )
        (not
          (supervisor_preconditions_met ?supervisor_case_record)
        )
        (plan_slot_reserved ?recovery_plan_document)
      )
    :effect
      (and
        (plan_populated ?recovery_plan_document)
        (plan_links_student_slot ?recovery_plan_document ?student_schedule_slot)
        (plan_links_supervisor_slot ?recovery_plan_document ?supervisor_schedule_slot)
        (plan_includes_student_contingency ?recovery_plan_document)
        (plan_includes_supervisor_contingency ?recovery_plan_document)
        (not
          (plan_slot_reserved ?recovery_plan_document)
        )
      )
  )
  (:action activate_recovery_plan
    :parameters (?recovery_plan_document - recovery_plan_document ?student_case_record - student_case_record ?faculty_evaluator - faculty_evaluator)
    :precondition
      (and
        (plan_populated ?recovery_plan_document)
        (student_ready_for_closure ?student_case_record)
        (faculty_evaluator_assigned_to_case ?student_case_record ?faculty_evaluator)
        (not
          (plan_activated ?recovery_plan_document)
        )
      )
    :effect (plan_activated ?recovery_plan_document)
  )
  (:action validate_and_link_evidence_artifact
    :parameters (?program_case_record - program_case_record ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (triage_complete ?program_case_record)
        (program_has_plan_reference ?program_case_record ?recovery_plan_document)
        (program_attached_artifact ?program_case_record ?evidence_artifact)
        (artifact_available ?evidence_artifact)
        (plan_populated ?recovery_plan_document)
        (plan_activated ?recovery_plan_document)
        (not
          (artifact_validated ?evidence_artifact)
        )
      )
    :effect
      (and
        (artifact_validated ?evidence_artifact)
        (artifact_linked_to_plan ?evidence_artifact ?recovery_plan_document)
        (not
          (artifact_available ?evidence_artifact)
        )
      )
  )
  (:action prepare_program_for_external_review
    :parameters (?program_case_record - program_case_record ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document ?faculty_evaluator - faculty_evaluator)
    :precondition
      (and
        (triage_complete ?program_case_record)
        (program_attached_artifact ?program_case_record ?evidence_artifact)
        (artifact_validated ?evidence_artifact)
        (artifact_linked_to_plan ?evidence_artifact ?recovery_plan_document)
        (faculty_evaluator_assigned_to_case ?program_case_record ?faculty_evaluator)
        (not
          (plan_includes_student_contingency ?recovery_plan_document)
        )
        (not
          (program_prepared_for_external_review ?program_case_record)
        )
      )
    :effect (program_prepared_for_external_review ?program_case_record)
  )
  (:action apply_policy_exception_to_program
    :parameters (?program_case_record - program_case_record ?policy_exception_document - policy_exception_document)
    :precondition
      (and
        (triage_complete ?program_case_record)
        (policy_document_available ?policy_exception_document)
        (not
          (policy_exception_available ?program_case_record)
        )
      )
    :effect
      (and
        (policy_exception_available ?program_case_record)
        (policy_document_used ?program_case_record ?policy_exception_document)
        (not
          (policy_document_available ?policy_exception_document)
        )
      )
  )
  (:action register_policy_exception_and_prepare_program
    :parameters (?program_case_record - program_case_record ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document ?faculty_evaluator - faculty_evaluator ?policy_exception_document - policy_exception_document)
    :precondition
      (and
        (triage_complete ?program_case_record)
        (program_attached_artifact ?program_case_record ?evidence_artifact)
        (artifact_validated ?evidence_artifact)
        (artifact_linked_to_plan ?evidence_artifact ?recovery_plan_document)
        (faculty_evaluator_assigned_to_case ?program_case_record ?faculty_evaluator)
        (plan_includes_student_contingency ?recovery_plan_document)
        (policy_exception_available ?program_case_record)
        (policy_document_used ?program_case_record ?policy_exception_document)
        (not
          (program_prepared_for_external_review ?program_case_record)
        )
      )
    :effect
      (and
        (program_prepared_for_external_review ?program_case_record)
        (policy_exception_registered ?program_case_record)
      )
  )
  (:action initiate_external_review_request
    :parameters (?program_case_record - program_case_record ?external_evaluator - external_evaluator ?review_panel - review_panel ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (program_prepared_for_external_review ?program_case_record)
        (external_evaluator_assigned_to_case ?program_case_record ?external_evaluator)
        (panel_assigned_to_case ?program_case_record ?review_panel)
        (program_attached_artifact ?program_case_record ?evidence_artifact)
        (artifact_linked_to_plan ?evidence_artifact ?recovery_plan_document)
        (not
          (plan_includes_supervisor_contingency ?recovery_plan_document)
        )
        (not
          (external_review_requested ?program_case_record)
        )
      )
    :effect (external_review_requested ?program_case_record)
  )
  (:action initiate_external_review_request_alternate
    :parameters (?program_case_record - program_case_record ?external_evaluator - external_evaluator ?review_panel - review_panel ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (program_prepared_for_external_review ?program_case_record)
        (external_evaluator_assigned_to_case ?program_case_record ?external_evaluator)
        (panel_assigned_to_case ?program_case_record ?review_panel)
        (program_attached_artifact ?program_case_record ?evidence_artifact)
        (artifact_linked_to_plan ?evidence_artifact ?recovery_plan_document)
        (plan_includes_supervisor_contingency ?recovery_plan_document)
        (not
          (external_review_requested ?program_case_record)
        )
      )
    :effect (external_review_requested ?program_case_record)
  )
  (:action complete_external_review
    :parameters (?program_case_record - program_case_record ?accreditation_marker - accreditation_marker ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (external_review_requested ?program_case_record)
        (accreditation_marker_attached ?program_case_record ?accreditation_marker)
        (program_attached_artifact ?program_case_record ?evidence_artifact)
        (artifact_linked_to_plan ?evidence_artifact ?recovery_plan_document)
        (not
          (plan_includes_student_contingency ?recovery_plan_document)
        )
        (not
          (plan_includes_supervisor_contingency ?recovery_plan_document)
        )
        (not
          (external_review_completed ?program_case_record)
        )
      )
    :effect (external_review_completed ?program_case_record)
  )
  (:action complete_external_review_and_collect_endorsements
    :parameters (?program_case_record - program_case_record ?accreditation_marker - accreditation_marker ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (external_review_requested ?program_case_record)
        (accreditation_marker_attached ?program_case_record ?accreditation_marker)
        (program_attached_artifact ?program_case_record ?evidence_artifact)
        (artifact_linked_to_plan ?evidence_artifact ?recovery_plan_document)
        (plan_includes_student_contingency ?recovery_plan_document)
        (not
          (plan_includes_supervisor_contingency ?recovery_plan_document)
        )
        (not
          (external_review_completed ?program_case_record)
        )
      )
    :effect
      (and
        (external_review_completed ?program_case_record)
        (endorsements_collected ?program_case_record)
      )
  )
  (:action complete_external_review_and_record_endorsements
    :parameters (?program_case_record - program_case_record ?accreditation_marker - accreditation_marker ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (external_review_requested ?program_case_record)
        (accreditation_marker_attached ?program_case_record ?accreditation_marker)
        (program_attached_artifact ?program_case_record ?evidence_artifact)
        (artifact_linked_to_plan ?evidence_artifact ?recovery_plan_document)
        (not
          (plan_includes_student_contingency ?recovery_plan_document)
        )
        (plan_includes_supervisor_contingency ?recovery_plan_document)
        (not
          (external_review_completed ?program_case_record)
        )
      )
    :effect
      (and
        (external_review_completed ?program_case_record)
        (endorsements_collected ?program_case_record)
      )
  )
  (:action finalize_external_review_with_all_endorsements
    :parameters (?program_case_record - program_case_record ?accreditation_marker - accreditation_marker ?evidence_artifact - evidence_artifact ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (external_review_requested ?program_case_record)
        (accreditation_marker_attached ?program_case_record ?accreditation_marker)
        (program_attached_artifact ?program_case_record ?evidence_artifact)
        (artifact_linked_to_plan ?evidence_artifact ?recovery_plan_document)
        (plan_includes_student_contingency ?recovery_plan_document)
        (plan_includes_supervisor_contingency ?recovery_plan_document)
        (not
          (external_review_completed ?program_case_record)
        )
      )
    :effect
      (and
        (external_review_completed ?program_case_record)
        (endorsements_collected ?program_case_record)
      )
  )
  (:action certify_program_ready_for_administrative_closure
    :parameters (?program_case_record - program_case_record)
    :precondition
      (and
        (external_review_completed ?program_case_record)
        (not
          (endorsements_collected ?program_case_record)
        )
        (not
          (program_ready_for_administrative_closure ?program_case_record)
        )
      )
    :effect
      (and
        (program_ready_for_administrative_closure ?program_case_record)
        (ready_for_recovery_actions ?program_case_record)
      )
  )
  (:action attach_administrative_form_to_program
    :parameters (?program_case_record - program_case_record ?administrative_form - administrative_form)
    :precondition
      (and
        (external_review_completed ?program_case_record)
        (endorsements_collected ?program_case_record)
        (administrative_form_available ?administrative_form)
      )
    :effect
      (and
        (administrative_form_attached ?program_case_record ?administrative_form)
        (not
          (administrative_form_available ?administrative_form)
        )
      )
  )
  (:action perform_final_verification
    :parameters (?program_case_record - program_case_record ?student_case_record - student_case_record ?supervisor_case_record - supervisor_case_record ?faculty_evaluator - faculty_evaluator ?administrative_form - administrative_form)
    :precondition
      (and
        (external_review_completed ?program_case_record)
        (endorsements_collected ?program_case_record)
        (administrative_form_attached ?program_case_record ?administrative_form)
        (program_links_student_record ?program_case_record ?student_case_record)
        (program_links_supervisor_record ?program_case_record ?supervisor_case_record)
        (student_preconditions_met ?student_case_record)
        (supervisor_preconditions_met ?supervisor_case_record)
        (faculty_evaluator_assigned_to_case ?program_case_record ?faculty_evaluator)
        (not
          (final_verification_passed ?program_case_record)
        )
      )
    :effect (final_verification_passed ?program_case_record)
  )
  (:action finalize_program_for_administrative_closure
    :parameters (?program_case_record - program_case_record)
    :precondition
      (and
        (external_review_completed ?program_case_record)
        (final_verification_passed ?program_case_record)
        (not
          (program_ready_for_administrative_closure ?program_case_record)
        )
      )
    :effect
      (and
        (program_ready_for_administrative_closure ?program_case_record)
        (ready_for_recovery_actions ?program_case_record)
      )
  )
  (:action flag_special_adjudication_required
    :parameters (?program_case_record - program_case_record ?endorsement_token - endorsement_token ?faculty_evaluator - faculty_evaluator)
    :precondition
      (and
        (triage_complete ?program_case_record)
        (faculty_evaluator_assigned_to_case ?program_case_record ?faculty_evaluator)
        (endorsement_available ?endorsement_token)
        (program_has_endorsement ?program_case_record ?endorsement_token)
        (not
          (special_adjudication_flag ?program_case_record)
        )
      )
    :effect
      (and
        (special_adjudication_flag ?program_case_record)
        (not
          (endorsement_available ?endorsement_token)
        )
      )
  )
  (:action complete_adjudication_stage_one
    :parameters (?program_case_record - program_case_record ?review_panel - review_panel)
    :precondition
      (and
        (special_adjudication_flag ?program_case_record)
        (panel_assigned_to_case ?program_case_record ?review_panel)
        (not
          (adjudication_stage_one_complete ?program_case_record)
        )
      )
    :effect (adjudication_stage_one_complete ?program_case_record)
  )
  (:action complete_adjudication_stage_two
    :parameters (?program_case_record - program_case_record ?accreditation_marker - accreditation_marker)
    :precondition
      (and
        (adjudication_stage_one_complete ?program_case_record)
        (accreditation_marker_attached ?program_case_record ?accreditation_marker)
        (not
          (adjudication_stage_two_complete ?program_case_record)
        )
      )
    :effect (adjudication_stage_two_complete ?program_case_record)
  )
  (:action finalize_special_adjudication
    :parameters (?program_case_record - program_case_record)
    :precondition
      (and
        (adjudication_stage_two_complete ?program_case_record)
        (not
          (program_ready_for_administrative_closure ?program_case_record)
        )
      )
    :effect
      (and
        (program_ready_for_administrative_closure ?program_case_record)
        (ready_for_recovery_actions ?program_case_record)
      )
  )
  (:action close_student_case_record
    :parameters (?student_case_record - student_case_record ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (student_ready_for_closure ?student_case_record)
        (student_preconditions_met ?student_case_record)
        (plan_populated ?recovery_plan_document)
        (plan_activated ?recovery_plan_document)
        (not
          (ready_for_recovery_actions ?student_case_record)
        )
      )
    :effect (ready_for_recovery_actions ?student_case_record)
  )
  (:action close_supervisor_case_record
    :parameters (?supervisor_case_record - supervisor_case_record ?recovery_plan_document - recovery_plan_document)
    :precondition
      (and
        (supervisor_ready_for_closure ?supervisor_case_record)
        (supervisor_preconditions_met ?supervisor_case_record)
        (plan_populated ?recovery_plan_document)
        (plan_activated ?recovery_plan_document)
        (not
          (ready_for_recovery_actions ?supervisor_case_record)
        )
      )
    :effect (ready_for_recovery_actions ?supervisor_case_record)
  )
  (:action require_recovery_plan_and_link_official_record
    :parameters (?capstone_case - capstone_case ?official_record_document - official_record_document ?faculty_evaluator - faculty_evaluator)
    :precondition
      (and
        (ready_for_recovery_actions ?capstone_case)
        (faculty_evaluator_assigned_to_case ?capstone_case ?faculty_evaluator)
        (official_record_document_available ?official_record_document)
        (not
          (recovery_plan_needed_flag ?capstone_case)
        )
      )
    :effect
      (and
        (recovery_plan_needed_flag ?capstone_case)
        (official_record_linked ?capstone_case ?official_record_document)
        (not
          (official_record_document_available ?official_record_document)
        )
      )
  )
  (:action apply_administrative_correction_to_student_record
    :parameters (?student_case_record - student_case_record ?institutional_resource - institutional_resource ?official_record_document - official_record_document)
    :precondition
      (and
        (recovery_plan_needed_flag ?student_case_record)
        (resource_allocated_to_case ?student_case_record ?institutional_resource)
        (official_record_linked ?student_case_record ?official_record_document)
        (not
          (case_closed_recorded ?student_case_record)
        )
      )
    :effect
      (and
        (case_closed_recorded ?student_case_record)
        (resource_available ?institutional_resource)
        (official_record_document_available ?official_record_document)
      )
  )
  (:action apply_administrative_correction_to_supervisor_record
    :parameters (?supervisor_case_record - supervisor_case_record ?institutional_resource - institutional_resource ?official_record_document - official_record_document)
    :precondition
      (and
        (recovery_plan_needed_flag ?supervisor_case_record)
        (resource_allocated_to_case ?supervisor_case_record ?institutional_resource)
        (official_record_linked ?supervisor_case_record ?official_record_document)
        (not
          (case_closed_recorded ?supervisor_case_record)
        )
      )
    :effect
      (and
        (case_closed_recorded ?supervisor_case_record)
        (resource_available ?institutional_resource)
        (official_record_document_available ?official_record_document)
      )
  )
  (:action apply_administrative_correction_to_program_record
    :parameters (?program_case_record - program_case_record ?institutional_resource - institutional_resource ?official_record_document - official_record_document)
    :precondition
      (and
        (recovery_plan_needed_flag ?program_case_record)
        (resource_allocated_to_case ?program_case_record ?institutional_resource)
        (official_record_linked ?program_case_record ?official_record_document)
        (not
          (case_closed_recorded ?program_case_record)
        )
      )
    :effect
      (and
        (case_closed_recorded ?program_case_record)
        (resource_available ?institutional_resource)
        (official_record_document_available ?official_record_document)
      )
  )
)

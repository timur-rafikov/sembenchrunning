(define (domain adverse_event_investigation_routing_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types adverse_event_case - object investigator - object review_panel - object clinical_department - object clinical_specialty - object technical_service - object evidence_kit - object notification_channel - object report_template - object collection_technician - object secure_bucket - object external_agency - object oversight_entity - object quality_committee - oversight_entity safety_committee - oversight_entity local_case_record - adverse_event_case incoming_report_case - adverse_event_case)
  (:predicates
    (case_active ?adverse_event_case - adverse_event_case)
    (case_assigned_to_investigator ?adverse_event_case - adverse_event_case ?investigator - investigator)
    (case_assigned ?adverse_event_case - adverse_event_case)
    (case_collection_ready ?adverse_event_case - adverse_event_case)
    (case_collection_completed ?adverse_event_case - adverse_event_case)
    (case_specialty ?adverse_event_case - adverse_event_case ?clinical_specialty - clinical_specialty)
    (case_department ?adverse_event_case - adverse_event_case ?clinical_department - clinical_department)
    (case_technical_service ?adverse_event_case - adverse_event_case ?technical_service - technical_service)
    (case_external_agency ?adverse_event_case - adverse_event_case ?external_agency - external_agency)
    (case_review_panel_assigned ?adverse_event_case - adverse_event_case ?review_panel - review_panel)
    (case_panel_review_completed ?adverse_event_case - adverse_event_case)
    (case_authorization_granted ?adverse_event_case - adverse_event_case)
    (case_collection_documented ?adverse_event_case - adverse_event_case)
    (case_closed ?adverse_event_case - adverse_event_case)
    (case_remediation_pending ?adverse_event_case - adverse_event_case)
    (case_remediation_approved ?adverse_event_case - adverse_event_case)
    (case_report_template_link ?adverse_event_case - adverse_event_case ?report_template - report_template)
    (case_report_authorized ?adverse_event_case - adverse_event_case ?report_template - report_template)
    (case_evidence_submission_logged ?adverse_event_case - adverse_event_case)
    (investigator_available ?investigator - investigator)
    (panel_available ?review_panel - review_panel)
    (specialty_available ?clinical_specialty - clinical_specialty)
    (department_available ?clinical_department - clinical_department)
    (technical_service_available ?technical_service - technical_service)
    (evidence_kit_available ?evidence_kit - evidence_kit)
    (notification_channel_available ?notification_channel - notification_channel)
    (report_template_available ?report_template - report_template)
    (technician_available ?collection_technician - collection_technician)
    (secure_bucket_available ?secure_document_bucket - secure_bucket)
    (external_agency_available ?external_agency - external_agency)
    (investigator_eligible_for_case ?adverse_event_case - adverse_event_case ?investigator - investigator)
    (panel_eligible_for_case ?adverse_event_case - adverse_event_case ?review_panel - review_panel)
    (specialty_eligible_for_case ?adverse_event_case - adverse_event_case ?clinical_specialty - clinical_specialty)
    (department_eligible_for_case ?adverse_event_case - adverse_event_case ?clinical_department - clinical_department)
    (technical_service_eligible_for_case ?adverse_event_case - adverse_event_case ?technical_service - technical_service)
    (secure_bucket_eligible_for_case ?adverse_event_case - adverse_event_case ?secure_document_bucket - secure_bucket)
    (external_agency_eligible_for_case ?adverse_event_case - adverse_event_case ?external_agency - external_agency)
    (case_oversight_entity ?adverse_event_case - adverse_event_case ?oversight_entity - oversight_entity)
    (case_template_assignment ?adverse_event_case - adverse_event_case ?report_template - report_template)
    (local_case_record_flag ?adverse_event_case - adverse_event_case)
    (incoming_report_case_flag ?adverse_event_case - adverse_event_case)
    (case_evidence_kit_allocated ?adverse_event_case - adverse_event_case ?evidence_kit - evidence_kit)
    (case_requires_followup_review ?adverse_event_case - adverse_event_case)
    (case_template_compatibility ?adverse_event_case - adverse_event_case ?report_template - report_template)
  )
  (:action intake_activate_case
    :parameters (?adverse_event_case - adverse_event_case)
    :precondition
      (and
        (not
          (case_active ?adverse_event_case)
        )
        (not
          (case_closed ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_active ?adverse_event_case)
      )
  )
  (:action assign_investigator
    :parameters (?adverse_event_case - adverse_event_case ?investigator - investigator)
    :precondition
      (and
        (case_active ?adverse_event_case)
        (investigator_available ?investigator)
        (investigator_eligible_for_case ?adverse_event_case ?investigator)
        (not
          (case_assigned ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_assigned_to_investigator ?adverse_event_case ?investigator)
        (case_assigned ?adverse_event_case)
        (not
          (investigator_available ?investigator)
        )
      )
  )
  (:action release_investigator
    :parameters (?adverse_event_case - adverse_event_case ?investigator - investigator)
    :precondition
      (and
        (case_assigned_to_investigator ?adverse_event_case ?investigator)
        (not
          (case_panel_review_completed ?adverse_event_case)
        )
        (not
          (case_authorization_granted ?adverse_event_case)
        )
      )
    :effect
      (and
        (not
          (case_assigned_to_investigator ?adverse_event_case ?investigator)
        )
        (not
          (case_assigned ?adverse_event_case)
        )
        (not
          (case_collection_ready ?adverse_event_case)
        )
        (not
          (case_collection_completed ?adverse_event_case)
        )
        (not
          (case_remediation_pending ?adverse_event_case)
        )
        (not
          (case_remediation_approved ?adverse_event_case)
        )
        (not
          (case_requires_followup_review ?adverse_event_case)
        )
        (investigator_available ?investigator)
      )
  )
  (:action reserve_evidence_kit
    :parameters (?adverse_event_case - adverse_event_case ?evidence_kit - evidence_kit)
    :precondition
      (and
        (case_active ?adverse_event_case)
        (evidence_kit_available ?evidence_kit)
      )
    :effect
      (and
        (case_evidence_kit_allocated ?adverse_event_case ?evidence_kit)
        (not
          (evidence_kit_available ?evidence_kit)
        )
      )
  )
  (:action release_evidence_kit
    :parameters (?adverse_event_case - adverse_event_case ?evidence_kit - evidence_kit)
    :precondition
      (and
        (case_evidence_kit_allocated ?adverse_event_case ?evidence_kit)
      )
    :effect
      (and
        (evidence_kit_available ?evidence_kit)
        (not
          (case_evidence_kit_allocated ?adverse_event_case ?evidence_kit)
        )
      )
  )
  (:action authorize_collection
    :parameters (?adverse_event_case - adverse_event_case ?evidence_kit - evidence_kit)
    :precondition
      (and
        (case_active ?adverse_event_case)
        (case_assigned ?adverse_event_case)
        (case_evidence_kit_allocated ?adverse_event_case ?evidence_kit)
        (not
          (case_collection_ready ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_collection_ready ?adverse_event_case)
      )
  )
  (:action trigger_notification_channel
    :parameters (?adverse_event_case - adverse_event_case ?notification_channel - notification_channel)
    :precondition
      (and
        (case_active ?adverse_event_case)
        (case_assigned ?adverse_event_case)
        (notification_channel_available ?notification_channel)
        (not
          (case_collection_ready ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_collection_ready ?adverse_event_case)
        (case_remediation_pending ?adverse_event_case)
        (not
          (notification_channel_available ?notification_channel)
        )
      )
  )
  (:action technician_collect_evidence
    :parameters (?adverse_event_case - adverse_event_case ?evidence_kit - evidence_kit ?collection_technician - collection_technician)
    :precondition
      (and
        (case_collection_ready ?adverse_event_case)
        (case_assigned ?adverse_event_case)
        (case_evidence_kit_allocated ?adverse_event_case ?evidence_kit)
        (technician_available ?collection_technician)
        (not
          (case_collection_completed ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_collection_completed ?adverse_event_case)
        (not
          (case_remediation_pending ?adverse_event_case)
        )
      )
  )
  (:action authorize_report_via_template
    :parameters (?adverse_event_case - adverse_event_case ?report_template - report_template)
    :precondition
      (and
        (case_assigned ?adverse_event_case)
        (case_report_authorized ?adverse_event_case ?report_template)
        (not
          (case_collection_completed ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_collection_completed ?adverse_event_case)
        (not
          (case_remediation_pending ?adverse_event_case)
        )
      )
  )
  (:action assign_specialty
    :parameters (?adverse_event_case - adverse_event_case ?clinical_specialty - clinical_specialty)
    :precondition
      (and
        (case_active ?adverse_event_case)
        (specialty_available ?clinical_specialty)
        (specialty_eligible_for_case ?adverse_event_case ?clinical_specialty)
      )
    :effect
      (and
        (case_specialty ?adverse_event_case ?clinical_specialty)
        (not
          (specialty_available ?clinical_specialty)
        )
      )
  )
  (:action release_specialty
    :parameters (?adverse_event_case - adverse_event_case ?clinical_specialty - clinical_specialty)
    :precondition
      (and
        (case_specialty ?adverse_event_case ?clinical_specialty)
      )
    :effect
      (and
        (specialty_available ?clinical_specialty)
        (not
          (case_specialty ?adverse_event_case ?clinical_specialty)
        )
      )
  )
  (:action assign_department
    :parameters (?adverse_event_case - adverse_event_case ?clinical_department - clinical_department)
    :precondition
      (and
        (case_active ?adverse_event_case)
        (department_available ?clinical_department)
        (department_eligible_for_case ?adverse_event_case ?clinical_department)
      )
    :effect
      (and
        (case_department ?adverse_event_case ?clinical_department)
        (not
          (department_available ?clinical_department)
        )
      )
  )
  (:action release_department
    :parameters (?adverse_event_case - adverse_event_case ?clinical_department - clinical_department)
    :precondition
      (and
        (case_department ?adverse_event_case ?clinical_department)
      )
    :effect
      (and
        (department_available ?clinical_department)
        (not
          (case_department ?adverse_event_case ?clinical_department)
        )
      )
  )
  (:action assign_technical_service
    :parameters (?adverse_event_case - adverse_event_case ?technical_service - technical_service)
    :precondition
      (and
        (case_active ?adverse_event_case)
        (technical_service_available ?technical_service)
        (technical_service_eligible_for_case ?adverse_event_case ?technical_service)
      )
    :effect
      (and
        (case_technical_service ?adverse_event_case ?technical_service)
        (not
          (technical_service_available ?technical_service)
        )
      )
  )
  (:action release_technical_service
    :parameters (?adverse_event_case - adverse_event_case ?technical_service - technical_service)
    :precondition
      (and
        (case_technical_service ?adverse_event_case ?technical_service)
      )
    :effect
      (and
        (technical_service_available ?technical_service)
        (not
          (case_technical_service ?adverse_event_case ?technical_service)
        )
      )
  )
  (:action assign_external_agency
    :parameters (?adverse_event_case - adverse_event_case ?external_agency - external_agency)
    :precondition
      (and
        (case_active ?adverse_event_case)
        (external_agency_available ?external_agency)
        (external_agency_eligible_for_case ?adverse_event_case ?external_agency)
      )
    :effect
      (and
        (case_external_agency ?adverse_event_case ?external_agency)
        (not
          (external_agency_available ?external_agency)
        )
      )
  )
  (:action release_external_agency
    :parameters (?adverse_event_case - adverse_event_case ?external_agency - external_agency)
    :precondition
      (and
        (case_external_agency ?adverse_event_case ?external_agency)
      )
    :effect
      (and
        (external_agency_available ?external_agency)
        (not
          (case_external_agency ?adverse_event_case ?external_agency)
        )
      )
  )
  (:action conduct_panel_review
    :parameters (?adverse_event_case - adverse_event_case ?review_panel - review_panel ?clinical_specialty - clinical_specialty ?clinical_department - clinical_department)
    :precondition
      (and
        (case_assigned ?adverse_event_case)
        (case_specialty ?adverse_event_case ?clinical_specialty)
        (case_department ?adverse_event_case ?clinical_department)
        (panel_available ?review_panel)
        (panel_eligible_for_case ?adverse_event_case ?review_panel)
        (not
          (case_panel_review_completed ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_review_panel_assigned ?adverse_event_case ?review_panel)
        (case_panel_review_completed ?adverse_event_case)
        (not
          (panel_available ?review_panel)
        )
      )
  )
  (:action conduct_technical_analysis
    :parameters (?adverse_event_case - adverse_event_case ?review_panel - review_panel ?technical_service - technical_service ?secure_document_bucket - secure_bucket)
    :precondition
      (and
        (case_assigned ?adverse_event_case)
        (case_technical_service ?adverse_event_case ?technical_service)
        (secure_bucket_available ?secure_document_bucket)
        (panel_available ?review_panel)
        (panel_eligible_for_case ?adverse_event_case ?review_panel)
        (secure_bucket_eligible_for_case ?adverse_event_case ?secure_document_bucket)
        (not
          (case_panel_review_completed ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_review_panel_assigned ?adverse_event_case ?review_panel)
        (case_panel_review_completed ?adverse_event_case)
        (case_requires_followup_review ?adverse_event_case)
        (case_remediation_pending ?adverse_event_case)
        (not
          (panel_available ?review_panel)
        )
        (not
          (secure_bucket_available ?secure_document_bucket)
        )
      )
  )
  (:action complete_multidisciplinary_review
    :parameters (?adverse_event_case - adverse_event_case ?clinical_specialty - clinical_specialty ?clinical_department - clinical_department)
    :precondition
      (and
        (case_panel_review_completed ?adverse_event_case)
        (case_requires_followup_review ?adverse_event_case)
        (case_specialty ?adverse_event_case ?clinical_specialty)
        (case_department ?adverse_event_case ?clinical_department)
      )
    :effect
      (and
        (not
          (case_requires_followup_review ?adverse_event_case)
        )
        (not
          (case_remediation_pending ?adverse_event_case)
        )
      )
  )
  (:action request_quality_committee_authorization
    :parameters (?adverse_event_case - adverse_event_case ?clinical_specialty - clinical_specialty ?clinical_department - clinical_department ?quality_committee - quality_committee)
    :precondition
      (and
        (case_collection_completed ?adverse_event_case)
        (case_panel_review_completed ?adverse_event_case)
        (case_specialty ?adverse_event_case ?clinical_specialty)
        (case_department ?adverse_event_case ?clinical_department)
        (case_oversight_entity ?adverse_event_case ?quality_committee)
        (not
          (case_remediation_pending ?adverse_event_case)
        )
        (not
          (case_authorization_granted ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_authorization_granted ?adverse_event_case)
      )
  )
  (:action request_safety_committee_authorization
    :parameters (?adverse_event_case - adverse_event_case ?technical_service - technical_service ?external_agency - external_agency ?safety_committee - safety_committee)
    :precondition
      (and
        (case_collection_completed ?adverse_event_case)
        (case_panel_review_completed ?adverse_event_case)
        (case_technical_service ?adverse_event_case ?technical_service)
        (case_external_agency ?adverse_event_case ?external_agency)
        (case_oversight_entity ?adverse_event_case ?safety_committee)
        (not
          (case_authorization_granted ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_authorization_granted ?adverse_event_case)
        (case_remediation_pending ?adverse_event_case)
      )
  )
  (:action implement_remediation
    :parameters (?adverse_event_case - adverse_event_case ?clinical_specialty - clinical_specialty ?clinical_department - clinical_department)
    :precondition
      (and
        (case_authorization_granted ?adverse_event_case)
        (case_remediation_pending ?adverse_event_case)
        (case_specialty ?adverse_event_case ?clinical_specialty)
        (case_department ?adverse_event_case ?clinical_department)
      )
    :effect
      (and
        (case_remediation_approved ?adverse_event_case)
        (not
          (case_remediation_pending ?adverse_event_case)
        )
        (not
          (case_collection_completed ?adverse_event_case)
        )
        (not
          (case_requires_followup_review ?adverse_event_case)
        )
      )
  )
  (:action reopen_collection_and_collect
    :parameters (?adverse_event_case - adverse_event_case ?evidence_kit - evidence_kit ?collection_technician - collection_technician)
    :precondition
      (and
        (case_remediation_approved ?adverse_event_case)
        (case_authorization_granted ?adverse_event_case)
        (case_assigned ?adverse_event_case)
        (case_evidence_kit_allocated ?adverse_event_case ?evidence_kit)
        (technician_available ?collection_technician)
        (not
          (case_collection_completed ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_collection_completed ?adverse_event_case)
      )
  )
  (:action document_collection
    :parameters (?adverse_event_case - adverse_event_case ?evidence_kit - evidence_kit)
    :precondition
      (and
        (case_authorization_granted ?adverse_event_case)
        (case_collection_completed ?adverse_event_case)
        (not
          (case_remediation_pending ?adverse_event_case)
        )
        (case_evidence_kit_allocated ?adverse_event_case ?evidence_kit)
        (not
          (case_collection_documented ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_collection_documented ?adverse_event_case)
      )
  )
  (:action document_collection_via_channel
    :parameters (?adverse_event_case - adverse_event_case ?notification_channel - notification_channel)
    :precondition
      (and
        (case_authorization_granted ?adverse_event_case)
        (case_collection_completed ?adverse_event_case)
        (not
          (case_remediation_pending ?adverse_event_case)
        )
        (notification_channel_available ?notification_channel)
        (not
          (case_collection_documented ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_collection_documented ?adverse_event_case)
        (not
          (notification_channel_available ?notification_channel)
        )
      )
  )
  (:action assign_report_template_to_case
    :parameters (?adverse_event_case - adverse_event_case ?report_template - report_template)
    :precondition
      (and
        (case_collection_documented ?adverse_event_case)
        (report_template_available ?report_template)
        (case_template_compatibility ?adverse_event_case ?report_template)
      )
    :effect
      (and
        (case_template_assignment ?adverse_event_case ?report_template)
        (not
          (report_template_available ?report_template)
        )
      )
  )
  (:action authorize_local_record_report
    :parameters (?incoming_report_source - incoming_report_case ?local_case_record - local_case_record ?report_template - report_template)
    :precondition
      (and
        (case_active ?incoming_report_source)
        (incoming_report_case_flag ?incoming_report_source)
        (case_report_template_link ?incoming_report_source ?report_template)
        (case_template_assignment ?local_case_record ?report_template)
        (not
          (case_report_authorized ?incoming_report_source ?report_template)
        )
      )
    :effect
      (and
        (case_report_authorized ?incoming_report_source ?report_template)
      )
  )
  (:action log_evidence_submission
    :parameters (?adverse_event_case - adverse_event_case ?evidence_kit - evidence_kit ?collection_technician - collection_technician)
    :precondition
      (and
        (case_active ?adverse_event_case)
        (incoming_report_case_flag ?adverse_event_case)
        (case_collection_completed ?adverse_event_case)
        (case_collection_documented ?adverse_event_case)
        (case_evidence_kit_allocated ?adverse_event_case ?evidence_kit)
        (technician_available ?collection_technician)
        (not
          (case_evidence_submission_logged ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_evidence_submission_logged ?adverse_event_case)
      )
  )
  (:action finalize_internal_report
    :parameters (?adverse_event_case - adverse_event_case)
    :precondition
      (and
        (local_case_record_flag ?adverse_event_case)
        (case_active ?adverse_event_case)
        (case_assigned ?adverse_event_case)
        (case_panel_review_completed ?adverse_event_case)
        (case_authorization_granted ?adverse_event_case)
        (case_collection_documented ?adverse_event_case)
        (case_collection_completed ?adverse_event_case)
        (not
          (case_closed ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_closed ?adverse_event_case)
      )
  )
  (:action finalize_external_report_with_template
    :parameters (?adverse_event_case - adverse_event_case ?report_template - report_template)
    :precondition
      (and
        (incoming_report_case_flag ?adverse_event_case)
        (case_active ?adverse_event_case)
        (case_assigned ?adverse_event_case)
        (case_panel_review_completed ?adverse_event_case)
        (case_authorization_granted ?adverse_event_case)
        (case_collection_documented ?adverse_event_case)
        (case_collection_completed ?adverse_event_case)
        (case_report_authorized ?adverse_event_case ?report_template)
        (not
          (case_closed ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_closed ?adverse_event_case)
      )
  )
  (:action finalize_external_report_with_submission
    :parameters (?adverse_event_case - adverse_event_case)
    :precondition
      (and
        (incoming_report_case_flag ?adverse_event_case)
        (case_active ?adverse_event_case)
        (case_assigned ?adverse_event_case)
        (case_panel_review_completed ?adverse_event_case)
        (case_authorization_granted ?adverse_event_case)
        (case_collection_documented ?adverse_event_case)
        (case_collection_completed ?adverse_event_case)
        (case_evidence_submission_logged ?adverse_event_case)
        (not
          (case_closed ?adverse_event_case)
        )
      )
    :effect
      (and
        (case_closed ?adverse_event_case)
      )
  )
)

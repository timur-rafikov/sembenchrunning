(define (domain temperature_excursion_response)
  (:requirements :strips :typing :negative-preconditions)
  (:types generic_entity - object personnel_or_resource_category - generic_entity infrastructure_category - generic_entity document_category - generic_entity case_category - generic_entity excursion_case - case_category investigator_team - personnel_or_resource_category laboratory_resource - personnel_or_resource_category containment_resource - personnel_or_resource_category regulatory_notification_template - personnel_or_resource_category supplier_approval_document - personnel_or_resource_category communication_template - personnel_or_resource_category technical_expert - personnel_or_resource_category quality_consultant - personnel_or_resource_category mitigation_resource - infrastructure_category laboratory_report - infrastructure_category external_stakeholder - infrastructure_category source_storage_node - document_category destination_storage_node - document_category remediation_action - document_category shipment_subcase - excursion_case response_subcase - excursion_case batch_instance - shipment_subcase related_batch_instance - shipment_subcase response_ticket - response_subcase)

  (:predicates
    (excursion_case_detected ?excursion_case - excursion_case)
    (case_or_ticket_opened ?excursion_case - excursion_case)
    (investigation_assigned ?excursion_case - excursion_case)
    (cleared_for_distribution ?excursion_case - excursion_case)
    (entity_release_authorized ?excursion_case - excursion_case)
    (operations_handoff_completed ?excursion_case - excursion_case)
    (investigator_team_available ?investigator_team - investigator_team)
    (assigned_to_team ?excursion_case - excursion_case ?investigator_team - investigator_team)
    (laboratory_resource_available ?laboratory_resource - laboratory_resource)
    (assigned_to_lab ?excursion_case - excursion_case ?laboratory_resource - laboratory_resource)
    (containment_resource_available ?containment_resource - containment_resource)
    (assigned_to_containment ?excursion_case - excursion_case ?containment_resource - containment_resource)
    (mitigation_resource_available ?mitigation_resource - mitigation_resource)
    (batch_allocated_mitigation_resource ?batch_instance - batch_instance ?mitigation_resource - mitigation_resource)
    (related_batch_allocated_mitigation_resource ?related_batch_instance - related_batch_instance ?mitigation_resource - mitigation_resource)
    (batch_origin_node ?batch_instance - batch_instance ?source_storage_node - source_storage_node)
    (source_node_flagged ?source_storage_node - source_storage_node)
    (source_node_mitigation_allocated ?source_storage_node - source_storage_node)
    (batch_ready_for_remediation ?batch_instance - batch_instance)
    (related_batch_destination_node ?related_batch_instance - related_batch_instance ?destination_storage_node - destination_storage_node)
    (destination_node_flagged ?destination_storage_node - destination_storage_node)
    (destination_node_mitigation_allocated ?destination_storage_node - destination_storage_node)
    (related_batch_ready_for_remediation ?related_batch_instance - related_batch_instance)
    (remediation_action_available ?remediation_action - remediation_action)
    (remediation_action_selected ?remediation_action - remediation_action)
    (remediation_action_targets_source_node ?remediation_action - remediation_action ?source_storage_node - source_storage_node)
    (remediation_action_targets_destination_node ?remediation_action - remediation_action ?destination_storage_node - destination_storage_node)
    (remediation_requires_source_signoff ?remediation_action - remediation_action)
    (remediation_requires_destination_signoff ?remediation_action - remediation_action)
    (remediation_lab_validation_complete ?remediation_action - remediation_action)
    (ticket_associated_with_batch ?response_ticket - response_ticket ?batch_instance - batch_instance)
    (ticket_associated_with_related_batch ?response_ticket - response_ticket ?related_batch_instance - related_batch_instance)
    (ticket_includes_remediation_action ?response_ticket - response_ticket ?remediation_action - remediation_action)
    (laboratory_report_available ?laboratory_report - laboratory_report)
    (ticket_linked_lab_report ?response_ticket - response_ticket ?laboratory_report - laboratory_report)
    (laboratory_report_consumed ?laboratory_report - laboratory_report)
    (laboratory_report_linked_to_action ?laboratory_report - laboratory_report ?remediation_action - remediation_action)
    (ready_for_expert_review ?response_ticket - response_ticket)
    (expert_engaged ?response_ticket - response_ticket)
    (expert_review_completed ?response_ticket - response_ticket)
    (regulatory_template_assigned ?response_ticket - response_ticket)
    (regulatory_notification_prepared ?response_ticket - response_ticket)
    (expert_recommendation_documented ?response_ticket - response_ticket)
    (final_review_completed ?response_ticket - response_ticket)
    (external_stakeholder_available ?external_stakeholder - external_stakeholder)
    (ticket_linked_to_external_stakeholder ?response_ticket - response_ticket ?external_stakeholder - external_stakeholder)
    (external_stakeholder_assigned ?response_ticket - response_ticket)
    (external_stakeholder_engagement_ready ?response_ticket - response_ticket)
    (external_stakeholder_approval_received ?response_ticket - response_ticket)
    (regulatory_notification_template_available ?regulatory_notification_template - regulatory_notification_template)
    (ticket_assigned_regulatory_template ?response_ticket - response_ticket ?regulatory_notification_template - regulatory_notification_template)
    (supplier_approval_document_available ?supplier_approval_document - supplier_approval_document)
    (ticket_linked_supplier_approval ?response_ticket - response_ticket ?supplier_approval_document - supplier_approval_document)
    (technical_expert_available ?technical_expert - technical_expert)
    (ticket_assigned_technical_expert ?response_ticket - response_ticket ?technical_expert - technical_expert)
    (quality_consultant_available ?quality_consultant - quality_consultant)
    (ticket_assigned_quality_consultant ?response_ticket - response_ticket ?quality_consultant - quality_consultant)
    (communication_template_available ?communication_template - communication_template)
    (bound_communication_template ?excursion_case - excursion_case ?communication_template - communication_template)
    (batch_triaged ?batch_instance - batch_instance)
    (related_batch_triaged ?related_batch_instance - related_batch_instance)
    (ticket_release_flag ?response_ticket - response_ticket)
  )
  (:action detect_and_open_excursion_case
    :parameters (?excursion_case - excursion_case)
    :precondition
      (and
        (not
          (excursion_case_detected ?excursion_case)
        )
        (not
          (cleared_for_distribution ?excursion_case)
        )
      )
    :effect (excursion_case_detected ?excursion_case)
  )
  (:action assign_investigator_team_to_case
    :parameters (?excursion_case - excursion_case ?investigator_team - investigator_team)
    :precondition
      (and
        (excursion_case_detected ?excursion_case)
        (not
          (investigation_assigned ?excursion_case)
        )
        (investigator_team_available ?investigator_team)
      )
    :effect
      (and
        (investigation_assigned ?excursion_case)
        (assigned_to_team ?excursion_case ?investigator_team)
        (not
          (investigator_team_available ?investigator_team)
        )
      )
  )
  (:action assign_laboratory_to_case
    :parameters (?excursion_case - excursion_case ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (excursion_case_detected ?excursion_case)
        (investigation_assigned ?excursion_case)
        (laboratory_resource_available ?laboratory_resource)
      )
    :effect
      (and
        (assigned_to_lab ?excursion_case ?laboratory_resource)
        (not
          (laboratory_resource_available ?laboratory_resource)
        )
      )
  )
  (:action finalize_lab_intake_and_open_ticket
    :parameters (?excursion_case - excursion_case ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (excursion_case_detected ?excursion_case)
        (investigation_assigned ?excursion_case)
        (assigned_to_lab ?excursion_case ?laboratory_resource)
        (not
          (case_or_ticket_opened ?excursion_case)
        )
      )
    :effect (case_or_ticket_opened ?excursion_case)
  )
  (:action release_laboratory_resource
    :parameters (?excursion_case - excursion_case ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (assigned_to_lab ?excursion_case ?laboratory_resource)
      )
    :effect
      (and
        (laboratory_resource_available ?laboratory_resource)
        (not
          (assigned_to_lab ?excursion_case ?laboratory_resource)
        )
      )
  )
  (:action assign_containment_resource_to_case
    :parameters (?excursion_case - excursion_case ?containment_resource - containment_resource)
    :precondition
      (and
        (case_or_ticket_opened ?excursion_case)
        (containment_resource_available ?containment_resource)
      )
    :effect
      (and
        (assigned_to_containment ?excursion_case ?containment_resource)
        (not
          (containment_resource_available ?containment_resource)
        )
      )
  )
  (:action release_containment_resource_from_case
    :parameters (?excursion_case - excursion_case ?containment_resource - containment_resource)
    :precondition
      (and
        (assigned_to_containment ?excursion_case ?containment_resource)
      )
    :effect
      (and
        (containment_resource_available ?containment_resource)
        (not
          (assigned_to_containment ?excursion_case ?containment_resource)
        )
      )
  )
  (:action assign_technical_expert_to_ticket
    :parameters (?response_ticket - response_ticket ?technical_expert - technical_expert)
    :precondition
      (and
        (case_or_ticket_opened ?response_ticket)
        (technical_expert_available ?technical_expert)
      )
    :effect
      (and
        (ticket_assigned_technical_expert ?response_ticket ?technical_expert)
        (not
          (technical_expert_available ?technical_expert)
        )
      )
  )
  (:action unassign_technical_expert_from_ticket
    :parameters (?response_ticket - response_ticket ?technical_expert - technical_expert)
    :precondition
      (and
        (ticket_assigned_technical_expert ?response_ticket ?technical_expert)
      )
    :effect
      (and
        (technical_expert_available ?technical_expert)
        (not
          (ticket_assigned_technical_expert ?response_ticket ?technical_expert)
        )
      )
  )
  (:action assign_quality_consultant_to_ticket
    :parameters (?response_ticket - response_ticket ?quality_consultant - quality_consultant)
    :precondition
      (and
        (case_or_ticket_opened ?response_ticket)
        (quality_consultant_available ?quality_consultant)
      )
    :effect
      (and
        (ticket_assigned_quality_consultant ?response_ticket ?quality_consultant)
        (not
          (quality_consultant_available ?quality_consultant)
        )
      )
  )
  (:action unassign_quality_consultant_from_ticket
    :parameters (?response_ticket - response_ticket ?quality_consultant - quality_consultant)
    :precondition
      (and
        (ticket_assigned_quality_consultant ?response_ticket ?quality_consultant)
      )
    :effect
      (and
        (quality_consultant_available ?quality_consultant)
        (not
          (ticket_assigned_quality_consultant ?response_ticket ?quality_consultant)
        )
      )
  )
  (:action flag_source_node_for_sampling
    :parameters (?batch_instance - batch_instance ?source_storage_node - source_storage_node ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (case_or_ticket_opened ?batch_instance)
        (assigned_to_lab ?batch_instance ?laboratory_resource)
        (batch_origin_node ?batch_instance ?source_storage_node)
        (not
          (source_node_flagged ?source_storage_node)
        )
        (not
          (source_node_mitigation_allocated ?source_storage_node)
        )
      )
    :effect (source_node_flagged ?source_storage_node)
  )
  (:action quarantine_batch_and_mark_for_remediation
    :parameters (?batch_instance - batch_instance ?source_storage_node - source_storage_node ?containment_resource - containment_resource)
    :precondition
      (and
        (case_or_ticket_opened ?batch_instance)
        (assigned_to_containment ?batch_instance ?containment_resource)
        (batch_origin_node ?batch_instance ?source_storage_node)
        (source_node_flagged ?source_storage_node)
        (not
          (batch_triaged ?batch_instance)
        )
      )
    :effect
      (and
        (batch_triaged ?batch_instance)
        (batch_ready_for_remediation ?batch_instance)
      )
  )
  (:action allocate_mitigation_resource_to_batch
    :parameters (?batch_instance - batch_instance ?source_storage_node - source_storage_node ?mitigation_resource - mitigation_resource)
    :precondition
      (and
        (case_or_ticket_opened ?batch_instance)
        (batch_origin_node ?batch_instance ?source_storage_node)
        (mitigation_resource_available ?mitigation_resource)
        (not
          (batch_triaged ?batch_instance)
        )
      )
    :effect
      (and
        (source_node_mitigation_allocated ?source_storage_node)
        (batch_triaged ?batch_instance)
        (batch_allocated_mitigation_resource ?batch_instance ?mitigation_resource)
        (not
          (mitigation_resource_available ?mitigation_resource)
        )
      )
  )
  (:action process_lab_result_and_update_batch
    :parameters (?batch_instance - batch_instance ?source_storage_node - source_storage_node ?laboratory_resource - laboratory_resource ?mitigation_resource - mitigation_resource)
    :precondition
      (and
        (case_or_ticket_opened ?batch_instance)
        (assigned_to_lab ?batch_instance ?laboratory_resource)
        (batch_origin_node ?batch_instance ?source_storage_node)
        (source_node_mitigation_allocated ?source_storage_node)
        (batch_allocated_mitigation_resource ?batch_instance ?mitigation_resource)
        (not
          (batch_ready_for_remediation ?batch_instance)
        )
      )
    :effect
      (and
        (source_node_flagged ?source_storage_node)
        (batch_ready_for_remediation ?batch_instance)
        (mitigation_resource_available ?mitigation_resource)
        (not
          (batch_allocated_mitigation_resource ?batch_instance ?mitigation_resource)
        )
      )
  )
  (:action flag_destination_node_for_sampling
    :parameters (?related_batch_instance - related_batch_instance ?destination_storage_node - destination_storage_node ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (case_or_ticket_opened ?related_batch_instance)
        (assigned_to_lab ?related_batch_instance ?laboratory_resource)
        (related_batch_destination_node ?related_batch_instance ?destination_storage_node)
        (not
          (destination_node_flagged ?destination_storage_node)
        )
        (not
          (destination_node_mitigation_allocated ?destination_storage_node)
        )
      )
    :effect (destination_node_flagged ?destination_storage_node)
  )
  (:action quarantine_related_batch_and_mark_for_remediation
    :parameters (?related_batch_instance - related_batch_instance ?destination_storage_node - destination_storage_node ?containment_resource - containment_resource)
    :precondition
      (and
        (case_or_ticket_opened ?related_batch_instance)
        (assigned_to_containment ?related_batch_instance ?containment_resource)
        (related_batch_destination_node ?related_batch_instance ?destination_storage_node)
        (destination_node_flagged ?destination_storage_node)
        (not
          (related_batch_triaged ?related_batch_instance)
        )
      )
    :effect
      (and
        (related_batch_triaged ?related_batch_instance)
        (related_batch_ready_for_remediation ?related_batch_instance)
      )
  )
  (:action allocate_mitigation_resource_to_related_batch
    :parameters (?related_batch_instance - related_batch_instance ?destination_storage_node - destination_storage_node ?mitigation_resource - mitigation_resource)
    :precondition
      (and
        (case_or_ticket_opened ?related_batch_instance)
        (related_batch_destination_node ?related_batch_instance ?destination_storage_node)
        (mitigation_resource_available ?mitigation_resource)
        (not
          (related_batch_triaged ?related_batch_instance)
        )
      )
    :effect
      (and
        (destination_node_mitigation_allocated ?destination_storage_node)
        (related_batch_triaged ?related_batch_instance)
        (related_batch_allocated_mitigation_resource ?related_batch_instance ?mitigation_resource)
        (not
          (mitigation_resource_available ?mitigation_resource)
        )
      )
  )
  (:action process_lab_result_for_related_batch
    :parameters (?related_batch_instance - related_batch_instance ?destination_storage_node - destination_storage_node ?laboratory_resource - laboratory_resource ?mitigation_resource - mitigation_resource)
    :precondition
      (and
        (case_or_ticket_opened ?related_batch_instance)
        (assigned_to_lab ?related_batch_instance ?laboratory_resource)
        (related_batch_destination_node ?related_batch_instance ?destination_storage_node)
        (destination_node_mitigation_allocated ?destination_storage_node)
        (related_batch_allocated_mitigation_resource ?related_batch_instance ?mitigation_resource)
        (not
          (related_batch_ready_for_remediation ?related_batch_instance)
        )
      )
    :effect
      (and
        (destination_node_flagged ?destination_storage_node)
        (related_batch_ready_for_remediation ?related_batch_instance)
        (mitigation_resource_available ?mitigation_resource)
        (not
          (related_batch_allocated_mitigation_resource ?related_batch_instance ?mitigation_resource)
        )
      )
  )
  (:action select_remediation_action_standard
    :parameters (?batch_instance - batch_instance ?related_batch_instance - related_batch_instance ?source_storage_node - source_storage_node ?destination_storage_node - destination_storage_node ?remediation_action - remediation_action)
    :precondition
      (and
        (batch_triaged ?batch_instance)
        (related_batch_triaged ?related_batch_instance)
        (batch_origin_node ?batch_instance ?source_storage_node)
        (related_batch_destination_node ?related_batch_instance ?destination_storage_node)
        (source_node_flagged ?source_storage_node)
        (destination_node_flagged ?destination_storage_node)
        (batch_ready_for_remediation ?batch_instance)
        (related_batch_ready_for_remediation ?related_batch_instance)
        (remediation_action_available ?remediation_action)
      )
    :effect
      (and
        (remediation_action_selected ?remediation_action)
        (remediation_action_targets_source_node ?remediation_action ?source_storage_node)
        (remediation_action_targets_destination_node ?remediation_action ?destination_storage_node)
        (not
          (remediation_action_available ?remediation_action)
        )
      )
  )
  (:action select_remediation_action_with_source_signoff
    :parameters (?batch_instance - batch_instance ?related_batch_instance - related_batch_instance ?source_storage_node - source_storage_node ?destination_storage_node - destination_storage_node ?remediation_action - remediation_action)
    :precondition
      (and
        (batch_triaged ?batch_instance)
        (related_batch_triaged ?related_batch_instance)
        (batch_origin_node ?batch_instance ?source_storage_node)
        (related_batch_destination_node ?related_batch_instance ?destination_storage_node)
        (source_node_mitigation_allocated ?source_storage_node)
        (destination_node_flagged ?destination_storage_node)
        (not
          (batch_ready_for_remediation ?batch_instance)
        )
        (related_batch_ready_for_remediation ?related_batch_instance)
        (remediation_action_available ?remediation_action)
      )
    :effect
      (and
        (remediation_action_selected ?remediation_action)
        (remediation_action_targets_source_node ?remediation_action ?source_storage_node)
        (remediation_action_targets_destination_node ?remediation_action ?destination_storage_node)
        (remediation_requires_source_signoff ?remediation_action)
        (not
          (remediation_action_available ?remediation_action)
        )
      )
  )
  (:action select_remediation_action_with_destination_signoff
    :parameters (?batch_instance - batch_instance ?related_batch_instance - related_batch_instance ?source_storage_node - source_storage_node ?destination_storage_node - destination_storage_node ?remediation_action - remediation_action)
    :precondition
      (and
        (batch_triaged ?batch_instance)
        (related_batch_triaged ?related_batch_instance)
        (batch_origin_node ?batch_instance ?source_storage_node)
        (related_batch_destination_node ?related_batch_instance ?destination_storage_node)
        (source_node_flagged ?source_storage_node)
        (destination_node_mitigation_allocated ?destination_storage_node)
        (batch_ready_for_remediation ?batch_instance)
        (not
          (related_batch_ready_for_remediation ?related_batch_instance)
        )
        (remediation_action_available ?remediation_action)
      )
    :effect
      (and
        (remediation_action_selected ?remediation_action)
        (remediation_action_targets_source_node ?remediation_action ?source_storage_node)
        (remediation_action_targets_destination_node ?remediation_action ?destination_storage_node)
        (remediation_requires_destination_signoff ?remediation_action)
        (not
          (remediation_action_available ?remediation_action)
        )
      )
  )
  (:action select_remediation_action_with_both_signoff
    :parameters (?batch_instance - batch_instance ?related_batch_instance - related_batch_instance ?source_storage_node - source_storage_node ?destination_storage_node - destination_storage_node ?remediation_action - remediation_action)
    :precondition
      (and
        (batch_triaged ?batch_instance)
        (related_batch_triaged ?related_batch_instance)
        (batch_origin_node ?batch_instance ?source_storage_node)
        (related_batch_destination_node ?related_batch_instance ?destination_storage_node)
        (source_node_mitigation_allocated ?source_storage_node)
        (destination_node_mitigation_allocated ?destination_storage_node)
        (not
          (batch_ready_for_remediation ?batch_instance)
        )
        (not
          (related_batch_ready_for_remediation ?related_batch_instance)
        )
        (remediation_action_available ?remediation_action)
      )
    :effect
      (and
        (remediation_action_selected ?remediation_action)
        (remediation_action_targets_source_node ?remediation_action ?source_storage_node)
        (remediation_action_targets_destination_node ?remediation_action ?destination_storage_node)
        (remediation_requires_source_signoff ?remediation_action)
        (remediation_requires_destination_signoff ?remediation_action)
        (not
          (remediation_action_available ?remediation_action)
        )
      )
  )
  (:action validate_remediation_action_via_lab
    :parameters (?remediation_action - remediation_action ?batch_instance - batch_instance ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (remediation_action_selected ?remediation_action)
        (batch_triaged ?batch_instance)
        (assigned_to_lab ?batch_instance ?laboratory_resource)
        (not
          (remediation_lab_validation_complete ?remediation_action)
        )
      )
    :effect (remediation_lab_validation_complete ?remediation_action)
  )
  (:action ingest_lab_report_and_link_to_action
    :parameters (?response_ticket - response_ticket ?laboratory_report - laboratory_report ?remediation_action - remediation_action)
    :precondition
      (and
        (case_or_ticket_opened ?response_ticket)
        (ticket_includes_remediation_action ?response_ticket ?remediation_action)
        (ticket_linked_lab_report ?response_ticket ?laboratory_report)
        (laboratory_report_available ?laboratory_report)
        (remediation_action_selected ?remediation_action)
        (remediation_lab_validation_complete ?remediation_action)
        (not
          (laboratory_report_consumed ?laboratory_report)
        )
      )
    :effect
      (and
        (laboratory_report_consumed ?laboratory_report)
        (laboratory_report_linked_to_action ?laboratory_report ?remediation_action)
        (not
          (laboratory_report_available ?laboratory_report)
        )
      )
  )
  (:action prepare_ticket_for_expert_review
    :parameters (?response_ticket - response_ticket ?laboratory_report - laboratory_report ?remediation_action - remediation_action ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (case_or_ticket_opened ?response_ticket)
        (ticket_linked_lab_report ?response_ticket ?laboratory_report)
        (laboratory_report_consumed ?laboratory_report)
        (laboratory_report_linked_to_action ?laboratory_report ?remediation_action)
        (assigned_to_lab ?response_ticket ?laboratory_resource)
        (not
          (remediation_requires_source_signoff ?remediation_action)
        )
        (not
          (ready_for_expert_review ?response_ticket)
        )
      )
    :effect (ready_for_expert_review ?response_ticket)
  )
  (:action assign_regulatory_template_to_ticket
    :parameters (?response_ticket - response_ticket ?regulatory_notification_template - regulatory_notification_template)
    :precondition
      (and
        (case_or_ticket_opened ?response_ticket)
        (regulatory_notification_template_available ?regulatory_notification_template)
        (not
          (regulatory_template_assigned ?response_ticket)
        )
      )
    :effect
      (and
        (regulatory_template_assigned ?response_ticket)
        (ticket_assigned_regulatory_template ?response_ticket ?regulatory_notification_template)
        (not
          (regulatory_notification_template_available ?regulatory_notification_template)
        )
      )
  )
  (:action prepare_regulatory_notification_and_mark
    :parameters (?response_ticket - response_ticket ?laboratory_report - laboratory_report ?remediation_action - remediation_action ?laboratory_resource - laboratory_resource ?regulatory_notification_template - regulatory_notification_template)
    :precondition
      (and
        (case_or_ticket_opened ?response_ticket)
        (ticket_linked_lab_report ?response_ticket ?laboratory_report)
        (laboratory_report_consumed ?laboratory_report)
        (laboratory_report_linked_to_action ?laboratory_report ?remediation_action)
        (assigned_to_lab ?response_ticket ?laboratory_resource)
        (remediation_requires_source_signoff ?remediation_action)
        (regulatory_template_assigned ?response_ticket)
        (ticket_assigned_regulatory_template ?response_ticket ?regulatory_notification_template)
        (not
          (ready_for_expert_review ?response_ticket)
        )
      )
    :effect
      (and
        (ready_for_expert_review ?response_ticket)
        (regulatory_notification_prepared ?response_ticket)
      )
  )
  (:action start_expert_review_phase_primary
    :parameters (?response_ticket - response_ticket ?technical_expert - technical_expert ?containment_resource - containment_resource ?laboratory_report - laboratory_report ?remediation_action - remediation_action)
    :precondition
      (and
        (ready_for_expert_review ?response_ticket)
        (ticket_assigned_technical_expert ?response_ticket ?technical_expert)
        (assigned_to_containment ?response_ticket ?containment_resource)
        (ticket_linked_lab_report ?response_ticket ?laboratory_report)
        (laboratory_report_linked_to_action ?laboratory_report ?remediation_action)
        (not
          (remediation_requires_destination_signoff ?remediation_action)
        )
        (not
          (expert_engaged ?response_ticket)
        )
      )
    :effect (expert_engaged ?response_ticket)
  )
  (:action start_expert_review_phase_alternate
    :parameters (?response_ticket - response_ticket ?technical_expert - technical_expert ?containment_resource - containment_resource ?laboratory_report - laboratory_report ?remediation_action - remediation_action)
    :precondition
      (and
        (ready_for_expert_review ?response_ticket)
        (ticket_assigned_technical_expert ?response_ticket ?technical_expert)
        (assigned_to_containment ?response_ticket ?containment_resource)
        (ticket_linked_lab_report ?response_ticket ?laboratory_report)
        (laboratory_report_linked_to_action ?laboratory_report ?remediation_action)
        (remediation_requires_destination_signoff ?remediation_action)
        (not
          (expert_engaged ?response_ticket)
        )
      )
    :effect (expert_engaged ?response_ticket)
  )
  (:action complete_expert_review_stage_primary
    :parameters (?response_ticket - response_ticket ?quality_consultant - quality_consultant ?laboratory_report - laboratory_report ?remediation_action - remediation_action)
    :precondition
      (and
        (expert_engaged ?response_ticket)
        (ticket_assigned_quality_consultant ?response_ticket ?quality_consultant)
        (ticket_linked_lab_report ?response_ticket ?laboratory_report)
        (laboratory_report_linked_to_action ?laboratory_report ?remediation_action)
        (not
          (remediation_requires_source_signoff ?remediation_action)
        )
        (not
          (remediation_requires_destination_signoff ?remediation_action)
        )
        (not
          (expert_review_completed ?response_ticket)
        )
      )
    :effect (expert_review_completed ?response_ticket)
  )
  (:action complete_expert_review_stage_with_source_signoff
    :parameters (?response_ticket - response_ticket ?quality_consultant - quality_consultant ?laboratory_report - laboratory_report ?remediation_action - remediation_action)
    :precondition
      (and
        (expert_engaged ?response_ticket)
        (ticket_assigned_quality_consultant ?response_ticket ?quality_consultant)
        (ticket_linked_lab_report ?response_ticket ?laboratory_report)
        (laboratory_report_linked_to_action ?laboratory_report ?remediation_action)
        (remediation_requires_source_signoff ?remediation_action)
        (not
          (remediation_requires_destination_signoff ?remediation_action)
        )
        (not
          (expert_review_completed ?response_ticket)
        )
      )
    :effect
      (and
        (expert_review_completed ?response_ticket)
        (expert_recommendation_documented ?response_ticket)
      )
  )
  (:action complete_expert_review_stage_with_destination_signoff
    :parameters (?response_ticket - response_ticket ?quality_consultant - quality_consultant ?laboratory_report - laboratory_report ?remediation_action - remediation_action)
    :precondition
      (and
        (expert_engaged ?response_ticket)
        (ticket_assigned_quality_consultant ?response_ticket ?quality_consultant)
        (ticket_linked_lab_report ?response_ticket ?laboratory_report)
        (laboratory_report_linked_to_action ?laboratory_report ?remediation_action)
        (not
          (remediation_requires_source_signoff ?remediation_action)
        )
        (remediation_requires_destination_signoff ?remediation_action)
        (not
          (expert_review_completed ?response_ticket)
        )
      )
    :effect
      (and
        (expert_review_completed ?response_ticket)
        (expert_recommendation_documented ?response_ticket)
      )
  )
  (:action complete_expert_review_stage_with_both_signoff
    :parameters (?response_ticket - response_ticket ?quality_consultant - quality_consultant ?laboratory_report - laboratory_report ?remediation_action - remediation_action)
    :precondition
      (and
        (expert_engaged ?response_ticket)
        (ticket_assigned_quality_consultant ?response_ticket ?quality_consultant)
        (ticket_linked_lab_report ?response_ticket ?laboratory_report)
        (laboratory_report_linked_to_action ?laboratory_report ?remediation_action)
        (remediation_requires_source_signoff ?remediation_action)
        (remediation_requires_destination_signoff ?remediation_action)
        (not
          (expert_review_completed ?response_ticket)
        )
      )
    :effect
      (and
        (expert_review_completed ?response_ticket)
        (expert_recommendation_documented ?response_ticket)
      )
  )
  (:action finalize_authorization_without_supplier_approval
    :parameters (?response_ticket - response_ticket)
    :precondition
      (and
        (expert_review_completed ?response_ticket)
        (not
          (expert_recommendation_documented ?response_ticket)
        )
        (not
          (ticket_release_flag ?response_ticket)
        )
      )
    :effect
      (and
        (ticket_release_flag ?response_ticket)
        (entity_release_authorized ?response_ticket)
      )
  )
  (:action attach_supplier_approval_document_to_ticket
    :parameters (?response_ticket - response_ticket ?supplier_approval_document - supplier_approval_document)
    :precondition
      (and
        (expert_review_completed ?response_ticket)
        (expert_recommendation_documented ?response_ticket)
        (supplier_approval_document_available ?supplier_approval_document)
      )
    :effect
      (and
        (ticket_linked_supplier_approval ?response_ticket ?supplier_approval_document)
        (not
          (supplier_approval_document_available ?supplier_approval_document)
        )
      )
  )
  (:action complete_final_review_and_authorize_release
    :parameters (?response_ticket - response_ticket ?batch_instance - batch_instance ?related_batch_instance - related_batch_instance ?laboratory_resource - laboratory_resource ?supplier_approval_document - supplier_approval_document)
    :precondition
      (and
        (expert_review_completed ?response_ticket)
        (expert_recommendation_documented ?response_ticket)
        (ticket_linked_supplier_approval ?response_ticket ?supplier_approval_document)
        (ticket_associated_with_batch ?response_ticket ?batch_instance)
        (ticket_associated_with_related_batch ?response_ticket ?related_batch_instance)
        (batch_ready_for_remediation ?batch_instance)
        (related_batch_ready_for_remediation ?related_batch_instance)
        (assigned_to_lab ?response_ticket ?laboratory_resource)
        (not
          (final_review_completed ?response_ticket)
        )
      )
    :effect (final_review_completed ?response_ticket)
  )
  (:action finalize_release_after_final_review
    :parameters (?response_ticket - response_ticket)
    :precondition
      (and
        (expert_review_completed ?response_ticket)
        (final_review_completed ?response_ticket)
        (not
          (ticket_release_flag ?response_ticket)
        )
      )
    :effect
      (and
        (ticket_release_flag ?response_ticket)
        (entity_release_authorized ?response_ticket)
      )
  )
  (:action assign_external_stakeholder_to_ticket
    :parameters (?response_ticket - response_ticket ?external_stakeholder - external_stakeholder ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (case_or_ticket_opened ?response_ticket)
        (assigned_to_lab ?response_ticket ?laboratory_resource)
        (external_stakeholder_available ?external_stakeholder)
        (ticket_linked_to_external_stakeholder ?response_ticket ?external_stakeholder)
        (not
          (external_stakeholder_assigned ?response_ticket)
        )
      )
    :effect
      (and
        (external_stakeholder_assigned ?response_ticket)
        (not
          (external_stakeholder_available ?external_stakeholder)
        )
      )
  )
  (:action prepare_external_stakeholder_engagement
    :parameters (?response_ticket - response_ticket ?containment_resource - containment_resource)
    :precondition
      (and
        (external_stakeholder_assigned ?response_ticket)
        (assigned_to_containment ?response_ticket ?containment_resource)
        (not
          (external_stakeholder_engagement_ready ?response_ticket)
        )
      )
    :effect (external_stakeholder_engagement_ready ?response_ticket)
  )
  (:action record_stakeholder_approval_by_quality_consultant
    :parameters (?response_ticket - response_ticket ?quality_consultant - quality_consultant)
    :precondition
      (and
        (external_stakeholder_engagement_ready ?response_ticket)
        (ticket_assigned_quality_consultant ?response_ticket ?quality_consultant)
        (not
          (external_stakeholder_approval_received ?response_ticket)
        )
      )
    :effect (external_stakeholder_approval_received ?response_ticket)
  )
  (:action finalize_release_after_stakeholder_approval
    :parameters (?response_ticket - response_ticket)
    :precondition
      (and
        (external_stakeholder_approval_received ?response_ticket)
        (not
          (ticket_release_flag ?response_ticket)
        )
      )
    :effect
      (and
        (ticket_release_flag ?response_ticket)
        (entity_release_authorized ?response_ticket)
      )
  )
  (:action execute_operational_release_for_batch
    :parameters (?batch_instance - batch_instance ?remediation_action - remediation_action)
    :precondition
      (and
        (batch_triaged ?batch_instance)
        (batch_ready_for_remediation ?batch_instance)
        (remediation_action_selected ?remediation_action)
        (remediation_lab_validation_complete ?remediation_action)
        (not
          (entity_release_authorized ?batch_instance)
        )
      )
    :effect (entity_release_authorized ?batch_instance)
  )
  (:action execute_operational_release_for_related_batch
    :parameters (?related_batch_instance - related_batch_instance ?remediation_action - remediation_action)
    :precondition
      (and
        (related_batch_triaged ?related_batch_instance)
        (related_batch_ready_for_remediation ?related_batch_instance)
        (remediation_action_selected ?remediation_action)
        (remediation_lab_validation_complete ?remediation_action)
        (not
          (entity_release_authorized ?related_batch_instance)
        )
      )
    :effect (entity_release_authorized ?related_batch_instance)
  )
  (:action bind_communication_template_and_prepare_handoff
    :parameters (?excursion_case - excursion_case ?communication_template - communication_template ?laboratory_resource - laboratory_resource)
    :precondition
      (and
        (entity_release_authorized ?excursion_case)
        (assigned_to_lab ?excursion_case ?laboratory_resource)
        (communication_template_available ?communication_template)
        (not
          (operations_handoff_completed ?excursion_case)
        )
      )
    :effect
      (and
        (operations_handoff_completed ?excursion_case)
        (bound_communication_template ?excursion_case ?communication_template)
        (not
          (communication_template_available ?communication_template)
        )
      )
  )
  (:action execute_mitigation_handoff_and_clear_batch
    :parameters (?batch_instance - batch_instance ?investigator_team - investigator_team ?communication_template - communication_template)
    :precondition
      (and
        (operations_handoff_completed ?batch_instance)
        (assigned_to_team ?batch_instance ?investigator_team)
        (bound_communication_template ?batch_instance ?communication_template)
        (not
          (cleared_for_distribution ?batch_instance)
        )
      )
    :effect
      (and
        (cleared_for_distribution ?batch_instance)
        (investigator_team_available ?investigator_team)
        (communication_template_available ?communication_template)
      )
  )
  (:action execute_mitigation_handoff_and_clear_related_batch
    :parameters (?related_batch_instance - related_batch_instance ?investigator_team - investigator_team ?communication_template - communication_template)
    :precondition
      (and
        (operations_handoff_completed ?related_batch_instance)
        (assigned_to_team ?related_batch_instance ?investigator_team)
        (bound_communication_template ?related_batch_instance ?communication_template)
        (not
          (cleared_for_distribution ?related_batch_instance)
        )
      )
    :effect
      (and
        (cleared_for_distribution ?related_batch_instance)
        (investigator_team_available ?investigator_team)
        (communication_template_available ?communication_template)
      )
  )
  (:action execute_mitigation_handoff_for_ticket
    :parameters (?response_ticket - response_ticket ?investigator_team - investigator_team ?communication_template - communication_template)
    :precondition
      (and
        (operations_handoff_completed ?response_ticket)
        (assigned_to_team ?response_ticket ?investigator_team)
        (bound_communication_template ?response_ticket ?communication_template)
        (not
          (cleared_for_distribution ?response_ticket)
        )
      )
    :effect
      (and
        (cleared_for_distribution ?response_ticket)
        (investigator_team_available ?investigator_team)
        (communication_template_available ?communication_template)
      )
  )
)

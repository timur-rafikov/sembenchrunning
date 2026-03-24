(define (domain pharm_recall_communication_escalation)
  (:requirements :strips :typing :negative-preconditions)
  (:types actor_or_resource - object artifact_group - object item_group - object entity_root - object affected_entity - entity_root communication_channel - actor_or_resource investigator - actor_or_resource local_responder - actor_or_resource notification_template - actor_or_resource logistics_resource - actor_or_resource recall_execution_profile - actor_or_resource quality_officer - actor_or_resource legal_counsel - actor_or_resource alternative_supply - artifact_group laboratory_result - artifact_group external_regulator - artifact_group manufacturer_batch - item_group distributor_batch - item_group recall_notice - item_group entity_subscope - affected_entity entity_subscope2 - affected_entity manufacturing_site - entity_subscope distribution_site - entity_subscope response_center - entity_subscope2)
  (:predicates
    (case_registered ?affected_entity - affected_entity)
    (recall_case_validated ?affected_entity - affected_entity)
    (case_channel_assigned_flag ?affected_entity - affected_entity)
    (case_closed ?affected_entity - affected_entity)
    (execution_confirmed ?affected_entity - affected_entity)
    (execution_authorized ?affected_entity - affected_entity)
    (communication_channel_available ?communication_channel - communication_channel)
    (case_assigned_channel ?affected_entity - affected_entity ?communication_channel - communication_channel)
    (investigator_available ?investigator - investigator)
    (case_assigned_investigator ?affected_entity - affected_entity ?investigator - investigator)
    (local_responder_available ?local_responder - local_responder)
    (case_assigned_local_responder ?affected_entity - affected_entity ?local_responder - local_responder)
    (alternative_supply_available ?alternative_supply - alternative_supply)
    (site_allocated_alternative_supply ?manufacturing_site - manufacturing_site ?alternative_supply - alternative_supply)
    (distribution_site_allocated_alternative_supply ?distribution_site - distribution_site ?alternative_supply - alternative_supply)
    (manufacturing_site_has_batch ?manufacturing_site - manufacturing_site ?manufacturer_batch - manufacturer_batch)
    (manufacturer_batch_quarantined ?manufacturer_batch - manufacturer_batch)
    (manufacturer_batch_under_mitigation ?manufacturer_batch - manufacturer_batch)
    (manufacturing_site_containment_confirmed ?manufacturing_site - manufacturing_site)
    (distribution_site_has_batch ?distribution_site - distribution_site ?distributor_batch - distributor_batch)
    (distributor_batch_quarantined ?distributor_batch - distributor_batch)
    (distributor_batch_under_mitigation ?distributor_batch - distributor_batch)
    (distribution_site_containment_confirmed ?distribution_site - distribution_site)
    (recall_notice_available ?recall_notice - recall_notice)
    (recall_notice_prepared ?recall_notice - recall_notice)
    (recall_notice_links_manufacturer_batch ?recall_notice - recall_notice ?manufacturer_batch - manufacturer_batch)
    (recall_notice_links_distributor_batch ?recall_notice - recall_notice ?distributor_batch - distributor_batch)
    (recall_notice_flag_manufacturer_action ?recall_notice - recall_notice)
    (recall_notice_flag_distributor_action ?recall_notice - recall_notice)
    (recall_notice_deployed ?recall_notice - recall_notice)
    (response_center_links_manufacturing_site ?response_center - response_center ?manufacturing_site - manufacturing_site)
    (response_center_links_distribution_site ?response_center - response_center ?distribution_site - distribution_site)
    (response_center_links_recall_notice ?response_center - response_center ?recall_notice - recall_notice)
    (laboratory_result_available ?laboratory_result - laboratory_result)
    (response_center_has_lab_result ?response_center - response_center ?laboratory_result - laboratory_result)
    (laboratory_result_processed ?laboratory_result - laboratory_result)
    (laboratory_result_links_recall_notice ?laboratory_result - laboratory_result ?recall_notice - recall_notice)
    (response_center_lab_verified ?response_center - response_center)
    (response_center_quality_reviewed ?response_center - response_center)
    (response_center_ready_for_finalization ?response_center - response_center)
    (response_center_allocated_template ?response_center - response_center)
    (response_center_regulatory_engagement_recorded ?response_center - response_center)
    (regulatory_clearance_granted ?response_center - response_center)
    (response_center_internal_approval ?response_center - response_center)
    (external_regulator_available ?external_regulator - external_regulator)
    (response_center_linked_external_regulator ?response_center - response_center ?external_regulator - external_regulator)
    (response_center_regulatory_approval ?response_center - response_center)
    (response_center_regulatory_liaison_active ?response_center - response_center)
    (response_center_legal_counsel_assigned ?response_center - response_center)
    (notification_template_available ?notification_template - notification_template)
    (response_center_allocated_notification_template ?response_center - response_center ?notification_template - notification_template)
    (logistics_resource_available ?logistics_resource - logistics_resource)
    (response_center_allocated_logistics_resource ?response_center - response_center ?logistics_resource - logistics_resource)
    (quality_officer_available ?quality_officer - quality_officer)
    (response_center_assigned_quality_officer ?response_center - response_center ?quality_officer - quality_officer)
    (legal_counsel_available ?legal_counsel - legal_counsel)
    (response_center_assigned_legal_counsel ?response_center - response_center ?legal_counsel - legal_counsel)
    (execution_profile_available ?execution_profile - recall_execution_profile)
    (affected_entity_assigned_execution_profile ?affected_entity - affected_entity ?execution_profile - recall_execution_profile)
    (manufacturing_site_containment_active ?manufacturing_site - manufacturing_site)
    (distribution_site_containment_active ?distribution_site - distribution_site)
    (final_notification_logged ?response_center - response_center)
  )
  (:action register_recall_case
    :parameters (?affected_entity - affected_entity)
    :precondition
      (and
        (not
          (case_registered ?affected_entity)
        )
        (not
          (case_closed ?affected_entity)
        )
      )
    :effect (case_registered ?affected_entity)
  )
  (:action assign_communication_channel_to_case
    :parameters (?affected_entity - affected_entity ?communication_channel - communication_channel)
    :precondition
      (and
        (case_registered ?affected_entity)
        (not
          (case_channel_assigned_flag ?affected_entity)
        )
        (communication_channel_available ?communication_channel)
      )
    :effect
      (and
        (case_channel_assigned_flag ?affected_entity)
        (case_assigned_channel ?affected_entity ?communication_channel)
        (not
          (communication_channel_available ?communication_channel)
        )
      )
  )
  (:action assign_investigator_to_case
    :parameters (?affected_entity - affected_entity ?investigator - investigator)
    :precondition
      (and
        (case_registered ?affected_entity)
        (case_channel_assigned_flag ?affected_entity)
        (investigator_available ?investigator)
      )
    :effect
      (and
        (case_assigned_investigator ?affected_entity ?investigator)
        (not
          (investigator_available ?investigator)
        )
      )
  )
  (:action confirm_investigation_validation
    :parameters (?affected_entity - affected_entity ?investigator - investigator)
    :precondition
      (and
        (case_registered ?affected_entity)
        (case_channel_assigned_flag ?affected_entity)
        (case_assigned_investigator ?affected_entity ?investigator)
        (not
          (recall_case_validated ?affected_entity)
        )
      )
    :effect (recall_case_validated ?affected_entity)
  )
  (:action release_investigator_from_case
    :parameters (?affected_entity - affected_entity ?investigator - investigator)
    :precondition
      (and
        (case_assigned_investigator ?affected_entity ?investigator)
      )
    :effect
      (and
        (investigator_available ?investigator)
        (not
          (case_assigned_investigator ?affected_entity ?investigator)
        )
      )
  )
  (:action assign_local_responder_to_case
    :parameters (?affected_entity - affected_entity ?local_responder - local_responder)
    :precondition
      (and
        (recall_case_validated ?affected_entity)
        (local_responder_available ?local_responder)
      )
    :effect
      (and
        (case_assigned_local_responder ?affected_entity ?local_responder)
        (not
          (local_responder_available ?local_responder)
        )
      )
  )
  (:action release_local_responder_from_case
    :parameters (?affected_entity - affected_entity ?local_responder - local_responder)
    :precondition
      (and
        (case_assigned_local_responder ?affected_entity ?local_responder)
      )
    :effect
      (and
        (local_responder_available ?local_responder)
        (not
          (case_assigned_local_responder ?affected_entity ?local_responder)
        )
      )
  )
  (:action assign_quality_officer_to_response_center
    :parameters (?response_center - response_center ?quality_officer - quality_officer)
    :precondition
      (and
        (recall_case_validated ?response_center)
        (quality_officer_available ?quality_officer)
      )
    :effect
      (and
        (response_center_assigned_quality_officer ?response_center ?quality_officer)
        (not
          (quality_officer_available ?quality_officer)
        )
      )
  )
  (:action release_quality_officer_from_response_center
    :parameters (?response_center - response_center ?quality_officer - quality_officer)
    :precondition
      (and
        (response_center_assigned_quality_officer ?response_center ?quality_officer)
      )
    :effect
      (and
        (quality_officer_available ?quality_officer)
        (not
          (response_center_assigned_quality_officer ?response_center ?quality_officer)
        )
      )
  )
  (:action assign_legal_counsel_to_response_center
    :parameters (?response_center - response_center ?legal_counsel - legal_counsel)
    :precondition
      (and
        (recall_case_validated ?response_center)
        (legal_counsel_available ?legal_counsel)
      )
    :effect
      (and
        (response_center_assigned_legal_counsel ?response_center ?legal_counsel)
        (not
          (legal_counsel_available ?legal_counsel)
        )
      )
  )
  (:action release_legal_counsel_from_response_center
    :parameters (?response_center - response_center ?legal_counsel - legal_counsel)
    :precondition
      (and
        (response_center_assigned_legal_counsel ?response_center ?legal_counsel)
      )
    :effect
      (and
        (legal_counsel_available ?legal_counsel)
        (not
          (response_center_assigned_legal_counsel ?response_center ?legal_counsel)
        )
      )
  )
  (:action initiate_manufacturer_batch_quarantine
    :parameters (?manufacturing_site - manufacturing_site ?manufacturer_batch - manufacturer_batch ?investigator - investigator)
    :precondition
      (and
        (recall_case_validated ?manufacturing_site)
        (case_assigned_investigator ?manufacturing_site ?investigator)
        (manufacturing_site_has_batch ?manufacturing_site ?manufacturer_batch)
        (not
          (manufacturer_batch_quarantined ?manufacturer_batch)
        )
        (not
          (manufacturer_batch_under_mitigation ?manufacturer_batch)
        )
      )
    :effect (manufacturer_batch_quarantined ?manufacturer_batch)
  )
  (:action confirm_manufacturing_site_containment
    :parameters (?manufacturing_site - manufacturing_site ?manufacturer_batch - manufacturer_batch ?local_responder - local_responder)
    :precondition
      (and
        (recall_case_validated ?manufacturing_site)
        (case_assigned_local_responder ?manufacturing_site ?local_responder)
        (manufacturing_site_has_batch ?manufacturing_site ?manufacturer_batch)
        (manufacturer_batch_quarantined ?manufacturer_batch)
        (not
          (manufacturing_site_containment_active ?manufacturing_site)
        )
      )
    :effect
      (and
        (manufacturing_site_containment_active ?manufacturing_site)
        (manufacturing_site_containment_confirmed ?manufacturing_site)
      )
  )
  (:action apply_mitigation_and_allocate_alternative_supply
    :parameters (?manufacturing_site - manufacturing_site ?manufacturer_batch - manufacturer_batch ?alternative_supply - alternative_supply)
    :precondition
      (and
        (recall_case_validated ?manufacturing_site)
        (manufacturing_site_has_batch ?manufacturing_site ?manufacturer_batch)
        (alternative_supply_available ?alternative_supply)
        (not
          (manufacturing_site_containment_active ?manufacturing_site)
        )
      )
    :effect
      (and
        (manufacturer_batch_under_mitigation ?manufacturer_batch)
        (manufacturing_site_containment_active ?manufacturing_site)
        (site_allocated_alternative_supply ?manufacturing_site ?alternative_supply)
        (not
          (alternative_supply_available ?alternative_supply)
        )
      )
  )
  (:action finalize_manufacturer_batch_mitigation
    :parameters (?manufacturing_site - manufacturing_site ?manufacturer_batch - manufacturer_batch ?investigator - investigator ?alternative_supply - alternative_supply)
    :precondition
      (and
        (recall_case_validated ?manufacturing_site)
        (case_assigned_investigator ?manufacturing_site ?investigator)
        (manufacturing_site_has_batch ?manufacturing_site ?manufacturer_batch)
        (manufacturer_batch_under_mitigation ?manufacturer_batch)
        (site_allocated_alternative_supply ?manufacturing_site ?alternative_supply)
        (not
          (manufacturing_site_containment_confirmed ?manufacturing_site)
        )
      )
    :effect
      (and
        (manufacturer_batch_quarantined ?manufacturer_batch)
        (manufacturing_site_containment_confirmed ?manufacturing_site)
        (alternative_supply_available ?alternative_supply)
        (not
          (site_allocated_alternative_supply ?manufacturing_site ?alternative_supply)
        )
      )
  )
  (:action initiate_distributor_batch_quarantine
    :parameters (?distribution_site - distribution_site ?distributor_batch - distributor_batch ?investigator - investigator)
    :precondition
      (and
        (recall_case_validated ?distribution_site)
        (case_assigned_investigator ?distribution_site ?investigator)
        (distribution_site_has_batch ?distribution_site ?distributor_batch)
        (not
          (distributor_batch_quarantined ?distributor_batch)
        )
        (not
          (distributor_batch_under_mitigation ?distributor_batch)
        )
      )
    :effect (distributor_batch_quarantined ?distributor_batch)
  )
  (:action confirm_distribution_site_containment
    :parameters (?distribution_site - distribution_site ?distributor_batch - distributor_batch ?local_responder - local_responder)
    :precondition
      (and
        (recall_case_validated ?distribution_site)
        (case_assigned_local_responder ?distribution_site ?local_responder)
        (distribution_site_has_batch ?distribution_site ?distributor_batch)
        (distributor_batch_quarantined ?distributor_batch)
        (not
          (distribution_site_containment_active ?distribution_site)
        )
      )
    :effect
      (and
        (distribution_site_containment_active ?distribution_site)
        (distribution_site_containment_confirmed ?distribution_site)
      )
  )
  (:action apply_distribution_mitigation_and_allocate_alternative_supply
    :parameters (?distribution_site - distribution_site ?distributor_batch - distributor_batch ?alternative_supply - alternative_supply)
    :precondition
      (and
        (recall_case_validated ?distribution_site)
        (distribution_site_has_batch ?distribution_site ?distributor_batch)
        (alternative_supply_available ?alternative_supply)
        (not
          (distribution_site_containment_active ?distribution_site)
        )
      )
    :effect
      (and
        (distributor_batch_under_mitigation ?distributor_batch)
        (distribution_site_containment_active ?distribution_site)
        (distribution_site_allocated_alternative_supply ?distribution_site ?alternative_supply)
        (not
          (alternative_supply_available ?alternative_supply)
        )
      )
  )
  (:action finalize_distributor_batch_mitigation
    :parameters (?distribution_site - distribution_site ?distributor_batch - distributor_batch ?investigator - investigator ?alternative_supply - alternative_supply)
    :precondition
      (and
        (recall_case_validated ?distribution_site)
        (case_assigned_investigator ?distribution_site ?investigator)
        (distribution_site_has_batch ?distribution_site ?distributor_batch)
        (distributor_batch_under_mitigation ?distributor_batch)
        (distribution_site_allocated_alternative_supply ?distribution_site ?alternative_supply)
        (not
          (distribution_site_containment_confirmed ?distribution_site)
        )
      )
    :effect
      (and
        (distributor_batch_quarantined ?distributor_batch)
        (distribution_site_containment_confirmed ?distribution_site)
        (alternative_supply_available ?alternative_supply)
        (not
          (distribution_site_allocated_alternative_supply ?distribution_site ?alternative_supply)
        )
      )
  )
  (:action prepare_and_link_recall_notice
    :parameters (?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?manufacturer_batch - manufacturer_batch ?distributor_batch - distributor_batch ?recall_notice - recall_notice)
    :precondition
      (and
        (manufacturing_site_containment_active ?manufacturing_site)
        (distribution_site_containment_active ?distribution_site)
        (manufacturing_site_has_batch ?manufacturing_site ?manufacturer_batch)
        (distribution_site_has_batch ?distribution_site ?distributor_batch)
        (manufacturer_batch_quarantined ?manufacturer_batch)
        (distributor_batch_quarantined ?distributor_batch)
        (manufacturing_site_containment_confirmed ?manufacturing_site)
        (distribution_site_containment_confirmed ?distribution_site)
        (recall_notice_available ?recall_notice)
      )
    :effect
      (and
        (recall_notice_prepared ?recall_notice)
        (recall_notice_links_manufacturer_batch ?recall_notice ?manufacturer_batch)
        (recall_notice_links_distributor_batch ?recall_notice ?distributor_batch)
        (not
          (recall_notice_available ?recall_notice)
        )
      )
  )
  (:action prepare_recall_notice_with_manufacturer_action_flag
    :parameters (?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?manufacturer_batch - manufacturer_batch ?distributor_batch - distributor_batch ?recall_notice - recall_notice)
    :precondition
      (and
        (manufacturing_site_containment_active ?manufacturing_site)
        (distribution_site_containment_active ?distribution_site)
        (manufacturing_site_has_batch ?manufacturing_site ?manufacturer_batch)
        (distribution_site_has_batch ?distribution_site ?distributor_batch)
        (manufacturer_batch_under_mitigation ?manufacturer_batch)
        (distributor_batch_quarantined ?distributor_batch)
        (not
          (manufacturing_site_containment_confirmed ?manufacturing_site)
        )
        (distribution_site_containment_confirmed ?distribution_site)
        (recall_notice_available ?recall_notice)
      )
    :effect
      (and
        (recall_notice_prepared ?recall_notice)
        (recall_notice_links_manufacturer_batch ?recall_notice ?manufacturer_batch)
        (recall_notice_links_distributor_batch ?recall_notice ?distributor_batch)
        (recall_notice_flag_manufacturer_action ?recall_notice)
        (not
          (recall_notice_available ?recall_notice)
        )
      )
  )
  (:action prepare_recall_notice_with_distributor_action_flag
    :parameters (?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?manufacturer_batch - manufacturer_batch ?distributor_batch - distributor_batch ?recall_notice - recall_notice)
    :precondition
      (and
        (manufacturing_site_containment_active ?manufacturing_site)
        (distribution_site_containment_active ?distribution_site)
        (manufacturing_site_has_batch ?manufacturing_site ?manufacturer_batch)
        (distribution_site_has_batch ?distribution_site ?distributor_batch)
        (manufacturer_batch_quarantined ?manufacturer_batch)
        (distributor_batch_under_mitigation ?distributor_batch)
        (manufacturing_site_containment_confirmed ?manufacturing_site)
        (not
          (distribution_site_containment_confirmed ?distribution_site)
        )
        (recall_notice_available ?recall_notice)
      )
    :effect
      (and
        (recall_notice_prepared ?recall_notice)
        (recall_notice_links_manufacturer_batch ?recall_notice ?manufacturer_batch)
        (recall_notice_links_distributor_batch ?recall_notice ?distributor_batch)
        (recall_notice_flag_distributor_action ?recall_notice)
        (not
          (recall_notice_available ?recall_notice)
        )
      )
  )
  (:action prepare_recall_notice_with_both_action_flags
    :parameters (?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?manufacturer_batch - manufacturer_batch ?distributor_batch - distributor_batch ?recall_notice - recall_notice)
    :precondition
      (and
        (manufacturing_site_containment_active ?manufacturing_site)
        (distribution_site_containment_active ?distribution_site)
        (manufacturing_site_has_batch ?manufacturing_site ?manufacturer_batch)
        (distribution_site_has_batch ?distribution_site ?distributor_batch)
        (manufacturer_batch_under_mitigation ?manufacturer_batch)
        (distributor_batch_under_mitigation ?distributor_batch)
        (not
          (manufacturing_site_containment_confirmed ?manufacturing_site)
        )
        (not
          (distribution_site_containment_confirmed ?distribution_site)
        )
        (recall_notice_available ?recall_notice)
      )
    :effect
      (and
        (recall_notice_prepared ?recall_notice)
        (recall_notice_links_manufacturer_batch ?recall_notice ?manufacturer_batch)
        (recall_notice_links_distributor_batch ?recall_notice ?distributor_batch)
        (recall_notice_flag_manufacturer_action ?recall_notice)
        (recall_notice_flag_distributor_action ?recall_notice)
        (not
          (recall_notice_available ?recall_notice)
        )
      )
  )
  (:action deploy_recall_notice_at_manufacturing_site
    :parameters (?recall_notice - recall_notice ?manufacturing_site - manufacturing_site ?investigator - investigator)
    :precondition
      (and
        (recall_notice_prepared ?recall_notice)
        (manufacturing_site_containment_active ?manufacturing_site)
        (case_assigned_investigator ?manufacturing_site ?investigator)
        (not
          (recall_notice_deployed ?recall_notice)
        )
      )
    :effect (recall_notice_deployed ?recall_notice)
  )
  (:action process_lab_result_and_link_notice
    :parameters (?response_center - response_center ?laboratory_result - laboratory_result ?recall_notice - recall_notice)
    :precondition
      (and
        (recall_case_validated ?response_center)
        (response_center_links_recall_notice ?response_center ?recall_notice)
        (response_center_has_lab_result ?response_center ?laboratory_result)
        (laboratory_result_available ?laboratory_result)
        (recall_notice_prepared ?recall_notice)
        (recall_notice_deployed ?recall_notice)
        (not
          (laboratory_result_processed ?laboratory_result)
        )
      )
    :effect
      (and
        (laboratory_result_processed ?laboratory_result)
        (laboratory_result_links_recall_notice ?laboratory_result ?recall_notice)
        (not
          (laboratory_result_available ?laboratory_result)
        )
      )
  )
  (:action verify_lab_result_at_response_center
    :parameters (?response_center - response_center ?laboratory_result - laboratory_result ?recall_notice - recall_notice ?investigator - investigator)
    :precondition
      (and
        (recall_case_validated ?response_center)
        (response_center_has_lab_result ?response_center ?laboratory_result)
        (laboratory_result_processed ?laboratory_result)
        (laboratory_result_links_recall_notice ?laboratory_result ?recall_notice)
        (case_assigned_investigator ?response_center ?investigator)
        (not
          (recall_notice_flag_manufacturer_action ?recall_notice)
        )
        (not
          (response_center_lab_verified ?response_center)
        )
      )
    :effect (response_center_lab_verified ?response_center)
  )
  (:action assign_notification_template_to_response_center
    :parameters (?response_center - response_center ?notification_template - notification_template)
    :precondition
      (and
        (recall_case_validated ?response_center)
        (notification_template_available ?notification_template)
        (not
          (response_center_allocated_template ?response_center)
        )
      )
    :effect
      (and
        (response_center_allocated_template ?response_center)
        (response_center_allocated_notification_template ?response_center ?notification_template)
        (not
          (notification_template_available ?notification_template)
        )
      )
  )
  (:action record_regulatory_engagement_with_template
    :parameters (?response_center - response_center ?laboratory_result - laboratory_result ?recall_notice - recall_notice ?investigator - investigator ?notification_template - notification_template)
    :precondition
      (and
        (recall_case_validated ?response_center)
        (response_center_has_lab_result ?response_center ?laboratory_result)
        (laboratory_result_processed ?laboratory_result)
        (laboratory_result_links_recall_notice ?laboratory_result ?recall_notice)
        (case_assigned_investigator ?response_center ?investigator)
        (recall_notice_flag_manufacturer_action ?recall_notice)
        (response_center_allocated_template ?response_center)
        (response_center_allocated_notification_template ?response_center ?notification_template)
        (not
          (response_center_lab_verified ?response_center)
        )
      )
    :effect
      (and
        (response_center_lab_verified ?response_center)
        (response_center_regulatory_engagement_recorded ?response_center)
      )
  )
  (:action start_quality_review_standard
    :parameters (?response_center - response_center ?quality_officer - quality_officer ?local_responder - local_responder ?laboratory_result - laboratory_result ?recall_notice - recall_notice)
    :precondition
      (and
        (response_center_lab_verified ?response_center)
        (response_center_assigned_quality_officer ?response_center ?quality_officer)
        (case_assigned_local_responder ?response_center ?local_responder)
        (response_center_has_lab_result ?response_center ?laboratory_result)
        (laboratory_result_links_recall_notice ?laboratory_result ?recall_notice)
        (not
          (recall_notice_flag_distributor_action ?recall_notice)
        )
        (not
          (response_center_quality_reviewed ?response_center)
        )
      )
    :effect (response_center_quality_reviewed ?response_center)
  )
  (:action start_quality_review_escalated
    :parameters (?response_center - response_center ?quality_officer - quality_officer ?local_responder - local_responder ?laboratory_result - laboratory_result ?recall_notice - recall_notice)
    :precondition
      (and
        (response_center_lab_verified ?response_center)
        (response_center_assigned_quality_officer ?response_center ?quality_officer)
        (case_assigned_local_responder ?response_center ?local_responder)
        (response_center_has_lab_result ?response_center ?laboratory_result)
        (laboratory_result_links_recall_notice ?laboratory_result ?recall_notice)
        (recall_notice_flag_distributor_action ?recall_notice)
        (not
          (response_center_quality_reviewed ?response_center)
        )
      )
    :effect (response_center_quality_reviewed ?response_center)
  )
  (:action finalize_legal_review_at_response_center
    :parameters (?response_center - response_center ?legal_counsel - legal_counsel ?laboratory_result - laboratory_result ?recall_notice - recall_notice)
    :precondition
      (and
        (response_center_quality_reviewed ?response_center)
        (response_center_assigned_legal_counsel ?response_center ?legal_counsel)
        (response_center_has_lab_result ?response_center ?laboratory_result)
        (laboratory_result_links_recall_notice ?laboratory_result ?recall_notice)
        (not
          (recall_notice_flag_manufacturer_action ?recall_notice)
        )
        (not
          (recall_notice_flag_distributor_action ?recall_notice)
        )
        (not
          (response_center_ready_for_finalization ?response_center)
        )
      )
    :effect (response_center_ready_for_finalization ?response_center)
  )
  (:action finalize_legal_review_and_grant_regulatory_clearance
    :parameters (?response_center - response_center ?legal_counsel - legal_counsel ?laboratory_result - laboratory_result ?recall_notice - recall_notice)
    :precondition
      (and
        (response_center_quality_reviewed ?response_center)
        (response_center_assigned_legal_counsel ?response_center ?legal_counsel)
        (response_center_has_lab_result ?response_center ?laboratory_result)
        (laboratory_result_links_recall_notice ?laboratory_result ?recall_notice)
        (recall_notice_flag_manufacturer_action ?recall_notice)
        (not
          (recall_notice_flag_distributor_action ?recall_notice)
        )
        (not
          (response_center_ready_for_finalization ?response_center)
        )
      )
    :effect
      (and
        (response_center_ready_for_finalization ?response_center)
        (regulatory_clearance_granted ?response_center)
      )
  )
  (:action finalize_legal_review_and_grant_clearance_with_distributor_flag
    :parameters (?response_center - response_center ?legal_counsel - legal_counsel ?laboratory_result - laboratory_result ?recall_notice - recall_notice)
    :precondition
      (and
        (response_center_quality_reviewed ?response_center)
        (response_center_assigned_legal_counsel ?response_center ?legal_counsel)
        (response_center_has_lab_result ?response_center ?laboratory_result)
        (laboratory_result_links_recall_notice ?laboratory_result ?recall_notice)
        (not
          (recall_notice_flag_manufacturer_action ?recall_notice)
        )
        (recall_notice_flag_distributor_action ?recall_notice)
        (not
          (response_center_ready_for_finalization ?response_center)
        )
      )
    :effect
      (and
        (response_center_ready_for_finalization ?response_center)
        (regulatory_clearance_granted ?response_center)
      )
  )
  (:action finalize_legal_review_and_grant_clearance_with_both_flags
    :parameters (?response_center - response_center ?legal_counsel - legal_counsel ?laboratory_result - laboratory_result ?recall_notice - recall_notice)
    :precondition
      (and
        (response_center_quality_reviewed ?response_center)
        (response_center_assigned_legal_counsel ?response_center ?legal_counsel)
        (response_center_has_lab_result ?response_center ?laboratory_result)
        (laboratory_result_links_recall_notice ?laboratory_result ?recall_notice)
        (recall_notice_flag_manufacturer_action ?recall_notice)
        (recall_notice_flag_distributor_action ?recall_notice)
        (not
          (response_center_ready_for_finalization ?response_center)
        )
      )
    :effect
      (and
        (response_center_ready_for_finalization ?response_center)
        (regulatory_clearance_granted ?response_center)
      )
  )
  (:action finalize_notification_and_record
    :parameters (?response_center - response_center)
    :precondition
      (and
        (response_center_ready_for_finalization ?response_center)
        (not
          (regulatory_clearance_granted ?response_center)
        )
        (not
          (final_notification_logged ?response_center)
        )
      )
    :effect
      (and
        (final_notification_logged ?response_center)
        (execution_confirmed ?response_center)
      )
  )
  (:action assign_logistics_resource_to_response_center
    :parameters (?response_center - response_center ?logistics_resource - logistics_resource)
    :precondition
      (and
        (response_center_ready_for_finalization ?response_center)
        (regulatory_clearance_granted ?response_center)
        (logistics_resource_available ?logistics_resource)
      )
    :effect
      (and
        (response_center_allocated_logistics_resource ?response_center ?logistics_resource)
        (not
          (logistics_resource_available ?logistics_resource)
        )
      )
  )
  (:action authorize_response_center_for_execution
    :parameters (?response_center - response_center ?manufacturing_site - manufacturing_site ?distribution_site - distribution_site ?investigator - investigator ?logistics_resource - logistics_resource)
    :precondition
      (and
        (response_center_ready_for_finalization ?response_center)
        (regulatory_clearance_granted ?response_center)
        (response_center_allocated_logistics_resource ?response_center ?logistics_resource)
        (response_center_links_manufacturing_site ?response_center ?manufacturing_site)
        (response_center_links_distribution_site ?response_center ?distribution_site)
        (manufacturing_site_containment_confirmed ?manufacturing_site)
        (distribution_site_containment_confirmed ?distribution_site)
        (case_assigned_investigator ?response_center ?investigator)
        (not
          (response_center_internal_approval ?response_center)
        )
      )
    :effect (response_center_internal_approval ?response_center)
  )
  (:action finalize_notification_post_authorization
    :parameters (?response_center - response_center)
    :precondition
      (and
        (response_center_ready_for_finalization ?response_center)
        (response_center_internal_approval ?response_center)
        (not
          (final_notification_logged ?response_center)
        )
      )
    :effect
      (and
        (final_notification_logged ?response_center)
        (execution_confirmed ?response_center)
      )
  )
  (:action assign_external_regulator_to_response_center
    :parameters (?response_center - response_center ?external_regulator - external_regulator ?investigator - investigator)
    :precondition
      (and
        (recall_case_validated ?response_center)
        (case_assigned_investigator ?response_center ?investigator)
        (external_regulator_available ?external_regulator)
        (response_center_linked_external_regulator ?response_center ?external_regulator)
        (not
          (response_center_regulatory_approval ?response_center)
        )
      )
    :effect
      (and
        (response_center_regulatory_approval ?response_center)
        (not
          (external_regulator_available ?external_regulator)
        )
      )
  )
  (:action establish_regulatory_liaison_at_center
    :parameters (?response_center - response_center ?local_responder - local_responder)
    :precondition
      (and
        (response_center_regulatory_approval ?response_center)
        (case_assigned_local_responder ?response_center ?local_responder)
        (not
          (response_center_regulatory_liaison_active ?response_center)
        )
      )
    :effect (response_center_regulatory_liaison_active ?response_center)
  )
  (:action confirm_legal_counsel_assignment
    :parameters (?response_center - response_center ?legal_counsel - legal_counsel)
    :precondition
      (and
        (response_center_regulatory_liaison_active ?response_center)
        (response_center_assigned_legal_counsel ?response_center ?legal_counsel)
        (not
          (response_center_legal_counsel_assigned ?response_center)
        )
      )
    :effect (response_center_legal_counsel_assigned ?response_center)
  )
  (:action finalize_notification_after_legal_confirmation
    :parameters (?response_center - response_center)
    :precondition
      (and
        (response_center_legal_counsel_assigned ?response_center)
        (not
          (final_notification_logged ?response_center)
        )
      )
    :effect
      (and
        (final_notification_logged ?response_center)
        (execution_confirmed ?response_center)
      )
  )
  (:action record_recall_execution_at_manufacturing_site
    :parameters (?manufacturing_site - manufacturing_site ?recall_notice - recall_notice)
    :precondition
      (and
        (manufacturing_site_containment_active ?manufacturing_site)
        (manufacturing_site_containment_confirmed ?manufacturing_site)
        (recall_notice_prepared ?recall_notice)
        (recall_notice_deployed ?recall_notice)
        (not
          (execution_confirmed ?manufacturing_site)
        )
      )
    :effect (execution_confirmed ?manufacturing_site)
  )
  (:action record_recall_execution_at_distribution_site
    :parameters (?distribution_site - distribution_site ?recall_notice - recall_notice)
    :precondition
      (and
        (distribution_site_containment_active ?distribution_site)
        (distribution_site_containment_confirmed ?distribution_site)
        (recall_notice_prepared ?recall_notice)
        (recall_notice_deployed ?recall_notice)
        (not
          (execution_confirmed ?distribution_site)
        )
      )
    :effect (execution_confirmed ?distribution_site)
  )
  (:action assign_execution_profile_to_affected_entity
    :parameters (?affected_entity - affected_entity ?execution_profile - recall_execution_profile ?investigator - investigator)
    :precondition
      (and
        (execution_confirmed ?affected_entity)
        (case_assigned_investigator ?affected_entity ?investigator)
        (execution_profile_available ?execution_profile)
        (not
          (execution_authorized ?affected_entity)
        )
      )
    :effect
      (and
        (execution_authorized ?affected_entity)
        (affected_entity_assigned_execution_profile ?affected_entity ?execution_profile)
        (not
          (execution_profile_available ?execution_profile)
        )
      )
  )
  (:action execute_recall_at_manufacturing_site
    :parameters (?manufacturing_site - manufacturing_site ?communication_channel - communication_channel ?execution_profile - recall_execution_profile)
    :precondition
      (and
        (execution_authorized ?manufacturing_site)
        (case_assigned_channel ?manufacturing_site ?communication_channel)
        (affected_entity_assigned_execution_profile ?manufacturing_site ?execution_profile)
        (not
          (case_closed ?manufacturing_site)
        )
      )
    :effect
      (and
        (case_closed ?manufacturing_site)
        (communication_channel_available ?communication_channel)
        (execution_profile_available ?execution_profile)
      )
  )
  (:action execute_recall_at_distribution_site
    :parameters (?distribution_site - distribution_site ?communication_channel - communication_channel ?execution_profile - recall_execution_profile)
    :precondition
      (and
        (execution_authorized ?distribution_site)
        (case_assigned_channel ?distribution_site ?communication_channel)
        (affected_entity_assigned_execution_profile ?distribution_site ?execution_profile)
        (not
          (case_closed ?distribution_site)
        )
      )
    :effect
      (and
        (case_closed ?distribution_site)
        (communication_channel_available ?communication_channel)
        (execution_profile_available ?execution_profile)
      )
  )
  (:action execute_recall_at_response_center
    :parameters (?response_center - response_center ?communication_channel - communication_channel ?execution_profile - recall_execution_profile)
    :precondition
      (and
        (execution_authorized ?response_center)
        (case_assigned_channel ?response_center ?communication_channel)
        (affected_entity_assigned_execution_profile ?response_center ?execution_profile)
        (not
          (case_closed ?response_center)
        )
      )
    :effect
      (and
        (case_closed ?response_center)
        (communication_channel_available ?communication_channel)
        (execution_profile_available ?execution_profile)
      )
  )
)

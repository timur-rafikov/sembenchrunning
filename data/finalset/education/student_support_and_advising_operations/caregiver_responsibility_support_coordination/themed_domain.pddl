(define (domain caregiver_responsibility_support_coordination_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object coordination_resource - entity resource_category - entity document_type - entity entity_type - entity case_record - entity_type support_service - coordination_resource assessment_report - coordination_resource staff_member - coordination_resource intervention_option - coordination_resource follow_up_task - coordination_resource external_reference - coordination_resource specialist_consult - coordination_resource clinical_input - coordination_resource referral - resource_category document_packet - resource_category external_authority - resource_category identified_barrier - document_type identified_need - document_type support_plan_document - document_type case_subtype - case_record protocol_variant - case_record primary_caregiver - case_subtype secondary_contact - case_subtype case_coordinator - protocol_variant)

  (:predicates
    (case_opened ?case_record - case_record)
    (entity_confirmed ?case_record - case_record)
    (case_service_matched ?case_record - case_record)
    (entity_closed ?case_record - case_record)
    (entity_ready_for_followup ?case_record - case_record)
    (entity_followthrough_documented ?case_record - case_record)
    (support_service_available ?support_service - support_service)
    (case_assigned_service ?case_record - case_record ?support_service - support_service)
    (assessment_available ?assessment_report - assessment_report)
    (entity_has_assessment ?case_record - case_record ?assessment_report - assessment_report)
    (staff_available ?staff_member - staff_member)
    (assigned_staff ?case_record - case_record ?staff_member - staff_member)
    (referral_available ?referral - referral)
    (primary_caregiver_referral ?primary_caregiver - primary_caregiver ?referral - referral)
    (secondary_contact_referral ?secondary_contact - secondary_contact ?referral - referral)
    (primary_caregiver_has_barrier ?primary_caregiver - primary_caregiver ?identified_barrier - identified_barrier)
    (barrier_flagged ?identified_barrier - identified_barrier)
    (barrier_referred ?identified_barrier - identified_barrier)
    (primary_caregiver_action_planned ?primary_caregiver - primary_caregiver)
    (secondary_contact_has_need ?secondary_contact - secondary_contact ?identified_need - identified_need)
    (need_flagged ?identified_need - identified_need)
    (need_referred ?identified_need - identified_need)
    (secondary_contact_action_planned ?secondary_contact - secondary_contact)
    (plan_document_pending ?support_plan_document - support_plan_document)
    (plan_document_created ?support_plan_document - support_plan_document)
    (plan_addresses_barrier ?support_plan_document - support_plan_document ?identified_barrier - identified_barrier)
    (plan_addresses_need ?support_plan_document - support_plan_document ?identified_need - identified_need)
    (plan_document_reviewed_by_coordinator ?support_plan_document - support_plan_document)
    (plan_document_reviewed_by_authority ?support_plan_document - support_plan_document)
    (plan_document_finalized ?support_plan_document - support_plan_document)
    (coordinator_linked_primary_caregiver ?case_coordinator - case_coordinator ?primary_caregiver - primary_caregiver)
    (coordinator_linked_secondary_contact ?case_coordinator - case_coordinator ?secondary_contact - secondary_contact)
    (coordinator_has_plan_document ?case_coordinator - case_coordinator ?support_plan_document - support_plan_document)
    (document_packet_available ?document_packet - document_packet)
    (coordinator_has_document_packet ?case_coordinator - case_coordinator ?document_packet - document_packet)
    (document_packet_processed ?document_packet - document_packet)
    (document_packet_attached_to_plan ?document_packet - document_packet ?support_plan_document - support_plan_document)
    (coordinator_authorized_for_intervention ?case_coordinator - case_coordinator)
    (coordinator_initiated_intervention ?case_coordinator - case_coordinator)
    (coordinator_intervention_sequence_started ?case_coordinator - case_coordinator)
    (coordinator_intervention_option_requested ?case_coordinator - case_coordinator)
    (coordinator_intervention_option_confirmed ?case_coordinator - case_coordinator)
    (coordinator_followup_conditions_met ?case_coordinator - case_coordinator)
    (coordinator_intervention_committed ?case_coordinator - case_coordinator)
    (external_authority_available ?external_authority - external_authority)
    (coordinator_linked_external_authority ?case_coordinator - case_coordinator ?external_authority - external_authority)
    (coordinator_escalation_requested ?case_coordinator - case_coordinator)
    (coordinator_escalation_approved_by_staff ?case_coordinator - case_coordinator)
    (coordinator_escalation_approved_by_clinical_input ?case_coordinator - case_coordinator)
    (intervention_option_available ?intervention_option - intervention_option)
    (coordinator_selected_intervention_option ?case_coordinator - case_coordinator ?intervention_option - intervention_option)
    (follow_up_task_available ?follow_up_task - follow_up_task)
    (coordinator_assigned_follow_up ?case_coordinator - case_coordinator ?follow_up_task - follow_up_task)
    (specialist_consult_available ?specialist_consult - specialist_consult)
    (coordinator_engaged_specialist ?case_coordinator - case_coordinator ?specialist_consult - specialist_consult)
    (clinical_input_available ?clinical_input - clinical_input)
    (coordinator_received_clinical_input ?case_coordinator - case_coordinator ?clinical_input - clinical_input)
    (external_reference_available ?external_reference - external_reference)
    (case_has_external_reference ?case_record - case_record ?external_reference - external_reference)
    (primary_caregiver_engaged ?primary_caregiver - primary_caregiver)
    (secondary_contact_engaged ?secondary_contact - secondary_contact)
    (coordinator_case_completed ?case_coordinator - case_coordinator)
  )
  (:action open_case_record
    :parameters (?case_record - case_record)
    :precondition
      (and
        (not
          (case_opened ?case_record)
        )
        (not
          (entity_closed ?case_record)
        )
      )
    :effect (case_opened ?case_record)
  )
  (:action assign_support_service
    :parameters (?case_record - case_record ?support_service - support_service)
    :precondition
      (and
        (case_opened ?case_record)
        (not
          (case_service_matched ?case_record)
        )
        (support_service_available ?support_service)
      )
    :effect
      (and
        (case_service_matched ?case_record)
        (case_assigned_service ?case_record ?support_service)
        (not
          (support_service_available ?support_service)
        )
      )
  )
  (:action attach_assessment_to_case
    :parameters (?case_record - case_record ?assessment_report - assessment_report)
    :precondition
      (and
        (case_opened ?case_record)
        (case_service_matched ?case_record)
        (assessment_available ?assessment_report)
      )
    :effect
      (and
        (entity_has_assessment ?case_record ?assessment_report)
        (not
          (assessment_available ?assessment_report)
        )
      )
  )
  (:action confirm_case_verification
    :parameters (?case_record - case_record ?assessment_report - assessment_report)
    :precondition
      (and
        (case_opened ?case_record)
        (case_service_matched ?case_record)
        (entity_has_assessment ?case_record ?assessment_report)
        (not
          (entity_confirmed ?case_record)
        )
      )
    :effect (entity_confirmed ?case_record)
  )
  (:action release_assessment_report
    :parameters (?case_record - case_record ?assessment_report - assessment_report)
    :precondition
      (and
        (entity_has_assessment ?case_record ?assessment_report)
      )
    :effect
      (and
        (assessment_available ?assessment_report)
        (not
          (entity_has_assessment ?case_record ?assessment_report)
        )
      )
  )
  (:action assign_staff_member
    :parameters (?case_record - case_record ?staff_member - staff_member)
    :precondition
      (and
        (entity_confirmed ?case_record)
        (staff_available ?staff_member)
      )
    :effect
      (and
        (assigned_staff ?case_record ?staff_member)
        (not
          (staff_available ?staff_member)
        )
      )
  )
  (:action remove_staff_assignment
    :parameters (?case_record - case_record ?staff_member - staff_member)
    :precondition
      (and
        (assigned_staff ?case_record ?staff_member)
      )
    :effect
      (and
        (staff_available ?staff_member)
        (not
          (assigned_staff ?case_record ?staff_member)
        )
      )
  )
  (:action engage_specialist_consult
    :parameters (?case_coordinator - case_coordinator ?specialist_consult - specialist_consult)
    :precondition
      (and
        (entity_confirmed ?case_coordinator)
        (specialist_consult_available ?specialist_consult)
      )
    :effect
      (and
        (coordinator_engaged_specialist ?case_coordinator ?specialist_consult)
        (not
          (specialist_consult_available ?specialist_consult)
        )
      )
  )
  (:action release_specialist_consult
    :parameters (?case_coordinator - case_coordinator ?specialist_consult - specialist_consult)
    :precondition
      (and
        (coordinator_engaged_specialist ?case_coordinator ?specialist_consult)
      )
    :effect
      (and
        (specialist_consult_available ?specialist_consult)
        (not
          (coordinator_engaged_specialist ?case_coordinator ?specialist_consult)
        )
      )
  )
  (:action engage_clinical_input
    :parameters (?case_coordinator - case_coordinator ?clinical_input - clinical_input)
    :precondition
      (and
        (entity_confirmed ?case_coordinator)
        (clinical_input_available ?clinical_input)
      )
    :effect
      (and
        (coordinator_received_clinical_input ?case_coordinator ?clinical_input)
        (not
          (clinical_input_available ?clinical_input)
        )
      )
  )
  (:action release_clinical_input
    :parameters (?case_coordinator - case_coordinator ?clinical_input - clinical_input)
    :precondition
      (and
        (coordinator_received_clinical_input ?case_coordinator ?clinical_input)
      )
    :effect
      (and
        (clinical_input_available ?clinical_input)
        (not
          (coordinator_received_clinical_input ?case_coordinator ?clinical_input)
        )
      )
  )
  (:action flag_identified_barrier_primary
    :parameters (?primary_caregiver - primary_caregiver ?identified_barrier - identified_barrier ?assessment_report - assessment_report)
    :precondition
      (and
        (entity_confirmed ?primary_caregiver)
        (entity_has_assessment ?primary_caregiver ?assessment_report)
        (primary_caregiver_has_barrier ?primary_caregiver ?identified_barrier)
        (not
          (barrier_flagged ?identified_barrier)
        )
        (not
          (barrier_referred ?identified_barrier)
        )
      )
    :effect (barrier_flagged ?identified_barrier)
  )
  (:action plan_primary_caregiver_action_with_staff
    :parameters (?primary_caregiver - primary_caregiver ?identified_barrier - identified_barrier ?staff_member - staff_member)
    :precondition
      (and
        (entity_confirmed ?primary_caregiver)
        (assigned_staff ?primary_caregiver ?staff_member)
        (primary_caregiver_has_barrier ?primary_caregiver ?identified_barrier)
        (barrier_flagged ?identified_barrier)
        (not
          (primary_caregiver_engaged ?primary_caregiver)
        )
      )
    :effect
      (and
        (primary_caregiver_engaged ?primary_caregiver)
        (primary_caregiver_action_planned ?primary_caregiver)
      )
  )
  (:action create_referral_for_primary_caregiver_barrier
    :parameters (?primary_caregiver - primary_caregiver ?identified_barrier - identified_barrier ?referral - referral)
    :precondition
      (and
        (entity_confirmed ?primary_caregiver)
        (primary_caregiver_has_barrier ?primary_caregiver ?identified_barrier)
        (referral_available ?referral)
        (not
          (primary_caregiver_engaged ?primary_caregiver)
        )
      )
    :effect
      (and
        (barrier_referred ?identified_barrier)
        (primary_caregiver_engaged ?primary_caregiver)
        (primary_caregiver_referral ?primary_caregiver ?referral)
        (not
          (referral_available ?referral)
        )
      )
  )
  (:action process_primary_referral_after_assessment
    :parameters (?primary_caregiver - primary_caregiver ?identified_barrier - identified_barrier ?assessment_report - assessment_report ?referral - referral)
    :precondition
      (and
        (entity_confirmed ?primary_caregiver)
        (entity_has_assessment ?primary_caregiver ?assessment_report)
        (primary_caregiver_has_barrier ?primary_caregiver ?identified_barrier)
        (barrier_referred ?identified_barrier)
        (primary_caregiver_referral ?primary_caregiver ?referral)
        (not
          (primary_caregiver_action_planned ?primary_caregiver)
        )
      )
    :effect
      (and
        (barrier_flagged ?identified_barrier)
        (primary_caregiver_action_planned ?primary_caregiver)
        (referral_available ?referral)
        (not
          (primary_caregiver_referral ?primary_caregiver ?referral)
        )
      )
  )
  (:action flag_secondary_identified_need
    :parameters (?secondary_contact - secondary_contact ?identified_need - identified_need ?assessment_report - assessment_report)
    :precondition
      (and
        (entity_confirmed ?secondary_contact)
        (entity_has_assessment ?secondary_contact ?assessment_report)
        (secondary_contact_has_need ?secondary_contact ?identified_need)
        (not
          (need_flagged ?identified_need)
        )
        (not
          (need_referred ?identified_need)
        )
      )
    :effect (need_flagged ?identified_need)
  )
  (:action assign_staff_for_secondary_need
    :parameters (?secondary_contact - secondary_contact ?identified_need - identified_need ?staff_member - staff_member)
    :precondition
      (and
        (entity_confirmed ?secondary_contact)
        (assigned_staff ?secondary_contact ?staff_member)
        (secondary_contact_has_need ?secondary_contact ?identified_need)
        (need_flagged ?identified_need)
        (not
          (secondary_contact_engaged ?secondary_contact)
        )
      )
    :effect
      (and
        (secondary_contact_engaged ?secondary_contact)
        (secondary_contact_action_planned ?secondary_contact)
      )
  )
  (:action create_referral_for_secondary_contact_need
    :parameters (?secondary_contact - secondary_contact ?identified_need - identified_need ?referral - referral)
    :precondition
      (and
        (entity_confirmed ?secondary_contact)
        (secondary_contact_has_need ?secondary_contact ?identified_need)
        (referral_available ?referral)
        (not
          (secondary_contact_engaged ?secondary_contact)
        )
      )
    :effect
      (and
        (need_referred ?identified_need)
        (secondary_contact_engaged ?secondary_contact)
        (secondary_contact_referral ?secondary_contact ?referral)
        (not
          (referral_available ?referral)
        )
      )
  )
  (:action process_secondary_referral_after_assessment
    :parameters (?secondary_contact - secondary_contact ?identified_need - identified_need ?assessment_report - assessment_report ?referral - referral)
    :precondition
      (and
        (entity_confirmed ?secondary_contact)
        (entity_has_assessment ?secondary_contact ?assessment_report)
        (secondary_contact_has_need ?secondary_contact ?identified_need)
        (need_referred ?identified_need)
        (secondary_contact_referral ?secondary_contact ?referral)
        (not
          (secondary_contact_action_planned ?secondary_contact)
        )
      )
    :effect
      (and
        (need_flagged ?identified_need)
        (secondary_contact_action_planned ?secondary_contact)
        (referral_available ?referral)
        (not
          (secondary_contact_referral ?secondary_contact ?referral)
        )
      )
  )
  (:action assemble_support_plan_document
    :parameters (?primary_caregiver - primary_caregiver ?secondary_contact - secondary_contact ?identified_barrier - identified_barrier ?identified_need - identified_need ?support_plan_document - support_plan_document)
    :precondition
      (and
        (primary_caregiver_engaged ?primary_caregiver)
        (secondary_contact_engaged ?secondary_contact)
        (primary_caregiver_has_barrier ?primary_caregiver ?identified_barrier)
        (secondary_contact_has_need ?secondary_contact ?identified_need)
        (barrier_flagged ?identified_barrier)
        (need_flagged ?identified_need)
        (primary_caregiver_action_planned ?primary_caregiver)
        (secondary_contact_action_planned ?secondary_contact)
        (plan_document_pending ?support_plan_document)
      )
    :effect
      (and
        (plan_document_created ?support_plan_document)
        (plan_addresses_barrier ?support_plan_document ?identified_barrier)
        (plan_addresses_need ?support_plan_document ?identified_need)
        (not
          (plan_document_pending ?support_plan_document)
        )
      )
  )
  (:action assemble_support_plan_document_with_referrals
    :parameters (?primary_caregiver - primary_caregiver ?secondary_contact - secondary_contact ?identified_barrier - identified_barrier ?identified_need - identified_need ?support_plan_document - support_plan_document)
    :precondition
      (and
        (primary_caregiver_engaged ?primary_caregiver)
        (secondary_contact_engaged ?secondary_contact)
        (primary_caregiver_has_barrier ?primary_caregiver ?identified_barrier)
        (secondary_contact_has_need ?secondary_contact ?identified_need)
        (barrier_referred ?identified_barrier)
        (need_flagged ?identified_need)
        (not
          (primary_caregiver_action_planned ?primary_caregiver)
        )
        (secondary_contact_action_planned ?secondary_contact)
        (plan_document_pending ?support_plan_document)
      )
    :effect
      (and
        (plan_document_created ?support_plan_document)
        (plan_addresses_barrier ?support_plan_document ?identified_barrier)
        (plan_addresses_need ?support_plan_document ?identified_need)
        (plan_document_reviewed_by_coordinator ?support_plan_document)
        (not
          (plan_document_pending ?support_plan_document)
        )
      )
  )
  (:action assemble_support_plan_document_with_authority_review
    :parameters (?primary_caregiver - primary_caregiver ?secondary_contact - secondary_contact ?identified_barrier - identified_barrier ?identified_need - identified_need ?support_plan_document - support_plan_document)
    :precondition
      (and
        (primary_caregiver_engaged ?primary_caregiver)
        (secondary_contact_engaged ?secondary_contact)
        (primary_caregiver_has_barrier ?primary_caregiver ?identified_barrier)
        (secondary_contact_has_need ?secondary_contact ?identified_need)
        (barrier_flagged ?identified_barrier)
        (need_referred ?identified_need)
        (primary_caregiver_action_planned ?primary_caregiver)
        (not
          (secondary_contact_action_planned ?secondary_contact)
        )
        (plan_document_pending ?support_plan_document)
      )
    :effect
      (and
        (plan_document_created ?support_plan_document)
        (plan_addresses_barrier ?support_plan_document ?identified_barrier)
        (plan_addresses_need ?support_plan_document ?identified_need)
        (plan_document_reviewed_by_authority ?support_plan_document)
        (not
          (plan_document_pending ?support_plan_document)
        )
      )
  )
  (:action assemble_support_plan_document_full_review
    :parameters (?primary_caregiver - primary_caregiver ?secondary_contact - secondary_contact ?identified_barrier - identified_barrier ?identified_need - identified_need ?support_plan_document - support_plan_document)
    :precondition
      (and
        (primary_caregiver_engaged ?primary_caregiver)
        (secondary_contact_engaged ?secondary_contact)
        (primary_caregiver_has_barrier ?primary_caregiver ?identified_barrier)
        (secondary_contact_has_need ?secondary_contact ?identified_need)
        (barrier_referred ?identified_barrier)
        (need_referred ?identified_need)
        (not
          (primary_caregiver_action_planned ?primary_caregiver)
        )
        (not
          (secondary_contact_action_planned ?secondary_contact)
        )
        (plan_document_pending ?support_plan_document)
      )
    :effect
      (and
        (plan_document_created ?support_plan_document)
        (plan_addresses_barrier ?support_plan_document ?identified_barrier)
        (plan_addresses_need ?support_plan_document ?identified_need)
        (plan_document_reviewed_by_coordinator ?support_plan_document)
        (plan_document_reviewed_by_authority ?support_plan_document)
        (not
          (plan_document_pending ?support_plan_document)
        )
      )
  )
  (:action finalize_support_plan_document
    :parameters (?support_plan_document - support_plan_document ?primary_caregiver - primary_caregiver ?assessment_report - assessment_report)
    :precondition
      (and
        (plan_document_created ?support_plan_document)
        (primary_caregiver_engaged ?primary_caregiver)
        (entity_has_assessment ?primary_caregiver ?assessment_report)
        (not
          (plan_document_finalized ?support_plan_document)
        )
      )
    :effect (plan_document_finalized ?support_plan_document)
  )
  (:action attach_document_packet_to_plan
    :parameters (?case_coordinator - case_coordinator ?document_packet - document_packet ?support_plan_document - support_plan_document)
    :precondition
      (and
        (entity_confirmed ?case_coordinator)
        (coordinator_has_plan_document ?case_coordinator ?support_plan_document)
        (coordinator_has_document_packet ?case_coordinator ?document_packet)
        (document_packet_available ?document_packet)
        (plan_document_created ?support_plan_document)
        (plan_document_finalized ?support_plan_document)
        (not
          (document_packet_processed ?document_packet)
        )
      )
    :effect
      (and
        (document_packet_processed ?document_packet)
        (document_packet_attached_to_plan ?document_packet ?support_plan_document)
        (not
          (document_packet_available ?document_packet)
        )
      )
  )
  (:action authorize_coordinator_for_intervention
    :parameters (?case_coordinator - case_coordinator ?document_packet - document_packet ?support_plan_document - support_plan_document ?assessment_report - assessment_report)
    :precondition
      (and
        (entity_confirmed ?case_coordinator)
        (coordinator_has_document_packet ?case_coordinator ?document_packet)
        (document_packet_processed ?document_packet)
        (document_packet_attached_to_plan ?document_packet ?support_plan_document)
        (entity_has_assessment ?case_coordinator ?assessment_report)
        (not
          (plan_document_reviewed_by_coordinator ?support_plan_document)
        )
        (not
          (coordinator_authorized_for_intervention ?case_coordinator)
        )
      )
    :effect (coordinator_authorized_for_intervention ?case_coordinator)
  )
  (:action select_intervention_option
    :parameters (?case_coordinator - case_coordinator ?intervention_option - intervention_option)
    :precondition
      (and
        (entity_confirmed ?case_coordinator)
        (intervention_option_available ?intervention_option)
        (not
          (coordinator_intervention_option_requested ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_intervention_option_requested ?case_coordinator)
        (coordinator_selected_intervention_option ?case_coordinator ?intervention_option)
        (not
          (intervention_option_available ?intervention_option)
        )
      )
  )
  (:action confirm_intervention_option_and_authorize
    :parameters (?case_coordinator - case_coordinator ?document_packet - document_packet ?support_plan_document - support_plan_document ?assessment_report - assessment_report ?intervention_option - intervention_option)
    :precondition
      (and
        (entity_confirmed ?case_coordinator)
        (coordinator_has_document_packet ?case_coordinator ?document_packet)
        (document_packet_processed ?document_packet)
        (document_packet_attached_to_plan ?document_packet ?support_plan_document)
        (entity_has_assessment ?case_coordinator ?assessment_report)
        (plan_document_reviewed_by_coordinator ?support_plan_document)
        (coordinator_intervention_option_requested ?case_coordinator)
        (coordinator_selected_intervention_option ?case_coordinator ?intervention_option)
        (not
          (coordinator_authorized_for_intervention ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_authorized_for_intervention ?case_coordinator)
        (coordinator_intervention_option_confirmed ?case_coordinator)
      )
  )
  (:action initiate_intervention
    :parameters (?case_coordinator - case_coordinator ?specialist_consult - specialist_consult ?staff_member - staff_member ?document_packet - document_packet ?support_plan_document - support_plan_document)
    :precondition
      (and
        (coordinator_authorized_for_intervention ?case_coordinator)
        (coordinator_engaged_specialist ?case_coordinator ?specialist_consult)
        (assigned_staff ?case_coordinator ?staff_member)
        (coordinator_has_document_packet ?case_coordinator ?document_packet)
        (document_packet_attached_to_plan ?document_packet ?support_plan_document)
        (not
          (plan_document_reviewed_by_authority ?support_plan_document)
        )
        (not
          (coordinator_initiated_intervention ?case_coordinator)
        )
      )
    :effect (coordinator_initiated_intervention ?case_coordinator)
  )
  (:action initiate_intervention_after_authority_review
    :parameters (?case_coordinator - case_coordinator ?specialist_consult - specialist_consult ?staff_member - staff_member ?document_packet - document_packet ?support_plan_document - support_plan_document)
    :precondition
      (and
        (coordinator_authorized_for_intervention ?case_coordinator)
        (coordinator_engaged_specialist ?case_coordinator ?specialist_consult)
        (assigned_staff ?case_coordinator ?staff_member)
        (coordinator_has_document_packet ?case_coordinator ?document_packet)
        (document_packet_attached_to_plan ?document_packet ?support_plan_document)
        (plan_document_reviewed_by_authority ?support_plan_document)
        (not
          (coordinator_initiated_intervention ?case_coordinator)
        )
      )
    :effect (coordinator_initiated_intervention ?case_coordinator)
  )
  (:action start_intervention_sequence_after_clinical_input
    :parameters (?case_coordinator - case_coordinator ?clinical_input - clinical_input ?document_packet - document_packet ?support_plan_document - support_plan_document)
    :precondition
      (and
        (coordinator_initiated_intervention ?case_coordinator)
        (coordinator_received_clinical_input ?case_coordinator ?clinical_input)
        (coordinator_has_document_packet ?case_coordinator ?document_packet)
        (document_packet_attached_to_plan ?document_packet ?support_plan_document)
        (not
          (plan_document_reviewed_by_coordinator ?support_plan_document)
        )
        (not
          (plan_document_reviewed_by_authority ?support_plan_document)
        )
        (not
          (coordinator_intervention_sequence_started ?case_coordinator)
        )
      )
    :effect (coordinator_intervention_sequence_started ?case_coordinator)
  )
  (:action start_intervention_sequence_and_prepare_followup
    :parameters (?case_coordinator - case_coordinator ?clinical_input - clinical_input ?document_packet - document_packet ?support_plan_document - support_plan_document)
    :precondition
      (and
        (coordinator_initiated_intervention ?case_coordinator)
        (coordinator_received_clinical_input ?case_coordinator ?clinical_input)
        (coordinator_has_document_packet ?case_coordinator ?document_packet)
        (document_packet_attached_to_plan ?document_packet ?support_plan_document)
        (plan_document_reviewed_by_coordinator ?support_plan_document)
        (not
          (plan_document_reviewed_by_authority ?support_plan_document)
        )
        (not
          (coordinator_intervention_sequence_started ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_intervention_sequence_started ?case_coordinator)
        (coordinator_followup_conditions_met ?case_coordinator)
      )
  )
  (:action start_intervention_sequence_with_authority_review
    :parameters (?case_coordinator - case_coordinator ?clinical_input - clinical_input ?document_packet - document_packet ?support_plan_document - support_plan_document)
    :precondition
      (and
        (coordinator_initiated_intervention ?case_coordinator)
        (coordinator_received_clinical_input ?case_coordinator ?clinical_input)
        (coordinator_has_document_packet ?case_coordinator ?document_packet)
        (document_packet_attached_to_plan ?document_packet ?support_plan_document)
        (not
          (plan_document_reviewed_by_coordinator ?support_plan_document)
        )
        (plan_document_reviewed_by_authority ?support_plan_document)
        (not
          (coordinator_intervention_sequence_started ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_intervention_sequence_started ?case_coordinator)
        (coordinator_followup_conditions_met ?case_coordinator)
      )
  )
  (:action start_intervention_sequence_fully_reviewed
    :parameters (?case_coordinator - case_coordinator ?clinical_input - clinical_input ?document_packet - document_packet ?support_plan_document - support_plan_document)
    :precondition
      (and
        (coordinator_initiated_intervention ?case_coordinator)
        (coordinator_received_clinical_input ?case_coordinator ?clinical_input)
        (coordinator_has_document_packet ?case_coordinator ?document_packet)
        (document_packet_attached_to_plan ?document_packet ?support_plan_document)
        (plan_document_reviewed_by_coordinator ?support_plan_document)
        (plan_document_reviewed_by_authority ?support_plan_document)
        (not
          (coordinator_intervention_sequence_started ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_intervention_sequence_started ?case_coordinator)
        (coordinator_followup_conditions_met ?case_coordinator)
      )
  )
  (:action complete_intervention_and_flag_case_for_followup
    :parameters (?case_coordinator - case_coordinator)
    :precondition
      (and
        (coordinator_intervention_sequence_started ?case_coordinator)
        (not
          (coordinator_followup_conditions_met ?case_coordinator)
        )
        (not
          (coordinator_case_completed ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_case_completed ?case_coordinator)
        (entity_ready_for_followup ?case_coordinator)
      )
  )
  (:action assign_follow_up_task_to_coordinator
    :parameters (?case_coordinator - case_coordinator ?follow_up_task - follow_up_task)
    :precondition
      (and
        (coordinator_intervention_sequence_started ?case_coordinator)
        (coordinator_followup_conditions_met ?case_coordinator)
        (follow_up_task_available ?follow_up_task)
      )
    :effect
      (and
        (coordinator_assigned_follow_up ?case_coordinator ?follow_up_task)
        (not
          (follow_up_task_available ?follow_up_task)
        )
      )
  )
  (:action commit_intervention_and_create_execution_task
    :parameters (?case_coordinator - case_coordinator ?primary_caregiver - primary_caregiver ?secondary_contact - secondary_contact ?assessment_report - assessment_report ?follow_up_task - follow_up_task)
    :precondition
      (and
        (coordinator_intervention_sequence_started ?case_coordinator)
        (coordinator_followup_conditions_met ?case_coordinator)
        (coordinator_assigned_follow_up ?case_coordinator ?follow_up_task)
        (coordinator_linked_primary_caregiver ?case_coordinator ?primary_caregiver)
        (coordinator_linked_secondary_contact ?case_coordinator ?secondary_contact)
        (primary_caregiver_action_planned ?primary_caregiver)
        (secondary_contact_action_planned ?secondary_contact)
        (entity_has_assessment ?case_coordinator ?assessment_report)
        (not
          (coordinator_intervention_committed ?case_coordinator)
        )
      )
    :effect (coordinator_intervention_committed ?case_coordinator)
  )
  (:action finalize_intervention_sequence
    :parameters (?case_coordinator - case_coordinator)
    :precondition
      (and
        (coordinator_intervention_sequence_started ?case_coordinator)
        (coordinator_intervention_committed ?case_coordinator)
        (not
          (coordinator_case_completed ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_case_completed ?case_coordinator)
        (entity_ready_for_followup ?case_coordinator)
      )
  )
  (:action escalate_to_external_authority
    :parameters (?case_coordinator - case_coordinator ?external_authority - external_authority ?assessment_report - assessment_report)
    :precondition
      (and
        (entity_confirmed ?case_coordinator)
        (entity_has_assessment ?case_coordinator ?assessment_report)
        (external_authority_available ?external_authority)
        (coordinator_linked_external_authority ?case_coordinator ?external_authority)
        (not
          (coordinator_escalation_requested ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_escalation_requested ?case_coordinator)
        (not
          (external_authority_available ?external_authority)
        )
      )
  )
  (:action approve_escalation_by_staff
    :parameters (?case_coordinator - case_coordinator ?staff_member - staff_member)
    :precondition
      (and
        (coordinator_escalation_requested ?case_coordinator)
        (assigned_staff ?case_coordinator ?staff_member)
        (not
          (coordinator_escalation_approved_by_staff ?case_coordinator)
        )
      )
    :effect (coordinator_escalation_approved_by_staff ?case_coordinator)
  )
  (:action approve_escalation_by_clinician
    :parameters (?case_coordinator - case_coordinator ?clinical_input - clinical_input)
    :precondition
      (and
        (coordinator_escalation_approved_by_staff ?case_coordinator)
        (coordinator_received_clinical_input ?case_coordinator ?clinical_input)
        (not
          (coordinator_escalation_approved_by_clinical_input ?case_coordinator)
        )
      )
    :effect (coordinator_escalation_approved_by_clinical_input ?case_coordinator)
  )
  (:action finalize_escalation_and_mark_case_ready
    :parameters (?case_coordinator - case_coordinator)
    :precondition
      (and
        (coordinator_escalation_approved_by_clinical_input ?case_coordinator)
        (not
          (coordinator_case_completed ?case_coordinator)
        )
      )
    :effect
      (and
        (coordinator_case_completed ?case_coordinator)
        (entity_ready_for_followup ?case_coordinator)
      )
  )
  (:action record_primary_caregiver_completion
    :parameters (?primary_caregiver - primary_caregiver ?support_plan_document - support_plan_document)
    :precondition
      (and
        (primary_caregiver_engaged ?primary_caregiver)
        (primary_caregiver_action_planned ?primary_caregiver)
        (plan_document_created ?support_plan_document)
        (plan_document_finalized ?support_plan_document)
        (not
          (entity_ready_for_followup ?primary_caregiver)
        )
      )
    :effect (entity_ready_for_followup ?primary_caregiver)
  )
  (:action record_secondary_contact_completion
    :parameters (?secondary_contact - secondary_contact ?support_plan_document - support_plan_document)
    :precondition
      (and
        (secondary_contact_engaged ?secondary_contact)
        (secondary_contact_action_planned ?secondary_contact)
        (plan_document_created ?support_plan_document)
        (plan_document_finalized ?support_plan_document)
        (not
          (entity_ready_for_followup ?secondary_contact)
        )
      )
    :effect (entity_ready_for_followup ?secondary_contact)
  )
  (:action document_caregiver_followthrough
    :parameters (?case_record - case_record ?external_reference - external_reference ?assessment_report - assessment_report)
    :precondition
      (and
        (entity_ready_for_followup ?case_record)
        (entity_has_assessment ?case_record ?assessment_report)
        (external_reference_available ?external_reference)
        (not
          (entity_followthrough_documented ?case_record)
        )
      )
    :effect
      (and
        (entity_followthrough_documented ?case_record)
        (case_has_external_reference ?case_record ?external_reference)
        (not
          (external_reference_available ?external_reference)
        )
      )
  )
  (:action finalize_primary_caregiver_closure_and_release_service
    :parameters (?primary_caregiver - primary_caregiver ?support_service - support_service ?external_reference - external_reference)
    :precondition
      (and
        (entity_followthrough_documented ?primary_caregiver)
        (case_assigned_service ?primary_caregiver ?support_service)
        (case_has_external_reference ?primary_caregiver ?external_reference)
        (not
          (entity_closed ?primary_caregiver)
        )
      )
    :effect
      (and
        (entity_closed ?primary_caregiver)
        (support_service_available ?support_service)
        (external_reference_available ?external_reference)
      )
  )
  (:action finalize_secondary_contact_closure_and_release_service
    :parameters (?secondary_contact - secondary_contact ?support_service - support_service ?external_reference - external_reference)
    :precondition
      (and
        (entity_followthrough_documented ?secondary_contact)
        (case_assigned_service ?secondary_contact ?support_service)
        (case_has_external_reference ?secondary_contact ?external_reference)
        (not
          (entity_closed ?secondary_contact)
        )
      )
    :effect
      (and
        (entity_closed ?secondary_contact)
        (support_service_available ?support_service)
        (external_reference_available ?external_reference)
      )
  )
  (:action finalize_case_closure_and_release_service_by_coordinator
    :parameters (?case_coordinator - case_coordinator ?support_service - support_service ?external_reference - external_reference)
    :precondition
      (and
        (entity_followthrough_documented ?case_coordinator)
        (case_assigned_service ?case_coordinator ?support_service)
        (case_has_external_reference ?case_coordinator ?external_reference)
        (not
          (entity_closed ?case_coordinator)
        )
      )
    :effect
      (and
        (entity_closed ?case_coordinator)
        (support_service_available ?support_service)
        (external_reference_available ?external_reference)
      )
  )
)

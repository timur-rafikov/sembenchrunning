(define (domain advisor_meeting_sequence_degree_progress)
  (:requirements :strips :typing :negative-preconditions)
  (:types advising_entity_type - object resource_artifact - object case_attribute_type - object advising_case_root - object case_participant - advising_case_root advisor_staff_member - advising_entity_type appointment_slot - advising_entity_type support_contact - advising_entity_type resource_category - advising_entity_type intervention_package - advising_entity_type accommodation_request - advising_entity_type service_provider - advising_entity_type community_partner - advising_entity_type support_service - resource_artifact student_document - resource_artifact department_unit - resource_artifact student_issue_tag - case_attribute_type student_concern_tag - case_attribute_type case_file - case_attribute_type advisor_group - case_participant advising_case_group - case_participant primary_advisor - advisor_group secondary_advisor - advisor_group advising_case_record - advising_case_group)
  (:predicates
    (advising_case_open ?case_participant - case_participant)
    (appointment_confirmation_recorded_for_entity ?case_participant - case_participant)
    (advisor_assigned ?case_participant - case_participant)
    (followup_completed ?case_participant - case_participant)
    (case_followup_confirmed ?case_participant - case_participant)
    (accommodation_assigned ?case_participant - case_participant)
    (advisor_available ?advisor_staff_member - advisor_staff_member)
    (assigned_advisor ?case_participant - case_participant ?advisor_staff_member - advisor_staff_member)
    (appointment_slot_available ?appointment_slot - appointment_slot)
    (appointment_booked_for_entity ?case_participant - case_participant ?appointment_slot - appointment_slot)
    (support_contact_available ?support_contact - support_contact)
    (contact_linked_to_case ?case_participant - case_participant ?support_contact - support_contact)
    (support_service_available ?support_service - support_service)
    (primary_advisor_referred_service ?primary_advisor - primary_advisor ?support_service - support_service)
    (secondary_advisor_referred_service ?secondary_advisor - secondary_advisor ?support_service - support_service)
    (participant_has_issue_tag ?primary_advisor - primary_advisor ?student_issue_tag - student_issue_tag)
    (issue_flag_primary ?student_issue_tag - student_issue_tag)
    (issue_flag_referred ?student_issue_tag - student_issue_tag)
    (primary_advisor_triage_recorded ?primary_advisor - primary_advisor)
    (advisor_has_concern_tag ?secondary_advisor - secondary_advisor ?student_concern_tag - student_concern_tag)
    (concern_flag_secondary ?student_concern_tag - student_concern_tag)
    (concern_referral_set ?student_concern_tag - student_concern_tag)
    (secondary_advisor_triage_recorded ?secondary_advisor - secondary_advisor)
    (case_file_available ?case_file - case_file)
    (case_file_compiled ?case_file - case_file)
    (case_file_has_issue_tag ?case_file - case_file ?student_issue_tag - student_issue_tag)
    (case_file_has_concern_tag ?case_file - case_file ?student_concern_tag - student_concern_tag)
    (case_file_flag_provider_review ?case_file - case_file)
    (case_file_flag_department_review ?case_file - case_file)
    (case_file_reviewed ?case_file - case_file)
    (advising_case_record_has_primary_advisor ?advising_case_record - advising_case_record ?primary_advisor - primary_advisor)
    (advising_case_record_has_secondary_advisor ?advising_case_record - advising_case_record ?secondary_advisor - secondary_advisor)
    (advising_case_record_has_case_file ?advising_case_record - advising_case_record ?case_file - case_file)
    (document_available ?student_document - student_document)
    (advising_case_record_linked_document ?advising_case_record - advising_case_record ?student_document - student_document)
    (document_verified ?student_document - student_document)
    (document_linked_to_case_file ?student_document - student_document ?case_file - case_file)
    (provider_engagement_initiated ?advising_case_record - advising_case_record)
    (provider_response_recorded ?advising_case_record - advising_case_record)
    (provider_confirmation_received ?advising_case_record - advising_case_record)
    (department_escalation_requested ?advising_case_record - advising_case_record)
    (department_followup_recorded ?advising_case_record - advising_case_record)
    (action_plan_assigned ?advising_case_record - advising_case_record)
    (action_plan_coordinated ?advising_case_record - advising_case_record)
    (department_unit_available ?department_unit - department_unit)
    (case_record_escalated_to_department ?advising_case_record - advising_case_record ?department_unit - department_unit)
    (department_response_recorded ?advising_case_record - advising_case_record)
    (department_contacted ?advising_case_record - advising_case_record)
    (department_review_completed ?advising_case_record - advising_case_record)
    (resource_category_available ?resource_category - resource_category)
    (advising_case_record_has_resource_category ?advising_case_record - advising_case_record ?resource_category - resource_category)
    (intervention_package_available ?intervention_package - intervention_package)
    (advising_case_record_has_intervention ?advising_case_record - advising_case_record ?intervention_package - intervention_package)
    (service_provider_available ?service_provider - service_provider)
    (advising_case_record_has_service_provider ?advising_case_record - advising_case_record ?service_provider - service_provider)
    (community_partner_available ?community_partner - community_partner)
    (advising_case_record_has_community_partner ?advising_case_record - advising_case_record ?community_partner - community_partner)
    (accommodation_request_available ?accommodation_request - accommodation_request)
    (participant_linked_to_accommodation_request ?case_participant - case_participant ?accommodation_request - accommodation_request)
    (primary_advisor_action_taken ?primary_advisor - primary_advisor)
    (secondary_advisor_action_taken ?secondary_advisor - secondary_advisor)
    (advising_case_record_finalized ?advising_case_record - advising_case_record)
  )
  (:action open_advising_case
    :parameters (?case_participant - case_participant)
    :precondition
      (and
        (not
          (advising_case_open ?case_participant)
        )
        (not
          (followup_completed ?case_participant)
        )
      )
    :effect (advising_case_open ?case_participant)
  )
  (:action assign_available_advisor
    :parameters (?case_participant - case_participant ?advisor_staff_member - advisor_staff_member)
    :precondition
      (and
        (advising_case_open ?case_participant)
        (not
          (advisor_assigned ?case_participant)
        )
        (advisor_available ?advisor_staff_member)
      )
    :effect
      (and
        (advisor_assigned ?case_participant)
        (assigned_advisor ?case_participant ?advisor_staff_member)
        (not
          (advisor_available ?advisor_staff_member)
        )
      )
  )
  (:action reserve_appointment_slot
    :parameters (?case_participant - case_participant ?appointment_slot - appointment_slot)
    :precondition
      (and
        (advising_case_open ?case_participant)
        (advisor_assigned ?case_participant)
        (appointment_slot_available ?appointment_slot)
      )
    :effect
      (and
        (appointment_booked_for_entity ?case_participant ?appointment_slot)
        (not
          (appointment_slot_available ?appointment_slot)
        )
      )
  )
  (:action confirm_appointment
    :parameters (?case_participant - case_participant ?appointment_slot - appointment_slot)
    :precondition
      (and
        (advising_case_open ?case_participant)
        (advisor_assigned ?case_participant)
        (appointment_booked_for_entity ?case_participant ?appointment_slot)
        (not
          (appointment_confirmation_recorded_for_entity ?case_participant)
        )
      )
    :effect (appointment_confirmation_recorded_for_entity ?case_participant)
  )
  (:action cancel_scheduled_appointment
    :parameters (?case_participant - case_participant ?appointment_slot - appointment_slot)
    :precondition
      (and
        (appointment_booked_for_entity ?case_participant ?appointment_slot)
      )
    :effect
      (and
        (appointment_slot_available ?appointment_slot)
        (not
          (appointment_booked_for_entity ?case_participant ?appointment_slot)
        )
      )
  )
  (:action associate_support_contact
    :parameters (?case_participant - case_participant ?support_contact - support_contact)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?case_participant)
        (support_contact_available ?support_contact)
      )
    :effect
      (and
        (contact_linked_to_case ?case_participant ?support_contact)
        (not
          (support_contact_available ?support_contact)
        )
      )
  )
  (:action unassociate_support_contact
    :parameters (?case_participant - case_participant ?support_contact - support_contact)
    :precondition
      (and
        (contact_linked_to_case ?case_participant ?support_contact)
      )
    :effect
      (and
        (support_contact_available ?support_contact)
        (not
          (contact_linked_to_case ?case_participant ?support_contact)
        )
      )
  )
  (:action engage_service_provider
    :parameters (?advising_case_record - advising_case_record ?service_provider - service_provider)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?advising_case_record)
        (service_provider_available ?service_provider)
      )
    :effect
      (and
        (advising_case_record_has_service_provider ?advising_case_record ?service_provider)
        (not
          (service_provider_available ?service_provider)
        )
      )
  )
  (:action disengage_service_provider
    :parameters (?advising_case_record - advising_case_record ?service_provider - service_provider)
    :precondition
      (and
        (advising_case_record_has_service_provider ?advising_case_record ?service_provider)
      )
    :effect
      (and
        (service_provider_available ?service_provider)
        (not
          (advising_case_record_has_service_provider ?advising_case_record ?service_provider)
        )
      )
  )
  (:action engage_community_partner
    :parameters (?advising_case_record - advising_case_record ?community_partner - community_partner)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?advising_case_record)
        (community_partner_available ?community_partner)
      )
    :effect
      (and
        (advising_case_record_has_community_partner ?advising_case_record ?community_partner)
        (not
          (community_partner_available ?community_partner)
        )
      )
  )
  (:action disengage_community_partner
    :parameters (?advising_case_record - advising_case_record ?community_partner - community_partner)
    :precondition
      (and
        (advising_case_record_has_community_partner ?advising_case_record ?community_partner)
      )
    :effect
      (and
        (community_partner_available ?community_partner)
        (not
          (advising_case_record_has_community_partner ?advising_case_record ?community_partner)
        )
      )
  )
  (:action flag_issue_for_primary_triage
    :parameters (?primary_advisor - primary_advisor ?student_issue_tag - student_issue_tag ?appointment_slot - appointment_slot)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?primary_advisor)
        (appointment_booked_for_entity ?primary_advisor ?appointment_slot)
        (participant_has_issue_tag ?primary_advisor ?student_issue_tag)
        (not
          (issue_flag_primary ?student_issue_tag)
        )
        (not
          (issue_flag_referred ?student_issue_tag)
        )
      )
    :effect (issue_flag_primary ?student_issue_tag)
  )
  (:action consult_support_contact_for_issue
    :parameters (?primary_advisor - primary_advisor ?student_issue_tag - student_issue_tag ?support_contact - support_contact)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?primary_advisor)
        (contact_linked_to_case ?primary_advisor ?support_contact)
        (participant_has_issue_tag ?primary_advisor ?student_issue_tag)
        (issue_flag_primary ?student_issue_tag)
        (not
          (primary_advisor_action_taken ?primary_advisor)
        )
      )
    :effect
      (and
        (primary_advisor_action_taken ?primary_advisor)
        (primary_advisor_triage_recorded ?primary_advisor)
      )
  )
  (:action refer_support_service_for_issue
    :parameters (?primary_advisor - primary_advisor ?student_issue_tag - student_issue_tag ?support_service - support_service)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?primary_advisor)
        (participant_has_issue_tag ?primary_advisor ?student_issue_tag)
        (support_service_available ?support_service)
        (not
          (primary_advisor_action_taken ?primary_advisor)
        )
      )
    :effect
      (and
        (issue_flag_referred ?student_issue_tag)
        (primary_advisor_action_taken ?primary_advisor)
        (primary_advisor_referred_service ?primary_advisor ?support_service)
        (not
          (support_service_available ?support_service)
        )
      )
  )
  (:action record_primary_triage_outcome
    :parameters (?primary_advisor - primary_advisor ?student_issue_tag - student_issue_tag ?appointment_slot - appointment_slot ?support_service - support_service)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?primary_advisor)
        (appointment_booked_for_entity ?primary_advisor ?appointment_slot)
        (participant_has_issue_tag ?primary_advisor ?student_issue_tag)
        (issue_flag_referred ?student_issue_tag)
        (primary_advisor_referred_service ?primary_advisor ?support_service)
        (not
          (primary_advisor_triage_recorded ?primary_advisor)
        )
      )
    :effect
      (and
        (issue_flag_primary ?student_issue_tag)
        (primary_advisor_triage_recorded ?primary_advisor)
        (support_service_available ?support_service)
        (not
          (primary_advisor_referred_service ?primary_advisor ?support_service)
        )
      )
  )
  (:action flag_concern_for_secondary_triage
    :parameters (?secondary_advisor - secondary_advisor ?student_concern_tag - student_concern_tag ?appointment_slot - appointment_slot)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?secondary_advisor)
        (appointment_booked_for_entity ?secondary_advisor ?appointment_slot)
        (advisor_has_concern_tag ?secondary_advisor ?student_concern_tag)
        (not
          (concern_flag_secondary ?student_concern_tag)
        )
        (not
          (concern_referral_set ?student_concern_tag)
        )
      )
    :effect (concern_flag_secondary ?student_concern_tag)
  )
  (:action consult_support_contact_for_concern
    :parameters (?secondary_advisor - secondary_advisor ?student_concern_tag - student_concern_tag ?support_contact - support_contact)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?secondary_advisor)
        (contact_linked_to_case ?secondary_advisor ?support_contact)
        (advisor_has_concern_tag ?secondary_advisor ?student_concern_tag)
        (concern_flag_secondary ?student_concern_tag)
        (not
          (secondary_advisor_action_taken ?secondary_advisor)
        )
      )
    :effect
      (and
        (secondary_advisor_action_taken ?secondary_advisor)
        (secondary_advisor_triage_recorded ?secondary_advisor)
      )
  )
  (:action refer_support_service_for_concern
    :parameters (?secondary_advisor - secondary_advisor ?student_concern_tag - student_concern_tag ?support_service - support_service)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?secondary_advisor)
        (advisor_has_concern_tag ?secondary_advisor ?student_concern_tag)
        (support_service_available ?support_service)
        (not
          (secondary_advisor_action_taken ?secondary_advisor)
        )
      )
    :effect
      (and
        (concern_referral_set ?student_concern_tag)
        (secondary_advisor_action_taken ?secondary_advisor)
        (secondary_advisor_referred_service ?secondary_advisor ?support_service)
        (not
          (support_service_available ?support_service)
        )
      )
  )
  (:action record_secondary_triage_outcome
    :parameters (?secondary_advisor - secondary_advisor ?student_concern_tag - student_concern_tag ?appointment_slot - appointment_slot ?support_service - support_service)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?secondary_advisor)
        (appointment_booked_for_entity ?secondary_advisor ?appointment_slot)
        (advisor_has_concern_tag ?secondary_advisor ?student_concern_tag)
        (concern_referral_set ?student_concern_tag)
        (secondary_advisor_referred_service ?secondary_advisor ?support_service)
        (not
          (secondary_advisor_triage_recorded ?secondary_advisor)
        )
      )
    :effect
      (and
        (concern_flag_secondary ?student_concern_tag)
        (secondary_advisor_triage_recorded ?secondary_advisor)
        (support_service_available ?support_service)
        (not
          (secondary_advisor_referred_service ?secondary_advisor ?support_service)
        )
      )
  )
  (:action assemble_case_file
    :parameters (?primary_advisor - primary_advisor ?secondary_advisor - secondary_advisor ?student_issue_tag - student_issue_tag ?student_concern_tag - student_concern_tag ?case_file - case_file)
    :precondition
      (and
        (primary_advisor_action_taken ?primary_advisor)
        (secondary_advisor_action_taken ?secondary_advisor)
        (participant_has_issue_tag ?primary_advisor ?student_issue_tag)
        (advisor_has_concern_tag ?secondary_advisor ?student_concern_tag)
        (issue_flag_primary ?student_issue_tag)
        (concern_flag_secondary ?student_concern_tag)
        (primary_advisor_triage_recorded ?primary_advisor)
        (secondary_advisor_triage_recorded ?secondary_advisor)
        (case_file_available ?case_file)
      )
    :effect
      (and
        (case_file_compiled ?case_file)
        (case_file_has_issue_tag ?case_file ?student_issue_tag)
        (case_file_has_concern_tag ?case_file ?student_concern_tag)
        (not
          (case_file_available ?case_file)
        )
      )
  )
  (:action assemble_case_file_for_provider_review
    :parameters (?primary_advisor - primary_advisor ?secondary_advisor - secondary_advisor ?student_issue_tag - student_issue_tag ?student_concern_tag - student_concern_tag ?case_file - case_file)
    :precondition
      (and
        (primary_advisor_action_taken ?primary_advisor)
        (secondary_advisor_action_taken ?secondary_advisor)
        (participant_has_issue_tag ?primary_advisor ?student_issue_tag)
        (advisor_has_concern_tag ?secondary_advisor ?student_concern_tag)
        (issue_flag_referred ?student_issue_tag)
        (concern_flag_secondary ?student_concern_tag)
        (not
          (primary_advisor_triage_recorded ?primary_advisor)
        )
        (secondary_advisor_triage_recorded ?secondary_advisor)
        (case_file_available ?case_file)
      )
    :effect
      (and
        (case_file_compiled ?case_file)
        (case_file_has_issue_tag ?case_file ?student_issue_tag)
        (case_file_has_concern_tag ?case_file ?student_concern_tag)
        (case_file_flag_provider_review ?case_file)
        (not
          (case_file_available ?case_file)
        )
      )
  )
  (:action assemble_case_file_for_department_review
    :parameters (?primary_advisor - primary_advisor ?secondary_advisor - secondary_advisor ?student_issue_tag - student_issue_tag ?student_concern_tag - student_concern_tag ?case_file - case_file)
    :precondition
      (and
        (primary_advisor_action_taken ?primary_advisor)
        (secondary_advisor_action_taken ?secondary_advisor)
        (participant_has_issue_tag ?primary_advisor ?student_issue_tag)
        (advisor_has_concern_tag ?secondary_advisor ?student_concern_tag)
        (issue_flag_primary ?student_issue_tag)
        (concern_referral_set ?student_concern_tag)
        (primary_advisor_triage_recorded ?primary_advisor)
        (not
          (secondary_advisor_triage_recorded ?secondary_advisor)
        )
        (case_file_available ?case_file)
      )
    :effect
      (and
        (case_file_compiled ?case_file)
        (case_file_has_issue_tag ?case_file ?student_issue_tag)
        (case_file_has_concern_tag ?case_file ?student_concern_tag)
        (case_file_flag_department_review ?case_file)
        (not
          (case_file_available ?case_file)
        )
      )
  )
  (:action assemble_case_file_for_provider_and_department_review
    :parameters (?primary_advisor - primary_advisor ?secondary_advisor - secondary_advisor ?student_issue_tag - student_issue_tag ?student_concern_tag - student_concern_tag ?case_file - case_file)
    :precondition
      (and
        (primary_advisor_action_taken ?primary_advisor)
        (secondary_advisor_action_taken ?secondary_advisor)
        (participant_has_issue_tag ?primary_advisor ?student_issue_tag)
        (advisor_has_concern_tag ?secondary_advisor ?student_concern_tag)
        (issue_flag_referred ?student_issue_tag)
        (concern_referral_set ?student_concern_tag)
        (not
          (primary_advisor_triage_recorded ?primary_advisor)
        )
        (not
          (secondary_advisor_triage_recorded ?secondary_advisor)
        )
        (case_file_available ?case_file)
      )
    :effect
      (and
        (case_file_compiled ?case_file)
        (case_file_has_issue_tag ?case_file ?student_issue_tag)
        (case_file_has_concern_tag ?case_file ?student_concern_tag)
        (case_file_flag_provider_review ?case_file)
        (case_file_flag_department_review ?case_file)
        (not
          (case_file_available ?case_file)
        )
      )
  )
  (:action verify_case_file
    :parameters (?case_file - case_file ?primary_advisor - primary_advisor ?appointment_slot - appointment_slot)
    :precondition
      (and
        (case_file_compiled ?case_file)
        (primary_advisor_action_taken ?primary_advisor)
        (appointment_booked_for_entity ?primary_advisor ?appointment_slot)
        (not
          (case_file_reviewed ?case_file)
        )
      )
    :effect (case_file_reviewed ?case_file)
  )
  (:action review_and_link_document
    :parameters (?advising_case_record - advising_case_record ?student_document - student_document ?case_file - case_file)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?advising_case_record)
        (advising_case_record_has_case_file ?advising_case_record ?case_file)
        (advising_case_record_linked_document ?advising_case_record ?student_document)
        (document_available ?student_document)
        (case_file_compiled ?case_file)
        (case_file_reviewed ?case_file)
        (not
          (document_verified ?student_document)
        )
      )
    :effect
      (and
        (document_verified ?student_document)
        (document_linked_to_case_file ?student_document ?case_file)
        (not
          (document_available ?student_document)
        )
      )
  )
  (:action initiate_provider_engagement_for_record
    :parameters (?advising_case_record - advising_case_record ?student_document - student_document ?case_file - case_file ?appointment_slot - appointment_slot)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?advising_case_record)
        (advising_case_record_linked_document ?advising_case_record ?student_document)
        (document_verified ?student_document)
        (document_linked_to_case_file ?student_document ?case_file)
        (appointment_booked_for_entity ?advising_case_record ?appointment_slot)
        (not
          (case_file_flag_provider_review ?case_file)
        )
        (not
          (provider_engagement_initiated ?advising_case_record)
        )
      )
    :effect (provider_engagement_initiated ?advising_case_record)
  )
  (:action link_resource_category_to_record
    :parameters (?advising_case_record - advising_case_record ?resource_category - resource_category)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?advising_case_record)
        (resource_category_available ?resource_category)
        (not
          (department_escalation_requested ?advising_case_record)
        )
      )
    :effect
      (and
        (department_escalation_requested ?advising_case_record)
        (advising_case_record_has_resource_category ?advising_case_record ?resource_category)
        (not
          (resource_category_available ?resource_category)
        )
      )
  )
  (:action confirm_resource_category_and_initiate_engagement
    :parameters (?advising_case_record - advising_case_record ?student_document - student_document ?case_file - case_file ?appointment_slot - appointment_slot ?resource_category - resource_category)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?advising_case_record)
        (advising_case_record_linked_document ?advising_case_record ?student_document)
        (document_verified ?student_document)
        (document_linked_to_case_file ?student_document ?case_file)
        (appointment_booked_for_entity ?advising_case_record ?appointment_slot)
        (case_file_flag_provider_review ?case_file)
        (department_escalation_requested ?advising_case_record)
        (advising_case_record_has_resource_category ?advising_case_record ?resource_category)
        (not
          (provider_engagement_initiated ?advising_case_record)
        )
      )
    :effect
      (and
        (provider_engagement_initiated ?advising_case_record)
        (department_followup_recorded ?advising_case_record)
      )
  )
  (:action record_provider_commitment
    :parameters (?advising_case_record - advising_case_record ?service_provider - service_provider ?support_contact - support_contact ?student_document - student_document ?case_file - case_file)
    :precondition
      (and
        (provider_engagement_initiated ?advising_case_record)
        (advising_case_record_has_service_provider ?advising_case_record ?service_provider)
        (contact_linked_to_case ?advising_case_record ?support_contact)
        (advising_case_record_linked_document ?advising_case_record ?student_document)
        (document_linked_to_case_file ?student_document ?case_file)
        (not
          (case_file_flag_department_review ?case_file)
        )
        (not
          (provider_response_recorded ?advising_case_record)
        )
      )
    :effect (provider_response_recorded ?advising_case_record)
  )
  (:action record_provider_commitment_post_review
    :parameters (?advising_case_record - advising_case_record ?service_provider - service_provider ?support_contact - support_contact ?student_document - student_document ?case_file - case_file)
    :precondition
      (and
        (provider_engagement_initiated ?advising_case_record)
        (advising_case_record_has_service_provider ?advising_case_record ?service_provider)
        (contact_linked_to_case ?advising_case_record ?support_contact)
        (advising_case_record_linked_document ?advising_case_record ?student_document)
        (document_linked_to_case_file ?student_document ?case_file)
        (case_file_flag_department_review ?case_file)
        (not
          (provider_response_recorded ?advising_case_record)
        )
      )
    :effect (provider_response_recorded ?advising_case_record)
  )
  (:action record_provider_confirmation
    :parameters (?advising_case_record - advising_case_record ?community_partner - community_partner ?student_document - student_document ?case_file - case_file)
    :precondition
      (and
        (provider_response_recorded ?advising_case_record)
        (advising_case_record_has_community_partner ?advising_case_record ?community_partner)
        (advising_case_record_linked_document ?advising_case_record ?student_document)
        (document_linked_to_case_file ?student_document ?case_file)
        (not
          (case_file_flag_provider_review ?case_file)
        )
        (not
          (case_file_flag_department_review ?case_file)
        )
        (not
          (provider_confirmation_received ?advising_case_record)
        )
      )
    :effect (provider_confirmation_received ?advising_case_record)
  )
  (:action confirm_provider_and_assign_action_plan
    :parameters (?advising_case_record - advising_case_record ?community_partner - community_partner ?student_document - student_document ?case_file - case_file)
    :precondition
      (and
        (provider_response_recorded ?advising_case_record)
        (advising_case_record_has_community_partner ?advising_case_record ?community_partner)
        (advising_case_record_linked_document ?advising_case_record ?student_document)
        (document_linked_to_case_file ?student_document ?case_file)
        (case_file_flag_provider_review ?case_file)
        (not
          (case_file_flag_department_review ?case_file)
        )
        (not
          (provider_confirmation_received ?advising_case_record)
        )
      )
    :effect
      (and
        (provider_confirmation_received ?advising_case_record)
        (action_plan_assigned ?advising_case_record)
      )
  )
  (:action confirm_provider_and_assign_action_plan_secondary
    :parameters (?advising_case_record - advising_case_record ?community_partner - community_partner ?student_document - student_document ?case_file - case_file)
    :precondition
      (and
        (provider_response_recorded ?advising_case_record)
        (advising_case_record_has_community_partner ?advising_case_record ?community_partner)
        (advising_case_record_linked_document ?advising_case_record ?student_document)
        (document_linked_to_case_file ?student_document ?case_file)
        (not
          (case_file_flag_provider_review ?case_file)
        )
        (case_file_flag_department_review ?case_file)
        (not
          (provider_confirmation_received ?advising_case_record)
        )
      )
    :effect
      (and
        (provider_confirmation_received ?advising_case_record)
        (action_plan_assigned ?advising_case_record)
      )
  )
  (:action confirm_provider_and_assign_action_plan_final
    :parameters (?advising_case_record - advising_case_record ?community_partner - community_partner ?student_document - student_document ?case_file - case_file)
    :precondition
      (and
        (provider_response_recorded ?advising_case_record)
        (advising_case_record_has_community_partner ?advising_case_record ?community_partner)
        (advising_case_record_linked_document ?advising_case_record ?student_document)
        (document_linked_to_case_file ?student_document ?case_file)
        (case_file_flag_provider_review ?case_file)
        (case_file_flag_department_review ?case_file)
        (not
          (provider_confirmation_received ?advising_case_record)
        )
      )
    :effect
      (and
        (provider_confirmation_received ?advising_case_record)
        (action_plan_assigned ?advising_case_record)
      )
  )
  (:action finalize_action_plan
    :parameters (?advising_case_record - advising_case_record)
    :precondition
      (and
        (provider_confirmation_received ?advising_case_record)
        (not
          (action_plan_assigned ?advising_case_record)
        )
        (not
          (advising_case_record_finalized ?advising_case_record)
        )
      )
    :effect
      (and
        (advising_case_record_finalized ?advising_case_record)
        (case_followup_confirmed ?advising_case_record)
      )
  )
  (:action assign_intervention_package
    :parameters (?advising_case_record - advising_case_record ?intervention_package - intervention_package)
    :precondition
      (and
        (provider_confirmation_received ?advising_case_record)
        (action_plan_assigned ?advising_case_record)
        (intervention_package_available ?intervention_package)
      )
    :effect
      (and
        (advising_case_record_has_intervention ?advising_case_record ?intervention_package)
        (not
          (intervention_package_available ?intervention_package)
        )
      )
  )
  (:action coordinate_action_plan
    :parameters (?advising_case_record - advising_case_record ?primary_advisor - primary_advisor ?secondary_advisor - secondary_advisor ?appointment_slot - appointment_slot ?intervention_package - intervention_package)
    :precondition
      (and
        (provider_confirmation_received ?advising_case_record)
        (action_plan_assigned ?advising_case_record)
        (advising_case_record_has_intervention ?advising_case_record ?intervention_package)
        (advising_case_record_has_primary_advisor ?advising_case_record ?primary_advisor)
        (advising_case_record_has_secondary_advisor ?advising_case_record ?secondary_advisor)
        (primary_advisor_triage_recorded ?primary_advisor)
        (secondary_advisor_triage_recorded ?secondary_advisor)
        (appointment_booked_for_entity ?advising_case_record ?appointment_slot)
        (not
          (action_plan_coordinated ?advising_case_record)
        )
      )
    :effect (action_plan_coordinated ?advising_case_record)
  )
  (:action approve_action_plan_and_mark_ready
    :parameters (?advising_case_record - advising_case_record)
    :precondition
      (and
        (provider_confirmation_received ?advising_case_record)
        (action_plan_coordinated ?advising_case_record)
        (not
          (advising_case_record_finalized ?advising_case_record)
        )
      )
    :effect
      (and
        (advising_case_record_finalized ?advising_case_record)
        (case_followup_confirmed ?advising_case_record)
      )
  )
  (:action escalate_case_to_department
    :parameters (?advising_case_record - advising_case_record ?department_unit - department_unit ?appointment_slot - appointment_slot)
    :precondition
      (and
        (appointment_confirmation_recorded_for_entity ?advising_case_record)
        (appointment_booked_for_entity ?advising_case_record ?appointment_slot)
        (department_unit_available ?department_unit)
        (case_record_escalated_to_department ?advising_case_record ?department_unit)
        (not
          (department_response_recorded ?advising_case_record)
        )
      )
    :effect
      (and
        (department_response_recorded ?advising_case_record)
        (not
          (department_unit_available ?department_unit)
        )
      )
  )
  (:action contact_department_unit
    :parameters (?advising_case_record - advising_case_record ?support_contact - support_contact)
    :precondition
      (and
        (department_response_recorded ?advising_case_record)
        (contact_linked_to_case ?advising_case_record ?support_contact)
        (not
          (department_contacted ?advising_case_record)
        )
      )
    :effect (department_contacted ?advising_case_record)
  )
  (:action record_department_response
    :parameters (?advising_case_record - advising_case_record ?community_partner - community_partner)
    :precondition
      (and
        (department_contacted ?advising_case_record)
        (advising_case_record_has_community_partner ?advising_case_record ?community_partner)
        (not
          (department_review_completed ?advising_case_record)
        )
      )
    :effect (department_review_completed ?advising_case_record)
  )
  (:action finalize_department_escalation
    :parameters (?advising_case_record - advising_case_record)
    :precondition
      (and
        (department_review_completed ?advising_case_record)
        (not
          (advising_case_record_finalized ?advising_case_record)
        )
      )
    :effect
      (and
        (advising_case_record_finalized ?advising_case_record)
        (case_followup_confirmed ?advising_case_record)
      )
  )
  (:action primary_advisor_confirm_completion
    :parameters (?primary_advisor - primary_advisor ?case_file - case_file)
    :precondition
      (and
        (primary_advisor_action_taken ?primary_advisor)
        (primary_advisor_triage_recorded ?primary_advisor)
        (case_file_compiled ?case_file)
        (case_file_reviewed ?case_file)
        (not
          (case_followup_confirmed ?primary_advisor)
        )
      )
    :effect (case_followup_confirmed ?primary_advisor)
  )
  (:action secondary_advisor_confirm_completion
    :parameters (?secondary_advisor - secondary_advisor ?case_file - case_file)
    :precondition
      (and
        (secondary_advisor_action_taken ?secondary_advisor)
        (secondary_advisor_triage_recorded ?secondary_advisor)
        (case_file_compiled ?case_file)
        (case_file_reviewed ?case_file)
        (not
          (case_followup_confirmed ?secondary_advisor)
        )
      )
    :effect (case_followup_confirmed ?secondary_advisor)
  )
  (:action activate_accommodation_request
    :parameters (?case_participant - case_participant ?accommodation_request - accommodation_request ?appointment_slot - appointment_slot)
    :precondition
      (and
        (case_followup_confirmed ?case_participant)
        (appointment_booked_for_entity ?case_participant ?appointment_slot)
        (accommodation_request_available ?accommodation_request)
        (not
          (accommodation_assigned ?case_participant)
        )
      )
    :effect
      (and
        (accommodation_assigned ?case_participant)
        (participant_linked_to_accommodation_request ?case_participant ?accommodation_request)
        (not
          (accommodation_request_available ?accommodation_request)
        )
      )
  )
  (:action assign_accommodation_and_notify_primary_advisor
    :parameters (?primary_advisor - primary_advisor ?advisor_staff_member - advisor_staff_member ?accommodation_request - accommodation_request)
    :precondition
      (and
        (accommodation_assigned ?primary_advisor)
        (assigned_advisor ?primary_advisor ?advisor_staff_member)
        (participant_linked_to_accommodation_request ?primary_advisor ?accommodation_request)
        (not
          (followup_completed ?primary_advisor)
        )
      )
    :effect
      (and
        (followup_completed ?primary_advisor)
        (advisor_available ?advisor_staff_member)
        (accommodation_request_available ?accommodation_request)
      )
  )
  (:action assign_accommodation_and_notify_secondary_advisor
    :parameters (?secondary_advisor - secondary_advisor ?advisor_staff_member - advisor_staff_member ?accommodation_request - accommodation_request)
    :precondition
      (and
        (accommodation_assigned ?secondary_advisor)
        (assigned_advisor ?secondary_advisor ?advisor_staff_member)
        (participant_linked_to_accommodation_request ?secondary_advisor ?accommodation_request)
        (not
          (followup_completed ?secondary_advisor)
        )
      )
    :effect
      (and
        (followup_completed ?secondary_advisor)
        (advisor_available ?advisor_staff_member)
        (accommodation_request_available ?accommodation_request)
      )
  )
  (:action assign_accommodation_and_notify_case_record
    :parameters (?advising_case_record - advising_case_record ?advisor_staff_member - advisor_staff_member ?accommodation_request - accommodation_request)
    :precondition
      (and
        (accommodation_assigned ?advising_case_record)
        (assigned_advisor ?advising_case_record ?advisor_staff_member)
        (participant_linked_to_accommodation_request ?advising_case_record ?accommodation_request)
        (not
          (followup_completed ?advising_case_record)
        )
      )
    :effect
      (and
        (followup_completed ?advising_case_record)
        (advisor_available ?advisor_staff_member)
        (accommodation_request_available ?accommodation_request)
      )
  )
)

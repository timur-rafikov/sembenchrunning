(define (domain internship_preparation_advising_plan_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types person - object institutional_entity - object administrative_entity - object human_actor - object student - human_actor employer_contact - person assessment_slot - person support_specialist - person employer_representative - person interview_slot - person accommodation_resource - person accommodation_request_type - person recommender_record - person support_service - institutional_entity document - institutional_entity reference_provider - institutional_entity student_task - administrative_entity coordinator_task - administrative_entity application_packet - administrative_entity operational_role_group_a - student operational_role_group_b - student career_advisor - operational_role_group_a internship_coordinator - operational_role_group_a advising_case - operational_role_group_b)
  (:predicates
    (has_active_advising_case ?student - student)
    (entity_approved_by_advisor ?student - student)
    (student_assignment_record ?student - student)
    (entity_finalized ?student - student)
    (entity_signed_off ?student - student)
    (accommodation_request_recorded ?student - student)
    (employer_contact_available ?employer_contact - employer_contact)
    (entity_has_employer_contact ?student - student ?employer_contact - employer_contact)
    (assessment_slot_available ?assessment_slot - assessment_slot)
    (assessment_assigned_to_entity ?student - student ?assessment_slot - assessment_slot)
    (support_specialist_available ?support_specialist - support_specialist)
    (support_specialist_assigned_to_entity ?student - student ?support_specialist - support_specialist)
    (support_service_available ?support_service - support_service)
    (advisor_referred_to_service ?career_advisor - career_advisor ?support_service - support_service)
    (coordinator_referred_to_service ?internship_coordinator - internship_coordinator ?support_service - support_service)
    (advisor_linked_student_task ?career_advisor - career_advisor ?student_task - student_task)
    (task_confirmed_by_advisor ?student_task - student_task)
    (task_referred_to_service ?student_task - student_task)
    (advisor_action_recorded ?career_advisor - career_advisor)
    (coordinator_has_task ?internship_coordinator - internship_coordinator ?coordinator_task - coordinator_task)
    (coordinator_task_confirmed ?coordinator_task - coordinator_task)
    (coordinator_task_referred ?coordinator_task - coordinator_task)
    (coordinator_action_recorded ?internship_coordinator - internship_coordinator)
    (application_packet_available ?application_packet - application_packet)
    (application_packet_created ?application_packet - application_packet)
    (packet_linked_student_task ?application_packet - application_packet ?student_task - student_task)
    (packet_linked_coordinator_task ?application_packet - application_packet ?coordinator_task - coordinator_task)
    (packet_approved_by_advisor ?application_packet - application_packet)
    (packet_approved_by_coordinator ?application_packet - application_packet)
    (packet_open_for_document_attachment ?application_packet - application_packet)
    (case_assigned_advisor ?advising_case - advising_case ?career_advisor - career_advisor)
    (case_assigned_coordinator ?advising_case - advising_case ?internship_coordinator - internship_coordinator)
    (case_linked_application_packet ?advising_case - advising_case ?application_packet - application_packet)
    (document_available ?document - document)
    (case_contains_document ?advising_case - advising_case ?document - document)
    (document_attached_to_packet ?document - document)
    (document_linked_to_packet ?document - document ?application_packet - application_packet)
    (case_documents_verified ?advising_case - advising_case)
    (accommodation_request_linked_to_case ?advising_case - advising_case)
    (case_ready_for_consolidation ?advising_case - advising_case)
    (case_has_employer_representative_assigned ?advising_case - advising_case)
    (employer_engagement_recorded ?advising_case - advising_case)
    (case_eligible_for_interview ?advising_case - advising_case)
    (case_review_completed ?advising_case - advising_case)
    (reference_provider_available ?reference_provider - reference_provider)
    (case_linked_reference_provider ?advising_case - advising_case ?reference_provider - reference_provider)
    (reference_request_created_for_case ?advising_case - advising_case)
    (reference_request_issued ?advising_case - advising_case)
    (reference_received ?advising_case - advising_case)
    (employer_representative_available ?employer_representative - employer_representative)
    (case_linked_employer_representative ?advising_case - advising_case ?employer_representative - employer_representative)
    (interview_slot_available ?interview_slot - interview_slot)
    (case_scheduled_interview_slot ?advising_case - advising_case ?interview_slot - interview_slot)
    (accommodation_request_type_available ?accommodation_request_type - accommodation_request_type)
    (case_linked_accommodation_request_type ?advising_case - advising_case ?accommodation_request_type - accommodation_request_type)
    (recommender_available ?recommender_record - recommender_record)
    (case_linked_recommender_record ?advising_case - advising_case ?recommender_record - recommender_record)
    (accommodation_resource_available ?accommodation_resource - accommodation_resource)
    (entity_accommodation_link ?student - student ?accommodation_resource - accommodation_resource)
    (advisor_action_completed ?career_advisor - career_advisor)
    (coordinator_action_completed ?internship_coordinator - internship_coordinator)
    (case_closed ?advising_case - advising_case)
  )
  (:action initiate_advising_case_for_student
    :parameters (?student - student)
    :precondition
      (and
        (not
          (has_active_advising_case ?student)
        )
        (not
          (entity_finalized ?student)
        )
      )
    :effect (has_active_advising_case ?student)
  )
  (:action assign_employer_contact_to_student
    :parameters (?student - student ?employer_contact - employer_contact)
    :precondition
      (and
        (has_active_advising_case ?student)
        (not
          (student_assignment_record ?student)
        )
        (employer_contact_available ?employer_contact)
      )
    :effect
      (and
        (student_assignment_record ?student)
        (entity_has_employer_contact ?student ?employer_contact)
        (not
          (employer_contact_available ?employer_contact)
        )
      )
  )
  (:action assign_assessment_slot_to_student
    :parameters (?student - student ?assessment_slot - assessment_slot)
    :precondition
      (and
        (has_active_advising_case ?student)
        (student_assignment_record ?student)
        (assessment_slot_available ?assessment_slot)
      )
    :effect
      (and
        (assessment_assigned_to_entity ?student ?assessment_slot)
        (not
          (assessment_slot_available ?assessment_slot)
        )
      )
  )
  (:action finalize_assessment_and_record_advisor_approval
    :parameters (?student - student ?assessment_slot - assessment_slot)
    :precondition
      (and
        (has_active_advising_case ?student)
        (student_assignment_record ?student)
        (assessment_assigned_to_entity ?student ?assessment_slot)
        (not
          (entity_approved_by_advisor ?student)
        )
      )
    :effect (entity_approved_by_advisor ?student)
  )
  (:action release_assessment_slot_from_student
    :parameters (?student - student ?assessment_slot - assessment_slot)
    :precondition
      (and
        (assessment_assigned_to_entity ?student ?assessment_slot)
      )
    :effect
      (and
        (assessment_slot_available ?assessment_slot)
        (not
          (assessment_assigned_to_entity ?student ?assessment_slot)
        )
      )
  )
  (:action assign_support_specialist_to_student
    :parameters (?student - student ?support_specialist - support_specialist)
    :precondition
      (and
        (entity_approved_by_advisor ?student)
        (support_specialist_available ?support_specialist)
      )
    :effect
      (and
        (support_specialist_assigned_to_entity ?student ?support_specialist)
        (not
          (support_specialist_available ?support_specialist)
        )
      )
  )
  (:action release_support_specialist_from_student
    :parameters (?student - student ?support_specialist - support_specialist)
    :precondition
      (and
        (support_specialist_assigned_to_entity ?student ?support_specialist)
      )
    :effect
      (and
        (support_specialist_available ?support_specialist)
        (not
          (support_specialist_assigned_to_entity ?student ?support_specialist)
        )
      )
  )
  (:action attach_accommodation_request_type_to_case
    :parameters (?advising_case - advising_case ?accommodation_request_type - accommodation_request_type)
    :precondition
      (and
        (entity_approved_by_advisor ?advising_case)
        (accommodation_request_type_available ?accommodation_request_type)
      )
    :effect
      (and
        (case_linked_accommodation_request_type ?advising_case ?accommodation_request_type)
        (not
          (accommodation_request_type_available ?accommodation_request_type)
        )
      )
  )
  (:action detach_accommodation_request_type_from_case
    :parameters (?advising_case - advising_case ?accommodation_request_type - accommodation_request_type)
    :precondition
      (and
        (case_linked_accommodation_request_type ?advising_case ?accommodation_request_type)
      )
    :effect
      (and
        (accommodation_request_type_available ?accommodation_request_type)
        (not
          (case_linked_accommodation_request_type ?advising_case ?accommodation_request_type)
        )
      )
  )
  (:action attach_recommender_record_to_case
    :parameters (?advising_case - advising_case ?recommender_record - recommender_record)
    :precondition
      (and
        (entity_approved_by_advisor ?advising_case)
        (recommender_available ?recommender_record)
      )
    :effect
      (and
        (case_linked_recommender_record ?advising_case ?recommender_record)
        (not
          (recommender_available ?recommender_record)
        )
      )
  )
  (:action detach_recommender_record_from_case
    :parameters (?advising_case - advising_case ?recommender_record - recommender_record)
    :precondition
      (and
        (case_linked_recommender_record ?advising_case ?recommender_record)
      )
    :effect
      (and
        (recommender_available ?recommender_record)
        (not
          (case_linked_recommender_record ?advising_case ?recommender_record)
        )
      )
  )
  (:action advisor_confirm_student_task
    :parameters (?career_advisor - career_advisor ?student_task - student_task ?assessment_slot - assessment_slot)
    :precondition
      (and
        (entity_approved_by_advisor ?career_advisor)
        (assessment_assigned_to_entity ?career_advisor ?assessment_slot)
        (advisor_linked_student_task ?career_advisor ?student_task)
        (not
          (task_confirmed_by_advisor ?student_task)
        )
        (not
          (task_referred_to_service ?student_task)
        )
      )
    :effect (task_confirmed_by_advisor ?student_task)
  )
  (:action advisor_assign_support_specialist_for_task
    :parameters (?career_advisor - career_advisor ?student_task - student_task ?support_specialist - support_specialist)
    :precondition
      (and
        (entity_approved_by_advisor ?career_advisor)
        (support_specialist_assigned_to_entity ?career_advisor ?support_specialist)
        (advisor_linked_student_task ?career_advisor ?student_task)
        (task_confirmed_by_advisor ?student_task)
        (not
          (advisor_action_completed ?career_advisor)
        )
      )
    :effect
      (and
        (advisor_action_completed ?career_advisor)
        (advisor_action_recorded ?career_advisor)
      )
  )
  (:action advisor_refer_student_to_support_service
    :parameters (?career_advisor - career_advisor ?student_task - student_task ?support_service - support_service)
    :precondition
      (and
        (entity_approved_by_advisor ?career_advisor)
        (advisor_linked_student_task ?career_advisor ?student_task)
        (support_service_available ?support_service)
        (not
          (advisor_action_completed ?career_advisor)
        )
      )
    :effect
      (and
        (task_referred_to_service ?student_task)
        (advisor_action_completed ?career_advisor)
        (advisor_referred_to_service ?career_advisor ?support_service)
        (not
          (support_service_available ?support_service)
        )
      )
  )
  (:action advisor_finalize_service_referral
    :parameters (?career_advisor - career_advisor ?student_task - student_task ?assessment_slot - assessment_slot ?support_service - support_service)
    :precondition
      (and
        (entity_approved_by_advisor ?career_advisor)
        (assessment_assigned_to_entity ?career_advisor ?assessment_slot)
        (advisor_linked_student_task ?career_advisor ?student_task)
        (task_referred_to_service ?student_task)
        (advisor_referred_to_service ?career_advisor ?support_service)
        (not
          (advisor_action_recorded ?career_advisor)
        )
      )
    :effect
      (and
        (task_confirmed_by_advisor ?student_task)
        (advisor_action_recorded ?career_advisor)
        (support_service_available ?support_service)
        (not
          (advisor_referred_to_service ?career_advisor ?support_service)
        )
      )
  )
  (:action coordinator_confirm_student_task
    :parameters (?internship_coordinator - internship_coordinator ?coordinator_task - coordinator_task ?assessment_slot - assessment_slot)
    :precondition
      (and
        (entity_approved_by_advisor ?internship_coordinator)
        (assessment_assigned_to_entity ?internship_coordinator ?assessment_slot)
        (coordinator_has_task ?internship_coordinator ?coordinator_task)
        (not
          (coordinator_task_confirmed ?coordinator_task)
        )
        (not
          (coordinator_task_referred ?coordinator_task)
        )
      )
    :effect (coordinator_task_confirmed ?coordinator_task)
  )
  (:action coordinator_assign_support_specialist_for_task
    :parameters (?internship_coordinator - internship_coordinator ?coordinator_task - coordinator_task ?support_specialist - support_specialist)
    :precondition
      (and
        (entity_approved_by_advisor ?internship_coordinator)
        (support_specialist_assigned_to_entity ?internship_coordinator ?support_specialist)
        (coordinator_has_task ?internship_coordinator ?coordinator_task)
        (coordinator_task_confirmed ?coordinator_task)
        (not
          (coordinator_action_completed ?internship_coordinator)
        )
      )
    :effect
      (and
        (coordinator_action_completed ?internship_coordinator)
        (coordinator_action_recorded ?internship_coordinator)
      )
  )
  (:action coordinator_refer_student_to_support_service
    :parameters (?internship_coordinator - internship_coordinator ?coordinator_task - coordinator_task ?support_service - support_service)
    :precondition
      (and
        (entity_approved_by_advisor ?internship_coordinator)
        (coordinator_has_task ?internship_coordinator ?coordinator_task)
        (support_service_available ?support_service)
        (not
          (coordinator_action_completed ?internship_coordinator)
        )
      )
    :effect
      (and
        (coordinator_task_referred ?coordinator_task)
        (coordinator_action_completed ?internship_coordinator)
        (coordinator_referred_to_service ?internship_coordinator ?support_service)
        (not
          (support_service_available ?support_service)
        )
      )
  )
  (:action coordinator_finalize_service_referral
    :parameters (?internship_coordinator - internship_coordinator ?coordinator_task - coordinator_task ?assessment_slot - assessment_slot ?support_service - support_service)
    :precondition
      (and
        (entity_approved_by_advisor ?internship_coordinator)
        (assessment_assigned_to_entity ?internship_coordinator ?assessment_slot)
        (coordinator_has_task ?internship_coordinator ?coordinator_task)
        (coordinator_task_referred ?coordinator_task)
        (coordinator_referred_to_service ?internship_coordinator ?support_service)
        (not
          (coordinator_action_recorded ?internship_coordinator)
        )
      )
    :effect
      (and
        (coordinator_task_confirmed ?coordinator_task)
        (coordinator_action_recorded ?internship_coordinator)
        (support_service_available ?support_service)
        (not
          (coordinator_referred_to_service ?internship_coordinator ?support_service)
        )
      )
  )
  (:action create_application_packet
    :parameters (?career_advisor - career_advisor ?internship_coordinator - internship_coordinator ?student_task - student_task ?coordinator_task - coordinator_task ?application_packet - application_packet)
    :precondition
      (and
        (advisor_action_completed ?career_advisor)
        (coordinator_action_completed ?internship_coordinator)
        (advisor_linked_student_task ?career_advisor ?student_task)
        (coordinator_has_task ?internship_coordinator ?coordinator_task)
        (task_confirmed_by_advisor ?student_task)
        (coordinator_task_confirmed ?coordinator_task)
        (advisor_action_recorded ?career_advisor)
        (coordinator_action_recorded ?internship_coordinator)
        (application_packet_available ?application_packet)
      )
    :effect
      (and
        (application_packet_created ?application_packet)
        (packet_linked_student_task ?application_packet ?student_task)
        (packet_linked_coordinator_task ?application_packet ?coordinator_task)
        (not
          (application_packet_available ?application_packet)
        )
      )
  )
  (:action create_application_packet_with_advisor_signoff
    :parameters (?career_advisor - career_advisor ?internship_coordinator - internship_coordinator ?student_task - student_task ?coordinator_task - coordinator_task ?application_packet - application_packet)
    :precondition
      (and
        (advisor_action_completed ?career_advisor)
        (coordinator_action_completed ?internship_coordinator)
        (advisor_linked_student_task ?career_advisor ?student_task)
        (coordinator_has_task ?internship_coordinator ?coordinator_task)
        (task_referred_to_service ?student_task)
        (coordinator_task_confirmed ?coordinator_task)
        (not
          (advisor_action_recorded ?career_advisor)
        )
        (coordinator_action_recorded ?internship_coordinator)
        (application_packet_available ?application_packet)
      )
    :effect
      (and
        (application_packet_created ?application_packet)
        (packet_linked_student_task ?application_packet ?student_task)
        (packet_linked_coordinator_task ?application_packet ?coordinator_task)
        (packet_approved_by_advisor ?application_packet)
        (not
          (application_packet_available ?application_packet)
        )
      )
  )
  (:action create_application_packet_with_coordinator_signoff
    :parameters (?career_advisor - career_advisor ?internship_coordinator - internship_coordinator ?student_task - student_task ?coordinator_task - coordinator_task ?application_packet - application_packet)
    :precondition
      (and
        (advisor_action_completed ?career_advisor)
        (coordinator_action_completed ?internship_coordinator)
        (advisor_linked_student_task ?career_advisor ?student_task)
        (coordinator_has_task ?internship_coordinator ?coordinator_task)
        (task_confirmed_by_advisor ?student_task)
        (coordinator_task_referred ?coordinator_task)
        (advisor_action_recorded ?career_advisor)
        (not
          (coordinator_action_recorded ?internship_coordinator)
        )
        (application_packet_available ?application_packet)
      )
    :effect
      (and
        (application_packet_created ?application_packet)
        (packet_linked_student_task ?application_packet ?student_task)
        (packet_linked_coordinator_task ?application_packet ?coordinator_task)
        (packet_approved_by_coordinator ?application_packet)
        (not
          (application_packet_available ?application_packet)
        )
      )
  )
  (:action create_application_packet_with_full_signoffs
    :parameters (?career_advisor - career_advisor ?internship_coordinator - internship_coordinator ?student_task - student_task ?coordinator_task - coordinator_task ?application_packet - application_packet)
    :precondition
      (and
        (advisor_action_completed ?career_advisor)
        (coordinator_action_completed ?internship_coordinator)
        (advisor_linked_student_task ?career_advisor ?student_task)
        (coordinator_has_task ?internship_coordinator ?coordinator_task)
        (task_referred_to_service ?student_task)
        (coordinator_task_referred ?coordinator_task)
        (not
          (advisor_action_recorded ?career_advisor)
        )
        (not
          (coordinator_action_recorded ?internship_coordinator)
        )
        (application_packet_available ?application_packet)
      )
    :effect
      (and
        (application_packet_created ?application_packet)
        (packet_linked_student_task ?application_packet ?student_task)
        (packet_linked_coordinator_task ?application_packet ?coordinator_task)
        (packet_approved_by_advisor ?application_packet)
        (packet_approved_by_coordinator ?application_packet)
        (not
          (application_packet_available ?application_packet)
        )
      )
  )
  (:action open_packet_for_document_attachment
    :parameters (?application_packet - application_packet ?career_advisor - career_advisor ?assessment_slot - assessment_slot)
    :precondition
      (and
        (application_packet_created ?application_packet)
        (advisor_action_completed ?career_advisor)
        (assessment_assigned_to_entity ?career_advisor ?assessment_slot)
        (not
          (packet_open_for_document_attachment ?application_packet)
        )
      )
    :effect (packet_open_for_document_attachment ?application_packet)
  )
  (:action attach_document_from_case_to_packet
    :parameters (?advising_case - advising_case ?document - document ?application_packet - application_packet)
    :precondition
      (and
        (entity_approved_by_advisor ?advising_case)
        (case_linked_application_packet ?advising_case ?application_packet)
        (case_contains_document ?advising_case ?document)
        (document_available ?document)
        (application_packet_created ?application_packet)
        (packet_open_for_document_attachment ?application_packet)
        (not
          (document_attached_to_packet ?document)
        )
      )
    :effect
      (and
        (document_attached_to_packet ?document)
        (document_linked_to_packet ?document ?application_packet)
        (not
          (document_available ?document)
        )
      )
  )
  (:action verify_packet_documents_and_mark_case
    :parameters (?advising_case - advising_case ?document - document ?application_packet - application_packet ?assessment_slot - assessment_slot)
    :precondition
      (and
        (entity_approved_by_advisor ?advising_case)
        (case_contains_document ?advising_case ?document)
        (document_attached_to_packet ?document)
        (document_linked_to_packet ?document ?application_packet)
        (assessment_assigned_to_entity ?advising_case ?assessment_slot)
        (not
          (packet_approved_by_advisor ?application_packet)
        )
        (not
          (case_documents_verified ?advising_case)
        )
      )
    :effect (case_documents_verified ?advising_case)
  )
  (:action assign_employer_representative_to_case
    :parameters (?advising_case - advising_case ?employer_representative - employer_representative)
    :precondition
      (and
        (entity_approved_by_advisor ?advising_case)
        (employer_representative_available ?employer_representative)
        (not
          (case_has_employer_representative_assigned ?advising_case)
        )
      )
    :effect
      (and
        (case_has_employer_representative_assigned ?advising_case)
        (case_linked_employer_representative ?advising_case ?employer_representative)
        (not
          (employer_representative_available ?employer_representative)
        )
      )
  )
  (:action record_employer_engagement_and_mark_case
    :parameters (?advising_case - advising_case ?document - document ?application_packet - application_packet ?assessment_slot - assessment_slot ?employer_representative - employer_representative)
    :precondition
      (and
        (entity_approved_by_advisor ?advising_case)
        (case_contains_document ?advising_case ?document)
        (document_attached_to_packet ?document)
        (document_linked_to_packet ?document ?application_packet)
        (assessment_assigned_to_entity ?advising_case ?assessment_slot)
        (packet_approved_by_advisor ?application_packet)
        (case_has_employer_representative_assigned ?advising_case)
        (case_linked_employer_representative ?advising_case ?employer_representative)
        (not
          (case_documents_verified ?advising_case)
        )
      )
    :effect
      (and
        (case_documents_verified ?advising_case)
        (employer_engagement_recorded ?advising_case)
      )
  )
  (:action initiate_accommodation_processing
    :parameters (?advising_case - advising_case ?accommodation_request_type - accommodation_request_type ?support_specialist - support_specialist ?document - document ?application_packet - application_packet)
    :precondition
      (and
        (case_documents_verified ?advising_case)
        (case_linked_accommodation_request_type ?advising_case ?accommodation_request_type)
        (support_specialist_assigned_to_entity ?advising_case ?support_specialist)
        (case_contains_document ?advising_case ?document)
        (document_linked_to_packet ?document ?application_packet)
        (not
          (packet_approved_by_coordinator ?application_packet)
        )
        (not
          (accommodation_request_linked_to_case ?advising_case)
        )
      )
    :effect (accommodation_request_linked_to_case ?advising_case)
  )
  (:action continue_accommodation_processing
    :parameters (?advising_case - advising_case ?accommodation_request_type - accommodation_request_type ?support_specialist - support_specialist ?document - document ?application_packet - application_packet)
    :precondition
      (and
        (case_documents_verified ?advising_case)
        (case_linked_accommodation_request_type ?advising_case ?accommodation_request_type)
        (support_specialist_assigned_to_entity ?advising_case ?support_specialist)
        (case_contains_document ?advising_case ?document)
        (document_linked_to_packet ?document ?application_packet)
        (packet_approved_by_coordinator ?application_packet)
        (not
          (accommodation_request_linked_to_case ?advising_case)
        )
      )
    :effect (accommodation_request_linked_to_case ?advising_case)
  )
  (:action advance_accommodation_review_stage1
    :parameters (?advising_case - advising_case ?recommender_record - recommender_record ?document - document ?application_packet - application_packet)
    :precondition
      (and
        (accommodation_request_linked_to_case ?advising_case)
        (case_linked_recommender_record ?advising_case ?recommender_record)
        (case_contains_document ?advising_case ?document)
        (document_linked_to_packet ?document ?application_packet)
        (not
          (packet_approved_by_advisor ?application_packet)
        )
        (not
          (packet_approved_by_coordinator ?application_packet)
        )
        (not
          (case_ready_for_consolidation ?advising_case)
        )
      )
    :effect (case_ready_for_consolidation ?advising_case)
  )
  (:action advance_accommodation_review_stage2
    :parameters (?advising_case - advising_case ?recommender_record - recommender_record ?document - document ?application_packet - application_packet)
    :precondition
      (and
        (accommodation_request_linked_to_case ?advising_case)
        (case_linked_recommender_record ?advising_case ?recommender_record)
        (case_contains_document ?advising_case ?document)
        (document_linked_to_packet ?document ?application_packet)
        (packet_approved_by_advisor ?application_packet)
        (not
          (packet_approved_by_coordinator ?application_packet)
        )
        (not
          (case_ready_for_consolidation ?advising_case)
        )
      )
    :effect
      (and
        (case_ready_for_consolidation ?advising_case)
        (case_eligible_for_interview ?advising_case)
      )
  )
  (:action advance_accommodation_review_stage3
    :parameters (?advising_case - advising_case ?recommender_record - recommender_record ?document - document ?application_packet - application_packet)
    :precondition
      (and
        (accommodation_request_linked_to_case ?advising_case)
        (case_linked_recommender_record ?advising_case ?recommender_record)
        (case_contains_document ?advising_case ?document)
        (document_linked_to_packet ?document ?application_packet)
        (not
          (packet_approved_by_advisor ?application_packet)
        )
        (packet_approved_by_coordinator ?application_packet)
        (not
          (case_ready_for_consolidation ?advising_case)
        )
      )
    :effect
      (and
        (case_ready_for_consolidation ?advising_case)
        (case_eligible_for_interview ?advising_case)
      )
  )
  (:action advance_accommodation_review_stage4
    :parameters (?advising_case - advising_case ?recommender_record - recommender_record ?document - document ?application_packet - application_packet)
    :precondition
      (and
        (accommodation_request_linked_to_case ?advising_case)
        (case_linked_recommender_record ?advising_case ?recommender_record)
        (case_contains_document ?advising_case ?document)
        (document_linked_to_packet ?document ?application_packet)
        (packet_approved_by_advisor ?application_packet)
        (packet_approved_by_coordinator ?application_packet)
        (not
          (case_ready_for_consolidation ?advising_case)
        )
      )
    :effect
      (and
        (case_ready_for_consolidation ?advising_case)
        (case_eligible_for_interview ?advising_case)
      )
  )
  (:action consolidate_case_and_create_final_flag
    :parameters (?advising_case - advising_case)
    :precondition
      (and
        (case_ready_for_consolidation ?advising_case)
        (not
          (case_eligible_for_interview ?advising_case)
        )
        (not
          (case_closed ?advising_case)
        )
      )
    :effect
      (and
        (case_closed ?advising_case)
        (entity_signed_off ?advising_case)
      )
  )
  (:action assign_interview_slot_to_case
    :parameters (?advising_case - advising_case ?interview_slot - interview_slot)
    :precondition
      (and
        (case_ready_for_consolidation ?advising_case)
        (case_eligible_for_interview ?advising_case)
        (interview_slot_available ?interview_slot)
      )
    :effect
      (and
        (case_scheduled_interview_slot ?advising_case ?interview_slot)
        (not
          (interview_slot_available ?interview_slot)
        )
      )
  )
  (:action complete_case_review
    :parameters (?advising_case - advising_case ?career_advisor - career_advisor ?internship_coordinator - internship_coordinator ?assessment_slot - assessment_slot ?interview_slot - interview_slot)
    :precondition
      (and
        (case_ready_for_consolidation ?advising_case)
        (case_eligible_for_interview ?advising_case)
        (case_scheduled_interview_slot ?advising_case ?interview_slot)
        (case_assigned_advisor ?advising_case ?career_advisor)
        (case_assigned_coordinator ?advising_case ?internship_coordinator)
        (advisor_action_recorded ?career_advisor)
        (coordinator_action_recorded ?internship_coordinator)
        (assessment_assigned_to_entity ?advising_case ?assessment_slot)
        (not
          (case_review_completed ?advising_case)
        )
      )
    :effect (case_review_completed ?advising_case)
  )
  (:action finalize_case_and_mark_signed_off
    :parameters (?advising_case - advising_case)
    :precondition
      (and
        (case_ready_for_consolidation ?advising_case)
        (case_review_completed ?advising_case)
        (not
          (case_closed ?advising_case)
        )
      )
    :effect
      (and
        (case_closed ?advising_case)
        (entity_signed_off ?advising_case)
      )
  )
  (:action create_reference_request_for_case
    :parameters (?advising_case - advising_case ?reference_provider - reference_provider ?assessment_slot - assessment_slot)
    :precondition
      (and
        (entity_approved_by_advisor ?advising_case)
        (assessment_assigned_to_entity ?advising_case ?assessment_slot)
        (reference_provider_available ?reference_provider)
        (case_linked_reference_provider ?advising_case ?reference_provider)
        (not
          (reference_request_created_for_case ?advising_case)
        )
      )
    :effect
      (and
        (reference_request_created_for_case ?advising_case)
        (not
          (reference_provider_available ?reference_provider)
        )
      )
  )
  (:action issue_reference_request
    :parameters (?advising_case - advising_case ?support_specialist - support_specialist)
    :precondition
      (and
        (reference_request_created_for_case ?advising_case)
        (support_specialist_assigned_to_entity ?advising_case ?support_specialist)
        (not
          (reference_request_issued ?advising_case)
        )
      )
    :effect (reference_request_issued ?advising_case)
  )
  (:action record_reference_submission
    :parameters (?advising_case - advising_case ?recommender_record - recommender_record)
    :precondition
      (and
        (reference_request_issued ?advising_case)
        (case_linked_recommender_record ?advising_case ?recommender_record)
        (not
          (reference_received ?advising_case)
        )
      )
    :effect (reference_received ?advising_case)
  )
  (:action finalize_reference_and_close_case
    :parameters (?advising_case - advising_case)
    :precondition
      (and
        (reference_received ?advising_case)
        (not
          (case_closed ?advising_case)
        )
      )
    :effect
      (and
        (case_closed ?advising_case)
        (entity_signed_off ?advising_case)
      )
  )
  (:action advisor_finalize_case
    :parameters (?career_advisor - career_advisor ?application_packet - application_packet)
    :precondition
      (and
        (advisor_action_completed ?career_advisor)
        (advisor_action_recorded ?career_advisor)
        (application_packet_created ?application_packet)
        (packet_open_for_document_attachment ?application_packet)
        (not
          (entity_signed_off ?career_advisor)
        )
      )
    :effect (entity_signed_off ?career_advisor)
  )
  (:action coordinator_finalize_case
    :parameters (?internship_coordinator - internship_coordinator ?application_packet - application_packet)
    :precondition
      (and
        (coordinator_action_completed ?internship_coordinator)
        (coordinator_action_recorded ?internship_coordinator)
        (application_packet_created ?application_packet)
        (packet_open_for_document_attachment ?application_packet)
        (not
          (entity_signed_off ?internship_coordinator)
        )
      )
    :effect (entity_signed_off ?internship_coordinator)
  )
  (:action student_submit_accommodation_request
    :parameters (?student - student ?accommodation_resource - accommodation_resource ?assessment_slot - assessment_slot)
    :precondition
      (and
        (entity_signed_off ?student)
        (assessment_assigned_to_entity ?student ?assessment_slot)
        (accommodation_resource_available ?accommodation_resource)
        (not
          (accommodation_request_recorded ?student)
        )
      )
    :effect
      (and
        (accommodation_request_recorded ?student)
        (entity_accommodation_link ?student ?accommodation_resource)
        (not
          (accommodation_resource_available ?accommodation_resource)
        )
      )
  )
  (:action advisor_process_accommodation_and_assign_employer_contact
    :parameters (?career_advisor - career_advisor ?employer_contact - employer_contact ?accommodation_resource - accommodation_resource)
    :precondition
      (and
        (accommodation_request_recorded ?career_advisor)
        (entity_has_employer_contact ?career_advisor ?employer_contact)
        (entity_accommodation_link ?career_advisor ?accommodation_resource)
        (not
          (entity_finalized ?career_advisor)
        )
      )
    :effect
      (and
        (entity_finalized ?career_advisor)
        (employer_contact_available ?employer_contact)
        (accommodation_resource_available ?accommodation_resource)
      )
  )
  (:action coordinator_process_accommodation_and_assign_employer_contact
    :parameters (?internship_coordinator - internship_coordinator ?employer_contact - employer_contact ?accommodation_resource - accommodation_resource)
    :precondition
      (and
        (accommodation_request_recorded ?internship_coordinator)
        (entity_has_employer_contact ?internship_coordinator ?employer_contact)
        (entity_accommodation_link ?internship_coordinator ?accommodation_resource)
        (not
          (entity_finalized ?internship_coordinator)
        )
      )
    :effect
      (and
        (entity_finalized ?internship_coordinator)
        (employer_contact_available ?employer_contact)
        (accommodation_resource_available ?accommodation_resource)
      )
  )
  (:action case_process_accommodation_and_assign_employer_contact
    :parameters (?advising_case - advising_case ?employer_contact - employer_contact ?accommodation_resource - accommodation_resource)
    :precondition
      (and
        (accommodation_request_recorded ?advising_case)
        (entity_has_employer_contact ?advising_case ?employer_contact)
        (entity_accommodation_link ?advising_case ?accommodation_resource)
        (not
          (entity_finalized ?advising_case)
        )
      )
    :effect
      (and
        (entity_finalized ?advising_case)
        (employer_contact_available ?employer_contact)
        (accommodation_resource_available ?accommodation_resource)
      )
  )
)

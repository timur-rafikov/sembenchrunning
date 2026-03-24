(define (domain credit_overload_approval_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object administrative_item_group - entity document_group - entity time_block_group - entity application_container - entity overload_application - application_container approval_token - administrative_item_group course_record - administrative_item_group reviewer_record - administrative_item_group priority_flag - administrative_item_group escalation_flag - administrative_item_group external_authorization - administrative_item_group committee_signature - administrative_item_group dean_signature - administrative_item_group supporting_document - document_group room_or_resource - document_group department_document - document_group student_time_block - time_block_group department_time_block - time_block_group schedule_proposal - time_block_group student_submission_variant - overload_application administrative_record_variant - overload_application student_actor - student_submission_variant department_actor - student_submission_variant administrative_case_file - administrative_record_variant)

  (:predicates
    (submission_initiated ?overload_application - overload_application)
    (record_validated ?overload_application - overload_application)
    (approval_token_assigned_to_submission ?overload_application - overload_application)
    (final_approval_recorded ?overload_application - overload_application)
    (submission_finalization_marker_set ?overload_application - overload_application)
    (submission_authorized ?overload_application - overload_application)
    (approval_token_available ?approval_token - approval_token)
    (submission_assigned_token ?overload_application - overload_application ?approval_token - approval_token)
    (course_available ?course_record - course_record)
    (submission_includes_course ?overload_application - overload_application ?course_record - course_record)
    (reviewer_available ?reviewer_record - reviewer_record)
    (submission_assigned_reviewer ?overload_application - overload_application ?reviewer_record - reviewer_record)
    (supporting_document_available ?supporting_document - supporting_document)
    (student_attached_document ?student_actor - student_actor ?supporting_document - supporting_document)
    (department_attached_document ?department_actor - department_actor ?supporting_document - supporting_document)
    (student_timeblock_assigned ?student_actor - student_actor ?student_time_block - student_time_block)
    (student_timeblock_reserved ?student_time_block - student_time_block)
    (student_timeblock_used ?student_time_block - student_time_block)
    (student_availability_confirmed ?student_actor - student_actor)
    (department_timeblock_assigned ?department_actor - department_actor ?department_time_block - department_time_block)
    (department_timeblock_reserved ?department_time_block - department_time_block)
    (department_timeblock_used ?department_time_block - department_time_block)
    (department_availability_confirmed ?department_actor - department_actor)
    (proposal_draft_available ?schedule_proposal - schedule_proposal)
    (proposal_reserved ?schedule_proposal - schedule_proposal)
    (proposal_includes_student_timeblock ?schedule_proposal - schedule_proposal ?student_time_block - student_time_block)
    (proposal_includes_department_timeblock ?schedule_proposal - schedule_proposal ?department_time_block - department_time_block)
    (proposal_student_block_confirmed ?schedule_proposal - schedule_proposal)
    (proposal_department_block_confirmed ?schedule_proposal - schedule_proposal)
    (proposal_room_allocated ?schedule_proposal - schedule_proposal)
    (casefile_linked_student ?administrative_case_file - administrative_case_file ?student_actor - student_actor)
    (casefile_linked_department ?administrative_case_file - administrative_case_file ?department_actor - department_actor)
    (casefile_includes_proposal ?administrative_case_file - administrative_case_file ?schedule_proposal - schedule_proposal)
    (resource_available ?room_or_resource - room_or_resource)
    (casefile_includes_resource ?administrative_case_file - administrative_case_file ?room_or_resource - room_or_resource)
    (resource_reserved ?room_or_resource - room_or_resource)
    (resource_assigned_to_proposal ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal)
    (casefile_documents_staged ?administrative_case_file - administrative_case_file)
    (committee_signature_obtained ?administrative_case_file - administrative_case_file)
    (committee_signature_verified ?administrative_case_file - administrative_case_file)
    (casefile_has_department_document_attached ?administrative_case_file - administrative_case_file)
    (casefile_priority_flag_attached ?administrative_case_file - administrative_case_file)
    (committee_signature_confirmed ?administrative_case_file - administrative_case_file)
    (casefile_final_checks_passed ?administrative_case_file - administrative_case_file)
    (department_document_available ?department_document - department_document)
    (casefile_includes_department_document ?administrative_case_file - administrative_case_file ?department_document - department_document)
    (department_document_verified ?administrative_case_file - administrative_case_file)
    (department_document_approved ?administrative_case_file - administrative_case_file)
    (department_document_cleared ?administrative_case_file - administrative_case_file)
    (priority_flag_available ?priority_flag - priority_flag)
    (casefile_has_priority_flag ?administrative_case_file - administrative_case_file ?priority_flag - priority_flag)
    (escalation_flag_available ?escalation_flag - escalation_flag)
    (casefile_has_escalation_flag ?administrative_case_file - administrative_case_file ?escalation_flag - escalation_flag)
    (committee_signature_available ?committee_signature - committee_signature)
    (casefile_has_committee_signature ?administrative_case_file - administrative_case_file ?committee_signature - committee_signature)
    (dean_signature_available ?dean_signature - dean_signature)
    (casefile_has_dean_signature ?administrative_case_file - administrative_case_file ?dean_signature - dean_signature)
    (external_authorization_available ?external_authorization - external_authorization)
    (submission_has_external_authorization ?overload_application - overload_application ?external_authorization - external_authorization)
    (student_ready_for_proposal ?student_actor - student_actor)
    (department_ready_for_proposal ?department_actor - department_actor)
    (casefile_finalized ?administrative_case_file - administrative_case_file)
  )
  (:action initiate_overload_submission
    :parameters (?overload_application - overload_application)
    :precondition
      (and
        (not
          (submission_initiated ?overload_application)
        )
        (not
          (final_approval_recorded ?overload_application)
        )
      )
    :effect (submission_initiated ?overload_application)
  )
  (:action assign_approval_token_to_submission
    :parameters (?overload_application - overload_application ?approval_token - approval_token)
    :precondition
      (and
        (submission_initiated ?overload_application)
        (not
          (approval_token_assigned_to_submission ?overload_application)
        )
        (approval_token_available ?approval_token)
      )
    :effect
      (and
        (approval_token_assigned_to_submission ?overload_application)
        (submission_assigned_token ?overload_application ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action attach_course_to_submission
    :parameters (?overload_application - overload_application ?course_record - course_record)
    :precondition
      (and
        (submission_initiated ?overload_application)
        (approval_token_assigned_to_submission ?overload_application)
        (course_available ?course_record)
      )
    :effect
      (and
        (submission_includes_course ?overload_application ?course_record)
        (not
          (course_available ?course_record)
        )
      )
  )
  (:action validate_submission_course
    :parameters (?overload_application - overload_application ?course_record - course_record)
    :precondition
      (and
        (submission_initiated ?overload_application)
        (approval_token_assigned_to_submission ?overload_application)
        (submission_includes_course ?overload_application ?course_record)
        (not
          (record_validated ?overload_application)
        )
      )
    :effect (record_validated ?overload_application)
  )
  (:action detach_course_from_submission
    :parameters (?overload_application - overload_application ?course_record - course_record)
    :precondition
      (and
        (submission_includes_course ?overload_application ?course_record)
      )
    :effect
      (and
        (course_available ?course_record)
        (not
          (submission_includes_course ?overload_application ?course_record)
        )
      )
  )
  (:action assign_reviewer_to_submission
    :parameters (?overload_application - overload_application ?reviewer_record - reviewer_record)
    :precondition
      (and
        (record_validated ?overload_application)
        (reviewer_available ?reviewer_record)
      )
    :effect
      (and
        (submission_assigned_reviewer ?overload_application ?reviewer_record)
        (not
          (reviewer_available ?reviewer_record)
        )
      )
  )
  (:action unassign_reviewer_from_submission
    :parameters (?overload_application - overload_application ?reviewer_record - reviewer_record)
    :precondition
      (and
        (submission_assigned_reviewer ?overload_application ?reviewer_record)
      )
    :effect
      (and
        (reviewer_available ?reviewer_record)
        (not
          (submission_assigned_reviewer ?overload_application ?reviewer_record)
        )
      )
  )
  (:action attach_committee_signature_to_casefile
    :parameters (?administrative_case_file - administrative_case_file ?committee_signature - committee_signature)
    :precondition
      (and
        (record_validated ?administrative_case_file)
        (committee_signature_available ?committee_signature)
      )
    :effect
      (and
        (casefile_has_committee_signature ?administrative_case_file ?committee_signature)
        (not
          (committee_signature_available ?committee_signature)
        )
      )
  )
  (:action release_committee_signature_from_casefile
    :parameters (?administrative_case_file - administrative_case_file ?committee_signature - committee_signature)
    :precondition
      (and
        (casefile_has_committee_signature ?administrative_case_file ?committee_signature)
      )
    :effect
      (and
        (committee_signature_available ?committee_signature)
        (not
          (casefile_has_committee_signature ?administrative_case_file ?committee_signature)
        )
      )
  )
  (:action attach_dean_signature_to_casefile
    :parameters (?administrative_case_file - administrative_case_file ?dean_signature - dean_signature)
    :precondition
      (and
        (record_validated ?administrative_case_file)
        (dean_signature_available ?dean_signature)
      )
    :effect
      (and
        (casefile_has_dean_signature ?administrative_case_file ?dean_signature)
        (not
          (dean_signature_available ?dean_signature)
        )
      )
  )
  (:action release_dean_signature_from_casefile
    :parameters (?administrative_case_file - administrative_case_file ?dean_signature - dean_signature)
    :precondition
      (and
        (casefile_has_dean_signature ?administrative_case_file ?dean_signature)
      )
    :effect
      (and
        (dean_signature_available ?dean_signature)
        (not
          (casefile_has_dean_signature ?administrative_case_file ?dean_signature)
        )
      )
  )
  (:action reserve_student_timeblock_for_course
    :parameters (?student_actor - student_actor ?student_time_block - student_time_block ?course_record - course_record)
    :precondition
      (and
        (record_validated ?student_actor)
        (submission_includes_course ?student_actor ?course_record)
        (student_timeblock_assigned ?student_actor ?student_time_block)
        (not
          (student_timeblock_reserved ?student_time_block)
        )
        (not
          (student_timeblock_used ?student_time_block)
        )
      )
    :effect (student_timeblock_reserved ?student_time_block)
  )
  (:action confirm_student_availability_with_reviewer
    :parameters (?student_actor - student_actor ?student_time_block - student_time_block ?reviewer_record - reviewer_record)
    :precondition
      (and
        (record_validated ?student_actor)
        (submission_assigned_reviewer ?student_actor ?reviewer_record)
        (student_timeblock_assigned ?student_actor ?student_time_block)
        (student_timeblock_reserved ?student_time_block)
        (not
          (student_ready_for_proposal ?student_actor)
        )
      )
    :effect
      (and
        (student_ready_for_proposal ?student_actor)
        (student_availability_confirmed ?student_actor)
      )
  )
  (:action attach_supporting_document_to_student_submission
    :parameters (?student_actor - student_actor ?student_time_block - student_time_block ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?student_actor)
        (student_timeblock_assigned ?student_actor ?student_time_block)
        (supporting_document_available ?supporting_document)
        (not
          (student_ready_for_proposal ?student_actor)
        )
      )
    :effect
      (and
        (student_timeblock_used ?student_time_block)
        (student_ready_for_proposal ?student_actor)
        (student_attached_document ?student_actor ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_student_availability_with_document
    :parameters (?student_actor - student_actor ?student_time_block - student_time_block ?course_record - course_record ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?student_actor)
        (submission_includes_course ?student_actor ?course_record)
        (student_timeblock_assigned ?student_actor ?student_time_block)
        (student_timeblock_used ?student_time_block)
        (student_attached_document ?student_actor ?supporting_document)
        (not
          (student_availability_confirmed ?student_actor)
        )
      )
    :effect
      (and
        (student_timeblock_reserved ?student_time_block)
        (student_availability_confirmed ?student_actor)
        (supporting_document_available ?supporting_document)
        (not
          (student_attached_document ?student_actor ?supporting_document)
        )
      )
  )
  (:action reserve_department_timeblock_for_course
    :parameters (?department_actor - department_actor ?department_time_block - department_time_block ?course_record - course_record)
    :precondition
      (and
        (record_validated ?department_actor)
        (submission_includes_course ?department_actor ?course_record)
        (department_timeblock_assigned ?department_actor ?department_time_block)
        (not
          (department_timeblock_reserved ?department_time_block)
        )
        (not
          (department_timeblock_used ?department_time_block)
        )
      )
    :effect (department_timeblock_reserved ?department_time_block)
  )
  (:action confirm_department_availability_with_reviewer
    :parameters (?department_actor - department_actor ?department_time_block - department_time_block ?reviewer_record - reviewer_record)
    :precondition
      (and
        (record_validated ?department_actor)
        (submission_assigned_reviewer ?department_actor ?reviewer_record)
        (department_timeblock_assigned ?department_actor ?department_time_block)
        (department_timeblock_reserved ?department_time_block)
        (not
          (department_ready_for_proposal ?department_actor)
        )
      )
    :effect
      (and
        (department_ready_for_proposal ?department_actor)
        (department_availability_confirmed ?department_actor)
      )
  )
  (:action attach_supporting_document_to_department_submission
    :parameters (?department_actor - department_actor ?department_time_block - department_time_block ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?department_actor)
        (department_timeblock_assigned ?department_actor ?department_time_block)
        (supporting_document_available ?supporting_document)
        (not
          (department_ready_for_proposal ?department_actor)
        )
      )
    :effect
      (and
        (department_timeblock_used ?department_time_block)
        (department_ready_for_proposal ?department_actor)
        (department_attached_document ?department_actor ?supporting_document)
        (not
          (supporting_document_available ?supporting_document)
        )
      )
  )
  (:action finalize_department_availability_with_document
    :parameters (?department_actor - department_actor ?department_time_block - department_time_block ?course_record - course_record ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?department_actor)
        (submission_includes_course ?department_actor ?course_record)
        (department_timeblock_assigned ?department_actor ?department_time_block)
        (department_timeblock_used ?department_time_block)
        (department_attached_document ?department_actor ?supporting_document)
        (not
          (department_availability_confirmed ?department_actor)
        )
      )
    :effect
      (and
        (department_timeblock_reserved ?department_time_block)
        (department_availability_confirmed ?department_actor)
        (supporting_document_available ?supporting_document)
        (not
          (department_attached_document ?department_actor ?supporting_document)
        )
      )
  )
  (:action construct_schedule_proposal
    :parameters (?student_actor - student_actor ?department_actor - department_actor ?student_time_block - student_time_block ?department_time_block - department_time_block ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student_actor)
        (department_ready_for_proposal ?department_actor)
        (student_timeblock_assigned ?student_actor ?student_time_block)
        (department_timeblock_assigned ?department_actor ?department_time_block)
        (student_timeblock_reserved ?student_time_block)
        (department_timeblock_reserved ?department_time_block)
        (student_availability_confirmed ?student_actor)
        (department_availability_confirmed ?department_actor)
        (proposal_draft_available ?schedule_proposal)
      )
    :effect
      (and
        (proposal_reserved ?schedule_proposal)
        (proposal_includes_student_timeblock ?schedule_proposal ?student_time_block)
        (proposal_includes_department_timeblock ?schedule_proposal ?department_time_block)
        (not
          (proposal_draft_available ?schedule_proposal)
        )
      )
  )
  (:action construct_schedule_proposal_using_student_block
    :parameters (?student_actor - student_actor ?department_actor - department_actor ?student_time_block - student_time_block ?department_time_block - department_time_block ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student_actor)
        (department_ready_for_proposal ?department_actor)
        (student_timeblock_assigned ?student_actor ?student_time_block)
        (department_timeblock_assigned ?department_actor ?department_time_block)
        (student_timeblock_used ?student_time_block)
        (department_timeblock_reserved ?department_time_block)
        (not
          (student_availability_confirmed ?student_actor)
        )
        (department_availability_confirmed ?department_actor)
        (proposal_draft_available ?schedule_proposal)
      )
    :effect
      (and
        (proposal_reserved ?schedule_proposal)
        (proposal_includes_student_timeblock ?schedule_proposal ?student_time_block)
        (proposal_includes_department_timeblock ?schedule_proposal ?department_time_block)
        (proposal_student_block_confirmed ?schedule_proposal)
        (not
          (proposal_draft_available ?schedule_proposal)
        )
      )
  )
  (:action construct_schedule_proposal_using_department_block
    :parameters (?student_actor - student_actor ?department_actor - department_actor ?student_time_block - student_time_block ?department_time_block - department_time_block ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student_actor)
        (department_ready_for_proposal ?department_actor)
        (student_timeblock_assigned ?student_actor ?student_time_block)
        (department_timeblock_assigned ?department_actor ?department_time_block)
        (student_timeblock_reserved ?student_time_block)
        (department_timeblock_used ?department_time_block)
        (student_availability_confirmed ?student_actor)
        (not
          (department_availability_confirmed ?department_actor)
        )
        (proposal_draft_available ?schedule_proposal)
      )
    :effect
      (and
        (proposal_reserved ?schedule_proposal)
        (proposal_includes_student_timeblock ?schedule_proposal ?student_time_block)
        (proposal_includes_department_timeblock ?schedule_proposal ?department_time_block)
        (proposal_department_block_confirmed ?schedule_proposal)
        (not
          (proposal_draft_available ?schedule_proposal)
        )
      )
  )
  (:action construct_schedule_proposal_using_both_blocks
    :parameters (?student_actor - student_actor ?department_actor - department_actor ?student_time_block - student_time_block ?department_time_block - department_time_block ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student_actor)
        (department_ready_for_proposal ?department_actor)
        (student_timeblock_assigned ?student_actor ?student_time_block)
        (department_timeblock_assigned ?department_actor ?department_time_block)
        (student_timeblock_used ?student_time_block)
        (department_timeblock_used ?department_time_block)
        (not
          (student_availability_confirmed ?student_actor)
        )
        (not
          (department_availability_confirmed ?department_actor)
        )
        (proposal_draft_available ?schedule_proposal)
      )
    :effect
      (and
        (proposal_reserved ?schedule_proposal)
        (proposal_includes_student_timeblock ?schedule_proposal ?student_time_block)
        (proposal_includes_department_timeblock ?schedule_proposal ?department_time_block)
        (proposal_student_block_confirmed ?schedule_proposal)
        (proposal_department_block_confirmed ?schedule_proposal)
        (not
          (proposal_draft_available ?schedule_proposal)
        )
      )
  )
  (:action allocate_room_for_proposal
    :parameters (?schedule_proposal - schedule_proposal ?student_actor - student_actor ?course_record - course_record)
    :precondition
      (and
        (proposal_reserved ?schedule_proposal)
        (student_ready_for_proposal ?student_actor)
        (submission_includes_course ?student_actor ?course_record)
        (not
          (proposal_room_allocated ?schedule_proposal)
        )
      )
    :effect (proposal_room_allocated ?schedule_proposal)
  )
  (:action reserve_resource_and_link_to_proposal
    :parameters (?administrative_case_file - administrative_case_file ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (record_validated ?administrative_case_file)
        (casefile_includes_proposal ?administrative_case_file ?schedule_proposal)
        (casefile_includes_resource ?administrative_case_file ?room_or_resource)
        (resource_available ?room_or_resource)
        (proposal_reserved ?schedule_proposal)
        (proposal_room_allocated ?schedule_proposal)
        (not
          (resource_reserved ?room_or_resource)
        )
      )
    :effect
      (and
        (resource_reserved ?room_or_resource)
        (resource_assigned_to_proposal ?room_or_resource ?schedule_proposal)
        (not
          (resource_available ?room_or_resource)
        )
      )
  )
  (:action stage_casefile_documents
    :parameters (?administrative_case_file - administrative_case_file ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal ?course_record - course_record)
    :precondition
      (and
        (record_validated ?administrative_case_file)
        (casefile_includes_resource ?administrative_case_file ?room_or_resource)
        (resource_reserved ?room_or_resource)
        (resource_assigned_to_proposal ?room_or_resource ?schedule_proposal)
        (submission_includes_course ?administrative_case_file ?course_record)
        (not
          (proposal_student_block_confirmed ?schedule_proposal)
        )
        (not
          (casefile_documents_staged ?administrative_case_file)
        )
      )
    :effect (casefile_documents_staged ?administrative_case_file)
  )
  (:action attach_priority_flag_to_casefile
    :parameters (?administrative_case_file - administrative_case_file ?priority_flag - priority_flag)
    :precondition
      (and
        (record_validated ?administrative_case_file)
        (priority_flag_available ?priority_flag)
        (not
          (casefile_has_department_document_attached ?administrative_case_file)
        )
      )
    :effect
      (and
        (casefile_has_department_document_attached ?administrative_case_file)
        (casefile_has_priority_flag ?administrative_case_file ?priority_flag)
        (not
          (priority_flag_available ?priority_flag)
        )
      )
  )
  (:action stage_casefile_documentation_with_priority
    :parameters (?administrative_case_file - administrative_case_file ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal ?course_record - course_record ?priority_flag - priority_flag)
    :precondition
      (and
        (record_validated ?administrative_case_file)
        (casefile_includes_resource ?administrative_case_file ?room_or_resource)
        (resource_reserved ?room_or_resource)
        (resource_assigned_to_proposal ?room_or_resource ?schedule_proposal)
        (submission_includes_course ?administrative_case_file ?course_record)
        (proposal_student_block_confirmed ?schedule_proposal)
        (casefile_has_department_document_attached ?administrative_case_file)
        (casefile_has_priority_flag ?administrative_case_file ?priority_flag)
        (not
          (casefile_documents_staged ?administrative_case_file)
        )
      )
    :effect
      (and
        (casefile_documents_staged ?administrative_case_file)
        (casefile_priority_flag_attached ?administrative_case_file)
      )
  )
  (:action collect_committee_signature_standard
    :parameters (?administrative_case_file - administrative_case_file ?committee_signature - committee_signature ?reviewer_record - reviewer_record ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (casefile_documents_staged ?administrative_case_file)
        (casefile_has_committee_signature ?administrative_case_file ?committee_signature)
        (submission_assigned_reviewer ?administrative_case_file ?reviewer_record)
        (casefile_includes_resource ?administrative_case_file ?room_or_resource)
        (resource_assigned_to_proposal ?room_or_resource ?schedule_proposal)
        (not
          (proposal_department_block_confirmed ?schedule_proposal)
        )
        (not
          (committee_signature_obtained ?administrative_case_file)
        )
      )
    :effect (committee_signature_obtained ?administrative_case_file)
  )
  (:action collect_committee_signature_with_department_block
    :parameters (?administrative_case_file - administrative_case_file ?committee_signature - committee_signature ?reviewer_record - reviewer_record ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (casefile_documents_staged ?administrative_case_file)
        (casefile_has_committee_signature ?administrative_case_file ?committee_signature)
        (submission_assigned_reviewer ?administrative_case_file ?reviewer_record)
        (casefile_includes_resource ?administrative_case_file ?room_or_resource)
        (resource_assigned_to_proposal ?room_or_resource ?schedule_proposal)
        (proposal_department_block_confirmed ?schedule_proposal)
        (not
          (committee_signature_obtained ?administrative_case_file)
        )
      )
    :effect (committee_signature_obtained ?administrative_case_file)
  )
  (:action verify_committee_signature_standard
    :parameters (?administrative_case_file - administrative_case_file ?dean_signature - dean_signature ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (committee_signature_obtained ?administrative_case_file)
        (casefile_has_dean_signature ?administrative_case_file ?dean_signature)
        (casefile_includes_resource ?administrative_case_file ?room_or_resource)
        (resource_assigned_to_proposal ?room_or_resource ?schedule_proposal)
        (not
          (proposal_student_block_confirmed ?schedule_proposal)
        )
        (not
          (proposal_department_block_confirmed ?schedule_proposal)
        )
        (not
          (committee_signature_verified ?administrative_case_file)
        )
      )
    :effect (committee_signature_verified ?administrative_case_file)
  )
  (:action verify_committee_signature_with_student_block
    :parameters (?administrative_case_file - administrative_case_file ?dean_signature - dean_signature ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (committee_signature_obtained ?administrative_case_file)
        (casefile_has_dean_signature ?administrative_case_file ?dean_signature)
        (casefile_includes_resource ?administrative_case_file ?room_or_resource)
        (resource_assigned_to_proposal ?room_or_resource ?schedule_proposal)
        (proposal_student_block_confirmed ?schedule_proposal)
        (not
          (proposal_department_block_confirmed ?schedule_proposal)
        )
        (not
          (committee_signature_verified ?administrative_case_file)
        )
      )
    :effect
      (and
        (committee_signature_verified ?administrative_case_file)
        (committee_signature_confirmed ?administrative_case_file)
      )
  )
  (:action verify_committee_signature_with_department_block
    :parameters (?administrative_case_file - administrative_case_file ?dean_signature - dean_signature ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (committee_signature_obtained ?administrative_case_file)
        (casefile_has_dean_signature ?administrative_case_file ?dean_signature)
        (casefile_includes_resource ?administrative_case_file ?room_or_resource)
        (resource_assigned_to_proposal ?room_or_resource ?schedule_proposal)
        (not
          (proposal_student_block_confirmed ?schedule_proposal)
        )
        (proposal_department_block_confirmed ?schedule_proposal)
        (not
          (committee_signature_verified ?administrative_case_file)
        )
      )
    :effect
      (and
        (committee_signature_verified ?administrative_case_file)
        (committee_signature_confirmed ?administrative_case_file)
      )
  )
  (:action verify_committee_signature_with_both_blocks
    :parameters (?administrative_case_file - administrative_case_file ?dean_signature - dean_signature ?room_or_resource - room_or_resource ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (committee_signature_obtained ?administrative_case_file)
        (casefile_has_dean_signature ?administrative_case_file ?dean_signature)
        (casefile_includes_resource ?administrative_case_file ?room_or_resource)
        (resource_assigned_to_proposal ?room_or_resource ?schedule_proposal)
        (proposal_student_block_confirmed ?schedule_proposal)
        (proposal_department_block_confirmed ?schedule_proposal)
        (not
          (committee_signature_verified ?administrative_case_file)
        )
      )
    :effect
      (and
        (committee_signature_verified ?administrative_case_file)
        (committee_signature_confirmed ?administrative_case_file)
      )
  )
  (:action finalize_casefile_with_committee_signature
    :parameters (?administrative_case_file - administrative_case_file)
    :precondition
      (and
        (committee_signature_verified ?administrative_case_file)
        (not
          (committee_signature_confirmed ?administrative_case_file)
        )
        (not
          (casefile_finalized ?administrative_case_file)
        )
      )
    :effect
      (and
        (casefile_finalized ?administrative_case_file)
        (submission_finalization_marker_set ?administrative_case_file)
      )
  )
  (:action attach_escalation_flag_to_casefile
    :parameters (?administrative_case_file - administrative_case_file ?escalation_flag - escalation_flag)
    :precondition
      (and
        (committee_signature_verified ?administrative_case_file)
        (committee_signature_confirmed ?administrative_case_file)
        (escalation_flag_available ?escalation_flag)
      )
    :effect
      (and
        (casefile_has_escalation_flag ?administrative_case_file ?escalation_flag)
        (not
          (escalation_flag_available ?escalation_flag)
        )
      )
  )
  (:action perform_final_casefile_checks
    :parameters (?administrative_case_file - administrative_case_file ?student_actor - student_actor ?department_actor - department_actor ?course_record - course_record ?escalation_flag - escalation_flag)
    :precondition
      (and
        (committee_signature_verified ?administrative_case_file)
        (committee_signature_confirmed ?administrative_case_file)
        (casefile_has_escalation_flag ?administrative_case_file ?escalation_flag)
        (casefile_linked_student ?administrative_case_file ?student_actor)
        (casefile_linked_department ?administrative_case_file ?department_actor)
        (student_availability_confirmed ?student_actor)
        (department_availability_confirmed ?department_actor)
        (submission_includes_course ?administrative_case_file ?course_record)
        (not
          (casefile_final_checks_passed ?administrative_case_file)
        )
      )
    :effect (casefile_final_checks_passed ?administrative_case_file)
  )
  (:action close_casefile_after_final_checks
    :parameters (?administrative_case_file - administrative_case_file)
    :precondition
      (and
        (committee_signature_verified ?administrative_case_file)
        (casefile_final_checks_passed ?administrative_case_file)
        (not
          (casefile_finalized ?administrative_case_file)
        )
      )
    :effect
      (and
        (casefile_finalized ?administrative_case_file)
        (submission_finalization_marker_set ?administrative_case_file)
      )
  )
  (:action attach_department_document_to_casefile
    :parameters (?administrative_case_file - administrative_case_file ?department_document - department_document ?course_record - course_record)
    :precondition
      (and
        (record_validated ?administrative_case_file)
        (submission_includes_course ?administrative_case_file ?course_record)
        (department_document_available ?department_document)
        (casefile_includes_department_document ?administrative_case_file ?department_document)
        (not
          (department_document_verified ?administrative_case_file)
        )
      )
    :effect
      (and
        (department_document_verified ?administrative_case_file)
        (not
          (department_document_available ?department_document)
        )
      )
  )
  (:action review_department_document
    :parameters (?administrative_case_file - administrative_case_file ?reviewer_record - reviewer_record)
    :precondition
      (and
        (department_document_verified ?administrative_case_file)
        (submission_assigned_reviewer ?administrative_case_file ?reviewer_record)
        (not
          (department_document_approved ?administrative_case_file)
        )
      )
    :effect (department_document_approved ?administrative_case_file)
  )
  (:action confirm_department_document_with_dean_signature
    :parameters (?administrative_case_file - administrative_case_file ?dean_signature - dean_signature)
    :precondition
      (and
        (department_document_approved ?administrative_case_file)
        (casefile_has_dean_signature ?administrative_case_file ?dean_signature)
        (not
          (department_document_cleared ?administrative_case_file)
        )
      )
    :effect (department_document_cleared ?administrative_case_file)
  )
  (:action finalize_casefile_after_department_clearance
    :parameters (?administrative_case_file - administrative_case_file)
    :precondition
      (and
        (department_document_cleared ?administrative_case_file)
        (not
          (casefile_finalized ?administrative_case_file)
        )
      )
    :effect
      (and
        (casefile_finalized ?administrative_case_file)
        (submission_finalization_marker_set ?administrative_case_file)
      )
  )
  (:action record_final_approval_on_student_record
    :parameters (?student_actor - student_actor ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (student_ready_for_proposal ?student_actor)
        (student_availability_confirmed ?student_actor)
        (proposal_reserved ?schedule_proposal)
        (proposal_room_allocated ?schedule_proposal)
        (not
          (submission_finalization_marker_set ?student_actor)
        )
      )
    :effect (submission_finalization_marker_set ?student_actor)
  )
  (:action record_final_approval_on_department_record
    :parameters (?department_actor - department_actor ?schedule_proposal - schedule_proposal)
    :precondition
      (and
        (department_ready_for_proposal ?department_actor)
        (department_availability_confirmed ?department_actor)
        (proposal_reserved ?schedule_proposal)
        (proposal_room_allocated ?schedule_proposal)
        (not
          (submission_finalization_marker_set ?department_actor)
        )
      )
    :effect (submission_finalization_marker_set ?department_actor)
  )
  (:action attach_external_authorization_to_submission
    :parameters (?overload_application - overload_application ?external_authorization - external_authorization ?course_record - course_record)
    :precondition
      (and
        (submission_finalization_marker_set ?overload_application)
        (submission_includes_course ?overload_application ?course_record)
        (external_authorization_available ?external_authorization)
        (not
          (submission_authorized ?overload_application)
        )
      )
    :effect
      (and
        (submission_authorized ?overload_application)
        (submission_has_external_authorization ?overload_application ?external_authorization)
        (not
          (external_authorization_available ?external_authorization)
        )
      )
  )
  (:action finalize_student_authorization_and_release_token
    :parameters (?student_actor - student_actor ?approval_token - approval_token ?external_authorization - external_authorization)
    :precondition
      (and
        (submission_authorized ?student_actor)
        (submission_assigned_token ?student_actor ?approval_token)
        (submission_has_external_authorization ?student_actor ?external_authorization)
        (not
          (final_approval_recorded ?student_actor)
        )
      )
    :effect
      (and
        (final_approval_recorded ?student_actor)
        (approval_token_available ?approval_token)
        (external_authorization_available ?external_authorization)
      )
  )
  (:action finalize_department_authorization_and_release_token
    :parameters (?department_actor - department_actor ?approval_token - approval_token ?external_authorization - external_authorization)
    :precondition
      (and
        (submission_authorized ?department_actor)
        (submission_assigned_token ?department_actor ?approval_token)
        (submission_has_external_authorization ?department_actor ?external_authorization)
        (not
          (final_approval_recorded ?department_actor)
        )
      )
    :effect
      (and
        (final_approval_recorded ?department_actor)
        (approval_token_available ?approval_token)
        (external_authorization_available ?external_authorization)
      )
  )
  (:action finalize_casefile_authorization_and_release_token
    :parameters (?administrative_case_file - administrative_case_file ?approval_token - approval_token ?external_authorization - external_authorization)
    :precondition
      (and
        (submission_authorized ?administrative_case_file)
        (submission_assigned_token ?administrative_case_file ?approval_token)
        (submission_has_external_authorization ?administrative_case_file ?external_authorization)
        (not
          (final_approval_recorded ?administrative_case_file)
        )
      )
    :effect
      (and
        (final_approval_recorded ?administrative_case_file)
        (approval_token_available ?approval_token)
        (external_authorization_available ?external_authorization)
      )
  )
)

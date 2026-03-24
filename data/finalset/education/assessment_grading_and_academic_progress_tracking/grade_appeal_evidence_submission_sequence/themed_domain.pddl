(define (domain grade_appeal_evidence_submission_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity_root - object institution_resource_type - entity_root document_type_group - entity_root processing_slot_group - entity_root appeal_root - entity_root appeal_request - appeal_root submission_channel - institution_resource_type evidence_document - institution_resource_type reviewer - institution_resource_type expedited_authorization - institution_resource_type committee_assignment_token - institution_resource_type notification_token - institution_resource_type committee_review_token - institution_resource_type committee_decision_token - institution_resource_type supplementary_material - document_type_group document_batch - document_type_group external_authorization - document_type_group appellant_deadline_slot - processing_slot_group respondent_deadline_slot - processing_slot_group appeal_packet - processing_slot_group case_participation_group - appeal_request academic_record_group - appeal_request appellant_record - case_participation_group respondent_record - case_participation_group appeal_dossier - academic_record_group)

  (:predicates
    (intake_entity_registered ?appeal_request - appeal_request)
    (intake_entity_validated ?appeal_request - appeal_request)
    (channel_assigned ?appeal_request - appeal_request)
    (finalized_record ?appeal_request - appeal_request)
    (ready_for_recording_submission ?appeal_request - appeal_request)
    (outcome_recorded_submission ?appeal_request - appeal_request)
    (channel_available ?submission_channel - submission_channel)
    (intake_entity_channel_link ?appeal_request - appeal_request ?submission_channel - submission_channel)
    (evidence_available ?evidence_document - evidence_document)
    (evidence_attached_to_record ?appeal_request - appeal_request ?evidence_document - evidence_document)
    (reviewer_available ?reviewer - reviewer)
    (reviewer_assigned ?appeal_request - appeal_request ?reviewer - reviewer)
    (supplementary_available ?supplementary_material - supplementary_material)
    (appellant_supplementary_link ?appellant_record - appellant_record ?supplementary_material - supplementary_material)
    (respondent_supplementary_link ?respondent_record - respondent_record ?supplementary_material - supplementary_material)
    (participant_to_deadline ?appellant_record - appellant_record ?appellant_deadline_slot - appellant_deadline_slot)
    (appellant_deadline_confirmed ?appellant_deadline_slot - appellant_deadline_slot)
    (appellant_deadline_has_supplement ?appellant_deadline_slot - appellant_deadline_slot)
    (appellant_submission_ready ?appellant_record - appellant_record)
    (respondent_to_deadline ?respondent_record - respondent_record ?respondent_deadline_slot - respondent_deadline_slot)
    (respondent_deadline_confirmed ?respondent_deadline_slot - respondent_deadline_slot)
    (respondent_deadline_has_supplement ?respondent_deadline_slot - respondent_deadline_slot)
    (respondent_submission_ready ?respondent_record - respondent_record)
    (packet_slot_available ?appeal_packet - appeal_packet)
    (packet_created ?appeal_packet - appeal_packet)
    (packet_bound_appellant_deadline ?appeal_packet - appeal_packet ?appellant_deadline_slot - appellant_deadline_slot)
    (packet_bound_respondent_deadline ?appeal_packet - appeal_packet ?respondent_deadline_slot - respondent_deadline_slot)
    (packet_flag_stage_one ?appeal_packet - appeal_packet)
    (packet_flag_stage_two ?appeal_packet - appeal_packet)
    (packet_marked_for_processing ?appeal_packet - appeal_packet)
    (dossier_appellant_link ?appeal_dossier - appeal_dossier ?appellant_record - appellant_record)
    (dossier_respondent_link ?appeal_dossier - appeal_dossier ?respondent_record - respondent_record)
    (dossier_packet_link ?appeal_dossier - appeal_dossier ?appeal_packet - appeal_packet)
    (batch_available ?document_batch - document_batch)
    (dossier_has_batch ?appeal_dossier - appeal_dossier ?document_batch - document_batch)
    (batch_packaged ?document_batch - document_batch)
    (batch_bound_to_packet ?document_batch - document_batch ?appeal_packet - appeal_packet)
    (dossier_documents_validated ?appeal_dossier - appeal_dossier)
    (dossier_packaging_complete ?appeal_dossier - appeal_dossier)
    (committee_ready ?appeal_dossier - appeal_dossier)
    (expedited_authorization_granted ?appeal_dossier - appeal_dossier)
    (dossier_precheck_complete ?appeal_dossier - appeal_dossier)
    (committee_review_authorized ?appeal_dossier - appeal_dossier)
    (committee_members_assigned ?appeal_dossier - appeal_dossier)
    (external_authorization_available ?external_authorization - external_authorization)
    (dossier_external_authorization_link ?appeal_dossier - appeal_dossier ?external_authorization - external_authorization)
    (external_authorization_applied ?appeal_dossier - appeal_dossier)
    (external_authorization_confirmed ?appeal_dossier - appeal_dossier)
    (external_authorization_review_complete ?appeal_dossier - appeal_dossier)
    (expedited_authorization_available ?expedited_authorization - expedited_authorization)
    (dossier_expedited_link ?appeal_dossier - appeal_dossier ?expedited_authorization - expedited_authorization)
    (committee_assignment_token_available ?committee_assignment_token - committee_assignment_token)
    (dossier_committee_assignment_token_link ?appeal_dossier - appeal_dossier ?committee_assignment_token - committee_assignment_token)
    (committee_review_token_available ?committee_review_token - committee_review_token)
    (dossier_committee_review_token_link ?appeal_dossier - appeal_dossier ?committee_review_token - committee_review_token)
    (committee_decision_token_available ?committee_decision_token - committee_decision_token)
    (dossier_committee_decision_token_link ?appeal_dossier - appeal_dossier ?committee_decision_token - committee_decision_token)
    (notification_token_available ?notification_token - notification_token)
    (intake_entity_notification_link ?appeal_request - appeal_request ?notification_token - notification_token)
    (appellant_ready_for_packet ?appellant_record - appellant_record)
    (respondent_ready_for_packet ?respondent_record - respondent_record)
    (dossier_locked_and_recorded ?appeal_dossier - appeal_dossier)
  )
  (:action create_appeal_intake
    :parameters (?appeal_request - appeal_request)
    :precondition
      (and
        (not
          (intake_entity_registered ?appeal_request)
        )
        (not
          (finalized_record ?appeal_request)
        )
      )
    :effect (intake_entity_registered ?appeal_request)
  )
  (:action assign_submission_channel
    :parameters (?appeal_request - appeal_request ?submission_channel - submission_channel)
    :precondition
      (and
        (intake_entity_registered ?appeal_request)
        (not
          (channel_assigned ?appeal_request)
        )
        (channel_available ?submission_channel)
      )
    :effect
      (and
        (channel_assigned ?appeal_request)
        (intake_entity_channel_link ?appeal_request ?submission_channel)
        (not
          (channel_available ?submission_channel)
        )
      )
  )
  (:action attach_evidence_document
    :parameters (?appeal_request - appeal_request ?evidence_document - evidence_document)
    :precondition
      (and
        (intake_entity_registered ?appeal_request)
        (channel_assigned ?appeal_request)
        (evidence_available ?evidence_document)
      )
    :effect
      (and
        (evidence_attached_to_record ?appeal_request ?evidence_document)
        (not
          (evidence_available ?evidence_document)
        )
      )
  )
  (:action validate_intake
    :parameters (?appeal_request - appeal_request ?evidence_document - evidence_document)
    :precondition
      (and
        (intake_entity_registered ?appeal_request)
        (channel_assigned ?appeal_request)
        (evidence_attached_to_record ?appeal_request ?evidence_document)
        (not
          (intake_entity_validated ?appeal_request)
        )
      )
    :effect (intake_entity_validated ?appeal_request)
  )
  (:action detach_evidence_document
    :parameters (?appeal_request - appeal_request ?evidence_document - evidence_document)
    :precondition
      (and
        (evidence_attached_to_record ?appeal_request ?evidence_document)
      )
    :effect
      (and
        (evidence_available ?evidence_document)
        (not
          (evidence_attached_to_record ?appeal_request ?evidence_document)
        )
      )
  )
  (:action assign_reviewer_to_intake
    :parameters (?appeal_request - appeal_request ?reviewer - reviewer)
    :precondition
      (and
        (intake_entity_validated ?appeal_request)
        (reviewer_available ?reviewer)
      )
    :effect
      (and
        (reviewer_assigned ?appeal_request ?reviewer)
        (not
          (reviewer_available ?reviewer)
        )
      )
  )
  (:action unassign_reviewer_from_intake
    :parameters (?appeal_request - appeal_request ?reviewer - reviewer)
    :precondition
      (and
        (reviewer_assigned ?appeal_request ?reviewer)
      )
    :effect
      (and
        (reviewer_available ?reviewer)
        (not
          (reviewer_assigned ?appeal_request ?reviewer)
        )
      )
  )
  (:action assign_committee_review_token
    :parameters (?appeal_dossier - appeal_dossier ?committee_review_token - committee_review_token)
    :precondition
      (and
        (intake_entity_validated ?appeal_dossier)
        (committee_review_token_available ?committee_review_token)
      )
    :effect
      (and
        (dossier_committee_review_token_link ?appeal_dossier ?committee_review_token)
        (not
          (committee_review_token_available ?committee_review_token)
        )
      )
  )
  (:action release_committee_review_token
    :parameters (?appeal_dossier - appeal_dossier ?committee_review_token - committee_review_token)
    :precondition
      (and
        (dossier_committee_review_token_link ?appeal_dossier ?committee_review_token)
      )
    :effect
      (and
        (committee_review_token_available ?committee_review_token)
        (not
          (dossier_committee_review_token_link ?appeal_dossier ?committee_review_token)
        )
      )
  )
  (:action assign_committee_decision_token
    :parameters (?appeal_dossier - appeal_dossier ?committee_decision_token - committee_decision_token)
    :precondition
      (and
        (intake_entity_validated ?appeal_dossier)
        (committee_decision_token_available ?committee_decision_token)
      )
    :effect
      (and
        (dossier_committee_decision_token_link ?appeal_dossier ?committee_decision_token)
        (not
          (committee_decision_token_available ?committee_decision_token)
        )
      )
  )
  (:action release_committee_decision_token
    :parameters (?appeal_dossier - appeal_dossier ?committee_decision_token - committee_decision_token)
    :precondition
      (and
        (dossier_committee_decision_token_link ?appeal_dossier ?committee_decision_token)
      )
    :effect
      (and
        (committee_decision_token_available ?committee_decision_token)
        (not
          (dossier_committee_decision_token_link ?appeal_dossier ?committee_decision_token)
        )
      )
  )
  (:action claim_appellant_deadline_slot
    :parameters (?appellant_record - appellant_record ?appellant_deadline_slot - appellant_deadline_slot ?evidence_document - evidence_document)
    :precondition
      (and
        (intake_entity_validated ?appellant_record)
        (evidence_attached_to_record ?appellant_record ?evidence_document)
        (participant_to_deadline ?appellant_record ?appellant_deadline_slot)
        (not
          (appellant_deadline_confirmed ?appellant_deadline_slot)
        )
        (not
          (appellant_deadline_has_supplement ?appellant_deadline_slot)
        )
      )
    :effect (appellant_deadline_confirmed ?appellant_deadline_slot)
  )
  (:action confirm_appellant_submission_by_reviewer
    :parameters (?appellant_record - appellant_record ?appellant_deadline_slot - appellant_deadline_slot ?reviewer - reviewer)
    :precondition
      (and
        (intake_entity_validated ?appellant_record)
        (reviewer_assigned ?appellant_record ?reviewer)
        (participant_to_deadline ?appellant_record ?appellant_deadline_slot)
        (appellant_deadline_confirmed ?appellant_deadline_slot)
        (not
          (appellant_ready_for_packet ?appellant_record)
        )
      )
    :effect
      (and
        (appellant_ready_for_packet ?appellant_record)
        (appellant_submission_ready ?appellant_record)
      )
  )
  (:action attach_supplementary_to_appellant_record
    :parameters (?appellant_record - appellant_record ?appellant_deadline_slot - appellant_deadline_slot ?supplementary_material - supplementary_material)
    :precondition
      (and
        (intake_entity_validated ?appellant_record)
        (participant_to_deadline ?appellant_record ?appellant_deadline_slot)
        (supplementary_available ?supplementary_material)
        (not
          (appellant_ready_for_packet ?appellant_record)
        )
      )
    :effect
      (and
        (appellant_deadline_has_supplement ?appellant_deadline_slot)
        (appellant_ready_for_packet ?appellant_record)
        (appellant_supplementary_link ?appellant_record ?supplementary_material)
        (not
          (supplementary_available ?supplementary_material)
        )
      )
  )
  (:action confirm_appellant_supplementary_processing
    :parameters (?appellant_record - appellant_record ?appellant_deadline_slot - appellant_deadline_slot ?evidence_document - evidence_document ?supplementary_material - supplementary_material)
    :precondition
      (and
        (intake_entity_validated ?appellant_record)
        (evidence_attached_to_record ?appellant_record ?evidence_document)
        (participant_to_deadline ?appellant_record ?appellant_deadline_slot)
        (appellant_deadline_has_supplement ?appellant_deadline_slot)
        (appellant_supplementary_link ?appellant_record ?supplementary_material)
        (not
          (appellant_submission_ready ?appellant_record)
        )
      )
    :effect
      (and
        (appellant_deadline_confirmed ?appellant_deadline_slot)
        (appellant_submission_ready ?appellant_record)
        (supplementary_available ?supplementary_material)
        (not
          (appellant_supplementary_link ?appellant_record ?supplementary_material)
        )
      )
  )
  (:action claim_respondent_deadline_slot
    :parameters (?respondent_record - respondent_record ?respondent_deadline_slot - respondent_deadline_slot ?evidence_document - evidence_document)
    :precondition
      (and
        (intake_entity_validated ?respondent_record)
        (evidence_attached_to_record ?respondent_record ?evidence_document)
        (respondent_to_deadline ?respondent_record ?respondent_deadline_slot)
        (not
          (respondent_deadline_confirmed ?respondent_deadline_slot)
        )
        (not
          (respondent_deadline_has_supplement ?respondent_deadline_slot)
        )
      )
    :effect (respondent_deadline_confirmed ?respondent_deadline_slot)
  )
  (:action confirm_respondent_submission_by_reviewer
    :parameters (?respondent_record - respondent_record ?respondent_deadline_slot - respondent_deadline_slot ?reviewer - reviewer)
    :precondition
      (and
        (intake_entity_validated ?respondent_record)
        (reviewer_assigned ?respondent_record ?reviewer)
        (respondent_to_deadline ?respondent_record ?respondent_deadline_slot)
        (respondent_deadline_confirmed ?respondent_deadline_slot)
        (not
          (respondent_ready_for_packet ?respondent_record)
        )
      )
    :effect
      (and
        (respondent_ready_for_packet ?respondent_record)
        (respondent_submission_ready ?respondent_record)
      )
  )
  (:action attach_supplementary_to_respondent_record
    :parameters (?respondent_record - respondent_record ?respondent_deadline_slot - respondent_deadline_slot ?supplementary_material - supplementary_material)
    :precondition
      (and
        (intake_entity_validated ?respondent_record)
        (respondent_to_deadline ?respondent_record ?respondent_deadline_slot)
        (supplementary_available ?supplementary_material)
        (not
          (respondent_ready_for_packet ?respondent_record)
        )
      )
    :effect
      (and
        (respondent_deadline_has_supplement ?respondent_deadline_slot)
        (respondent_ready_for_packet ?respondent_record)
        (respondent_supplementary_link ?respondent_record ?supplementary_material)
        (not
          (supplementary_available ?supplementary_material)
        )
      )
  )
  (:action confirm_respondent_supplementary_processing
    :parameters (?respondent_record - respondent_record ?respondent_deadline_slot - respondent_deadline_slot ?evidence_document - evidence_document ?supplementary_material - supplementary_material)
    :precondition
      (and
        (intake_entity_validated ?respondent_record)
        (evidence_attached_to_record ?respondent_record ?evidence_document)
        (respondent_to_deadline ?respondent_record ?respondent_deadline_slot)
        (respondent_deadline_has_supplement ?respondent_deadline_slot)
        (respondent_supplementary_link ?respondent_record ?supplementary_material)
        (not
          (respondent_submission_ready ?respondent_record)
        )
      )
    :effect
      (and
        (respondent_deadline_confirmed ?respondent_deadline_slot)
        (respondent_submission_ready ?respondent_record)
        (supplementary_available ?supplementary_material)
        (not
          (respondent_supplementary_link ?respondent_record ?supplementary_material)
        )
      )
  )
  (:action create_appeal_packet
    :parameters (?appellant_record - appellant_record ?respondent_record - respondent_record ?appellant_deadline_slot - appellant_deadline_slot ?respondent_deadline_slot - respondent_deadline_slot ?appeal_packet - appeal_packet)
    :precondition
      (and
        (appellant_ready_for_packet ?appellant_record)
        (respondent_ready_for_packet ?respondent_record)
        (participant_to_deadline ?appellant_record ?appellant_deadline_slot)
        (respondent_to_deadline ?respondent_record ?respondent_deadline_slot)
        (appellant_deadline_confirmed ?appellant_deadline_slot)
        (respondent_deadline_confirmed ?respondent_deadline_slot)
        (appellant_submission_ready ?appellant_record)
        (respondent_submission_ready ?respondent_record)
        (packet_slot_available ?appeal_packet)
      )
    :effect
      (and
        (packet_created ?appeal_packet)
        (packet_bound_appellant_deadline ?appeal_packet ?appellant_deadline_slot)
        (packet_bound_respondent_deadline ?appeal_packet ?respondent_deadline_slot)
        (not
          (packet_slot_available ?appeal_packet)
        )
      )
  )
  (:action assemble_appeal_packet_with_appellant_supplement
    :parameters (?appellant_record - appellant_record ?respondent_record - respondent_record ?appellant_deadline_slot - appellant_deadline_slot ?respondent_deadline_slot - respondent_deadline_slot ?appeal_packet - appeal_packet)
    :precondition
      (and
        (appellant_ready_for_packet ?appellant_record)
        (respondent_ready_for_packet ?respondent_record)
        (participant_to_deadline ?appellant_record ?appellant_deadline_slot)
        (respondent_to_deadline ?respondent_record ?respondent_deadline_slot)
        (appellant_deadline_has_supplement ?appellant_deadline_slot)
        (respondent_deadline_confirmed ?respondent_deadline_slot)
        (not
          (appellant_submission_ready ?appellant_record)
        )
        (respondent_submission_ready ?respondent_record)
        (packet_slot_available ?appeal_packet)
      )
    :effect
      (and
        (packet_created ?appeal_packet)
        (packet_bound_appellant_deadline ?appeal_packet ?appellant_deadline_slot)
        (packet_bound_respondent_deadline ?appeal_packet ?respondent_deadline_slot)
        (packet_flag_stage_one ?appeal_packet)
        (not
          (packet_slot_available ?appeal_packet)
        )
      )
  )
  (:action assemble_appeal_packet_with_respondent_supplement
    :parameters (?appellant_record - appellant_record ?respondent_record - respondent_record ?appellant_deadline_slot - appellant_deadline_slot ?respondent_deadline_slot - respondent_deadline_slot ?appeal_packet - appeal_packet)
    :precondition
      (and
        (appellant_ready_for_packet ?appellant_record)
        (respondent_ready_for_packet ?respondent_record)
        (participant_to_deadline ?appellant_record ?appellant_deadline_slot)
        (respondent_to_deadline ?respondent_record ?respondent_deadline_slot)
        (appellant_deadline_confirmed ?appellant_deadline_slot)
        (respondent_deadline_has_supplement ?respondent_deadline_slot)
        (appellant_submission_ready ?appellant_record)
        (not
          (respondent_submission_ready ?respondent_record)
        )
        (packet_slot_available ?appeal_packet)
      )
    :effect
      (and
        (packet_created ?appeal_packet)
        (packet_bound_appellant_deadline ?appeal_packet ?appellant_deadline_slot)
        (packet_bound_respondent_deadline ?appeal_packet ?respondent_deadline_slot)
        (packet_flag_stage_two ?appeal_packet)
        (not
          (packet_slot_available ?appeal_packet)
        )
      )
  )
  (:action assemble_appeal_packet_with_both_supplements
    :parameters (?appellant_record - appellant_record ?respondent_record - respondent_record ?appellant_deadline_slot - appellant_deadline_slot ?respondent_deadline_slot - respondent_deadline_slot ?appeal_packet - appeal_packet)
    :precondition
      (and
        (appellant_ready_for_packet ?appellant_record)
        (respondent_ready_for_packet ?respondent_record)
        (participant_to_deadline ?appellant_record ?appellant_deadline_slot)
        (respondent_to_deadline ?respondent_record ?respondent_deadline_slot)
        (appellant_deadline_has_supplement ?appellant_deadline_slot)
        (respondent_deadline_has_supplement ?respondent_deadline_slot)
        (not
          (appellant_submission_ready ?appellant_record)
        )
        (not
          (respondent_submission_ready ?respondent_record)
        )
        (packet_slot_available ?appeal_packet)
      )
    :effect
      (and
        (packet_created ?appeal_packet)
        (packet_bound_appellant_deadline ?appeal_packet ?appellant_deadline_slot)
        (packet_bound_respondent_deadline ?appeal_packet ?respondent_deadline_slot)
        (packet_flag_stage_one ?appeal_packet)
        (packet_flag_stage_two ?appeal_packet)
        (not
          (packet_slot_available ?appeal_packet)
        )
      )
  )
  (:action mark_packet_for_document_processing
    :parameters (?appeal_packet - appeal_packet ?appellant_record - appellant_record ?evidence_document - evidence_document)
    :precondition
      (and
        (packet_created ?appeal_packet)
        (appellant_ready_for_packet ?appellant_record)
        (evidence_attached_to_record ?appellant_record ?evidence_document)
        (not
          (packet_marked_for_processing ?appeal_packet)
        )
      )
    :effect (packet_marked_for_processing ?appeal_packet)
  )
  (:action attach_batch_to_dossier
    :parameters (?appeal_dossier - appeal_dossier ?document_batch - document_batch ?appeal_packet - appeal_packet)
    :precondition
      (and
        (intake_entity_validated ?appeal_dossier)
        (dossier_packet_link ?appeal_dossier ?appeal_packet)
        (dossier_has_batch ?appeal_dossier ?document_batch)
        (batch_available ?document_batch)
        (packet_created ?appeal_packet)
        (packet_marked_for_processing ?appeal_packet)
        (not
          (batch_packaged ?document_batch)
        )
      )
    :effect
      (and
        (batch_packaged ?document_batch)
        (batch_bound_to_packet ?document_batch ?appeal_packet)
        (not
          (batch_available ?document_batch)
        )
      )
  )
  (:action validate_and_lock_dossier_documents
    :parameters (?appeal_dossier - appeal_dossier ?document_batch - document_batch ?appeal_packet - appeal_packet ?evidence_document - evidence_document)
    :precondition
      (and
        (intake_entity_validated ?appeal_dossier)
        (dossier_has_batch ?appeal_dossier ?document_batch)
        (batch_packaged ?document_batch)
        (batch_bound_to_packet ?document_batch ?appeal_packet)
        (evidence_attached_to_record ?appeal_dossier ?evidence_document)
        (not
          (packet_flag_stage_one ?appeal_packet)
        )
        (not
          (dossier_documents_validated ?appeal_dossier)
        )
      )
    :effect (dossier_documents_validated ?appeal_dossier)
  )
  (:action apply_expedited_authorization_to_dossier
    :parameters (?appeal_dossier - appeal_dossier ?expedited_authorization - expedited_authorization)
    :precondition
      (and
        (intake_entity_validated ?appeal_dossier)
        (expedited_authorization_available ?expedited_authorization)
        (not
          (expedited_authorization_granted ?appeal_dossier)
        )
      )
    :effect
      (and
        (expedited_authorization_granted ?appeal_dossier)
        (dossier_expedited_link ?appeal_dossier ?expedited_authorization)
        (not
          (expedited_authorization_available ?expedited_authorization)
        )
      )
  )
  (:action prepare_dossier_with_expedited_authorization
    :parameters (?appeal_dossier - appeal_dossier ?document_batch - document_batch ?appeal_packet - appeal_packet ?evidence_document - evidence_document ?expedited_authorization - expedited_authorization)
    :precondition
      (and
        (intake_entity_validated ?appeal_dossier)
        (dossier_has_batch ?appeal_dossier ?document_batch)
        (batch_packaged ?document_batch)
        (batch_bound_to_packet ?document_batch ?appeal_packet)
        (evidence_attached_to_record ?appeal_dossier ?evidence_document)
        (packet_flag_stage_one ?appeal_packet)
        (expedited_authorization_granted ?appeal_dossier)
        (dossier_expedited_link ?appeal_dossier ?expedited_authorization)
        (not
          (dossier_documents_validated ?appeal_dossier)
        )
      )
    :effect
      (and
        (dossier_documents_validated ?appeal_dossier)
        (dossier_precheck_complete ?appeal_dossier)
      )
  )
  (:action activate_dossier_for_committee_review_primary
    :parameters (?appeal_dossier - appeal_dossier ?committee_review_token - committee_review_token ?reviewer - reviewer ?document_batch - document_batch ?appeal_packet - appeal_packet)
    :precondition
      (and
        (dossier_documents_validated ?appeal_dossier)
        (dossier_committee_review_token_link ?appeal_dossier ?committee_review_token)
        (reviewer_assigned ?appeal_dossier ?reviewer)
        (dossier_has_batch ?appeal_dossier ?document_batch)
        (batch_bound_to_packet ?document_batch ?appeal_packet)
        (not
          (packet_flag_stage_two ?appeal_packet)
        )
        (not
          (dossier_packaging_complete ?appeal_dossier)
        )
      )
    :effect (dossier_packaging_complete ?appeal_dossier)
  )
  (:action activate_dossier_for_committee_review_secondary
    :parameters (?appeal_dossier - appeal_dossier ?committee_review_token - committee_review_token ?reviewer - reviewer ?document_batch - document_batch ?appeal_packet - appeal_packet)
    :precondition
      (and
        (dossier_documents_validated ?appeal_dossier)
        (dossier_committee_review_token_link ?appeal_dossier ?committee_review_token)
        (reviewer_assigned ?appeal_dossier ?reviewer)
        (dossier_has_batch ?appeal_dossier ?document_batch)
        (batch_bound_to_packet ?document_batch ?appeal_packet)
        (packet_flag_stage_two ?appeal_packet)
        (not
          (dossier_packaging_complete ?appeal_dossier)
        )
      )
    :effect (dossier_packaging_complete ?appeal_dossier)
  )
  (:action queue_dossier_for_committee_readiness
    :parameters (?appeal_dossier - appeal_dossier ?committee_decision_token - committee_decision_token ?document_batch - document_batch ?appeal_packet - appeal_packet)
    :precondition
      (and
        (dossier_packaging_complete ?appeal_dossier)
        (dossier_committee_decision_token_link ?appeal_dossier ?committee_decision_token)
        (dossier_has_batch ?appeal_dossier ?document_batch)
        (batch_bound_to_packet ?document_batch ?appeal_packet)
        (not
          (packet_flag_stage_one ?appeal_packet)
        )
        (not
          (packet_flag_stage_two ?appeal_packet)
        )
        (not
          (committee_ready ?appeal_dossier)
        )
      )
    :effect (committee_ready ?appeal_dossier)
  )
  (:action authorize_committee_review_stage_two
    :parameters (?appeal_dossier - appeal_dossier ?committee_decision_token - committee_decision_token ?document_batch - document_batch ?appeal_packet - appeal_packet)
    :precondition
      (and
        (dossier_packaging_complete ?appeal_dossier)
        (dossier_committee_decision_token_link ?appeal_dossier ?committee_decision_token)
        (dossier_has_batch ?appeal_dossier ?document_batch)
        (batch_bound_to_packet ?document_batch ?appeal_packet)
        (packet_flag_stage_one ?appeal_packet)
        (not
          (packet_flag_stage_two ?appeal_packet)
        )
        (not
          (committee_ready ?appeal_dossier)
        )
      )
    :effect
      (and
        (committee_ready ?appeal_dossier)
        (committee_review_authorized ?appeal_dossier)
      )
  )
  (:action authorize_committee_review_with_packet_stage_two
    :parameters (?appeal_dossier - appeal_dossier ?committee_decision_token - committee_decision_token ?document_batch - document_batch ?appeal_packet - appeal_packet)
    :precondition
      (and
        (dossier_packaging_complete ?appeal_dossier)
        (dossier_committee_decision_token_link ?appeal_dossier ?committee_decision_token)
        (dossier_has_batch ?appeal_dossier ?document_batch)
        (batch_bound_to_packet ?document_batch ?appeal_packet)
        (not
          (packet_flag_stage_one ?appeal_packet)
        )
        (packet_flag_stage_two ?appeal_packet)
        (not
          (committee_ready ?appeal_dossier)
        )
      )
    :effect
      (and
        (committee_ready ?appeal_dossier)
        (committee_review_authorized ?appeal_dossier)
      )
  )
  (:action authorize_committee_review_full
    :parameters (?appeal_dossier - appeal_dossier ?committee_decision_token - committee_decision_token ?document_batch - document_batch ?appeal_packet - appeal_packet)
    :precondition
      (and
        (dossier_packaging_complete ?appeal_dossier)
        (dossier_committee_decision_token_link ?appeal_dossier ?committee_decision_token)
        (dossier_has_batch ?appeal_dossier ?document_batch)
        (batch_bound_to_packet ?document_batch ?appeal_packet)
        (packet_flag_stage_one ?appeal_packet)
        (packet_flag_stage_two ?appeal_packet)
        (not
          (committee_ready ?appeal_dossier)
        )
      )
    :effect
      (and
        (committee_ready ?appeal_dossier)
        (committee_review_authorized ?appeal_dossier)
      )
  )
  (:action flag_dossier_for_recording
    :parameters (?appeal_dossier - appeal_dossier)
    :precondition
      (and
        (committee_ready ?appeal_dossier)
        (not
          (committee_review_authorized ?appeal_dossier)
        )
        (not
          (dossier_locked_and_recorded ?appeal_dossier)
        )
      )
    :effect
      (and
        (dossier_locked_and_recorded ?appeal_dossier)
        (ready_for_recording_submission ?appeal_dossier)
      )
  )
  (:action assign_committee_assignment_token
    :parameters (?appeal_dossier - appeal_dossier ?committee_assignment_token - committee_assignment_token)
    :precondition
      (and
        (committee_ready ?appeal_dossier)
        (committee_review_authorized ?appeal_dossier)
        (committee_assignment_token_available ?committee_assignment_token)
      )
    :effect
      (and
        (dossier_committee_assignment_token_link ?appeal_dossier ?committee_assignment_token)
        (not
          (committee_assignment_token_available ?committee_assignment_token)
        )
      )
  )
  (:action assign_committee_to_dossier
    :parameters (?appeal_dossier - appeal_dossier ?appellant_record - appellant_record ?respondent_record - respondent_record ?evidence_document - evidence_document ?committee_assignment_token - committee_assignment_token)
    :precondition
      (and
        (committee_ready ?appeal_dossier)
        (committee_review_authorized ?appeal_dossier)
        (dossier_committee_assignment_token_link ?appeal_dossier ?committee_assignment_token)
        (dossier_appellant_link ?appeal_dossier ?appellant_record)
        (dossier_respondent_link ?appeal_dossier ?respondent_record)
        (appellant_submission_ready ?appellant_record)
        (respondent_submission_ready ?respondent_record)
        (evidence_attached_to_record ?appeal_dossier ?evidence_document)
        (not
          (committee_members_assigned ?appeal_dossier)
        )
      )
    :effect (committee_members_assigned ?appeal_dossier)
  )
  (:action record_dossier_finalization_post_assignment
    :parameters (?appeal_dossier - appeal_dossier)
    :precondition
      (and
        (committee_ready ?appeal_dossier)
        (committee_members_assigned ?appeal_dossier)
        (not
          (dossier_locked_and_recorded ?appeal_dossier)
        )
      )
    :effect
      (and
        (dossier_locked_and_recorded ?appeal_dossier)
        (ready_for_recording_submission ?appeal_dossier)
      )
  )
  (:action apply_external_authorization_to_dossier
    :parameters (?appeal_dossier - appeal_dossier ?external_authorization - external_authorization ?evidence_document - evidence_document)
    :precondition
      (and
        (intake_entity_validated ?appeal_dossier)
        (evidence_attached_to_record ?appeal_dossier ?evidence_document)
        (external_authorization_available ?external_authorization)
        (dossier_external_authorization_link ?appeal_dossier ?external_authorization)
        (not
          (external_authorization_applied ?appeal_dossier)
        )
      )
    :effect
      (and
        (external_authorization_applied ?appeal_dossier)
        (not
          (external_authorization_available ?external_authorization)
        )
      )
  )
  (:action confirm_external_authorization
    :parameters (?appeal_dossier - appeal_dossier ?reviewer - reviewer)
    :precondition
      (and
        (external_authorization_applied ?appeal_dossier)
        (reviewer_assigned ?appeal_dossier ?reviewer)
        (not
          (external_authorization_confirmed ?appeal_dossier)
        )
      )
    :effect (external_authorization_confirmed ?appeal_dossier)
  )
  (:action record_external_authorization_review
    :parameters (?appeal_dossier - appeal_dossier ?committee_decision_token - committee_decision_token)
    :precondition
      (and
        (external_authorization_confirmed ?appeal_dossier)
        (dossier_committee_decision_token_link ?appeal_dossier ?committee_decision_token)
        (not
          (external_authorization_review_complete ?appeal_dossier)
        )
      )
    :effect (external_authorization_review_complete ?appeal_dossier)
  )
  (:action finalize_dossier_after_external_authorization
    :parameters (?appeal_dossier - appeal_dossier)
    :precondition
      (and
        (external_authorization_review_complete ?appeal_dossier)
        (not
          (dossier_locked_and_recorded ?appeal_dossier)
        )
      )
    :effect
      (and
        (dossier_locked_and_recorded ?appeal_dossier)
        (ready_for_recording_submission ?appeal_dossier)
      )
  )
  (:action finalize_appellant_record
    :parameters (?appellant_record - appellant_record ?appeal_packet - appeal_packet)
    :precondition
      (and
        (appellant_ready_for_packet ?appellant_record)
        (appellant_submission_ready ?appellant_record)
        (packet_created ?appeal_packet)
        (packet_marked_for_processing ?appeal_packet)
        (not
          (ready_for_recording_submission ?appellant_record)
        )
      )
    :effect (ready_for_recording_submission ?appellant_record)
  )
  (:action finalize_respondent_record
    :parameters (?respondent_record - respondent_record ?appeal_packet - appeal_packet)
    :precondition
      (and
        (respondent_ready_for_packet ?respondent_record)
        (respondent_submission_ready ?respondent_record)
        (packet_created ?appeal_packet)
        (packet_marked_for_processing ?appeal_packet)
        (not
          (ready_for_recording_submission ?respondent_record)
        )
      )
    :effect (ready_for_recording_submission ?respondent_record)
  )
  (:action record_outcome_and_issue_notification
    :parameters (?appeal_request - appeal_request ?notification_token - notification_token ?evidence_document - evidence_document)
    :precondition
      (and
        (ready_for_recording_submission ?appeal_request)
        (evidence_attached_to_record ?appeal_request ?evidence_document)
        (notification_token_available ?notification_token)
        (not
          (outcome_recorded_submission ?appeal_request)
        )
      )
    :effect
      (and
        (outcome_recorded_submission ?appeal_request)
        (intake_entity_notification_link ?appeal_request ?notification_token)
        (not
          (notification_token_available ?notification_token)
        )
      )
  )
  (:action propagate_finalization_to_appellant_and_release_channel
    :parameters (?appellant_record - appellant_record ?submission_channel - submission_channel ?notification_token - notification_token)
    :precondition
      (and
        (outcome_recorded_submission ?appellant_record)
        (intake_entity_channel_link ?appellant_record ?submission_channel)
        (intake_entity_notification_link ?appellant_record ?notification_token)
        (not
          (finalized_record ?appellant_record)
        )
      )
    :effect
      (and
        (finalized_record ?appellant_record)
        (channel_available ?submission_channel)
        (notification_token_available ?notification_token)
      )
  )
  (:action propagate_finalization_to_respondent_and_release_channel
    :parameters (?respondent_record - respondent_record ?submission_channel - submission_channel ?notification_token - notification_token)
    :precondition
      (and
        (outcome_recorded_submission ?respondent_record)
        (intake_entity_channel_link ?respondent_record ?submission_channel)
        (intake_entity_notification_link ?respondent_record ?notification_token)
        (not
          (finalized_record ?respondent_record)
        )
      )
    :effect
      (and
        (finalized_record ?respondent_record)
        (channel_available ?submission_channel)
        (notification_token_available ?notification_token)
      )
  )
  (:action propagate_finalization_to_dossier_and_release_channel
    :parameters (?appeal_dossier - appeal_dossier ?submission_channel - submission_channel ?notification_token - notification_token)
    :precondition
      (and
        (outcome_recorded_submission ?appeal_dossier)
        (intake_entity_channel_link ?appeal_dossier ?submission_channel)
        (intake_entity_notification_link ?appeal_dossier ?notification_token)
        (not
          (finalized_record ?appeal_dossier)
        )
      )
    :effect
      (and
        (finalized_record ?appeal_dossier)
        (channel_available ?submission_channel)
        (notification_token_available ?notification_token)
      )
  )
)

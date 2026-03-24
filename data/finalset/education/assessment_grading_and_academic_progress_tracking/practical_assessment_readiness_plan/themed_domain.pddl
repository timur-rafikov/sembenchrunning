(define (domain practical_assessment_readiness_plan_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types administrative_entity - object institutional_resource - object auxiliary_resource - object plan_container - object assessable_entity - plan_container availability_slot - administrative_entity assessment_session - administrative_entity proctor - administrative_entity endorsement_request - administrative_entity grading_component - administrative_entity eligibility_certificate - administrative_entity equipment_certification - administrative_entity external_audit_token - administrative_entity remediation_resource - institutional_resource evidence_document - institutional_resource special_accommodation_request - institutional_resource competency_item - auxiliary_resource peer_competency_item - auxiliary_resource submission_record - auxiliary_resource candidate_grouping - assessable_entity assessor_grouping - assessable_entity candidate - candidate_grouping peer_candidate - candidate_grouping assessor - assessor_grouping)
  (:predicates
    (entity_registered ?plan - assessable_entity)
    (entity_confirmed ?plan - assessable_entity)
    (entity_reserved ?plan - assessable_entity)
    (entity_certified ?plan - assessable_entity)
    (final_approval_granted ?plan - assessable_entity)
    (certificate_consumed ?plan - assessable_entity)
    (slot_available ?availability_slot - availability_slot)
    (entity_reserved_slot ?plan - assessable_entity ?availability_slot - availability_slot)
    (session_available ?assessment_session - assessment_session)
    (entity_assigned_session ?plan - assessable_entity ?assessment_session - assessment_session)
    (proctor_available ?proctor - proctor)
    (entity_assigned_proctor ?plan - assessable_entity ?proctor - proctor)
    (remediation_resource_available ?remediation_resource - remediation_resource)
    (candidate_remediation_assigned ?candidate - candidate ?remediation_resource - remediation_resource)
    (peer_remediation_assigned ?peer_candidate - peer_candidate ?remediation_resource - remediation_resource)
    (candidate_competency_assigned ?candidate - candidate ?competency_item - competency_item)
    (competency_item_locked ?competency_item - competency_item)
    (competency_item_under_remediation ?competency_item - competency_item)
    (candidate_component_verified ?candidate - candidate)
    (peer_competency_assigned ?peer_candidate - peer_candidate ?peer_competency_item - peer_competency_item)
    (peer_competency_locked ?peer_competency_item - peer_competency_item)
    (peer_competency_under_remediation ?peer_competency_item - peer_competency_item)
    (peer_component_verified ?peer_candidate - peer_candidate)
    (submission_slot_open ?submission_record - submission_record)
    (submission_record_created ?submission_record - submission_record)
    (submission_links_competency ?submission_record - submission_record ?competency_item - competency_item)
    (submission_links_peer_competency ?submission_record - submission_record ?peer_competency_item - peer_competency_item)
    (submission_candidate_remediation_flag ?submission_record - submission_record)
    (submission_peer_remediation_flag ?submission_record - submission_record)
    (submission_materials_verified ?submission_record - submission_record)
    (assessor_assigned_candidate ?assessor - assessor ?candidate - candidate)
    (assessor_assigned_peer ?assessor - assessor ?peer_candidate - peer_candidate)
    (assessor_assigned_submission ?assessor - assessor ?submission_record - submission_record)
    (evidence_available ?evidence_document - evidence_document)
    (assessor_has_evidence ?assessor - assessor ?evidence_document - evidence_document)
    (evidence_validated ?evidence_document - evidence_document)
    (evidence_linked_submission ?evidence_document - evidence_document ?submission_record - submission_record)
    (assessor_prepared ?assessor - assessor)
    (assessor_claimed_review ?assessor - assessor)
    (assessor_verification_complete ?assessor - assessor)
    (assessor_endorsement_requested ?assessor - assessor)
    (assessor_endorsement_attached ?assessor - assessor)
    (assessor_ready_for_grading ?assessor - assessor)
    (assessor_review_completed ?assessor - assessor)
    (accommodation_request_available ?accommodation_request - special_accommodation_request)
    (assessor_has_accommodation_request ?assessor - assessor ?accommodation_request - special_accommodation_request)
    (assessor_accommodation_acknowledged ?assessor - assessor)
    (assessor_endorsement_applied ?assessor - assessor)
    (assessor_endorsement_verified ?assessor - assessor)
    (endorsement_request_available ?endorsement_request - endorsement_request)
    (assessor_has_endorsement_request ?assessor - assessor ?endorsement_request - endorsement_request)
    (grading_component_available ?grading_component - grading_component)
    (assessor_has_grading_component ?assessor - assessor ?grading_component - grading_component)
    (equipment_certification_available ?equipment_certification - equipment_certification)
    (assessor_has_equipment_certification ?assessor - assessor ?equipment_certification - equipment_certification)
    (external_audit_token_available ?external_audit_token - external_audit_token)
    (assessor_has_external_audit_token ?assessor - assessor ?external_audit_token - external_audit_token)
    (eligibility_certificate_available ?eligibility_certificate - eligibility_certificate)
    (entity_has_eligibility_certificate ?plan - assessable_entity ?eligibility_certificate - eligibility_certificate)
    (candidate_component_lock ?candidate - candidate)
    (peer_candidate_lock ?peer_candidate - peer_candidate)
    (assessor_authorization_issued ?assessor - assessor)
  )
  (:action register_entity
    :parameters (?plan - assessable_entity)
    :precondition
      (and
        (not
          (entity_registered ?plan)
        )
        (not
          (entity_certified ?plan)
        )
      )
    :effect (entity_registered ?plan)
  )
  (:action reserve_availability_slot
    :parameters (?plan - assessable_entity ?availability_slot - availability_slot)
    :precondition
      (and
        (entity_registered ?plan)
        (not
          (entity_reserved ?plan)
        )
        (slot_available ?availability_slot)
      )
    :effect
      (and
        (entity_reserved ?plan)
        (entity_reserved_slot ?plan ?availability_slot)
        (not
          (slot_available ?availability_slot)
        )
      )
  )
  (:action assign_assessment_session
    :parameters (?plan - assessable_entity ?assessment_session - assessment_session)
    :precondition
      (and
        (entity_registered ?plan)
        (entity_reserved ?plan)
        (session_available ?assessment_session)
      )
    :effect
      (and
        (entity_assigned_session ?plan ?assessment_session)
        (not
          (session_available ?assessment_session)
        )
      )
  )
  (:action confirm_assessment_plan
    :parameters (?plan - assessable_entity ?assessment_session - assessment_session)
    :precondition
      (and
        (entity_registered ?plan)
        (entity_reserved ?plan)
        (entity_assigned_session ?plan ?assessment_session)
        (not
          (entity_confirmed ?plan)
        )
      )
    :effect (entity_confirmed ?plan)
  )
  (:action release_assessment_session
    :parameters (?plan - assessable_entity ?assessment_session - assessment_session)
    :precondition
      (and
        (entity_assigned_session ?plan ?assessment_session)
      )
    :effect
      (and
        (session_available ?assessment_session)
        (not
          (entity_assigned_session ?plan ?assessment_session)
        )
      )
  )
  (:action assign_proctor
    :parameters (?plan - assessable_entity ?proctor - proctor)
    :precondition
      (and
        (entity_confirmed ?plan)
        (proctor_available ?proctor)
      )
    :effect
      (and
        (entity_assigned_proctor ?plan ?proctor)
        (not
          (proctor_available ?proctor)
        )
      )
  )
  (:action release_proctor
    :parameters (?plan - assessable_entity ?proctor - proctor)
    :precondition
      (and
        (entity_assigned_proctor ?plan ?proctor)
      )
    :effect
      (and
        (proctor_available ?proctor)
        (not
          (entity_assigned_proctor ?plan ?proctor)
        )
      )
  )
  (:action assign_equipment_certification
    :parameters (?assessor - assessor ?equipment_certification - equipment_certification)
    :precondition
      (and
        (entity_confirmed ?assessor)
        (equipment_certification_available ?equipment_certification)
      )
    :effect
      (and
        (assessor_has_equipment_certification ?assessor ?equipment_certification)
        (not
          (equipment_certification_available ?equipment_certification)
        )
      )
  )
  (:action revoke_equipment_certification
    :parameters (?assessor - assessor ?equipment_certification - equipment_certification)
    :precondition
      (and
        (assessor_has_equipment_certification ?assessor ?equipment_certification)
      )
    :effect
      (and
        (equipment_certification_available ?equipment_certification)
        (not
          (assessor_has_equipment_certification ?assessor ?equipment_certification)
        )
      )
  )
  (:action assign_external_audit_token
    :parameters (?assessor - assessor ?external_audit_token - external_audit_token)
    :precondition
      (and
        (entity_confirmed ?assessor)
        (external_audit_token_available ?external_audit_token)
      )
    :effect
      (and
        (assessor_has_external_audit_token ?assessor ?external_audit_token)
        (not
          (external_audit_token_available ?external_audit_token)
        )
      )
  )
  (:action revoke_external_audit_token
    :parameters (?assessor - assessor ?external_audit_token - external_audit_token)
    :precondition
      (and
        (assessor_has_external_audit_token ?assessor ?external_audit_token)
      )
    :effect
      (and
        (external_audit_token_available ?external_audit_token)
        (not
          (assessor_has_external_audit_token ?assessor ?external_audit_token)
        )
      )
  )
  (:action claim_competency_item_for_candidate
    :parameters (?candidate - candidate ?competency_item - competency_item ?assessment_session - assessment_session)
    :precondition
      (and
        (entity_confirmed ?candidate)
        (entity_assigned_session ?candidate ?assessment_session)
        (candidate_competency_assigned ?candidate ?competency_item)
        (not
          (competency_item_locked ?competency_item)
        )
        (not
          (competency_item_under_remediation ?competency_item)
        )
      )
    :effect (competency_item_locked ?competency_item)
  )
  (:action proctor_verify_candidate_component
    :parameters (?candidate - candidate ?competency_item - competency_item ?proctor - proctor)
    :precondition
      (and
        (entity_confirmed ?candidate)
        (entity_assigned_proctor ?candidate ?proctor)
        (candidate_competency_assigned ?candidate ?competency_item)
        (competency_item_locked ?competency_item)
        (not
          (candidate_component_lock ?candidate)
        )
      )
    :effect
      (and
        (candidate_component_lock ?candidate)
        (candidate_component_verified ?candidate)
      )
  )
  (:action apply_remediation_resource
    :parameters (?candidate - candidate ?competency_item - competency_item ?remediation_resource - remediation_resource)
    :precondition
      (and
        (entity_confirmed ?candidate)
        (candidate_competency_assigned ?candidate ?competency_item)
        (remediation_resource_available ?remediation_resource)
        (not
          (candidate_component_lock ?candidate)
        )
      )
    :effect
      (and
        (competency_item_under_remediation ?competency_item)
        (candidate_component_lock ?candidate)
        (candidate_remediation_assigned ?candidate ?remediation_resource)
        (not
          (remediation_resource_available ?remediation_resource)
        )
      )
  )
  (:action complete_remediation
    :parameters (?candidate - candidate ?competency_item - competency_item ?assessment_session - assessment_session ?remediation_resource - remediation_resource)
    :precondition
      (and
        (entity_confirmed ?candidate)
        (entity_assigned_session ?candidate ?assessment_session)
        (candidate_competency_assigned ?candidate ?competency_item)
        (competency_item_under_remediation ?competency_item)
        (candidate_remediation_assigned ?candidate ?remediation_resource)
        (not
          (candidate_component_verified ?candidate)
        )
      )
    :effect
      (and
        (competency_item_locked ?competency_item)
        (candidate_component_verified ?candidate)
        (remediation_resource_available ?remediation_resource)
        (not
          (candidate_remediation_assigned ?candidate ?remediation_resource)
        )
      )
  )
  (:action claim_peer_competency_item
    :parameters (?peer_candidate - peer_candidate ?peer_competency_item - peer_competency_item ?assessment_session - assessment_session)
    :precondition
      (and
        (entity_confirmed ?peer_candidate)
        (entity_assigned_session ?peer_candidate ?assessment_session)
        (peer_competency_assigned ?peer_candidate ?peer_competency_item)
        (not
          (peer_competency_locked ?peer_competency_item)
        )
        (not
          (peer_competency_under_remediation ?peer_competency_item)
        )
      )
    :effect (peer_competency_locked ?peer_competency_item)
  )
  (:action proctor_verify_peer_component
    :parameters (?peer_candidate - peer_candidate ?peer_competency_item - peer_competency_item ?proctor - proctor)
    :precondition
      (and
        (entity_confirmed ?peer_candidate)
        (entity_assigned_proctor ?peer_candidate ?proctor)
        (peer_competency_assigned ?peer_candidate ?peer_competency_item)
        (peer_competency_locked ?peer_competency_item)
        (not
          (peer_candidate_lock ?peer_candidate)
        )
      )
    :effect
      (and
        (peer_candidate_lock ?peer_candidate)
        (peer_component_verified ?peer_candidate)
      )
  )
  (:action apply_peer_remediation
    :parameters (?peer_candidate - peer_candidate ?peer_competency_item - peer_competency_item ?remediation_resource - remediation_resource)
    :precondition
      (and
        (entity_confirmed ?peer_candidate)
        (peer_competency_assigned ?peer_candidate ?peer_competency_item)
        (remediation_resource_available ?remediation_resource)
        (not
          (peer_candidate_lock ?peer_candidate)
        )
      )
    :effect
      (and
        (peer_competency_under_remediation ?peer_competency_item)
        (peer_candidate_lock ?peer_candidate)
        (peer_remediation_assigned ?peer_candidate ?remediation_resource)
        (not
          (remediation_resource_available ?remediation_resource)
        )
      )
  )
  (:action complete_peer_remediation
    :parameters (?peer_candidate - peer_candidate ?peer_competency_item - peer_competency_item ?assessment_session - assessment_session ?remediation_resource - remediation_resource)
    :precondition
      (and
        (entity_confirmed ?peer_candidate)
        (entity_assigned_session ?peer_candidate ?assessment_session)
        (peer_competency_assigned ?peer_candidate ?peer_competency_item)
        (peer_competency_under_remediation ?peer_competency_item)
        (peer_remediation_assigned ?peer_candidate ?remediation_resource)
        (not
          (peer_component_verified ?peer_candidate)
        )
      )
    :effect
      (and
        (peer_competency_locked ?peer_competency_item)
        (peer_component_verified ?peer_candidate)
        (remediation_resource_available ?remediation_resource)
        (not
          (peer_remediation_assigned ?peer_candidate ?remediation_resource)
        )
      )
  )
  (:action assemble_submission_record
    :parameters (?candidate - candidate ?peer_candidate - peer_candidate ?competency_item - competency_item ?peer_competency_item - peer_competency_item ?submission_record - submission_record)
    :precondition
      (and
        (candidate_component_lock ?candidate)
        (peer_candidate_lock ?peer_candidate)
        (candidate_competency_assigned ?candidate ?competency_item)
        (peer_competency_assigned ?peer_candidate ?peer_competency_item)
        (competency_item_locked ?competency_item)
        (peer_competency_locked ?peer_competency_item)
        (candidate_component_verified ?candidate)
        (peer_component_verified ?peer_candidate)
        (submission_slot_open ?submission_record)
      )
    :effect
      (and
        (submission_record_created ?submission_record)
        (submission_links_competency ?submission_record ?competency_item)
        (submission_links_peer_competency ?submission_record ?peer_competency_item)
        (not
          (submission_slot_open ?submission_record)
        )
      )
  )
  (:action assemble_submission_with_candidate_remediation
    :parameters (?candidate - candidate ?peer_candidate - peer_candidate ?competency_item - competency_item ?peer_competency_item - peer_competency_item ?submission_record - submission_record)
    :precondition
      (and
        (candidate_component_lock ?candidate)
        (peer_candidate_lock ?peer_candidate)
        (candidate_competency_assigned ?candidate ?competency_item)
        (peer_competency_assigned ?peer_candidate ?peer_competency_item)
        (competency_item_under_remediation ?competency_item)
        (peer_competency_locked ?peer_competency_item)
        (not
          (candidate_component_verified ?candidate)
        )
        (peer_component_verified ?peer_candidate)
        (submission_slot_open ?submission_record)
      )
    :effect
      (and
        (submission_record_created ?submission_record)
        (submission_links_competency ?submission_record ?competency_item)
        (submission_links_peer_competency ?submission_record ?peer_competency_item)
        (submission_candidate_remediation_flag ?submission_record)
        (not
          (submission_slot_open ?submission_record)
        )
      )
  )
  (:action assemble_submission_with_peer_remediation
    :parameters (?candidate - candidate ?peer_candidate - peer_candidate ?competency_item - competency_item ?peer_competency_item - peer_competency_item ?submission_record - submission_record)
    :precondition
      (and
        (candidate_component_lock ?candidate)
        (peer_candidate_lock ?peer_candidate)
        (candidate_competency_assigned ?candidate ?competency_item)
        (peer_competency_assigned ?peer_candidate ?peer_competency_item)
        (competency_item_locked ?competency_item)
        (peer_competency_under_remediation ?peer_competency_item)
        (candidate_component_verified ?candidate)
        (not
          (peer_component_verified ?peer_candidate)
        )
        (submission_slot_open ?submission_record)
      )
    :effect
      (and
        (submission_record_created ?submission_record)
        (submission_links_competency ?submission_record ?competency_item)
        (submission_links_peer_competency ?submission_record ?peer_competency_item)
        (submission_peer_remediation_flag ?submission_record)
        (not
          (submission_slot_open ?submission_record)
        )
      )
  )
  (:action assemble_submission_with_both_remediations
    :parameters (?candidate - candidate ?peer_candidate - peer_candidate ?competency_item - competency_item ?peer_competency_item - peer_competency_item ?submission_record - submission_record)
    :precondition
      (and
        (candidate_component_lock ?candidate)
        (peer_candidate_lock ?peer_candidate)
        (candidate_competency_assigned ?candidate ?competency_item)
        (peer_competency_assigned ?peer_candidate ?peer_competency_item)
        (competency_item_under_remediation ?competency_item)
        (peer_competency_under_remediation ?peer_competency_item)
        (not
          (candidate_component_verified ?candidate)
        )
        (not
          (peer_component_verified ?peer_candidate)
        )
        (submission_slot_open ?submission_record)
      )
    :effect
      (and
        (submission_record_created ?submission_record)
        (submission_links_competency ?submission_record ?competency_item)
        (submission_links_peer_competency ?submission_record ?peer_competency_item)
        (submission_candidate_remediation_flag ?submission_record)
        (submission_peer_remediation_flag ?submission_record)
        (not
          (submission_slot_open ?submission_record)
        )
      )
  )
  (:action finalize_submission
    :parameters (?submission_record - submission_record ?candidate - candidate ?assessment_session - assessment_session)
    :precondition
      (and
        (submission_record_created ?submission_record)
        (candidate_component_lock ?candidate)
        (entity_assigned_session ?candidate ?assessment_session)
        (not
          (submission_materials_verified ?submission_record)
        )
      )
    :effect (submission_materials_verified ?submission_record)
  )
  (:action validate_evidence_document
    :parameters (?assessor - assessor ?evidence_document - evidence_document ?submission_record - submission_record)
    :precondition
      (and
        (entity_confirmed ?assessor)
        (assessor_assigned_submission ?assessor ?submission_record)
        (assessor_has_evidence ?assessor ?evidence_document)
        (evidence_available ?evidence_document)
        (submission_record_created ?submission_record)
        (submission_materials_verified ?submission_record)
        (not
          (evidence_validated ?evidence_document)
        )
      )
    :effect
      (and
        (evidence_validated ?evidence_document)
        (evidence_linked_submission ?evidence_document ?submission_record)
        (not
          (evidence_available ?evidence_document)
        )
      )
  )
  (:action record_prevalidation
    :parameters (?assessor - assessor ?evidence_document - evidence_document ?submission_record - submission_record ?assessment_session - assessment_session)
    :precondition
      (and
        (entity_confirmed ?assessor)
        (assessor_has_evidence ?assessor ?evidence_document)
        (evidence_validated ?evidence_document)
        (evidence_linked_submission ?evidence_document ?submission_record)
        (entity_assigned_session ?assessor ?assessment_session)
        (not
          (submission_candidate_remediation_flag ?submission_record)
        )
        (not
          (assessor_prepared ?assessor)
        )
      )
    :effect (assessor_prepared ?assessor)
  )
  (:action request_endorsement
    :parameters (?assessor - assessor ?endorsement_request - endorsement_request)
    :precondition
      (and
        (entity_confirmed ?assessor)
        (endorsement_request_available ?endorsement_request)
        (not
          (assessor_endorsement_requested ?assessor)
        )
      )
    :effect
      (and
        (assessor_endorsement_requested ?assessor)
        (assessor_has_endorsement_request ?assessor ?endorsement_request)
        (not
          (endorsement_request_available ?endorsement_request)
        )
      )
  )
  (:action prepare_assessor_with_endorsement
    :parameters (?assessor - assessor ?evidence_document - evidence_document ?submission_record - submission_record ?assessment_session - assessment_session ?endorsement_request - endorsement_request)
    :precondition
      (and
        (entity_confirmed ?assessor)
        (assessor_has_evidence ?assessor ?evidence_document)
        (evidence_validated ?evidence_document)
        (evidence_linked_submission ?evidence_document ?submission_record)
        (entity_assigned_session ?assessor ?assessment_session)
        (submission_candidate_remediation_flag ?submission_record)
        (assessor_endorsement_requested ?assessor)
        (assessor_has_endorsement_request ?assessor ?endorsement_request)
        (not
          (assessor_prepared ?assessor)
        )
      )
    :effect
      (and
        (assessor_prepared ?assessor)
        (assessor_endorsement_attached ?assessor)
      )
  )
  (:action claim_evidence_review_phase1
    :parameters (?assessor - assessor ?equipment_certification - equipment_certification ?proctor - proctor ?evidence_document - evidence_document ?submission_record - submission_record)
    :precondition
      (and
        (assessor_prepared ?assessor)
        (assessor_has_equipment_certification ?assessor ?equipment_certification)
        (entity_assigned_proctor ?assessor ?proctor)
        (assessor_has_evidence ?assessor ?evidence_document)
        (evidence_linked_submission ?evidence_document ?submission_record)
        (not
          (submission_peer_remediation_flag ?submission_record)
        )
        (not
          (assessor_claimed_review ?assessor)
        )
      )
    :effect (assessor_claimed_review ?assessor)
  )
  (:action claim_evidence_review_phase2
    :parameters (?assessor - assessor ?equipment_certification - equipment_certification ?proctor - proctor ?evidence_document - evidence_document ?submission_record - submission_record)
    :precondition
      (and
        (assessor_prepared ?assessor)
        (assessor_has_equipment_certification ?assessor ?equipment_certification)
        (entity_assigned_proctor ?assessor ?proctor)
        (assessor_has_evidence ?assessor ?evidence_document)
        (evidence_linked_submission ?evidence_document ?submission_record)
        (submission_peer_remediation_flag ?submission_record)
        (not
          (assessor_claimed_review ?assessor)
        )
      )
    :effect (assessor_claimed_review ?assessor)
  )
  (:action perform_external_audit_phase1
    :parameters (?assessor - assessor ?external_audit_token - external_audit_token ?evidence_document - evidence_document ?submission_record - submission_record)
    :precondition
      (and
        (assessor_claimed_review ?assessor)
        (assessor_has_external_audit_token ?assessor ?external_audit_token)
        (assessor_has_evidence ?assessor ?evidence_document)
        (evidence_linked_submission ?evidence_document ?submission_record)
        (not
          (submission_candidate_remediation_flag ?submission_record)
        )
        (not
          (submission_peer_remediation_flag ?submission_record)
        )
        (not
          (assessor_verification_complete ?assessor)
        )
      )
    :effect (assessor_verification_complete ?assessor)
  )
  (:action perform_external_audit_phase2
    :parameters (?assessor - assessor ?external_audit_token - external_audit_token ?evidence_document - evidence_document ?submission_record - submission_record)
    :precondition
      (and
        (assessor_claimed_review ?assessor)
        (assessor_has_external_audit_token ?assessor ?external_audit_token)
        (assessor_has_evidence ?assessor ?evidence_document)
        (evidence_linked_submission ?evidence_document ?submission_record)
        (submission_candidate_remediation_flag ?submission_record)
        (not
          (submission_peer_remediation_flag ?submission_record)
        )
        (not
          (assessor_verification_complete ?assessor)
        )
      )
    :effect
      (and
        (assessor_verification_complete ?assessor)
        (assessor_ready_for_grading ?assessor)
      )
  )
  (:action perform_external_audit_phase3
    :parameters (?assessor - assessor ?external_audit_token - external_audit_token ?evidence_document - evidence_document ?submission_record - submission_record)
    :precondition
      (and
        (assessor_claimed_review ?assessor)
        (assessor_has_external_audit_token ?assessor ?external_audit_token)
        (assessor_has_evidence ?assessor ?evidence_document)
        (evidence_linked_submission ?evidence_document ?submission_record)
        (not
          (submission_candidate_remediation_flag ?submission_record)
        )
        (submission_peer_remediation_flag ?submission_record)
        (not
          (assessor_verification_complete ?assessor)
        )
      )
    :effect
      (and
        (assessor_verification_complete ?assessor)
        (assessor_ready_for_grading ?assessor)
      )
  )
  (:action perform_external_audit_phase4
    :parameters (?assessor - assessor ?external_audit_token - external_audit_token ?evidence_document - evidence_document ?submission_record - submission_record)
    :precondition
      (and
        (assessor_claimed_review ?assessor)
        (assessor_has_external_audit_token ?assessor ?external_audit_token)
        (assessor_has_evidence ?assessor ?evidence_document)
        (evidence_linked_submission ?evidence_document ?submission_record)
        (submission_candidate_remediation_flag ?submission_record)
        (submission_peer_remediation_flag ?submission_record)
        (not
          (assessor_verification_complete ?assessor)
        )
      )
    :effect
      (and
        (assessor_verification_complete ?assessor)
        (assessor_ready_for_grading ?assessor)
      )
  )
  (:action mark_assessor_authorized
    :parameters (?assessor - assessor)
    :precondition
      (and
        (assessor_verification_complete ?assessor)
        (not
          (assessor_ready_for_grading ?assessor)
        )
        (not
          (assessor_authorization_issued ?assessor)
        )
      )
    :effect
      (and
        (assessor_authorization_issued ?assessor)
        (final_approval_granted ?assessor)
      )
  )
  (:action attach_grading_component
    :parameters (?assessor - assessor ?grading_component - grading_component)
    :precondition
      (and
        (assessor_verification_complete ?assessor)
        (assessor_ready_for_grading ?assessor)
        (grading_component_available ?grading_component)
      )
    :effect
      (and
        (assessor_has_grading_component ?assessor ?grading_component)
        (not
          (grading_component_available ?grading_component)
        )
      )
  )
  (:action complete_assessor_checks
    :parameters (?assessor - assessor ?candidate - candidate ?peer_candidate - peer_candidate ?assessment_session - assessment_session ?grading_component - grading_component)
    :precondition
      (and
        (assessor_verification_complete ?assessor)
        (assessor_ready_for_grading ?assessor)
        (assessor_has_grading_component ?assessor ?grading_component)
        (assessor_assigned_candidate ?assessor ?candidate)
        (assessor_assigned_peer ?assessor ?peer_candidate)
        (candidate_component_verified ?candidate)
        (peer_component_verified ?peer_candidate)
        (entity_assigned_session ?assessor ?assessment_session)
        (not
          (assessor_review_completed ?assessor)
        )
      )
    :effect (assessor_review_completed ?assessor)
  )
  (:action finalize_assessor_checks
    :parameters (?assessor - assessor)
    :precondition
      (and
        (assessor_verification_complete ?assessor)
        (assessor_review_completed ?assessor)
        (not
          (assessor_authorization_issued ?assessor)
        )
      )
    :effect
      (and
        (assessor_authorization_issued ?assessor)
        (final_approval_granted ?assessor)
      )
  )
  (:action process_accommodation_request
    :parameters (?assessor - assessor ?accommodation_request - special_accommodation_request ?assessment_session - assessment_session)
    :precondition
      (and
        (entity_confirmed ?assessor)
        (entity_assigned_session ?assessor ?assessment_session)
        (accommodation_request_available ?accommodation_request)
        (assessor_has_accommodation_request ?assessor ?accommodation_request)
        (not
          (assessor_accommodation_acknowledged ?assessor)
        )
      )
    :effect
      (and
        (assessor_accommodation_acknowledged ?assessor)
        (not
          (accommodation_request_available ?accommodation_request)
        )
      )
  )
  (:action apply_endorsement
    :parameters (?assessor - assessor ?proctor - proctor)
    :precondition
      (and
        (assessor_accommodation_acknowledged ?assessor)
        (entity_assigned_proctor ?assessor ?proctor)
        (not
          (assessor_endorsement_applied ?assessor)
        )
      )
    :effect (assessor_endorsement_applied ?assessor)
  )
  (:action acknowledge_endorsement_and_record_audit
    :parameters (?assessor - assessor ?external_audit_token - external_audit_token)
    :precondition
      (and
        (assessor_endorsement_applied ?assessor)
        (assessor_has_external_audit_token ?assessor ?external_audit_token)
        (not
          (assessor_endorsement_verified ?assessor)
        )
      )
    :effect (assessor_endorsement_verified ?assessor)
  )
  (:action finalize_endorsement_and_authorize
    :parameters (?assessor - assessor)
    :precondition
      (and
        (assessor_endorsement_verified ?assessor)
        (not
          (assessor_authorization_issued ?assessor)
        )
      )
    :effect
      (and
        (assessor_authorization_issued ?assessor)
        (final_approval_granted ?assessor)
      )
  )
  (:action authorize_candidate_from_submission
    :parameters (?candidate - candidate ?submission_record - submission_record)
    :precondition
      (and
        (candidate_component_lock ?candidate)
        (candidate_component_verified ?candidate)
        (submission_record_created ?submission_record)
        (submission_materials_verified ?submission_record)
        (not
          (final_approval_granted ?candidate)
        )
      )
    :effect (final_approval_granted ?candidate)
  )
  (:action authorize_peer_from_submission
    :parameters (?peer_candidate - peer_candidate ?submission_record - submission_record)
    :precondition
      (and
        (peer_candidate_lock ?peer_candidate)
        (peer_component_verified ?peer_candidate)
        (submission_record_created ?submission_record)
        (submission_materials_verified ?submission_record)
        (not
          (final_approval_granted ?peer_candidate)
        )
      )
    :effect (final_approval_granted ?peer_candidate)
  )
  (:action consume_eligibility_for_completion
    :parameters (?plan - assessable_entity ?eligibility_certificate - eligibility_certificate ?assessment_session - assessment_session)
    :precondition
      (and
        (final_approval_granted ?plan)
        (entity_assigned_session ?plan ?assessment_session)
        (eligibility_certificate_available ?eligibility_certificate)
        (not
          (certificate_consumed ?plan)
        )
      )
    :effect
      (and
        (certificate_consumed ?plan)
        (entity_has_eligibility_certificate ?plan ?eligibility_certificate)
        (not
          (eligibility_certificate_available ?eligibility_certificate)
        )
      )
  )
  (:action recycle_resources_and_mark_certified_for_candidate
    :parameters (?candidate - candidate ?availability_slot - availability_slot ?eligibility_certificate - eligibility_certificate)
    :precondition
      (and
        (certificate_consumed ?candidate)
        (entity_reserved_slot ?candidate ?availability_slot)
        (entity_has_eligibility_certificate ?candidate ?eligibility_certificate)
        (not
          (entity_certified ?candidate)
        )
      )
    :effect
      (and
        (entity_certified ?candidate)
        (slot_available ?availability_slot)
        (eligibility_certificate_available ?eligibility_certificate)
      )
  )
  (:action recycle_resources_and_mark_certified_for_peer
    :parameters (?peer_candidate - peer_candidate ?availability_slot - availability_slot ?eligibility_certificate - eligibility_certificate)
    :precondition
      (and
        (certificate_consumed ?peer_candidate)
        (entity_reserved_slot ?peer_candidate ?availability_slot)
        (entity_has_eligibility_certificate ?peer_candidate ?eligibility_certificate)
        (not
          (entity_certified ?peer_candidate)
        )
      )
    :effect
      (and
        (entity_certified ?peer_candidate)
        (slot_available ?availability_slot)
        (eligibility_certificate_available ?eligibility_certificate)
      )
  )
  (:action recycle_resources_and_mark_certified_for_assessor
    :parameters (?assessor - assessor ?availability_slot - availability_slot ?eligibility_certificate - eligibility_certificate)
    :precondition
      (and
        (certificate_consumed ?assessor)
        (entity_reserved_slot ?assessor ?availability_slot)
        (entity_has_eligibility_certificate ?assessor ?eligibility_certificate)
        (not
          (entity_certified ?assessor)
        )
      )
    :effect
      (and
        (entity_certified ?assessor)
        (slot_available ?availability_slot)
        (eligibility_certificate_available ?eligibility_certificate)
      )
  )
)

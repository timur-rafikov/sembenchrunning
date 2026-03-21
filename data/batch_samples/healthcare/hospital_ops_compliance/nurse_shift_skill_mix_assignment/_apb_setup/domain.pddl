(define (domain healthcare_nurse_shift_skill_mix_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types shift_slot - object nurse_candidate - object clinical_role - object support_skill - object specialty_skill - object technical_skill - object orientation_session - object clinical_supervisor - object approval_document_type - object trainer - object special_equipment - object credential - object staff_role - object preceptor_role - staff_role mentor_role - staff_role day_shift_slot - shift_slot night_shift_slot - shift_slot)
  (:predicates
    (slot_active ?shift_slot - shift_slot)
    (slot_assigned_to ?shift_slot - shift_slot ?nurse_candidate - nurse_candidate)
    (slot_assignment_pending ?shift_slot - shift_slot)
    (orientation_confirmed ?shift_slot - shift_slot)
    (competency_verified ?shift_slot - shift_slot)
    (slot_reserved_specialty_skill ?shift_slot - shift_slot ?specialty_skill - specialty_skill)
    (slot_reserved_support_skill ?shift_slot - shift_slot ?support_skill - support_skill)
    (slot_reserved_technical_skill ?shift_slot - shift_slot ?technical_skill - technical_skill)
    (slot_reserved_credential ?shift_slot - shift_slot ?credential - credential)
    (slot_clinical_role_assigned ?shift_slot - shift_slot ?clinical_role - clinical_role)
    (clinical_role_scheduled ?shift_slot - shift_slot)
    (competency_certified ?shift_slot - shift_slot)
    (requalification_scheduled ?shift_slot - shift_slot)
    (slot_finalized ?shift_slot - shift_slot)
    (supervisor_engaged ?shift_slot - shift_slot)
    (certification_granted ?shift_slot - shift_slot)
    (slot_requires_document_type ?shift_slot - shift_slot ?approval_document_type - approval_document_type)
    (slot_document_linked ?shift_slot - shift_slot ?approval_document_type - approval_document_type)
    (followup_completed ?shift_slot - shift_slot)
    (candidate_available ?nurse_candidate - nurse_candidate)
    (clinical_role_available ?clinical_role - clinical_role)
    (specialty_skill_available ?specialty_skill - specialty_skill)
    (support_skill_available ?support_skill - support_skill)
    (technical_skill_available ?technical_skill - technical_skill)
    (orientation_session_available ?orientation_session - orientation_session)
    (clinical_supervisor_available ?clinical_supervisor - clinical_supervisor)
    (approval_document_available ?approval_document_type - approval_document_type)
    (trainer_available ?trainer - trainer)
    (special_equipment_available ?special_equipment - special_equipment)
    (credential_available ?credential - credential)
    (slot_candidate_compatible ?shift_slot - shift_slot ?nurse_candidate - nurse_candidate)
    (slot_requires_clinical_role ?shift_slot - shift_slot ?clinical_role - clinical_role)
    (slot_requires_specialty_skill ?shift_slot - shift_slot ?specialty_skill - specialty_skill)
    (slot_requires_support_skill ?shift_slot - shift_slot ?support_skill - support_skill)
    (slot_requires_technical_skill ?shift_slot - shift_slot ?technical_skill - technical_skill)
    (slot_requires_special_equipment ?shift_slot - shift_slot ?special_equipment - special_equipment)
    (slot_requires_credential ?shift_slot - shift_slot ?credential - credential)
    (slot_has_staff_role ?shift_slot - shift_slot ?staff_role_group - staff_role)
    (slot_document_linked_day ?shift_slot - shift_slot ?approval_document_type - approval_document_type)
    (day_shift_policy_applicable ?shift_slot - shift_slot)
    (night_shift_policy_applicable ?shift_slot - shift_slot)
    (slot_reserved_orientation_session ?shift_slot - shift_slot ?orientation_session - orientation_session)
    (followup_required ?shift_slot - shift_slot)
    (slot_document_applicability ?shift_slot - shift_slot ?approval_document_type - approval_document_type)
  )
  (:action activate_shift_slot
    :parameters (?shift_slot - shift_slot)
    :precondition
      (and
        (not
          (slot_active ?shift_slot)
        )
        (not
          (slot_finalized ?shift_slot)
        )
      )
    :effect
      (and
        (slot_active ?shift_slot)
      )
  )
  (:action assign_nurse_to_slot
    :parameters (?shift_slot - shift_slot ?nurse_candidate - nurse_candidate)
    :precondition
      (and
        (slot_active ?shift_slot)
        (candidate_available ?nurse_candidate)
        (slot_candidate_compatible ?shift_slot ?nurse_candidate)
        (not
          (slot_assignment_pending ?shift_slot)
        )
      )
    :effect
      (and
        (slot_assigned_to ?shift_slot ?nurse_candidate)
        (slot_assignment_pending ?shift_slot)
        (not
          (candidate_available ?nurse_candidate)
        )
      )
  )
  (:action unassign_nurse_from_slot
    :parameters (?shift_slot - shift_slot ?nurse_candidate - nurse_candidate)
    :precondition
      (and
        (slot_assigned_to ?shift_slot ?nurse_candidate)
        (not
          (clinical_role_scheduled ?shift_slot)
        )
        (not
          (competency_certified ?shift_slot)
        )
      )
    :effect
      (and
        (not
          (slot_assigned_to ?shift_slot ?nurse_candidate)
        )
        (not
          (slot_assignment_pending ?shift_slot)
        )
        (not
          (orientation_confirmed ?shift_slot)
        )
        (not
          (competency_verified ?shift_slot)
        )
        (not
          (supervisor_engaged ?shift_slot)
        )
        (not
          (certification_granted ?shift_slot)
        )
        (not
          (followup_required ?shift_slot)
        )
        (candidate_available ?nurse_candidate)
      )
  )
  (:action reserve_orientation_for_slot
    :parameters (?shift_slot - shift_slot ?orientation_session - orientation_session)
    :precondition
      (and
        (slot_active ?shift_slot)
        (orientation_session_available ?orientation_session)
      )
    :effect
      (and
        (slot_reserved_orientation_session ?shift_slot ?orientation_session)
        (not
          (orientation_session_available ?orientation_session)
        )
      )
  )
  (:action release_orientation_for_slot
    :parameters (?shift_slot - shift_slot ?orientation_session - orientation_session)
    :precondition
      (and
        (slot_reserved_orientation_session ?shift_slot ?orientation_session)
      )
    :effect
      (and
        (orientation_session_available ?orientation_session)
        (not
          (slot_reserved_orientation_session ?shift_slot ?orientation_session)
        )
      )
  )
  (:action confirm_orientation_completion
    :parameters (?shift_slot - shift_slot ?orientation_session - orientation_session)
    :precondition
      (and
        (slot_active ?shift_slot)
        (slot_assignment_pending ?shift_slot)
        (slot_reserved_orientation_session ?shift_slot ?orientation_session)
        (not
          (orientation_confirmed ?shift_slot)
        )
      )
    :effect
      (and
        (orientation_confirmed ?shift_slot)
      )
  )
  (:action engage_clinical_supervisor_for_slot
    :parameters (?shift_slot - shift_slot ?clinical_supervisor - clinical_supervisor)
    :precondition
      (and
        (slot_active ?shift_slot)
        (slot_assignment_pending ?shift_slot)
        (clinical_supervisor_available ?clinical_supervisor)
        (not
          (orientation_confirmed ?shift_slot)
        )
      )
    :effect
      (and
        (orientation_confirmed ?shift_slot)
        (supervisor_engaged ?shift_slot)
        (not
          (clinical_supervisor_available ?clinical_supervisor)
        )
      )
  )
  (:action trainer_verify_competency
    :parameters (?shift_slot - shift_slot ?orientation_session - orientation_session ?trainer - trainer)
    :precondition
      (and
        (orientation_confirmed ?shift_slot)
        (slot_assignment_pending ?shift_slot)
        (slot_reserved_orientation_session ?shift_slot ?orientation_session)
        (trainer_available ?trainer)
        (not
          (competency_verified ?shift_slot)
        )
      )
    :effect
      (and
        (competency_verified ?shift_slot)
        (not
          (supervisor_engaged ?shift_slot)
        )
      )
  )
  (:action verify_competency_with_document
    :parameters (?shift_slot - shift_slot ?approval_document_type - approval_document_type)
    :precondition
      (and
        (slot_assignment_pending ?shift_slot)
        (slot_document_linked ?shift_slot ?approval_document_type)
        (not
          (competency_verified ?shift_slot)
        )
      )
    :effect
      (and
        (competency_verified ?shift_slot)
        (not
          (supervisor_engaged ?shift_slot)
        )
      )
  )
  (:action reserve_specialty_for_slot
    :parameters (?shift_slot - shift_slot ?specialty_skill - specialty_skill)
    :precondition
      (and
        (slot_active ?shift_slot)
        (specialty_skill_available ?specialty_skill)
        (slot_requires_specialty_skill ?shift_slot ?specialty_skill)
      )
    :effect
      (and
        (slot_reserved_specialty_skill ?shift_slot ?specialty_skill)
        (not
          (specialty_skill_available ?specialty_skill)
        )
      )
  )
  (:action release_specialty_from_slot
    :parameters (?shift_slot - shift_slot ?specialty_skill - specialty_skill)
    :precondition
      (and
        (slot_reserved_specialty_skill ?shift_slot ?specialty_skill)
      )
    :effect
      (and
        (specialty_skill_available ?specialty_skill)
        (not
          (slot_reserved_specialty_skill ?shift_slot ?specialty_skill)
        )
      )
  )
  (:action reserve_support_skill_for_slot
    :parameters (?shift_slot - shift_slot ?support_skill - support_skill)
    :precondition
      (and
        (slot_active ?shift_slot)
        (support_skill_available ?support_skill)
        (slot_requires_support_skill ?shift_slot ?support_skill)
      )
    :effect
      (and
        (slot_reserved_support_skill ?shift_slot ?support_skill)
        (not
          (support_skill_available ?support_skill)
        )
      )
  )
  (:action release_support_skill_from_slot
    :parameters (?shift_slot - shift_slot ?support_skill - support_skill)
    :precondition
      (and
        (slot_reserved_support_skill ?shift_slot ?support_skill)
      )
    :effect
      (and
        (support_skill_available ?support_skill)
        (not
          (slot_reserved_support_skill ?shift_slot ?support_skill)
        )
      )
  )
  (:action reserve_technical_skill_for_slot
    :parameters (?shift_slot - shift_slot ?technical_skill - technical_skill)
    :precondition
      (and
        (slot_active ?shift_slot)
        (technical_skill_available ?technical_skill)
        (slot_requires_technical_skill ?shift_slot ?technical_skill)
      )
    :effect
      (and
        (slot_reserved_technical_skill ?shift_slot ?technical_skill)
        (not
          (technical_skill_available ?technical_skill)
        )
      )
  )
  (:action release_technical_skill_from_slot
    :parameters (?shift_slot - shift_slot ?technical_skill - technical_skill)
    :precondition
      (and
        (slot_reserved_technical_skill ?shift_slot ?technical_skill)
      )
    :effect
      (and
        (technical_skill_available ?technical_skill)
        (not
          (slot_reserved_technical_skill ?shift_slot ?technical_skill)
        )
      )
  )
  (:action reserve_credential_for_slot
    :parameters (?shift_slot - shift_slot ?credential - credential)
    :precondition
      (and
        (slot_active ?shift_slot)
        (credential_available ?credential)
        (slot_requires_credential ?shift_slot ?credential)
      )
    :effect
      (and
        (slot_reserved_credential ?shift_slot ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action release_credential_from_slot
    :parameters (?shift_slot - shift_slot ?credential - credential)
    :precondition
      (and
        (slot_reserved_credential ?shift_slot ?credential)
      )
    :effect
      (and
        (credential_available ?credential)
        (not
          (slot_reserved_credential ?shift_slot ?credential)
        )
      )
  )
  (:action schedule_clinical_role_for_slot
    :parameters (?shift_slot - shift_slot ?clinical_role - clinical_role ?specialty_skill - specialty_skill ?support_skill - support_skill)
    :precondition
      (and
        (slot_assignment_pending ?shift_slot)
        (slot_reserved_specialty_skill ?shift_slot ?specialty_skill)
        (slot_reserved_support_skill ?shift_slot ?support_skill)
        (clinical_role_available ?clinical_role)
        (slot_requires_clinical_role ?shift_slot ?clinical_role)
        (not
          (clinical_role_scheduled ?shift_slot)
        )
      )
    :effect
      (and
        (slot_clinical_role_assigned ?shift_slot ?clinical_role)
        (clinical_role_scheduled ?shift_slot)
        (not
          (clinical_role_available ?clinical_role)
        )
      )
  )
  (:action schedule_clinical_role_with_equipment
    :parameters (?shift_slot - shift_slot ?clinical_role - clinical_role ?technical_skill - technical_skill ?special_equipment - special_equipment)
    :precondition
      (and
        (slot_assignment_pending ?shift_slot)
        (slot_reserved_technical_skill ?shift_slot ?technical_skill)
        (special_equipment_available ?special_equipment)
        (clinical_role_available ?clinical_role)
        (slot_requires_clinical_role ?shift_slot ?clinical_role)
        (slot_requires_special_equipment ?shift_slot ?special_equipment)
        (not
          (clinical_role_scheduled ?shift_slot)
        )
      )
    :effect
      (and
        (slot_clinical_role_assigned ?shift_slot ?clinical_role)
        (clinical_role_scheduled ?shift_slot)
        (followup_required ?shift_slot)
        (supervisor_engaged ?shift_slot)
        (not
          (clinical_role_available ?clinical_role)
        )
        (not
          (special_equipment_available ?special_equipment)
        )
      )
  )
  (:action clear_followup_and_supervisor_flags
    :parameters (?shift_slot - shift_slot ?specialty_skill - specialty_skill ?support_skill - support_skill)
    :precondition
      (and
        (clinical_role_scheduled ?shift_slot)
        (followup_required ?shift_slot)
        (slot_reserved_specialty_skill ?shift_slot ?specialty_skill)
        (slot_reserved_support_skill ?shift_slot ?support_skill)
      )
    :effect
      (and
        (not
          (followup_required ?shift_slot)
        )
        (not
          (supervisor_engaged ?shift_slot)
        )
      )
  )
  (:action approve_competency_by_preceptor
    :parameters (?shift_slot - shift_slot ?specialty_skill - specialty_skill ?support_skill - support_skill ?preceptor_role - preceptor_role)
    :precondition
      (and
        (competency_verified ?shift_slot)
        (clinical_role_scheduled ?shift_slot)
        (slot_reserved_specialty_skill ?shift_slot ?specialty_skill)
        (slot_reserved_support_skill ?shift_slot ?support_skill)
        (slot_has_staff_role ?shift_slot ?preceptor_role)
        (not
          (supervisor_engaged ?shift_slot)
        )
        (not
          (competency_certified ?shift_slot)
        )
      )
    :effect
      (and
        (competency_certified ?shift_slot)
      )
  )
  (:action approve_competency_by_mentor
    :parameters (?shift_slot - shift_slot ?technical_skill - technical_skill ?credential - credential ?mentor_role - mentor_role)
    :precondition
      (and
        (competency_verified ?shift_slot)
        (clinical_role_scheduled ?shift_slot)
        (slot_reserved_technical_skill ?shift_slot ?technical_skill)
        (slot_reserved_credential ?shift_slot ?credential)
        (slot_has_staff_role ?shift_slot ?mentor_role)
        (not
          (competency_certified ?shift_slot)
        )
      )
    :effect
      (and
        (competency_certified ?shift_slot)
        (supervisor_engaged ?shift_slot)
      )
  )
  (:action grant_certification_and_clear_transient_flags
    :parameters (?shift_slot - shift_slot ?specialty_skill - specialty_skill ?support_skill - support_skill)
    :precondition
      (and
        (competency_certified ?shift_slot)
        (supervisor_engaged ?shift_slot)
        (slot_reserved_specialty_skill ?shift_slot ?specialty_skill)
        (slot_reserved_support_skill ?shift_slot ?support_skill)
      )
    :effect
      (and
        (certification_granted ?shift_slot)
        (not
          (supervisor_engaged ?shift_slot)
        )
        (not
          (competency_verified ?shift_slot)
        )
        (not
          (followup_required ?shift_slot)
        )
      )
  )
  (:action perform_requalification_with_trainer
    :parameters (?shift_slot - shift_slot ?orientation_session - orientation_session ?trainer - trainer)
    :precondition
      (and
        (certification_granted ?shift_slot)
        (competency_certified ?shift_slot)
        (slot_assignment_pending ?shift_slot)
        (slot_reserved_orientation_session ?shift_slot ?orientation_session)
        (trainer_available ?trainer)
        (not
          (competency_verified ?shift_slot)
        )
      )
    :effect
      (and
        (competency_verified ?shift_slot)
      )
  )
  (:action schedule_requalification_for_orientation
    :parameters (?shift_slot - shift_slot ?orientation_session - orientation_session)
    :precondition
      (and
        (competency_certified ?shift_slot)
        (competency_verified ?shift_slot)
        (not
          (supervisor_engaged ?shift_slot)
        )
        (slot_reserved_orientation_session ?shift_slot ?orientation_session)
        (not
          (requalification_scheduled ?shift_slot)
        )
      )
    :effect
      (and
        (requalification_scheduled ?shift_slot)
      )
  )
  (:action schedule_requalification_with_supervisor
    :parameters (?shift_slot - shift_slot ?clinical_supervisor - clinical_supervisor)
    :precondition
      (and
        (competency_certified ?shift_slot)
        (competency_verified ?shift_slot)
        (not
          (supervisor_engaged ?shift_slot)
        )
        (clinical_supervisor_available ?clinical_supervisor)
        (not
          (requalification_scheduled ?shift_slot)
        )
      )
    :effect
      (and
        (requalification_scheduled ?shift_slot)
        (not
          (clinical_supervisor_available ?clinical_supervisor)
        )
      )
  )
  (:action attach_approval_document_to_slot
    :parameters (?shift_slot - shift_slot ?approval_document_type - approval_document_type)
    :precondition
      (and
        (requalification_scheduled ?shift_slot)
        (approval_document_available ?approval_document_type)
        (slot_document_applicability ?shift_slot ?approval_document_type)
      )
    :effect
      (and
        (slot_document_linked_day ?shift_slot ?approval_document_type)
        (not
          (approval_document_available ?approval_document_type)
        )
      )
  )
  (:action link_cross_shift_approval_between_shifts
    :parameters (?night_shift_slot - night_shift_slot ?day_shift_slot - day_shift_slot ?approval_document_type - approval_document_type)
    :precondition
      (and
        (slot_active ?night_shift_slot)
        (night_shift_policy_applicable ?night_shift_slot)
        (slot_requires_document_type ?night_shift_slot ?approval_document_type)
        (slot_document_linked_day ?day_shift_slot ?approval_document_type)
        (not
          (slot_document_linked ?night_shift_slot ?approval_document_type)
        )
      )
    :effect
      (and
        (slot_document_linked ?night_shift_slot ?approval_document_type)
      )
  )
  (:action mark_followup_completed_for_slot
    :parameters (?shift_slot - shift_slot ?orientation_session - orientation_session ?trainer - trainer)
    :precondition
      (and
        (slot_active ?shift_slot)
        (night_shift_policy_applicable ?shift_slot)
        (competency_verified ?shift_slot)
        (requalification_scheduled ?shift_slot)
        (slot_reserved_orientation_session ?shift_slot ?orientation_session)
        (trainer_available ?trainer)
        (not
          (followup_completed ?shift_slot)
        )
      )
    :effect
      (and
        (followup_completed ?shift_slot)
      )
  )
  (:action finalize_day_shift_slot_standard
    :parameters (?shift_slot - shift_slot)
    :precondition
      (and
        (day_shift_policy_applicable ?shift_slot)
        (slot_active ?shift_slot)
        (slot_assignment_pending ?shift_slot)
        (clinical_role_scheduled ?shift_slot)
        (competency_certified ?shift_slot)
        (requalification_scheduled ?shift_slot)
        (competency_verified ?shift_slot)
        (not
          (slot_finalized ?shift_slot)
        )
      )
    :effect
      (and
        (slot_finalized ?shift_slot)
      )
  )
  (:action finalize_slot_with_document
    :parameters (?shift_slot - shift_slot ?approval_document_type - approval_document_type)
    :precondition
      (and
        (night_shift_policy_applicable ?shift_slot)
        (slot_active ?shift_slot)
        (slot_assignment_pending ?shift_slot)
        (clinical_role_scheduled ?shift_slot)
        (competency_certified ?shift_slot)
        (requalification_scheduled ?shift_slot)
        (competency_verified ?shift_slot)
        (slot_document_linked ?shift_slot ?approval_document_type)
        (not
          (slot_finalized ?shift_slot)
        )
      )
    :effect
      (and
        (slot_finalized ?shift_slot)
      )
  )
  (:action finalize_slot_with_followup
    :parameters (?shift_slot - shift_slot)
    :precondition
      (and
        (night_shift_policy_applicable ?shift_slot)
        (slot_active ?shift_slot)
        (slot_assignment_pending ?shift_slot)
        (clinical_role_scheduled ?shift_slot)
        (competency_certified ?shift_slot)
        (requalification_scheduled ?shift_slot)
        (competency_verified ?shift_slot)
        (followup_completed ?shift_slot)
        (not
          (slot_finalized ?shift_slot)
        )
      )
    :effect
      (and
        (slot_finalized ?shift_slot)
      )
  )
)

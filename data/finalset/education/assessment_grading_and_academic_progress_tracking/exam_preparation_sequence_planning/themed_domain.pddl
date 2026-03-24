(define (domain exam_preparation_sequence_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_asset_category - object support_item_category - object session_and_package_category - object entity - object actor - entity study_resource - operational_asset_category exam_slot - operational_asset_category assessor - operational_asset_category administrative_document - operational_asset_category accommodation - operational_asset_category grading_threshold - operational_asset_category proctor_assignment - operational_asset_category external_endorsement - operational_asset_category remedial_task - support_item_category assessment_component - support_item_category override_permission - support_item_category study_session - session_and_package_category study_session_variant - session_and_package_category exam_package - session_and_package_category learner_category - actor organizational_unit - actor candidate_primary - learner_category candidate_secondary - learner_category course_section - organizational_unit)
  (:predicates
    (actor_identified ?participant - actor)
    (actor_ready ?participant - actor)
    (has_assigned_resource ?participant - actor)
    (milestone_completed ?participant - actor)
    (eligible_for_finalization ?participant - actor)
    (final_grade_recorded ?participant - actor)
    (study_resource_available ?study_resource - study_resource)
    (assigned_study_resource ?participant - actor ?study_resource - study_resource)
    (exam_slot_available ?exam_slot - exam_slot)
    (reserved_exam_slot ?participant - actor ?exam_slot - exam_slot)
    (assessor_available ?assessor - assessor)
    (assessor_assigned ?participant - actor ?assessor - assessor)
    (remedial_task_available ?remedial_task - remedial_task)
    (primary_assigned_remedial ?primary_candidate - candidate_primary ?remedial_task - remedial_task)
    (secondary_assigned_remedial ?secondary_candidate - candidate_secondary ?remedial_task - remedial_task)
    (primary_scheduled_for_session ?primary_candidate - candidate_primary ?study_session - study_session)
    (study_session_confirmed ?study_session - study_session)
    (study_session_in_remediation ?study_session - study_session)
    (primary_session_completed ?primary_candidate - candidate_primary)
    (secondary_scheduled_for_session_variant ?secondary_candidate - candidate_secondary ?study_session_variant - study_session_variant)
    (session_variant_confirmed ?study_session_variant - study_session_variant)
    (session_variant_in_remediation ?study_session_variant - study_session_variant)
    (secondary_session_completed ?secondary_candidate - candidate_secondary)
    (exam_package_pending ?exam_package - exam_package)
    (exam_package_assembled ?exam_package - exam_package)
    (exam_package_targets_session ?exam_package - exam_package ?study_session - study_session)
    (exam_package_targets_session_variant ?exam_package - exam_package ?study_session_variant - study_session_variant)
    (exam_package_includes_remediation ?exam_package - exam_package)
    (exam_package_includes_secondary_remediation ?exam_package - exam_package)
    (exam_package_executed ?exam_package - exam_package)
    (section_enrolled_primary_candidate ?course_section - course_section ?primary_candidate - candidate_primary)
    (section_enrolled_secondary_candidate ?course_section - course_section ?secondary_candidate - candidate_secondary)
    (section_linked_exam_package ?course_section - course_section ?exam_package - exam_package)
    (assessment_component_available ?assessment_component - assessment_component)
    (section_has_assessment_component ?course_section - course_section ?assessment_component - assessment_component)
    (assessment_component_moderated ?assessment_component - assessment_component)
    (component_linked_to_package ?assessment_component - assessment_component ?exam_package - exam_package)
    (section_moderation_initiated ?course_section - course_section)
    (section_proctor_confirmed ?course_section - course_section)
    (section_external_endorsement_completed ?course_section - course_section)
    (section_admin_document_registered ?course_section - course_section)
    (section_admin_document_processed ?course_section - course_section)
    (section_accommodation_requested ?course_section - course_section)
    (section_instructor_review_completed ?course_section - course_section)
    (override_permission_available ?override_permission - override_permission)
    (section_has_override_permission ?course_section - course_section ?override_permission - override_permission)
    (section_override_applied ?course_section - course_section)
    (section_override_recorded ?course_section - course_section)
    (section_override_endorsed ?course_section - course_section)
    (administrative_document_available ?administrative_document - administrative_document)
    (section_registered_admin_document ?course_section - course_section ?administrative_document - administrative_document)
    (accommodation_available ?accommodation - accommodation)
    (section_assigned_accommodation ?course_section - course_section ?accommodation - accommodation)
    (proctor_assignment_available ?proctor_assignment - proctor_assignment)
    (section_proctor_assigned ?course_section - course_section ?proctor_assignment - proctor_assignment)
    (external_endorsement_available ?external_endorsement - external_endorsement)
    (section_external_endorsement_assigned ?course_section - course_section ?external_endorsement - external_endorsement)
    (grading_threshold_available ?grading_threshold - grading_threshold)
    (actor_assigned_grading_threshold ?participant - actor ?grading_threshold - grading_threshold)
    (primary_candidate_session_processed ?primary_candidate - candidate_primary)
    (secondary_candidate_session_processed ?secondary_candidate - candidate_secondary)
    (section_finalized ?course_section - course_section)
  )
  (:action register_candidate
    :parameters (?participant - actor)
    :precondition
      (and
        (not
          (actor_identified ?participant)
        )
        (not
          (milestone_completed ?participant)
        )
      )
    :effect (actor_identified ?participant)
  )
  (:action allocate_study_resource
    :parameters (?participant - actor ?study_resource - study_resource)
    :precondition
      (and
        (actor_identified ?participant)
        (not
          (has_assigned_resource ?participant)
        )
        (study_resource_available ?study_resource)
      )
    :effect
      (and
        (has_assigned_resource ?participant)
        (assigned_study_resource ?participant ?study_resource)
        (not
          (study_resource_available ?study_resource)
        )
      )
  )
  (:action reserve_exam_slot_for_participant
    :parameters (?participant - actor ?exam_slot - exam_slot)
    :precondition
      (and
        (actor_identified ?participant)
        (has_assigned_resource ?participant)
        (exam_slot_available ?exam_slot)
      )
    :effect
      (and
        (reserved_exam_slot ?participant ?exam_slot)
        (not
          (exam_slot_available ?exam_slot)
        )
      )
  )
  (:action confirm_participant_readiness
    :parameters (?participant - actor ?exam_slot - exam_slot)
    :precondition
      (and
        (actor_identified ?participant)
        (has_assigned_resource ?participant)
        (reserved_exam_slot ?participant ?exam_slot)
        (not
          (actor_ready ?participant)
        )
      )
    :effect (actor_ready ?participant)
  )
  (:action cancel_exam_slot_reservation
    :parameters (?participant - actor ?exam_slot - exam_slot)
    :precondition
      (and
        (reserved_exam_slot ?participant ?exam_slot)
      )
    :effect
      (and
        (exam_slot_available ?exam_slot)
        (not
          (reserved_exam_slot ?participant ?exam_slot)
        )
      )
  )
  (:action assign_assessor_to_participant
    :parameters (?participant - actor ?assessor - assessor)
    :precondition
      (and
        (actor_ready ?participant)
        (assessor_available ?assessor)
      )
    :effect
      (and
        (assessor_assigned ?participant ?assessor)
        (not
          (assessor_available ?assessor)
        )
      )
  )
  (:action unassign_assessor_from_participant
    :parameters (?participant - actor ?assessor - assessor)
    :precondition
      (and
        (assessor_assigned ?participant ?assessor)
      )
    :effect
      (and
        (assessor_available ?assessor)
        (not
          (assessor_assigned ?participant ?assessor)
        )
      )
  )
  (:action assign_proctor_to_section
    :parameters (?course_section - course_section ?proctor_assignment - proctor_assignment)
    :precondition
      (and
        (actor_ready ?course_section)
        (proctor_assignment_available ?proctor_assignment)
      )
    :effect
      (and
        (section_proctor_assigned ?course_section ?proctor_assignment)
        (not
          (proctor_assignment_available ?proctor_assignment)
        )
      )
  )
  (:action unassign_proctor_from_section
    :parameters (?course_section - course_section ?proctor_assignment - proctor_assignment)
    :precondition
      (and
        (section_proctor_assigned ?course_section ?proctor_assignment)
      )
    :effect
      (and
        (proctor_assignment_available ?proctor_assignment)
        (not
          (section_proctor_assigned ?course_section ?proctor_assignment)
        )
      )
  )
  (:action assign_external_endorsement_to_section
    :parameters (?course_section - course_section ?external_endorsement - external_endorsement)
    :precondition
      (and
        (actor_ready ?course_section)
        (external_endorsement_available ?external_endorsement)
      )
    :effect
      (and
        (section_external_endorsement_assigned ?course_section ?external_endorsement)
        (not
          (external_endorsement_available ?external_endorsement)
        )
      )
  )
  (:action revoke_external_endorsement_from_section
    :parameters (?course_section - course_section ?external_endorsement - external_endorsement)
    :precondition
      (and
        (section_external_endorsement_assigned ?course_section ?external_endorsement)
      )
    :effect
      (and
        (external_endorsement_available ?external_endorsement)
        (not
          (section_external_endorsement_assigned ?course_section ?external_endorsement)
        )
      )
  )
  (:action confirm_study_session_for_primary_candidate
    :parameters (?primary_candidate - candidate_primary ?study_session - study_session ?exam_slot - exam_slot)
    :precondition
      (and
        (actor_ready ?primary_candidate)
        (reserved_exam_slot ?primary_candidate ?exam_slot)
        (primary_scheduled_for_session ?primary_candidate ?study_session)
        (not
          (study_session_confirmed ?study_session)
        )
        (not
          (study_session_in_remediation ?study_session)
        )
      )
    :effect (study_session_confirmed ?study_session)
  )
  (:action finalize_primary_candidate_session
    :parameters (?primary_candidate - candidate_primary ?study_session - study_session ?assessor - assessor)
    :precondition
      (and
        (actor_ready ?primary_candidate)
        (assessor_assigned ?primary_candidate ?assessor)
        (primary_scheduled_for_session ?primary_candidate ?study_session)
        (study_session_confirmed ?study_session)
        (not
          (primary_candidate_session_processed ?primary_candidate)
        )
      )
    :effect
      (and
        (primary_candidate_session_processed ?primary_candidate)
        (primary_session_completed ?primary_candidate)
      )
  )
  (:action assign_remedial_task_to_primary_candidate
    :parameters (?primary_candidate - candidate_primary ?study_session - study_session ?remedial_task - remedial_task)
    :precondition
      (and
        (actor_ready ?primary_candidate)
        (primary_scheduled_for_session ?primary_candidate ?study_session)
        (remedial_task_available ?remedial_task)
        (not
          (primary_candidate_session_processed ?primary_candidate)
        )
      )
    :effect
      (and
        (study_session_in_remediation ?study_session)
        (primary_candidate_session_processed ?primary_candidate)
        (primary_assigned_remedial ?primary_candidate ?remedial_task)
        (not
          (remedial_task_available ?remedial_task)
        )
      )
  )
  (:action complete_primary_candidate_remediation
    :parameters (?primary_candidate - candidate_primary ?study_session - study_session ?exam_slot - exam_slot ?remedial_task - remedial_task)
    :precondition
      (and
        (actor_ready ?primary_candidate)
        (reserved_exam_slot ?primary_candidate ?exam_slot)
        (primary_scheduled_for_session ?primary_candidate ?study_session)
        (study_session_in_remediation ?study_session)
        (primary_assigned_remedial ?primary_candidate ?remedial_task)
        (not
          (primary_session_completed ?primary_candidate)
        )
      )
    :effect
      (and
        (study_session_confirmed ?study_session)
        (primary_session_completed ?primary_candidate)
        (remedial_task_available ?remedial_task)
        (not
          (primary_assigned_remedial ?primary_candidate ?remedial_task)
        )
      )
  )
  (:action confirm_study_session_variant_for_secondary_candidate
    :parameters (?secondary_candidate - candidate_secondary ?study_session_variant - study_session_variant ?exam_slot - exam_slot)
    :precondition
      (and
        (actor_ready ?secondary_candidate)
        (reserved_exam_slot ?secondary_candidate ?exam_slot)
        (secondary_scheduled_for_session_variant ?secondary_candidate ?study_session_variant)
        (not
          (session_variant_confirmed ?study_session_variant)
        )
        (not
          (session_variant_in_remediation ?study_session_variant)
        )
      )
    :effect (session_variant_confirmed ?study_session_variant)
  )
  (:action finalize_secondary_candidate_session
    :parameters (?secondary_candidate - candidate_secondary ?study_session_variant - study_session_variant ?assessor - assessor)
    :precondition
      (and
        (actor_ready ?secondary_candidate)
        (assessor_assigned ?secondary_candidate ?assessor)
        (secondary_scheduled_for_session_variant ?secondary_candidate ?study_session_variant)
        (session_variant_confirmed ?study_session_variant)
        (not
          (secondary_candidate_session_processed ?secondary_candidate)
        )
      )
    :effect
      (and
        (secondary_candidate_session_processed ?secondary_candidate)
        (secondary_session_completed ?secondary_candidate)
      )
  )
  (:action assign_remedial_task_to_secondary_candidate
    :parameters (?secondary_candidate - candidate_secondary ?study_session_variant - study_session_variant ?remedial_task - remedial_task)
    :precondition
      (and
        (actor_ready ?secondary_candidate)
        (secondary_scheduled_for_session_variant ?secondary_candidate ?study_session_variant)
        (remedial_task_available ?remedial_task)
        (not
          (secondary_candidate_session_processed ?secondary_candidate)
        )
      )
    :effect
      (and
        (session_variant_in_remediation ?study_session_variant)
        (secondary_candidate_session_processed ?secondary_candidate)
        (secondary_assigned_remedial ?secondary_candidate ?remedial_task)
        (not
          (remedial_task_available ?remedial_task)
        )
      )
  )
  (:action complete_secondary_candidate_remediation
    :parameters (?secondary_candidate - candidate_secondary ?study_session_variant - study_session_variant ?exam_slot - exam_slot ?remedial_task - remedial_task)
    :precondition
      (and
        (actor_ready ?secondary_candidate)
        (reserved_exam_slot ?secondary_candidate ?exam_slot)
        (secondary_scheduled_for_session_variant ?secondary_candidate ?study_session_variant)
        (session_variant_in_remediation ?study_session_variant)
        (secondary_assigned_remedial ?secondary_candidate ?remedial_task)
        (not
          (secondary_session_completed ?secondary_candidate)
        )
      )
    :effect
      (and
        (session_variant_confirmed ?study_session_variant)
        (secondary_session_completed ?secondary_candidate)
        (remedial_task_available ?remedial_task)
        (not
          (secondary_assigned_remedial ?secondary_candidate ?remedial_task)
        )
      )
  )
  (:action assemble_exam_package_from_sessions
    :parameters (?primary_candidate - candidate_primary ?secondary_candidate - candidate_secondary ?study_session - study_session ?study_session_variant - study_session_variant ?exam_package - exam_package)
    :precondition
      (and
        (primary_candidate_session_processed ?primary_candidate)
        (secondary_candidate_session_processed ?secondary_candidate)
        (primary_scheduled_for_session ?primary_candidate ?study_session)
        (secondary_scheduled_for_session_variant ?secondary_candidate ?study_session_variant)
        (study_session_confirmed ?study_session)
        (session_variant_confirmed ?study_session_variant)
        (primary_session_completed ?primary_candidate)
        (secondary_session_completed ?secondary_candidate)
        (exam_package_pending ?exam_package)
      )
    :effect
      (and
        (exam_package_assembled ?exam_package)
        (exam_package_targets_session ?exam_package ?study_session)
        (exam_package_targets_session_variant ?exam_package ?study_session_variant)
        (not
          (exam_package_pending ?exam_package)
        )
      )
  )
  (:action assemble_exam_package_with_remediation
    :parameters (?primary_candidate - candidate_primary ?secondary_candidate - candidate_secondary ?study_session - study_session ?study_session_variant - study_session_variant ?exam_package - exam_package)
    :precondition
      (and
        (primary_candidate_session_processed ?primary_candidate)
        (secondary_candidate_session_processed ?secondary_candidate)
        (primary_scheduled_for_session ?primary_candidate ?study_session)
        (secondary_scheduled_for_session_variant ?secondary_candidate ?study_session_variant)
        (study_session_in_remediation ?study_session)
        (session_variant_confirmed ?study_session_variant)
        (not
          (primary_session_completed ?primary_candidate)
        )
        (secondary_session_completed ?secondary_candidate)
        (exam_package_pending ?exam_package)
      )
    :effect
      (and
        (exam_package_assembled ?exam_package)
        (exam_package_targets_session ?exam_package ?study_session)
        (exam_package_targets_session_variant ?exam_package ?study_session_variant)
        (exam_package_includes_remediation ?exam_package)
        (not
          (exam_package_pending ?exam_package)
        )
      )
  )
  (:action assemble_exam_package_with_secondary_remediation
    :parameters (?primary_candidate - candidate_primary ?secondary_candidate - candidate_secondary ?study_session - study_session ?study_session_variant - study_session_variant ?exam_package - exam_package)
    :precondition
      (and
        (primary_candidate_session_processed ?primary_candidate)
        (secondary_candidate_session_processed ?secondary_candidate)
        (primary_scheduled_for_session ?primary_candidate ?study_session)
        (secondary_scheduled_for_session_variant ?secondary_candidate ?study_session_variant)
        (study_session_confirmed ?study_session)
        (session_variant_in_remediation ?study_session_variant)
        (primary_session_completed ?primary_candidate)
        (not
          (secondary_session_completed ?secondary_candidate)
        )
        (exam_package_pending ?exam_package)
      )
    :effect
      (and
        (exam_package_assembled ?exam_package)
        (exam_package_targets_session ?exam_package ?study_session)
        (exam_package_targets_session_variant ?exam_package ?study_session_variant)
        (exam_package_includes_secondary_remediation ?exam_package)
        (not
          (exam_package_pending ?exam_package)
        )
      )
  )
  (:action assemble_exam_package_with_both_remediations
    :parameters (?primary_candidate - candidate_primary ?secondary_candidate - candidate_secondary ?study_session - study_session ?study_session_variant - study_session_variant ?exam_package - exam_package)
    :precondition
      (and
        (primary_candidate_session_processed ?primary_candidate)
        (secondary_candidate_session_processed ?secondary_candidate)
        (primary_scheduled_for_session ?primary_candidate ?study_session)
        (secondary_scheduled_for_session_variant ?secondary_candidate ?study_session_variant)
        (study_session_in_remediation ?study_session)
        (session_variant_in_remediation ?study_session_variant)
        (not
          (primary_session_completed ?primary_candidate)
        )
        (not
          (secondary_session_completed ?secondary_candidate)
        )
        (exam_package_pending ?exam_package)
      )
    :effect
      (and
        (exam_package_assembled ?exam_package)
        (exam_package_targets_session ?exam_package ?study_session)
        (exam_package_targets_session_variant ?exam_package ?study_session_variant)
        (exam_package_includes_remediation ?exam_package)
        (exam_package_includes_secondary_remediation ?exam_package)
        (not
          (exam_package_pending ?exam_package)
        )
      )
  )
  (:action execute_exam_package_for_primary_candidate
    :parameters (?exam_package - exam_package ?primary_candidate - candidate_primary ?exam_slot - exam_slot)
    :precondition
      (and
        (exam_package_assembled ?exam_package)
        (primary_candidate_session_processed ?primary_candidate)
        (reserved_exam_slot ?primary_candidate ?exam_slot)
        (not
          (exam_package_executed ?exam_package)
        )
      )
    :effect (exam_package_executed ?exam_package)
  )
  (:action moderate_assessment_component_for_section
    :parameters (?course_section - course_section ?assessment_component - assessment_component ?exam_package - exam_package)
    :precondition
      (and
        (actor_ready ?course_section)
        (section_linked_exam_package ?course_section ?exam_package)
        (section_has_assessment_component ?course_section ?assessment_component)
        (assessment_component_available ?assessment_component)
        (exam_package_assembled ?exam_package)
        (exam_package_executed ?exam_package)
        (not
          (assessment_component_moderated ?assessment_component)
        )
      )
    :effect
      (and
        (assessment_component_moderated ?assessment_component)
        (component_linked_to_package ?assessment_component ?exam_package)
        (not
          (assessment_component_available ?assessment_component)
        )
      )
  )
  (:action initiate_section_moderation
    :parameters (?course_section - course_section ?assessment_component - assessment_component ?exam_package - exam_package ?exam_slot - exam_slot)
    :precondition
      (and
        (actor_ready ?course_section)
        (section_has_assessment_component ?course_section ?assessment_component)
        (assessment_component_moderated ?assessment_component)
        (component_linked_to_package ?assessment_component ?exam_package)
        (reserved_exam_slot ?course_section ?exam_slot)
        (not
          (exam_package_includes_remediation ?exam_package)
        )
        (not
          (section_moderation_initiated ?course_section)
        )
      )
    :effect (section_moderation_initiated ?course_section)
  )
  (:action register_admin_document_for_section
    :parameters (?course_section - course_section ?administrative_document - administrative_document)
    :precondition
      (and
        (actor_ready ?course_section)
        (administrative_document_available ?administrative_document)
        (not
          (section_admin_document_registered ?course_section)
        )
      )
    :effect
      (and
        (section_admin_document_registered ?course_section)
        (section_registered_admin_document ?course_section ?administrative_document)
        (not
          (administrative_document_available ?administrative_document)
        )
      )
  )
  (:action process_admin_document_for_section
    :parameters (?course_section - course_section ?assessment_component - assessment_component ?exam_package - exam_package ?exam_slot - exam_slot ?administrative_document - administrative_document)
    :precondition
      (and
        (actor_ready ?course_section)
        (section_has_assessment_component ?course_section ?assessment_component)
        (assessment_component_moderated ?assessment_component)
        (component_linked_to_package ?assessment_component ?exam_package)
        (reserved_exam_slot ?course_section ?exam_slot)
        (exam_package_includes_remediation ?exam_package)
        (section_admin_document_registered ?course_section)
        (section_registered_admin_document ?course_section ?administrative_document)
        (not
          (section_moderation_initiated ?course_section)
        )
      )
    :effect
      (and
        (section_moderation_initiated ?course_section)
        (section_admin_document_processed ?course_section)
      )
  )
  (:action confirm_proctor_assignment_for_section_standard
    :parameters (?course_section - course_section ?proctor_assignment - proctor_assignment ?assessor - assessor ?assessment_component - assessment_component ?exam_package - exam_package)
    :precondition
      (and
        (section_moderation_initiated ?course_section)
        (section_proctor_assigned ?course_section ?proctor_assignment)
        (assessor_assigned ?course_section ?assessor)
        (section_has_assessment_component ?course_section ?assessment_component)
        (component_linked_to_package ?assessment_component ?exam_package)
        (not
          (exam_package_includes_secondary_remediation ?exam_package)
        )
        (not
          (section_proctor_confirmed ?course_section)
        )
      )
    :effect (section_proctor_confirmed ?course_section)
  )
  (:action confirm_proctor_assignment_for_section_variant
    :parameters (?course_section - course_section ?proctor_assignment - proctor_assignment ?assessor - assessor ?assessment_component - assessment_component ?exam_package - exam_package)
    :precondition
      (and
        (section_moderation_initiated ?course_section)
        (section_proctor_assigned ?course_section ?proctor_assignment)
        (assessor_assigned ?course_section ?assessor)
        (section_has_assessment_component ?course_section ?assessment_component)
        (component_linked_to_package ?assessment_component ?exam_package)
        (exam_package_includes_secondary_remediation ?exam_package)
        (not
          (section_proctor_confirmed ?course_section)
        )
      )
    :effect (section_proctor_confirmed ?course_section)
  )
  (:action apply_external_endorsement_to_section
    :parameters (?course_section - course_section ?external_endorsement - external_endorsement ?assessment_component - assessment_component ?exam_package - exam_package)
    :precondition
      (and
        (section_proctor_confirmed ?course_section)
        (section_external_endorsement_assigned ?course_section ?external_endorsement)
        (section_has_assessment_component ?course_section ?assessment_component)
        (component_linked_to_package ?assessment_component ?exam_package)
        (not
          (exam_package_includes_remediation ?exam_package)
        )
        (not
          (exam_package_includes_secondary_remediation ?exam_package)
        )
        (not
          (section_external_endorsement_completed ?course_section)
        )
      )
    :effect (section_external_endorsement_completed ?course_section)
  )
  (:action apply_external_endorsement_and_request_accommodation_variant_a
    :parameters (?course_section - course_section ?external_endorsement - external_endorsement ?assessment_component - assessment_component ?exam_package - exam_package)
    :precondition
      (and
        (section_proctor_confirmed ?course_section)
        (section_external_endorsement_assigned ?course_section ?external_endorsement)
        (section_has_assessment_component ?course_section ?assessment_component)
        (component_linked_to_package ?assessment_component ?exam_package)
        (exam_package_includes_remediation ?exam_package)
        (not
          (exam_package_includes_secondary_remediation ?exam_package)
        )
        (not
          (section_external_endorsement_completed ?course_section)
        )
      )
    :effect
      (and
        (section_external_endorsement_completed ?course_section)
        (section_accommodation_requested ?course_section)
      )
  )
  (:action apply_external_endorsement_and_request_accommodation_variant_b
    :parameters (?course_section - course_section ?external_endorsement - external_endorsement ?assessment_component - assessment_component ?exam_package - exam_package)
    :precondition
      (and
        (section_proctor_confirmed ?course_section)
        (section_external_endorsement_assigned ?course_section ?external_endorsement)
        (section_has_assessment_component ?course_section ?assessment_component)
        (component_linked_to_package ?assessment_component ?exam_package)
        (not
          (exam_package_includes_remediation ?exam_package)
        )
        (exam_package_includes_secondary_remediation ?exam_package)
        (not
          (section_external_endorsement_completed ?course_section)
        )
      )
    :effect
      (and
        (section_external_endorsement_completed ?course_section)
        (section_accommodation_requested ?course_section)
      )
  )
  (:action apply_external_endorsement_and_request_accommodation_variant_c
    :parameters (?course_section - course_section ?external_endorsement - external_endorsement ?assessment_component - assessment_component ?exam_package - exam_package)
    :precondition
      (and
        (section_proctor_confirmed ?course_section)
        (section_external_endorsement_assigned ?course_section ?external_endorsement)
        (section_has_assessment_component ?course_section ?assessment_component)
        (component_linked_to_package ?assessment_component ?exam_package)
        (exam_package_includes_remediation ?exam_package)
        (exam_package_includes_secondary_remediation ?exam_package)
        (not
          (section_external_endorsement_completed ?course_section)
        )
      )
    :effect
      (and
        (section_external_endorsement_completed ?course_section)
        (section_accommodation_requested ?course_section)
      )
  )
  (:action finalize_section_without_accommodation
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_external_endorsement_completed ?course_section)
        (not
          (section_accommodation_requested ?course_section)
        )
        (not
          (section_finalized ?course_section)
        )
      )
    :effect
      (and
        (section_finalized ?course_section)
        (eligible_for_finalization ?course_section)
      )
  )
  (:action assign_accommodation_to_section
    :parameters (?course_section - course_section ?accommodation - accommodation)
    :precondition
      (and
        (section_external_endorsement_completed ?course_section)
        (section_accommodation_requested ?course_section)
        (accommodation_available ?accommodation)
      )
    :effect
      (and
        (section_assigned_accommodation ?course_section ?accommodation)
        (not
          (accommodation_available ?accommodation)
        )
      )
  )
  (:action complete_instructor_review_for_section
    :parameters (?course_section - course_section ?primary_candidate - candidate_primary ?secondary_candidate - candidate_secondary ?exam_slot - exam_slot ?accommodation - accommodation)
    :precondition
      (and
        (section_external_endorsement_completed ?course_section)
        (section_accommodation_requested ?course_section)
        (section_assigned_accommodation ?course_section ?accommodation)
        (section_enrolled_primary_candidate ?course_section ?primary_candidate)
        (section_enrolled_secondary_candidate ?course_section ?secondary_candidate)
        (primary_session_completed ?primary_candidate)
        (secondary_session_completed ?secondary_candidate)
        (reserved_exam_slot ?course_section ?exam_slot)
        (not
          (section_instructor_review_completed ?course_section)
        )
      )
    :effect (section_instructor_review_completed ?course_section)
  )
  (:action finalize_section_after_review
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_external_endorsement_completed ?course_section)
        (section_instructor_review_completed ?course_section)
        (not
          (section_finalized ?course_section)
        )
      )
    :effect
      (and
        (section_finalized ?course_section)
        (eligible_for_finalization ?course_section)
      )
  )
  (:action apply_override_permission_to_section
    :parameters (?course_section - course_section ?override_permission - override_permission ?exam_slot - exam_slot)
    :precondition
      (and
        (actor_ready ?course_section)
        (reserved_exam_slot ?course_section ?exam_slot)
        (override_permission_available ?override_permission)
        (section_has_override_permission ?course_section ?override_permission)
        (not
          (section_override_applied ?course_section)
        )
      )
    :effect
      (and
        (section_override_applied ?course_section)
        (not
          (override_permission_available ?override_permission)
        )
      )
  )
  (:action record_override_by_assessor_for_section
    :parameters (?course_section - course_section ?assessor - assessor)
    :precondition
      (and
        (section_override_applied ?course_section)
        (assessor_assigned ?course_section ?assessor)
        (not
          (section_override_recorded ?course_section)
        )
      )
    :effect (section_override_recorded ?course_section)
  )
  (:action endorse_override_for_section
    :parameters (?course_section - course_section ?external_endorsement - external_endorsement)
    :precondition
      (and
        (section_override_recorded ?course_section)
        (section_external_endorsement_assigned ?course_section ?external_endorsement)
        (not
          (section_override_endorsed ?course_section)
        )
      )
    :effect (section_override_endorsed ?course_section)
  )
  (:action finalize_section_after_override_endorsement
    :parameters (?course_section - course_section)
    :precondition
      (and
        (section_override_endorsed ?course_section)
        (not
          (section_finalized ?course_section)
        )
      )
    :effect
      (and
        (section_finalized ?course_section)
        (eligible_for_finalization ?course_section)
      )
  )
  (:action flag_primary_candidate_ready_for_finalization
    :parameters (?primary_candidate - candidate_primary ?exam_package - exam_package)
    :precondition
      (and
        (primary_candidate_session_processed ?primary_candidate)
        (primary_session_completed ?primary_candidate)
        (exam_package_assembled ?exam_package)
        (exam_package_executed ?exam_package)
        (not
          (eligible_for_finalization ?primary_candidate)
        )
      )
    :effect (eligible_for_finalization ?primary_candidate)
  )
  (:action flag_secondary_candidate_ready_for_finalization
    :parameters (?secondary_candidate - candidate_secondary ?exam_package - exam_package)
    :precondition
      (and
        (secondary_candidate_session_processed ?secondary_candidate)
        (secondary_session_completed ?secondary_candidate)
        (exam_package_assembled ?exam_package)
        (exam_package_executed ?exam_package)
        (not
          (eligible_for_finalization ?secondary_candidate)
        )
      )
    :effect (eligible_for_finalization ?secondary_candidate)
  )
  (:action apply_final_grade_to_participant
    :parameters (?participant - actor ?grading_threshold - grading_threshold ?exam_slot - exam_slot)
    :precondition
      (and
        (eligible_for_finalization ?participant)
        (reserved_exam_slot ?participant ?exam_slot)
        (grading_threshold_available ?grading_threshold)
        (not
          (final_grade_recorded ?participant)
        )
      )
    :effect
      (and
        (final_grade_recorded ?participant)
        (actor_assigned_grading_threshold ?participant ?grading_threshold)
        (not
          (grading_threshold_available ?grading_threshold)
        )
      )
  )
  (:action finalize_primary_candidate_and_release_resource
    :parameters (?primary_candidate - candidate_primary ?study_resource - study_resource ?grading_threshold - grading_threshold)
    :precondition
      (and
        (final_grade_recorded ?primary_candidate)
        (assigned_study_resource ?primary_candidate ?study_resource)
        (actor_assigned_grading_threshold ?primary_candidate ?grading_threshold)
        (not
          (milestone_completed ?primary_candidate)
        )
      )
    :effect
      (and
        (milestone_completed ?primary_candidate)
        (study_resource_available ?study_resource)
        (grading_threshold_available ?grading_threshold)
      )
  )
  (:action finalize_secondary_candidate_and_release_resource
    :parameters (?secondary_candidate - candidate_secondary ?study_resource - study_resource ?grading_threshold - grading_threshold)
    :precondition
      (and
        (final_grade_recorded ?secondary_candidate)
        (assigned_study_resource ?secondary_candidate ?study_resource)
        (actor_assigned_grading_threshold ?secondary_candidate ?grading_threshold)
        (not
          (milestone_completed ?secondary_candidate)
        )
      )
    :effect
      (and
        (milestone_completed ?secondary_candidate)
        (study_resource_available ?study_resource)
        (grading_threshold_available ?grading_threshold)
      )
  )
  (:action finalize_section_and_release_resource
    :parameters (?course_section - course_section ?study_resource - study_resource ?grading_threshold - grading_threshold)
    :precondition
      (and
        (final_grade_recorded ?course_section)
        (assigned_study_resource ?course_section ?study_resource)
        (actor_assigned_grading_threshold ?course_section ?grading_threshold)
        (not
          (milestone_completed ?course_section)
        )
      )
    :effect
      (and
        (milestone_completed ?course_section)
        (study_resource_available ?study_resource)
        (grading_threshold_available ?grading_threshold)
      )
  )
)

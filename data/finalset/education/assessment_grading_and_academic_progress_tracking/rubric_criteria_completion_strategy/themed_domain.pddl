(define (domain rubric_criteria_completion_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_entity - object role_category - object resource_category - object top_level_assessment - object assessment_item - top_level_assessment schedule_slot - domain_entity attempt - domain_entity grader - domain_entity recommendation - domain_entity extension_request - domain_entity recovery_token - domain_entity feedback_artifact - domain_entity escalation_notice - domain_entity criterion_component - role_category supporting_material - role_category approval_artifact - role_category assessment_window - resource_category exam_session - resource_category submission_bundle - resource_category assessment_subitem - assessment_item assessment_group - assessment_item learner - assessment_subitem learner_group - assessment_subitem instructor - assessment_group)
  (:predicates
    (assessment_registered ?assessment_item - assessment_item)
    (entity_authorized_for_assessment ?assessment_item - assessment_item)
    (assessment_reservation_confirmed ?assessment_item - assessment_item)
    (entity_outcome_recorded ?assessment_item - assessment_item)
    (entity_grade_finalized ?assessment_item - assessment_item)
    (entity_recovery_initiated ?assessment_item - assessment_item)
    (slot_available ?schedule_slot - schedule_slot)
    (entity_assigned_slot ?assessment_item - assessment_item ?schedule_slot - schedule_slot)
    (attempt_available ?attempt - attempt)
    (entity_has_attempt ?assessment_item - assessment_item ?attempt - attempt)
    (grader_available ?grader - grader)
    (entity_assigned_grader ?assessment_item - assessment_item ?grader - grader)
    (criterion_component_available ?criterion_component - criterion_component)
    (learner_assigned_component ?learner - learner ?criterion_component - criterion_component)
    (group_assigned_component ?learner_group - learner_group ?criterion_component - criterion_component)
    (learner_assigned_window ?learner - learner ?assessment_window - assessment_window)
    (window_ready ?assessment_window - assessment_window)
    (window_resources_allocated ?assessment_window - assessment_window)
    (learner_ready ?learner - learner)
    (group_assigned_session ?learner_group - learner_group ?exam_session - exam_session)
    (session_ready ?exam_session - exam_session)
    (session_resources_allocated ?exam_session - exam_session)
    (group_ready ?learner_group - learner_group)
    (submission_bundle_available ?submission_bundle - submission_bundle)
    (submission_bundle_prepared ?submission_bundle - submission_bundle)
    (bundle_mapped_window ?submission_bundle - submission_bundle ?assessment_window - assessment_window)
    (bundle_assigned_session ?submission_bundle - submission_bundle ?exam_session - exam_session)
    (bundle_requires_instructor_review ?submission_bundle - submission_bundle)
    (bundle_requires_additional_processing ?submission_bundle - submission_bundle)
    (bundle_locked_for_attachment ?submission_bundle - submission_bundle)
    (instructor_assigned_learner ?instructor - instructor ?learner - learner)
    (instructor_assigned_group ?instructor - instructor ?learner_group - learner_group)
    (instructor_responsible_for_bundle ?instructor - instructor ?submission_bundle - submission_bundle)
    (supporting_material_available ?supporting_material - supporting_material)
    (instructor_associated_material ?instructor - instructor ?supporting_material - supporting_material)
    (supporting_material_attached ?supporting_material - supporting_material)
    (material_attached_to_bundle ?supporting_material - supporting_material ?submission_bundle - submission_bundle)
    (instructor_material_ready ?instructor - instructor)
    (instructor_feedback_prepared ?instructor - instructor)
    (feedback_ready_for_signoff ?instructor - instructor)
    (recommendation_assigned ?instructor - instructor)
    (instructor_review_logged ?instructor - instructor)
    (extension_processing_required ?instructor - instructor)
    (instructor_signoff_ready ?instructor - instructor)
    (approval_artifact_available ?approval_artifact - approval_artifact)
    (instructor_has_approval ?instructor - instructor ?approval_artifact - approval_artifact)
    (approval_acknowledged ?instructor - instructor)
    (approval_processed ?instructor - instructor)
    (escalation_linked ?instructor - instructor)
    (recommendation_available ?recommendation - recommendation)
    (instructor_assigned_recommendation ?instructor - instructor ?recommendation - recommendation)
    (extension_request_available ?extension_request - extension_request)
    (instructor_assigned_extension ?instructor - instructor ?extension_request - extension_request)
    (feedback_artifact_available ?feedback_artifact - feedback_artifact)
    (instructor_has_feedback_artifact ?instructor - instructor ?feedback_artifact - feedback_artifact)
    (escalation_notice_available ?escalation_notice - escalation_notice)
    (instructor_escalation_notice ?instructor - instructor ?escalation_notice - escalation_notice)
    (recovery_token_available ?recovery_token - recovery_token)
    (entity_recovery_token_assigned ?assessment_item - assessment_item ?recovery_token - recovery_token)
    (learner_confirmed ?learner - learner)
    (group_confirmed ?learner_group - learner_group)
    (grade_signoff_recorded ?instructor - instructor)
  )
  (:action register_assessment_item
    :parameters (?assessment_item - assessment_item)
    :precondition
      (and
        (not
          (assessment_registered ?assessment_item)
        )
        (not
          (entity_outcome_recorded ?assessment_item)
        )
      )
    :effect (assessment_registered ?assessment_item)
  )
  (:action reserve_schedule_slot_for_assessment
    :parameters (?assessment_item - assessment_item ?schedule_slot - schedule_slot)
    :precondition
      (and
        (assessment_registered ?assessment_item)
        (not
          (assessment_reservation_confirmed ?assessment_item)
        )
        (slot_available ?schedule_slot)
      )
    :effect
      (and
        (assessment_reservation_confirmed ?assessment_item)
        (entity_assigned_slot ?assessment_item ?schedule_slot)
        (not
          (slot_available ?schedule_slot)
        )
      )
  )
  (:action instantiate_attempt_for_assessment
    :parameters (?assessment_item - assessment_item ?attempt - attempt)
    :precondition
      (and
        (assessment_registered ?assessment_item)
        (assessment_reservation_confirmed ?assessment_item)
        (attempt_available ?attempt)
      )
    :effect
      (and
        (entity_has_attempt ?assessment_item ?attempt)
        (not
          (attempt_available ?attempt)
        )
      )
  )
  (:action authorize_assessment_for_evaluation
    :parameters (?assessment_item - assessment_item ?attempt - attempt)
    :precondition
      (and
        (assessment_registered ?assessment_item)
        (assessment_reservation_confirmed ?assessment_item)
        (entity_has_attempt ?assessment_item ?attempt)
        (not
          (entity_authorized_for_assessment ?assessment_item)
        )
      )
    :effect (entity_authorized_for_assessment ?assessment_item)
  )
  (:action release_attempt_from_assessment
    :parameters (?assessment_item - assessment_item ?attempt - attempt)
    :precondition
      (and
        (entity_has_attempt ?assessment_item ?attempt)
      )
    :effect
      (and
        (attempt_available ?attempt)
        (not
          (entity_has_attempt ?assessment_item ?attempt)
        )
      )
  )
  (:action assign_grader_to_assessment
    :parameters (?assessment_item - assessment_item ?grader - grader)
    :precondition
      (and
        (entity_authorized_for_assessment ?assessment_item)
        (grader_available ?grader)
      )
    :effect
      (and
        (entity_assigned_grader ?assessment_item ?grader)
        (not
          (grader_available ?grader)
        )
      )
  )
  (:action unassign_grader_from_assessment
    :parameters (?assessment_item - assessment_item ?grader - grader)
    :precondition
      (and
        (entity_assigned_grader ?assessment_item ?grader)
      )
    :effect
      (and
        (grader_available ?grader)
        (not
          (entity_assigned_grader ?assessment_item ?grader)
        )
      )
  )
  (:action allocate_feedback_artifact_to_instructor
    :parameters (?instructor - instructor ?feedback_artifact - feedback_artifact)
    :precondition
      (and
        (entity_authorized_for_assessment ?instructor)
        (feedback_artifact_available ?feedback_artifact)
      )
    :effect
      (and
        (instructor_has_feedback_artifact ?instructor ?feedback_artifact)
        (not
          (feedback_artifact_available ?feedback_artifact)
        )
      )
  )
  (:action release_feedback_artifact_from_instructor
    :parameters (?instructor - instructor ?feedback_artifact - feedback_artifact)
    :precondition
      (and
        (instructor_has_feedback_artifact ?instructor ?feedback_artifact)
      )
    :effect
      (and
        (feedback_artifact_available ?feedback_artifact)
        (not
          (instructor_has_feedback_artifact ?instructor ?feedback_artifact)
        )
      )
  )
  (:action allocate_escalation_notice_to_instructor
    :parameters (?instructor - instructor ?escalation_notice - escalation_notice)
    :precondition
      (and
        (entity_authorized_for_assessment ?instructor)
        (escalation_notice_available ?escalation_notice)
      )
    :effect
      (and
        (instructor_escalation_notice ?instructor ?escalation_notice)
        (not
          (escalation_notice_available ?escalation_notice)
        )
      )
  )
  (:action release_escalation_notice_from_instructor
    :parameters (?instructor - instructor ?escalation_notice - escalation_notice)
    :precondition
      (and
        (instructor_escalation_notice ?instructor ?escalation_notice)
      )
    :effect
      (and
        (escalation_notice_available ?escalation_notice)
        (not
          (instructor_escalation_notice ?instructor ?escalation_notice)
        )
      )
  )
  (:action activate_assessment_window_for_learner_attempt
    :parameters (?learner - learner ?assessment_window - assessment_window ?attempt - attempt)
    :precondition
      (and
        (entity_authorized_for_assessment ?learner)
        (entity_has_attempt ?learner ?attempt)
        (learner_assigned_window ?learner ?assessment_window)
        (not
          (window_ready ?assessment_window)
        )
        (not
          (window_resources_allocated ?assessment_window)
        )
      )
    :effect (window_ready ?assessment_window)
  )
  (:action confirm_learner_readiness_with_grader
    :parameters (?learner - learner ?assessment_window - assessment_window ?grader - grader)
    :precondition
      (and
        (entity_authorized_for_assessment ?learner)
        (entity_assigned_grader ?learner ?grader)
        (learner_assigned_window ?learner ?assessment_window)
        (window_ready ?assessment_window)
        (not
          (learner_confirmed ?learner)
        )
      )
    :effect
      (and
        (learner_confirmed ?learner)
        (learner_ready ?learner)
      )
  )
  (:action assign_component_and_confirm_learner
    :parameters (?learner - learner ?assessment_window - assessment_window ?criterion_component - criterion_component)
    :precondition
      (and
        (entity_authorized_for_assessment ?learner)
        (learner_assigned_window ?learner ?assessment_window)
        (criterion_component_available ?criterion_component)
        (not
          (learner_confirmed ?learner)
        )
      )
    :effect
      (and
        (window_resources_allocated ?assessment_window)
        (learner_confirmed ?learner)
        (learner_assigned_component ?learner ?criterion_component)
        (not
          (criterion_component_available ?criterion_component)
        )
      )
  )
  (:action process_component_submission_for_learner
    :parameters (?learner - learner ?assessment_window - assessment_window ?attempt - attempt ?criterion_component - criterion_component)
    :precondition
      (and
        (entity_authorized_for_assessment ?learner)
        (entity_has_attempt ?learner ?attempt)
        (learner_assigned_window ?learner ?assessment_window)
        (window_resources_allocated ?assessment_window)
        (learner_assigned_component ?learner ?criterion_component)
        (not
          (learner_ready ?learner)
        )
      )
    :effect
      (and
        (window_ready ?assessment_window)
        (learner_ready ?learner)
        (criterion_component_available ?criterion_component)
        (not
          (learner_assigned_component ?learner ?criterion_component)
        )
      )
  )
  (:action activate_exam_session_for_group
    :parameters (?learner_group - learner_group ?exam_session - exam_session ?attempt - attempt)
    :precondition
      (and
        (entity_authorized_for_assessment ?learner_group)
        (entity_has_attempt ?learner_group ?attempt)
        (group_assigned_session ?learner_group ?exam_session)
        (not
          (session_ready ?exam_session)
        )
        (not
          (session_resources_allocated ?exam_session)
        )
      )
    :effect (session_ready ?exam_session)
  )
  (:action confirm_group_readiness_with_grader
    :parameters (?learner_group - learner_group ?exam_session - exam_session ?grader - grader)
    :precondition
      (and
        (entity_authorized_for_assessment ?learner_group)
        (entity_assigned_grader ?learner_group ?grader)
        (group_assigned_session ?learner_group ?exam_session)
        (session_ready ?exam_session)
        (not
          (group_confirmed ?learner_group)
        )
      )
    :effect
      (and
        (group_confirmed ?learner_group)
        (group_ready ?learner_group)
      )
  )
  (:action assign_component_and_confirm_group
    :parameters (?learner_group - learner_group ?exam_session - exam_session ?criterion_component - criterion_component)
    :precondition
      (and
        (entity_authorized_for_assessment ?learner_group)
        (group_assigned_session ?learner_group ?exam_session)
        (criterion_component_available ?criterion_component)
        (not
          (group_confirmed ?learner_group)
        )
      )
    :effect
      (and
        (session_resources_allocated ?exam_session)
        (group_confirmed ?learner_group)
        (group_assigned_component ?learner_group ?criterion_component)
        (not
          (criterion_component_available ?criterion_component)
        )
      )
  )
  (:action process_component_submission_for_group
    :parameters (?learner_group - learner_group ?exam_session - exam_session ?attempt - attempt ?criterion_component - criterion_component)
    :precondition
      (and
        (entity_authorized_for_assessment ?learner_group)
        (entity_has_attempt ?learner_group ?attempt)
        (group_assigned_session ?learner_group ?exam_session)
        (session_resources_allocated ?exam_session)
        (group_assigned_component ?learner_group ?criterion_component)
        (not
          (group_ready ?learner_group)
        )
      )
    :effect
      (and
        (session_ready ?exam_session)
        (group_ready ?learner_group)
        (criterion_component_available ?criterion_component)
        (not
          (group_assigned_component ?learner_group ?criterion_component)
        )
      )
  )
  (:action assemble_submission_bundle_standard
    :parameters (?learner - learner ?learner_group - learner_group ?assessment_window - assessment_window ?exam_session - exam_session ?submission_bundle - submission_bundle)
    :precondition
      (and
        (learner_confirmed ?learner)
        (group_confirmed ?learner_group)
        (learner_assigned_window ?learner ?assessment_window)
        (group_assigned_session ?learner_group ?exam_session)
        (window_ready ?assessment_window)
        (session_ready ?exam_session)
        (learner_ready ?learner)
        (group_ready ?learner_group)
        (submission_bundle_available ?submission_bundle)
      )
    :effect
      (and
        (submission_bundle_prepared ?submission_bundle)
        (bundle_mapped_window ?submission_bundle ?assessment_window)
        (bundle_assigned_session ?submission_bundle ?exam_session)
        (not
          (submission_bundle_available ?submission_bundle)
        )
      )
  )
  (:action assemble_submission_bundle_mark_for_instructor_review
    :parameters (?learner - learner ?learner_group - learner_group ?assessment_window - assessment_window ?exam_session - exam_session ?submission_bundle - submission_bundle)
    :precondition
      (and
        (learner_confirmed ?learner)
        (group_confirmed ?learner_group)
        (learner_assigned_window ?learner ?assessment_window)
        (group_assigned_session ?learner_group ?exam_session)
        (window_resources_allocated ?assessment_window)
        (session_ready ?exam_session)
        (not
          (learner_ready ?learner)
        )
        (group_ready ?learner_group)
        (submission_bundle_available ?submission_bundle)
      )
    :effect
      (and
        (submission_bundle_prepared ?submission_bundle)
        (bundle_mapped_window ?submission_bundle ?assessment_window)
        (bundle_assigned_session ?submission_bundle ?exam_session)
        (bundle_requires_instructor_review ?submission_bundle)
        (not
          (submission_bundle_available ?submission_bundle)
        )
      )
  )
  (:action assemble_submission_bundle_mark_for_additional_processing
    :parameters (?learner - learner ?learner_group - learner_group ?assessment_window - assessment_window ?exam_session - exam_session ?submission_bundle - submission_bundle)
    :precondition
      (and
        (learner_confirmed ?learner)
        (group_confirmed ?learner_group)
        (learner_assigned_window ?learner ?assessment_window)
        (group_assigned_session ?learner_group ?exam_session)
        (window_ready ?assessment_window)
        (session_resources_allocated ?exam_session)
        (learner_ready ?learner)
        (not
          (group_ready ?learner_group)
        )
        (submission_bundle_available ?submission_bundle)
      )
    :effect
      (and
        (submission_bundle_prepared ?submission_bundle)
        (bundle_mapped_window ?submission_bundle ?assessment_window)
        (bundle_assigned_session ?submission_bundle ?exam_session)
        (bundle_requires_additional_processing ?submission_bundle)
        (not
          (submission_bundle_available ?submission_bundle)
        )
      )
  )
  (:action assemble_submission_bundle_mark_for_both_reviews
    :parameters (?learner - learner ?learner_group - learner_group ?assessment_window - assessment_window ?exam_session - exam_session ?submission_bundle - submission_bundle)
    :precondition
      (and
        (learner_confirmed ?learner)
        (group_confirmed ?learner_group)
        (learner_assigned_window ?learner ?assessment_window)
        (group_assigned_session ?learner_group ?exam_session)
        (window_resources_allocated ?assessment_window)
        (session_resources_allocated ?exam_session)
        (not
          (learner_ready ?learner)
        )
        (not
          (group_ready ?learner_group)
        )
        (submission_bundle_available ?submission_bundle)
      )
    :effect
      (and
        (submission_bundle_prepared ?submission_bundle)
        (bundle_mapped_window ?submission_bundle ?assessment_window)
        (bundle_assigned_session ?submission_bundle ?exam_session)
        (bundle_requires_instructor_review ?submission_bundle)
        (bundle_requires_additional_processing ?submission_bundle)
        (not
          (submission_bundle_available ?submission_bundle)
        )
      )
  )
  (:action lock_submission_bundle_for_attachment
    :parameters (?submission_bundle - submission_bundle ?learner - learner ?attempt - attempt)
    :precondition
      (and
        (submission_bundle_prepared ?submission_bundle)
        (learner_confirmed ?learner)
        (entity_has_attempt ?learner ?attempt)
        (not
          (bundle_locked_for_attachment ?submission_bundle)
        )
      )
    :effect (bundle_locked_for_attachment ?submission_bundle)
  )
  (:action attach_supporting_material_to_bundle
    :parameters (?instructor - instructor ?supporting_material - supporting_material ?submission_bundle - submission_bundle)
    :precondition
      (and
        (entity_authorized_for_assessment ?instructor)
        (instructor_responsible_for_bundle ?instructor ?submission_bundle)
        (instructor_associated_material ?instructor ?supporting_material)
        (supporting_material_available ?supporting_material)
        (submission_bundle_prepared ?submission_bundle)
        (bundle_locked_for_attachment ?submission_bundle)
        (not
          (supporting_material_attached ?supporting_material)
        )
      )
    :effect
      (and
        (supporting_material_attached ?supporting_material)
        (material_attached_to_bundle ?supporting_material ?submission_bundle)
        (not
          (supporting_material_available ?supporting_material)
        )
      )
  )
  (:action instructor_prepare_material_for_review
    :parameters (?instructor - instructor ?supporting_material - supporting_material ?submission_bundle - submission_bundle ?attempt - attempt)
    :precondition
      (and
        (entity_authorized_for_assessment ?instructor)
        (instructor_associated_material ?instructor ?supporting_material)
        (supporting_material_attached ?supporting_material)
        (material_attached_to_bundle ?supporting_material ?submission_bundle)
        (entity_has_attempt ?instructor ?attempt)
        (not
          (bundle_requires_instructor_review ?submission_bundle)
        )
        (not
          (instructor_material_ready ?instructor)
        )
      )
    :effect (instructor_material_ready ?instructor)
  )
  (:action assign_recommendation_to_instructor
    :parameters (?instructor - instructor ?recommendation - recommendation)
    :precondition
      (and
        (entity_authorized_for_assessment ?instructor)
        (recommendation_available ?recommendation)
        (not
          (recommendation_assigned ?instructor)
        )
      )
    :effect
      (and
        (recommendation_assigned ?instructor)
        (instructor_assigned_recommendation ?instructor ?recommendation)
        (not
          (recommendation_available ?recommendation)
        )
      )
  )
  (:action instructor_initiate_review_from_bundle
    :parameters (?instructor - instructor ?supporting_material - supporting_material ?submission_bundle - submission_bundle ?attempt - attempt ?recommendation - recommendation)
    :precondition
      (and
        (entity_authorized_for_assessment ?instructor)
        (instructor_associated_material ?instructor ?supporting_material)
        (supporting_material_attached ?supporting_material)
        (material_attached_to_bundle ?supporting_material ?submission_bundle)
        (entity_has_attempt ?instructor ?attempt)
        (bundle_requires_instructor_review ?submission_bundle)
        (recommendation_assigned ?instructor)
        (instructor_assigned_recommendation ?instructor ?recommendation)
        (not
          (instructor_material_ready ?instructor)
        )
      )
    :effect
      (and
        (instructor_material_ready ?instructor)
        (instructor_review_logged ?instructor)
      )
  )
  (:action instructor_prepare_feedback_variant1
    :parameters (?instructor - instructor ?feedback_artifact - feedback_artifact ?grader - grader ?supporting_material - supporting_material ?submission_bundle - submission_bundle)
    :precondition
      (and
        (instructor_material_ready ?instructor)
        (instructor_has_feedback_artifact ?instructor ?feedback_artifact)
        (entity_assigned_grader ?instructor ?grader)
        (instructor_associated_material ?instructor ?supporting_material)
        (material_attached_to_bundle ?supporting_material ?submission_bundle)
        (not
          (bundle_requires_additional_processing ?submission_bundle)
        )
        (not
          (instructor_feedback_prepared ?instructor)
        )
      )
    :effect (instructor_feedback_prepared ?instructor)
  )
  (:action instructor_prepare_feedback_variant2
    :parameters (?instructor - instructor ?feedback_artifact - feedback_artifact ?grader - grader ?supporting_material - supporting_material ?submission_bundle - submission_bundle)
    :precondition
      (and
        (instructor_material_ready ?instructor)
        (instructor_has_feedback_artifact ?instructor ?feedback_artifact)
        (entity_assigned_grader ?instructor ?grader)
        (instructor_associated_material ?instructor ?supporting_material)
        (material_attached_to_bundle ?supporting_material ?submission_bundle)
        (bundle_requires_additional_processing ?submission_bundle)
        (not
          (instructor_feedback_prepared ?instructor)
        )
      )
    :effect (instructor_feedback_prepared ?instructor)
  )
  (:action instructor_prepare_for_signoff_escalation
    :parameters (?instructor - instructor ?escalation_notice - escalation_notice ?supporting_material - supporting_material ?submission_bundle - submission_bundle)
    :precondition
      (and
        (instructor_feedback_prepared ?instructor)
        (instructor_escalation_notice ?instructor ?escalation_notice)
        (instructor_associated_material ?instructor ?supporting_material)
        (material_attached_to_bundle ?supporting_material ?submission_bundle)
        (not
          (bundle_requires_instructor_review ?submission_bundle)
        )
        (not
          (bundle_requires_additional_processing ?submission_bundle)
        )
        (not
          (feedback_ready_for_signoff ?instructor)
        )
      )
    :effect (feedback_ready_for_signoff ?instructor)
  )
  (:action instructor_signoff_and_log_with_escalation
    :parameters (?instructor - instructor ?escalation_notice - escalation_notice ?supporting_material - supporting_material ?submission_bundle - submission_bundle)
    :precondition
      (and
        (instructor_feedback_prepared ?instructor)
        (instructor_escalation_notice ?instructor ?escalation_notice)
        (instructor_associated_material ?instructor ?supporting_material)
        (material_attached_to_bundle ?supporting_material ?submission_bundle)
        (bundle_requires_instructor_review ?submission_bundle)
        (not
          (bundle_requires_additional_processing ?submission_bundle)
        )
        (not
          (feedback_ready_for_signoff ?instructor)
        )
      )
    :effect
      (and
        (feedback_ready_for_signoff ?instructor)
        (extension_processing_required ?instructor)
      )
  )
  (:action instructor_signoff_and_approve_alternate
    :parameters (?instructor - instructor ?escalation_notice - escalation_notice ?supporting_material - supporting_material ?submission_bundle - submission_bundle)
    :precondition
      (and
        (instructor_feedback_prepared ?instructor)
        (instructor_escalation_notice ?instructor ?escalation_notice)
        (instructor_associated_material ?instructor ?supporting_material)
        (material_attached_to_bundle ?supporting_material ?submission_bundle)
        (not
          (bundle_requires_instructor_review ?submission_bundle)
        )
        (bundle_requires_additional_processing ?submission_bundle)
        (not
          (feedback_ready_for_signoff ?instructor)
        )
      )
    :effect
      (and
        (feedback_ready_for_signoff ?instructor)
        (extension_processing_required ?instructor)
      )
  )
  (:action instructor_complete_signoff_with_approvals
    :parameters (?instructor - instructor ?escalation_notice - escalation_notice ?supporting_material - supporting_material ?submission_bundle - submission_bundle)
    :precondition
      (and
        (instructor_feedback_prepared ?instructor)
        (instructor_escalation_notice ?instructor ?escalation_notice)
        (instructor_associated_material ?instructor ?supporting_material)
        (material_attached_to_bundle ?supporting_material ?submission_bundle)
        (bundle_requires_instructor_review ?submission_bundle)
        (bundle_requires_additional_processing ?submission_bundle)
        (not
          (feedback_ready_for_signoff ?instructor)
        )
      )
    :effect
      (and
        (feedback_ready_for_signoff ?instructor)
        (extension_processing_required ?instructor)
      )
  )
  (:action finalize_grade_standard
    :parameters (?instructor - instructor)
    :precondition
      (and
        (feedback_ready_for_signoff ?instructor)
        (not
          (extension_processing_required ?instructor)
        )
        (not
          (grade_signoff_recorded ?instructor)
        )
      )
    :effect
      (and
        (grade_signoff_recorded ?instructor)
        (entity_grade_finalized ?instructor)
      )
  )
  (:action apply_extension_request
    :parameters (?instructor - instructor ?extension_request - extension_request)
    :precondition
      (and
        (feedback_ready_for_signoff ?instructor)
        (extension_processing_required ?instructor)
        (extension_request_available ?extension_request)
      )
    :effect
      (and
        (instructor_assigned_extension ?instructor ?extension_request)
        (not
          (extension_request_available ?extension_request)
        )
      )
  )
  (:action perform_evaluation_and_mark_for_finalization
    :parameters (?instructor - instructor ?learner - learner ?learner_group - learner_group ?attempt - attempt ?extension_request - extension_request)
    :precondition
      (and
        (feedback_ready_for_signoff ?instructor)
        (extension_processing_required ?instructor)
        (instructor_assigned_extension ?instructor ?extension_request)
        (instructor_assigned_learner ?instructor ?learner)
        (instructor_assigned_group ?instructor ?learner_group)
        (learner_ready ?learner)
        (group_ready ?learner_group)
        (entity_has_attempt ?instructor ?attempt)
        (not
          (instructor_signoff_ready ?instructor)
        )
      )
    :effect (instructor_signoff_ready ?instructor)
  )
  (:action finalize_grade_after_review
    :parameters (?instructor - instructor)
    :precondition
      (and
        (feedback_ready_for_signoff ?instructor)
        (instructor_signoff_ready ?instructor)
        (not
          (grade_signoff_recorded ?instructor)
        )
      )
    :effect
      (and
        (grade_signoff_recorded ?instructor)
        (entity_grade_finalized ?instructor)
      )
  )
  (:action acknowledge_approval_artifact
    :parameters (?instructor - instructor ?approval_artifact - approval_artifact ?attempt - attempt)
    :precondition
      (and
        (entity_authorized_for_assessment ?instructor)
        (entity_has_attempt ?instructor ?attempt)
        (approval_artifact_available ?approval_artifact)
        (instructor_has_approval ?instructor ?approval_artifact)
        (not
          (approval_acknowledged ?instructor)
        )
      )
    :effect
      (and
        (approval_acknowledged ?instructor)
        (not
          (approval_artifact_available ?approval_artifact)
        )
      )
  )
  (:action process_approval_by_grader
    :parameters (?instructor - instructor ?grader - grader)
    :precondition
      (and
        (approval_acknowledged ?instructor)
        (entity_assigned_grader ?instructor ?grader)
        (not
          (approval_processed ?instructor)
        )
      )
    :effect (approval_processed ?instructor)
  )
  (:action record_escalation_notice_for_instructor
    :parameters (?instructor - instructor ?escalation_notice - escalation_notice)
    :precondition
      (and
        (approval_processed ?instructor)
        (instructor_escalation_notice ?instructor ?escalation_notice)
        (not
          (escalation_linked ?instructor)
        )
      )
    :effect (escalation_linked ?instructor)
  )
  (:action finalize_grade_from_approval
    :parameters (?instructor - instructor)
    :precondition
      (and
        (escalation_linked ?instructor)
        (not
          (grade_signoff_recorded ?instructor)
        )
      )
    :effect
      (and
        (grade_signoff_recorded ?instructor)
        (entity_grade_finalized ?instructor)
      )
  )
  (:action record_final_grade_for_learner
    :parameters (?learner - learner ?submission_bundle - submission_bundle)
    :precondition
      (and
        (learner_confirmed ?learner)
        (learner_ready ?learner)
        (submission_bundle_prepared ?submission_bundle)
        (bundle_locked_for_attachment ?submission_bundle)
        (not
          (entity_grade_finalized ?learner)
        )
      )
    :effect (entity_grade_finalized ?learner)
  )
  (:action record_final_grade_for_group
    :parameters (?learner_group - learner_group ?submission_bundle - submission_bundle)
    :precondition
      (and
        (group_confirmed ?learner_group)
        (group_ready ?learner_group)
        (submission_bundle_prepared ?submission_bundle)
        (bundle_locked_for_attachment ?submission_bundle)
        (not
          (entity_grade_finalized ?learner_group)
        )
      )
    :effect (entity_grade_finalized ?learner_group)
  )
  (:action request_recovery_for_assessment
    :parameters (?assessment_item - assessment_item ?recovery_token - recovery_token ?attempt - attempt)
    :precondition
      (and
        (entity_grade_finalized ?assessment_item)
        (entity_has_attempt ?assessment_item ?attempt)
        (recovery_token_available ?recovery_token)
        (not
          (entity_recovery_initiated ?assessment_item)
        )
      )
    :effect
      (and
        (entity_recovery_initiated ?assessment_item)
        (entity_recovery_token_assigned ?assessment_item ?recovery_token)
        (not
          (recovery_token_available ?recovery_token)
        )
      )
  )
  (:action consume_recovery_and_reserve_slot_for_learner
    :parameters (?learner - learner ?schedule_slot - schedule_slot ?recovery_token - recovery_token)
    :precondition
      (and
        (entity_recovery_initiated ?learner)
        (entity_assigned_slot ?learner ?schedule_slot)
        (entity_recovery_token_assigned ?learner ?recovery_token)
        (not
          (entity_outcome_recorded ?learner)
        )
      )
    :effect
      (and
        (entity_outcome_recorded ?learner)
        (slot_available ?schedule_slot)
        (recovery_token_available ?recovery_token)
      )
  )
  (:action consume_recovery_and_reserve_slot_for_group
    :parameters (?learner_group - learner_group ?schedule_slot - schedule_slot ?recovery_token - recovery_token)
    :precondition
      (and
        (entity_recovery_initiated ?learner_group)
        (entity_assigned_slot ?learner_group ?schedule_slot)
        (entity_recovery_token_assigned ?learner_group ?recovery_token)
        (not
          (entity_outcome_recorded ?learner_group)
        )
      )
    :effect
      (and
        (entity_outcome_recorded ?learner_group)
        (slot_available ?schedule_slot)
        (recovery_token_available ?recovery_token)
      )
  )
  (:action consume_recovery_and_reserve_slot_for_instructor
    :parameters (?instructor - instructor ?schedule_slot - schedule_slot ?recovery_token - recovery_token)
    :precondition
      (and
        (entity_recovery_initiated ?instructor)
        (entity_assigned_slot ?instructor ?schedule_slot)
        (entity_recovery_token_assigned ?instructor ?recovery_token)
        (not
          (entity_outcome_recorded ?instructor)
        )
      )
    :effect
      (and
        (entity_outcome_recorded ?instructor)
        (slot_available ?schedule_slot)
        (recovery_token_available ?recovery_token)
      )
  )
)

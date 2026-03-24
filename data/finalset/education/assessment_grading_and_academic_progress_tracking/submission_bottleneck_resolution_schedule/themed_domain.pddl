(define (domain submission_bottleneck_resolution_schedule)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object operational_resource_type - entity timebound_resource_type - entity role_resource_type - entity case_type - entity record - case_type grading_slot - operational_resource_type assessment_event - operational_resource_type instructor - operational_resource_type policy_template - operational_resource_type performance_metric - operational_resource_type escalation_token - operational_resource_type qa_check - operational_resource_type external_verification - operational_resource_type remediation_resource - timebound_resource_type assessment_component - timebound_resource_type accommodation_request - timebound_resource_type resolution_window - role_resource_type assessment_session - role_resource_type resolution_schedule - role_resource_type record_bucket - record record_stream - record student_profile - record_bucket cohort_profile - record_bucket course_instance - record_stream)

  (:predicates
    (record_registered ?submission_record - record)
    (record_ready ?submission_record - record)
    (record_slot_allocated ?submission_record - record)
    (outcome_propagated ?submission_record - record)
    (ready_for_finalization ?submission_record - record)
    (finalization_approved ?submission_record - record)
    (grading_slot_available ?grading_slot - grading_slot)
    (record_assigned_slot ?submission_record - record ?grading_slot - grading_slot)
    (assessment_event_available ?assessment_event - assessment_event)
    (record_linked_event ?submission_record - record ?assessment_event - assessment_event)
    (instructor_available ?instructor - instructor)
    (record_assigned_instructor ?submission_record - record ?instructor - instructor)
    (remediation_resource_available ?remediation_resource - remediation_resource)
    (student_assigned_remediation ?student_profile - student_profile ?remediation_resource - remediation_resource)
    (cohort_assigned_remediation ?cohort_profile - cohort_profile ?remediation_resource - remediation_resource)
    (student_linked_window ?student_profile - student_profile ?resolution_window - resolution_window)
    (window_marked_for_resolution ?resolution_window - resolution_window)
    (window_has_remediation_allocated ?resolution_window - resolution_window)
    (student_flagged_for_resolution ?student_profile - student_profile)
    (cohort_linked_session ?cohort_profile - cohort_profile ?assessment_session - assessment_session)
    (session_confirmed ?assessment_session - assessment_session)
    (session_has_remediation ?assessment_session - assessment_session)
    (cohort_flagged_for_resolution ?cohort_profile - cohort_profile)
    (resolution_schedule_available ?resolution_schedule - resolution_schedule)
    (resolution_schedule_confirmed ?resolution_schedule - resolution_schedule)
    (schedule_includes_window ?resolution_schedule - resolution_schedule ?resolution_window - resolution_window)
    (schedule_includes_session ?resolution_schedule - resolution_schedule ?assessment_session - assessment_session)
    (schedule_requires_policy_review ?resolution_schedule - resolution_schedule)
    (schedule_requires_additional_verification ?resolution_schedule - resolution_schedule)
    (schedule_ready_for_component_processing ?resolution_schedule - resolution_schedule)
    (course_enrolled_student ?course_instance - course_instance ?student_profile - student_profile)
    (course_has_cohort ?course_instance - course_instance ?cohort_profile - cohort_profile)
    (course_linked_schedule ?course_instance - course_instance ?resolution_schedule - resolution_schedule)
    (assessment_component_available ?assessment_component - assessment_component)
    (course_has_component ?course_instance - course_instance ?assessment_component - assessment_component)
    (component_prepared_for_schedule ?assessment_component - assessment_component)
    (component_in_schedule ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule)
    (course_component_prepared ?course_instance - course_instance)
    (course_ready_for_qa ?course_instance - course_instance)
    (course_qa_verified ?course_instance - course_instance)
    (policy_assigned_to_course ?course_instance - course_instance)
    (course_policy_applied ?course_instance - course_instance)
    (course_has_qa_checklist ?course_instance - course_instance)
    (course_ready_for_finalization ?course_instance - course_instance)
    (accommodation_request_available ?accommodation_request - accommodation_request)
    (course_has_accommodation_request ?course_instance - course_instance ?accommodation_request - accommodation_request)
    (accommodation_acknowledged ?course_instance - course_instance)
    (accommodation_processed ?course_instance - course_instance)
    (accommodation_verified ?course_instance - course_instance)
    (policy_template_available ?policy_template - policy_template)
    (course_assigned_policy_template ?course_instance - course_instance ?policy_template - policy_template)
    (performance_metric_available ?performance_metric - performance_metric)
    (course_has_performance_metric ?course_instance - course_instance ?performance_metric - performance_metric)
    (qa_check_available ?qa_check - qa_check)
    (course_assigned_qa_check ?course_instance - course_instance ?qa_check - qa_check)
    (external_verification_available ?external_verification - external_verification)
    (course_assigned_external_verification ?course_instance - course_instance ?external_verification - external_verification)
    (escalation_token_available ?escalation_token - escalation_token)
    (record_has_escalation_token ?submission_record - record ?escalation_token - escalation_token)
    (student_prepared_for_schedule ?student_profile - student_profile)
    (cohort_prepared_for_schedule ?cohort_profile - cohort_profile)
    (course_finalization_recorded ?course_instance - course_instance)
  )
  (:action register_record
    :parameters (?submission_record - record)
    :precondition
      (and
        (not
          (record_registered ?submission_record)
        )
        (not
          (outcome_propagated ?submission_record)
        )
      )
    :effect (record_registered ?submission_record)
  )
  (:action allocate_grading_slot_to_record
    :parameters (?submission_record - record ?grading_slot - grading_slot)
    :precondition
      (and
        (record_registered ?submission_record)
        (not
          (record_slot_allocated ?submission_record)
        )
        (grading_slot_available ?grading_slot)
      )
    :effect
      (and
        (record_slot_allocated ?submission_record)
        (record_assigned_slot ?submission_record ?grading_slot)
        (not
          (grading_slot_available ?grading_slot)
        )
      )
  )
  (:action schedule_record_for_assessment_event
    :parameters (?submission_record - record ?assessment_event - assessment_event)
    :precondition
      (and
        (record_registered ?submission_record)
        (record_slot_allocated ?submission_record)
        (assessment_event_available ?assessment_event)
      )
    :effect
      (and
        (record_linked_event ?submission_record ?assessment_event)
        (not
          (assessment_event_available ?assessment_event)
        )
      )
  )
  (:action mark_record_ready
    :parameters (?submission_record - record ?assessment_event - assessment_event)
    :precondition
      (and
        (record_registered ?submission_record)
        (record_slot_allocated ?submission_record)
        (record_linked_event ?submission_record ?assessment_event)
        (not
          (record_ready ?submission_record)
        )
      )
    :effect (record_ready ?submission_record)
  )
  (:action release_assessment_event_assignment
    :parameters (?submission_record - record ?assessment_event - assessment_event)
    :precondition
      (and
        (record_linked_event ?submission_record ?assessment_event)
      )
    :effect
      (and
        (assessment_event_available ?assessment_event)
        (not
          (record_linked_event ?submission_record ?assessment_event)
        )
      )
  )
  (:action assign_instructor_to_record
    :parameters (?submission_record - record ?instructor - instructor)
    :precondition
      (and
        (record_ready ?submission_record)
        (instructor_available ?instructor)
      )
    :effect
      (and
        (record_assigned_instructor ?submission_record ?instructor)
        (not
          (instructor_available ?instructor)
        )
      )
  )
  (:action release_instructor_from_record
    :parameters (?submission_record - record ?instructor - instructor)
    :precondition
      (and
        (record_assigned_instructor ?submission_record ?instructor)
      )
    :effect
      (and
        (instructor_available ?instructor)
        (not
          (record_assigned_instructor ?submission_record ?instructor)
        )
      )
  )
  (:action assign_qa_check_to_course
    :parameters (?course_instance - course_instance ?qa_check - qa_check)
    :precondition
      (and
        (record_ready ?course_instance)
        (qa_check_available ?qa_check)
      )
    :effect
      (and
        (course_assigned_qa_check ?course_instance ?qa_check)
        (not
          (qa_check_available ?qa_check)
        )
      )
  )
  (:action release_qa_check_from_course
    :parameters (?course_instance - course_instance ?qa_check - qa_check)
    :precondition
      (and
        (course_assigned_qa_check ?course_instance ?qa_check)
      )
    :effect
      (and
        (qa_check_available ?qa_check)
        (not
          (course_assigned_qa_check ?course_instance ?qa_check)
        )
      )
  )
  (:action assign_external_verification_to_course
    :parameters (?course_instance - course_instance ?external_verification - external_verification)
    :precondition
      (and
        (record_ready ?course_instance)
        (external_verification_available ?external_verification)
      )
    :effect
      (and
        (course_assigned_external_verification ?course_instance ?external_verification)
        (not
          (external_verification_available ?external_verification)
        )
      )
  )
  (:action release_external_verification_from_course
    :parameters (?course_instance - course_instance ?external_verification - external_verification)
    :precondition
      (and
        (course_assigned_external_verification ?course_instance ?external_verification)
      )
    :effect
      (and
        (external_verification_available ?external_verification)
        (not
          (course_assigned_external_verification ?course_instance ?external_verification)
        )
      )
  )
  (:action mark_resolution_window_for_student_event
    :parameters (?student_profile - student_profile ?resolution_window - resolution_window ?assessment_event - assessment_event)
    :precondition
      (and
        (record_ready ?student_profile)
        (record_linked_event ?student_profile ?assessment_event)
        (student_linked_window ?student_profile ?resolution_window)
        (not
          (window_marked_for_resolution ?resolution_window)
        )
        (not
          (window_has_remediation_allocated ?resolution_window)
        )
      )
    :effect (window_marked_for_resolution ?resolution_window)
  )
  (:action confirm_student_window_with_instructor
    :parameters (?student_profile - student_profile ?resolution_window - resolution_window ?instructor - instructor)
    :precondition
      (and
        (record_ready ?student_profile)
        (record_assigned_instructor ?student_profile ?instructor)
        (student_linked_window ?student_profile ?resolution_window)
        (window_marked_for_resolution ?resolution_window)
        (not
          (student_prepared_for_schedule ?student_profile)
        )
      )
    :effect
      (and
        (student_prepared_for_schedule ?student_profile)
        (student_flagged_for_resolution ?student_profile)
      )
  )
  (:action assign_remediation_to_student_window
    :parameters (?student_profile - student_profile ?resolution_window - resolution_window ?remediation_resource - remediation_resource)
    :precondition
      (and
        (record_ready ?student_profile)
        (student_linked_window ?student_profile ?resolution_window)
        (remediation_resource_available ?remediation_resource)
        (not
          (student_prepared_for_schedule ?student_profile)
        )
      )
    :effect
      (and
        (window_has_remediation_allocated ?resolution_window)
        (student_prepared_for_schedule ?student_profile)
        (student_assigned_remediation ?student_profile ?remediation_resource)
        (not
          (remediation_resource_available ?remediation_resource)
        )
      )
  )
  (:action apply_remediation_and_confirm_student_window
    :parameters (?student_profile - student_profile ?resolution_window - resolution_window ?assessment_event - assessment_event ?remediation_resource - remediation_resource)
    :precondition
      (and
        (record_ready ?student_profile)
        (record_linked_event ?student_profile ?assessment_event)
        (student_linked_window ?student_profile ?resolution_window)
        (window_has_remediation_allocated ?resolution_window)
        (student_assigned_remediation ?student_profile ?remediation_resource)
        (not
          (student_flagged_for_resolution ?student_profile)
        )
      )
    :effect
      (and
        (window_marked_for_resolution ?resolution_window)
        (student_flagged_for_resolution ?student_profile)
        (remediation_resource_available ?remediation_resource)
        (not
          (student_assigned_remediation ?student_profile ?remediation_resource)
        )
      )
  )
  (:action mark_assessment_session_for_cohort
    :parameters (?cohort_profile - cohort_profile ?assessment_session - assessment_session ?assessment_event - assessment_event)
    :precondition
      (and
        (record_ready ?cohort_profile)
        (record_linked_event ?cohort_profile ?assessment_event)
        (cohort_linked_session ?cohort_profile ?assessment_session)
        (not
          (session_confirmed ?assessment_session)
        )
        (not
          (session_has_remediation ?assessment_session)
        )
      )
    :effect (session_confirmed ?assessment_session)
  )
  (:action confirm_cohort_session_with_instructor
    :parameters (?cohort_profile - cohort_profile ?assessment_session - assessment_session ?instructor - instructor)
    :precondition
      (and
        (record_ready ?cohort_profile)
        (record_assigned_instructor ?cohort_profile ?instructor)
        (cohort_linked_session ?cohort_profile ?assessment_session)
        (session_confirmed ?assessment_session)
        (not
          (cohort_prepared_for_schedule ?cohort_profile)
        )
      )
    :effect
      (and
        (cohort_prepared_for_schedule ?cohort_profile)
        (cohort_flagged_for_resolution ?cohort_profile)
      )
  )
  (:action assign_cohort_remediation_to_session
    :parameters (?cohort_profile - cohort_profile ?assessment_session - assessment_session ?remediation_resource - remediation_resource)
    :precondition
      (and
        (record_ready ?cohort_profile)
        (cohort_linked_session ?cohort_profile ?assessment_session)
        (remediation_resource_available ?remediation_resource)
        (not
          (cohort_prepared_for_schedule ?cohort_profile)
        )
      )
    :effect
      (and
        (session_has_remediation ?assessment_session)
        (cohort_prepared_for_schedule ?cohort_profile)
        (cohort_assigned_remediation ?cohort_profile ?remediation_resource)
        (not
          (remediation_resource_available ?remediation_resource)
        )
      )
  )
  (:action apply_cohort_remediation_and_confirm_session
    :parameters (?cohort_profile - cohort_profile ?assessment_session - assessment_session ?assessment_event - assessment_event ?remediation_resource - remediation_resource)
    :precondition
      (and
        (record_ready ?cohort_profile)
        (record_linked_event ?cohort_profile ?assessment_event)
        (cohort_linked_session ?cohort_profile ?assessment_session)
        (session_has_remediation ?assessment_session)
        (cohort_assigned_remediation ?cohort_profile ?remediation_resource)
        (not
          (cohort_flagged_for_resolution ?cohort_profile)
        )
      )
    :effect
      (and
        (session_confirmed ?assessment_session)
        (cohort_flagged_for_resolution ?cohort_profile)
        (remediation_resource_available ?remediation_resource)
        (not
          (cohort_assigned_remediation ?cohort_profile ?remediation_resource)
        )
      )
  )
  (:action compose_resolution_schedule
    :parameters (?student_profile - student_profile ?cohort_profile - cohort_profile ?resolution_window - resolution_window ?assessment_session - assessment_session ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (student_prepared_for_schedule ?student_profile)
        (cohort_prepared_for_schedule ?cohort_profile)
        (student_linked_window ?student_profile ?resolution_window)
        (cohort_linked_session ?cohort_profile ?assessment_session)
        (window_marked_for_resolution ?resolution_window)
        (session_confirmed ?assessment_session)
        (student_flagged_for_resolution ?student_profile)
        (cohort_flagged_for_resolution ?cohort_profile)
        (resolution_schedule_available ?resolution_schedule)
      )
    :effect
      (and
        (resolution_schedule_confirmed ?resolution_schedule)
        (schedule_includes_window ?resolution_schedule ?resolution_window)
        (schedule_includes_session ?resolution_schedule ?assessment_session)
        (not
          (resolution_schedule_available ?resolution_schedule)
        )
      )
  )
  (:action compose_resolution_schedule_with_window_flag
    :parameters (?student_profile - student_profile ?cohort_profile - cohort_profile ?resolution_window - resolution_window ?assessment_session - assessment_session ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (student_prepared_for_schedule ?student_profile)
        (cohort_prepared_for_schedule ?cohort_profile)
        (student_linked_window ?student_profile ?resolution_window)
        (cohort_linked_session ?cohort_profile ?assessment_session)
        (window_has_remediation_allocated ?resolution_window)
        (session_confirmed ?assessment_session)
        (not
          (student_flagged_for_resolution ?student_profile)
        )
        (cohort_flagged_for_resolution ?cohort_profile)
        (resolution_schedule_available ?resolution_schedule)
      )
    :effect
      (and
        (resolution_schedule_confirmed ?resolution_schedule)
        (schedule_includes_window ?resolution_schedule ?resolution_window)
        (schedule_includes_session ?resolution_schedule ?assessment_session)
        (schedule_requires_policy_review ?resolution_schedule)
        (not
          (resolution_schedule_available ?resolution_schedule)
        )
      )
  )
  (:action compose_resolution_schedule_with_session_flag
    :parameters (?student_profile - student_profile ?cohort_profile - cohort_profile ?resolution_window - resolution_window ?assessment_session - assessment_session ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (student_prepared_for_schedule ?student_profile)
        (cohort_prepared_for_schedule ?cohort_profile)
        (student_linked_window ?student_profile ?resolution_window)
        (cohort_linked_session ?cohort_profile ?assessment_session)
        (window_marked_for_resolution ?resolution_window)
        (session_has_remediation ?assessment_session)
        (student_flagged_for_resolution ?student_profile)
        (not
          (cohort_flagged_for_resolution ?cohort_profile)
        )
        (resolution_schedule_available ?resolution_schedule)
      )
    :effect
      (and
        (resolution_schedule_confirmed ?resolution_schedule)
        (schedule_includes_window ?resolution_schedule ?resolution_window)
        (schedule_includes_session ?resolution_schedule ?assessment_session)
        (schedule_requires_additional_verification ?resolution_schedule)
        (not
          (resolution_schedule_available ?resolution_schedule)
        )
      )
  )
  (:action compose_resolution_schedule_with_all_flags
    :parameters (?student_profile - student_profile ?cohort_profile - cohort_profile ?resolution_window - resolution_window ?assessment_session - assessment_session ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (student_prepared_for_schedule ?student_profile)
        (cohort_prepared_for_schedule ?cohort_profile)
        (student_linked_window ?student_profile ?resolution_window)
        (cohort_linked_session ?cohort_profile ?assessment_session)
        (window_has_remediation_allocated ?resolution_window)
        (session_has_remediation ?assessment_session)
        (not
          (student_flagged_for_resolution ?student_profile)
        )
        (not
          (cohort_flagged_for_resolution ?cohort_profile)
        )
        (resolution_schedule_available ?resolution_schedule)
      )
    :effect
      (and
        (resolution_schedule_confirmed ?resolution_schedule)
        (schedule_includes_window ?resolution_schedule ?resolution_window)
        (schedule_includes_session ?resolution_schedule ?assessment_session)
        (schedule_requires_policy_review ?resolution_schedule)
        (schedule_requires_additional_verification ?resolution_schedule)
        (not
          (resolution_schedule_available ?resolution_schedule)
        )
      )
  )
  (:action flag_schedule_components_ready
    :parameters (?resolution_schedule - resolution_schedule ?student_profile - student_profile ?assessment_event - assessment_event)
    :precondition
      (and
        (resolution_schedule_confirmed ?resolution_schedule)
        (student_prepared_for_schedule ?student_profile)
        (record_linked_event ?student_profile ?assessment_event)
        (not
          (schedule_ready_for_component_processing ?resolution_schedule)
        )
      )
    :effect (schedule_ready_for_component_processing ?resolution_schedule)
  )
  (:action prepare_assessment_component_for_schedule
    :parameters (?course_instance - course_instance ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (record_ready ?course_instance)
        (course_linked_schedule ?course_instance ?resolution_schedule)
        (course_has_component ?course_instance ?assessment_component)
        (assessment_component_available ?assessment_component)
        (resolution_schedule_confirmed ?resolution_schedule)
        (schedule_ready_for_component_processing ?resolution_schedule)
        (not
          (component_prepared_for_schedule ?assessment_component)
        )
      )
    :effect
      (and
        (component_prepared_for_schedule ?assessment_component)
        (component_in_schedule ?assessment_component ?resolution_schedule)
        (not
          (assessment_component_available ?assessment_component)
        )
      )
  )
  (:action finalize_course_component_preparation
    :parameters (?course_instance - course_instance ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule ?assessment_event - assessment_event)
    :precondition
      (and
        (record_ready ?course_instance)
        (course_has_component ?course_instance ?assessment_component)
        (component_prepared_for_schedule ?assessment_component)
        (component_in_schedule ?assessment_component ?resolution_schedule)
        (record_linked_event ?course_instance ?assessment_event)
        (not
          (schedule_requires_policy_review ?resolution_schedule)
        )
        (not
          (course_component_prepared ?course_instance)
        )
      )
    :effect (course_component_prepared ?course_instance)
  )
  (:action assign_policy_template_to_course
    :parameters (?course_instance - course_instance ?policy_template - policy_template)
    :precondition
      (and
        (record_ready ?course_instance)
        (policy_template_available ?policy_template)
        (not
          (policy_assigned_to_course ?course_instance)
        )
      )
    :effect
      (and
        (policy_assigned_to_course ?course_instance)
        (course_assigned_policy_template ?course_instance ?policy_template)
        (not
          (policy_template_available ?policy_template)
        )
      )
  )
  (:action apply_policy_and_prepare_course_component
    :parameters (?course_instance - course_instance ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule ?assessment_event - assessment_event ?policy_template - policy_template)
    :precondition
      (and
        (record_ready ?course_instance)
        (course_has_component ?course_instance ?assessment_component)
        (component_prepared_for_schedule ?assessment_component)
        (component_in_schedule ?assessment_component ?resolution_schedule)
        (record_linked_event ?course_instance ?assessment_event)
        (schedule_requires_policy_review ?resolution_schedule)
        (policy_assigned_to_course ?course_instance)
        (course_assigned_policy_template ?course_instance ?policy_template)
        (not
          (course_component_prepared ?course_instance)
        )
      )
    :effect
      (and
        (course_component_prepared ?course_instance)
        (course_policy_applied ?course_instance)
      )
  )
  (:action start_qa_path_for_course
    :parameters (?course_instance - course_instance ?qa_check - qa_check ?instructor - instructor ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (course_component_prepared ?course_instance)
        (course_assigned_qa_check ?course_instance ?qa_check)
        (record_assigned_instructor ?course_instance ?instructor)
        (course_has_component ?course_instance ?assessment_component)
        (component_in_schedule ?assessment_component ?resolution_schedule)
        (not
          (schedule_requires_additional_verification ?resolution_schedule)
        )
        (not
          (course_ready_for_qa ?course_instance)
        )
      )
    :effect (course_ready_for_qa ?course_instance)
  )
  (:action start_qa_path_for_course_with_additional_verification
    :parameters (?course_instance - course_instance ?qa_check - qa_check ?instructor - instructor ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (course_component_prepared ?course_instance)
        (course_assigned_qa_check ?course_instance ?qa_check)
        (record_assigned_instructor ?course_instance ?instructor)
        (course_has_component ?course_instance ?assessment_component)
        (component_in_schedule ?assessment_component ?resolution_schedule)
        (schedule_requires_additional_verification ?resolution_schedule)
        (not
          (course_ready_for_qa ?course_instance)
        )
      )
    :effect (course_ready_for_qa ?course_instance)
  )
  (:action verify_course_via_external_verification
    :parameters (?course_instance - course_instance ?external_verification - external_verification ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (course_ready_for_qa ?course_instance)
        (course_assigned_external_verification ?course_instance ?external_verification)
        (course_has_component ?course_instance ?assessment_component)
        (component_in_schedule ?assessment_component ?resolution_schedule)
        (not
          (schedule_requires_policy_review ?resolution_schedule)
        )
        (not
          (schedule_requires_additional_verification ?resolution_schedule)
        )
        (not
          (course_qa_verified ?course_instance)
        )
      )
    :effect (course_qa_verified ?course_instance)
  )
  (:action verify_course_and_attach_qa_check_with_policy
    :parameters (?course_instance - course_instance ?external_verification - external_verification ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (course_ready_for_qa ?course_instance)
        (course_assigned_external_verification ?course_instance ?external_verification)
        (course_has_component ?course_instance ?assessment_component)
        (component_in_schedule ?assessment_component ?resolution_schedule)
        (schedule_requires_policy_review ?resolution_schedule)
        (not
          (schedule_requires_additional_verification ?resolution_schedule)
        )
        (not
          (course_qa_verified ?course_instance)
        )
      )
    :effect
      (and
        (course_qa_verified ?course_instance)
        (course_has_qa_checklist ?course_instance)
      )
  )
  (:action verify_course_and_attach_qa_check_with_session_verification
    :parameters (?course_instance - course_instance ?external_verification - external_verification ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (course_ready_for_qa ?course_instance)
        (course_assigned_external_verification ?course_instance ?external_verification)
        (course_has_component ?course_instance ?assessment_component)
        (component_in_schedule ?assessment_component ?resolution_schedule)
        (not
          (schedule_requires_policy_review ?resolution_schedule)
        )
        (schedule_requires_additional_verification ?resolution_schedule)
        (not
          (course_qa_verified ?course_instance)
        )
      )
    :effect
      (and
        (course_qa_verified ?course_instance)
        (course_has_qa_checklist ?course_instance)
      )
  )
  (:action verify_course_and_attach_qa_check_with_both_flags
    :parameters (?course_instance - course_instance ?external_verification - external_verification ?assessment_component - assessment_component ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (course_ready_for_qa ?course_instance)
        (course_assigned_external_verification ?course_instance ?external_verification)
        (course_has_component ?course_instance ?assessment_component)
        (component_in_schedule ?assessment_component ?resolution_schedule)
        (schedule_requires_policy_review ?resolution_schedule)
        (schedule_requires_additional_verification ?resolution_schedule)
        (not
          (course_qa_verified ?course_instance)
        )
      )
    :effect
      (and
        (course_qa_verified ?course_instance)
        (course_has_qa_checklist ?course_instance)
      )
  )
  (:action finalize_course_verification_without_qa_checklist
    :parameters (?course_instance - course_instance)
    :precondition
      (and
        (course_qa_verified ?course_instance)
        (not
          (course_has_qa_checklist ?course_instance)
        )
        (not
          (course_finalization_recorded ?course_instance)
        )
      )
    :effect
      (and
        (course_finalization_recorded ?course_instance)
        (ready_for_finalization ?course_instance)
      )
  )
  (:action attach_performance_metric_to_course
    :parameters (?course_instance - course_instance ?performance_metric - performance_metric)
    :precondition
      (and
        (course_qa_verified ?course_instance)
        (course_has_qa_checklist ?course_instance)
        (performance_metric_available ?performance_metric)
      )
    :effect
      (and
        (course_has_performance_metric ?course_instance ?performance_metric)
        (not
          (performance_metric_available ?performance_metric)
        )
      )
  )
  (:action execute_adjudication_and_final_checks_for_course
    :parameters (?course_instance - course_instance ?student_profile - student_profile ?cohort_profile - cohort_profile ?assessment_event - assessment_event ?performance_metric - performance_metric)
    :precondition
      (and
        (course_qa_verified ?course_instance)
        (course_has_qa_checklist ?course_instance)
        (course_has_performance_metric ?course_instance ?performance_metric)
        (course_enrolled_student ?course_instance ?student_profile)
        (course_has_cohort ?course_instance ?cohort_profile)
        (student_flagged_for_resolution ?student_profile)
        (cohort_flagged_for_resolution ?cohort_profile)
        (record_linked_event ?course_instance ?assessment_event)
        (not
          (course_ready_for_finalization ?course_instance)
        )
      )
    :effect (course_ready_for_finalization ?course_instance)
  )
  (:action finalize_course_verification
    :parameters (?course_instance - course_instance)
    :precondition
      (and
        (course_qa_verified ?course_instance)
        (course_ready_for_finalization ?course_instance)
        (not
          (course_finalization_recorded ?course_instance)
        )
      )
    :effect
      (and
        (course_finalization_recorded ?course_instance)
        (ready_for_finalization ?course_instance)
      )
  )
  (:action acknowledge_accommodation_request_for_course
    :parameters (?course_instance - course_instance ?accommodation_request - accommodation_request ?assessment_event - assessment_event)
    :precondition
      (and
        (record_ready ?course_instance)
        (record_linked_event ?course_instance ?assessment_event)
        (accommodation_request_available ?accommodation_request)
        (course_has_accommodation_request ?course_instance ?accommodation_request)
        (not
          (accommodation_acknowledged ?course_instance)
        )
      )
    :effect
      (and
        (accommodation_acknowledged ?course_instance)
        (not
          (accommodation_request_available ?accommodation_request)
        )
      )
  )
  (:action process_accommodation_with_instructor
    :parameters (?course_instance - course_instance ?instructor - instructor)
    :precondition
      (and
        (accommodation_acknowledged ?course_instance)
        (record_assigned_instructor ?course_instance ?instructor)
        (not
          (accommodation_processed ?course_instance)
        )
      )
    :effect (accommodation_processed ?course_instance)
  )
  (:action apply_external_verification_to_accommodation
    :parameters (?course_instance - course_instance ?external_verification - external_verification)
    :precondition
      (and
        (accommodation_processed ?course_instance)
        (course_assigned_external_verification ?course_instance ?external_verification)
        (not
          (accommodation_verified ?course_instance)
        )
      )
    :effect (accommodation_verified ?course_instance)
  )
  (:action finalize_accommodation_verification
    :parameters (?course_instance - course_instance)
    :precondition
      (and
        (accommodation_verified ?course_instance)
        (not
          (course_finalization_recorded ?course_instance)
        )
      )
    :effect
      (and
        (course_finalization_recorded ?course_instance)
        (ready_for_finalization ?course_instance)
      )
  )
  (:action finalize_student_profile_from_schedule
    :parameters (?student_profile - student_profile ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (student_prepared_for_schedule ?student_profile)
        (student_flagged_for_resolution ?student_profile)
        (resolution_schedule_confirmed ?resolution_schedule)
        (schedule_ready_for_component_processing ?resolution_schedule)
        (not
          (ready_for_finalization ?student_profile)
        )
      )
    :effect (ready_for_finalization ?student_profile)
  )
  (:action finalize_cohort_profile_from_schedule
    :parameters (?cohort_profile - cohort_profile ?resolution_schedule - resolution_schedule)
    :precondition
      (and
        (cohort_prepared_for_schedule ?cohort_profile)
        (cohort_flagged_for_resolution ?cohort_profile)
        (resolution_schedule_confirmed ?resolution_schedule)
        (schedule_ready_for_component_processing ?resolution_schedule)
        (not
          (ready_for_finalization ?cohort_profile)
        )
      )
    :effect (ready_for_finalization ?cohort_profile)
  )
  (:action approve_record_finalization_with_escalation_token
    :parameters (?submission_record - record ?escalation_token - escalation_token ?assessment_event - assessment_event)
    :precondition
      (and
        (ready_for_finalization ?submission_record)
        (record_linked_event ?submission_record ?assessment_event)
        (escalation_token_available ?escalation_token)
        (not
          (finalization_approved ?submission_record)
        )
      )
    :effect
      (and
        (finalization_approved ?submission_record)
        (record_has_escalation_token ?submission_record ?escalation_token)
        (not
          (escalation_token_available ?escalation_token)
        )
      )
  )
  (:action apply_finalization_and_release_resources_for_student
    :parameters (?student_profile - student_profile ?grading_slot - grading_slot ?escalation_token - escalation_token)
    :precondition
      (and
        (finalization_approved ?student_profile)
        (record_assigned_slot ?student_profile ?grading_slot)
        (record_has_escalation_token ?student_profile ?escalation_token)
        (not
          (outcome_propagated ?student_profile)
        )
      )
    :effect
      (and
        (outcome_propagated ?student_profile)
        (grading_slot_available ?grading_slot)
        (escalation_token_available ?escalation_token)
      )
  )
  (:action apply_finalization_and_release_resources_for_cohort
    :parameters (?cohort_profile - cohort_profile ?grading_slot - grading_slot ?escalation_token - escalation_token)
    :precondition
      (and
        (finalization_approved ?cohort_profile)
        (record_assigned_slot ?cohort_profile ?grading_slot)
        (record_has_escalation_token ?cohort_profile ?escalation_token)
        (not
          (outcome_propagated ?cohort_profile)
        )
      )
    :effect
      (and
        (outcome_propagated ?cohort_profile)
        (grading_slot_available ?grading_slot)
        (escalation_token_available ?escalation_token)
      )
  )
  (:action apply_finalization_and_release_resources_for_course
    :parameters (?course_instance - course_instance ?grading_slot - grading_slot ?escalation_token - escalation_token)
    :precondition
      (and
        (finalization_approved ?course_instance)
        (record_assigned_slot ?course_instance ?grading_slot)
        (record_has_escalation_token ?course_instance ?escalation_token)
        (not
          (outcome_propagated ?course_instance)
        )
      )
    :effect
      (and
        (outcome_propagated ?course_instance)
        (grading_slot_available ?grading_slot)
        (escalation_token_available ?escalation_token)
      )
  )
)

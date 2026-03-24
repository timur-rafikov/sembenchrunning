(define (domain major_requirement_sequence_design)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_type - object auxiliary_artifact - object slot_type - object curriculum_entity_type - object curriculum_component - curriculum_entity_type department_resource - resource_type course - resource_type instructional_role - resource_type specialization_option - resource_type credential_option - resource_type milestone_marker - resource_type instructor_assignment - resource_type assessment_package - resource_type elective_credit - auxiliary_artifact competency_badge - auxiliary_artifact approval_badge - auxiliary_artifact term_slot - slot_type term_slot_variant - slot_type course_instance - slot_type student_component - curriculum_component program_component - curriculum_component cohort - student_component cohort_track - student_component major_profile - program_component)
  (:predicates
    (component_initialized ?curriculum_component - curriculum_component)
    (component_validated ?curriculum_component - curriculum_component)
    (component_resource_assigned ?curriculum_component - curriculum_component)
    (component_completed ?curriculum_component - curriculum_component)
    (component_awarded ?curriculum_component - curriculum_component)
    (component_eligible_for_completion ?curriculum_component - curriculum_component)
    (resource_available ?department_resource - department_resource)
    (component_assigned_department_resource ?curriculum_component - curriculum_component ?department_resource - department_resource)
    (course_available ?course_var - course)
    (component_reserved_course ?curriculum_component - curriculum_component ?course_var - course)
    (instructional_role_available ?instructional_role - instructional_role)
    (component_assigned_instructional_role ?curriculum_component - curriculum_component ?instructional_role - instructional_role)
    (elective_credit_available ?elective_credit - elective_credit)
    (cohort_assigned_elective ?cohort - cohort ?elective_credit - elective_credit)
    (track_assigned_elective ?cohort_track - cohort_track ?elective_credit - elective_credit)
    (cohort_has_term_slot ?cohort - cohort ?term_slot - term_slot)
    (term_slot_allocated ?term_slot - term_slot)
    (term_slot_claimed ?term_slot - term_slot)
    (cohort_slot_confirmed ?cohort - cohort)
    (track_has_term_variant ?cohort_track - cohort_track ?term_slot_variant - term_slot_variant)
    (term_variant_allocated ?term_slot_variant - term_slot_variant)
    (term_variant_claimed ?term_slot_variant - term_slot_variant)
    (track_slot_confirmed ?cohort_track - cohort_track)
    (course_instance_available ?course_instance - course_instance)
    (course_instance_ready ?course_instance - course_instance)
    (course_instance_scheduled_in_term_slot ?course_instance - course_instance ?term_slot - term_slot)
    (course_instance_scheduled_in_term_variant ?course_instance - course_instance ?term_slot_variant - term_slot_variant)
    (course_instance_cohort_requirement_met ?course_instance - course_instance)
    (course_instance_track_requirement_met ?course_instance - course_instance)
    (course_instance_finalized ?course_instance - course_instance)
    (profile_linked_cohort ?major_profile - major_profile ?cohort - cohort)
    (profile_linked_track ?major_profile - major_profile ?cohort_track - cohort_track)
    (profile_includes_course_instance ?major_profile - major_profile ?course_instance - course_instance)
    (competency_available ?competency_badge - competency_badge)
    (profile_links_competency ?major_profile - major_profile ?competency_badge - competency_badge)
    (competency_validated ?competency_badge - competency_badge)
    (competency_applied_to_course_instance ?competency_badge - competency_badge ?course_instance - course_instance)
    (profile_assignment_initiated ?major_profile - major_profile)
    (profile_assignment_confirmed ?major_profile - major_profile)
    (profile_assignment_allocated ?major_profile - major_profile)
    (profile_specialization_attached ?major_profile - major_profile)
    (profile_specialization_assignment_initiated ?major_profile - major_profile)
    (profile_has_credential_slot ?major_profile - major_profile)
    (profile_final_checks_passed ?major_profile - major_profile)
    (approval_badge_available ?approval_badge - approval_badge)
    (profile_requested_approval_badge ?major_profile - major_profile ?approval_badge - approval_badge)
    (profile_approval_recorded ?major_profile - major_profile)
    (profile_approval_in_effect ?major_profile - major_profile)
    (profile_approval_validated ?major_profile - major_profile)
    (specialization_option_available ?specialization_option - specialization_option)
    (profile_has_specialization_option ?major_profile - major_profile ?specialization_option - specialization_option)
    (credential_option_available ?credential_option - credential_option)
    (profile_has_credential_option ?major_profile - major_profile ?credential_option - credential_option)
    (instructor_assignment_available ?instructor_assignment - instructor_assignment)
    (profile_has_instructor_assignment ?major_profile - major_profile ?instructor_assignment - instructor_assignment)
    (assessment_package_available ?assessment_package - assessment_package)
    (profile_has_assessment_package ?major_profile - major_profile ?assessment_package - assessment_package)
    (milestone_marker_available ?milestone_marker - milestone_marker)
    (component_assigned_milestone ?curriculum_component - curriculum_component ?milestone_marker - milestone_marker)
    (cohort_ready ?cohort - cohort)
    (track_ready ?cohort_track - cohort_track)
    (profile_finalization_recorded ?major_profile - major_profile)
  )
  (:action activate_curriculum_component
    :parameters (?curriculum_component - curriculum_component)
    :precondition
      (and
        (not
          (component_initialized ?curriculum_component)
        )
        (not
          (component_completed ?curriculum_component)
        )
      )
    :effect (component_initialized ?curriculum_component)
  )
  (:action assign_department_resource_to_component
    :parameters (?curriculum_component - curriculum_component ?department_resource - department_resource)
    :precondition
      (and
        (component_initialized ?curriculum_component)
        (not
          (component_resource_assigned ?curriculum_component)
        )
        (resource_available ?department_resource)
      )
    :effect
      (and
        (component_resource_assigned ?curriculum_component)
        (component_assigned_department_resource ?curriculum_component ?department_resource)
        (not
          (resource_available ?department_resource)
        )
      )
  )
  (:action reserve_course_for_component
    :parameters (?curriculum_component - curriculum_component ?course_var - course)
    :precondition
      (and
        (component_initialized ?curriculum_component)
        (component_resource_assigned ?curriculum_component)
        (course_available ?course_var)
      )
    :effect
      (and
        (component_reserved_course ?curriculum_component ?course_var)
        (not
          (course_available ?course_var)
        )
      )
  )
  (:action confirm_course_reservation_for_component
    :parameters (?curriculum_component - curriculum_component ?course_var - course)
    :precondition
      (and
        (component_initialized ?curriculum_component)
        (component_resource_assigned ?curriculum_component)
        (component_reserved_course ?curriculum_component ?course_var)
        (not
          (component_validated ?curriculum_component)
        )
      )
    :effect (component_validated ?curriculum_component)
  )
  (:action release_course_reservation
    :parameters (?curriculum_component - curriculum_component ?course_var - course)
    :precondition
      (and
        (component_reserved_course ?curriculum_component ?course_var)
      )
    :effect
      (and
        (course_available ?course_var)
        (not
          (component_reserved_course ?curriculum_component ?course_var)
        )
      )
  )
  (:action assign_instructional_role_to_component
    :parameters (?curriculum_component - curriculum_component ?instructional_role - instructional_role)
    :precondition
      (and
        (component_validated ?curriculum_component)
        (instructional_role_available ?instructional_role)
      )
    :effect
      (and
        (component_assigned_instructional_role ?curriculum_component ?instructional_role)
        (not
          (instructional_role_available ?instructional_role)
        )
      )
  )
  (:action release_instructional_role_from_component
    :parameters (?curriculum_component - curriculum_component ?instructional_role - instructional_role)
    :precondition
      (and
        (component_assigned_instructional_role ?curriculum_component ?instructional_role)
      )
    :effect
      (and
        (instructional_role_available ?instructional_role)
        (not
          (component_assigned_instructional_role ?curriculum_component ?instructional_role)
        )
      )
  )
  (:action assign_instructor_assignment_to_profile
    :parameters (?major_profile - major_profile ?instructor_assignment - instructor_assignment)
    :precondition
      (and
        (component_validated ?major_profile)
        (instructor_assignment_available ?instructor_assignment)
      )
    :effect
      (and
        (profile_has_instructor_assignment ?major_profile ?instructor_assignment)
        (not
          (instructor_assignment_available ?instructor_assignment)
        )
      )
  )
  (:action unassign_instructor_from_profile
    :parameters (?major_profile - major_profile ?instructor_assignment - instructor_assignment)
    :precondition
      (and
        (profile_has_instructor_assignment ?major_profile ?instructor_assignment)
      )
    :effect
      (and
        (instructor_assignment_available ?instructor_assignment)
        (not
          (profile_has_instructor_assignment ?major_profile ?instructor_assignment)
        )
      )
  )
  (:action assign_assessment_to_profile
    :parameters (?major_profile - major_profile ?assessment_package - assessment_package)
    :precondition
      (and
        (component_validated ?major_profile)
        (assessment_package_available ?assessment_package)
      )
    :effect
      (and
        (profile_has_assessment_package ?major_profile ?assessment_package)
        (not
          (assessment_package_available ?assessment_package)
        )
      )
  )
  (:action unassign_assessment_from_profile
    :parameters (?major_profile - major_profile ?assessment_package - assessment_package)
    :precondition
      (and
        (profile_has_assessment_package ?major_profile ?assessment_package)
      )
    :effect
      (and
        (assessment_package_available ?assessment_package)
        (not
          (profile_has_assessment_package ?major_profile ?assessment_package)
        )
      )
  )
  (:action allocate_term_slot
    :parameters (?cohort - cohort ?term_slot - term_slot ?course_var - course)
    :precondition
      (and
        (component_validated ?cohort)
        (component_reserved_course ?cohort ?course_var)
        (cohort_has_term_slot ?cohort ?term_slot)
        (not
          (term_slot_allocated ?term_slot)
        )
        (not
          (term_slot_claimed ?term_slot)
        )
      )
    :effect (term_slot_allocated ?term_slot)
  )
  (:action confirm_cohort_term_slot
    :parameters (?cohort - cohort ?term_slot - term_slot ?instructional_role - instructional_role)
    :precondition
      (and
        (component_validated ?cohort)
        (component_assigned_instructional_role ?cohort ?instructional_role)
        (cohort_has_term_slot ?cohort ?term_slot)
        (term_slot_allocated ?term_slot)
        (not
          (cohort_ready ?cohort)
        )
      )
    :effect
      (and
        (cohort_ready ?cohort)
        (cohort_slot_confirmed ?cohort)
      )
  )
  (:action claim_elective_for_cohort_term_slot
    :parameters (?cohort - cohort ?term_slot - term_slot ?elective_credit - elective_credit)
    :precondition
      (and
        (component_validated ?cohort)
        (cohort_has_term_slot ?cohort ?term_slot)
        (elective_credit_available ?elective_credit)
        (not
          (cohort_ready ?cohort)
        )
      )
    :effect
      (and
        (term_slot_claimed ?term_slot)
        (cohort_ready ?cohort)
        (cohort_assigned_elective ?cohort ?elective_credit)
        (not
          (elective_credit_available ?elective_credit)
        )
      )
  )
  (:action finalize_cohort_term_slot
    :parameters (?cohort - cohort ?term_slot - term_slot ?course_var - course ?elective_credit - elective_credit)
    :precondition
      (and
        (component_validated ?cohort)
        (component_reserved_course ?cohort ?course_var)
        (cohort_has_term_slot ?cohort ?term_slot)
        (term_slot_claimed ?term_slot)
        (cohort_assigned_elective ?cohort ?elective_credit)
        (not
          (cohort_slot_confirmed ?cohort)
        )
      )
    :effect
      (and
        (term_slot_allocated ?term_slot)
        (cohort_slot_confirmed ?cohort)
        (elective_credit_available ?elective_credit)
        (not
          (cohort_assigned_elective ?cohort ?elective_credit)
        )
      )
  )
  (:action allocate_term_variant
    :parameters (?cohort_track - cohort_track ?term_slot_variant - term_slot_variant ?course_var - course)
    :precondition
      (and
        (component_validated ?cohort_track)
        (component_reserved_course ?cohort_track ?course_var)
        (track_has_term_variant ?cohort_track ?term_slot_variant)
        (not
          (term_variant_allocated ?term_slot_variant)
        )
        (not
          (term_variant_claimed ?term_slot_variant)
        )
      )
    :effect (term_variant_allocated ?term_slot_variant)
  )
  (:action confirm_track_term_variant
    :parameters (?cohort_track - cohort_track ?term_slot_variant - term_slot_variant ?instructional_role - instructional_role)
    :precondition
      (and
        (component_validated ?cohort_track)
        (component_assigned_instructional_role ?cohort_track ?instructional_role)
        (track_has_term_variant ?cohort_track ?term_slot_variant)
        (term_variant_allocated ?term_slot_variant)
        (not
          (track_ready ?cohort_track)
        )
      )
    :effect
      (and
        (track_ready ?cohort_track)
        (track_slot_confirmed ?cohort_track)
      )
  )
  (:action claim_elective_for_track_variant
    :parameters (?cohort_track - cohort_track ?term_slot_variant - term_slot_variant ?elective_credit - elective_credit)
    :precondition
      (and
        (component_validated ?cohort_track)
        (track_has_term_variant ?cohort_track ?term_slot_variant)
        (elective_credit_available ?elective_credit)
        (not
          (track_ready ?cohort_track)
        )
      )
    :effect
      (and
        (term_variant_claimed ?term_slot_variant)
        (track_ready ?cohort_track)
        (track_assigned_elective ?cohort_track ?elective_credit)
        (not
          (elective_credit_available ?elective_credit)
        )
      )
  )
  (:action finalize_track_term_variant
    :parameters (?cohort_track - cohort_track ?term_slot_variant - term_slot_variant ?course_var - course ?elective_credit - elective_credit)
    :precondition
      (and
        (component_validated ?cohort_track)
        (component_reserved_course ?cohort_track ?course_var)
        (track_has_term_variant ?cohort_track ?term_slot_variant)
        (term_variant_claimed ?term_slot_variant)
        (track_assigned_elective ?cohort_track ?elective_credit)
        (not
          (track_slot_confirmed ?cohort_track)
        )
      )
    :effect
      (and
        (term_variant_allocated ?term_slot_variant)
        (track_slot_confirmed ?cohort_track)
        (elective_credit_available ?elective_credit)
        (not
          (track_assigned_elective ?cohort_track ?elective_credit)
        )
      )
  )
  (:action assemble_course_instance_package
    :parameters (?cohort - cohort ?cohort_track - cohort_track ?term_slot - term_slot ?term_slot_variant - term_slot_variant ?course_instance - course_instance)
    :precondition
      (and
        (cohort_ready ?cohort)
        (track_ready ?cohort_track)
        (cohort_has_term_slot ?cohort ?term_slot)
        (track_has_term_variant ?cohort_track ?term_slot_variant)
        (term_slot_allocated ?term_slot)
        (term_variant_allocated ?term_slot_variant)
        (cohort_slot_confirmed ?cohort)
        (track_slot_confirmed ?cohort_track)
        (course_instance_available ?course_instance)
      )
    :effect
      (and
        (course_instance_ready ?course_instance)
        (course_instance_scheduled_in_term_slot ?course_instance ?term_slot)
        (course_instance_scheduled_in_term_variant ?course_instance ?term_slot_variant)
        (not
          (course_instance_available ?course_instance)
        )
      )
  )
  (:action assemble_course_instance_with_claimed_slot
    :parameters (?cohort - cohort ?cohort_track - cohort_track ?term_slot - term_slot ?term_slot_variant - term_slot_variant ?course_instance - course_instance)
    :precondition
      (and
        (cohort_ready ?cohort)
        (track_ready ?cohort_track)
        (cohort_has_term_slot ?cohort ?term_slot)
        (track_has_term_variant ?cohort_track ?term_slot_variant)
        (term_slot_claimed ?term_slot)
        (term_variant_allocated ?term_slot_variant)
        (not
          (cohort_slot_confirmed ?cohort)
        )
        (track_slot_confirmed ?cohort_track)
        (course_instance_available ?course_instance)
      )
    :effect
      (and
        (course_instance_ready ?course_instance)
        (course_instance_scheduled_in_term_slot ?course_instance ?term_slot)
        (course_instance_scheduled_in_term_variant ?course_instance ?term_slot_variant)
        (course_instance_cohort_requirement_met ?course_instance)
        (not
          (course_instance_available ?course_instance)
        )
      )
  )
  (:action assemble_course_instance_with_track_claim
    :parameters (?cohort - cohort ?cohort_track - cohort_track ?term_slot - term_slot ?term_slot_variant - term_slot_variant ?course_instance - course_instance)
    :precondition
      (and
        (cohort_ready ?cohort)
        (track_ready ?cohort_track)
        (cohort_has_term_slot ?cohort ?term_slot)
        (track_has_term_variant ?cohort_track ?term_slot_variant)
        (term_slot_allocated ?term_slot)
        (term_variant_claimed ?term_slot_variant)
        (cohort_slot_confirmed ?cohort)
        (not
          (track_slot_confirmed ?cohort_track)
        )
        (course_instance_available ?course_instance)
      )
    :effect
      (and
        (course_instance_ready ?course_instance)
        (course_instance_scheduled_in_term_slot ?course_instance ?term_slot)
        (course_instance_scheduled_in_term_variant ?course_instance ?term_slot_variant)
        (course_instance_track_requirement_met ?course_instance)
        (not
          (course_instance_available ?course_instance)
        )
      )
  )
  (:action assemble_course_instance_with_both_claims
    :parameters (?cohort - cohort ?cohort_track - cohort_track ?term_slot - term_slot ?term_slot_variant - term_slot_variant ?course_instance - course_instance)
    :precondition
      (and
        (cohort_ready ?cohort)
        (track_ready ?cohort_track)
        (cohort_has_term_slot ?cohort ?term_slot)
        (track_has_term_variant ?cohort_track ?term_slot_variant)
        (term_slot_claimed ?term_slot)
        (term_variant_claimed ?term_slot_variant)
        (not
          (cohort_slot_confirmed ?cohort)
        )
        (not
          (track_slot_confirmed ?cohort_track)
        )
        (course_instance_available ?course_instance)
      )
    :effect
      (and
        (course_instance_ready ?course_instance)
        (course_instance_scheduled_in_term_slot ?course_instance ?term_slot)
        (course_instance_scheduled_in_term_variant ?course_instance ?term_slot_variant)
        (course_instance_cohort_requirement_met ?course_instance)
        (course_instance_track_requirement_met ?course_instance)
        (not
          (course_instance_available ?course_instance)
        )
      )
  )
  (:action finalize_course_instance
    :parameters (?course_instance - course_instance ?cohort - cohort ?course_var - course)
    :precondition
      (and
        (course_instance_ready ?course_instance)
        (cohort_ready ?cohort)
        (component_reserved_course ?cohort ?course_var)
        (not
          (course_instance_finalized ?course_instance)
        )
      )
    :effect (course_instance_finalized ?course_instance)
  )
  (:action validate_competency_for_instance
    :parameters (?major_profile - major_profile ?competency_badge - competency_badge ?course_instance - course_instance)
    :precondition
      (and
        (component_validated ?major_profile)
        (profile_includes_course_instance ?major_profile ?course_instance)
        (profile_links_competency ?major_profile ?competency_badge)
        (competency_available ?competency_badge)
        (course_instance_ready ?course_instance)
        (course_instance_finalized ?course_instance)
        (not
          (competency_validated ?competency_badge)
        )
      )
    :effect
      (and
        (competency_validated ?competency_badge)
        (competency_applied_to_course_instance ?competency_badge ?course_instance)
        (not
          (competency_available ?competency_badge)
        )
      )
  )
  (:action initiate_profile_assignment
    :parameters (?major_profile - major_profile ?competency_badge - competency_badge ?course_instance - course_instance ?course_var - course)
    :precondition
      (and
        (component_validated ?major_profile)
        (profile_links_competency ?major_profile ?competency_badge)
        (competency_validated ?competency_badge)
        (competency_applied_to_course_instance ?competency_badge ?course_instance)
        (component_reserved_course ?major_profile ?course_var)
        (not
          (course_instance_cohort_requirement_met ?course_instance)
        )
        (not
          (profile_assignment_initiated ?major_profile)
        )
      )
    :effect (profile_assignment_initiated ?major_profile)
  )
  (:action attach_specialization_to_profile
    :parameters (?major_profile - major_profile ?specialization_option - specialization_option)
    :precondition
      (and
        (component_validated ?major_profile)
        (specialization_option_available ?specialization_option)
        (not
          (profile_specialization_attached ?major_profile)
        )
      )
    :effect
      (and
        (profile_specialization_attached ?major_profile)
        (profile_has_specialization_option ?major_profile ?specialization_option)
        (not
          (specialization_option_available ?specialization_option)
        )
      )
  )
  (:action attach_specialization_and_initiate_assignment
    :parameters (?major_profile - major_profile ?competency_badge - competency_badge ?course_instance - course_instance ?course_var - course ?specialization_option - specialization_option)
    :precondition
      (and
        (component_validated ?major_profile)
        (profile_links_competency ?major_profile ?competency_badge)
        (competency_validated ?competency_badge)
        (competency_applied_to_course_instance ?competency_badge ?course_instance)
        (component_reserved_course ?major_profile ?course_var)
        (course_instance_cohort_requirement_met ?course_instance)
        (profile_specialization_attached ?major_profile)
        (profile_has_specialization_option ?major_profile ?specialization_option)
        (not
          (profile_assignment_initiated ?major_profile)
        )
      )
    :effect
      (and
        (profile_assignment_initiated ?major_profile)
        (profile_specialization_assignment_initiated ?major_profile)
      )
  )
  (:action confirm_profile_instructor_assignment_stage1
    :parameters (?major_profile - major_profile ?instructor_assignment - instructor_assignment ?instructional_role - instructional_role ?competency_badge - competency_badge ?course_instance - course_instance)
    :precondition
      (and
        (profile_assignment_initiated ?major_profile)
        (profile_has_instructor_assignment ?major_profile ?instructor_assignment)
        (component_assigned_instructional_role ?major_profile ?instructional_role)
        (profile_links_competency ?major_profile ?competency_badge)
        (competency_applied_to_course_instance ?competency_badge ?course_instance)
        (not
          (course_instance_track_requirement_met ?course_instance)
        )
        (not
          (profile_assignment_confirmed ?major_profile)
        )
      )
    :effect (profile_assignment_confirmed ?major_profile)
  )
  (:action confirm_profile_instructor_assignment_stage2
    :parameters (?major_profile - major_profile ?instructor_assignment - instructor_assignment ?instructional_role - instructional_role ?competency_badge - competency_badge ?course_instance - course_instance)
    :precondition
      (and
        (profile_assignment_initiated ?major_profile)
        (profile_has_instructor_assignment ?major_profile ?instructor_assignment)
        (component_assigned_instructional_role ?major_profile ?instructional_role)
        (profile_links_competency ?major_profile ?competency_badge)
        (competency_applied_to_course_instance ?competency_badge ?course_instance)
        (course_instance_track_requirement_met ?course_instance)
        (not
          (profile_assignment_confirmed ?major_profile)
        )
      )
    :effect (profile_assignment_confirmed ?major_profile)
  )
  (:action promote_profile_assignment_to_allocation
    :parameters (?major_profile - major_profile ?assessment_package - assessment_package ?competency_badge - competency_badge ?course_instance - course_instance)
    :precondition
      (and
        (profile_assignment_confirmed ?major_profile)
        (profile_has_assessment_package ?major_profile ?assessment_package)
        (profile_links_competency ?major_profile ?competency_badge)
        (competency_applied_to_course_instance ?competency_badge ?course_instance)
        (not
          (course_instance_cohort_requirement_met ?course_instance)
        )
        (not
          (course_instance_track_requirement_met ?course_instance)
        )
        (not
          (profile_assignment_allocated ?major_profile)
        )
      )
    :effect (profile_assignment_allocated ?major_profile)
  )
  (:action promote_profile_assignment_and_prepare_credential_slot
    :parameters (?major_profile - major_profile ?assessment_package - assessment_package ?competency_badge - competency_badge ?course_instance - course_instance)
    :precondition
      (and
        (profile_assignment_confirmed ?major_profile)
        (profile_has_assessment_package ?major_profile ?assessment_package)
        (profile_links_competency ?major_profile ?competency_badge)
        (competency_applied_to_course_instance ?competency_badge ?course_instance)
        (course_instance_cohort_requirement_met ?course_instance)
        (not
          (course_instance_track_requirement_met ?course_instance)
        )
        (not
          (profile_assignment_allocated ?major_profile)
        )
      )
    :effect
      (and
        (profile_assignment_allocated ?major_profile)
        (profile_has_credential_slot ?major_profile)
      )
  )
  (:action finalize_profile_assignment_and_open_credential_slot_variant1
    :parameters (?major_profile - major_profile ?assessment_package - assessment_package ?competency_badge - competency_badge ?course_instance - course_instance)
    :precondition
      (and
        (profile_assignment_confirmed ?major_profile)
        (profile_has_assessment_package ?major_profile ?assessment_package)
        (profile_links_competency ?major_profile ?competency_badge)
        (competency_applied_to_course_instance ?competency_badge ?course_instance)
        (not
          (course_instance_cohort_requirement_met ?course_instance)
        )
        (course_instance_track_requirement_met ?course_instance)
        (not
          (profile_assignment_allocated ?major_profile)
        )
      )
    :effect
      (and
        (profile_assignment_allocated ?major_profile)
        (profile_has_credential_slot ?major_profile)
      )
  )
  (:action finalize_profile_assignment_and_open_credential_slot_variant2
    :parameters (?major_profile - major_profile ?assessment_package - assessment_package ?competency_badge - competency_badge ?course_instance - course_instance)
    :precondition
      (and
        (profile_assignment_confirmed ?major_profile)
        (profile_has_assessment_package ?major_profile ?assessment_package)
        (profile_links_competency ?major_profile ?competency_badge)
        (competency_applied_to_course_instance ?competency_badge ?course_instance)
        (course_instance_cohort_requirement_met ?course_instance)
        (course_instance_track_requirement_met ?course_instance)
        (not
          (profile_assignment_allocated ?major_profile)
        )
      )
    :effect
      (and
        (profile_assignment_allocated ?major_profile)
        (profile_has_credential_slot ?major_profile)
      )
  )
  (:action award_profile_certificate
    :parameters (?major_profile - major_profile)
    :precondition
      (and
        (profile_assignment_allocated ?major_profile)
        (not
          (profile_has_credential_slot ?major_profile)
        )
        (not
          (profile_finalization_recorded ?major_profile)
        )
      )
    :effect
      (and
        (profile_finalization_recorded ?major_profile)
        (component_awarded ?major_profile)
      )
  )
  (:action attach_credential_option_to_profile
    :parameters (?major_profile - major_profile ?credential_option - credential_option)
    :precondition
      (and
        (profile_assignment_allocated ?major_profile)
        (profile_has_credential_slot ?major_profile)
        (credential_option_available ?credential_option)
      )
    :effect
      (and
        (profile_has_credential_option ?major_profile ?credential_option)
        (not
          (credential_option_available ?credential_option)
        )
      )
  )
  (:action perform_profile_final_checks
    :parameters (?major_profile - major_profile ?cohort - cohort ?cohort_track - cohort_track ?course_var - course ?credential_option - credential_option)
    :precondition
      (and
        (profile_assignment_allocated ?major_profile)
        (profile_has_credential_slot ?major_profile)
        (profile_has_credential_option ?major_profile ?credential_option)
        (profile_linked_cohort ?major_profile ?cohort)
        (profile_linked_track ?major_profile ?cohort_track)
        (cohort_slot_confirmed ?cohort)
        (track_slot_confirmed ?cohort_track)
        (component_reserved_course ?major_profile ?course_var)
        (not
          (profile_final_checks_passed ?major_profile)
        )
      )
    :effect (profile_final_checks_passed ?major_profile)
  )
  (:action finalize_and_award_profile
    :parameters (?major_profile - major_profile)
    :precondition
      (and
        (profile_assignment_allocated ?major_profile)
        (profile_final_checks_passed ?major_profile)
        (not
          (profile_finalization_recorded ?major_profile)
        )
      )
    :effect
      (and
        (profile_finalization_recorded ?major_profile)
        (component_awarded ?major_profile)
      )
  )
  (:action attach_approval_badge_to_profile
    :parameters (?major_profile - major_profile ?approval_badge - approval_badge ?course_var - course)
    :precondition
      (and
        (component_validated ?major_profile)
        (component_reserved_course ?major_profile ?course_var)
        (approval_badge_available ?approval_badge)
        (profile_requested_approval_badge ?major_profile ?approval_badge)
        (not
          (profile_approval_recorded ?major_profile)
        )
      )
    :effect
      (and
        (profile_approval_recorded ?major_profile)
        (not
          (approval_badge_available ?approval_badge)
        )
      )
  )
  (:action apply_profile_approval
    :parameters (?major_profile - major_profile ?instructional_role - instructional_role)
    :precondition
      (and
        (profile_approval_recorded ?major_profile)
        (component_assigned_instructional_role ?major_profile ?instructional_role)
        (not
          (profile_approval_in_effect ?major_profile)
        )
      )
    :effect (profile_approval_in_effect ?major_profile)
  )
  (:action validate_profile_approval
    :parameters (?major_profile - major_profile ?assessment_package - assessment_package)
    :precondition
      (and
        (profile_approval_in_effect ?major_profile)
        (profile_has_assessment_package ?major_profile ?assessment_package)
        (not
          (profile_approval_validated ?major_profile)
        )
      )
    :effect (profile_approval_validated ?major_profile)
  )
  (:action award_profile_certificate_after_approval
    :parameters (?major_profile - major_profile)
    :precondition
      (and
        (profile_approval_validated ?major_profile)
        (not
          (profile_finalization_recorded ?major_profile)
        )
      )
    :effect
      (and
        (profile_finalization_recorded ?major_profile)
        (component_awarded ?major_profile)
      )
  )
  (:action grant_award_to_cohort
    :parameters (?cohort - cohort ?course_instance - course_instance)
    :precondition
      (and
        (cohort_ready ?cohort)
        (cohort_slot_confirmed ?cohort)
        (course_instance_ready ?course_instance)
        (course_instance_finalized ?course_instance)
        (not
          (component_awarded ?cohort)
        )
      )
    :effect (component_awarded ?cohort)
  )
  (:action grant_award_to_track
    :parameters (?cohort_track - cohort_track ?course_instance - course_instance)
    :precondition
      (and
        (track_ready ?cohort_track)
        (track_slot_confirmed ?cohort_track)
        (course_instance_ready ?course_instance)
        (course_instance_finalized ?course_instance)
        (not
          (component_awarded ?cohort_track)
        )
      )
    :effect (component_awarded ?cohort_track)
  )
  (:action claim_milestone_for_component
    :parameters (?curriculum_component - curriculum_component ?milestone_marker - milestone_marker ?course_var - course)
    :precondition
      (and
        (component_awarded ?curriculum_component)
        (component_reserved_course ?curriculum_component ?course_var)
        (milestone_marker_available ?milestone_marker)
        (not
          (component_eligible_for_completion ?curriculum_component)
        )
      )
    :effect
      (and
        (component_eligible_for_completion ?curriculum_component)
        (component_assigned_milestone ?curriculum_component ?milestone_marker)
        (not
          (milestone_marker_available ?milestone_marker)
        )
      )
  )
  (:action complete_component_and_release_resource
    :parameters (?cohort - cohort ?department_resource - department_resource ?milestone_marker - milestone_marker)
    :precondition
      (and
        (component_eligible_for_completion ?cohort)
        (component_assigned_department_resource ?cohort ?department_resource)
        (component_assigned_milestone ?cohort ?milestone_marker)
        (not
          (component_completed ?cohort)
        )
      )
    :effect
      (and
        (component_completed ?cohort)
        (resource_available ?department_resource)
        (milestone_marker_available ?milestone_marker)
      )
  )
  (:action complete_track_and_release_resource
    :parameters (?cohort_track - cohort_track ?department_resource - department_resource ?milestone_marker - milestone_marker)
    :precondition
      (and
        (component_eligible_for_completion ?cohort_track)
        (component_assigned_department_resource ?cohort_track ?department_resource)
        (component_assigned_milestone ?cohort_track ?milestone_marker)
        (not
          (component_completed ?cohort_track)
        )
      )
    :effect
      (and
        (component_completed ?cohort_track)
        (resource_available ?department_resource)
        (milestone_marker_available ?milestone_marker)
      )
  )
  (:action complete_profile_and_release_resource
    :parameters (?major_profile - major_profile ?department_resource - department_resource ?milestone_marker - milestone_marker)
    :precondition
      (and
        (component_eligible_for_completion ?major_profile)
        (component_assigned_department_resource ?major_profile ?department_resource)
        (component_assigned_milestone ?major_profile ?milestone_marker)
        (not
          (component_completed ?major_profile)
        )
      )
    :effect
      (and
        (component_completed ?major_profile)
        (resource_available ?department_resource)
        (milestone_marker_available ?milestone_marker)
      )
  )
)

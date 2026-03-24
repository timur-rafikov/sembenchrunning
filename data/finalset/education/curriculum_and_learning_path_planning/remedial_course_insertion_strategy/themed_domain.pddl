(define (domain remediation_course_insertion_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_entity - object scheduling_entity - object institutional_element - object root_entity - object academic_entity - root_entity remediation_template - domain_entity instructional_resource - domain_entity faculty_resource - domain_entity policy_requirement - domain_entity approval_token - domain_entity remediation_justification - domain_entity resource_tag - domain_entity special_condition - domain_entity diagnostic_assessment - scheduling_entity degree_requirement - scheduling_entity placement_rule - scheduling_entity skill_gap_profile - institutional_element schedule_slot - institutional_element course_section - institutional_element learner_category - academic_entity curriculum_category - academic_entity learner - learner_category cohort - learner_category curriculum_unit - curriculum_category)
  (:predicates
    (candidate_flag ?academic_entity - academic_entity)
    (remediation_enrolled ?academic_entity - academic_entity)
    (remediation_template_assigned ?academic_entity - academic_entity)
    (insertion_complete ?academic_entity - academic_entity)
    (ready_for_finalization ?academic_entity - academic_entity)
    (remediation_complete ?academic_entity - academic_entity)
    (template_available ?remediation_template - remediation_template)
    (template_allocated ?academic_entity - academic_entity ?remediation_template - remediation_template)
    (resource_available ?instructional_resource - instructional_resource)
    (resource_assigned ?academic_entity - academic_entity ?instructional_resource - instructional_resource)
    (faculty_available ?faculty_resource - faculty_resource)
    (faculty_assigned ?academic_entity - academic_entity ?faculty_resource - faculty_resource)
    (diagnostic_available ?diagnostic_assessment - diagnostic_assessment)
    (assessment_assigned ?learner - learner ?diagnostic_assessment - diagnostic_assessment)
    (cohort_assessment_assigned ?cohort - cohort ?diagnostic_assessment - diagnostic_assessment)
    (has_skill_gap ?learner - learner ?skill_gap - skill_gap_profile)
    (skill_gap_confirmed ?skill_gap - skill_gap_profile)
    (skill_gap_pending ?skill_gap - skill_gap_profile)
    (preparation_verified ?learner - learner)
    (cohort_slot_assigned ?cohort - cohort ?schedule_slot - schedule_slot)
    (slot_confirmed ?schedule_slot - schedule_slot)
    (slot_pending ?schedule_slot - schedule_slot)
    (cohort_verified ?cohort - cohort)
    (section_provision_available ?course_section - course_section)
    (section_created ?course_section - course_section)
    (section_skill_gap_link ?course_section - course_section ?skill_gap - skill_gap_profile)
    (section_scheduled_in_slot ?course_section - course_section ?schedule_slot - schedule_slot)
    (section_prepared ?course_section - course_section)
    (section_validated ?course_section - course_section)
    (section_open_for_enrollment ?course_section - course_section)
    (unit_assigned_to_learner ?curriculum_unit - curriculum_unit ?learner - learner)
    (unit_assigned_to_cohort ?curriculum_unit - curriculum_unit ?cohort - cohort)
    (unit_offered_in_section ?curriculum_unit - curriculum_unit ?course_section - course_section)
    (requirement_unsatisfied ?degree_requirement - degree_requirement)
    (unit_requirement_link ?curriculum_unit - curriculum_unit ?degree_requirement - degree_requirement)
    (requirement_satisfied ?degree_requirement - degree_requirement)
    (requirement_section_link ?degree_requirement - degree_requirement ?course_section - course_section)
    (unit_requirement_binding_complete ?curriculum_unit - curriculum_unit)
    (unit_resources_bound ?curriculum_unit - curriculum_unit)
    (unit_finalized ?curriculum_unit - curriculum_unit)
    (unit_policy_applied ?curriculum_unit - curriculum_unit)
    (unit_policy_verified ?curriculum_unit - curriculum_unit)
    (approval_required ?curriculum_unit - curriculum_unit)
    (unit_final_check_passed ?curriculum_unit - curriculum_unit)
    (placement_rule_available ?placement_rule - placement_rule)
    (unit_placement_rule_link ?curriculum_unit - curriculum_unit ?placement_rule - placement_rule)
    (placement_rule_acknowledged ?curriculum_unit - curriculum_unit)
    (placement_rule_verified ?curriculum_unit - curriculum_unit)
    (placement_rule_finalized ?curriculum_unit - curriculum_unit)
    (policy_requirement_available ?policy_requirement - policy_requirement)
    (unit_policy_link ?curriculum_unit - curriculum_unit ?policy_requirement - policy_requirement)
    (approval_token_available ?approval_token - approval_token)
    (unit_approval_link ?curriculum_unit - curriculum_unit ?approval_token - approval_token)
    (resource_tag_available ?resource_tag - resource_tag)
    (unit_resource_tag_link ?curriculum_unit - curriculum_unit ?resource_tag - resource_tag)
    (special_condition_available ?special_condition - special_condition)
    (unit_special_condition_link ?curriculum_unit - curriculum_unit ?special_condition - special_condition)
    (justification_available ?remediation_justification - remediation_justification)
    (justification_linked_to_participant ?academic_entity - academic_entity ?remediation_justification - remediation_justification)
    (preparation_logged ?learner - learner)
    (cohort_preparation_logged ?cohort - cohort)
    (finalization_recorded ?curriculum_unit - curriculum_unit)
  )
  (:action identify_candidate
    :parameters (?academic_entity - academic_entity)
    :precondition
      (and
        (not
          (candidate_flag ?academic_entity)
        )
        (not
          (insertion_complete ?academic_entity)
        )
      )
    :effect (candidate_flag ?academic_entity)
  )
  (:action assign_remediation_template
    :parameters (?academic_entity - academic_entity ?remediation_template - remediation_template)
    :precondition
      (and
        (candidate_flag ?academic_entity)
        (not
          (remediation_template_assigned ?academic_entity)
        )
        (template_available ?remediation_template)
      )
    :effect
      (and
        (remediation_template_assigned ?academic_entity)
        (template_allocated ?academic_entity ?remediation_template)
        (not
          (template_available ?remediation_template)
        )
      )
  )
  (:action reserve_instructional_resource
    :parameters (?academic_entity - academic_entity ?instructional_resource - instructional_resource)
    :precondition
      (and
        (candidate_flag ?academic_entity)
        (remediation_template_assigned ?academic_entity)
        (resource_available ?instructional_resource)
      )
    :effect
      (and
        (resource_assigned ?academic_entity ?instructional_resource)
        (not
          (resource_available ?instructional_resource)
        )
      )
  )
  (:action confirm_resource_assignment
    :parameters (?academic_entity - academic_entity ?instructional_resource - instructional_resource)
    :precondition
      (and
        (candidate_flag ?academic_entity)
        (remediation_template_assigned ?academic_entity)
        (resource_assigned ?academic_entity ?instructional_resource)
        (not
          (remediation_enrolled ?academic_entity)
        )
      )
    :effect (remediation_enrolled ?academic_entity)
  )
  (:action release_instructional_resource
    :parameters (?academic_entity - academic_entity ?instructional_resource - instructional_resource)
    :precondition
      (and
        (resource_assigned ?academic_entity ?instructional_resource)
      )
    :effect
      (and
        (resource_available ?instructional_resource)
        (not
          (resource_assigned ?academic_entity ?instructional_resource)
        )
      )
  )
  (:action assign_faculty
    :parameters (?academic_entity - academic_entity ?faculty_resource - faculty_resource)
    :precondition
      (and
        (remediation_enrolled ?academic_entity)
        (faculty_available ?faculty_resource)
      )
    :effect
      (and
        (faculty_assigned ?academic_entity ?faculty_resource)
        (not
          (faculty_available ?faculty_resource)
        )
      )
  )
  (:action release_faculty_assignment
    :parameters (?academic_entity - academic_entity ?faculty_resource - faculty_resource)
    :precondition
      (and
        (faculty_assigned ?academic_entity ?faculty_resource)
      )
    :effect
      (and
        (faculty_available ?faculty_resource)
        (not
          (faculty_assigned ?academic_entity ?faculty_resource)
        )
      )
  )
  (:action allocate_resource_tag_to_unit
    :parameters (?curriculum_unit - curriculum_unit ?resource_tag - resource_tag)
    :precondition
      (and
        (remediation_enrolled ?curriculum_unit)
        (resource_tag_available ?resource_tag)
      )
    :effect
      (and
        (unit_resource_tag_link ?curriculum_unit ?resource_tag)
        (not
          (resource_tag_available ?resource_tag)
        )
      )
  )
  (:action release_resource_tag_from_unit
    :parameters (?curriculum_unit - curriculum_unit ?resource_tag - resource_tag)
    :precondition
      (and
        (unit_resource_tag_link ?curriculum_unit ?resource_tag)
      )
    :effect
      (and
        (resource_tag_available ?resource_tag)
        (not
          (unit_resource_tag_link ?curriculum_unit ?resource_tag)
        )
      )
  )
  (:action attach_special_condition_to_unit
    :parameters (?curriculum_unit - curriculum_unit ?special_condition - special_condition)
    :precondition
      (and
        (remediation_enrolled ?curriculum_unit)
        (special_condition_available ?special_condition)
      )
    :effect
      (and
        (unit_special_condition_link ?curriculum_unit ?special_condition)
        (not
          (special_condition_available ?special_condition)
        )
      )
  )
  (:action detach_special_condition_from_unit
    :parameters (?curriculum_unit - curriculum_unit ?special_condition - special_condition)
    :precondition
      (and
        (unit_special_condition_link ?curriculum_unit ?special_condition)
      )
    :effect
      (and
        (special_condition_available ?special_condition)
        (not
          (unit_special_condition_link ?curriculum_unit ?special_condition)
        )
      )
  )
  (:action confirm_skill_gap
    :parameters (?learner - learner ?skill_gap - skill_gap_profile ?instructional_resource - instructional_resource)
    :precondition
      (and
        (remediation_enrolled ?learner)
        (resource_assigned ?learner ?instructional_resource)
        (has_skill_gap ?learner ?skill_gap)
        (not
          (skill_gap_confirmed ?skill_gap)
        )
        (not
          (skill_gap_pending ?skill_gap)
        )
      )
    :effect (skill_gap_confirmed ?skill_gap)
  )
  (:action apply_preparatory_intervention
    :parameters (?learner - learner ?skill_gap - skill_gap_profile ?faculty_resource - faculty_resource)
    :precondition
      (and
        (remediation_enrolled ?learner)
        (faculty_assigned ?learner ?faculty_resource)
        (has_skill_gap ?learner ?skill_gap)
        (skill_gap_confirmed ?skill_gap)
        (not
          (preparation_logged ?learner)
        )
      )
    :effect
      (and
        (preparation_logged ?learner)
        (preparation_verified ?learner)
      )
  )
  (:action apply_diagnostic_assessment
    :parameters (?learner - learner ?skill_gap - skill_gap_profile ?diagnostic_assessment - diagnostic_assessment)
    :precondition
      (and
        (remediation_enrolled ?learner)
        (has_skill_gap ?learner ?skill_gap)
        (diagnostic_available ?diagnostic_assessment)
        (not
          (preparation_logged ?learner)
        )
      )
    :effect
      (and
        (skill_gap_pending ?skill_gap)
        (preparation_logged ?learner)
        (assessment_assigned ?learner ?diagnostic_assessment)
        (not
          (diagnostic_available ?diagnostic_assessment)
        )
      )
  )
  (:action finalize_diagnostic_and_preparation
    :parameters (?learner - learner ?skill_gap - skill_gap_profile ?instructional_resource - instructional_resource ?diagnostic_assessment - diagnostic_assessment)
    :precondition
      (and
        (remediation_enrolled ?learner)
        (resource_assigned ?learner ?instructional_resource)
        (has_skill_gap ?learner ?skill_gap)
        (skill_gap_pending ?skill_gap)
        (assessment_assigned ?learner ?diagnostic_assessment)
        (not
          (preparation_verified ?learner)
        )
      )
    :effect
      (and
        (skill_gap_confirmed ?skill_gap)
        (preparation_verified ?learner)
        (diagnostic_available ?diagnostic_assessment)
        (not
          (assessment_assigned ?learner ?diagnostic_assessment)
        )
      )
  )
  (:action confirm_slot_for_cohort
    :parameters (?cohort - cohort ?schedule_slot - schedule_slot ?instructional_resource - instructional_resource)
    :precondition
      (and
        (remediation_enrolled ?cohort)
        (resource_assigned ?cohort ?instructional_resource)
        (cohort_slot_assigned ?cohort ?schedule_slot)
        (not
          (slot_confirmed ?schedule_slot)
        )
        (not
          (slot_pending ?schedule_slot)
        )
      )
    :effect (slot_confirmed ?schedule_slot)
  )
  (:action assign_faculty_to_cohort_slot
    :parameters (?cohort - cohort ?schedule_slot - schedule_slot ?faculty_resource - faculty_resource)
    :precondition
      (and
        (remediation_enrolled ?cohort)
        (faculty_assigned ?cohort ?faculty_resource)
        (cohort_slot_assigned ?cohort ?schedule_slot)
        (slot_confirmed ?schedule_slot)
        (not
          (cohort_preparation_logged ?cohort)
        )
      )
    :effect
      (and
        (cohort_preparation_logged ?cohort)
        (cohort_verified ?cohort)
      )
  )
  (:action assign_diagnostic_to_cohort_slot
    :parameters (?cohort - cohort ?schedule_slot - schedule_slot ?diagnostic_assessment - diagnostic_assessment)
    :precondition
      (and
        (remediation_enrolled ?cohort)
        (cohort_slot_assigned ?cohort ?schedule_slot)
        (diagnostic_available ?diagnostic_assessment)
        (not
          (cohort_preparation_logged ?cohort)
        )
      )
    :effect
      (and
        (slot_pending ?schedule_slot)
        (cohort_preparation_logged ?cohort)
        (cohort_assessment_assigned ?cohort ?diagnostic_assessment)
        (not
          (diagnostic_available ?diagnostic_assessment)
        )
      )
  )
  (:action finalize_cohort_diagnostic_and_preparation
    :parameters (?cohort - cohort ?schedule_slot - schedule_slot ?instructional_resource - instructional_resource ?diagnostic_assessment - diagnostic_assessment)
    :precondition
      (and
        (remediation_enrolled ?cohort)
        (resource_assigned ?cohort ?instructional_resource)
        (cohort_slot_assigned ?cohort ?schedule_slot)
        (slot_pending ?schedule_slot)
        (cohort_assessment_assigned ?cohort ?diagnostic_assessment)
        (not
          (cohort_verified ?cohort)
        )
      )
    :effect
      (and
        (slot_confirmed ?schedule_slot)
        (cohort_verified ?cohort)
        (diagnostic_available ?diagnostic_assessment)
        (not
          (cohort_assessment_assigned ?cohort ?diagnostic_assessment)
        )
      )
  )
  (:action assemble_course_section_confirmed
    :parameters (?learner - learner ?cohort - cohort ?skill_gap - skill_gap_profile ?schedule_slot - schedule_slot ?course_section - course_section)
    :precondition
      (and
        (preparation_logged ?learner)
        (cohort_preparation_logged ?cohort)
        (has_skill_gap ?learner ?skill_gap)
        (cohort_slot_assigned ?cohort ?schedule_slot)
        (skill_gap_confirmed ?skill_gap)
        (slot_confirmed ?schedule_slot)
        (preparation_verified ?learner)
        (cohort_verified ?cohort)
        (section_provision_available ?course_section)
      )
    :effect
      (and
        (section_created ?course_section)
        (section_skill_gap_link ?course_section ?skill_gap)
        (section_scheduled_in_slot ?course_section ?schedule_slot)
        (not
          (section_provision_available ?course_section)
        )
      )
  )
  (:action assemble_course_section_skill_gap_pending
    :parameters (?learner - learner ?cohort - cohort ?skill_gap - skill_gap_profile ?schedule_slot - schedule_slot ?course_section - course_section)
    :precondition
      (and
        (preparation_logged ?learner)
        (cohort_preparation_logged ?cohort)
        (has_skill_gap ?learner ?skill_gap)
        (cohort_slot_assigned ?cohort ?schedule_slot)
        (skill_gap_pending ?skill_gap)
        (slot_confirmed ?schedule_slot)
        (not
          (preparation_verified ?learner)
        )
        (cohort_verified ?cohort)
        (section_provision_available ?course_section)
      )
    :effect
      (and
        (section_created ?course_section)
        (section_skill_gap_link ?course_section ?skill_gap)
        (section_scheduled_in_slot ?course_section ?schedule_slot)
        (section_prepared ?course_section)
        (not
          (section_provision_available ?course_section)
        )
      )
  )
  (:action assemble_course_section_slot_pending
    :parameters (?learner - learner ?cohort - cohort ?skill_gap - skill_gap_profile ?schedule_slot - schedule_slot ?course_section - course_section)
    :precondition
      (and
        (preparation_logged ?learner)
        (cohort_preparation_logged ?cohort)
        (has_skill_gap ?learner ?skill_gap)
        (cohort_slot_assigned ?cohort ?schedule_slot)
        (skill_gap_confirmed ?skill_gap)
        (slot_pending ?schedule_slot)
        (preparation_verified ?learner)
        (not
          (cohort_verified ?cohort)
        )
        (section_provision_available ?course_section)
      )
    :effect
      (and
        (section_created ?course_section)
        (section_skill_gap_link ?course_section ?skill_gap)
        (section_scheduled_in_slot ?course_section ?schedule_slot)
        (section_validated ?course_section)
        (not
          (section_provision_available ?course_section)
        )
      )
  )
  (:action assemble_course_section_both_pending
    :parameters (?learner - learner ?cohort - cohort ?skill_gap - skill_gap_profile ?schedule_slot - schedule_slot ?course_section - course_section)
    :precondition
      (and
        (preparation_logged ?learner)
        (cohort_preparation_logged ?cohort)
        (has_skill_gap ?learner ?skill_gap)
        (cohort_slot_assigned ?cohort ?schedule_slot)
        (skill_gap_pending ?skill_gap)
        (slot_pending ?schedule_slot)
        (not
          (preparation_verified ?learner)
        )
        (not
          (cohort_verified ?cohort)
        )
        (section_provision_available ?course_section)
      )
    :effect
      (and
        (section_created ?course_section)
        (section_skill_gap_link ?course_section ?skill_gap)
        (section_scheduled_in_slot ?course_section ?schedule_slot)
        (section_prepared ?course_section)
        (section_validated ?course_section)
        (not
          (section_provision_available ?course_section)
        )
      )
  )
  (:action open_section_for_enrollment
    :parameters (?course_section - course_section ?learner - learner ?instructional_resource - instructional_resource)
    :precondition
      (and
        (section_created ?course_section)
        (preparation_logged ?learner)
        (resource_assigned ?learner ?instructional_resource)
        (not
          (section_open_for_enrollment ?course_section)
        )
      )
    :effect (section_open_for_enrollment ?course_section)
  )
  (:action bind_unit_to_requirement_and_section
    :parameters (?curriculum_unit - curriculum_unit ?degree_requirement - degree_requirement ?course_section - course_section)
    :precondition
      (and
        (remediation_enrolled ?curriculum_unit)
        (unit_offered_in_section ?curriculum_unit ?course_section)
        (unit_requirement_link ?curriculum_unit ?degree_requirement)
        (requirement_unsatisfied ?degree_requirement)
        (section_created ?course_section)
        (section_open_for_enrollment ?course_section)
        (not
          (requirement_satisfied ?degree_requirement)
        )
      )
    :effect
      (and
        (requirement_satisfied ?degree_requirement)
        (requirement_section_link ?degree_requirement ?course_section)
        (not
          (requirement_unsatisfied ?degree_requirement)
        )
      )
  )
  (:action finalize_unit_requirement_binding
    :parameters (?curriculum_unit - curriculum_unit ?degree_requirement - degree_requirement ?course_section - course_section ?instructional_resource - instructional_resource)
    :precondition
      (and
        (remediation_enrolled ?curriculum_unit)
        (unit_requirement_link ?curriculum_unit ?degree_requirement)
        (requirement_satisfied ?degree_requirement)
        (requirement_section_link ?degree_requirement ?course_section)
        (resource_assigned ?curriculum_unit ?instructional_resource)
        (not
          (section_prepared ?course_section)
        )
        (not
          (unit_requirement_binding_complete ?curriculum_unit)
        )
      )
    :effect (unit_requirement_binding_complete ?curriculum_unit)
  )
  (:action apply_policy_requirement_to_unit
    :parameters (?curriculum_unit - curriculum_unit ?policy_requirement - policy_requirement)
    :precondition
      (and
        (remediation_enrolled ?curriculum_unit)
        (policy_requirement_available ?policy_requirement)
        (not
          (unit_policy_applied ?curriculum_unit)
        )
      )
    :effect
      (and
        (unit_policy_applied ?curriculum_unit)
        (unit_policy_link ?curriculum_unit ?policy_requirement)
        (not
          (policy_requirement_available ?policy_requirement)
        )
      )
  )
  (:action apply_policy_and_finalize_unit_binding
    :parameters (?curriculum_unit - curriculum_unit ?degree_requirement - degree_requirement ?course_section - course_section ?instructional_resource - instructional_resource ?policy_requirement - policy_requirement)
    :precondition
      (and
        (remediation_enrolled ?curriculum_unit)
        (unit_requirement_link ?curriculum_unit ?degree_requirement)
        (requirement_satisfied ?degree_requirement)
        (requirement_section_link ?degree_requirement ?course_section)
        (resource_assigned ?curriculum_unit ?instructional_resource)
        (section_prepared ?course_section)
        (unit_policy_applied ?curriculum_unit)
        (unit_policy_link ?curriculum_unit ?policy_requirement)
        (not
          (unit_requirement_binding_complete ?curriculum_unit)
        )
      )
    :effect
      (and
        (unit_requirement_binding_complete ?curriculum_unit)
        (unit_policy_verified ?curriculum_unit)
      )
  )
  (:action assign_resources_and_mark_unit
    :parameters (?curriculum_unit - curriculum_unit ?resource_tag - resource_tag ?faculty_resource - faculty_resource ?degree_requirement - degree_requirement ?course_section - course_section)
    :precondition
      (and
        (unit_requirement_binding_complete ?curriculum_unit)
        (unit_resource_tag_link ?curriculum_unit ?resource_tag)
        (faculty_assigned ?curriculum_unit ?faculty_resource)
        (unit_requirement_link ?curriculum_unit ?degree_requirement)
        (requirement_section_link ?degree_requirement ?course_section)
        (not
          (section_validated ?course_section)
        )
        (not
          (unit_resources_bound ?curriculum_unit)
        )
      )
    :effect (unit_resources_bound ?curriculum_unit)
  )
  (:action assign_resources_with_alternate_slot
    :parameters (?curriculum_unit - curriculum_unit ?resource_tag - resource_tag ?faculty_resource - faculty_resource ?degree_requirement - degree_requirement ?course_section - course_section)
    :precondition
      (and
        (unit_requirement_binding_complete ?curriculum_unit)
        (unit_resource_tag_link ?curriculum_unit ?resource_tag)
        (faculty_assigned ?curriculum_unit ?faculty_resource)
        (unit_requirement_link ?curriculum_unit ?degree_requirement)
        (requirement_section_link ?degree_requirement ?course_section)
        (section_validated ?course_section)
        (not
          (unit_resources_bound ?curriculum_unit)
        )
      )
    :effect (unit_resources_bound ?curriculum_unit)
  )
  (:action consolidate_unit_without_section_flags
    :parameters (?curriculum_unit - curriculum_unit ?special_condition - special_condition ?degree_requirement - degree_requirement ?course_section - course_section)
    :precondition
      (and
        (unit_resources_bound ?curriculum_unit)
        (unit_special_condition_link ?curriculum_unit ?special_condition)
        (unit_requirement_link ?curriculum_unit ?degree_requirement)
        (requirement_section_link ?degree_requirement ?course_section)
        (not
          (section_prepared ?course_section)
        )
        (not
          (section_validated ?course_section)
        )
        (not
          (unit_finalized ?curriculum_unit)
        )
      )
    :effect (unit_finalized ?curriculum_unit)
  )
  (:action consolidate_unit_with_prepared_section
    :parameters (?curriculum_unit - curriculum_unit ?special_condition - special_condition ?degree_requirement - degree_requirement ?course_section - course_section)
    :precondition
      (and
        (unit_resources_bound ?curriculum_unit)
        (unit_special_condition_link ?curriculum_unit ?special_condition)
        (unit_requirement_link ?curriculum_unit ?degree_requirement)
        (requirement_section_link ?degree_requirement ?course_section)
        (section_prepared ?course_section)
        (not
          (section_validated ?course_section)
        )
        (not
          (unit_finalized ?curriculum_unit)
        )
      )
    :effect
      (and
        (unit_finalized ?curriculum_unit)
        (approval_required ?curriculum_unit)
      )
  )
  (:action consolidate_unit_with_validated_section
    :parameters (?curriculum_unit - curriculum_unit ?special_condition - special_condition ?degree_requirement - degree_requirement ?course_section - course_section)
    :precondition
      (and
        (unit_resources_bound ?curriculum_unit)
        (unit_special_condition_link ?curriculum_unit ?special_condition)
        (unit_requirement_link ?curriculum_unit ?degree_requirement)
        (requirement_section_link ?degree_requirement ?course_section)
        (not
          (section_prepared ?course_section)
        )
        (section_validated ?course_section)
        (not
          (unit_finalized ?curriculum_unit)
        )
      )
    :effect
      (and
        (unit_finalized ?curriculum_unit)
        (approval_required ?curriculum_unit)
      )
  )
  (:action consolidate_unit_with_prepared_and_validated_section
    :parameters (?curriculum_unit - curriculum_unit ?special_condition - special_condition ?degree_requirement - degree_requirement ?course_section - course_section)
    :precondition
      (and
        (unit_resources_bound ?curriculum_unit)
        (unit_special_condition_link ?curriculum_unit ?special_condition)
        (unit_requirement_link ?curriculum_unit ?degree_requirement)
        (requirement_section_link ?degree_requirement ?course_section)
        (section_prepared ?course_section)
        (section_validated ?course_section)
        (not
          (unit_finalized ?curriculum_unit)
        )
      )
    :effect
      (and
        (unit_finalized ?curriculum_unit)
        (approval_required ?curriculum_unit)
      )
  )
  (:action certify_unit_readiness
    :parameters (?curriculum_unit - curriculum_unit)
    :precondition
      (and
        (unit_finalized ?curriculum_unit)
        (not
          (approval_required ?curriculum_unit)
        )
        (not
          (finalization_recorded ?curriculum_unit)
        )
      )
    :effect
      (and
        (finalization_recorded ?curriculum_unit)
        (ready_for_finalization ?curriculum_unit)
      )
  )
  (:action apply_approval_token_to_unit
    :parameters (?curriculum_unit - curriculum_unit ?approval_token - approval_token)
    :precondition
      (and
        (unit_finalized ?curriculum_unit)
        (approval_required ?curriculum_unit)
        (approval_token_available ?approval_token)
      )
    :effect
      (and
        (unit_approval_link ?curriculum_unit ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action perform_unit_final_checks
    :parameters (?curriculum_unit - curriculum_unit ?learner - learner ?cohort - cohort ?instructional_resource - instructional_resource ?approval_token - approval_token)
    :precondition
      (and
        (unit_finalized ?curriculum_unit)
        (approval_required ?curriculum_unit)
        (unit_approval_link ?curriculum_unit ?approval_token)
        (unit_assigned_to_learner ?curriculum_unit ?learner)
        (unit_assigned_to_cohort ?curriculum_unit ?cohort)
        (preparation_verified ?learner)
        (cohort_verified ?cohort)
        (resource_assigned ?curriculum_unit ?instructional_resource)
        (not
          (unit_final_check_passed ?curriculum_unit)
        )
      )
    :effect (unit_final_check_passed ?curriculum_unit)
  )
  (:action certify_unit_after_verification
    :parameters (?curriculum_unit - curriculum_unit)
    :precondition
      (and
        (unit_finalized ?curriculum_unit)
        (unit_final_check_passed ?curriculum_unit)
        (not
          (finalization_recorded ?curriculum_unit)
        )
      )
    :effect
      (and
        (finalization_recorded ?curriculum_unit)
        (ready_for_finalization ?curriculum_unit)
      )
  )
  (:action acknowledge_placement_rule_for_unit
    :parameters (?curriculum_unit - curriculum_unit ?placement_rule - placement_rule ?instructional_resource - instructional_resource)
    :precondition
      (and
        (remediation_enrolled ?curriculum_unit)
        (resource_assigned ?curriculum_unit ?instructional_resource)
        (placement_rule_available ?placement_rule)
        (unit_placement_rule_link ?curriculum_unit ?placement_rule)
        (not
          (placement_rule_acknowledged ?curriculum_unit)
        )
      )
    :effect
      (and
        (placement_rule_acknowledged ?curriculum_unit)
        (not
          (placement_rule_available ?placement_rule)
        )
      )
  )
  (:action verify_placement_with_faculty
    :parameters (?curriculum_unit - curriculum_unit ?faculty_resource - faculty_resource)
    :precondition
      (and
        (placement_rule_acknowledged ?curriculum_unit)
        (faculty_assigned ?curriculum_unit ?faculty_resource)
        (not
          (placement_rule_verified ?curriculum_unit)
        )
      )
    :effect (placement_rule_verified ?curriculum_unit)
  )
  (:action finalize_placement_condition
    :parameters (?curriculum_unit - curriculum_unit ?special_condition - special_condition)
    :precondition
      (and
        (placement_rule_verified ?curriculum_unit)
        (unit_special_condition_link ?curriculum_unit ?special_condition)
        (not
          (placement_rule_finalized ?curriculum_unit)
        )
      )
    :effect (placement_rule_finalized ?curriculum_unit)
  )
  (:action certify_unit_after_placement
    :parameters (?curriculum_unit - curriculum_unit)
    :precondition
      (and
        (placement_rule_finalized ?curriculum_unit)
        (not
          (finalization_recorded ?curriculum_unit)
        )
      )
    :effect
      (and
        (finalization_recorded ?curriculum_unit)
        (ready_for_finalization ?curriculum_unit)
      )
  )
  (:action certify_learner_ready
    :parameters (?learner - learner ?course_section - course_section)
    :precondition
      (and
        (preparation_logged ?learner)
        (preparation_verified ?learner)
        (section_created ?course_section)
        (section_open_for_enrollment ?course_section)
        (not
          (ready_for_finalization ?learner)
        )
      )
    :effect (ready_for_finalization ?learner)
  )
  (:action certify_cohort_ready
    :parameters (?cohort - cohort ?course_section - course_section)
    :precondition
      (and
        (cohort_preparation_logged ?cohort)
        (cohort_verified ?cohort)
        (section_created ?course_section)
        (section_open_for_enrollment ?course_section)
        (not
          (ready_for_finalization ?cohort)
        )
      )
    :effect (ready_for_finalization ?cohort)
  )
  (:action record_remediation_completion
    :parameters (?academic_entity - academic_entity ?remediation_justification - remediation_justification ?instructional_resource - instructional_resource)
    :precondition
      (and
        (ready_for_finalization ?academic_entity)
        (resource_assigned ?academic_entity ?instructional_resource)
        (justification_available ?remediation_justification)
        (not
          (remediation_complete ?academic_entity)
        )
      )
    :effect
      (and
        (remediation_complete ?academic_entity)
        (justification_linked_to_participant ?academic_entity ?remediation_justification)
        (not
          (justification_available ?remediation_justification)
        )
      )
  )
  (:action materialize_remediation_insertion_for_learner
    :parameters (?learner - learner ?remediation_template - remediation_template ?remediation_justification - remediation_justification)
    :precondition
      (and
        (remediation_complete ?learner)
        (template_allocated ?learner ?remediation_template)
        (justification_linked_to_participant ?learner ?remediation_justification)
        (not
          (insertion_complete ?learner)
        )
      )
    :effect
      (and
        (insertion_complete ?learner)
        (template_available ?remediation_template)
        (justification_available ?remediation_justification)
      )
  )
  (:action materialize_remediation_insertion_for_cohort
    :parameters (?cohort - cohort ?remediation_template - remediation_template ?remediation_justification - remediation_justification)
    :precondition
      (and
        (remediation_complete ?cohort)
        (template_allocated ?cohort ?remediation_template)
        (justification_linked_to_participant ?cohort ?remediation_justification)
        (not
          (insertion_complete ?cohort)
        )
      )
    :effect
      (and
        (insertion_complete ?cohort)
        (template_available ?remediation_template)
        (justification_available ?remediation_justification)
      )
  )
  (:action materialize_remediation_insertion_for_unit
    :parameters (?curriculum_unit - curriculum_unit ?remediation_template - remediation_template ?remediation_justification - remediation_justification)
    :precondition
      (and
        (remediation_complete ?curriculum_unit)
        (template_allocated ?curriculum_unit ?remediation_template)
        (justification_linked_to_participant ?curriculum_unit ?remediation_justification)
        (not
          (insertion_complete ?curriculum_unit)
        )
      )
    :effect
      (and
        (insertion_complete ?curriculum_unit)
        (template_available ?remediation_template)
        (justification_available ?remediation_justification)
      )
  )
)

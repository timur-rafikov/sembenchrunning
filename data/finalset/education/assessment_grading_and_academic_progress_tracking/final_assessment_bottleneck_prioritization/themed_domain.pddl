(define (domain final_assessment_bottleneck_prioritization_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object entity_grouping - entity resource_grouping - entity tag_grouping - entity root_group - entity assessment_entity - root_group assessment_slot - entity_grouping assessment_activity - entity_grouping staff_member - entity_grouping escalation_flag - entity_grouping policy_intervention - entity_grouping evidence_document - entity_grouping grading_tool - entity_grouping academic_action - entity_grouping support_resource - resource_grouping milestone_checkpoint - resource_grouping exception_reason - resource_grouping bottleneck_category - tag_grouping priority_tag - tag_grouping assessment_batch - tag_grouping student_category - assessment_entity offering_category - assessment_entity student_undergraduate - student_category student_graduate - student_category course_offering - offering_category)

  (:predicates
    (registered_for_assessment ?assessment_entity - assessment_entity)
    (awaiting_grading ?assessment_entity - assessment_entity)
    (slot_assigned ?assessment_entity - assessment_entity)
    (assessment_process_finalized ?assessment_entity - assessment_entity)
    (academic_record_committed ?assessment_entity - assessment_entity)
    (academic_update_committed ?assessment_entity - assessment_entity)
    (slot_available ?assessment_slot - assessment_slot)
    (allocated_slot ?assessment_entity - assessment_entity ?assessment_slot - assessment_slot)
    (activity_available ?assessment_activity - assessment_activity)
    (activity_assigned ?assessment_entity - assessment_entity ?assessment_activity - assessment_activity)
    (staff_available ?staff_member - staff_member)
    (assigned_grader ?assessment_entity - assessment_entity ?staff_member - staff_member)
    (support_resource_available ?support_resource - support_resource)
    (undergraduate_allocated_resource ?student_undergraduate - student_undergraduate ?support_resource - support_resource)
    (graduate_allocated_resource ?student_graduate - student_graduate ?support_resource - support_resource)
    (student_bottleneck_tag ?student_undergraduate - student_undergraduate ?bottleneck_category - bottleneck_category)
    (bottleneck_prioritized ?bottleneck_category - bottleneck_category)
    (bottleneck_tagged ?bottleneck_category - bottleneck_category)
    (student_prioritized ?student_undergraduate - student_undergraduate)
    (graduate_priority_assigned ?student_graduate - student_graduate ?priority_tag - priority_tag)
    (priority_tag_activated ?priority_tag - priority_tag)
    (priority_tag_queued ?priority_tag - priority_tag)
    (graduate_prioritized ?student_graduate - student_graduate)
    (batch_pending ?assessment_batch - assessment_batch)
    (batch_confirmed ?assessment_batch - assessment_batch)
    (batch_bottleneck_link ?assessment_batch - assessment_batch ?bottleneck_category - bottleneck_category)
    (batch_priority_link ?assessment_batch - assessment_batch ?priority_tag - priority_tag)
    (batch_requires_escalation ?assessment_batch - assessment_batch)
    (batch_requires_intervention ?assessment_batch - assessment_batch)
    (batch_executed ?assessment_batch - assessment_batch)
    (offering_enrolled_undergraduate ?course_offering - course_offering ?student_undergraduate - student_undergraduate)
    (offering_enrolled_graduate ?course_offering - course_offering ?student_graduate - student_graduate)
    (offering_associated_batch ?course_offering - course_offering ?assessment_batch - assessment_batch)
    (checkpoint_available ?milestone_checkpoint - milestone_checkpoint)
    (offering_has_checkpoint ?course_offering - course_offering ?milestone_checkpoint - milestone_checkpoint)
    (checkpoint_verified ?milestone_checkpoint - milestone_checkpoint)
    (checkpoint_assigned_batch ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch)
    (offering_milestone_ready ?course_offering - course_offering)
    (offering_grading_tool_confirmed ?course_offering - course_offering)
    (eligibility_confirmed ?course_offering - course_offering)
    (escalation_flagged ?course_offering - course_offering)
    (escalation_acknowledged ?course_offering - course_offering)
    (intervention_applied ?course_offering - course_offering)
    (milestone_verified ?course_offering - course_offering)
    (exception_available ?exception_reason - exception_reason)
    (offering_has_exception ?course_offering - course_offering ?exception_reason - exception_reason)
    (exception_approved ?course_offering - course_offering)
    (exception_assigned ?course_offering - course_offering)
    (exception_actioned ?course_offering - course_offering)
    (escalation_flag_available ?escalation_flag - escalation_flag)
    (offering_escalation_flagged ?course_offering - course_offering ?escalation_flag - escalation_flag)
    (policy_intervention_available ?policy_intervention - policy_intervention)
    (offering_intervention_applied ?course_offering - course_offering ?policy_intervention - policy_intervention)
    (grading_tool_available ?grading_tool - grading_tool)
    (offering_grading_tool_assigned ?course_offering - course_offering ?grading_tool - grading_tool)
    (academic_action_available ?academic_action - academic_action)
    (offering_academic_action_assigned ?course_offering - course_offering ?academic_action - academic_action)
    (evidence_document_available ?evidence_document - evidence_document)
    (student_evidence_document ?assessment_entity - assessment_entity ?evidence_document - evidence_document)
    (undergraduate_batch_ready ?student_undergraduate - student_undergraduate)
    (graduate_batch_ready ?student_graduate - student_graduate)
    (offering_completion_recorded ?course_offering - course_offering)
  )
  (:action register_assessment_entity
    :parameters (?assessment_entity - assessment_entity)
    :precondition
      (and
        (not
          (registered_for_assessment ?assessment_entity)
        )
        (not
          (assessment_process_finalized ?assessment_entity)
        )
      )
    :effect (registered_for_assessment ?assessment_entity)
  )
  (:action assign_assessment_slot
    :parameters (?assessment_entity - assessment_entity ?assessment_slot - assessment_slot)
    :precondition
      (and
        (registered_for_assessment ?assessment_entity)
        (not
          (slot_assigned ?assessment_entity)
        )
        (slot_available ?assessment_slot)
      )
    :effect
      (and
        (slot_assigned ?assessment_entity)
        (allocated_slot ?assessment_entity ?assessment_slot)
        (not
          (slot_available ?assessment_slot)
        )
      )
  )
  (:action book_assessment_activity
    :parameters (?assessment_entity - assessment_entity ?assessment_activity - assessment_activity)
    :precondition
      (and
        (registered_for_assessment ?assessment_entity)
        (slot_assigned ?assessment_entity)
        (activity_available ?assessment_activity)
      )
    :effect
      (and
        (activity_assigned ?assessment_entity ?assessment_activity)
        (not
          (activity_available ?assessment_activity)
        )
      )
  )
  (:action mark_entity_ready_for_grading
    :parameters (?assessment_entity - assessment_entity ?assessment_activity - assessment_activity)
    :precondition
      (and
        (registered_for_assessment ?assessment_entity)
        (slot_assigned ?assessment_entity)
        (activity_assigned ?assessment_entity ?assessment_activity)
        (not
          (awaiting_grading ?assessment_entity)
        )
      )
    :effect (awaiting_grading ?assessment_entity)
  )
  (:action release_assessment_activity
    :parameters (?assessment_entity - assessment_entity ?assessment_activity - assessment_activity)
    :precondition
      (and
        (activity_assigned ?assessment_entity ?assessment_activity)
      )
    :effect
      (and
        (activity_available ?assessment_activity)
        (not
          (activity_assigned ?assessment_entity ?assessment_activity)
        )
      )
  )
  (:action assign_staff_to_assessment_entity
    :parameters (?assessment_entity - assessment_entity ?staff_member - staff_member)
    :precondition
      (and
        (awaiting_grading ?assessment_entity)
        (staff_available ?staff_member)
      )
    :effect
      (and
        (assigned_grader ?assessment_entity ?staff_member)
        (not
          (staff_available ?staff_member)
        )
      )
  )
  (:action release_staff_assignment
    :parameters (?assessment_entity - assessment_entity ?staff_member - staff_member)
    :precondition
      (and
        (assigned_grader ?assessment_entity ?staff_member)
      )
    :effect
      (and
        (staff_available ?staff_member)
        (not
          (assigned_grader ?assessment_entity ?staff_member)
        )
      )
  )
  (:action assign_grading_tool_to_offering
    :parameters (?course_offering - course_offering ?grading_tool - grading_tool)
    :precondition
      (and
        (awaiting_grading ?course_offering)
        (grading_tool_available ?grading_tool)
      )
    :effect
      (and
        (offering_grading_tool_assigned ?course_offering ?grading_tool)
        (not
          (grading_tool_available ?grading_tool)
        )
      )
  )
  (:action release_grading_tool_from_offering
    :parameters (?course_offering - course_offering ?grading_tool - grading_tool)
    :precondition
      (and
        (offering_grading_tool_assigned ?course_offering ?grading_tool)
      )
    :effect
      (and
        (grading_tool_available ?grading_tool)
        (not
          (offering_grading_tool_assigned ?course_offering ?grading_tool)
        )
      )
  )
  (:action assign_academic_action_to_offering
    :parameters (?course_offering - course_offering ?academic_action - academic_action)
    :precondition
      (and
        (awaiting_grading ?course_offering)
        (academic_action_available ?academic_action)
      )
    :effect
      (and
        (offering_academic_action_assigned ?course_offering ?academic_action)
        (not
          (academic_action_available ?academic_action)
        )
      )
  )
  (:action release_academic_action_from_offering
    :parameters (?course_offering - course_offering ?academic_action - academic_action)
    :precondition
      (and
        (offering_academic_action_assigned ?course_offering ?academic_action)
      )
    :effect
      (and
        (academic_action_available ?academic_action)
        (not
          (offering_academic_action_assigned ?course_offering ?academic_action)
        )
      )
  )
  (:action prioritize_bottleneck_for_undergraduate
    :parameters (?student_undergraduate - student_undergraduate ?bottleneck_category - bottleneck_category ?assessment_activity - assessment_activity)
    :precondition
      (and
        (awaiting_grading ?student_undergraduate)
        (activity_assigned ?student_undergraduate ?assessment_activity)
        (student_bottleneck_tag ?student_undergraduate ?bottleneck_category)
        (not
          (bottleneck_prioritized ?bottleneck_category)
        )
        (not
          (bottleneck_tagged ?bottleneck_category)
        )
      )
    :effect (bottleneck_prioritized ?bottleneck_category)
  )
  (:action assign_staff_to_undergraduate_bottleneck
    :parameters (?student_undergraduate - student_undergraduate ?bottleneck_category - bottleneck_category ?staff_member - staff_member)
    :precondition
      (and
        (awaiting_grading ?student_undergraduate)
        (assigned_grader ?student_undergraduate ?staff_member)
        (student_bottleneck_tag ?student_undergraduate ?bottleneck_category)
        (bottleneck_prioritized ?bottleneck_category)
        (not
          (undergraduate_batch_ready ?student_undergraduate)
        )
      )
    :effect
      (and
        (undergraduate_batch_ready ?student_undergraduate)
        (student_prioritized ?student_undergraduate)
      )
  )
  (:action allocate_support_resource_to_undergraduate
    :parameters (?student_undergraduate - student_undergraduate ?bottleneck_category - bottleneck_category ?support_resource - support_resource)
    :precondition
      (and
        (awaiting_grading ?student_undergraduate)
        (student_bottleneck_tag ?student_undergraduate ?bottleneck_category)
        (support_resource_available ?support_resource)
        (not
          (undergraduate_batch_ready ?student_undergraduate)
        )
      )
    :effect
      (and
        (bottleneck_tagged ?bottleneck_category)
        (undergraduate_batch_ready ?student_undergraduate)
        (undergraduate_allocated_resource ?student_undergraduate ?support_resource)
        (not
          (support_resource_available ?support_resource)
        )
      )
  )
  (:action resolve_undergraduate_bottleneck_with_activity
    :parameters (?student_undergraduate - student_undergraduate ?bottleneck_category - bottleneck_category ?assessment_activity - assessment_activity ?support_resource - support_resource)
    :precondition
      (and
        (awaiting_grading ?student_undergraduate)
        (activity_assigned ?student_undergraduate ?assessment_activity)
        (student_bottleneck_tag ?student_undergraduate ?bottleneck_category)
        (bottleneck_tagged ?bottleneck_category)
        (undergraduate_allocated_resource ?student_undergraduate ?support_resource)
        (not
          (student_prioritized ?student_undergraduate)
        )
      )
    :effect
      (and
        (bottleneck_prioritized ?bottleneck_category)
        (student_prioritized ?student_undergraduate)
        (support_resource_available ?support_resource)
        (not
          (undergraduate_allocated_resource ?student_undergraduate ?support_resource)
        )
      )
  )
  (:action activate_priority_tag_for_graduate
    :parameters (?student_graduate - student_graduate ?priority_tag - priority_tag ?assessment_activity - assessment_activity)
    :precondition
      (and
        (awaiting_grading ?student_graduate)
        (activity_assigned ?student_graduate ?assessment_activity)
        (graduate_priority_assigned ?student_graduate ?priority_tag)
        (not
          (priority_tag_activated ?priority_tag)
        )
        (not
          (priority_tag_queued ?priority_tag)
        )
      )
    :effect (priority_tag_activated ?priority_tag)
  )
  (:action assign_staff_to_graduate_priority
    :parameters (?student_graduate - student_graduate ?priority_tag - priority_tag ?staff_member - staff_member)
    :precondition
      (and
        (awaiting_grading ?student_graduate)
        (assigned_grader ?student_graduate ?staff_member)
        (graduate_priority_assigned ?student_graduate ?priority_tag)
        (priority_tag_activated ?priority_tag)
        (not
          (graduate_batch_ready ?student_graduate)
        )
      )
    :effect
      (and
        (graduate_batch_ready ?student_graduate)
        (graduate_prioritized ?student_graduate)
      )
  )
  (:action allocate_support_resource_to_graduate_priority
    :parameters (?student_graduate - student_graduate ?priority_tag - priority_tag ?support_resource - support_resource)
    :precondition
      (and
        (awaiting_grading ?student_graduate)
        (graduate_priority_assigned ?student_graduate ?priority_tag)
        (support_resource_available ?support_resource)
        (not
          (graduate_batch_ready ?student_graduate)
        )
      )
    :effect
      (and
        (priority_tag_queued ?priority_tag)
        (graduate_batch_ready ?student_graduate)
        (graduate_allocated_resource ?student_graduate ?support_resource)
        (not
          (support_resource_available ?support_resource)
        )
      )
  )
  (:action resolve_graduate_bottleneck_with_activity
    :parameters (?student_graduate - student_graduate ?priority_tag - priority_tag ?assessment_activity - assessment_activity ?support_resource - support_resource)
    :precondition
      (and
        (awaiting_grading ?student_graduate)
        (activity_assigned ?student_graduate ?assessment_activity)
        (graduate_priority_assigned ?student_graduate ?priority_tag)
        (priority_tag_queued ?priority_tag)
        (graduate_allocated_resource ?student_graduate ?support_resource)
        (not
          (graduate_prioritized ?student_graduate)
        )
      )
    :effect
      (and
        (priority_tag_activated ?priority_tag)
        (graduate_prioritized ?student_graduate)
        (support_resource_available ?support_resource)
        (not
          (graduate_allocated_resource ?student_graduate ?support_resource)
        )
      )
  )
  (:action compose_assessment_batch
    :parameters (?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?bottleneck_category - bottleneck_category ?priority_tag - priority_tag ?assessment_batch - assessment_batch)
    :precondition
      (and
        (undergraduate_batch_ready ?student_undergraduate)
        (graduate_batch_ready ?student_graduate)
        (student_bottleneck_tag ?student_undergraduate ?bottleneck_category)
        (graduate_priority_assigned ?student_graduate ?priority_tag)
        (bottleneck_prioritized ?bottleneck_category)
        (priority_tag_activated ?priority_tag)
        (student_prioritized ?student_undergraduate)
        (graduate_prioritized ?student_graduate)
        (batch_pending ?assessment_batch)
      )
    :effect
      (and
        (batch_confirmed ?assessment_batch)
        (batch_bottleneck_link ?assessment_batch ?bottleneck_category)
        (batch_priority_link ?assessment_batch ?priority_tag)
        (not
          (batch_pending ?assessment_batch)
        )
      )
  )
  (:action compose_assessment_batch_with_tagged_bottleneck
    :parameters (?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?bottleneck_category - bottleneck_category ?priority_tag - priority_tag ?assessment_batch - assessment_batch)
    :precondition
      (and
        (undergraduate_batch_ready ?student_undergraduate)
        (graduate_batch_ready ?student_graduate)
        (student_bottleneck_tag ?student_undergraduate ?bottleneck_category)
        (graduate_priority_assigned ?student_graduate ?priority_tag)
        (bottleneck_tagged ?bottleneck_category)
        (priority_tag_activated ?priority_tag)
        (not
          (student_prioritized ?student_undergraduate)
        )
        (graduate_prioritized ?student_graduate)
        (batch_pending ?assessment_batch)
      )
    :effect
      (and
        (batch_confirmed ?assessment_batch)
        (batch_bottleneck_link ?assessment_batch ?bottleneck_category)
        (batch_priority_link ?assessment_batch ?priority_tag)
        (batch_requires_escalation ?assessment_batch)
        (not
          (batch_pending ?assessment_batch)
        )
      )
  )
  (:action compose_assessment_batch_with_priority_queued
    :parameters (?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?bottleneck_category - bottleneck_category ?priority_tag - priority_tag ?assessment_batch - assessment_batch)
    :precondition
      (and
        (undergraduate_batch_ready ?student_undergraduate)
        (graduate_batch_ready ?student_graduate)
        (student_bottleneck_tag ?student_undergraduate ?bottleneck_category)
        (graduate_priority_assigned ?student_graduate ?priority_tag)
        (bottleneck_prioritized ?bottleneck_category)
        (priority_tag_queued ?priority_tag)
        (student_prioritized ?student_undergraduate)
        (not
          (graduate_prioritized ?student_graduate)
        )
        (batch_pending ?assessment_batch)
      )
    :effect
      (and
        (batch_confirmed ?assessment_batch)
        (batch_bottleneck_link ?assessment_batch ?bottleneck_category)
        (batch_priority_link ?assessment_batch ?priority_tag)
        (batch_requires_intervention ?assessment_batch)
        (not
          (batch_pending ?assessment_batch)
        )
      )
  )
  (:action compose_assessment_batch_with_intervention_and_escalation
    :parameters (?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?bottleneck_category - bottleneck_category ?priority_tag - priority_tag ?assessment_batch - assessment_batch)
    :precondition
      (and
        (undergraduate_batch_ready ?student_undergraduate)
        (graduate_batch_ready ?student_graduate)
        (student_bottleneck_tag ?student_undergraduate ?bottleneck_category)
        (graduate_priority_assigned ?student_graduate ?priority_tag)
        (bottleneck_tagged ?bottleneck_category)
        (priority_tag_queued ?priority_tag)
        (not
          (student_prioritized ?student_undergraduate)
        )
        (not
          (graduate_prioritized ?student_graduate)
        )
        (batch_pending ?assessment_batch)
      )
    :effect
      (and
        (batch_confirmed ?assessment_batch)
        (batch_bottleneck_link ?assessment_batch ?bottleneck_category)
        (batch_priority_link ?assessment_batch ?priority_tag)
        (batch_requires_escalation ?assessment_batch)
        (batch_requires_intervention ?assessment_batch)
        (not
          (batch_pending ?assessment_batch)
        )
      )
  )
  (:action activate_assessment_batch
    :parameters (?assessment_batch - assessment_batch ?student_undergraduate - student_undergraduate ?assessment_activity - assessment_activity)
    :precondition
      (and
        (batch_confirmed ?assessment_batch)
        (undergraduate_batch_ready ?student_undergraduate)
        (activity_assigned ?student_undergraduate ?assessment_activity)
        (not
          (batch_executed ?assessment_batch)
        )
      )
    :effect (batch_executed ?assessment_batch)
  )
  (:action prepare_milestone_checkpoint
    :parameters (?course_offering - course_offering ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch)
    :precondition
      (and
        (awaiting_grading ?course_offering)
        (offering_associated_batch ?course_offering ?assessment_batch)
        (offering_has_checkpoint ?course_offering ?milestone_checkpoint)
        (checkpoint_available ?milestone_checkpoint)
        (batch_confirmed ?assessment_batch)
        (batch_executed ?assessment_batch)
        (not
          (checkpoint_verified ?milestone_checkpoint)
        )
      )
    :effect
      (and
        (checkpoint_verified ?milestone_checkpoint)
        (checkpoint_assigned_batch ?milestone_checkpoint ?assessment_batch)
        (not
          (checkpoint_available ?milestone_checkpoint)
        )
      )
  )
  (:action verify_milestone_without_escalation
    :parameters (?course_offering - course_offering ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch ?assessment_activity - assessment_activity)
    :precondition
      (and
        (awaiting_grading ?course_offering)
        (offering_has_checkpoint ?course_offering ?milestone_checkpoint)
        (checkpoint_verified ?milestone_checkpoint)
        (checkpoint_assigned_batch ?milestone_checkpoint ?assessment_batch)
        (activity_assigned ?course_offering ?assessment_activity)
        (not
          (batch_requires_escalation ?assessment_batch)
        )
        (not
          (offering_milestone_ready ?course_offering)
        )
      )
    :effect (offering_milestone_ready ?course_offering)
  )
  (:action assign_escalation_flag_to_offering
    :parameters (?course_offering - course_offering ?escalation_flag - escalation_flag)
    :precondition
      (and
        (awaiting_grading ?course_offering)
        (escalation_flag_available ?escalation_flag)
        (not
          (escalation_flagged ?course_offering)
        )
      )
    :effect
      (and
        (escalation_flagged ?course_offering)
        (offering_escalation_flagged ?course_offering ?escalation_flag)
        (not
          (escalation_flag_available ?escalation_flag)
        )
      )
  )
  (:action process_escalation_for_offering_checkpoint
    :parameters (?course_offering - course_offering ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch ?assessment_activity - assessment_activity ?escalation_flag - escalation_flag)
    :precondition
      (and
        (awaiting_grading ?course_offering)
        (offering_has_checkpoint ?course_offering ?milestone_checkpoint)
        (checkpoint_verified ?milestone_checkpoint)
        (checkpoint_assigned_batch ?milestone_checkpoint ?assessment_batch)
        (activity_assigned ?course_offering ?assessment_activity)
        (batch_requires_escalation ?assessment_batch)
        (escalation_flagged ?course_offering)
        (offering_escalation_flagged ?course_offering ?escalation_flag)
        (not
          (offering_milestone_ready ?course_offering)
        )
      )
    :effect
      (and
        (offering_milestone_ready ?course_offering)
        (escalation_acknowledged ?course_offering)
      )
  )
  (:action assign_grading_tool_and_prepare_offering
    :parameters (?course_offering - course_offering ?grading_tool - grading_tool ?staff_member - staff_member ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch)
    :precondition
      (and
        (offering_milestone_ready ?course_offering)
        (offering_grading_tool_assigned ?course_offering ?grading_tool)
        (assigned_grader ?course_offering ?staff_member)
        (offering_has_checkpoint ?course_offering ?milestone_checkpoint)
        (checkpoint_assigned_batch ?milestone_checkpoint ?assessment_batch)
        (not
          (batch_requires_intervention ?assessment_batch)
        )
        (not
          (offering_grading_tool_confirmed ?course_offering)
        )
      )
    :effect (offering_grading_tool_confirmed ?course_offering)
  )
  (:action assign_grading_tool_for_intervened_offering
    :parameters (?course_offering - course_offering ?grading_tool - grading_tool ?staff_member - staff_member ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch)
    :precondition
      (and
        (offering_milestone_ready ?course_offering)
        (offering_grading_tool_assigned ?course_offering ?grading_tool)
        (assigned_grader ?course_offering ?staff_member)
        (offering_has_checkpoint ?course_offering ?milestone_checkpoint)
        (checkpoint_assigned_batch ?milestone_checkpoint ?assessment_batch)
        (batch_requires_intervention ?assessment_batch)
        (not
          (offering_grading_tool_confirmed ?course_offering)
        )
      )
    :effect (offering_grading_tool_confirmed ?course_offering)
  )
  (:action apply_academic_action_and_confirm_eligibility
    :parameters (?course_offering - course_offering ?academic_action - academic_action ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch)
    :precondition
      (and
        (offering_grading_tool_confirmed ?course_offering)
        (offering_academic_action_assigned ?course_offering ?academic_action)
        (offering_has_checkpoint ?course_offering ?milestone_checkpoint)
        (checkpoint_assigned_batch ?milestone_checkpoint ?assessment_batch)
        (not
          (batch_requires_escalation ?assessment_batch)
        )
        (not
          (batch_requires_intervention ?assessment_batch)
        )
        (not
          (eligibility_confirmed ?course_offering)
        )
      )
    :effect (eligibility_confirmed ?course_offering)
  )
  (:action apply_academic_action_with_escalation
    :parameters (?course_offering - course_offering ?academic_action - academic_action ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch)
    :precondition
      (and
        (offering_grading_tool_confirmed ?course_offering)
        (offering_academic_action_assigned ?course_offering ?academic_action)
        (offering_has_checkpoint ?course_offering ?milestone_checkpoint)
        (checkpoint_assigned_batch ?milestone_checkpoint ?assessment_batch)
        (batch_requires_escalation ?assessment_batch)
        (not
          (batch_requires_intervention ?assessment_batch)
        )
        (not
          (eligibility_confirmed ?course_offering)
        )
      )
    :effect
      (and
        (eligibility_confirmed ?course_offering)
        (intervention_applied ?course_offering)
      )
  )
  (:action apply_academic_action_with_policy_intervention
    :parameters (?course_offering - course_offering ?academic_action - academic_action ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch)
    :precondition
      (and
        (offering_grading_tool_confirmed ?course_offering)
        (offering_academic_action_assigned ?course_offering ?academic_action)
        (offering_has_checkpoint ?course_offering ?milestone_checkpoint)
        (checkpoint_assigned_batch ?milestone_checkpoint ?assessment_batch)
        (not
          (batch_requires_escalation ?assessment_batch)
        )
        (batch_requires_intervention ?assessment_batch)
        (not
          (eligibility_confirmed ?course_offering)
        )
      )
    :effect
      (and
        (eligibility_confirmed ?course_offering)
        (intervention_applied ?course_offering)
      )
  )
  (:action apply_academic_action_with_multiple_flags
    :parameters (?course_offering - course_offering ?academic_action - academic_action ?milestone_checkpoint - milestone_checkpoint ?assessment_batch - assessment_batch)
    :precondition
      (and
        (offering_grading_tool_confirmed ?course_offering)
        (offering_academic_action_assigned ?course_offering ?academic_action)
        (offering_has_checkpoint ?course_offering ?milestone_checkpoint)
        (checkpoint_assigned_batch ?milestone_checkpoint ?assessment_batch)
        (batch_requires_escalation ?assessment_batch)
        (batch_requires_intervention ?assessment_batch)
        (not
          (eligibility_confirmed ?course_offering)
        )
      )
    :effect
      (and
        (eligibility_confirmed ?course_offering)
        (intervention_applied ?course_offering)
      )
  )
  (:action finalize_offering_completion
    :parameters (?course_offering - course_offering)
    :precondition
      (and
        (eligibility_confirmed ?course_offering)
        (not
          (intervention_applied ?course_offering)
        )
        (not
          (offering_completion_recorded ?course_offering)
        )
      )
    :effect
      (and
        (offering_completion_recorded ?course_offering)
        (academic_record_committed ?course_offering)
      )
  )
  (:action apply_policy_intervention_to_offering
    :parameters (?course_offering - course_offering ?policy_intervention - policy_intervention)
    :precondition
      (and
        (eligibility_confirmed ?course_offering)
        (intervention_applied ?course_offering)
        (policy_intervention_available ?policy_intervention)
      )
    :effect
      (and
        (offering_intervention_applied ?course_offering ?policy_intervention)
        (not
          (policy_intervention_available ?policy_intervention)
        )
      )
  )
  (:action verify_milestone_with_students_and_mark_verified
    :parameters (?course_offering - course_offering ?student_undergraduate - student_undergraduate ?student_graduate - student_graduate ?assessment_activity - assessment_activity ?policy_intervention - policy_intervention)
    :precondition
      (and
        (eligibility_confirmed ?course_offering)
        (intervention_applied ?course_offering)
        (offering_intervention_applied ?course_offering ?policy_intervention)
        (offering_enrolled_undergraduate ?course_offering ?student_undergraduate)
        (offering_enrolled_graduate ?course_offering ?student_graduate)
        (student_prioritized ?student_undergraduate)
        (graduate_prioritized ?student_graduate)
        (activity_assigned ?course_offering ?assessment_activity)
        (not
          (milestone_verified ?course_offering)
        )
      )
    :effect (milestone_verified ?course_offering)
  )
  (:action confirm_offering_finalization
    :parameters (?course_offering - course_offering)
    :precondition
      (and
        (eligibility_confirmed ?course_offering)
        (milestone_verified ?course_offering)
        (not
          (offering_completion_recorded ?course_offering)
        )
      )
    :effect
      (and
        (offering_completion_recorded ?course_offering)
        (academic_record_committed ?course_offering)
      )
  )
  (:action approve_exception_for_offering
    :parameters (?course_offering - course_offering ?exception_reason - exception_reason ?assessment_activity - assessment_activity)
    :precondition
      (and
        (awaiting_grading ?course_offering)
        (activity_assigned ?course_offering ?assessment_activity)
        (exception_available ?exception_reason)
        (offering_has_exception ?course_offering ?exception_reason)
        (not
          (exception_approved ?course_offering)
        )
      )
    :effect
      (and
        (exception_approved ?course_offering)
        (not
          (exception_available ?exception_reason)
        )
      )
  )
  (:action assign_staff_for_exception_handling
    :parameters (?course_offering - course_offering ?staff_member - staff_member)
    :precondition
      (and
        (exception_approved ?course_offering)
        (assigned_grader ?course_offering ?staff_member)
        (not
          (exception_assigned ?course_offering)
        )
      )
    :effect (exception_assigned ?course_offering)
  )
  (:action record_exception_action
    :parameters (?course_offering - course_offering ?academic_action - academic_action)
    :precondition
      (and
        (exception_assigned ?course_offering)
        (offering_academic_action_assigned ?course_offering ?academic_action)
        (not
          (exception_actioned ?course_offering)
        )
      )
    :effect (exception_actioned ?course_offering)
  )
  (:action finalize_offering_after_exception
    :parameters (?course_offering - course_offering)
    :precondition
      (and
        (exception_actioned ?course_offering)
        (not
          (offering_completion_recorded ?course_offering)
        )
      )
    :effect
      (and
        (offering_completion_recorded ?course_offering)
        (academic_record_committed ?course_offering)
      )
  )
  (:action finalize_undergraduate_assessment_outcome
    :parameters (?student_undergraduate - student_undergraduate ?assessment_batch - assessment_batch)
    :precondition
      (and
        (undergraduate_batch_ready ?student_undergraduate)
        (student_prioritized ?student_undergraduate)
        (batch_confirmed ?assessment_batch)
        (batch_executed ?assessment_batch)
        (not
          (academic_record_committed ?student_undergraduate)
        )
      )
    :effect (academic_record_committed ?student_undergraduate)
  )
  (:action finalize_graduate_assessment_outcome
    :parameters (?student_graduate - student_graduate ?assessment_batch - assessment_batch)
    :precondition
      (and
        (graduate_batch_ready ?student_graduate)
        (graduate_prioritized ?student_graduate)
        (batch_confirmed ?assessment_batch)
        (batch_executed ?assessment_batch)
        (not
          (academic_record_committed ?student_graduate)
        )
      )
    :effect (academic_record_committed ?student_graduate)
  )
  (:action apply_evidence_and_commit_academic_update
    :parameters (?assessment_entity - assessment_entity ?evidence_document - evidence_document ?assessment_activity - assessment_activity)
    :precondition
      (and
        (academic_record_committed ?assessment_entity)
        (activity_assigned ?assessment_entity ?assessment_activity)
        (evidence_document_available ?evidence_document)
        (not
          (academic_update_committed ?assessment_entity)
        )
      )
    :effect
      (and
        (academic_update_committed ?assessment_entity)
        (student_evidence_document ?assessment_entity ?evidence_document)
        (not
          (evidence_document_available ?evidence_document)
        )
      )
  )
  (:action finalize_undergraduate_and_release_assessment_slot
    :parameters (?student_undergraduate - student_undergraduate ?assessment_slot - assessment_slot ?evidence_document - evidence_document)
    :precondition
      (and
        (academic_update_committed ?student_undergraduate)
        (allocated_slot ?student_undergraduate ?assessment_slot)
        (student_evidence_document ?student_undergraduate ?evidence_document)
        (not
          (assessment_process_finalized ?student_undergraduate)
        )
      )
    :effect
      (and
        (assessment_process_finalized ?student_undergraduate)
        (slot_available ?assessment_slot)
        (evidence_document_available ?evidence_document)
      )
  )
  (:action finalize_graduate_and_release_assessment_slot
    :parameters (?student_graduate - student_graduate ?assessment_slot - assessment_slot ?evidence_document - evidence_document)
    :precondition
      (and
        (academic_update_committed ?student_graduate)
        (allocated_slot ?student_graduate ?assessment_slot)
        (student_evidence_document ?student_graduate ?evidence_document)
        (not
          (assessment_process_finalized ?student_graduate)
        )
      )
    :effect
      (and
        (assessment_process_finalized ?student_graduate)
        (slot_available ?assessment_slot)
        (evidence_document_available ?evidence_document)
      )
  )
  (:action finalize_offering_and_release_assessment_slot
    :parameters (?course_offering - course_offering ?assessment_slot - assessment_slot ?evidence_document - evidence_document)
    :precondition
      (and
        (academic_update_committed ?course_offering)
        (allocated_slot ?course_offering ?assessment_slot)
        (student_evidence_document ?course_offering ?evidence_document)
        (not
          (assessment_process_finalized ?course_offering)
        )
      )
    :effect
      (and
        (assessment_process_finalized ?course_offering)
        (slot_available ?assessment_slot)
        (evidence_document_available ?evidence_document)
      )
  )
)

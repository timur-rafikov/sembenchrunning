(define (domain education_research_supervision_matching)
  (:requirements :strips :typing :negative-preconditions)
  (:types institutional_role_holder - object person_role - object organizational_unit - object case_container - object student_case - case_container supervision_slot - institutional_role_holder research_proposal - institutional_role_holder department_advisor - institutional_role_holder supervisor_specialty_tag - institutional_role_holder evaluation_criterion - institutional_role_holder special_requirement - institutional_role_holder funding_allocation - institutional_role_holder external_approval - institutional_role_holder support_resource - person_role application_document - person_role external_recommendation - person_role expertise_area_doctoral - organizational_unit expertise_area_masters - organizational_unit match_proposal - organizational_unit student_subclass_container - student_case staff_subclass_container - student_case doctoral_candidate - student_subclass_container masters_candidate - student_subclass_container faculty_supervisor - staff_subclass_container)
  (:predicates
    (case_intake_created ?student_case - student_case)
    (entity_verified ?student_case - student_case)
    (initial_allocation_complete ?student_case - student_case)
    (entity_match_confirmed ?student_case - student_case)
    (entity_finalization_marker ?student_case - student_case)
    (entity_ready_for_assignment ?student_case - student_case)
    (supervision_slot_available ?supervision_slot - supervision_slot)
    (entity_assigned_to_supervision_slot ?student_case - student_case ?supervision_slot - supervision_slot)
    (proposal_available ?research_proposal - research_proposal)
    (entity_proposal_link ?student_case - student_case ?research_proposal - research_proposal)
    (advisor_available ?department_advisor - department_advisor)
    (entity_advisor_link ?student_case - student_case ?department_advisor - department_advisor)
    (support_resource_available ?support_resource - support_resource)
    (resource_allocated_to_doctoral ?doctoral_candidate - doctoral_candidate ?support_resource - support_resource)
    (resource_allocated_to_masters ?masters_candidate - masters_candidate ?support_resource - support_resource)
    (doctoral_expertise_link ?doctoral_candidate - doctoral_candidate ?expertise_area_doctoral - expertise_area_doctoral)
    (expertise_area_selected_flag ?expertise_area_doctoral - expertise_area_doctoral)
    (expertise_area_allocated_flag ?expertise_area_doctoral - expertise_area_doctoral)
    (doctoral_ready_for_pairing ?doctoral_candidate - doctoral_candidate)
    (masters_expertise_link ?masters_candidate - masters_candidate ?expertise_area_masters - expertise_area_masters)
    (masters_expertise_selected_flag ?expertise_area_masters - expertise_area_masters)
    (masters_expertise_allocated_flag ?expertise_area_masters - expertise_area_masters)
    (masters_ready_for_pairing ?masters_candidate - masters_candidate)
    (match_proposal_template_available ?match_proposal - match_proposal)
    (proposal_reserved ?match_proposal - match_proposal)
    (proposal_assigned_expertise_doctoral ?match_proposal - match_proposal ?expertise_area_doctoral - expertise_area_doctoral)
    (proposal_assigned_expertise_masters ?match_proposal - match_proposal ?expertise_area_masters - expertise_area_masters)
    (proposal_quality_flag_1 ?match_proposal - match_proposal)
    (proposal_quality_flag_2 ?match_proposal - match_proposal)
    (proposal_locked_for_assignment ?match_proposal - match_proposal)
    (supervisor_capacity_for_doctoral ?faculty_supervisor - faculty_supervisor ?doctoral_candidate - doctoral_candidate)
    (supervisor_capacity_for_masters ?faculty_supervisor - faculty_supervisor ?masters_candidate - masters_candidate)
    (supervisor_link_to_proposal_container ?faculty_supervisor - faculty_supervisor ?match_proposal - match_proposal)
    (document_available ?application_document - application_document)
    (supervisor_document_association ?faculty_supervisor - faculty_supervisor ?application_document - application_document)
    (document_locked ?application_document - application_document)
    (document_attached_to_proposal ?application_document - application_document ?match_proposal - match_proposal)
    (supervisor_precheck_passed ?faculty_supervisor - faculty_supervisor)
    (supervisor_stage_one_complete ?faculty_supervisor - faculty_supervisor)
    (supervisor_stage_two_complete ?faculty_supervisor - faculty_supervisor)
    (supervisor_tag_assigned ?faculty_supervisor - faculty_supervisor)
    (supervisor_tag_confirmed ?faculty_supervisor - faculty_supervisor)
    (supervisor_ready_for_assignment ?faculty_supervisor - faculty_supervisor)
    (supervisor_final_checks_complete ?faculty_supervisor - faculty_supervisor)
    (recommendation_available ?external_recommendation - external_recommendation)
    (supervisor_recommendation_link ?faculty_supervisor - faculty_supervisor ?external_recommendation - external_recommendation)
    (supervisor_initiated_assignment_path ?faculty_supervisor - faculty_supervisor)
    (supervisor_assignment_prepared ?faculty_supervisor - faculty_supervisor)
    (supervisor_assignment_finalized ?faculty_supervisor - faculty_supervisor)
    (specialty_tag_available ?supervisor_specialty_tag - supervisor_specialty_tag)
    (supervisor_tag_link ?faculty_supervisor - faculty_supervisor ?supervisor_specialty_tag - supervisor_specialty_tag)
    (criterion_available ?evaluation_criterion - evaluation_criterion)
    (supervisor_criterion_link ?faculty_supervisor - faculty_supervisor ?evaluation_criterion - evaluation_criterion)
    (funding_allocation_available ?funding_allocation - funding_allocation)
    (supervisor_funding_assigned ?faculty_supervisor - faculty_supervisor ?funding_allocation - funding_allocation)
    (external_approval_available ?external_approval - external_approval)
    (supervisor_external_approval_link ?faculty_supervisor - faculty_supervisor ?external_approval - external_approval)
    (special_requirement_available ?special_requirement - special_requirement)
    (entity_special_requirement_link ?student_case - student_case ?special_requirement - special_requirement)
    (doctoral_candidate_prepared_flag ?doctoral_candidate - doctoral_candidate)
    (masters_candidate_prepared_flag ?masters_candidate - masters_candidate)
    (entity_authorized_for_closure ?faculty_supervisor - faculty_supervisor)
  )
  (:action create_case_intake
    :parameters (?student_case - student_case)
    :precondition
      (and
        (not
          (case_intake_created ?student_case)
        )
        (not
          (entity_match_confirmed ?student_case)
        )
      )
    :effect (case_intake_created ?student_case)
  )
  (:action assign_case_to_supervision_slot
    :parameters (?student_case - student_case ?supervision_slot - supervision_slot)
    :precondition
      (and
        (case_intake_created ?student_case)
        (not
          (initial_allocation_complete ?student_case)
        )
        (supervision_slot_available ?supervision_slot)
      )
    :effect
      (and
        (initial_allocation_complete ?student_case)
        (entity_assigned_to_supervision_slot ?student_case ?supervision_slot)
        (not
          (supervision_slot_available ?supervision_slot)
        )
      )
  )
  (:action link_proposal_to_case
    :parameters (?student_case - student_case ?research_proposal - research_proposal)
    :precondition
      (and
        (case_intake_created ?student_case)
        (initial_allocation_complete ?student_case)
        (proposal_available ?research_proposal)
      )
    :effect
      (and
        (entity_proposal_link ?student_case ?research_proposal)
        (not
          (proposal_available ?research_proposal)
        )
      )
  )
  (:action mark_case_verified
    :parameters (?student_case - student_case ?research_proposal - research_proposal)
    :precondition
      (and
        (case_intake_created ?student_case)
        (initial_allocation_complete ?student_case)
        (entity_proposal_link ?student_case ?research_proposal)
        (not
          (entity_verified ?student_case)
        )
      )
    :effect (entity_verified ?student_case)
  )
  (:action release_proposal
    :parameters (?student_case - student_case ?research_proposal - research_proposal)
    :precondition
      (and
        (entity_proposal_link ?student_case ?research_proposal)
      )
    :effect
      (and
        (proposal_available ?research_proposal)
        (not
          (entity_proposal_link ?student_case ?research_proposal)
        )
      )
  )
  (:action assign_department_advisor
    :parameters (?student_case - student_case ?department_advisor - department_advisor)
    :precondition
      (and
        (entity_verified ?student_case)
        (advisor_available ?department_advisor)
      )
    :effect
      (and
        (entity_advisor_link ?student_case ?department_advisor)
        (not
          (advisor_available ?department_advisor)
        )
      )
  )
  (:action unassign_department_advisor
    :parameters (?student_case - student_case ?department_advisor - department_advisor)
    :precondition
      (and
        (entity_advisor_link ?student_case ?department_advisor)
      )
    :effect
      (and
        (advisor_available ?department_advisor)
        (not
          (entity_advisor_link ?student_case ?department_advisor)
        )
      )
  )
  (:action assign_funding_to_supervisor
    :parameters (?faculty_supervisor - faculty_supervisor ?funding_allocation - funding_allocation)
    :precondition
      (and
        (entity_verified ?faculty_supervisor)
        (funding_allocation_available ?funding_allocation)
      )
    :effect
      (and
        (supervisor_funding_assigned ?faculty_supervisor ?funding_allocation)
        (not
          (funding_allocation_available ?funding_allocation)
        )
      )
  )
  (:action release_funding_allocation_from_supervisor
    :parameters (?faculty_supervisor - faculty_supervisor ?funding_allocation - funding_allocation)
    :precondition
      (and
        (supervisor_funding_assigned ?faculty_supervisor ?funding_allocation)
      )
    :effect
      (and
        (funding_allocation_available ?funding_allocation)
        (not
          (supervisor_funding_assigned ?faculty_supervisor ?funding_allocation)
        )
      )
  )
  (:action assign_external_approval_to_supervisor
    :parameters (?faculty_supervisor - faculty_supervisor ?external_approval - external_approval)
    :precondition
      (and
        (entity_verified ?faculty_supervisor)
        (external_approval_available ?external_approval)
      )
    :effect
      (and
        (supervisor_external_approval_link ?faculty_supervisor ?external_approval)
        (not
          (external_approval_available ?external_approval)
        )
      )
  )
  (:action release_external_approval_from_supervisor
    :parameters (?faculty_supervisor - faculty_supervisor ?external_approval - external_approval)
    :precondition
      (and
        (supervisor_external_approval_link ?faculty_supervisor ?external_approval)
      )
    :effect
      (and
        (external_approval_available ?external_approval)
        (not
          (supervisor_external_approval_link ?faculty_supervisor ?external_approval)
        )
      )
  )
  (:action select_doctoral_expertise_area
    :parameters (?doctoral_candidate - doctoral_candidate ?expertise_area_doctoral - expertise_area_doctoral ?research_proposal - research_proposal)
    :precondition
      (and
        (entity_verified ?doctoral_candidate)
        (entity_proposal_link ?doctoral_candidate ?research_proposal)
        (doctoral_expertise_link ?doctoral_candidate ?expertise_area_doctoral)
        (not
          (expertise_area_selected_flag ?expertise_area_doctoral)
        )
        (not
          (expertise_area_allocated_flag ?expertise_area_doctoral)
        )
      )
    :effect (expertise_area_selected_flag ?expertise_area_doctoral)
  )
  (:action confirm_doctoral_candidate_preparedness
    :parameters (?doctoral_candidate - doctoral_candidate ?expertise_area_doctoral - expertise_area_doctoral ?department_advisor - department_advisor)
    :precondition
      (and
        (entity_verified ?doctoral_candidate)
        (entity_advisor_link ?doctoral_candidate ?department_advisor)
        (doctoral_expertise_link ?doctoral_candidate ?expertise_area_doctoral)
        (expertise_area_selected_flag ?expertise_area_doctoral)
        (not
          (doctoral_candidate_prepared_flag ?doctoral_candidate)
        )
      )
    :effect
      (and
        (doctoral_candidate_prepared_flag ?doctoral_candidate)
        (doctoral_ready_for_pairing ?doctoral_candidate)
      )
  )
  (:action allocate_support_to_doctoral_candidate
    :parameters (?doctoral_candidate - doctoral_candidate ?expertise_area_doctoral - expertise_area_doctoral ?support_resource - support_resource)
    :precondition
      (and
        (entity_verified ?doctoral_candidate)
        (doctoral_expertise_link ?doctoral_candidate ?expertise_area_doctoral)
        (support_resource_available ?support_resource)
        (not
          (doctoral_candidate_prepared_flag ?doctoral_candidate)
        )
      )
    :effect
      (and
        (expertise_area_allocated_flag ?expertise_area_doctoral)
        (doctoral_candidate_prepared_flag ?doctoral_candidate)
        (resource_allocated_to_doctoral ?doctoral_candidate ?support_resource)
        (not
          (support_resource_available ?support_resource)
        )
      )
  )
  (:action finalize_doctoral_expertise_selection
    :parameters (?doctoral_candidate - doctoral_candidate ?expertise_area_doctoral - expertise_area_doctoral ?research_proposal - research_proposal ?support_resource - support_resource)
    :precondition
      (and
        (entity_verified ?doctoral_candidate)
        (entity_proposal_link ?doctoral_candidate ?research_proposal)
        (doctoral_expertise_link ?doctoral_candidate ?expertise_area_doctoral)
        (expertise_area_allocated_flag ?expertise_area_doctoral)
        (resource_allocated_to_doctoral ?doctoral_candidate ?support_resource)
        (not
          (doctoral_ready_for_pairing ?doctoral_candidate)
        )
      )
    :effect
      (and
        (expertise_area_selected_flag ?expertise_area_doctoral)
        (doctoral_ready_for_pairing ?doctoral_candidate)
        (support_resource_available ?support_resource)
        (not
          (resource_allocated_to_doctoral ?doctoral_candidate ?support_resource)
        )
      )
  )
  (:action select_masters_expertise_area
    :parameters (?masters_candidate - masters_candidate ?expertise_area_masters - expertise_area_masters ?research_proposal - research_proposal)
    :precondition
      (and
        (entity_verified ?masters_candidate)
        (entity_proposal_link ?masters_candidate ?research_proposal)
        (masters_expertise_link ?masters_candidate ?expertise_area_masters)
        (not
          (masters_expertise_selected_flag ?expertise_area_masters)
        )
        (not
          (masters_expertise_allocated_flag ?expertise_area_masters)
        )
      )
    :effect (masters_expertise_selected_flag ?expertise_area_masters)
  )
  (:action confirm_masters_candidate_preparedness
    :parameters (?masters_candidate - masters_candidate ?expertise_area_masters - expertise_area_masters ?department_advisor - department_advisor)
    :precondition
      (and
        (entity_verified ?masters_candidate)
        (entity_advisor_link ?masters_candidate ?department_advisor)
        (masters_expertise_link ?masters_candidate ?expertise_area_masters)
        (masters_expertise_selected_flag ?expertise_area_masters)
        (not
          (masters_candidate_prepared_flag ?masters_candidate)
        )
      )
    :effect
      (and
        (masters_candidate_prepared_flag ?masters_candidate)
        (masters_ready_for_pairing ?masters_candidate)
      )
  )
  (:action allocate_support_to_masters_candidate
    :parameters (?masters_candidate - masters_candidate ?expertise_area_masters - expertise_area_masters ?support_resource - support_resource)
    :precondition
      (and
        (entity_verified ?masters_candidate)
        (masters_expertise_link ?masters_candidate ?expertise_area_masters)
        (support_resource_available ?support_resource)
        (not
          (masters_candidate_prepared_flag ?masters_candidate)
        )
      )
    :effect
      (and
        (masters_expertise_allocated_flag ?expertise_area_masters)
        (masters_candidate_prepared_flag ?masters_candidate)
        (resource_allocated_to_masters ?masters_candidate ?support_resource)
        (not
          (support_resource_available ?support_resource)
        )
      )
  )
  (:action finalize_masters_expertise_selection
    :parameters (?masters_candidate - masters_candidate ?expertise_area_masters - expertise_area_masters ?research_proposal - research_proposal ?support_resource - support_resource)
    :precondition
      (and
        (entity_verified ?masters_candidate)
        (entity_proposal_link ?masters_candidate ?research_proposal)
        (masters_expertise_link ?masters_candidate ?expertise_area_masters)
        (masters_expertise_allocated_flag ?expertise_area_masters)
        (resource_allocated_to_masters ?masters_candidate ?support_resource)
        (not
          (masters_ready_for_pairing ?masters_candidate)
        )
      )
    :effect
      (and
        (masters_expertise_selected_flag ?expertise_area_masters)
        (masters_ready_for_pairing ?masters_candidate)
        (support_resource_available ?support_resource)
        (not
          (resource_allocated_to_masters ?masters_candidate ?support_resource)
        )
      )
  )
  (:action create_and_reserve_match_proposal
    :parameters (?doctoral_candidate - doctoral_candidate ?masters_candidate - masters_candidate ?expertise_area_doctoral - expertise_area_doctoral ?expertise_area_masters - expertise_area_masters ?match_proposal - match_proposal)
    :precondition
      (and
        (doctoral_candidate_prepared_flag ?doctoral_candidate)
        (masters_candidate_prepared_flag ?masters_candidate)
        (doctoral_expertise_link ?doctoral_candidate ?expertise_area_doctoral)
        (masters_expertise_link ?masters_candidate ?expertise_area_masters)
        (expertise_area_selected_flag ?expertise_area_doctoral)
        (masters_expertise_selected_flag ?expertise_area_masters)
        (doctoral_ready_for_pairing ?doctoral_candidate)
        (masters_ready_for_pairing ?masters_candidate)
        (match_proposal_template_available ?match_proposal)
      )
    :effect
      (and
        (proposal_reserved ?match_proposal)
        (proposal_assigned_expertise_doctoral ?match_proposal ?expertise_area_doctoral)
        (proposal_assigned_expertise_masters ?match_proposal ?expertise_area_masters)
        (not
          (match_proposal_template_available ?match_proposal)
        )
      )
  )
  (:action reserve_match_proposal_with_quality_flag_1
    :parameters (?doctoral_candidate - doctoral_candidate ?masters_candidate - masters_candidate ?expertise_area_doctoral - expertise_area_doctoral ?expertise_area_masters - expertise_area_masters ?match_proposal - match_proposal)
    :precondition
      (and
        (doctoral_candidate_prepared_flag ?doctoral_candidate)
        (masters_candidate_prepared_flag ?masters_candidate)
        (doctoral_expertise_link ?doctoral_candidate ?expertise_area_doctoral)
        (masters_expertise_link ?masters_candidate ?expertise_area_masters)
        (expertise_area_allocated_flag ?expertise_area_doctoral)
        (masters_expertise_selected_flag ?expertise_area_masters)
        (not
          (doctoral_ready_for_pairing ?doctoral_candidate)
        )
        (masters_ready_for_pairing ?masters_candidate)
        (match_proposal_template_available ?match_proposal)
      )
    :effect
      (and
        (proposal_reserved ?match_proposal)
        (proposal_assigned_expertise_doctoral ?match_proposal ?expertise_area_doctoral)
        (proposal_assigned_expertise_masters ?match_proposal ?expertise_area_masters)
        (proposal_quality_flag_1 ?match_proposal)
        (not
          (match_proposal_template_available ?match_proposal)
        )
      )
  )
  (:action reserve_match_proposal_with_quality_flag_2
    :parameters (?doctoral_candidate - doctoral_candidate ?masters_candidate - masters_candidate ?expertise_area_doctoral - expertise_area_doctoral ?expertise_area_masters - expertise_area_masters ?match_proposal - match_proposal)
    :precondition
      (and
        (doctoral_candidate_prepared_flag ?doctoral_candidate)
        (masters_candidate_prepared_flag ?masters_candidate)
        (doctoral_expertise_link ?doctoral_candidate ?expertise_area_doctoral)
        (masters_expertise_link ?masters_candidate ?expertise_area_masters)
        (expertise_area_selected_flag ?expertise_area_doctoral)
        (masters_expertise_allocated_flag ?expertise_area_masters)
        (doctoral_ready_for_pairing ?doctoral_candidate)
        (not
          (masters_ready_for_pairing ?masters_candidate)
        )
        (match_proposal_template_available ?match_proposal)
      )
    :effect
      (and
        (proposal_reserved ?match_proposal)
        (proposal_assigned_expertise_doctoral ?match_proposal ?expertise_area_doctoral)
        (proposal_assigned_expertise_masters ?match_proposal ?expertise_area_masters)
        (proposal_quality_flag_2 ?match_proposal)
        (not
          (match_proposal_template_available ?match_proposal)
        )
      )
  )
  (:action reserve_match_proposal_with_both_quality_flags
    :parameters (?doctoral_candidate - doctoral_candidate ?masters_candidate - masters_candidate ?expertise_area_doctoral - expertise_area_doctoral ?expertise_area_masters - expertise_area_masters ?match_proposal - match_proposal)
    :precondition
      (and
        (doctoral_candidate_prepared_flag ?doctoral_candidate)
        (masters_candidate_prepared_flag ?masters_candidate)
        (doctoral_expertise_link ?doctoral_candidate ?expertise_area_doctoral)
        (masters_expertise_link ?masters_candidate ?expertise_area_masters)
        (expertise_area_allocated_flag ?expertise_area_doctoral)
        (masters_expertise_allocated_flag ?expertise_area_masters)
        (not
          (doctoral_ready_for_pairing ?doctoral_candidate)
        )
        (not
          (masters_ready_for_pairing ?masters_candidate)
        )
        (match_proposal_template_available ?match_proposal)
      )
    :effect
      (and
        (proposal_reserved ?match_proposal)
        (proposal_assigned_expertise_doctoral ?match_proposal ?expertise_area_doctoral)
        (proposal_assigned_expertise_masters ?match_proposal ?expertise_area_masters)
        (proposal_quality_flag_1 ?match_proposal)
        (proposal_quality_flag_2 ?match_proposal)
        (not
          (match_proposal_template_available ?match_proposal)
        )
      )
  )
  (:action lock_proposal_for_assignment
    :parameters (?match_proposal - match_proposal ?doctoral_candidate - doctoral_candidate ?research_proposal - research_proposal)
    :precondition
      (and
        (proposal_reserved ?match_proposal)
        (doctoral_candidate_prepared_flag ?doctoral_candidate)
        (entity_proposal_link ?doctoral_candidate ?research_proposal)
        (not
          (proposal_locked_for_assignment ?match_proposal)
        )
      )
    :effect (proposal_locked_for_assignment ?match_proposal)
  )
  (:action attach_and_lock_document_to_proposal
    :parameters (?faculty_supervisor - faculty_supervisor ?application_document - application_document ?match_proposal - match_proposal)
    :precondition
      (and
        (entity_verified ?faculty_supervisor)
        (supervisor_link_to_proposal_container ?faculty_supervisor ?match_proposal)
        (supervisor_document_association ?faculty_supervisor ?application_document)
        (document_available ?application_document)
        (proposal_reserved ?match_proposal)
        (proposal_locked_for_assignment ?match_proposal)
        (not
          (document_locked ?application_document)
        )
      )
    :effect
      (and
        (document_locked ?application_document)
        (document_attached_to_proposal ?application_document ?match_proposal)
        (not
          (document_available ?application_document)
        )
      )
  )
  (:action mark_supervisor_precheck_passed
    :parameters (?faculty_supervisor - faculty_supervisor ?application_document - application_document ?match_proposal - match_proposal ?research_proposal - research_proposal)
    :precondition
      (and
        (entity_verified ?faculty_supervisor)
        (supervisor_document_association ?faculty_supervisor ?application_document)
        (document_locked ?application_document)
        (document_attached_to_proposal ?application_document ?match_proposal)
        (entity_proposal_link ?faculty_supervisor ?research_proposal)
        (not
          (proposal_quality_flag_1 ?match_proposal)
        )
        (not
          (supervisor_precheck_passed ?faculty_supervisor)
        )
      )
    :effect (supervisor_precheck_passed ?faculty_supervisor)
  )
  (:action assign_supervisor_specialty_tag
    :parameters (?faculty_supervisor - faculty_supervisor ?supervisor_specialty_tag - supervisor_specialty_tag)
    :precondition
      (and
        (entity_verified ?faculty_supervisor)
        (specialty_tag_available ?supervisor_specialty_tag)
        (not
          (supervisor_tag_assigned ?faculty_supervisor)
        )
      )
    :effect
      (and
        (supervisor_tag_assigned ?faculty_supervisor)
        (supervisor_tag_link ?faculty_supervisor ?supervisor_specialty_tag)
        (not
          (specialty_tag_available ?supervisor_specialty_tag)
        )
      )
  )
  (:action assign_and_confirm_supervisor_specialty_tag
    :parameters (?faculty_supervisor - faculty_supervisor ?application_document - application_document ?match_proposal - match_proposal ?research_proposal - research_proposal ?supervisor_specialty_tag - supervisor_specialty_tag)
    :precondition
      (and
        (entity_verified ?faculty_supervisor)
        (supervisor_document_association ?faculty_supervisor ?application_document)
        (document_locked ?application_document)
        (document_attached_to_proposal ?application_document ?match_proposal)
        (entity_proposal_link ?faculty_supervisor ?research_proposal)
        (proposal_quality_flag_1 ?match_proposal)
        (supervisor_tag_assigned ?faculty_supervisor)
        (supervisor_tag_link ?faculty_supervisor ?supervisor_specialty_tag)
        (not
          (supervisor_precheck_passed ?faculty_supervisor)
        )
      )
    :effect
      (and
        (supervisor_precheck_passed ?faculty_supervisor)
        (supervisor_tag_confirmed ?faculty_supervisor)
      )
  )
  (:action complete_supervisor_stage_one
    :parameters (?faculty_supervisor - faculty_supervisor ?funding_allocation - funding_allocation ?department_advisor - department_advisor ?application_document - application_document ?match_proposal - match_proposal)
    :precondition
      (and
        (supervisor_precheck_passed ?faculty_supervisor)
        (supervisor_funding_assigned ?faculty_supervisor ?funding_allocation)
        (entity_advisor_link ?faculty_supervisor ?department_advisor)
        (supervisor_document_association ?faculty_supervisor ?application_document)
        (document_attached_to_proposal ?application_document ?match_proposal)
        (not
          (proposal_quality_flag_2 ?match_proposal)
        )
        (not
          (supervisor_stage_one_complete ?faculty_supervisor)
        )
      )
    :effect (supervisor_stage_one_complete ?faculty_supervisor)
  )
  (:action complete_supervisor_stage_one_alternate
    :parameters (?faculty_supervisor - faculty_supervisor ?funding_allocation - funding_allocation ?department_advisor - department_advisor ?application_document - application_document ?match_proposal - match_proposal)
    :precondition
      (and
        (supervisor_precheck_passed ?faculty_supervisor)
        (supervisor_funding_assigned ?faculty_supervisor ?funding_allocation)
        (entity_advisor_link ?faculty_supervisor ?department_advisor)
        (supervisor_document_association ?faculty_supervisor ?application_document)
        (document_attached_to_proposal ?application_document ?match_proposal)
        (proposal_quality_flag_2 ?match_proposal)
        (not
          (supervisor_stage_one_complete ?faculty_supervisor)
        )
      )
    :effect (supervisor_stage_one_complete ?faculty_supervisor)
  )
  (:action complete_supervisor_stage_two
    :parameters (?faculty_supervisor - faculty_supervisor ?external_approval - external_approval ?application_document - application_document ?match_proposal - match_proposal)
    :precondition
      (and
        (supervisor_stage_one_complete ?faculty_supervisor)
        (supervisor_external_approval_link ?faculty_supervisor ?external_approval)
        (supervisor_document_association ?faculty_supervisor ?application_document)
        (document_attached_to_proposal ?application_document ?match_proposal)
        (not
          (proposal_quality_flag_1 ?match_proposal)
        )
        (not
          (proposal_quality_flag_2 ?match_proposal)
        )
        (not
          (supervisor_stage_two_complete ?faculty_supervisor)
        )
      )
    :effect (supervisor_stage_two_complete ?faculty_supervisor)
  )
  (:action confirm_supervisor_stage_two_and_mark_ready
    :parameters (?faculty_supervisor - faculty_supervisor ?external_approval - external_approval ?application_document - application_document ?match_proposal - match_proposal)
    :precondition
      (and
        (supervisor_stage_one_complete ?faculty_supervisor)
        (supervisor_external_approval_link ?faculty_supervisor ?external_approval)
        (supervisor_document_association ?faculty_supervisor ?application_document)
        (document_attached_to_proposal ?application_document ?match_proposal)
        (proposal_quality_flag_1 ?match_proposal)
        (not
          (proposal_quality_flag_2 ?match_proposal)
        )
        (not
          (supervisor_stage_two_complete ?faculty_supervisor)
        )
      )
    :effect
      (and
        (supervisor_stage_two_complete ?faculty_supervisor)
        (supervisor_ready_for_assignment ?faculty_supervisor)
      )
  )
  (:action confirm_supervisor_stage_two_and_mark_ready_alternate
    :parameters (?faculty_supervisor - faculty_supervisor ?external_approval - external_approval ?application_document - application_document ?match_proposal - match_proposal)
    :precondition
      (and
        (supervisor_stage_one_complete ?faculty_supervisor)
        (supervisor_external_approval_link ?faculty_supervisor ?external_approval)
        (supervisor_document_association ?faculty_supervisor ?application_document)
        (document_attached_to_proposal ?application_document ?match_proposal)
        (not
          (proposal_quality_flag_1 ?match_proposal)
        )
        (proposal_quality_flag_2 ?match_proposal)
        (not
          (supervisor_stage_two_complete ?faculty_supervisor)
        )
      )
    :effect
      (and
        (supervisor_stage_two_complete ?faculty_supervisor)
        (supervisor_ready_for_assignment ?faculty_supervisor)
      )
  )
  (:action confirm_supervisor_stage_two_and_mark_ready_both
    :parameters (?faculty_supervisor - faculty_supervisor ?external_approval - external_approval ?application_document - application_document ?match_proposal - match_proposal)
    :precondition
      (and
        (supervisor_stage_one_complete ?faculty_supervisor)
        (supervisor_external_approval_link ?faculty_supervisor ?external_approval)
        (supervisor_document_association ?faculty_supervisor ?application_document)
        (document_attached_to_proposal ?application_document ?match_proposal)
        (proposal_quality_flag_1 ?match_proposal)
        (proposal_quality_flag_2 ?match_proposal)
        (not
          (supervisor_stage_two_complete ?faculty_supervisor)
        )
      )
    :effect
      (and
        (supervisor_stage_two_complete ?faculty_supervisor)
        (supervisor_ready_for_assignment ?faculty_supervisor)
      )
  )
  (:action authorize_supervisor_for_assignment
    :parameters (?faculty_supervisor - faculty_supervisor)
    :precondition
      (and
        (supervisor_stage_two_complete ?faculty_supervisor)
        (not
          (supervisor_ready_for_assignment ?faculty_supervisor)
        )
        (not
          (entity_authorized_for_closure ?faculty_supervisor)
        )
      )
    :effect
      (and
        (entity_authorized_for_closure ?faculty_supervisor)
        (entity_finalization_marker ?faculty_supervisor)
      )
  )
  (:action assign_evaluation_criterion_to_supervisor
    :parameters (?faculty_supervisor - faculty_supervisor ?evaluation_criterion - evaluation_criterion)
    :precondition
      (and
        (supervisor_stage_two_complete ?faculty_supervisor)
        (supervisor_ready_for_assignment ?faculty_supervisor)
        (criterion_available ?evaluation_criterion)
      )
    :effect
      (and
        (supervisor_criterion_link ?faculty_supervisor ?evaluation_criterion)
        (not
          (criterion_available ?evaluation_criterion)
        )
      )
  )
  (:action finalize_supervisor_final_checks
    :parameters (?faculty_supervisor - faculty_supervisor ?doctoral_candidate - doctoral_candidate ?masters_candidate - masters_candidate ?research_proposal - research_proposal ?evaluation_criterion - evaluation_criterion)
    :precondition
      (and
        (supervisor_stage_two_complete ?faculty_supervisor)
        (supervisor_ready_for_assignment ?faculty_supervisor)
        (supervisor_criterion_link ?faculty_supervisor ?evaluation_criterion)
        (supervisor_capacity_for_doctoral ?faculty_supervisor ?doctoral_candidate)
        (supervisor_capacity_for_masters ?faculty_supervisor ?masters_candidate)
        (doctoral_ready_for_pairing ?doctoral_candidate)
        (masters_ready_for_pairing ?masters_candidate)
        (entity_proposal_link ?faculty_supervisor ?research_proposal)
        (not
          (supervisor_final_checks_complete ?faculty_supervisor)
        )
      )
    :effect (supervisor_final_checks_complete ?faculty_supervisor)
  )
  (:action confirm_supervisor_authorization
    :parameters (?faculty_supervisor - faculty_supervisor)
    :precondition
      (and
        (supervisor_stage_two_complete ?faculty_supervisor)
        (supervisor_final_checks_complete ?faculty_supervisor)
        (not
          (entity_authorized_for_closure ?faculty_supervisor)
        )
      )
    :effect
      (and
        (entity_authorized_for_closure ?faculty_supervisor)
        (entity_finalization_marker ?faculty_supervisor)
      )
  )
  (:action initiate_supervisor_assignment_path
    :parameters (?faculty_supervisor - faculty_supervisor ?external_recommendation - external_recommendation ?research_proposal - research_proposal)
    :precondition
      (and
        (entity_verified ?faculty_supervisor)
        (entity_proposal_link ?faculty_supervisor ?research_proposal)
        (recommendation_available ?external_recommendation)
        (supervisor_recommendation_link ?faculty_supervisor ?external_recommendation)
        (not
          (supervisor_initiated_assignment_path ?faculty_supervisor)
        )
      )
    :effect
      (and
        (supervisor_initiated_assignment_path ?faculty_supervisor)
        (not
          (recommendation_available ?external_recommendation)
        )
      )
  )
  (:action prepare_supervisor_assignment
    :parameters (?faculty_supervisor - faculty_supervisor ?department_advisor - department_advisor)
    :precondition
      (and
        (supervisor_initiated_assignment_path ?faculty_supervisor)
        (entity_advisor_link ?faculty_supervisor ?department_advisor)
        (not
          (supervisor_assignment_prepared ?faculty_supervisor)
        )
      )
    :effect (supervisor_assignment_prepared ?faculty_supervisor)
  )
  (:action finalize_supervisor_assignment_with_approval
    :parameters (?faculty_supervisor - faculty_supervisor ?external_approval - external_approval)
    :precondition
      (and
        (supervisor_assignment_prepared ?faculty_supervisor)
        (supervisor_external_approval_link ?faculty_supervisor ?external_approval)
        (not
          (supervisor_assignment_finalized ?faculty_supervisor)
        )
      )
    :effect (supervisor_assignment_finalized ?faculty_supervisor)
  )
  (:action authorize_supervisor_closure
    :parameters (?faculty_supervisor - faculty_supervisor)
    :precondition
      (and
        (supervisor_assignment_finalized ?faculty_supervisor)
        (not
          (entity_authorized_for_closure ?faculty_supervisor)
        )
      )
    :effect
      (and
        (entity_authorized_for_closure ?faculty_supervisor)
        (entity_finalization_marker ?faculty_supervisor)
      )
  )
  (:action finalize_doctoral_candidate_assignment
    :parameters (?doctoral_candidate - doctoral_candidate ?match_proposal - match_proposal)
    :precondition
      (and
        (doctoral_candidate_prepared_flag ?doctoral_candidate)
        (doctoral_ready_for_pairing ?doctoral_candidate)
        (proposal_reserved ?match_proposal)
        (proposal_locked_for_assignment ?match_proposal)
        (not
          (entity_finalization_marker ?doctoral_candidate)
        )
      )
    :effect (entity_finalization_marker ?doctoral_candidate)
  )
  (:action finalize_masters_candidate_assignment
    :parameters (?masters_candidate - masters_candidate ?match_proposal - match_proposal)
    :precondition
      (and
        (masters_candidate_prepared_flag ?masters_candidate)
        (masters_ready_for_pairing ?masters_candidate)
        (proposal_reserved ?match_proposal)
        (proposal_locked_for_assignment ?match_proposal)
        (not
          (entity_finalization_marker ?masters_candidate)
        )
      )
    :effect (entity_finalization_marker ?masters_candidate)
  )
  (:action assign_special_requirement_to_case_and_mark_ready
    :parameters (?student_case - student_case ?special_requirement - special_requirement ?research_proposal - research_proposal)
    :precondition
      (and
        (entity_finalization_marker ?student_case)
        (entity_proposal_link ?student_case ?research_proposal)
        (special_requirement_available ?special_requirement)
        (not
          (entity_ready_for_assignment ?student_case)
        )
      )
    :effect
      (and
        (entity_ready_for_assignment ?student_case)
        (entity_special_requirement_link ?student_case ?special_requirement)
        (not
          (special_requirement_available ?special_requirement)
        )
      )
  )
  (:action confirm_doctoral_assignment_and_allocate_slot
    :parameters (?doctoral_candidate - doctoral_candidate ?supervision_slot - supervision_slot ?special_requirement - special_requirement)
    :precondition
      (and
        (entity_ready_for_assignment ?doctoral_candidate)
        (entity_assigned_to_supervision_slot ?doctoral_candidate ?supervision_slot)
        (entity_special_requirement_link ?doctoral_candidate ?special_requirement)
        (not
          (entity_match_confirmed ?doctoral_candidate)
        )
      )
    :effect
      (and
        (entity_match_confirmed ?doctoral_candidate)
        (supervision_slot_available ?supervision_slot)
        (special_requirement_available ?special_requirement)
      )
  )
  (:action confirm_masters_assignment_and_allocate_slot
    :parameters (?masters_candidate - masters_candidate ?supervision_slot - supervision_slot ?special_requirement - special_requirement)
    :precondition
      (and
        (entity_ready_for_assignment ?masters_candidate)
        (entity_assigned_to_supervision_slot ?masters_candidate ?supervision_slot)
        (entity_special_requirement_link ?masters_candidate ?special_requirement)
        (not
          (entity_match_confirmed ?masters_candidate)
        )
      )
    :effect
      (and
        (entity_match_confirmed ?masters_candidate)
        (supervision_slot_available ?supervision_slot)
        (special_requirement_available ?special_requirement)
      )
  )
  (:action confirm_assignment_by_supervisor
    :parameters (?faculty_supervisor - faculty_supervisor ?supervision_slot - supervision_slot ?special_requirement - special_requirement)
    :precondition
      (and
        (entity_ready_for_assignment ?faculty_supervisor)
        (entity_assigned_to_supervision_slot ?faculty_supervisor ?supervision_slot)
        (entity_special_requirement_link ?faculty_supervisor ?special_requirement)
        (not
          (entity_match_confirmed ?faculty_supervisor)
        )
      )
    :effect
      (and
        (entity_match_confirmed ?faculty_supervisor)
        (supervision_slot_available ?supervision_slot)
        (special_requirement_available ?special_requirement)
      )
  )
)

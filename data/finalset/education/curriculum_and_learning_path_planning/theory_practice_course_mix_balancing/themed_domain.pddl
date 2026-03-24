(define (domain curriculum_theory_practice_balance)
  (:requirements :strips :typing :negative-preconditions)
  (:types curriculum_component - object offering_component - object resource_type - object curriculum_element - object offering - curriculum_element teaching_facility - curriculum_component section_offering - curriculum_component instructor - curriculum_component industry_partner - curriculum_component elective_option - curriculum_component credit_token - curriculum_component practice_resource - curriculum_component capstone_advisor - curriculum_component practical_component - offering_component elective_module - offering_component accreditation_benchmark - offering_component theory_slot - resource_type practice_slot - resource_type academic_term - resource_type track_container - offering group_container - offering theory_track - track_container practice_track - track_container degree_plan - group_container)
  (:predicates
    (offering_registered ?course - offering)
    (offering_active ?course - offering)
    (offering_facility_assigned ?course - offering)
    (finalized ?course - offering)
    (credit_eligible ?course - offering)
    (credit_assigned ?course - offering)
    (facility_available ?facility - teaching_facility)
    (offering_facility_link ?course - offering ?facility - teaching_facility)
    (section_available ?section - section_offering)
    (offering_section_assigned ?course - offering ?section - section_offering)
    (instructor_available ?instructor - instructor)
    (offering_assigned_instructor ?course - offering ?instructor - instructor)
    (practical_component_available ?practical_component - practical_component)
    (theory_track_component_allocated ?theory_track - theory_track ?practical_component - practical_component)
    (practice_track_component_allocated ?practice_track - practice_track ?practical_component - practical_component)
    (track_has_theory_slot ?theory_track - theory_track ?theory_slot - theory_slot)
    (theory_slot_claimed ?theory_slot - theory_slot)
    (theory_slot_practical_component_bound ?theory_slot - theory_slot)
    (theory_track_ready ?theory_track - theory_track)
    (track_has_practice_slot ?practice_track - practice_track ?practice_slot - practice_slot)
    (practice_slot_claimed ?practice_slot - practice_slot)
    (practice_slot_practical_component_bound ?practice_slot - practice_slot)
    (practice_track_ready ?practice_track - practice_track)
    (term_available ?term - academic_term)
    (term_assembled ?term - academic_term)
    (term_includes_theory_slot ?term - academic_term ?theory_slot - theory_slot)
    (term_includes_practice_slot ?term - academic_term ?practice_slot - practice_slot)
    (term_theory_practical_integrated ?term - academic_term)
    (term_practice_practical_integrated ?term - academic_term)
    (term_ready_for_module_integration ?term - academic_term)
    (plan_includes_theory_track ?degree_plan - degree_plan ?theory_track - theory_track)
    (plan_includes_practice_track ?degree_plan - degree_plan ?practice_track - practice_track)
    (plan_scheduled_for_term ?degree_plan - degree_plan ?term - academic_term)
    (elective_module_available ?elective_module - elective_module)
    (plan_includes_elective_module ?degree_plan - degree_plan ?elective_module - elective_module)
    (elective_module_activated ?elective_module - elective_module)
    (elective_module_scheduled_in_term ?elective_module - elective_module ?term - academic_term)
    (plan_ready_for_resource_allocation ?degree_plan - degree_plan)
    (plan_resources_allocated ?degree_plan - degree_plan)
    (plan_activation_ready ?degree_plan - degree_plan)
    (plan_industry_partner_assigned ?degree_plan - degree_plan)
    (plan_industry_partner_registered ?degree_plan - degree_plan)
    (plan_elective_required ?degree_plan - degree_plan)
    (plan_preparation_completed ?degree_plan - degree_plan)
    (accreditation_benchmark_available ?accreditation_benchmark - accreditation_benchmark)
    (plan_has_accreditation_benchmark ?degree_plan - degree_plan ?accreditation_benchmark - accreditation_benchmark)
    (plan_accreditation_benchmark_assigned ?degree_plan - degree_plan)
    (plan_accreditation_review_started ?degree_plan - degree_plan)
    (plan_accreditation_review_completed ?degree_plan - degree_plan)
    (industry_partner_available ?industry_partner - industry_partner)
    (plan_industry_partner_link ?degree_plan - degree_plan ?industry_partner - industry_partner)
    (elective_option_available ?elective_option - elective_option)
    (plan_elective_assigned ?degree_plan - degree_plan ?elective_option - elective_option)
    (practice_resource_available ?practice_resource - practice_resource)
    (plan_allocated_practice_resource ?degree_plan - degree_plan ?practice_resource - practice_resource)
    (capstone_advisor_available ?capstone_advisor - capstone_advisor)
    (plan_assigned_capstone_advisor ?degree_plan - degree_plan ?capstone_advisor - capstone_advisor)
    (credit_token_available ?credit_token - credit_token)
    (has_credit_token ?course - offering ?credit_token - credit_token)
    (theory_track_component_confirmed ?theory_track - theory_track)
    (practice_track_component_confirmed ?practice_track - practice_track)
    (degree_awarded ?degree_plan - degree_plan)
  )
  (:action create_course_catalog_entry
    :parameters (?course - offering)
    :precondition
      (and
        (not
          (offering_registered ?course)
        )
        (not
          (finalized ?course)
        )
      )
    :effect (offering_registered ?course)
  )
  (:action assign_facility_to_course
    :parameters (?course - offering ?facility - teaching_facility)
    :precondition
      (and
        (offering_registered ?course)
        (not
          (offering_facility_assigned ?course)
        )
        (facility_available ?facility)
      )
    :effect
      (and
        (offering_facility_assigned ?course)
        (offering_facility_link ?course ?facility)
        (not
          (facility_available ?facility)
        )
      )
  )
  (:action attach_section_offering_to_course
    :parameters (?course - offering ?section - section_offering)
    :precondition
      (and
        (offering_registered ?course)
        (offering_facility_assigned ?course)
        (section_available ?section)
      )
    :effect
      (and
        (offering_section_assigned ?course ?section)
        (not
          (section_available ?section)
        )
      )
  )
  (:action finalize_course_offering
    :parameters (?course - offering ?section - section_offering)
    :precondition
      (and
        (offering_registered ?course)
        (offering_facility_assigned ?course)
        (offering_section_assigned ?course ?section)
        (not
          (offering_active ?course)
        )
      )
    :effect (offering_active ?course)
  )
  (:action detach_section_offering
    :parameters (?course - offering ?section - section_offering)
    :precondition
      (and
        (offering_section_assigned ?course ?section)
      )
    :effect
      (and
        (section_available ?section)
        (not
          (offering_section_assigned ?course ?section)
        )
      )
  )
  (:action assign_instructor_to_course
    :parameters (?course - offering ?instructor - instructor)
    :precondition
      (and
        (offering_active ?course)
        (instructor_available ?instructor)
      )
    :effect
      (and
        (offering_assigned_instructor ?course ?instructor)
        (not
          (instructor_available ?instructor)
        )
      )
  )
  (:action release_instructor_from_course
    :parameters (?course - offering ?instructor - instructor)
    :precondition
      (and
        (offering_assigned_instructor ?course ?instructor)
      )
    :effect
      (and
        (instructor_available ?instructor)
        (not
          (offering_assigned_instructor ?course ?instructor)
        )
      )
  )
  (:action allocate_practice_resource_to_plan
    :parameters (?degree_plan - degree_plan ?practice_resource - practice_resource)
    :precondition
      (and
        (offering_active ?degree_plan)
        (practice_resource_available ?practice_resource)
      )
    :effect
      (and
        (plan_allocated_practice_resource ?degree_plan ?practice_resource)
        (not
          (practice_resource_available ?practice_resource)
        )
      )
  )
  (:action release_practice_resource_from_plan
    :parameters (?degree_plan - degree_plan ?practice_resource - practice_resource)
    :precondition
      (and
        (plan_allocated_practice_resource ?degree_plan ?practice_resource)
      )
    :effect
      (and
        (practice_resource_available ?practice_resource)
        (not
          (plan_allocated_practice_resource ?degree_plan ?practice_resource)
        )
      )
  )
  (:action assign_capstone_advisor_to_plan
    :parameters (?degree_plan - degree_plan ?capstone_advisor - capstone_advisor)
    :precondition
      (and
        (offering_active ?degree_plan)
        (capstone_advisor_available ?capstone_advisor)
      )
    :effect
      (and
        (plan_assigned_capstone_advisor ?degree_plan ?capstone_advisor)
        (not
          (capstone_advisor_available ?capstone_advisor)
        )
      )
  )
  (:action remove_capstone_advisor_from_plan
    :parameters (?degree_plan - degree_plan ?capstone_advisor - capstone_advisor)
    :precondition
      (and
        (plan_assigned_capstone_advisor ?degree_plan ?capstone_advisor)
      )
    :effect
      (and
        (capstone_advisor_available ?capstone_advisor)
        (not
          (plan_assigned_capstone_advisor ?degree_plan ?capstone_advisor)
        )
      )
  )
  (:action claim_theory_slot_for_track
    :parameters (?theory_track - theory_track ?theory_slot - theory_slot ?section - section_offering)
    :precondition
      (and
        (offering_active ?theory_track)
        (offering_section_assigned ?theory_track ?section)
        (track_has_theory_slot ?theory_track ?theory_slot)
        (not
          (theory_slot_claimed ?theory_slot)
        )
        (not
          (theory_slot_practical_component_bound ?theory_slot)
        )
      )
    :effect (theory_slot_claimed ?theory_slot)
  )
  (:action confirm_theory_slot_with_instructor
    :parameters (?theory_track - theory_track ?theory_slot - theory_slot ?instructor - instructor)
    :precondition
      (and
        (offering_active ?theory_track)
        (offering_assigned_instructor ?theory_track ?instructor)
        (track_has_theory_slot ?theory_track ?theory_slot)
        (theory_slot_claimed ?theory_slot)
        (not
          (theory_track_component_confirmed ?theory_track)
        )
      )
    :effect
      (and
        (theory_track_component_confirmed ?theory_track)
        (theory_track_ready ?theory_track)
      )
  )
  (:action allocate_practical_component_to_theory_slot
    :parameters (?theory_track - theory_track ?theory_slot - theory_slot ?practical_component - practical_component)
    :precondition
      (and
        (offering_active ?theory_track)
        (track_has_theory_slot ?theory_track ?theory_slot)
        (practical_component_available ?practical_component)
        (not
          (theory_track_component_confirmed ?theory_track)
        )
      )
    :effect
      (and
        (theory_slot_practical_component_bound ?theory_slot)
        (theory_track_component_confirmed ?theory_track)
        (theory_track_component_allocated ?theory_track ?practical_component)
        (not
          (practical_component_available ?practical_component)
        )
      )
  )
  (:action finalize_theory_slot_assignment
    :parameters (?theory_track - theory_track ?theory_slot - theory_slot ?section - section_offering ?practical_component - practical_component)
    :precondition
      (and
        (offering_active ?theory_track)
        (offering_section_assigned ?theory_track ?section)
        (track_has_theory_slot ?theory_track ?theory_slot)
        (theory_slot_practical_component_bound ?theory_slot)
        (theory_track_component_allocated ?theory_track ?practical_component)
        (not
          (theory_track_ready ?theory_track)
        )
      )
    :effect
      (and
        (theory_slot_claimed ?theory_slot)
        (theory_track_ready ?theory_track)
        (practical_component_available ?practical_component)
        (not
          (theory_track_component_allocated ?theory_track ?practical_component)
        )
      )
  )
  (:action claim_practice_slot_for_track
    :parameters (?practice_track - practice_track ?practice_slot - practice_slot ?section - section_offering)
    :precondition
      (and
        (offering_active ?practice_track)
        (offering_section_assigned ?practice_track ?section)
        (track_has_practice_slot ?practice_track ?practice_slot)
        (not
          (practice_slot_claimed ?practice_slot)
        )
        (not
          (practice_slot_practical_component_bound ?practice_slot)
        )
      )
    :effect (practice_slot_claimed ?practice_slot)
  )
  (:action confirm_practice_slot_with_instructor
    :parameters (?practice_track - practice_track ?practice_slot - practice_slot ?instructor - instructor)
    :precondition
      (and
        (offering_active ?practice_track)
        (offering_assigned_instructor ?practice_track ?instructor)
        (track_has_practice_slot ?practice_track ?practice_slot)
        (practice_slot_claimed ?practice_slot)
        (not
          (practice_track_component_confirmed ?practice_track)
        )
      )
    :effect
      (and
        (practice_track_component_confirmed ?practice_track)
        (practice_track_ready ?practice_track)
      )
  )
  (:action allocate_practical_component_to_practice_slot
    :parameters (?practice_track - practice_track ?practice_slot - practice_slot ?practical_component - practical_component)
    :precondition
      (and
        (offering_active ?practice_track)
        (track_has_practice_slot ?practice_track ?practice_slot)
        (practical_component_available ?practical_component)
        (not
          (practice_track_component_confirmed ?practice_track)
        )
      )
    :effect
      (and
        (practice_slot_practical_component_bound ?practice_slot)
        (practice_track_component_confirmed ?practice_track)
        (practice_track_component_allocated ?practice_track ?practical_component)
        (not
          (practical_component_available ?practical_component)
        )
      )
  )
  (:action finalize_practice_slot_assignment
    :parameters (?practice_track - practice_track ?practice_slot - practice_slot ?section - section_offering ?practical_component - practical_component)
    :precondition
      (and
        (offering_active ?practice_track)
        (offering_section_assigned ?practice_track ?section)
        (track_has_practice_slot ?practice_track ?practice_slot)
        (practice_slot_practical_component_bound ?practice_slot)
        (practice_track_component_allocated ?practice_track ?practical_component)
        (not
          (practice_track_ready ?practice_track)
        )
      )
    :effect
      (and
        (practice_slot_claimed ?practice_slot)
        (practice_track_ready ?practice_track)
        (practical_component_available ?practical_component)
        (not
          (practice_track_component_allocated ?practice_track ?practical_component)
        )
      )
  )
  (:action assemble_academic_term
    :parameters (?theory_track - theory_track ?practice_track - practice_track ?theory_slot - theory_slot ?practice_slot - practice_slot ?term - academic_term)
    :precondition
      (and
        (theory_track_component_confirmed ?theory_track)
        (practice_track_component_confirmed ?practice_track)
        (track_has_theory_slot ?theory_track ?theory_slot)
        (track_has_practice_slot ?practice_track ?practice_slot)
        (theory_slot_claimed ?theory_slot)
        (practice_slot_claimed ?practice_slot)
        (theory_track_ready ?theory_track)
        (practice_track_ready ?practice_track)
        (term_available ?term)
      )
    :effect
      (and
        (term_assembled ?term)
        (term_includes_theory_slot ?term ?theory_slot)
        (term_includes_practice_slot ?term ?practice_slot)
        (not
          (term_available ?term)
        )
      )
  )
  (:action assemble_term_with_theory_practical_integration
    :parameters (?theory_track - theory_track ?practice_track - practice_track ?theory_slot - theory_slot ?practice_slot - practice_slot ?term - academic_term)
    :precondition
      (and
        (theory_track_component_confirmed ?theory_track)
        (practice_track_component_confirmed ?practice_track)
        (track_has_theory_slot ?theory_track ?theory_slot)
        (track_has_practice_slot ?practice_track ?practice_slot)
        (theory_slot_practical_component_bound ?theory_slot)
        (practice_slot_claimed ?practice_slot)
        (not
          (theory_track_ready ?theory_track)
        )
        (practice_track_ready ?practice_track)
        (term_available ?term)
      )
    :effect
      (and
        (term_assembled ?term)
        (term_includes_theory_slot ?term ?theory_slot)
        (term_includes_practice_slot ?term ?practice_slot)
        (term_theory_practical_integrated ?term)
        (not
          (term_available ?term)
        )
      )
  )
  (:action assemble_term_with_practice_component
    :parameters (?theory_track - theory_track ?practice_track - practice_track ?theory_slot - theory_slot ?practice_slot - practice_slot ?term - academic_term)
    :precondition
      (and
        (theory_track_component_confirmed ?theory_track)
        (practice_track_component_confirmed ?practice_track)
        (track_has_theory_slot ?theory_track ?theory_slot)
        (track_has_practice_slot ?practice_track ?practice_slot)
        (theory_slot_claimed ?theory_slot)
        (practice_slot_practical_component_bound ?practice_slot)
        (theory_track_ready ?theory_track)
        (not
          (practice_track_ready ?practice_track)
        )
        (term_available ?term)
      )
    :effect
      (and
        (term_assembled ?term)
        (term_includes_theory_slot ?term ?theory_slot)
        (term_includes_practice_slot ?term ?practice_slot)
        (term_practice_practical_integrated ?term)
        (not
          (term_available ?term)
        )
      )
  )
  (:action assemble_fully_integrated_term
    :parameters (?theory_track - theory_track ?practice_track - practice_track ?theory_slot - theory_slot ?practice_slot - practice_slot ?term - academic_term)
    :precondition
      (and
        (theory_track_component_confirmed ?theory_track)
        (practice_track_component_confirmed ?practice_track)
        (track_has_theory_slot ?theory_track ?theory_slot)
        (track_has_practice_slot ?practice_track ?practice_slot)
        (theory_slot_practical_component_bound ?theory_slot)
        (practice_slot_practical_component_bound ?practice_slot)
        (not
          (theory_track_ready ?theory_track)
        )
        (not
          (practice_track_ready ?practice_track)
        )
        (term_available ?term)
      )
    :effect
      (and
        (term_assembled ?term)
        (term_includes_theory_slot ?term ?theory_slot)
        (term_includes_practice_slot ?term ?practice_slot)
        (term_theory_practical_integrated ?term)
        (term_practice_practical_integrated ?term)
        (not
          (term_available ?term)
        )
      )
  )
  (:action confirm_term_session
    :parameters (?term - academic_term ?theory_track - theory_track ?section - section_offering)
    :precondition
      (and
        (term_assembled ?term)
        (theory_track_component_confirmed ?theory_track)
        (offering_section_assigned ?theory_track ?section)
        (not
          (term_ready_for_module_integration ?term)
        )
      )
    :effect (term_ready_for_module_integration ?term)
  )
  (:action integrate_elective_module_into_plan
    :parameters (?degree_plan - degree_plan ?elective_module - elective_module ?term - academic_term)
    :precondition
      (and
        (offering_active ?degree_plan)
        (plan_scheduled_for_term ?degree_plan ?term)
        (plan_includes_elective_module ?degree_plan ?elective_module)
        (elective_module_available ?elective_module)
        (term_assembled ?term)
        (term_ready_for_module_integration ?term)
        (not
          (elective_module_activated ?elective_module)
        )
      )
    :effect
      (and
        (elective_module_activated ?elective_module)
        (elective_module_scheduled_in_term ?elective_module ?term)
        (not
          (elective_module_available ?elective_module)
        )
      )
  )
  (:action authorize_module_activation_for_plan
    :parameters (?degree_plan - degree_plan ?elective_module - elective_module ?term - academic_term ?section - section_offering)
    :precondition
      (and
        (offering_active ?degree_plan)
        (plan_includes_elective_module ?degree_plan ?elective_module)
        (elective_module_activated ?elective_module)
        (elective_module_scheduled_in_term ?elective_module ?term)
        (offering_section_assigned ?degree_plan ?section)
        (not
          (term_theory_practical_integrated ?term)
        )
        (not
          (plan_ready_for_resource_allocation ?degree_plan)
        )
      )
    :effect (plan_ready_for_resource_allocation ?degree_plan)
  )
  (:action assign_industry_partner_to_plan
    :parameters (?degree_plan - degree_plan ?industry_partner - industry_partner)
    :precondition
      (and
        (offering_active ?degree_plan)
        (industry_partner_available ?industry_partner)
        (not
          (plan_industry_partner_assigned ?degree_plan)
        )
      )
    :effect
      (and
        (plan_industry_partner_assigned ?degree_plan)
        (plan_industry_partner_link ?degree_plan ?industry_partner)
        (not
          (industry_partner_available ?industry_partner)
        )
      )
  )
  (:action integrate_industry_partner_for_module
    :parameters (?degree_plan - degree_plan ?elective_module - elective_module ?term - academic_term ?section - section_offering ?industry_partner - industry_partner)
    :precondition
      (and
        (offering_active ?degree_plan)
        (plan_includes_elective_module ?degree_plan ?elective_module)
        (elective_module_activated ?elective_module)
        (elective_module_scheduled_in_term ?elective_module ?term)
        (offering_section_assigned ?degree_plan ?section)
        (term_theory_practical_integrated ?term)
        (plan_industry_partner_assigned ?degree_plan)
        (plan_industry_partner_link ?degree_plan ?industry_partner)
        (not
          (plan_ready_for_resource_allocation ?degree_plan)
        )
      )
    :effect
      (and
        (plan_ready_for_resource_allocation ?degree_plan)
        (plan_industry_partner_registered ?degree_plan)
      )
  )
  (:action assign_practice_resource_and_instructor_for_module
    :parameters (?degree_plan - degree_plan ?practice_resource - practice_resource ?instructor - instructor ?elective_module - elective_module ?term - academic_term)
    :precondition
      (and
        (plan_ready_for_resource_allocation ?degree_plan)
        (plan_allocated_practice_resource ?degree_plan ?practice_resource)
        (offering_assigned_instructor ?degree_plan ?instructor)
        (plan_includes_elective_module ?degree_plan ?elective_module)
        (elective_module_scheduled_in_term ?elective_module ?term)
        (not
          (term_practice_practical_integrated ?term)
        )
        (not
          (plan_resources_allocated ?degree_plan)
        )
      )
    :effect (plan_resources_allocated ?degree_plan)
  )
  (:action assign_practice_resource_and_instructor_for_module_confirmed
    :parameters (?degree_plan - degree_plan ?practice_resource - practice_resource ?instructor - instructor ?elective_module - elective_module ?term - academic_term)
    :precondition
      (and
        (plan_ready_for_resource_allocation ?degree_plan)
        (plan_allocated_practice_resource ?degree_plan ?practice_resource)
        (offering_assigned_instructor ?degree_plan ?instructor)
        (plan_includes_elective_module ?degree_plan ?elective_module)
        (elective_module_scheduled_in_term ?elective_module ?term)
        (term_practice_practical_integrated ?term)
        (not
          (plan_resources_allocated ?degree_plan)
        )
      )
    :effect (plan_resources_allocated ?degree_plan)
  )
  (:action mark_plan_activation_ready
    :parameters (?degree_plan - degree_plan ?capstone_advisor - capstone_advisor ?elective_module - elective_module ?term - academic_term)
    :precondition
      (and
        (plan_resources_allocated ?degree_plan)
        (plan_assigned_capstone_advisor ?degree_plan ?capstone_advisor)
        (plan_includes_elective_module ?degree_plan ?elective_module)
        (elective_module_scheduled_in_term ?elective_module ?term)
        (not
          (term_theory_practical_integrated ?term)
        )
        (not
          (term_practice_practical_integrated ?term)
        )
        (not
          (plan_activation_ready ?degree_plan)
        )
      )
    :effect (plan_activation_ready ?degree_plan)
  )
  (:action activate_module_and_require_elective_selection_a
    :parameters (?degree_plan - degree_plan ?capstone_advisor - capstone_advisor ?elective_module - elective_module ?term - academic_term)
    :precondition
      (and
        (plan_resources_allocated ?degree_plan)
        (plan_assigned_capstone_advisor ?degree_plan ?capstone_advisor)
        (plan_includes_elective_module ?degree_plan ?elective_module)
        (elective_module_scheduled_in_term ?elective_module ?term)
        (term_theory_practical_integrated ?term)
        (not
          (term_practice_practical_integrated ?term)
        )
        (not
          (plan_activation_ready ?degree_plan)
        )
      )
    :effect
      (and
        (plan_activation_ready ?degree_plan)
        (plan_elective_required ?degree_plan)
      )
  )
  (:action activate_module_and_require_elective_selection_b
    :parameters (?degree_plan - degree_plan ?capstone_advisor - capstone_advisor ?elective_module - elective_module ?term - academic_term)
    :precondition
      (and
        (plan_resources_allocated ?degree_plan)
        (plan_assigned_capstone_advisor ?degree_plan ?capstone_advisor)
        (plan_includes_elective_module ?degree_plan ?elective_module)
        (elective_module_scheduled_in_term ?elective_module ?term)
        (not
          (term_theory_practical_integrated ?term)
        )
        (term_practice_practical_integrated ?term)
        (not
          (plan_activation_ready ?degree_plan)
        )
      )
    :effect
      (and
        (plan_activation_ready ?degree_plan)
        (plan_elective_required ?degree_plan)
      )
  )
  (:action activate_module_and_require_elective_selection_c
    :parameters (?degree_plan - degree_plan ?capstone_advisor - capstone_advisor ?elective_module - elective_module ?term - academic_term)
    :precondition
      (and
        (plan_resources_allocated ?degree_plan)
        (plan_assigned_capstone_advisor ?degree_plan ?capstone_advisor)
        (plan_includes_elective_module ?degree_plan ?elective_module)
        (elective_module_scheduled_in_term ?elective_module ?term)
        (term_theory_practical_integrated ?term)
        (term_practice_practical_integrated ?term)
        (not
          (plan_activation_ready ?degree_plan)
        )
      )
    :effect
      (and
        (plan_activation_ready ?degree_plan)
        (plan_elective_required ?degree_plan)
      )
  )
  (:action award_plan_intermediate_milestone
    :parameters (?degree_plan - degree_plan)
    :precondition
      (and
        (plan_activation_ready ?degree_plan)
        (not
          (plan_elective_required ?degree_plan)
        )
        (not
          (degree_awarded ?degree_plan)
        )
      )
    :effect
      (and
        (degree_awarded ?degree_plan)
        (credit_eligible ?degree_plan)
      )
  )
  (:action select_elective_option_for_plan
    :parameters (?degree_plan - degree_plan ?elective_option - elective_option)
    :precondition
      (and
        (plan_activation_ready ?degree_plan)
        (plan_elective_required ?degree_plan)
        (elective_option_available ?elective_option)
      )
    :effect
      (and
        (plan_elective_assigned ?degree_plan ?elective_option)
        (not
          (elective_option_available ?elective_option)
        )
      )
  )
  (:action finalize_plan_preparation_for_activation
    :parameters (?degree_plan - degree_plan ?theory_track - theory_track ?practice_track - practice_track ?section - section_offering ?elective_option - elective_option)
    :precondition
      (and
        (plan_activation_ready ?degree_plan)
        (plan_elective_required ?degree_plan)
        (plan_elective_assigned ?degree_plan ?elective_option)
        (plan_includes_theory_track ?degree_plan ?theory_track)
        (plan_includes_practice_track ?degree_plan ?practice_track)
        (theory_track_ready ?theory_track)
        (practice_track_ready ?practice_track)
        (offering_section_assigned ?degree_plan ?section)
        (not
          (plan_preparation_completed ?degree_plan)
        )
      )
    :effect (plan_preparation_completed ?degree_plan)
  )
  (:action award_degree_for_plan
    :parameters (?degree_plan - degree_plan)
    :precondition
      (and
        (plan_activation_ready ?degree_plan)
        (plan_preparation_completed ?degree_plan)
        (not
          (degree_awarded ?degree_plan)
        )
      )
    :effect
      (and
        (degree_awarded ?degree_plan)
        (credit_eligible ?degree_plan)
      )
  )
  (:action assign_accreditation_benchmark_to_plan
    :parameters (?degree_plan - degree_plan ?accreditation_benchmark - accreditation_benchmark ?section - section_offering)
    :precondition
      (and
        (offering_active ?degree_plan)
        (offering_section_assigned ?degree_plan ?section)
        (accreditation_benchmark_available ?accreditation_benchmark)
        (plan_has_accreditation_benchmark ?degree_plan ?accreditation_benchmark)
        (not
          (plan_accreditation_benchmark_assigned ?degree_plan)
        )
      )
    :effect
      (and
        (plan_accreditation_benchmark_assigned ?degree_plan)
        (not
          (accreditation_benchmark_available ?accreditation_benchmark)
        )
      )
  )
  (:action initiate_accreditation_review_for_plan
    :parameters (?degree_plan - degree_plan ?instructor - instructor)
    :precondition
      (and
        (plan_accreditation_benchmark_assigned ?degree_plan)
        (offering_assigned_instructor ?degree_plan ?instructor)
        (not
          (plan_accreditation_review_started ?degree_plan)
        )
      )
    :effect (plan_accreditation_review_started ?degree_plan)
  )
  (:action complete_accreditation_review_for_plan
    :parameters (?degree_plan - degree_plan ?capstone_advisor - capstone_advisor)
    :precondition
      (and
        (plan_accreditation_review_started ?degree_plan)
        (plan_assigned_capstone_advisor ?degree_plan ?capstone_advisor)
        (not
          (plan_accreditation_review_completed ?degree_plan)
        )
      )
    :effect (plan_accreditation_review_completed ?degree_plan)
  )
  (:action finalize_plan_accreditation
    :parameters (?degree_plan - degree_plan)
    :precondition
      (and
        (plan_accreditation_review_completed ?degree_plan)
        (not
          (degree_awarded ?degree_plan)
        )
      )
    :effect
      (and
        (degree_awarded ?degree_plan)
        (credit_eligible ?degree_plan)
      )
  )
  (:action award_track_milestone
    :parameters (?theory_track - theory_track ?term - academic_term)
    :precondition
      (and
        (theory_track_component_confirmed ?theory_track)
        (theory_track_ready ?theory_track)
        (term_assembled ?term)
        (term_ready_for_module_integration ?term)
        (not
          (credit_eligible ?theory_track)
        )
      )
    :effect (credit_eligible ?theory_track)
  )
  (:action award_practice_track_milestone
    :parameters (?practice_track - practice_track ?term - academic_term)
    :precondition
      (and
        (practice_track_component_confirmed ?practice_track)
        (practice_track_ready ?practice_track)
        (term_assembled ?term)
        (term_ready_for_module_integration ?term)
        (not
          (credit_eligible ?practice_track)
        )
      )
    :effect (credit_eligible ?practice_track)
  )
  (:action assign_credit_to_course
    :parameters (?course - offering ?credit_token - credit_token ?section - section_offering)
    :precondition
      (and
        (credit_eligible ?course)
        (offering_section_assigned ?course ?section)
        (credit_token_available ?credit_token)
        (not
          (credit_assigned ?course)
        )
      )
    :effect
      (and
        (credit_assigned ?course)
        (has_credit_token ?course ?credit_token)
        (not
          (credit_token_available ?credit_token)
        )
      )
  )
  (:action finalize_theory_track_with_credit
    :parameters (?theory_track - theory_track ?facility - teaching_facility ?credit_token - credit_token)
    :precondition
      (and
        (credit_assigned ?theory_track)
        (offering_facility_link ?theory_track ?facility)
        (has_credit_token ?theory_track ?credit_token)
        (not
          (finalized ?theory_track)
        )
      )
    :effect
      (and
        (finalized ?theory_track)
        (facility_available ?facility)
        (credit_token_available ?credit_token)
      )
  )
  (:action finalize_practice_track_with_credit
    :parameters (?practice_track - practice_track ?facility - teaching_facility ?credit_token - credit_token)
    :precondition
      (and
        (credit_assigned ?practice_track)
        (offering_facility_link ?practice_track ?facility)
        (has_credit_token ?practice_track ?credit_token)
        (not
          (finalized ?practice_track)
        )
      )
    :effect
      (and
        (finalized ?practice_track)
        (facility_available ?facility)
        (credit_token_available ?credit_token)
      )
  )
  (:action finalize_degree_plan_with_credit
    :parameters (?degree_plan - degree_plan ?facility - teaching_facility ?credit_token - credit_token)
    :precondition
      (and
        (credit_assigned ?degree_plan)
        (offering_facility_link ?degree_plan ?facility)
        (has_credit_token ?degree_plan ?credit_token)
        (not
          (finalized ?degree_plan)
        )
      )
    :effect
      (and
        (finalized ?degree_plan)
        (facility_available ?facility)
        (credit_token_available ?credit_token)
      )
  )
)

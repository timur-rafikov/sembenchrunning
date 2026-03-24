(define (domain study_abroad_term_integration)
  (:requirements :strips :typing :negative-preconditions)
  (:types administrative_item - object organizational_unit - object resource - object application_container - object application_subject - application_container partner_university_slot - administrative_item course_proposal - administrative_item course_coordinator - administrative_item scholarship_offer - administrative_item predeparture_clearance - administrative_item immigration_document - administrative_item credit_transfer_item - administrative_item host_institution_approval - administrative_item credit_equivalency_proposal - organizational_unit host_course_listing - organizational_unit department_endorsement - organizational_unit home_term - resource host_term - resource placement_record - resource academic_unit - application_subject program - application_subject home_advisor - academic_unit host_advisor - academic_unit student - program)
  (:predicates
    (entity_initiated ?study_abroad_application - application_subject)
    (entity_approved ?study_abroad_application - application_subject)
    (entity_nominated ?study_abroad_application - application_subject)
    (mobility_record_finalized ?study_abroad_application - application_subject)
    (transcript_updated ?study_abroad_application - application_subject)
    (entity_ready_for_integration ?study_abroad_application - application_subject)
    (partner_slot_available ?partner_university_slot - partner_university_slot)
    (entity_assigned_slot ?study_abroad_application - application_subject ?partner_university_slot - partner_university_slot)
    (course_proposal_submitted ?course_proposal - course_proposal)
    (entity_contains_course_proposal ?study_abroad_application - application_subject ?course_proposal - course_proposal)
    (coordinator_available ?course_coordinator - course_coordinator)
    (entity_assigned_coordinator ?study_abroad_application - application_subject ?course_coordinator - course_coordinator)
    (credit_equivalency_proposal_available ?credit_equivalency_proposal - credit_equivalency_proposal)
    (advisor_recorded_equivalency_proposal ?home_advisor - home_advisor ?credit_equivalency_proposal - credit_equivalency_proposal)
    (host_advisor_recorded_equivalency_proposal ?host_advisor - host_advisor ?credit_equivalency_proposal - credit_equivalency_proposal)
    (advisor_assigned_home_term ?home_advisor - home_advisor ?home_term - home_term)
    (home_term_mapping_finalized ?home_term - home_term)
    (home_term_equivalency_attached ?home_term - home_term)
    (home_advisor_mapping_confirmed ?home_advisor - home_advisor)
    (host_advisor_assigned_host_term ?host_advisor - host_advisor ?host_term - host_term)
    (host_term_mapping_finalized ?host_term - host_term)
    (host_term_equivalency_attached ?host_term - host_term)
    (host_advisor_mapping_confirmed ?host_advisor - host_advisor)
    (placement_record_available ?placement_record - placement_record)
    (placement_record_claimed ?placement_record - placement_record)
    (placement_linked_home_term ?placement_record - placement_record ?home_term - home_term)
    (placement_linked_host_term ?placement_record - placement_record ?host_term - host_term)
    (placement_processed_by_home_office ?placement_record - placement_record)
    (placement_processed_by_host_office ?placement_record - placement_record)
    (placement_enrollment_confirmed ?placement_record - placement_record)
    (student_has_home_advisor ?student - student ?home_advisor - home_advisor)
    (student_has_host_advisor ?student - student ?host_advisor - host_advisor)
    (student_has_placement_record ?student - student ?placement_record - placement_record)
    (host_course_listing_available ?host_course_listing - host_course_listing)
    (student_selected_host_course ?student - student ?host_course_listing - host_course_listing)
    (host_course_enrollment_processed ?host_course_listing - host_course_listing)
    (host_course_linked_to_placement ?host_course_listing - host_course_listing ?placement_record - placement_record)
    (student_enrolled_on_host_course ?student - student)
    (student_credit_equivalency_submitted ?student - student)
    (credit_transfer_ready_for_finalization ?student - student)
    (student_claimed_scholarship ?student - student)
    (scholarship_verified_for_student ?student - student)
    (department_clearance_complete ?student - student)
    (academic_record_ready_for_finalization ?student - student)
    (department_endorsement_available ?department_endorsement - department_endorsement)
    (student_has_department_endorsement ?student - student ?department_endorsement - department_endorsement)
    (department_endorsement_committed ?student - student)
    (endorsement_routed_to_coordinator ?student - student)
    (host_institution_approval_recorded ?student - student)
    (scholarship_offer_available ?scholarship_offer - scholarship_offer)
    (student_received_scholarship_offer ?student - student ?scholarship_offer - scholarship_offer)
    (predeparture_clearance_available ?predeparture_clearance - predeparture_clearance)
    (student_has_predeparture_clearance ?student - student ?predeparture_clearance - predeparture_clearance)
    (credit_transfer_item_available ?credit_transfer_item - credit_transfer_item)
    (student_assigned_credit_transfer_item ?student - student ?credit_transfer_item - credit_transfer_item)
    (host_institution_approval_available ?host_institution_approval - host_institution_approval)
    (student_has_host_institution_approval ?student - student ?host_institution_approval - host_institution_approval)
    (immigration_document_available ?immigration_document - immigration_document)
    (entity_linked_immigration_document ?study_abroad_application - application_subject ?immigration_document - immigration_document)
    (home_advisor_ready ?home_advisor - home_advisor)
    (host_advisor_ready ?host_advisor - host_advisor)
    (mobility_finalization_recorded ?student - student)
  )
  (:action create_study_abroad_application
    :parameters (?study_abroad_application - application_subject)
    :precondition
      (and
        (not
          (entity_initiated ?study_abroad_application)
        )
        (not
          (mobility_record_finalized ?study_abroad_application)
        )
      )
    :effect (entity_initiated ?study_abroad_application)
  )
  (:action nominate_partner_slot_for_application
    :parameters (?study_abroad_application - application_subject ?partner_university_slot - partner_university_slot)
    :precondition
      (and
        (entity_initiated ?study_abroad_application)
        (not
          (entity_nominated ?study_abroad_application)
        )
        (partner_slot_available ?partner_university_slot)
      )
    :effect
      (and
        (entity_nominated ?study_abroad_application)
        (entity_assigned_slot ?study_abroad_application ?partner_university_slot)
        (not
          (partner_slot_available ?partner_university_slot)
        )
      )
  )
  (:action attach_course_proposal_to_application
    :parameters (?study_abroad_application - application_subject ?course_proposal - course_proposal)
    :precondition
      (and
        (entity_initiated ?study_abroad_application)
        (entity_nominated ?study_abroad_application)
        (course_proposal_submitted ?course_proposal)
      )
    :effect
      (and
        (entity_contains_course_proposal ?study_abroad_application ?course_proposal)
        (not
          (course_proposal_submitted ?course_proposal)
        )
      )
  )
  (:action approve_application_with_course_proposal
    :parameters (?study_abroad_application - application_subject ?course_proposal - course_proposal)
    :precondition
      (and
        (entity_initiated ?study_abroad_application)
        (entity_nominated ?study_abroad_application)
        (entity_contains_course_proposal ?study_abroad_application ?course_proposal)
        (not
          (entity_approved ?study_abroad_application)
        )
      )
    :effect (entity_approved ?study_abroad_application)
  )
  (:action detach_course_proposal_from_application
    :parameters (?study_abroad_application - application_subject ?course_proposal - course_proposal)
    :precondition
      (and
        (entity_contains_course_proposal ?study_abroad_application ?course_proposal)
      )
    :effect
      (and
        (course_proposal_submitted ?course_proposal)
        (not
          (entity_contains_course_proposal ?study_abroad_application ?course_proposal)
        )
      )
  )
  (:action assign_course_coordinator_to_application
    :parameters (?study_abroad_application - application_subject ?course_coordinator - course_coordinator)
    :precondition
      (and
        (entity_approved ?study_abroad_application)
        (coordinator_available ?course_coordinator)
      )
    :effect
      (and
        (entity_assigned_coordinator ?study_abroad_application ?course_coordinator)
        (not
          (coordinator_available ?course_coordinator)
        )
      )
  )
  (:action unassign_course_coordinator_from_application
    :parameters (?study_abroad_application - application_subject ?course_coordinator - course_coordinator)
    :precondition
      (and
        (entity_assigned_coordinator ?study_abroad_application ?course_coordinator)
      )
    :effect
      (and
        (coordinator_available ?course_coordinator)
        (not
          (entity_assigned_coordinator ?study_abroad_application ?course_coordinator)
        )
      )
  )
  (:action assign_credit_transfer_item_to_student
    :parameters (?student - student ?credit_transfer_item - credit_transfer_item)
    :precondition
      (and
        (entity_approved ?student)
        (credit_transfer_item_available ?credit_transfer_item)
      )
    :effect
      (and
        (student_assigned_credit_transfer_item ?student ?credit_transfer_item)
        (not
          (credit_transfer_item_available ?credit_transfer_item)
        )
      )
  )
  (:action unassign_credit_transfer_item_from_student
    :parameters (?student - student ?credit_transfer_item - credit_transfer_item)
    :precondition
      (and
        (student_assigned_credit_transfer_item ?student ?credit_transfer_item)
      )
    :effect
      (and
        (credit_transfer_item_available ?credit_transfer_item)
        (not
          (student_assigned_credit_transfer_item ?student ?credit_transfer_item)
        )
      )
  )
  (:action record_host_institution_approval_for_student
    :parameters (?student - student ?host_institution_approval - host_institution_approval)
    :precondition
      (and
        (entity_approved ?student)
        (host_institution_approval_available ?host_institution_approval)
      )
    :effect
      (and
        (student_has_host_institution_approval ?student ?host_institution_approval)
        (not
          (host_institution_approval_available ?host_institution_approval)
        )
      )
  )
  (:action revoke_host_institution_approval_for_student
    :parameters (?student - student ?host_institution_approval - host_institution_approval)
    :precondition
      (and
        (student_has_host_institution_approval ?student ?host_institution_approval)
      )
    :effect
      (and
        (host_institution_approval_available ?host_institution_approval)
        (not
          (student_has_host_institution_approval ?student ?host_institution_approval)
        )
      )
  )
  (:action home_advisor_register_course_proposal_for_home_term
    :parameters (?home_advisor - home_advisor ?home_term - home_term ?course_proposal - course_proposal)
    :precondition
      (and
        (entity_approved ?home_advisor)
        (entity_contains_course_proposal ?home_advisor ?course_proposal)
        (advisor_assigned_home_term ?home_advisor ?home_term)
        (not
          (home_term_mapping_finalized ?home_term)
        )
        (not
          (home_term_equivalency_attached ?home_term)
        )
      )
    :effect (home_term_mapping_finalized ?home_term)
  )
  (:action home_advisor_lock_home_term_mapping
    :parameters (?home_advisor - home_advisor ?home_term - home_term ?course_coordinator - course_coordinator)
    :precondition
      (and
        (entity_approved ?home_advisor)
        (entity_assigned_coordinator ?home_advisor ?course_coordinator)
        (advisor_assigned_home_term ?home_advisor ?home_term)
        (home_term_mapping_finalized ?home_term)
        (not
          (home_advisor_ready ?home_advisor)
        )
      )
    :effect
      (and
        (home_advisor_ready ?home_advisor)
        (home_advisor_mapping_confirmed ?home_advisor)
      )
  )
  (:action home_advisor_attach_equivalency_proposal_to_home_term
    :parameters (?home_advisor - home_advisor ?home_term - home_term ?credit_equivalency_proposal - credit_equivalency_proposal)
    :precondition
      (and
        (entity_approved ?home_advisor)
        (advisor_assigned_home_term ?home_advisor ?home_term)
        (credit_equivalency_proposal_available ?credit_equivalency_proposal)
        (not
          (home_advisor_ready ?home_advisor)
        )
      )
    :effect
      (and
        (home_term_equivalency_attached ?home_term)
        (home_advisor_ready ?home_advisor)
        (advisor_recorded_equivalency_proposal ?home_advisor ?credit_equivalency_proposal)
        (not
          (credit_equivalency_proposal_available ?credit_equivalency_proposal)
        )
      )
  )
  (:action home_advisor_finalize_home_term_equivalency_mapping
    :parameters (?home_advisor - home_advisor ?home_term - home_term ?course_proposal - course_proposal ?credit_equivalency_proposal - credit_equivalency_proposal)
    :precondition
      (and
        (entity_approved ?home_advisor)
        (entity_contains_course_proposal ?home_advisor ?course_proposal)
        (advisor_assigned_home_term ?home_advisor ?home_term)
        (home_term_equivalency_attached ?home_term)
        (advisor_recorded_equivalency_proposal ?home_advisor ?credit_equivalency_proposal)
        (not
          (home_advisor_mapping_confirmed ?home_advisor)
        )
      )
    :effect
      (and
        (home_term_mapping_finalized ?home_term)
        (home_advisor_mapping_confirmed ?home_advisor)
        (credit_equivalency_proposal_available ?credit_equivalency_proposal)
        (not
          (advisor_recorded_equivalency_proposal ?home_advisor ?credit_equivalency_proposal)
        )
      )
  )
  (:action host_advisor_mark_host_term_ready
    :parameters (?host_advisor - host_advisor ?host_term - host_term ?course_proposal - course_proposal)
    :precondition
      (and
        (entity_approved ?host_advisor)
        (entity_contains_course_proposal ?host_advisor ?course_proposal)
        (host_advisor_assigned_host_term ?host_advisor ?host_term)
        (not
          (host_term_mapping_finalized ?host_term)
        )
        (not
          (host_term_equivalency_attached ?host_term)
        )
      )
    :effect (host_term_mapping_finalized ?host_term)
  )
  (:action host_advisor_confirm_host_term_and_mark_ready
    :parameters (?host_advisor - host_advisor ?host_term - host_term ?course_coordinator - course_coordinator)
    :precondition
      (and
        (entity_approved ?host_advisor)
        (entity_assigned_coordinator ?host_advisor ?course_coordinator)
        (host_advisor_assigned_host_term ?host_advisor ?host_term)
        (host_term_mapping_finalized ?host_term)
        (not
          (host_advisor_ready ?host_advisor)
        )
      )
    :effect
      (and
        (host_advisor_ready ?host_advisor)
        (host_advisor_mapping_confirmed ?host_advisor)
      )
  )
  (:action host_advisor_attach_credit_equivalency_proposal_to_host_term
    :parameters (?host_advisor - host_advisor ?host_term - host_term ?credit_equivalency_proposal - credit_equivalency_proposal)
    :precondition
      (and
        (entity_approved ?host_advisor)
        (host_advisor_assigned_host_term ?host_advisor ?host_term)
        (credit_equivalency_proposal_available ?credit_equivalency_proposal)
        (not
          (host_advisor_ready ?host_advisor)
        )
      )
    :effect
      (and
        (host_term_equivalency_attached ?host_term)
        (host_advisor_ready ?host_advisor)
        (host_advisor_recorded_equivalency_proposal ?host_advisor ?credit_equivalency_proposal)
        (not
          (credit_equivalency_proposal_available ?credit_equivalency_proposal)
        )
      )
  )
  (:action host_advisor_finalize_host_course_equivalency
    :parameters (?host_advisor - host_advisor ?host_term - host_term ?course_proposal - course_proposal ?credit_equivalency_proposal - credit_equivalency_proposal)
    :precondition
      (and
        (entity_approved ?host_advisor)
        (entity_contains_course_proposal ?host_advisor ?course_proposal)
        (host_advisor_assigned_host_term ?host_advisor ?host_term)
        (host_term_equivalency_attached ?host_term)
        (host_advisor_recorded_equivalency_proposal ?host_advisor ?credit_equivalency_proposal)
        (not
          (host_advisor_mapping_confirmed ?host_advisor)
        )
      )
    :effect
      (and
        (host_term_mapping_finalized ?host_term)
        (host_advisor_mapping_confirmed ?host_advisor)
        (credit_equivalency_proposal_available ?credit_equivalency_proposal)
        (not
          (host_advisor_recorded_equivalency_proposal ?host_advisor ?credit_equivalency_proposal)
        )
      )
  )
  (:action allocate_placement_record
    :parameters (?home_advisor - home_advisor ?host_advisor - host_advisor ?home_term - home_term ?host_term - host_term ?placement_record - placement_record)
    :precondition
      (and
        (home_advisor_ready ?home_advisor)
        (host_advisor_ready ?host_advisor)
        (advisor_assigned_home_term ?home_advisor ?home_term)
        (host_advisor_assigned_host_term ?host_advisor ?host_term)
        (home_term_mapping_finalized ?home_term)
        (host_term_mapping_finalized ?host_term)
        (home_advisor_mapping_confirmed ?home_advisor)
        (host_advisor_mapping_confirmed ?host_advisor)
        (placement_record_available ?placement_record)
      )
    :effect
      (and
        (placement_record_claimed ?placement_record)
        (placement_linked_home_term ?placement_record ?home_term)
        (placement_linked_host_term ?placement_record ?host_term)
        (not
          (placement_record_available ?placement_record)
        )
      )
  )
  (:action allocate_placement_record_with_home_equivalency
    :parameters (?home_advisor - home_advisor ?host_advisor - host_advisor ?home_term - home_term ?host_term - host_term ?placement_record - placement_record)
    :precondition
      (and
        (home_advisor_ready ?home_advisor)
        (host_advisor_ready ?host_advisor)
        (advisor_assigned_home_term ?home_advisor ?home_term)
        (host_advisor_assigned_host_term ?host_advisor ?host_term)
        (home_term_equivalency_attached ?home_term)
        (host_term_mapping_finalized ?host_term)
        (not
          (home_advisor_mapping_confirmed ?home_advisor)
        )
        (host_advisor_mapping_confirmed ?host_advisor)
        (placement_record_available ?placement_record)
      )
    :effect
      (and
        (placement_record_claimed ?placement_record)
        (placement_linked_home_term ?placement_record ?home_term)
        (placement_linked_host_term ?placement_record ?host_term)
        (placement_processed_by_home_office ?placement_record)
        (not
          (placement_record_available ?placement_record)
        )
      )
  )
  (:action allocate_placement_record_with_host_equivalency
    :parameters (?home_advisor - home_advisor ?host_advisor - host_advisor ?home_term - home_term ?host_term - host_term ?placement_record - placement_record)
    :precondition
      (and
        (home_advisor_ready ?home_advisor)
        (host_advisor_ready ?host_advisor)
        (advisor_assigned_home_term ?home_advisor ?home_term)
        (host_advisor_assigned_host_term ?host_advisor ?host_term)
        (home_term_mapping_finalized ?home_term)
        (host_term_equivalency_attached ?host_term)
        (home_advisor_mapping_confirmed ?home_advisor)
        (not
          (host_advisor_mapping_confirmed ?host_advisor)
        )
        (placement_record_available ?placement_record)
      )
    :effect
      (and
        (placement_record_claimed ?placement_record)
        (placement_linked_home_term ?placement_record ?home_term)
        (placement_linked_host_term ?placement_record ?host_term)
        (placement_processed_by_host_office ?placement_record)
        (not
          (placement_record_available ?placement_record)
        )
      )
  )
  (:action allocate_placement_record_with_both_equivalencies
    :parameters (?home_advisor - home_advisor ?host_advisor - host_advisor ?home_term - home_term ?host_term - host_term ?placement_record - placement_record)
    :precondition
      (and
        (home_advisor_ready ?home_advisor)
        (host_advisor_ready ?host_advisor)
        (advisor_assigned_home_term ?home_advisor ?home_term)
        (host_advisor_assigned_host_term ?host_advisor ?host_term)
        (home_term_equivalency_attached ?home_term)
        (host_term_equivalency_attached ?host_term)
        (not
          (home_advisor_mapping_confirmed ?home_advisor)
        )
        (not
          (host_advisor_mapping_confirmed ?host_advisor)
        )
        (placement_record_available ?placement_record)
      )
    :effect
      (and
        (placement_record_claimed ?placement_record)
        (placement_linked_home_term ?placement_record ?home_term)
        (placement_linked_host_term ?placement_record ?host_term)
        (placement_processed_by_home_office ?placement_record)
        (placement_processed_by_host_office ?placement_record)
        (not
          (placement_record_available ?placement_record)
        )
      )
  )
  (:action confirm_placement_enrollment_for_student
    :parameters (?placement_record - placement_record ?home_advisor - home_advisor ?course_proposal - course_proposal)
    :precondition
      (and
        (placement_record_claimed ?placement_record)
        (home_advisor_ready ?home_advisor)
        (entity_contains_course_proposal ?home_advisor ?course_proposal)
        (not
          (placement_enrollment_confirmed ?placement_record)
        )
      )
    :effect (placement_enrollment_confirmed ?placement_record)
  )
  (:action enroll_host_course_and_create_transfer_item
    :parameters (?student - student ?host_course_listing - host_course_listing ?placement_record - placement_record)
    :precondition
      (and
        (entity_approved ?student)
        (student_has_placement_record ?student ?placement_record)
        (student_selected_host_course ?student ?host_course_listing)
        (host_course_listing_available ?host_course_listing)
        (placement_record_claimed ?placement_record)
        (placement_enrollment_confirmed ?placement_record)
        (not
          (host_course_enrollment_processed ?host_course_listing)
        )
      )
    :effect
      (and
        (host_course_enrollment_processed ?host_course_listing)
        (host_course_linked_to_placement ?host_course_listing ?placement_record)
        (not
          (host_course_listing_available ?host_course_listing)
        )
      )
  )
  (:action confirm_student_enrollment_for_host_course
    :parameters (?student - student ?host_course_listing - host_course_listing ?placement_record - placement_record ?course_proposal - course_proposal)
    :precondition
      (and
        (entity_approved ?student)
        (student_selected_host_course ?student ?host_course_listing)
        (host_course_enrollment_processed ?host_course_listing)
        (host_course_linked_to_placement ?host_course_listing ?placement_record)
        (entity_contains_course_proposal ?student ?course_proposal)
        (not
          (placement_processed_by_home_office ?placement_record)
        )
        (not
          (student_enrolled_on_host_course ?student)
        )
      )
    :effect (student_enrolled_on_host_course ?student)
  )
  (:action claim_scholarship_offer_for_student
    :parameters (?student - student ?scholarship_offer - scholarship_offer)
    :precondition
      (and
        (entity_approved ?student)
        (scholarship_offer_available ?scholarship_offer)
        (not
          (student_claimed_scholarship ?student)
        )
      )
    :effect
      (and
        (student_claimed_scholarship ?student)
        (student_received_scholarship_offer ?student ?scholarship_offer)
        (not
          (scholarship_offer_available ?scholarship_offer)
        )
      )
  )
  (:action validate_scholarship_and_enrollment_for_student
    :parameters (?student - student ?host_course_listing - host_course_listing ?placement_record - placement_record ?course_proposal - course_proposal ?scholarship_offer - scholarship_offer)
    :precondition
      (and
        (entity_approved ?student)
        (student_selected_host_course ?student ?host_course_listing)
        (host_course_enrollment_processed ?host_course_listing)
        (host_course_linked_to_placement ?host_course_listing ?placement_record)
        (entity_contains_course_proposal ?student ?course_proposal)
        (placement_processed_by_home_office ?placement_record)
        (student_claimed_scholarship ?student)
        (student_received_scholarship_offer ?student ?scholarship_offer)
        (not
          (student_enrolled_on_host_course ?student)
        )
      )
    :effect
      (and
        (student_enrolled_on_host_course ?student)
        (scholarship_verified_for_student ?student)
      )
  )
  (:action submit_credit_equivalency_for_review
    :parameters (?student - student ?credit_transfer_item - credit_transfer_item ?course_coordinator - course_coordinator ?host_course_listing - host_course_listing ?placement_record - placement_record)
    :precondition
      (and
        (student_enrolled_on_host_course ?student)
        (student_assigned_credit_transfer_item ?student ?credit_transfer_item)
        (entity_assigned_coordinator ?student ?course_coordinator)
        (student_selected_host_course ?student ?host_course_listing)
        (host_course_linked_to_placement ?host_course_listing ?placement_record)
        (not
          (placement_processed_by_host_office ?placement_record)
        )
        (not
          (student_credit_equivalency_submitted ?student)
        )
      )
    :effect (student_credit_equivalency_submitted ?student)
  )
  (:action submit_credit_equivalency_for_review_stage2
    :parameters (?student - student ?credit_transfer_item - credit_transfer_item ?course_coordinator - course_coordinator ?host_course_listing - host_course_listing ?placement_record - placement_record)
    :precondition
      (and
        (student_enrolled_on_host_course ?student)
        (student_assigned_credit_transfer_item ?student ?credit_transfer_item)
        (entity_assigned_coordinator ?student ?course_coordinator)
        (student_selected_host_course ?student ?host_course_listing)
        (host_course_linked_to_placement ?host_course_listing ?placement_record)
        (placement_processed_by_host_office ?placement_record)
        (not
          (student_credit_equivalency_submitted ?student)
        )
      )
    :effect (student_credit_equivalency_submitted ?student)
  )
  (:action initiate_credit_transfer_finalization
    :parameters (?student - student ?host_institution_approval - host_institution_approval ?host_course_listing - host_course_listing ?placement_record - placement_record)
    :precondition
      (and
        (student_credit_equivalency_submitted ?student)
        (student_has_host_institution_approval ?student ?host_institution_approval)
        (student_selected_host_course ?student ?host_course_listing)
        (host_course_linked_to_placement ?host_course_listing ?placement_record)
        (not
          (placement_processed_by_home_office ?placement_record)
        )
        (not
          (placement_processed_by_host_office ?placement_record)
        )
        (not
          (credit_transfer_ready_for_finalization ?student)
        )
      )
    :effect (credit_transfer_ready_for_finalization ?student)
  )
  (:action initiate_credit_transfer_finalization_with_home_approval
    :parameters (?student - student ?host_institution_approval - host_institution_approval ?host_course_listing - host_course_listing ?placement_record - placement_record)
    :precondition
      (and
        (student_credit_equivalency_submitted ?student)
        (student_has_host_institution_approval ?student ?host_institution_approval)
        (student_selected_host_course ?student ?host_course_listing)
        (host_course_linked_to_placement ?host_course_listing ?placement_record)
        (placement_processed_by_home_office ?placement_record)
        (not
          (placement_processed_by_host_office ?placement_record)
        )
        (not
          (credit_transfer_ready_for_finalization ?student)
        )
      )
    :effect
      (and
        (credit_transfer_ready_for_finalization ?student)
        (department_clearance_complete ?student)
      )
  )
  (:action initiate_credit_transfer_finalization_with_host_approval
    :parameters (?student - student ?host_institution_approval - host_institution_approval ?host_course_listing - host_course_listing ?placement_record - placement_record)
    :precondition
      (and
        (student_credit_equivalency_submitted ?student)
        (student_has_host_institution_approval ?student ?host_institution_approval)
        (student_selected_host_course ?student ?host_course_listing)
        (host_course_linked_to_placement ?host_course_listing ?placement_record)
        (not
          (placement_processed_by_home_office ?placement_record)
        )
        (placement_processed_by_host_office ?placement_record)
        (not
          (credit_transfer_ready_for_finalization ?student)
        )
      )
    :effect
      (and
        (credit_transfer_ready_for_finalization ?student)
        (department_clearance_complete ?student)
      )
  )
  (:action initiate_credit_transfer_finalization_with_full_approvals
    :parameters (?student - student ?host_institution_approval - host_institution_approval ?host_course_listing - host_course_listing ?placement_record - placement_record)
    :precondition
      (and
        (student_credit_equivalency_submitted ?student)
        (student_has_host_institution_approval ?student ?host_institution_approval)
        (student_selected_host_course ?student ?host_course_listing)
        (host_course_linked_to_placement ?host_course_listing ?placement_record)
        (placement_processed_by_home_office ?placement_record)
        (placement_processed_by_host_office ?placement_record)
        (not
          (credit_transfer_ready_for_finalization ?student)
        )
      )
    :effect
      (and
        (credit_transfer_ready_for_finalization ?student)
        (department_clearance_complete ?student)
      )
  )
  (:action finalize_mobility_and_update_transcript
    :parameters (?student - student)
    :precondition
      (and
        (credit_transfer_ready_for_finalization ?student)
        (not
          (department_clearance_complete ?student)
        )
        (not
          (mobility_finalization_recorded ?student)
        )
      )
    :effect
      (and
        (mobility_finalization_recorded ?student)
        (transcript_updated ?student)
      )
  )
  (:action record_predeparture_clearance_for_student
    :parameters (?student - student ?predeparture_clearance - predeparture_clearance)
    :precondition
      (and
        (credit_transfer_ready_for_finalization ?student)
        (department_clearance_complete ?student)
        (predeparture_clearance_available ?predeparture_clearance)
      )
    :effect
      (and
        (student_has_predeparture_clearance ?student ?predeparture_clearance)
        (not
          (predeparture_clearance_available ?predeparture_clearance)
        )
      )
  )
  (:action consolidate_equivalencies_for_transcript_update
    :parameters (?student - student ?home_advisor - home_advisor ?host_advisor - host_advisor ?course_proposal - course_proposal ?predeparture_clearance - predeparture_clearance)
    :precondition
      (and
        (credit_transfer_ready_for_finalization ?student)
        (department_clearance_complete ?student)
        (student_has_predeparture_clearance ?student ?predeparture_clearance)
        (student_has_home_advisor ?student ?home_advisor)
        (student_has_host_advisor ?student ?host_advisor)
        (home_advisor_mapping_confirmed ?home_advisor)
        (host_advisor_mapping_confirmed ?host_advisor)
        (entity_contains_course_proposal ?student ?course_proposal)
        (not
          (academic_record_ready_for_finalization ?student)
        )
      )
    :effect (academic_record_ready_for_finalization ?student)
  )
  (:action finalize_transcript_update_after_consolidation
    :parameters (?student - student)
    :precondition
      (and
        (credit_transfer_ready_for_finalization ?student)
        (academic_record_ready_for_finalization ?student)
        (not
          (mobility_finalization_recorded ?student)
        )
      )
    :effect
      (and
        (mobility_finalization_recorded ?student)
        (transcript_updated ?student)
      )
  )
  (:action student_claim_department_endorsement
    :parameters (?student - student ?department_endorsement - department_endorsement ?course_proposal - course_proposal)
    :precondition
      (and
        (entity_approved ?student)
        (entity_contains_course_proposal ?student ?course_proposal)
        (department_endorsement_available ?department_endorsement)
        (student_has_department_endorsement ?student ?department_endorsement)
        (not
          (department_endorsement_committed ?student)
        )
      )
    :effect
      (and
        (department_endorsement_committed ?student)
        (not
          (department_endorsement_available ?department_endorsement)
        )
      )
  )
  (:action route_endorsement_to_coordinator
    :parameters (?student - student ?course_coordinator - course_coordinator)
    :precondition
      (and
        (department_endorsement_committed ?student)
        (entity_assigned_coordinator ?student ?course_coordinator)
        (not
          (endorsement_routed_to_coordinator ?student)
        )
      )
    :effect (endorsement_routed_to_coordinator ?student)
  )
  (:action record_host_approval_for_endorsement
    :parameters (?student - student ?host_institution_approval - host_institution_approval)
    :precondition
      (and
        (endorsement_routed_to_coordinator ?student)
        (student_has_host_institution_approval ?student ?host_institution_approval)
        (not
          (host_institution_approval_recorded ?student)
        )
      )
    :effect (host_institution_approval_recorded ?student)
  )
  (:action finalize_mobility_post_host_approval
    :parameters (?student - student)
    :precondition
      (and
        (host_institution_approval_recorded ?student)
        (not
          (mobility_finalization_recorded ?student)
        )
      )
    :effect
      (and
        (mobility_finalization_recorded ?student)
        (transcript_updated ?student)
      )
  )
  (:action home_advisor_apply_credit_transfer_to_student_record
    :parameters (?home_advisor - home_advisor ?placement_record - placement_record)
    :precondition
      (and
        (home_advisor_ready ?home_advisor)
        (home_advisor_mapping_confirmed ?home_advisor)
        (placement_record_claimed ?placement_record)
        (placement_enrollment_confirmed ?placement_record)
        (not
          (transcript_updated ?home_advisor)
        )
      )
    :effect (transcript_updated ?home_advisor)
  )
  (:action host_advisor_apply_credit_transfer_to_student_record
    :parameters (?host_advisor - host_advisor ?placement_record - placement_record)
    :precondition
      (and
        (host_advisor_ready ?host_advisor)
        (host_advisor_mapping_confirmed ?host_advisor)
        (placement_record_claimed ?placement_record)
        (placement_enrollment_confirmed ?placement_record)
        (not
          (transcript_updated ?host_advisor)
        )
      )
    :effect (transcript_updated ?host_advisor)
  )
  (:action link_immigration_document_to_application
    :parameters (?study_abroad_application - application_subject ?immigration_document - immigration_document ?course_proposal - course_proposal)
    :precondition
      (and
        (transcript_updated ?study_abroad_application)
        (entity_contains_course_proposal ?study_abroad_application ?course_proposal)
        (immigration_document_available ?immigration_document)
        (not
          (entity_ready_for_integration ?study_abroad_application)
        )
      )
    :effect
      (and
        (entity_ready_for_integration ?study_abroad_application)
        (entity_linked_immigration_document ?study_abroad_application ?immigration_document)
        (not
          (immigration_document_available ?immigration_document)
        )
      )
  )
  (:action home_advisor_finalize_application_and_claim_slot
    :parameters (?home_advisor - home_advisor ?partner_university_slot - partner_university_slot ?immigration_document - immigration_document)
    :precondition
      (and
        (entity_ready_for_integration ?home_advisor)
        (entity_assigned_slot ?home_advisor ?partner_university_slot)
        (entity_linked_immigration_document ?home_advisor ?immigration_document)
        (not
          (mobility_record_finalized ?home_advisor)
        )
      )
    :effect
      (and
        (mobility_record_finalized ?home_advisor)
        (partner_slot_available ?partner_university_slot)
        (immigration_document_available ?immigration_document)
      )
  )
  (:action host_advisor_finalize_application_and_claim_slot
    :parameters (?host_advisor - host_advisor ?partner_university_slot - partner_university_slot ?immigration_document - immigration_document)
    :precondition
      (and
        (entity_ready_for_integration ?host_advisor)
        (entity_assigned_slot ?host_advisor ?partner_university_slot)
        (entity_linked_immigration_document ?host_advisor ?immigration_document)
        (not
          (mobility_record_finalized ?host_advisor)
        )
      )
    :effect
      (and
        (mobility_record_finalized ?host_advisor)
        (partner_slot_available ?partner_university_slot)
        (immigration_document_available ?immigration_document)
      )
  )
  (:action student_finalize_application_and_claim_slot
    :parameters (?student - student ?partner_university_slot - partner_university_slot ?immigration_document - immigration_document)
    :precondition
      (and
        (entity_ready_for_integration ?student)
        (entity_assigned_slot ?student ?partner_university_slot)
        (entity_linked_immigration_document ?student ?immigration_document)
        (not
          (mobility_record_finalized ?student)
        )
      )
    :effect
      (and
        (mobility_record_finalized ?student)
        (partner_slot_available ?partner_university_slot)
        (immigration_document_available ?immigration_document)
      )
  )
)

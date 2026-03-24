(define (domain culling_candidate_review)
  (:requirements :strips :typing :negative-preconditions)
  (:types farm_entity_subtype - object resource_subtype - object infrastructure_subtype - object animal_root - object animal_candidate - animal_root holding_pen - farm_entity_subtype inspector - farm_entity_subtype veterinary_officer - farm_entity_subtype selection_criterion - farm_entity_subtype authorization_form - farm_entity_subtype abattoir_slot - farm_entity_subtype medical_treatment_kit - farm_entity_subtype senior_veterinary_approval - farm_entity_subtype sample_kit - resource_subtype lab_sample - resource_subtype ear_tag - resource_subtype assessment_stall_primary - infrastructure_subtype assessment_stall_secondary - infrastructure_subtype submission_batch - infrastructure_subtype grouping_subtype - animal_candidate case_subtype - animal_candidate production_group - grouping_subtype management_group - grouping_subtype culling_case_record - case_subtype)
  (:predicates
    (candidate_identified ?animal - animal_candidate)
    (inspection_completed ?animal - animal_candidate)
    (staged_in_holding_pen ?animal - animal_candidate)
    (disposition_finalized ?animal - animal_candidate)
    (approved_for_culling ?animal - animal_candidate)
    (abattoir_slot_reserved ?animal - animal_candidate)
    (holding_pen_available ?holding_pen - holding_pen)
    (assigned_to_holding_pen ?animal - animal_candidate ?holding_pen - holding_pen)
    (inspector_available ?inspector - inspector)
    (inspected_by ?animal - animal_candidate ?inspector - inspector)
    (veterinarian_available ?veterinarian - veterinary_officer)
    (veterinarian_assigned ?animal - animal_candidate ?veterinarian - veterinary_officer)
    (sample_kit_available ?sample_kit - sample_kit)
    (production_group_sample_kit_assigned ?production_group - production_group ?sample_kit - sample_kit)
    (management_group_sample_kit_assigned ?management_group - management_group ?sample_kit - sample_kit)
    (production_group_assigned_primary_stall ?production_group - production_group ?primary_stall - assessment_stall_primary)
    (primary_stall_ready ?primary_stall - assessment_stall_primary)
    (primary_stall_prepared_with_sample_kit ?primary_stall - assessment_stall_primary)
    (production_group_assessment_completed ?production_group - production_group)
    (management_group_assigned_secondary_stall ?management_group - management_group ?secondary_stall - assessment_stall_secondary)
    (secondary_stall_ready ?secondary_stall - assessment_stall_secondary)
    (secondary_stall_prepared_with_sample_kit ?secondary_stall - assessment_stall_secondary)
    (management_group_assessment_completed ?management_group - management_group)
    (submission_batch_available ?submission_batch - submission_batch)
    (submission_batch_marked_ready ?submission_batch - submission_batch)
    (batch_includes_primary_stall ?submission_batch - submission_batch ?primary_stall - assessment_stall_primary)
    (batch_includes_secondary_stall ?submission_batch - submission_batch ?secondary_stall - assessment_stall_secondary)
    (batch_has_prepared_primary_stall ?submission_batch - submission_batch)
    (batch_has_prepared_secondary_stall ?submission_batch - submission_batch)
    (submission_batch_locked_for_lab ?submission_batch - submission_batch)
    (case_record_source_production_group ?case_record - culling_case_record ?production_group - production_group)
    (case_record_source_management_group ?case_record - culling_case_record ?management_group - management_group)
    (case_assigned_to_submission_batch ?case_record - culling_case_record ?submission_batch - submission_batch)
    (lab_sample_available ?lab_sample - lab_sample)
    (case_has_lab_sample_assigned ?case_record - culling_case_record ?lab_sample - lab_sample)
    (lab_sample_received ?lab_sample - lab_sample)
    (sample_in_submission_batch ?lab_sample - lab_sample ?submission_batch - submission_batch)
    (lab_results_ready_for_case ?case_record - culling_case_record)
    (treatment_applied_to_case ?case_record - culling_case_record)
    (case_ready_for_final_review ?case_record - culling_case_record)
    (case_has_selection_criterion ?case_record - culling_case_record)
    (selection_criterion_verified_for_case ?case_record - culling_case_record)
    (administrative_checks_passed ?case_record - culling_case_record)
    (administrative_authorization_applied ?case_record - culling_case_record)
    (ear_tag_available ?ear_tag - ear_tag)
    (case_assigned_ear_tag ?case_record - culling_case_record ?ear_tag - ear_tag)
    (ear_tag_attached ?case_record - culling_case_record)
    (veterinarian_confirmed_ear_tagging ?case_record - culling_case_record)
    (senior_veterinarian_ear_tag_approval ?case_record - culling_case_record)
    (selection_criterion_available ?selection_criterion - selection_criterion)
    (case_selection_criterion_assigned ?case_record - culling_case_record ?selection_criterion - selection_criterion)
    (authorization_form_available ?authorization_form - authorization_form)
    (case_authorization_form_applied ?case_record - culling_case_record ?authorization_form - authorization_form)
    (medical_treatment_kit_available ?medical_treatment_kit - medical_treatment_kit)
    (case_assigned_medical_treatment_kit ?case_record - culling_case_record ?medical_treatment_kit - medical_treatment_kit)
    (senior_vet_approval_available ?senior_vet_approval - senior_veterinary_approval)
    (case_has_senior_vet_approval ?case_record - culling_case_record ?senior_vet_approval - senior_veterinary_approval)
    (abattoir_slot_available ?abattoir_slot - abattoir_slot)
    (assigned_to_abattoir_slot ?animal - animal_candidate ?abattoir_slot - abattoir_slot)
    (production_group_ready_for_submission ?production_group - production_group)
    (management_group_ready_for_submission ?management_group - management_group)
    (case_finalized ?case_record - culling_case_record)
  )
  (:action identify_culling_candidate
    :parameters (?animal - animal_candidate)
    :precondition
      (and
        (not
          (candidate_identified ?animal)
        )
        (not
          (disposition_finalized ?animal)
        )
      )
    :effect (candidate_identified ?animal)
  )
  (:action assign_candidate_to_holding_pen
    :parameters (?animal - animal_candidate ?holding_pen - holding_pen)
    :precondition
      (and
        (candidate_identified ?animal)
        (not
          (staged_in_holding_pen ?animal)
        )
        (holding_pen_available ?holding_pen)
      )
    :effect
      (and
        (staged_in_holding_pen ?animal)
        (assigned_to_holding_pen ?animal ?holding_pen)
        (not
          (holding_pen_available ?holding_pen)
        )
      )
  )
  (:action assign_inspector_to_candidate
    :parameters (?animal - animal_candidate ?inspector - inspector)
    :precondition
      (and
        (candidate_identified ?animal)
        (staged_in_holding_pen ?animal)
        (inspector_available ?inspector)
      )
    :effect
      (and
        (inspected_by ?animal ?inspector)
        (not
          (inspector_available ?inspector)
        )
      )
  )
  (:action finalize_inspection_for_candidate
    :parameters (?animal - animal_candidate ?inspector - inspector)
    :precondition
      (and
        (candidate_identified ?animal)
        (staged_in_holding_pen ?animal)
        (inspected_by ?animal ?inspector)
        (not
          (inspection_completed ?animal)
        )
      )
    :effect (inspection_completed ?animal)
  )
  (:action release_inspector_from_candidate
    :parameters (?animal - animal_candidate ?inspector - inspector)
    :precondition
      (and
        (inspected_by ?animal ?inspector)
      )
    :effect
      (and
        (inspector_available ?inspector)
        (not
          (inspected_by ?animal ?inspector)
        )
      )
  )
  (:action assign_veterinarian_to_candidate
    :parameters (?animal - animal_candidate ?veterinarian - veterinary_officer)
    :precondition
      (and
        (inspection_completed ?animal)
        (veterinarian_available ?veterinarian)
      )
    :effect
      (and
        (veterinarian_assigned ?animal ?veterinarian)
        (not
          (veterinarian_available ?veterinarian)
        )
      )
  )
  (:action release_veterinarian_from_candidate
    :parameters (?animal - animal_candidate ?veterinarian - veterinary_officer)
    :precondition
      (and
        (veterinarian_assigned ?animal ?veterinarian)
      )
    :effect
      (and
        (veterinarian_available ?veterinarian)
        (not
          (veterinarian_assigned ?animal ?veterinarian)
        )
      )
  )
  (:action assign_medical_treatment_kit_to_case
    :parameters (?case_record - culling_case_record ?medical_treatment_kit - medical_treatment_kit)
    :precondition
      (and
        (inspection_completed ?case_record)
        (medical_treatment_kit_available ?medical_treatment_kit)
      )
    :effect
      (and
        (case_assigned_medical_treatment_kit ?case_record ?medical_treatment_kit)
        (not
          (medical_treatment_kit_available ?medical_treatment_kit)
        )
      )
  )
  (:action release_medical_treatment_kit_from_case
    :parameters (?case_record - culling_case_record ?medical_treatment_kit - medical_treatment_kit)
    :precondition
      (and
        (case_assigned_medical_treatment_kit ?case_record ?medical_treatment_kit)
      )
    :effect
      (and
        (medical_treatment_kit_available ?medical_treatment_kit)
        (not
          (case_assigned_medical_treatment_kit ?case_record ?medical_treatment_kit)
        )
      )
  )
  (:action assign_senior_vet_approval_to_case
    :parameters (?case_record - culling_case_record ?senior_vet_approval - senior_veterinary_approval)
    :precondition
      (and
        (inspection_completed ?case_record)
        (senior_vet_approval_available ?senior_vet_approval)
      )
    :effect
      (and
        (case_has_senior_vet_approval ?case_record ?senior_vet_approval)
        (not
          (senior_vet_approval_available ?senior_vet_approval)
        )
      )
  )
  (:action release_senior_vet_approval_from_case
    :parameters (?case_record - culling_case_record ?senior_vet_approval - senior_veterinary_approval)
    :precondition
      (and
        (case_has_senior_vet_approval ?case_record ?senior_vet_approval)
      )
    :effect
      (and
        (senior_vet_approval_available ?senior_vet_approval)
        (not
          (case_has_senior_vet_approval ?case_record ?senior_vet_approval)
        )
      )
  )
  (:action prepare_primary_stall_for_group
    :parameters (?production_group - production_group ?primary_stall - assessment_stall_primary ?inspector - inspector)
    :precondition
      (and
        (inspection_completed ?production_group)
        (inspected_by ?production_group ?inspector)
        (production_group_assigned_primary_stall ?production_group ?primary_stall)
        (not
          (primary_stall_ready ?primary_stall)
        )
        (not
          (primary_stall_prepared_with_sample_kit ?primary_stall)
        )
      )
    :effect (primary_stall_ready ?primary_stall)
  )
  (:action confirm_primary_assessment_for_group
    :parameters (?production_group - production_group ?primary_stall - assessment_stall_primary ?veterinarian - veterinary_officer)
    :precondition
      (and
        (inspection_completed ?production_group)
        (veterinarian_assigned ?production_group ?veterinarian)
        (production_group_assigned_primary_stall ?production_group ?primary_stall)
        (primary_stall_ready ?primary_stall)
        (not
          (production_group_ready_for_submission ?production_group)
        )
      )
    :effect
      (and
        (production_group_ready_for_submission ?production_group)
        (production_group_assessment_completed ?production_group)
      )
  )
  (:action collect_sample_at_primary_stall
    :parameters (?production_group - production_group ?primary_stall - assessment_stall_primary ?sample_kit - sample_kit)
    :precondition
      (and
        (inspection_completed ?production_group)
        (production_group_assigned_primary_stall ?production_group ?primary_stall)
        (sample_kit_available ?sample_kit)
        (not
          (production_group_ready_for_submission ?production_group)
        )
      )
    :effect
      (and
        (primary_stall_prepared_with_sample_kit ?primary_stall)
        (production_group_ready_for_submission ?production_group)
        (production_group_sample_kit_assigned ?production_group ?sample_kit)
        (not
          (sample_kit_available ?sample_kit)
        )
      )
  )
  (:action finalize_primary_sample_collection_for_group
    :parameters (?production_group - production_group ?primary_stall - assessment_stall_primary ?inspector - inspector ?sample_kit - sample_kit)
    :precondition
      (and
        (inspection_completed ?production_group)
        (inspected_by ?production_group ?inspector)
        (production_group_assigned_primary_stall ?production_group ?primary_stall)
        (primary_stall_prepared_with_sample_kit ?primary_stall)
        (production_group_sample_kit_assigned ?production_group ?sample_kit)
        (not
          (production_group_assessment_completed ?production_group)
        )
      )
    :effect
      (and
        (primary_stall_ready ?primary_stall)
        (production_group_assessment_completed ?production_group)
        (sample_kit_available ?sample_kit)
        (not
          (production_group_sample_kit_assigned ?production_group ?sample_kit)
        )
      )
  )
  (:action prepare_secondary_stall_for_group
    :parameters (?management_group - management_group ?secondary_stall - assessment_stall_secondary ?inspector - inspector)
    :precondition
      (and
        (inspection_completed ?management_group)
        (inspected_by ?management_group ?inspector)
        (management_group_assigned_secondary_stall ?management_group ?secondary_stall)
        (not
          (secondary_stall_ready ?secondary_stall)
        )
        (not
          (secondary_stall_prepared_with_sample_kit ?secondary_stall)
        )
      )
    :effect (secondary_stall_ready ?secondary_stall)
  )
  (:action confirm_secondary_assessment_for_group
    :parameters (?management_group - management_group ?secondary_stall - assessment_stall_secondary ?veterinarian - veterinary_officer)
    :precondition
      (and
        (inspection_completed ?management_group)
        (veterinarian_assigned ?management_group ?veterinarian)
        (management_group_assigned_secondary_stall ?management_group ?secondary_stall)
        (secondary_stall_ready ?secondary_stall)
        (not
          (management_group_ready_for_submission ?management_group)
        )
      )
    :effect
      (and
        (management_group_ready_for_submission ?management_group)
        (management_group_assessment_completed ?management_group)
      )
  )
  (:action collect_sample_at_secondary_stall
    :parameters (?management_group - management_group ?secondary_stall - assessment_stall_secondary ?sample_kit - sample_kit)
    :precondition
      (and
        (inspection_completed ?management_group)
        (management_group_assigned_secondary_stall ?management_group ?secondary_stall)
        (sample_kit_available ?sample_kit)
        (not
          (management_group_ready_for_submission ?management_group)
        )
      )
    :effect
      (and
        (secondary_stall_prepared_with_sample_kit ?secondary_stall)
        (management_group_ready_for_submission ?management_group)
        (management_group_sample_kit_assigned ?management_group ?sample_kit)
        (not
          (sample_kit_available ?sample_kit)
        )
      )
  )
  (:action finalize_secondary_sample_collection_for_group
    :parameters (?management_group - management_group ?secondary_stall - assessment_stall_secondary ?inspector - inspector ?sample_kit - sample_kit)
    :precondition
      (and
        (inspection_completed ?management_group)
        (inspected_by ?management_group ?inspector)
        (management_group_assigned_secondary_stall ?management_group ?secondary_stall)
        (secondary_stall_prepared_with_sample_kit ?secondary_stall)
        (management_group_sample_kit_assigned ?management_group ?sample_kit)
        (not
          (management_group_assessment_completed ?management_group)
        )
      )
    :effect
      (and
        (secondary_stall_ready ?secondary_stall)
        (management_group_assessment_completed ?management_group)
        (sample_kit_available ?sample_kit)
        (not
          (management_group_sample_kit_assigned ?management_group ?sample_kit)
        )
      )
  )
  (:action assemble_submission_batch_from_stalls
    :parameters (?production_group - production_group ?management_group - management_group ?primary_stall - assessment_stall_primary ?secondary_stall - assessment_stall_secondary ?submission_batch - submission_batch)
    :precondition
      (and
        (production_group_ready_for_submission ?production_group)
        (management_group_ready_for_submission ?management_group)
        (production_group_assigned_primary_stall ?production_group ?primary_stall)
        (management_group_assigned_secondary_stall ?management_group ?secondary_stall)
        (primary_stall_ready ?primary_stall)
        (secondary_stall_ready ?secondary_stall)
        (production_group_assessment_completed ?production_group)
        (management_group_assessment_completed ?management_group)
        (submission_batch_available ?submission_batch)
      )
    :effect
      (and
        (submission_batch_marked_ready ?submission_batch)
        (batch_includes_primary_stall ?submission_batch ?primary_stall)
        (batch_includes_secondary_stall ?submission_batch ?secondary_stall)
        (not
          (submission_batch_available ?submission_batch)
        )
      )
  )
  (:action assemble_submission_batch_primary_prepared
    :parameters (?production_group - production_group ?management_group - management_group ?primary_stall - assessment_stall_primary ?secondary_stall - assessment_stall_secondary ?submission_batch - submission_batch)
    :precondition
      (and
        (production_group_ready_for_submission ?production_group)
        (management_group_ready_for_submission ?management_group)
        (production_group_assigned_primary_stall ?production_group ?primary_stall)
        (management_group_assigned_secondary_stall ?management_group ?secondary_stall)
        (primary_stall_prepared_with_sample_kit ?primary_stall)
        (secondary_stall_ready ?secondary_stall)
        (not
          (production_group_assessment_completed ?production_group)
        )
        (management_group_assessment_completed ?management_group)
        (submission_batch_available ?submission_batch)
      )
    :effect
      (and
        (submission_batch_marked_ready ?submission_batch)
        (batch_includes_primary_stall ?submission_batch ?primary_stall)
        (batch_includes_secondary_stall ?submission_batch ?secondary_stall)
        (batch_has_prepared_primary_stall ?submission_batch)
        (not
          (submission_batch_available ?submission_batch)
        )
      )
  )
  (:action assemble_submission_batch_secondary_prepared
    :parameters (?production_group - production_group ?management_group - management_group ?primary_stall - assessment_stall_primary ?secondary_stall - assessment_stall_secondary ?submission_batch - submission_batch)
    :precondition
      (and
        (production_group_ready_for_submission ?production_group)
        (management_group_ready_for_submission ?management_group)
        (production_group_assigned_primary_stall ?production_group ?primary_stall)
        (management_group_assigned_secondary_stall ?management_group ?secondary_stall)
        (primary_stall_ready ?primary_stall)
        (secondary_stall_prepared_with_sample_kit ?secondary_stall)
        (production_group_assessment_completed ?production_group)
        (not
          (management_group_assessment_completed ?management_group)
        )
        (submission_batch_available ?submission_batch)
      )
    :effect
      (and
        (submission_batch_marked_ready ?submission_batch)
        (batch_includes_primary_stall ?submission_batch ?primary_stall)
        (batch_includes_secondary_stall ?submission_batch ?secondary_stall)
        (batch_has_prepared_secondary_stall ?submission_batch)
        (not
          (submission_batch_available ?submission_batch)
        )
      )
  )
  (:action assemble_submission_batch_both_prepared
    :parameters (?production_group - production_group ?management_group - management_group ?primary_stall - assessment_stall_primary ?secondary_stall - assessment_stall_secondary ?submission_batch - submission_batch)
    :precondition
      (and
        (production_group_ready_for_submission ?production_group)
        (management_group_ready_for_submission ?management_group)
        (production_group_assigned_primary_stall ?production_group ?primary_stall)
        (management_group_assigned_secondary_stall ?management_group ?secondary_stall)
        (primary_stall_prepared_with_sample_kit ?primary_stall)
        (secondary_stall_prepared_with_sample_kit ?secondary_stall)
        (not
          (production_group_assessment_completed ?production_group)
        )
        (not
          (management_group_assessment_completed ?management_group)
        )
        (submission_batch_available ?submission_batch)
      )
    :effect
      (and
        (submission_batch_marked_ready ?submission_batch)
        (batch_includes_primary_stall ?submission_batch ?primary_stall)
        (batch_includes_secondary_stall ?submission_batch ?secondary_stall)
        (batch_has_prepared_primary_stall ?submission_batch)
        (batch_has_prepared_secondary_stall ?submission_batch)
        (not
          (submission_batch_available ?submission_batch)
        )
      )
  )
  (:action finalize_submission_batch_for_lab
    :parameters (?submission_batch - submission_batch ?production_group - production_group ?inspector - inspector)
    :precondition
      (and
        (submission_batch_marked_ready ?submission_batch)
        (production_group_ready_for_submission ?production_group)
        (inspected_by ?production_group ?inspector)
        (not
          (submission_batch_locked_for_lab ?submission_batch)
        )
      )
    :effect (submission_batch_locked_for_lab ?submission_batch)
  )
  (:action record_lab_sample_receipt_for_case
    :parameters (?case_record - culling_case_record ?lab_sample - lab_sample ?submission_batch - submission_batch)
    :precondition
      (and
        (inspection_completed ?case_record)
        (case_assigned_to_submission_batch ?case_record ?submission_batch)
        (case_has_lab_sample_assigned ?case_record ?lab_sample)
        (lab_sample_available ?lab_sample)
        (submission_batch_marked_ready ?submission_batch)
        (submission_batch_locked_for_lab ?submission_batch)
        (not
          (lab_sample_received ?lab_sample)
        )
      )
    :effect
      (and
        (lab_sample_received ?lab_sample)
        (sample_in_submission_batch ?lab_sample ?submission_batch)
        (not
          (lab_sample_available ?lab_sample)
        )
      )
  )
  (:action process_lab_sample_and_mark_case_ready
    :parameters (?case_record - culling_case_record ?lab_sample - lab_sample ?submission_batch - submission_batch ?inspector - inspector)
    :precondition
      (and
        (inspection_completed ?case_record)
        (case_has_lab_sample_assigned ?case_record ?lab_sample)
        (lab_sample_received ?lab_sample)
        (sample_in_submission_batch ?lab_sample ?submission_batch)
        (inspected_by ?case_record ?inspector)
        (not
          (batch_has_prepared_primary_stall ?submission_batch)
        )
        (not
          (lab_results_ready_for_case ?case_record)
        )
      )
    :effect (lab_results_ready_for_case ?case_record)
  )
  (:action assign_selection_criterion_to_case_record
    :parameters (?case_record - culling_case_record ?selection_criterion - selection_criterion)
    :precondition
      (and
        (inspection_completed ?case_record)
        (selection_criterion_available ?selection_criterion)
        (not
          (case_has_selection_criterion ?case_record)
        )
      )
    :effect
      (and
        (case_has_selection_criterion ?case_record)
        (case_selection_criterion_assigned ?case_record ?selection_criterion)
        (not
          (selection_criterion_available ?selection_criterion)
        )
      )
  )
  (:action verify_selection_criterion_and_mark_case_ready
    :parameters (?case_record - culling_case_record ?lab_sample - lab_sample ?submission_batch - submission_batch ?inspector - inspector ?selection_criterion - selection_criterion)
    :precondition
      (and
        (inspection_completed ?case_record)
        (case_has_lab_sample_assigned ?case_record ?lab_sample)
        (lab_sample_received ?lab_sample)
        (sample_in_submission_batch ?lab_sample ?submission_batch)
        (inspected_by ?case_record ?inspector)
        (batch_has_prepared_primary_stall ?submission_batch)
        (case_has_selection_criterion ?case_record)
        (case_selection_criterion_assigned ?case_record ?selection_criterion)
        (not
          (lab_results_ready_for_case ?case_record)
        )
      )
    :effect
      (and
        (lab_results_ready_for_case ?case_record)
        (selection_criterion_verified_for_case ?case_record)
      )
  )
  (:action administer_treatment_to_case_standard
    :parameters (?case_record - culling_case_record ?medical_treatment_kit - medical_treatment_kit ?veterinarian - veterinary_officer ?lab_sample - lab_sample ?submission_batch - submission_batch)
    :precondition
      (and
        (lab_results_ready_for_case ?case_record)
        (case_assigned_medical_treatment_kit ?case_record ?medical_treatment_kit)
        (veterinarian_assigned ?case_record ?veterinarian)
        (case_has_lab_sample_assigned ?case_record ?lab_sample)
        (sample_in_submission_batch ?lab_sample ?submission_batch)
        (not
          (batch_has_prepared_secondary_stall ?submission_batch)
        )
        (not
          (treatment_applied_to_case ?case_record)
        )
      )
    :effect (treatment_applied_to_case ?case_record)
  )
  (:action administer_treatment_to_case_secondary_flagged
    :parameters (?case_record - culling_case_record ?medical_treatment_kit - medical_treatment_kit ?veterinarian - veterinary_officer ?lab_sample - lab_sample ?submission_batch - submission_batch)
    :precondition
      (and
        (lab_results_ready_for_case ?case_record)
        (case_assigned_medical_treatment_kit ?case_record ?medical_treatment_kit)
        (veterinarian_assigned ?case_record ?veterinarian)
        (case_has_lab_sample_assigned ?case_record ?lab_sample)
        (sample_in_submission_batch ?lab_sample ?submission_batch)
        (batch_has_prepared_secondary_stall ?submission_batch)
        (not
          (treatment_applied_to_case ?case_record)
        )
      )
    :effect (treatment_applied_to_case ?case_record)
  )
  (:action mark_case_ready_for_final_review
    :parameters (?case_record - culling_case_record ?senior_vet_approval - senior_veterinary_approval ?lab_sample - lab_sample ?submission_batch - submission_batch)
    :precondition
      (and
        (treatment_applied_to_case ?case_record)
        (case_has_senior_vet_approval ?case_record ?senior_vet_approval)
        (case_has_lab_sample_assigned ?case_record ?lab_sample)
        (sample_in_submission_batch ?lab_sample ?submission_batch)
        (not
          (batch_has_prepared_primary_stall ?submission_batch)
        )
        (not
          (batch_has_prepared_secondary_stall ?submission_batch)
        )
        (not
          (case_ready_for_final_review ?case_record)
        )
      )
    :effect (case_ready_for_final_review ?case_record)
  )
  (:action mark_case_admin_verified_and_ready
    :parameters (?case_record - culling_case_record ?senior_vet_approval - senior_veterinary_approval ?lab_sample - lab_sample ?submission_batch - submission_batch)
    :precondition
      (and
        (treatment_applied_to_case ?case_record)
        (case_has_senior_vet_approval ?case_record ?senior_vet_approval)
        (case_has_lab_sample_assigned ?case_record ?lab_sample)
        (sample_in_submission_batch ?lab_sample ?submission_batch)
        (batch_has_prepared_primary_stall ?submission_batch)
        (not
          (batch_has_prepared_secondary_stall ?submission_batch)
        )
        (not
          (case_ready_for_final_review ?case_record)
        )
      )
    :effect
      (and
        (case_ready_for_final_review ?case_record)
        (administrative_checks_passed ?case_record)
      )
  )
  (:action mark_case_admin_verified_and_ready_secondary
    :parameters (?case_record - culling_case_record ?senior_vet_approval - senior_veterinary_approval ?lab_sample - lab_sample ?submission_batch - submission_batch)
    :precondition
      (and
        (treatment_applied_to_case ?case_record)
        (case_has_senior_vet_approval ?case_record ?senior_vet_approval)
        (case_has_lab_sample_assigned ?case_record ?lab_sample)
        (sample_in_submission_batch ?lab_sample ?submission_batch)
        (not
          (batch_has_prepared_primary_stall ?submission_batch)
        )
        (batch_has_prepared_secondary_stall ?submission_batch)
        (not
          (case_ready_for_final_review ?case_record)
        )
      )
    :effect
      (and
        (case_ready_for_final_review ?case_record)
        (administrative_checks_passed ?case_record)
      )
  )
  (:action mark_case_admin_verified_and_ready_both
    :parameters (?case_record - culling_case_record ?senior_vet_approval - senior_veterinary_approval ?lab_sample - lab_sample ?submission_batch - submission_batch)
    :precondition
      (and
        (treatment_applied_to_case ?case_record)
        (case_has_senior_vet_approval ?case_record ?senior_vet_approval)
        (case_has_lab_sample_assigned ?case_record ?lab_sample)
        (sample_in_submission_batch ?lab_sample ?submission_batch)
        (batch_has_prepared_primary_stall ?submission_batch)
        (batch_has_prepared_secondary_stall ?submission_batch)
        (not
          (case_ready_for_final_review ?case_record)
        )
      )
    :effect
      (and
        (case_ready_for_final_review ?case_record)
        (administrative_checks_passed ?case_record)
      )
  )
  (:action finalize_case_and_mark_approved_for_culling
    :parameters (?case_record - culling_case_record)
    :precondition
      (and
        (case_ready_for_final_review ?case_record)
        (not
          (administrative_checks_passed ?case_record)
        )
        (not
          (case_finalized ?case_record)
        )
      )
    :effect
      (and
        (case_finalized ?case_record)
        (approved_for_culling ?case_record)
      )
  )
  (:action apply_authorization_form_to_case
    :parameters (?case_record - culling_case_record ?authorization_form - authorization_form)
    :precondition
      (and
        (case_ready_for_final_review ?case_record)
        (administrative_checks_passed ?case_record)
        (authorization_form_available ?authorization_form)
      )
    :effect
      (and
        (case_authorization_form_applied ?case_record ?authorization_form)
        (not
          (authorization_form_available ?authorization_form)
        )
      )
  )
  (:action apply_administrative_authorization_to_case
    :parameters (?case_record - culling_case_record ?production_group - production_group ?management_group - management_group ?inspector - inspector ?authorization_form - authorization_form)
    :precondition
      (and
        (case_ready_for_final_review ?case_record)
        (administrative_checks_passed ?case_record)
        (case_authorization_form_applied ?case_record ?authorization_form)
        (case_record_source_production_group ?case_record ?production_group)
        (case_record_source_management_group ?case_record ?management_group)
        (production_group_assessment_completed ?production_group)
        (management_group_assessment_completed ?management_group)
        (inspected_by ?case_record ?inspector)
        (not
          (administrative_authorization_applied ?case_record)
        )
      )
    :effect (administrative_authorization_applied ?case_record)
  )
  (:action finalize_case_after_administrative_authorization
    :parameters (?case_record - culling_case_record)
    :precondition
      (and
        (case_ready_for_final_review ?case_record)
        (administrative_authorization_applied ?case_record)
        (not
          (case_finalized ?case_record)
        )
      )
    :effect
      (and
        (case_finalized ?case_record)
        (approved_for_culling ?case_record)
      )
  )
  (:action attach_ear_tag_to_case
    :parameters (?case_record - culling_case_record ?ear_tag - ear_tag ?inspector - inspector)
    :precondition
      (and
        (inspection_completed ?case_record)
        (inspected_by ?case_record ?inspector)
        (ear_tag_available ?ear_tag)
        (case_assigned_ear_tag ?case_record ?ear_tag)
        (not
          (ear_tag_attached ?case_record)
        )
      )
    :effect
      (and
        (ear_tag_attached ?case_record)
        (not
          (ear_tag_available ?ear_tag)
        )
      )
  )
  (:action veterinarian_confirm_ear_tagging
    :parameters (?case_record - culling_case_record ?veterinarian - veterinary_officer)
    :precondition
      (and
        (ear_tag_attached ?case_record)
        (veterinarian_assigned ?case_record ?veterinarian)
        (not
          (veterinarian_confirmed_ear_tagging ?case_record)
        )
      )
    :effect (veterinarian_confirmed_ear_tagging ?case_record)
  )
  (:action senior_veterinarian_confirm_ear_tagging
    :parameters (?case_record - culling_case_record ?senior_vet_approval - senior_veterinary_approval)
    :precondition
      (and
        (veterinarian_confirmed_ear_tagging ?case_record)
        (case_has_senior_vet_approval ?case_record ?senior_vet_approval)
        (not
          (senior_veterinarian_ear_tag_approval ?case_record)
        )
      )
    :effect (senior_veterinarian_ear_tag_approval ?case_record)
  )
  (:action finalize_case_after_tagging_approval
    :parameters (?case_record - culling_case_record)
    :precondition
      (and
        (senior_veterinarian_ear_tag_approval ?case_record)
        (not
          (case_finalized ?case_record)
        )
      )
    :effect
      (and
        (case_finalized ?case_record)
        (approved_for_culling ?case_record)
      )
  )
  (:action finalize_production_group_for_culling
    :parameters (?production_group - production_group ?submission_batch - submission_batch)
    :precondition
      (and
        (production_group_ready_for_submission ?production_group)
        (production_group_assessment_completed ?production_group)
        (submission_batch_marked_ready ?submission_batch)
        (submission_batch_locked_for_lab ?submission_batch)
        (not
          (approved_for_culling ?production_group)
        )
      )
    :effect (approved_for_culling ?production_group)
  )
  (:action finalize_management_group_for_culling
    :parameters (?management_group - management_group ?submission_batch - submission_batch)
    :precondition
      (and
        (management_group_ready_for_submission ?management_group)
        (management_group_assessment_completed ?management_group)
        (submission_batch_marked_ready ?submission_batch)
        (submission_batch_locked_for_lab ?submission_batch)
        (not
          (approved_for_culling ?management_group)
        )
      )
    :effect (approved_for_culling ?management_group)
  )
  (:action book_abattoir_slot_for_animal
    :parameters (?animal - animal_candidate ?abattoir_slot - abattoir_slot ?inspector - inspector)
    :precondition
      (and
        (approved_for_culling ?animal)
        (inspected_by ?animal ?inspector)
        (abattoir_slot_available ?abattoir_slot)
        (not
          (abattoir_slot_reserved ?animal)
        )
      )
    :effect
      (and
        (abattoir_slot_reserved ?animal)
        (assigned_to_abattoir_slot ?animal ?abattoir_slot)
        (not
          (abattoir_slot_available ?abattoir_slot)
        )
      )
  )
  (:action confirm_culling_execution_for_production_group
    :parameters (?production_group - production_group ?holding_pen - holding_pen ?abattoir_slot - abattoir_slot)
    :precondition
      (and
        (abattoir_slot_reserved ?production_group)
        (assigned_to_holding_pen ?production_group ?holding_pen)
        (assigned_to_abattoir_slot ?production_group ?abattoir_slot)
        (not
          (disposition_finalized ?production_group)
        )
      )
    :effect
      (and
        (disposition_finalized ?production_group)
        (holding_pen_available ?holding_pen)
        (abattoir_slot_available ?abattoir_slot)
      )
  )
  (:action confirm_culling_execution_for_management_group
    :parameters (?management_group - management_group ?holding_pen - holding_pen ?abattoir_slot - abattoir_slot)
    :precondition
      (and
        (abattoir_slot_reserved ?management_group)
        (assigned_to_holding_pen ?management_group ?holding_pen)
        (assigned_to_abattoir_slot ?management_group ?abattoir_slot)
        (not
          (disposition_finalized ?management_group)
        )
      )
    :effect
      (and
        (disposition_finalized ?management_group)
        (holding_pen_available ?holding_pen)
        (abattoir_slot_available ?abattoir_slot)
      )
  )
  (:action confirm_culling_execution_for_case_record
    :parameters (?case_record - culling_case_record ?holding_pen - holding_pen ?abattoir_slot - abattoir_slot)
    :precondition
      (and
        (abattoir_slot_reserved ?case_record)
        (assigned_to_holding_pen ?case_record ?holding_pen)
        (assigned_to_abattoir_slot ?case_record ?abattoir_slot)
        (not
          (disposition_finalized ?case_record)
        )
      )
    :effect
      (and
        (disposition_finalized ?case_record)
        (holding_pen_available ?holding_pen)
        (abattoir_slot_available ?abattoir_slot)
      )
  )
)

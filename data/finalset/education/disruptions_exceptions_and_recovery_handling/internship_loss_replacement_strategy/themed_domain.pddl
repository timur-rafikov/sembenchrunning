(define (domain internship_loss_replacement_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types case_resource - object institutional_resource - object institutional_asset - object internship_case_root - object internship_case - internship_case_root replacement_slot - case_resource supporting_document - case_resource staff_officer - case_resource external_approval_token - case_resource resource_allocation_token - case_resource credit_artifact - case_resource training_module - case_resource accreditation_document - case_resource alternative_course - institutional_resource equivalency_packet - institutional_resource sponsor_confirmation - institutional_resource schedule_block_a - institutional_asset schedule_block_b - institutional_asset replacement_plan - institutional_asset student_group - internship_case program_group - internship_case affected_student - student_group peer_student - student_group administrative_case_unit - program_group)
  (:predicates
    (case_opened ?internship_case - internship_case)
    (record_validated ?internship_case - internship_case)
    (replacement_slot_listed ?internship_case - internship_case)
    (administrative_record_updated ?internship_case - internship_case)
    (record_resolved ?internship_case - internship_case)
    (credit_awarded ?internship_case - internship_case)
    (slot_available ?replacement_slot - replacement_slot)
    (case_slot_link ?internship_case - internship_case ?replacement_slot - replacement_slot)
    (document_available ?supporting_document - supporting_document)
    (case_document_link ?internship_case - internship_case ?supporting_document - supporting_document)
    (officer_available ?staff_officer - staff_officer)
    (case_assigned_officer ?internship_case - internship_case ?staff_officer - staff_officer)
    (alternative_course_available ?alternative_course - alternative_course)
    (student_alternative_assigned ?affected_student - affected_student ?alternative_course - alternative_course)
    (peer_alternative_assigned ?peer_student - peer_student ?alternative_course - alternative_course)
    (student_has_schedule_block_a ?affected_student - affected_student ?schedule_block_a - schedule_block_a)
    (block_a_selected ?schedule_block_a - schedule_block_a)
    (block_a_assigned ?schedule_block_a - schedule_block_a)
    (student_ready_for_plan ?affected_student - affected_student)
    (peer_has_schedule_block_b ?peer_student - peer_student ?schedule_block_b - schedule_block_b)
    (block_b_selected ?schedule_block_b - schedule_block_b)
    (block_b_assigned ?schedule_block_b - schedule_block_b)
    (peer_ready_for_plan ?peer_student - peer_student)
    (plan_available ?replacement_plan - replacement_plan)
    (plan_compiled ?replacement_plan - replacement_plan)
    (plan_includes_block_a ?replacement_plan - replacement_plan ?schedule_block_a - schedule_block_a)
    (plan_includes_block_b ?replacement_plan - replacement_plan ?schedule_block_b - schedule_block_b)
    (plan_flag_type_a ?replacement_plan - replacement_plan)
    (plan_flag_type_b ?replacement_plan - replacement_plan)
    (plan_ready_for_packaging ?replacement_plan - replacement_plan)
    (unit_has_affected_student ?administrative_case_unit - administrative_case_unit ?affected_student - affected_student)
    (unit_has_peer_student ?administrative_case_unit - administrative_case_unit ?peer_student - peer_student)
    (unit_has_plan ?administrative_case_unit - administrative_case_unit ?replacement_plan - replacement_plan)
    (packet_available ?equivalency_packet - equivalency_packet)
    (unit_has_equivalency_packet ?administrative_case_unit - administrative_case_unit ?equivalency_packet - equivalency_packet)
    (packet_validated ?equivalency_packet - equivalency_packet)
    (packet_links_plan ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan)
    (unit_approval_stage_1 ?administrative_case_unit - administrative_case_unit)
    (unit_approval_stage_2 ?administrative_case_unit - administrative_case_unit)
    (unit_approval_stage_3 ?administrative_case_unit - administrative_case_unit)
    (unit_approval_initiated ?administrative_case_unit - administrative_case_unit)
    (unit_approval_stage_4 ?administrative_case_unit - administrative_case_unit)
    (unit_ready_for_finalization ?administrative_case_unit - administrative_case_unit)
    (unit_final_approval ?administrative_case_unit - administrative_case_unit)
    (sponsor_confirmation_available ?sponsor_confirmation - sponsor_confirmation)
    (unit_has_sponsor_confirmation ?administrative_case_unit - administrative_case_unit ?sponsor_confirmation - sponsor_confirmation)
    (unit_sponsor_acknowledged ?administrative_case_unit - administrative_case_unit)
    (unit_approval_for_accreditation ?administrative_case_unit - administrative_case_unit)
    (unit_accreditation_stage ?administrative_case_unit - administrative_case_unit)
    (external_approval_token_available ?external_approval_token - external_approval_token)
    (unit_has_external_approval_token ?administrative_case_unit - administrative_case_unit ?external_approval_token - external_approval_token)
    (resource_allocation_token_available ?resource_allocation_token - resource_allocation_token)
    (unit_has_resource_allocation ?administrative_case_unit - administrative_case_unit ?resource_allocation_token - resource_allocation_token)
    (training_module_available ?training_module - training_module)
    (unit_applied_training_module ?administrative_case_unit - administrative_case_unit ?training_module - training_module)
    (accreditation_document_available ?accreditation_document - accreditation_document)
    (unit_has_accreditation_document ?administrative_case_unit - administrative_case_unit ?accreditation_document - accreditation_document)
    (credit_artifact_available ?credit_artifact - credit_artifact)
    (case_has_credit_artifact ?internship_case - internship_case ?credit_artifact - credit_artifact)
    (student_processing_mark ?affected_student - affected_student)
    (peer_processing_mark ?peer_student - peer_student)
    (unit_finalized ?administrative_case_unit - administrative_case_unit)
  )
  (:action open_internship_case
    :parameters (?internship_case - internship_case)
    :precondition
      (and
        (not
          (case_opened ?internship_case)
        )
        (not
          (administrative_record_updated ?internship_case)
        )
      )
    :effect (case_opened ?internship_case)
  )
  (:action register_replacement_slot_for_case
    :parameters (?internship_case - internship_case ?replacement_slot - replacement_slot)
    :precondition
      (and
        (case_opened ?internship_case)
        (not
          (replacement_slot_listed ?internship_case)
        )
        (slot_available ?replacement_slot)
      )
    :effect
      (and
        (replacement_slot_listed ?internship_case)
        (case_slot_link ?internship_case ?replacement_slot)
        (not
          (slot_available ?replacement_slot)
        )
      )
  )
  (:action link_supporting_document_to_case
    :parameters (?internship_case - internship_case ?supporting_document - supporting_document)
    :precondition
      (and
        (case_opened ?internship_case)
        (replacement_slot_listed ?internship_case)
        (document_available ?supporting_document)
      )
    :effect
      (and
        (case_document_link ?internship_case ?supporting_document)
        (not
          (document_available ?supporting_document)
        )
      )
  )
  (:action validate_case_evidence
    :parameters (?internship_case - internship_case ?supporting_document - supporting_document)
    :precondition
      (and
        (case_opened ?internship_case)
        (replacement_slot_listed ?internship_case)
        (case_document_link ?internship_case ?supporting_document)
        (not
          (record_validated ?internship_case)
        )
      )
    :effect (record_validated ?internship_case)
  )
  (:action unlink_supporting_document_from_case
    :parameters (?internship_case - internship_case ?supporting_document - supporting_document)
    :precondition
      (and
        (case_document_link ?internship_case ?supporting_document)
      )
    :effect
      (and
        (document_available ?supporting_document)
        (not
          (case_document_link ?internship_case ?supporting_document)
        )
      )
  )
  (:action assign_staff_officer_to_case
    :parameters (?internship_case - internship_case ?staff_officer - staff_officer)
    :precondition
      (and
        (record_validated ?internship_case)
        (officer_available ?staff_officer)
      )
    :effect
      (and
        (case_assigned_officer ?internship_case ?staff_officer)
        (not
          (officer_available ?staff_officer)
        )
      )
  )
  (:action unassign_staff_officer_from_case
    :parameters (?internship_case - internship_case ?staff_officer - staff_officer)
    :precondition
      (and
        (case_assigned_officer ?internship_case ?staff_officer)
      )
    :effect
      (and
        (officer_available ?staff_officer)
        (not
          (case_assigned_officer ?internship_case ?staff_officer)
        )
      )
  )
  (:action apply_training_module_to_unit
    :parameters (?administrative_case_unit - administrative_case_unit ?training_module - training_module)
    :precondition
      (and
        (record_validated ?administrative_case_unit)
        (training_module_available ?training_module)
      )
    :effect
      (and
        (unit_applied_training_module ?administrative_case_unit ?training_module)
        (not
          (training_module_available ?training_module)
        )
      )
  )
  (:action revoke_training_module_from_unit
    :parameters (?administrative_case_unit - administrative_case_unit ?training_module - training_module)
    :precondition
      (and
        (unit_applied_training_module ?administrative_case_unit ?training_module)
      )
    :effect
      (and
        (training_module_available ?training_module)
        (not
          (unit_applied_training_module ?administrative_case_unit ?training_module)
        )
      )
  )
  (:action attach_accreditation_document_to_unit
    :parameters (?administrative_case_unit - administrative_case_unit ?accreditation_document - accreditation_document)
    :precondition
      (and
        (record_validated ?administrative_case_unit)
        (accreditation_document_available ?accreditation_document)
      )
    :effect
      (and
        (unit_has_accreditation_document ?administrative_case_unit ?accreditation_document)
        (not
          (accreditation_document_available ?accreditation_document)
        )
      )
  )
  (:action detach_accreditation_document_from_unit
    :parameters (?administrative_case_unit - administrative_case_unit ?accreditation_document - accreditation_document)
    :precondition
      (and
        (unit_has_accreditation_document ?administrative_case_unit ?accreditation_document)
      )
    :effect
      (and
        (accreditation_document_available ?accreditation_document)
        (not
          (unit_has_accreditation_document ?administrative_case_unit ?accreditation_document)
        )
      )
  )
  (:action reserve_schedule_block_a_for_student
    :parameters (?affected_student - affected_student ?schedule_block_a - schedule_block_a ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?affected_student)
        (case_document_link ?affected_student ?supporting_document)
        (student_has_schedule_block_a ?affected_student ?schedule_block_a)
        (not
          (block_a_selected ?schedule_block_a)
        )
        (not
          (block_a_assigned ?schedule_block_a)
        )
      )
    :effect (block_a_selected ?schedule_block_a)
  )
  (:action authorize_schedule_block_a_for_student
    :parameters (?affected_student - affected_student ?schedule_block_a - schedule_block_a ?staff_officer - staff_officer)
    :precondition
      (and
        (record_validated ?affected_student)
        (case_assigned_officer ?affected_student ?staff_officer)
        (student_has_schedule_block_a ?affected_student ?schedule_block_a)
        (block_a_selected ?schedule_block_a)
        (not
          (student_processing_mark ?affected_student)
        )
      )
    :effect
      (and
        (student_processing_mark ?affected_student)
        (student_ready_for_plan ?affected_student)
      )
  )
  (:action assign_alternative_course_to_student
    :parameters (?affected_student - affected_student ?schedule_block_a - schedule_block_a ?alternative_course - alternative_course)
    :precondition
      (and
        (record_validated ?affected_student)
        (student_has_schedule_block_a ?affected_student ?schedule_block_a)
        (alternative_course_available ?alternative_course)
        (not
          (student_processing_mark ?affected_student)
        )
      )
    :effect
      (and
        (block_a_assigned ?schedule_block_a)
        (student_processing_mark ?affected_student)
        (student_alternative_assigned ?affected_student ?alternative_course)
        (not
          (alternative_course_available ?alternative_course)
        )
      )
  )
  (:action finalize_student_block_and_alternative
    :parameters (?affected_student - affected_student ?schedule_block_a - schedule_block_a ?supporting_document - supporting_document ?alternative_course - alternative_course)
    :precondition
      (and
        (record_validated ?affected_student)
        (case_document_link ?affected_student ?supporting_document)
        (student_has_schedule_block_a ?affected_student ?schedule_block_a)
        (block_a_assigned ?schedule_block_a)
        (student_alternative_assigned ?affected_student ?alternative_course)
        (not
          (student_ready_for_plan ?affected_student)
        )
      )
    :effect
      (and
        (block_a_selected ?schedule_block_a)
        (student_ready_for_plan ?affected_student)
        (alternative_course_available ?alternative_course)
        (not
          (student_alternative_assigned ?affected_student ?alternative_course)
        )
      )
  )
  (:action reserve_schedule_block_b_for_peer
    :parameters (?peer_student - peer_student ?schedule_block_b - schedule_block_b ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?peer_student)
        (case_document_link ?peer_student ?supporting_document)
        (peer_has_schedule_block_b ?peer_student ?schedule_block_b)
        (not
          (block_b_selected ?schedule_block_b)
        )
        (not
          (block_b_assigned ?schedule_block_b)
        )
      )
    :effect (block_b_selected ?schedule_block_b)
  )
  (:action authorize_schedule_block_b_for_peer
    :parameters (?peer_student - peer_student ?schedule_block_b - schedule_block_b ?staff_officer - staff_officer)
    :precondition
      (and
        (record_validated ?peer_student)
        (case_assigned_officer ?peer_student ?staff_officer)
        (peer_has_schedule_block_b ?peer_student ?schedule_block_b)
        (block_b_selected ?schedule_block_b)
        (not
          (peer_processing_mark ?peer_student)
        )
      )
    :effect
      (and
        (peer_processing_mark ?peer_student)
        (peer_ready_for_plan ?peer_student)
      )
  )
  (:action assign_alternative_course_to_peer
    :parameters (?peer_student - peer_student ?schedule_block_b - schedule_block_b ?alternative_course - alternative_course)
    :precondition
      (and
        (record_validated ?peer_student)
        (peer_has_schedule_block_b ?peer_student ?schedule_block_b)
        (alternative_course_available ?alternative_course)
        (not
          (peer_processing_mark ?peer_student)
        )
      )
    :effect
      (and
        (block_b_assigned ?schedule_block_b)
        (peer_processing_mark ?peer_student)
        (peer_alternative_assigned ?peer_student ?alternative_course)
        (not
          (alternative_course_available ?alternative_course)
        )
      )
  )
  (:action finalize_peer_block_and_alternative
    :parameters (?peer_student - peer_student ?schedule_block_b - schedule_block_b ?supporting_document - supporting_document ?alternative_course - alternative_course)
    :precondition
      (and
        (record_validated ?peer_student)
        (case_document_link ?peer_student ?supporting_document)
        (peer_has_schedule_block_b ?peer_student ?schedule_block_b)
        (block_b_assigned ?schedule_block_b)
        (peer_alternative_assigned ?peer_student ?alternative_course)
        (not
          (peer_ready_for_plan ?peer_student)
        )
      )
    :effect
      (and
        (block_b_selected ?schedule_block_b)
        (peer_ready_for_plan ?peer_student)
        (alternative_course_available ?alternative_course)
        (not
          (peer_alternative_assigned ?peer_student ?alternative_course)
        )
      )
  )
  (:action compile_replacement_plan_candidate
    :parameters (?affected_student - affected_student ?peer_student - peer_student ?schedule_block_a - schedule_block_a ?schedule_block_b - schedule_block_b ?replacement_plan - replacement_plan)
    :precondition
      (and
        (student_processing_mark ?affected_student)
        (peer_processing_mark ?peer_student)
        (student_has_schedule_block_a ?affected_student ?schedule_block_a)
        (peer_has_schedule_block_b ?peer_student ?schedule_block_b)
        (block_a_selected ?schedule_block_a)
        (block_b_selected ?schedule_block_b)
        (student_ready_for_plan ?affected_student)
        (peer_ready_for_plan ?peer_student)
        (plan_available ?replacement_plan)
      )
    :effect
      (and
        (plan_compiled ?replacement_plan)
        (plan_includes_block_a ?replacement_plan ?schedule_block_a)
        (plan_includes_block_b ?replacement_plan ?schedule_block_b)
        (not
          (plan_available ?replacement_plan)
        )
      )
  )
  (:action compile_replacement_plan_with_block_a
    :parameters (?affected_student - affected_student ?peer_student - peer_student ?schedule_block_a - schedule_block_a ?schedule_block_b - schedule_block_b ?replacement_plan - replacement_plan)
    :precondition
      (and
        (student_processing_mark ?affected_student)
        (peer_processing_mark ?peer_student)
        (student_has_schedule_block_a ?affected_student ?schedule_block_a)
        (peer_has_schedule_block_b ?peer_student ?schedule_block_b)
        (block_a_assigned ?schedule_block_a)
        (block_b_selected ?schedule_block_b)
        (not
          (student_ready_for_plan ?affected_student)
        )
        (peer_ready_for_plan ?peer_student)
        (plan_available ?replacement_plan)
      )
    :effect
      (and
        (plan_compiled ?replacement_plan)
        (plan_includes_block_a ?replacement_plan ?schedule_block_a)
        (plan_includes_block_b ?replacement_plan ?schedule_block_b)
        (plan_flag_type_a ?replacement_plan)
        (not
          (plan_available ?replacement_plan)
        )
      )
  )
  (:action compile_replacement_plan_with_block_b
    :parameters (?affected_student - affected_student ?peer_student - peer_student ?schedule_block_a - schedule_block_a ?schedule_block_b - schedule_block_b ?replacement_plan - replacement_plan)
    :precondition
      (and
        (student_processing_mark ?affected_student)
        (peer_processing_mark ?peer_student)
        (student_has_schedule_block_a ?affected_student ?schedule_block_a)
        (peer_has_schedule_block_b ?peer_student ?schedule_block_b)
        (block_a_selected ?schedule_block_a)
        (block_b_assigned ?schedule_block_b)
        (student_ready_for_plan ?affected_student)
        (not
          (peer_ready_for_plan ?peer_student)
        )
        (plan_available ?replacement_plan)
      )
    :effect
      (and
        (plan_compiled ?replacement_plan)
        (plan_includes_block_a ?replacement_plan ?schedule_block_a)
        (plan_includes_block_b ?replacement_plan ?schedule_block_b)
        (plan_flag_type_b ?replacement_plan)
        (not
          (plan_available ?replacement_plan)
        )
      )
  )
  (:action compile_replacement_plan_with_both_blocks
    :parameters (?affected_student - affected_student ?peer_student - peer_student ?schedule_block_a - schedule_block_a ?schedule_block_b - schedule_block_b ?replacement_plan - replacement_plan)
    :precondition
      (and
        (student_processing_mark ?affected_student)
        (peer_processing_mark ?peer_student)
        (student_has_schedule_block_a ?affected_student ?schedule_block_a)
        (peer_has_schedule_block_b ?peer_student ?schedule_block_b)
        (block_a_assigned ?schedule_block_a)
        (block_b_assigned ?schedule_block_b)
        (not
          (student_ready_for_plan ?affected_student)
        )
        (not
          (peer_ready_for_plan ?peer_student)
        )
        (plan_available ?replacement_plan)
      )
    :effect
      (and
        (plan_compiled ?replacement_plan)
        (plan_includes_block_a ?replacement_plan ?schedule_block_a)
        (plan_includes_block_b ?replacement_plan ?schedule_block_b)
        (plan_flag_type_a ?replacement_plan)
        (plan_flag_type_b ?replacement_plan)
        (not
          (plan_available ?replacement_plan)
        )
      )
  )
  (:action mark_plan_ready_for_packaging
    :parameters (?replacement_plan - replacement_plan ?affected_student - affected_student ?supporting_document - supporting_document)
    :precondition
      (and
        (plan_compiled ?replacement_plan)
        (student_processing_mark ?affected_student)
        (case_document_link ?affected_student ?supporting_document)
        (not
          (plan_ready_for_packaging ?replacement_plan)
        )
      )
    :effect (plan_ready_for_packaging ?replacement_plan)
  )
  (:action validate_and_link_equivalency_packet
    :parameters (?administrative_case_unit - administrative_case_unit ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan)
    :precondition
      (and
        (record_validated ?administrative_case_unit)
        (unit_has_plan ?administrative_case_unit ?replacement_plan)
        (unit_has_equivalency_packet ?administrative_case_unit ?equivalency_packet)
        (packet_available ?equivalency_packet)
        (plan_compiled ?replacement_plan)
        (plan_ready_for_packaging ?replacement_plan)
        (not
          (packet_validated ?equivalency_packet)
        )
      )
    :effect
      (and
        (packet_validated ?equivalency_packet)
        (packet_links_plan ?equivalency_packet ?replacement_plan)
        (not
          (packet_available ?equivalency_packet)
        )
      )
  )
  (:action advance_unit_approval_stage_1
    :parameters (?administrative_case_unit - administrative_case_unit ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?administrative_case_unit)
        (unit_has_equivalency_packet ?administrative_case_unit ?equivalency_packet)
        (packet_validated ?equivalency_packet)
        (packet_links_plan ?equivalency_packet ?replacement_plan)
        (case_document_link ?administrative_case_unit ?supporting_document)
        (not
          (plan_flag_type_a ?replacement_plan)
        )
        (not
          (unit_approval_stage_1 ?administrative_case_unit)
        )
      )
    :effect (unit_approval_stage_1 ?administrative_case_unit)
  )
  (:action attach_external_approval_token_to_unit
    :parameters (?administrative_case_unit - administrative_case_unit ?external_approval_token - external_approval_token)
    :precondition
      (and
        (record_validated ?administrative_case_unit)
        (external_approval_token_available ?external_approval_token)
        (not
          (unit_approval_initiated ?administrative_case_unit)
        )
      )
    :effect
      (and
        (unit_approval_initiated ?administrative_case_unit)
        (unit_has_external_approval_token ?administrative_case_unit ?external_approval_token)
        (not
          (external_approval_token_available ?external_approval_token)
        )
      )
  )
  (:action advance_unit_approval_stage_with_packet
    :parameters (?administrative_case_unit - administrative_case_unit ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan ?supporting_document - supporting_document ?external_approval_token - external_approval_token)
    :precondition
      (and
        (record_validated ?administrative_case_unit)
        (unit_has_equivalency_packet ?administrative_case_unit ?equivalency_packet)
        (packet_validated ?equivalency_packet)
        (packet_links_plan ?equivalency_packet ?replacement_plan)
        (case_document_link ?administrative_case_unit ?supporting_document)
        (plan_flag_type_a ?replacement_plan)
        (unit_approval_initiated ?administrative_case_unit)
        (unit_has_external_approval_token ?administrative_case_unit ?external_approval_token)
        (not
          (unit_approval_stage_1 ?administrative_case_unit)
        )
      )
    :effect
      (and
        (unit_approval_stage_1 ?administrative_case_unit)
        (unit_approval_stage_4 ?administrative_case_unit)
      )
  )
  (:action apply_training_module_and_progress_unit_unflagged
    :parameters (?administrative_case_unit - administrative_case_unit ?training_module - training_module ?staff_officer - staff_officer ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan)
    :precondition
      (and
        (unit_approval_stage_1 ?administrative_case_unit)
        (unit_applied_training_module ?administrative_case_unit ?training_module)
        (case_assigned_officer ?administrative_case_unit ?staff_officer)
        (unit_has_equivalency_packet ?administrative_case_unit ?equivalency_packet)
        (packet_links_plan ?equivalency_packet ?replacement_plan)
        (not
          (plan_flag_type_b ?replacement_plan)
        )
        (not
          (unit_approval_stage_2 ?administrative_case_unit)
        )
      )
    :effect (unit_approval_stage_2 ?administrative_case_unit)
  )
  (:action apply_training_module_and_progress_unit_flagged
    :parameters (?administrative_case_unit - administrative_case_unit ?training_module - training_module ?staff_officer - staff_officer ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan)
    :precondition
      (and
        (unit_approval_stage_1 ?administrative_case_unit)
        (unit_applied_training_module ?administrative_case_unit ?training_module)
        (case_assigned_officer ?administrative_case_unit ?staff_officer)
        (unit_has_equivalency_packet ?administrative_case_unit ?equivalency_packet)
        (packet_links_plan ?equivalency_packet ?replacement_plan)
        (plan_flag_type_b ?replacement_plan)
        (not
          (unit_approval_stage_2 ?administrative_case_unit)
        )
      )
    :effect (unit_approval_stage_2 ?administrative_case_unit)
  )
  (:action apply_accreditation_document_stage1
    :parameters (?administrative_case_unit - administrative_case_unit ?accreditation_document - accreditation_document ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan)
    :precondition
      (and
        (unit_approval_stage_2 ?administrative_case_unit)
        (unit_has_accreditation_document ?administrative_case_unit ?accreditation_document)
        (unit_has_equivalency_packet ?administrative_case_unit ?equivalency_packet)
        (packet_links_plan ?equivalency_packet ?replacement_plan)
        (not
          (plan_flag_type_a ?replacement_plan)
        )
        (not
          (plan_flag_type_b ?replacement_plan)
        )
        (not
          (unit_approval_stage_3 ?administrative_case_unit)
        )
      )
    :effect (unit_approval_stage_3 ?administrative_case_unit)
  )
  (:action apply_accreditation_document_stage2
    :parameters (?administrative_case_unit - administrative_case_unit ?accreditation_document - accreditation_document ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan)
    :precondition
      (and
        (unit_approval_stage_2 ?administrative_case_unit)
        (unit_has_accreditation_document ?administrative_case_unit ?accreditation_document)
        (unit_has_equivalency_packet ?administrative_case_unit ?equivalency_packet)
        (packet_links_plan ?equivalency_packet ?replacement_plan)
        (plan_flag_type_a ?replacement_plan)
        (not
          (plan_flag_type_b ?replacement_plan)
        )
        (not
          (unit_approval_stage_3 ?administrative_case_unit)
        )
      )
    :effect
      (and
        (unit_approval_stage_3 ?administrative_case_unit)
        (unit_ready_for_finalization ?administrative_case_unit)
      )
  )
  (:action apply_accreditation_document_stage3
    :parameters (?administrative_case_unit - administrative_case_unit ?accreditation_document - accreditation_document ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan)
    :precondition
      (and
        (unit_approval_stage_2 ?administrative_case_unit)
        (unit_has_accreditation_document ?administrative_case_unit ?accreditation_document)
        (unit_has_equivalency_packet ?administrative_case_unit ?equivalency_packet)
        (packet_links_plan ?equivalency_packet ?replacement_plan)
        (not
          (plan_flag_type_a ?replacement_plan)
        )
        (plan_flag_type_b ?replacement_plan)
        (not
          (unit_approval_stage_3 ?administrative_case_unit)
        )
      )
    :effect
      (and
        (unit_approval_stage_3 ?administrative_case_unit)
        (unit_ready_for_finalization ?administrative_case_unit)
      )
  )
  (:action apply_accreditation_document_stage4
    :parameters (?administrative_case_unit - administrative_case_unit ?accreditation_document - accreditation_document ?equivalency_packet - equivalency_packet ?replacement_plan - replacement_plan)
    :precondition
      (and
        (unit_approval_stage_2 ?administrative_case_unit)
        (unit_has_accreditation_document ?administrative_case_unit ?accreditation_document)
        (unit_has_equivalency_packet ?administrative_case_unit ?equivalency_packet)
        (packet_links_plan ?equivalency_packet ?replacement_plan)
        (plan_flag_type_a ?replacement_plan)
        (plan_flag_type_b ?replacement_plan)
        (not
          (unit_approval_stage_3 ?administrative_case_unit)
        )
      )
    :effect
      (and
        (unit_approval_stage_3 ?administrative_case_unit)
        (unit_ready_for_finalization ?administrative_case_unit)
      )
  )
  (:action finalize_unit_and_mark_case_resolved
    :parameters (?administrative_case_unit - administrative_case_unit)
    :precondition
      (and
        (unit_approval_stage_3 ?administrative_case_unit)
        (not
          (unit_ready_for_finalization ?administrative_case_unit)
        )
        (not
          (unit_finalized ?administrative_case_unit)
        )
      )
    :effect
      (and
        (unit_finalized ?administrative_case_unit)
        (record_resolved ?administrative_case_unit)
      )
  )
  (:action allocate_resources_to_unit
    :parameters (?administrative_case_unit - administrative_case_unit ?resource_allocation_token - resource_allocation_token)
    :precondition
      (and
        (unit_approval_stage_3 ?administrative_case_unit)
        (unit_ready_for_finalization ?administrative_case_unit)
        (resource_allocation_token_available ?resource_allocation_token)
      )
    :effect
      (and
        (unit_has_resource_allocation ?administrative_case_unit ?resource_allocation_token)
        (not
          (resource_allocation_token_available ?resource_allocation_token)
        )
      )
  )
  (:action final_institutional_approval_for_unit
    :parameters (?administrative_case_unit - administrative_case_unit ?affected_student - affected_student ?peer_student - peer_student ?supporting_document - supporting_document ?resource_allocation_token - resource_allocation_token)
    :precondition
      (and
        (unit_approval_stage_3 ?administrative_case_unit)
        (unit_ready_for_finalization ?administrative_case_unit)
        (unit_has_resource_allocation ?administrative_case_unit ?resource_allocation_token)
        (unit_has_affected_student ?administrative_case_unit ?affected_student)
        (unit_has_peer_student ?administrative_case_unit ?peer_student)
        (student_ready_for_plan ?affected_student)
        (peer_ready_for_plan ?peer_student)
        (case_document_link ?administrative_case_unit ?supporting_document)
        (not
          (unit_final_approval ?administrative_case_unit)
        )
      )
    :effect (unit_final_approval ?administrative_case_unit)
  )
  (:action finalize_unit_and_mark_case_resolved_confirm
    :parameters (?administrative_case_unit - administrative_case_unit)
    :precondition
      (and
        (unit_approval_stage_3 ?administrative_case_unit)
        (unit_final_approval ?administrative_case_unit)
        (not
          (unit_finalized ?administrative_case_unit)
        )
      )
    :effect
      (and
        (unit_finalized ?administrative_case_unit)
        (record_resolved ?administrative_case_unit)
      )
  )
  (:action acknowledge_sponsor_confirmation_for_unit
    :parameters (?administrative_case_unit - administrative_case_unit ?sponsor_confirmation - sponsor_confirmation ?supporting_document - supporting_document)
    :precondition
      (and
        (record_validated ?administrative_case_unit)
        (case_document_link ?administrative_case_unit ?supporting_document)
        (sponsor_confirmation_available ?sponsor_confirmation)
        (unit_has_sponsor_confirmation ?administrative_case_unit ?sponsor_confirmation)
        (not
          (unit_sponsor_acknowledged ?administrative_case_unit)
        )
      )
    :effect
      (and
        (unit_sponsor_acknowledged ?administrative_case_unit)
        (not
          (sponsor_confirmation_available ?sponsor_confirmation)
        )
      )
  )
  (:action initiate_unit_accreditation_review
    :parameters (?administrative_case_unit - administrative_case_unit ?staff_officer - staff_officer)
    :precondition
      (and
        (unit_sponsor_acknowledged ?administrative_case_unit)
        (case_assigned_officer ?administrative_case_unit ?staff_officer)
        (not
          (unit_approval_for_accreditation ?administrative_case_unit)
        )
      )
    :effect (unit_approval_for_accreditation ?administrative_case_unit)
  )
  (:action confirm_unit_accreditation_review
    :parameters (?administrative_case_unit - administrative_case_unit ?accreditation_document - accreditation_document)
    :precondition
      (and
        (unit_approval_for_accreditation ?administrative_case_unit)
        (unit_has_accreditation_document ?administrative_case_unit ?accreditation_document)
        (not
          (unit_accreditation_stage ?administrative_case_unit)
        )
      )
    :effect (unit_accreditation_stage ?administrative_case_unit)
  )
  (:action finalize_unit_after_accreditation
    :parameters (?administrative_case_unit - administrative_case_unit)
    :precondition
      (and
        (unit_accreditation_stage ?administrative_case_unit)
        (not
          (unit_finalized ?administrative_case_unit)
        )
      )
    :effect
      (and
        (unit_finalized ?administrative_case_unit)
        (record_resolved ?administrative_case_unit)
      )
  )
  (:action apply_plan_and_finalize_student_record
    :parameters (?affected_student - affected_student ?replacement_plan - replacement_plan)
    :precondition
      (and
        (student_processing_mark ?affected_student)
        (student_ready_for_plan ?affected_student)
        (plan_compiled ?replacement_plan)
        (plan_ready_for_packaging ?replacement_plan)
        (not
          (record_resolved ?affected_student)
        )
      )
    :effect (record_resolved ?affected_student)
  )
  (:action apply_plan_and_finalize_peer_record
    :parameters (?peer_student - peer_student ?replacement_plan - replacement_plan)
    :precondition
      (and
        (peer_processing_mark ?peer_student)
        (peer_ready_for_plan ?peer_student)
        (plan_compiled ?replacement_plan)
        (plan_ready_for_packaging ?replacement_plan)
        (not
          (record_resolved ?peer_student)
        )
      )
    :effect (record_resolved ?peer_student)
  )
  (:action award_credit_artifact_to_case
    :parameters (?internship_case - internship_case ?credit_artifact - credit_artifact ?supporting_document - supporting_document)
    :precondition
      (and
        (record_resolved ?internship_case)
        (case_document_link ?internship_case ?supporting_document)
        (credit_artifact_available ?credit_artifact)
        (not
          (credit_awarded ?internship_case)
        )
      )
    :effect
      (and
        (credit_awarded ?internship_case)
        (case_has_credit_artifact ?internship_case ?credit_artifact)
        (not
          (credit_artifact_available ?credit_artifact)
        )
      )
  )
  (:action update_student_record_and_relink_slot
    :parameters (?affected_student - affected_student ?replacement_slot - replacement_slot ?credit_artifact - credit_artifact)
    :precondition
      (and
        (credit_awarded ?affected_student)
        (case_slot_link ?affected_student ?replacement_slot)
        (case_has_credit_artifact ?affected_student ?credit_artifact)
        (not
          (administrative_record_updated ?affected_student)
        )
      )
    :effect
      (and
        (administrative_record_updated ?affected_student)
        (slot_available ?replacement_slot)
        (credit_artifact_available ?credit_artifact)
      )
  )
  (:action update_peer_record_and_relink_slot
    :parameters (?peer_student - peer_student ?replacement_slot - replacement_slot ?credit_artifact - credit_artifact)
    :precondition
      (and
        (credit_awarded ?peer_student)
        (case_slot_link ?peer_student ?replacement_slot)
        (case_has_credit_artifact ?peer_student ?credit_artifact)
        (not
          (administrative_record_updated ?peer_student)
        )
      )
    :effect
      (and
        (administrative_record_updated ?peer_student)
        (slot_available ?replacement_slot)
        (credit_artifact_available ?credit_artifact)
      )
  )
  (:action update_admin_unit_and_relink_slot
    :parameters (?administrative_case_unit - administrative_case_unit ?replacement_slot - replacement_slot ?credit_artifact - credit_artifact)
    :precondition
      (and
        (credit_awarded ?administrative_case_unit)
        (case_slot_link ?administrative_case_unit ?replacement_slot)
        (case_has_credit_artifact ?administrative_case_unit ?credit_artifact)
        (not
          (administrative_record_updated ?administrative_case_unit)
        )
      )
    :effect
      (and
        (administrative_record_updated ?administrative_case_unit)
        (slot_available ?replacement_slot)
        (credit_artifact_available ?credit_artifact)
      )
  )
)

(define (domain education_system_outage_enrollment_recovery)
  (:requirements :strips :typing :negative-preconditions)
  (:types institutional_entity - object scheduling_component - object operational_asset - object case_root_type - object enrollment_case - case_root_type support_resource - institutional_entity system_artifact - institutional_entity approver - institutional_entity document - institutional_entity oversight_committee - institutional_entity communication_channel - institutional_entity technical_approval - institutional_entity audit_record - institutional_entity remediation_option - scheduling_component course_requirement - scheduling_component external_authority - scheduling_component student_schedule_slot - operational_asset instructor_schedule_slot - operational_asset recovery_plan - operational_asset case_participant - enrollment_case case_administrative_role - enrollment_case student_party - case_participant instructor_party - case_participant case_manager - case_administrative_role)
  (:predicates
    (entity_registered ?enrollment_case - enrollment_case)
    (subject_validated ?enrollment_case - enrollment_case)
    (entity_resource_allocation_recorded ?enrollment_case - enrollment_case)
    (recovery_applied ?enrollment_case - enrollment_case)
    (subject_ready_for_recovery ?enrollment_case - enrollment_case)
    (subject_finalized ?enrollment_case - enrollment_case)
    (support_resource_available ?support_resource - support_resource)
    (resource_assigned_to_subject ?enrollment_case - enrollment_case ?support_resource - support_resource)
    (artifact_available ?system_artifact - system_artifact)
    (artifact_attached_to_subject ?enrollment_case - enrollment_case ?system_artifact - system_artifact)
    (approver_available ?approver - approver)
    (approver_assigned_to_subject ?enrollment_case - enrollment_case ?approver - approver)
    (remediation_option_available ?remediation_option - remediation_option)
    (student_remediation_registered ?student_party - student_party ?remediation_option - remediation_option)
    (instructor_remediation_registered ?instructor_party - instructor_party ?remediation_option - remediation_option)
    (student_assigned_slot ?student_party - student_party ?student_schedule_slot - student_schedule_slot)
    (student_slot_reserved ?student_schedule_slot - student_schedule_slot)
    (student_slot_provisional ?student_schedule_slot - student_schedule_slot)
    (student_availability_confirmed ?student_party - student_party)
    (instructor_assigned_slot ?instructor_party - instructor_party ?instructor_schedule_slot - instructor_schedule_slot)
    (instructor_slot_reserved ?instructor_schedule_slot - instructor_schedule_slot)
    (instructor_slot_provisional ?instructor_schedule_slot - instructor_schedule_slot)
    (instructor_availability_confirmed ?instructor_party - instructor_party)
    (recovery_plan_draft ?recovery_plan - recovery_plan)
    (recovery_plan_created ?recovery_plan - recovery_plan)
    (recovery_plan_includes_student_slot ?recovery_plan - recovery_plan ?student_schedule_slot - student_schedule_slot)
    (recovery_plan_includes_instructor_slot ?recovery_plan - recovery_plan ?instructor_schedule_slot - instructor_schedule_slot)
    (recovery_plan_requires_department_approval ?recovery_plan - recovery_plan)
    (recovery_plan_requires_committee_approval ?recovery_plan - recovery_plan)
    (recovery_plan_locked ?recovery_plan - recovery_plan)
    (manager_assigned_to_student ?case_manager - case_manager ?student_party - student_party)
    (manager_assigned_to_instructor ?case_manager - case_manager ?instructor_party - instructor_party)
    (manager_assigned_to_plan ?case_manager - case_manager ?recovery_plan - recovery_plan)
    (course_requirement_available ?course_requirement - course_requirement)
    (manager_has_requirement ?case_manager - case_manager ?course_requirement - course_requirement)
    (course_requirement_verified ?course_requirement - course_requirement)
    (requirement_linked_to_plan ?course_requirement - course_requirement ?recovery_plan - recovery_plan)
    (manager_prepared_for_approval ?case_manager - case_manager)
    (manager_approval_initiated ?case_manager - case_manager)
    (manager_approval_finalized ?case_manager - case_manager)
    (manager_document_attached ?case_manager - case_manager)
    (manager_document_validated ?case_manager - case_manager)
    (manager_collected_multi_approvals ?case_manager - case_manager)
    (manager_final_verification_done ?case_manager - case_manager)
    (external_authority_available ?external_authority - external_authority)
    (manager_has_external_authority_link ?case_manager - case_manager ?external_authority - external_authority)
    (manager_external_routing_initiated ?case_manager - case_manager)
    (manager_external_response_recorded ?case_manager - case_manager)
    (manager_external_approval_confirmed ?case_manager - case_manager)
    (document_available ?document - document)
    (manager_document_assigned ?case_manager - case_manager ?document - document)
    (oversight_committee_available ?oversight_committee - oversight_committee)
    (manager_oversight_assigned ?case_manager - case_manager ?oversight_committee - oversight_committee)
    (technical_approval_available ?technical_approval - technical_approval)
    (manager_technical_approval_assigned ?case_manager - case_manager ?technical_approval - technical_approval)
    (audit_record_available ?audit_record - audit_record)
    (manager_audit_record_attached ?case_manager - case_manager ?audit_record - audit_record)
    (communication_channel_available ?communication_channel - communication_channel)
    (communication_channel_assigned_to_subject ?enrollment_case - enrollment_case ?communication_channel - communication_channel)
    (student_planning_eligible ?student_party - student_party)
    (instructor_planning_eligible ?instructor_party - instructor_party)
    (manager_case_marked_ready ?case_manager - case_manager)
  )
  (:action register_enrollment_case
    :parameters (?enrollment_case - enrollment_case)
    :precondition
      (and
        (not
          (entity_registered ?enrollment_case)
        )
        (not
          (recovery_applied ?enrollment_case)
        )
      )
    :effect (entity_registered ?enrollment_case)
  )
  (:action assign_support_resource_to_case
    :parameters (?enrollment_case - enrollment_case ?support_resource - support_resource)
    :precondition
      (and
        (entity_registered ?enrollment_case)
        (not
          (entity_resource_allocation_recorded ?enrollment_case)
        )
        (support_resource_available ?support_resource)
      )
    :effect
      (and
        (entity_resource_allocation_recorded ?enrollment_case)
        (resource_assigned_to_subject ?enrollment_case ?support_resource)
        (not
          (support_resource_available ?support_resource)
        )
      )
  )
  (:action attach_system_artifact_to_case
    :parameters (?enrollment_case - enrollment_case ?system_artifact - system_artifact)
    :precondition
      (and
        (entity_registered ?enrollment_case)
        (entity_resource_allocation_recorded ?enrollment_case)
        (artifact_available ?system_artifact)
      )
    :effect
      (and
        (artifact_attached_to_subject ?enrollment_case ?system_artifact)
        (not
          (artifact_available ?system_artifact)
        )
      )
  )
  (:action validate_case
    :parameters (?enrollment_case - enrollment_case ?system_artifact - system_artifact)
    :precondition
      (and
        (entity_registered ?enrollment_case)
        (entity_resource_allocation_recorded ?enrollment_case)
        (artifact_attached_to_subject ?enrollment_case ?system_artifact)
        (not
          (subject_validated ?enrollment_case)
        )
      )
    :effect (subject_validated ?enrollment_case)
  )
  (:action detach_system_artifact_from_case
    :parameters (?enrollment_case - enrollment_case ?system_artifact - system_artifact)
    :precondition
      (and
        (artifact_attached_to_subject ?enrollment_case ?system_artifact)
      )
    :effect
      (and
        (artifact_available ?system_artifact)
        (not
          (artifact_attached_to_subject ?enrollment_case ?system_artifact)
        )
      )
  )
  (:action assign_approver_to_case
    :parameters (?enrollment_case - enrollment_case ?approver - approver)
    :precondition
      (and
        (subject_validated ?enrollment_case)
        (approver_available ?approver)
      )
    :effect
      (and
        (approver_assigned_to_subject ?enrollment_case ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action release_approver_from_case
    :parameters (?enrollment_case - enrollment_case ?approver - approver)
    :precondition
      (and
        (approver_assigned_to_subject ?enrollment_case ?approver)
      )
    :effect
      (and
        (approver_available ?approver)
        (not
          (approver_assigned_to_subject ?enrollment_case ?approver)
        )
      )
  )
  (:action assign_technical_approval_to_manager
    :parameters (?case_manager - case_manager ?technical_approval - technical_approval)
    :precondition
      (and
        (subject_validated ?case_manager)
        (technical_approval_available ?technical_approval)
      )
    :effect
      (and
        (manager_technical_approval_assigned ?case_manager ?technical_approval)
        (not
          (technical_approval_available ?technical_approval)
        )
      )
  )
  (:action revoke_technical_approval_from_manager
    :parameters (?case_manager - case_manager ?technical_approval - technical_approval)
    :precondition
      (and
        (manager_technical_approval_assigned ?case_manager ?technical_approval)
      )
    :effect
      (and
        (technical_approval_available ?technical_approval)
        (not
          (manager_technical_approval_assigned ?case_manager ?technical_approval)
        )
      )
  )
  (:action attach_audit_record_to_manager
    :parameters (?case_manager - case_manager ?audit_record - audit_record)
    :precondition
      (and
        (subject_validated ?case_manager)
        (audit_record_available ?audit_record)
      )
    :effect
      (and
        (manager_audit_record_attached ?case_manager ?audit_record)
        (not
          (audit_record_available ?audit_record)
        )
      )
  )
  (:action revoke_audit_record_from_manager
    :parameters (?case_manager - case_manager ?audit_record - audit_record)
    :precondition
      (and
        (manager_audit_record_attached ?case_manager ?audit_record)
      )
    :effect
      (and
        (audit_record_available ?audit_record)
        (not
          (manager_audit_record_attached ?case_manager ?audit_record)
        )
      )
  )
  (:action reserve_student_schedule_slot
    :parameters (?student_party - student_party ?student_schedule_slot - student_schedule_slot ?system_artifact - system_artifact)
    :precondition
      (and
        (subject_validated ?student_party)
        (artifact_attached_to_subject ?student_party ?system_artifact)
        (student_assigned_slot ?student_party ?student_schedule_slot)
        (not
          (student_slot_reserved ?student_schedule_slot)
        )
        (not
          (student_slot_provisional ?student_schedule_slot)
        )
      )
    :effect (student_slot_reserved ?student_schedule_slot)
  )
  (:action approve_student_slot_by_approver
    :parameters (?student_party - student_party ?student_schedule_slot - student_schedule_slot ?approver - approver)
    :precondition
      (and
        (subject_validated ?student_party)
        (approver_assigned_to_subject ?student_party ?approver)
        (student_assigned_slot ?student_party ?student_schedule_slot)
        (student_slot_reserved ?student_schedule_slot)
        (not
          (student_planning_eligible ?student_party)
        )
      )
    :effect
      (and
        (student_planning_eligible ?student_party)
        (student_availability_confirmed ?student_party)
      )
  )
  (:action assign_remediation_option_to_student
    :parameters (?student_party - student_party ?student_schedule_slot - student_schedule_slot ?remediation_option - remediation_option)
    :precondition
      (and
        (subject_validated ?student_party)
        (student_assigned_slot ?student_party ?student_schedule_slot)
        (remediation_option_available ?remediation_option)
        (not
          (student_planning_eligible ?student_party)
        )
      )
    :effect
      (and
        (student_slot_provisional ?student_schedule_slot)
        (student_planning_eligible ?student_party)
        (student_remediation_registered ?student_party ?remediation_option)
        (not
          (remediation_option_available ?remediation_option)
        )
      )
  )
  (:action confirm_remediation_and_reserve_student_slot
    :parameters (?student_party - student_party ?student_schedule_slot - student_schedule_slot ?system_artifact - system_artifact ?remediation_option - remediation_option)
    :precondition
      (and
        (subject_validated ?student_party)
        (artifact_attached_to_subject ?student_party ?system_artifact)
        (student_assigned_slot ?student_party ?student_schedule_slot)
        (student_slot_provisional ?student_schedule_slot)
        (student_remediation_registered ?student_party ?remediation_option)
        (not
          (student_availability_confirmed ?student_party)
        )
      )
    :effect
      (and
        (student_slot_reserved ?student_schedule_slot)
        (student_availability_confirmed ?student_party)
        (remediation_option_available ?remediation_option)
        (not
          (student_remediation_registered ?student_party ?remediation_option)
        )
      )
  )
  (:action reserve_instructor_schedule_slot
    :parameters (?instructor_party - instructor_party ?instructor_schedule_slot - instructor_schedule_slot ?system_artifact - system_artifact)
    :precondition
      (and
        (subject_validated ?instructor_party)
        (artifact_attached_to_subject ?instructor_party ?system_artifact)
        (instructor_assigned_slot ?instructor_party ?instructor_schedule_slot)
        (not
          (instructor_slot_reserved ?instructor_schedule_slot)
        )
        (not
          (instructor_slot_provisional ?instructor_schedule_slot)
        )
      )
    :effect (instructor_slot_reserved ?instructor_schedule_slot)
  )
  (:action approve_instructor_slot_by_approver
    :parameters (?instructor_party - instructor_party ?instructor_schedule_slot - instructor_schedule_slot ?approver - approver)
    :precondition
      (and
        (subject_validated ?instructor_party)
        (approver_assigned_to_subject ?instructor_party ?approver)
        (instructor_assigned_slot ?instructor_party ?instructor_schedule_slot)
        (instructor_slot_reserved ?instructor_schedule_slot)
        (not
          (instructor_planning_eligible ?instructor_party)
        )
      )
    :effect
      (and
        (instructor_planning_eligible ?instructor_party)
        (instructor_availability_confirmed ?instructor_party)
      )
  )
  (:action assign_remediation_option_to_instructor
    :parameters (?instructor_party - instructor_party ?instructor_schedule_slot - instructor_schedule_slot ?remediation_option - remediation_option)
    :precondition
      (and
        (subject_validated ?instructor_party)
        (instructor_assigned_slot ?instructor_party ?instructor_schedule_slot)
        (remediation_option_available ?remediation_option)
        (not
          (instructor_planning_eligible ?instructor_party)
        )
      )
    :effect
      (and
        (instructor_slot_provisional ?instructor_schedule_slot)
        (instructor_planning_eligible ?instructor_party)
        (instructor_remediation_registered ?instructor_party ?remediation_option)
        (not
          (remediation_option_available ?remediation_option)
        )
      )
  )
  (:action confirm_remediation_and_reserve_instructor_slot
    :parameters (?instructor_party - instructor_party ?instructor_schedule_slot - instructor_schedule_slot ?system_artifact - system_artifact ?remediation_option - remediation_option)
    :precondition
      (and
        (subject_validated ?instructor_party)
        (artifact_attached_to_subject ?instructor_party ?system_artifact)
        (instructor_assigned_slot ?instructor_party ?instructor_schedule_slot)
        (instructor_slot_provisional ?instructor_schedule_slot)
        (instructor_remediation_registered ?instructor_party ?remediation_option)
        (not
          (instructor_availability_confirmed ?instructor_party)
        )
      )
    :effect
      (and
        (instructor_slot_reserved ?instructor_schedule_slot)
        (instructor_availability_confirmed ?instructor_party)
        (remediation_option_available ?remediation_option)
        (not
          (instructor_remediation_registered ?instructor_party ?remediation_option)
        )
      )
  )
  (:action assemble_recovery_plan_with_confirmed_slots
    :parameters (?student_party - student_party ?instructor_party - instructor_party ?student_schedule_slot - student_schedule_slot ?instructor_schedule_slot - instructor_schedule_slot ?recovery_plan - recovery_plan)
    :precondition
      (and
        (student_planning_eligible ?student_party)
        (instructor_planning_eligible ?instructor_party)
        (student_assigned_slot ?student_party ?student_schedule_slot)
        (instructor_assigned_slot ?instructor_party ?instructor_schedule_slot)
        (student_slot_reserved ?student_schedule_slot)
        (instructor_slot_reserved ?instructor_schedule_slot)
        (student_availability_confirmed ?student_party)
        (instructor_availability_confirmed ?instructor_party)
        (recovery_plan_draft ?recovery_plan)
      )
    :effect
      (and
        (recovery_plan_created ?recovery_plan)
        (recovery_plan_includes_student_slot ?recovery_plan ?student_schedule_slot)
        (recovery_plan_includes_instructor_slot ?recovery_plan ?instructor_schedule_slot)
        (not
          (recovery_plan_draft ?recovery_plan)
        )
      )
  )
  (:action assemble_recovery_plan_with_provisional_student_slot
    :parameters (?student_party - student_party ?instructor_party - instructor_party ?student_schedule_slot - student_schedule_slot ?instructor_schedule_slot - instructor_schedule_slot ?recovery_plan - recovery_plan)
    :precondition
      (and
        (student_planning_eligible ?student_party)
        (instructor_planning_eligible ?instructor_party)
        (student_assigned_slot ?student_party ?student_schedule_slot)
        (instructor_assigned_slot ?instructor_party ?instructor_schedule_slot)
        (student_slot_provisional ?student_schedule_slot)
        (instructor_slot_reserved ?instructor_schedule_slot)
        (not
          (student_availability_confirmed ?student_party)
        )
        (instructor_availability_confirmed ?instructor_party)
        (recovery_plan_draft ?recovery_plan)
      )
    :effect
      (and
        (recovery_plan_created ?recovery_plan)
        (recovery_plan_includes_student_slot ?recovery_plan ?student_schedule_slot)
        (recovery_plan_includes_instructor_slot ?recovery_plan ?instructor_schedule_slot)
        (recovery_plan_requires_department_approval ?recovery_plan)
        (not
          (recovery_plan_draft ?recovery_plan)
        )
      )
  )
  (:action assemble_recovery_plan_with_provisional_instructor_slot
    :parameters (?student_party - student_party ?instructor_party - instructor_party ?student_schedule_slot - student_schedule_slot ?instructor_schedule_slot - instructor_schedule_slot ?recovery_plan - recovery_plan)
    :precondition
      (and
        (student_planning_eligible ?student_party)
        (instructor_planning_eligible ?instructor_party)
        (student_assigned_slot ?student_party ?student_schedule_slot)
        (instructor_assigned_slot ?instructor_party ?instructor_schedule_slot)
        (student_slot_reserved ?student_schedule_slot)
        (instructor_slot_provisional ?instructor_schedule_slot)
        (student_availability_confirmed ?student_party)
        (not
          (instructor_availability_confirmed ?instructor_party)
        )
        (recovery_plan_draft ?recovery_plan)
      )
    :effect
      (and
        (recovery_plan_created ?recovery_plan)
        (recovery_plan_includes_student_slot ?recovery_plan ?student_schedule_slot)
        (recovery_plan_includes_instructor_slot ?recovery_plan ?instructor_schedule_slot)
        (recovery_plan_requires_committee_approval ?recovery_plan)
        (not
          (recovery_plan_draft ?recovery_plan)
        )
      )
  )
  (:action assemble_recovery_plan_with_provisional_slots
    :parameters (?student_party - student_party ?instructor_party - instructor_party ?student_schedule_slot - student_schedule_slot ?instructor_schedule_slot - instructor_schedule_slot ?recovery_plan - recovery_plan)
    :precondition
      (and
        (student_planning_eligible ?student_party)
        (instructor_planning_eligible ?instructor_party)
        (student_assigned_slot ?student_party ?student_schedule_slot)
        (instructor_assigned_slot ?instructor_party ?instructor_schedule_slot)
        (student_slot_provisional ?student_schedule_slot)
        (instructor_slot_provisional ?instructor_schedule_slot)
        (not
          (student_availability_confirmed ?student_party)
        )
        (not
          (instructor_availability_confirmed ?instructor_party)
        )
        (recovery_plan_draft ?recovery_plan)
      )
    :effect
      (and
        (recovery_plan_created ?recovery_plan)
        (recovery_plan_includes_student_slot ?recovery_plan ?student_schedule_slot)
        (recovery_plan_includes_instructor_slot ?recovery_plan ?instructor_schedule_slot)
        (recovery_plan_requires_department_approval ?recovery_plan)
        (recovery_plan_requires_committee_approval ?recovery_plan)
        (not
          (recovery_plan_draft ?recovery_plan)
        )
      )
  )
  (:action lock_recovery_plan_for_execution
    :parameters (?recovery_plan - recovery_plan ?student_party - student_party ?system_artifact - system_artifact)
    :precondition
      (and
        (recovery_plan_created ?recovery_plan)
        (student_planning_eligible ?student_party)
        (artifact_attached_to_subject ?student_party ?system_artifact)
        (not
          (recovery_plan_locked ?recovery_plan)
        )
      )
    :effect (recovery_plan_locked ?recovery_plan)
  )
  (:action verify_and_attach_course_requirement
    :parameters (?case_manager - case_manager ?course_requirement - course_requirement ?recovery_plan - recovery_plan)
    :precondition
      (and
        (subject_validated ?case_manager)
        (manager_assigned_to_plan ?case_manager ?recovery_plan)
        (manager_has_requirement ?case_manager ?course_requirement)
        (course_requirement_available ?course_requirement)
        (recovery_plan_created ?recovery_plan)
        (recovery_plan_locked ?recovery_plan)
        (not
          (course_requirement_verified ?course_requirement)
        )
      )
    :effect
      (and
        (course_requirement_verified ?course_requirement)
        (requirement_linked_to_plan ?course_requirement ?recovery_plan)
        (not
          (course_requirement_available ?course_requirement)
        )
      )
  )
  (:action prepare_manager_for_requirement_validation
    :parameters (?case_manager - case_manager ?course_requirement - course_requirement ?recovery_plan - recovery_plan ?system_artifact - system_artifact)
    :precondition
      (and
        (subject_validated ?case_manager)
        (manager_has_requirement ?case_manager ?course_requirement)
        (course_requirement_verified ?course_requirement)
        (requirement_linked_to_plan ?course_requirement ?recovery_plan)
        (artifact_attached_to_subject ?case_manager ?system_artifact)
        (not
          (recovery_plan_requires_department_approval ?recovery_plan)
        )
        (not
          (manager_prepared_for_approval ?case_manager)
        )
      )
    :effect (manager_prepared_for_approval ?case_manager)
  )
  (:action attach_document_to_manager
    :parameters (?case_manager - case_manager ?document - document)
    :precondition
      (and
        (subject_validated ?case_manager)
        (document_available ?document)
        (not
          (manager_document_attached ?case_manager)
        )
      )
    :effect
      (and
        (manager_document_attached ?case_manager)
        (manager_document_assigned ?case_manager ?document)
        (not
          (document_available ?document)
        )
      )
  )
  (:action validate_manager_documentation_for_plan
    :parameters (?case_manager - case_manager ?course_requirement - course_requirement ?recovery_plan - recovery_plan ?system_artifact - system_artifact ?document - document)
    :precondition
      (and
        (subject_validated ?case_manager)
        (manager_has_requirement ?case_manager ?course_requirement)
        (course_requirement_verified ?course_requirement)
        (requirement_linked_to_plan ?course_requirement ?recovery_plan)
        (artifact_attached_to_subject ?case_manager ?system_artifact)
        (recovery_plan_requires_department_approval ?recovery_plan)
        (manager_document_attached ?case_manager)
        (manager_document_assigned ?case_manager ?document)
        (not
          (manager_prepared_for_approval ?case_manager)
        )
      )
    :effect
      (and
        (manager_prepared_for_approval ?case_manager)
        (manager_document_validated ?case_manager)
      )
  )
  (:action initiate_manager_internal_approval
    :parameters (?case_manager - case_manager ?technical_approval - technical_approval ?approver - approver ?course_requirement - course_requirement ?recovery_plan - recovery_plan)
    :precondition
      (and
        (manager_prepared_for_approval ?case_manager)
        (manager_technical_approval_assigned ?case_manager ?technical_approval)
        (approver_assigned_to_subject ?case_manager ?approver)
        (manager_has_requirement ?case_manager ?course_requirement)
        (requirement_linked_to_plan ?course_requirement ?recovery_plan)
        (not
          (recovery_plan_requires_committee_approval ?recovery_plan)
        )
        (not
          (manager_approval_initiated ?case_manager)
        )
      )
    :effect (manager_approval_initiated ?case_manager)
  )
  (:action initiate_manager_internal_approval_with_committee_flag
    :parameters (?case_manager - case_manager ?technical_approval - technical_approval ?approver - approver ?course_requirement - course_requirement ?recovery_plan - recovery_plan)
    :precondition
      (and
        (manager_prepared_for_approval ?case_manager)
        (manager_technical_approval_assigned ?case_manager ?technical_approval)
        (approver_assigned_to_subject ?case_manager ?approver)
        (manager_has_requirement ?case_manager ?course_requirement)
        (requirement_linked_to_plan ?course_requirement ?recovery_plan)
        (recovery_plan_requires_committee_approval ?recovery_plan)
        (not
          (manager_approval_initiated ?case_manager)
        )
      )
    :effect (manager_approval_initiated ?case_manager)
  )
  (:action obtain_external_authority_approval_for_manager
    :parameters (?case_manager - case_manager ?audit_record - audit_record ?course_requirement - course_requirement ?recovery_plan - recovery_plan)
    :precondition
      (and
        (manager_approval_initiated ?case_manager)
        (manager_audit_record_attached ?case_manager ?audit_record)
        (manager_has_requirement ?case_manager ?course_requirement)
        (requirement_linked_to_plan ?course_requirement ?recovery_plan)
        (not
          (recovery_plan_requires_department_approval ?recovery_plan)
        )
        (not
          (recovery_plan_requires_committee_approval ?recovery_plan)
        )
        (not
          (manager_approval_finalized ?case_manager)
        )
      )
    :effect (manager_approval_finalized ?case_manager)
  )
  (:action obtain_external_authority_and_department_endorsement
    :parameters (?case_manager - case_manager ?audit_record - audit_record ?course_requirement - course_requirement ?recovery_plan - recovery_plan)
    :precondition
      (and
        (manager_approval_initiated ?case_manager)
        (manager_audit_record_attached ?case_manager ?audit_record)
        (manager_has_requirement ?case_manager ?course_requirement)
        (requirement_linked_to_plan ?course_requirement ?recovery_plan)
        (recovery_plan_requires_department_approval ?recovery_plan)
        (not
          (recovery_plan_requires_committee_approval ?recovery_plan)
        )
        (not
          (manager_approval_finalized ?case_manager)
        )
      )
    :effect
      (and
        (manager_approval_finalized ?case_manager)
        (manager_collected_multi_approvals ?case_manager)
      )
  )
  (:action obtain_external_authority_and_committee_endorsement
    :parameters (?case_manager - case_manager ?audit_record - audit_record ?course_requirement - course_requirement ?recovery_plan - recovery_plan)
    :precondition
      (and
        (manager_approval_initiated ?case_manager)
        (manager_audit_record_attached ?case_manager ?audit_record)
        (manager_has_requirement ?case_manager ?course_requirement)
        (requirement_linked_to_plan ?course_requirement ?recovery_plan)
        (not
          (recovery_plan_requires_department_approval ?recovery_plan)
        )
        (recovery_plan_requires_committee_approval ?recovery_plan)
        (not
          (manager_approval_finalized ?case_manager)
        )
      )
    :effect
      (and
        (manager_approval_finalized ?case_manager)
        (manager_collected_multi_approvals ?case_manager)
      )
  )
  (:action obtain_full_external_and_committee_endorsement
    :parameters (?case_manager - case_manager ?audit_record - audit_record ?course_requirement - course_requirement ?recovery_plan - recovery_plan)
    :precondition
      (and
        (manager_approval_initiated ?case_manager)
        (manager_audit_record_attached ?case_manager ?audit_record)
        (manager_has_requirement ?case_manager ?course_requirement)
        (requirement_linked_to_plan ?course_requirement ?recovery_plan)
        (recovery_plan_requires_department_approval ?recovery_plan)
        (recovery_plan_requires_committee_approval ?recovery_plan)
        (not
          (manager_approval_finalized ?case_manager)
        )
      )
    :effect
      (and
        (manager_approval_finalized ?case_manager)
        (manager_collected_multi_approvals ?case_manager)
      )
  )
  (:action perform_final_checks_and_mark_case_ready
    :parameters (?case_manager - case_manager)
    :precondition
      (and
        (manager_approval_finalized ?case_manager)
        (not
          (manager_collected_multi_approvals ?case_manager)
        )
        (not
          (manager_case_marked_ready ?case_manager)
        )
      )
    :effect
      (and
        (manager_case_marked_ready ?case_manager)
        (subject_ready_for_recovery ?case_manager)
      )
  )
  (:action assign_oversight_committee_to_manager
    :parameters (?case_manager - case_manager ?oversight_committee - oversight_committee)
    :precondition
      (and
        (manager_approval_finalized ?case_manager)
        (manager_collected_multi_approvals ?case_manager)
        (oversight_committee_available ?oversight_committee)
      )
    :effect
      (and
        (manager_oversight_assigned ?case_manager ?oversight_committee)
        (not
          (oversight_committee_available ?oversight_committee)
        )
      )
  )
  (:action complete_final_verification_for_case
    :parameters (?case_manager - case_manager ?student_party - student_party ?instructor_party - instructor_party ?system_artifact - system_artifact ?oversight_committee - oversight_committee)
    :precondition
      (and
        (manager_approval_finalized ?case_manager)
        (manager_collected_multi_approvals ?case_manager)
        (manager_oversight_assigned ?case_manager ?oversight_committee)
        (manager_assigned_to_student ?case_manager ?student_party)
        (manager_assigned_to_instructor ?case_manager ?instructor_party)
        (student_availability_confirmed ?student_party)
        (instructor_availability_confirmed ?instructor_party)
        (artifact_attached_to_subject ?case_manager ?system_artifact)
        (not
          (manager_final_verification_done ?case_manager)
        )
      )
    :effect (manager_final_verification_done ?case_manager)
  )
  (:action finalize_case_marking_after_checks
    :parameters (?case_manager - case_manager)
    :precondition
      (and
        (manager_approval_finalized ?case_manager)
        (manager_final_verification_done ?case_manager)
        (not
          (manager_case_marked_ready ?case_manager)
        )
      )
    :effect
      (and
        (manager_case_marked_ready ?case_manager)
        (subject_ready_for_recovery ?case_manager)
      )
  )
  (:action route_manager_to_external_authority
    :parameters (?case_manager - case_manager ?external_authority - external_authority ?system_artifact - system_artifact)
    :precondition
      (and
        (subject_validated ?case_manager)
        (artifact_attached_to_subject ?case_manager ?system_artifact)
        (external_authority_available ?external_authority)
        (manager_has_external_authority_link ?case_manager ?external_authority)
        (not
          (manager_external_routing_initiated ?case_manager)
        )
      )
    :effect
      (and
        (manager_external_routing_initiated ?case_manager)
        (not
          (external_authority_available ?external_authority)
        )
      )
  )
  (:action record_external_authority_response
    :parameters (?case_manager - case_manager ?approver - approver)
    :precondition
      (and
        (manager_external_routing_initiated ?case_manager)
        (approver_assigned_to_subject ?case_manager ?approver)
        (not
          (manager_external_response_recorded ?case_manager)
        )
      )
    :effect (manager_external_response_recorded ?case_manager)
  )
  (:action confirm_external_approval_with_audit
    :parameters (?case_manager - case_manager ?audit_record - audit_record)
    :precondition
      (and
        (manager_external_response_recorded ?case_manager)
        (manager_audit_record_attached ?case_manager ?audit_record)
        (not
          (manager_external_approval_confirmed ?case_manager)
        )
      )
    :effect (manager_external_approval_confirmed ?case_manager)
  )
  (:action finalize_external_approval_and_mark_case_ready
    :parameters (?case_manager - case_manager)
    :precondition
      (and
        (manager_external_approval_confirmed ?case_manager)
        (not
          (manager_case_marked_ready ?case_manager)
        )
      )
    :effect
      (and
        (manager_case_marked_ready ?case_manager)
        (subject_ready_for_recovery ?case_manager)
      )
  )
  (:action execute_student_recovery_from_plan
    :parameters (?student_party - student_party ?recovery_plan - recovery_plan)
    :precondition
      (and
        (student_planning_eligible ?student_party)
        (student_availability_confirmed ?student_party)
        (recovery_plan_created ?recovery_plan)
        (recovery_plan_locked ?recovery_plan)
        (not
          (subject_ready_for_recovery ?student_party)
        )
      )
    :effect (subject_ready_for_recovery ?student_party)
  )
  (:action execute_instructor_recovery_from_plan
    :parameters (?instructor_party - instructor_party ?recovery_plan - recovery_plan)
    :precondition
      (and
        (instructor_planning_eligible ?instructor_party)
        (instructor_availability_confirmed ?instructor_party)
        (recovery_plan_created ?recovery_plan)
        (recovery_plan_locked ?recovery_plan)
        (not
          (subject_ready_for_recovery ?instructor_party)
        )
      )
    :effect (subject_ready_for_recovery ?instructor_party)
  )
  (:action apply_administrative_correction_to_case
    :parameters (?enrollment_case - enrollment_case ?communication_channel - communication_channel ?system_artifact - system_artifact)
    :precondition
      (and
        (subject_ready_for_recovery ?enrollment_case)
        (artifact_attached_to_subject ?enrollment_case ?system_artifact)
        (communication_channel_available ?communication_channel)
        (not
          (subject_finalized ?enrollment_case)
        )
      )
    :effect
      (and
        (subject_finalized ?enrollment_case)
        (communication_channel_assigned_to_subject ?enrollment_case ?communication_channel)
        (not
          (communication_channel_available ?communication_channel)
        )
      )
  )
  (:action reassign_resource_and_notify_student
    :parameters (?student_party - student_party ?support_resource - support_resource ?communication_channel - communication_channel)
    :precondition
      (and
        (subject_finalized ?student_party)
        (resource_assigned_to_subject ?student_party ?support_resource)
        (communication_channel_assigned_to_subject ?student_party ?communication_channel)
        (not
          (recovery_applied ?student_party)
        )
      )
    :effect
      (and
        (recovery_applied ?student_party)
        (support_resource_available ?support_resource)
        (communication_channel_available ?communication_channel)
      )
  )
  (:action reassign_resource_and_notify_instructor
    :parameters (?instructor_party - instructor_party ?support_resource - support_resource ?communication_channel - communication_channel)
    :precondition
      (and
        (subject_finalized ?instructor_party)
        (resource_assigned_to_subject ?instructor_party ?support_resource)
        (communication_channel_assigned_to_subject ?instructor_party ?communication_channel)
        (not
          (recovery_applied ?instructor_party)
        )
      )
    :effect
      (and
        (recovery_applied ?instructor_party)
        (support_resource_available ?support_resource)
        (communication_channel_available ?communication_channel)
      )
  )
  (:action reassign_resource_and_notify_manager
    :parameters (?case_manager - case_manager ?support_resource - support_resource ?communication_channel - communication_channel)
    :precondition
      (and
        (subject_finalized ?case_manager)
        (resource_assigned_to_subject ?case_manager ?support_resource)
        (communication_channel_assigned_to_subject ?case_manager ?communication_channel)
        (not
          (recovery_applied ?case_manager)
        )
      )
    :effect
      (and
        (recovery_applied ?case_manager)
        (support_resource_available ?support_resource)
        (communication_channel_available ?communication_channel)
      )
  )
)

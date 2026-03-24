(define (domain manual_adjustment_approval_control)
  (:requirements :strips :typing :negative-preconditions)
  (:types unused_type_t19 - object unused_type_t20 - object unused_type_t21 - object case_root_alias - object approval_case - case_root_alias preparer_resource - unused_type_t19 adjustment_entry - unused_type_t19 approver_resource - unused_type_t19 compliance_certificate - unused_type_t19 audit_note - unused_type_t19 authorization_token - unused_type_t19 reviewer_signature - unused_type_t19 external_signature - unused_type_t19 supporting_evidence - unused_type_t20 attachment_file - unused_type_t20 external_reviewer - unused_type_t20 control_check - unused_type_t21 control_finding - unused_type_t21 reporting_package - unused_type_t21 case_subtype_container - approval_case case_subtype_container2 - approval_case preparation_case - case_subtype_container review_case - case_subtype_container case_work_item - case_subtype_container2)
  (:predicates
    (case_initiated ?approval_case - approval_case)
    (case_ready_for_assignment ?approval_case - approval_case)
    (case_preparer_allocated ?approval_case - approval_case)
    (case_released_for_posting ?approval_case - approval_case)
    (case_ready_for_signoff ?approval_case - approval_case)
    (case_authorized_flag ?approval_case - approval_case)
    (preparer_available ?preparer_resource - preparer_resource)
    (case_assigned_preparer ?approval_case - approval_case ?preparer_resource - preparer_resource)
    (entry_available ?adjustment_entry - adjustment_entry)
    (case_contains_entry ?approval_case - approval_case ?adjustment_entry - adjustment_entry)
    (approver_available ?approver_resource - approver_resource)
    (case_assigned_approver ?approval_case - approval_case ?approver_resource - approver_resource)
    (evidence_available ?supporting_evidence - supporting_evidence)
    (case_has_evidence ?preparation_case - preparation_case ?supporting_evidence - supporting_evidence)
    (case_has_reviewer_evidence ?review_case - review_case ?supporting_evidence - supporting_evidence)
    (case_mapped_controlcheck ?preparation_case - preparation_case ?control_check - control_check)
    (controlcheck_mark_passed ?control_check - control_check)
    (controlcheck_mark_failed ?control_check - control_check)
    (preparer_validation_completed ?preparation_case - preparation_case)
    (case_mapped_finding ?review_case - review_case ?control_finding - control_finding)
    (finding_flag_passed ?control_finding - control_finding)
    (finding_flag_failed ?control_finding - control_finding)
    (reviewer_validation_completed ?review_case - review_case)
    (package_open_for_assembly ?reporting_package - reporting_package)
    (package_sealed_for_review ?reporting_package - reporting_package)
    (package_includes_controlcheck ?reporting_package - reporting_package ?control_check - control_check)
    (package_includes_finding ?reporting_package - reporting_package ?control_finding - control_finding)
    (package_has_attachment_flag1 ?reporting_package - reporting_package)
    (package_has_attachment_flag2 ?reporting_package - reporting_package)
    (package_attachment_verified ?reporting_package - reporting_package)
    (workitem_links_preparer_case ?case_work_item - case_work_item ?preparation_case - preparation_case)
    (workitem_links_reviewer_case ?case_work_item - case_work_item ?review_case - review_case)
    (workitem_links_package ?case_work_item - case_work_item ?reporting_package - reporting_package)
    (attachment_available ?attachment_file - attachment_file)
    (workitem_has_attachment ?case_work_item - case_work_item ?attachment_file - attachment_file)
    (attachment_ingested ?attachment_file - attachment_file)
    (attachment_linked_to_package ?attachment_file - attachment_file ?reporting_package - reporting_package)
    (approver_stage_started ?case_work_item - case_work_item)
    (approver_signature_recorded ?case_work_item - case_work_item)
    (approver_action_required ?case_work_item - case_work_item)
    (workitem_compliance_certificate_flag ?case_work_item - case_work_item)
    (approver_evidence_enhanced ?case_work_item - case_work_item)
    (approver_additional_checks_passed ?case_work_item - case_work_item)
    (approver_certified ?case_work_item - case_work_item)
    (external_reviewer_candidate ?external_reviewer - external_reviewer)
    (workitem_assigned_external_reviewer ?case_work_item - case_work_item ?external_reviewer - external_reviewer)
    (external_reviewer_engaged_flag ?case_work_item - case_work_item)
    (external_reviewer_action_required ?case_work_item - case_work_item)
    (external_reviewer_signed ?case_work_item - case_work_item)
    (compliance_certificate_available_flag ?compliance_certificate - compliance_certificate)
    (workitem_has_compliance_certificate ?case_work_item - case_work_item ?compliance_certificate - compliance_certificate)
    (audit_note_available ?audit_note - audit_note)
    (workitem_has_audit_note ?case_work_item - case_work_item ?audit_note - audit_note)
    (reviewer_signature_available ?reviewer_signature - reviewer_signature)
    (workitem_bound_reviewer_signature ?case_work_item - case_work_item ?reviewer_signature - reviewer_signature)
    (external_signature_available ?external_signature - external_signature)
    (workitem_bound_external_signature ?case_work_item - case_work_item ?external_signature - external_signature)
    (authorization_token_available ?authorization_token - authorization_token)
    (case_bound_authorization_token ?approval_case - approval_case ?authorization_token - authorization_token)
    (preparer_stage_flag ?preparation_case - preparation_case)
    (reviewer_stage_flag ?review_case - review_case)
    (approver_signoff_recorded ?case_work_item - case_work_item)
  )
  (:action initiate_approval_case
    :parameters (?approval_case - approval_case)
    :precondition
      (and
        (not
          (case_initiated ?approval_case)
        )
        (not
          (case_released_for_posting ?approval_case)
        )
      )
    :effect (case_initiated ?approval_case)
  )
  (:action assign_preparer_to_case
    :parameters (?approval_case - approval_case ?preparer_resource - preparer_resource)
    :precondition
      (and
        (case_initiated ?approval_case)
        (not
          (case_preparer_allocated ?approval_case)
        )
        (preparer_available ?preparer_resource)
      )
    :effect
      (and
        (case_preparer_allocated ?approval_case)
        (case_assigned_preparer ?approval_case ?preparer_resource)
        (not
          (preparer_available ?preparer_resource)
        )
      )
  )
  (:action bind_adjustment_entry_to_case
    :parameters (?approval_case - approval_case ?adjustment_entry - adjustment_entry)
    :precondition
      (and
        (case_initiated ?approval_case)
        (case_preparer_allocated ?approval_case)
        (entry_available ?adjustment_entry)
      )
    :effect
      (and
        (case_contains_entry ?approval_case ?adjustment_entry)
        (not
          (entry_available ?adjustment_entry)
        )
      )
  )
  (:action mark_case_ready_for_assignment
    :parameters (?approval_case - approval_case ?adjustment_entry - adjustment_entry)
    :precondition
      (and
        (case_initiated ?approval_case)
        (case_preparer_allocated ?approval_case)
        (case_contains_entry ?approval_case ?adjustment_entry)
        (not
          (case_ready_for_assignment ?approval_case)
        )
      )
    :effect (case_ready_for_assignment ?approval_case)
  )
  (:action release_adjustment_entry_from_case
    :parameters (?approval_case - approval_case ?adjustment_entry - adjustment_entry)
    :precondition
      (and
        (case_contains_entry ?approval_case ?adjustment_entry)
      )
    :effect
      (and
        (entry_available ?adjustment_entry)
        (not
          (case_contains_entry ?approval_case ?adjustment_entry)
        )
      )
  )
  (:action assign_approver_to_case
    :parameters (?approval_case - approval_case ?approver_resource - approver_resource)
    :precondition
      (and
        (case_ready_for_assignment ?approval_case)
        (approver_available ?approver_resource)
      )
    :effect
      (and
        (case_assigned_approver ?approval_case ?approver_resource)
        (not
          (approver_available ?approver_resource)
        )
      )
  )
  (:action release_approver_from_case
    :parameters (?approval_case - approval_case ?approver_resource - approver_resource)
    :precondition
      (and
        (case_assigned_approver ?approval_case ?approver_resource)
      )
    :effect
      (and
        (approver_available ?approver_resource)
        (not
          (case_assigned_approver ?approval_case ?approver_resource)
        )
      )
  )
  (:action bind_reviewer_signature_to_workitem
    :parameters (?case_work_item - case_work_item ?reviewer_signature - reviewer_signature)
    :precondition
      (and
        (case_ready_for_assignment ?case_work_item)
        (reviewer_signature_available ?reviewer_signature)
      )
    :effect
      (and
        (workitem_bound_reviewer_signature ?case_work_item ?reviewer_signature)
        (not
          (reviewer_signature_available ?reviewer_signature)
        )
      )
  )
  (:action unbind_reviewer_signature_from_workitem
    :parameters (?case_work_item - case_work_item ?reviewer_signature - reviewer_signature)
    :precondition
      (and
        (workitem_bound_reviewer_signature ?case_work_item ?reviewer_signature)
      )
    :effect
      (and
        (reviewer_signature_available ?reviewer_signature)
        (not
          (workitem_bound_reviewer_signature ?case_work_item ?reviewer_signature)
        )
      )
  )
  (:action bind_external_signature_to_workitem
    :parameters (?case_work_item - case_work_item ?external_signature - external_signature)
    :precondition
      (and
        (case_ready_for_assignment ?case_work_item)
        (external_signature_available ?external_signature)
      )
    :effect
      (and
        (workitem_bound_external_signature ?case_work_item ?external_signature)
        (not
          (external_signature_available ?external_signature)
        )
      )
  )
  (:action unbind_external_signature_from_workitem
    :parameters (?case_work_item - case_work_item ?external_signature - external_signature)
    :precondition
      (and
        (workitem_bound_external_signature ?case_work_item ?external_signature)
      )
    :effect
      (and
        (external_signature_available ?external_signature)
        (not
          (workitem_bound_external_signature ?case_work_item ?external_signature)
        )
      )
  )
  (:action preparer_mark_controlcheck_passed
    :parameters (?preparation_case - preparation_case ?control_check - control_check ?adjustment_entry - adjustment_entry)
    :precondition
      (and
        (case_ready_for_assignment ?preparation_case)
        (case_contains_entry ?preparation_case ?adjustment_entry)
        (case_mapped_controlcheck ?preparation_case ?control_check)
        (not
          (controlcheck_mark_passed ?control_check)
        )
        (not
          (controlcheck_mark_failed ?control_check)
        )
      )
    :effect (controlcheck_mark_passed ?control_check)
  )
  (:action preparer_complete_validation_with_approver
    :parameters (?preparation_case - preparation_case ?control_check - control_check ?approver_resource - approver_resource)
    :precondition
      (and
        (case_ready_for_assignment ?preparation_case)
        (case_assigned_approver ?preparation_case ?approver_resource)
        (case_mapped_controlcheck ?preparation_case ?control_check)
        (controlcheck_mark_passed ?control_check)
        (not
          (preparer_stage_flag ?preparation_case)
        )
      )
    :effect
      (and
        (preparer_stage_flag ?preparation_case)
        (preparer_validation_completed ?preparation_case)
      )
  )
  (:action preparer_mark_controlcheck_failed_and_attach_evidence
    :parameters (?preparation_case - preparation_case ?control_check - control_check ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (case_ready_for_assignment ?preparation_case)
        (case_mapped_controlcheck ?preparation_case ?control_check)
        (evidence_available ?supporting_evidence)
        (not
          (preparer_stage_flag ?preparation_case)
        )
      )
    :effect
      (and
        (controlcheck_mark_failed ?control_check)
        (preparer_stage_flag ?preparation_case)
        (case_has_evidence ?preparation_case ?supporting_evidence)
        (not
          (evidence_available ?supporting_evidence)
        )
      )
  )
  (:action preparer_resolve_controlcheck_with_evidence
    :parameters (?preparation_case - preparation_case ?control_check - control_check ?adjustment_entry - adjustment_entry ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (case_ready_for_assignment ?preparation_case)
        (case_contains_entry ?preparation_case ?adjustment_entry)
        (case_mapped_controlcheck ?preparation_case ?control_check)
        (controlcheck_mark_failed ?control_check)
        (case_has_evidence ?preparation_case ?supporting_evidence)
        (not
          (preparer_validation_completed ?preparation_case)
        )
      )
    :effect
      (and
        (controlcheck_mark_passed ?control_check)
        (preparer_validation_completed ?preparation_case)
        (evidence_available ?supporting_evidence)
        (not
          (case_has_evidence ?preparation_case ?supporting_evidence)
        )
      )
  )
  (:action reviewer_mark_finding_passed
    :parameters (?review_case - review_case ?control_finding - control_finding ?adjustment_entry - adjustment_entry)
    :precondition
      (and
        (case_ready_for_assignment ?review_case)
        (case_contains_entry ?review_case ?adjustment_entry)
        (case_mapped_finding ?review_case ?control_finding)
        (not
          (finding_flag_passed ?control_finding)
        )
        (not
          (finding_flag_failed ?control_finding)
        )
      )
    :effect (finding_flag_passed ?control_finding)
  )
  (:action reviewer_complete_validation_with_approver
    :parameters (?review_case - review_case ?control_finding - control_finding ?approver_resource - approver_resource)
    :precondition
      (and
        (case_ready_for_assignment ?review_case)
        (case_assigned_approver ?review_case ?approver_resource)
        (case_mapped_finding ?review_case ?control_finding)
        (finding_flag_passed ?control_finding)
        (not
          (reviewer_stage_flag ?review_case)
        )
      )
    :effect
      (and
        (reviewer_stage_flag ?review_case)
        (reviewer_validation_completed ?review_case)
      )
  )
  (:action reviewer_mark_finding_failed_and_attach_evidence
    :parameters (?review_case - review_case ?control_finding - control_finding ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (case_ready_for_assignment ?review_case)
        (case_mapped_finding ?review_case ?control_finding)
        (evidence_available ?supporting_evidence)
        (not
          (reviewer_stage_flag ?review_case)
        )
      )
    :effect
      (and
        (finding_flag_failed ?control_finding)
        (reviewer_stage_flag ?review_case)
        (case_has_reviewer_evidence ?review_case ?supporting_evidence)
        (not
          (evidence_available ?supporting_evidence)
        )
      )
  )
  (:action reviewer_resolve_finding_with_evidence
    :parameters (?review_case - review_case ?control_finding - control_finding ?adjustment_entry - adjustment_entry ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (case_ready_for_assignment ?review_case)
        (case_contains_entry ?review_case ?adjustment_entry)
        (case_mapped_finding ?review_case ?control_finding)
        (finding_flag_failed ?control_finding)
        (case_has_reviewer_evidence ?review_case ?supporting_evidence)
        (not
          (reviewer_validation_completed ?review_case)
        )
      )
    :effect
      (and
        (finding_flag_passed ?control_finding)
        (reviewer_validation_completed ?review_case)
        (evidence_available ?supporting_evidence)
        (not
          (case_has_reviewer_evidence ?review_case ?supporting_evidence)
        )
      )
  )
  (:action assemble_and_seal_reporting_package
    :parameters (?preparation_case - preparation_case ?review_case - review_case ?control_check - control_check ?control_finding - control_finding ?reporting_package - reporting_package)
    :precondition
      (and
        (preparer_stage_flag ?preparation_case)
        (reviewer_stage_flag ?review_case)
        (case_mapped_controlcheck ?preparation_case ?control_check)
        (case_mapped_finding ?review_case ?control_finding)
        (controlcheck_mark_passed ?control_check)
        (finding_flag_passed ?control_finding)
        (preparer_validation_completed ?preparation_case)
        (reviewer_validation_completed ?review_case)
        (package_open_for_assembly ?reporting_package)
      )
    :effect
      (and
        (package_sealed_for_review ?reporting_package)
        (package_includes_controlcheck ?reporting_package ?control_check)
        (package_includes_finding ?reporting_package ?control_finding)
        (not
          (package_open_for_assembly ?reporting_package)
        )
      )
  )
  (:action assemble_and_seal_reporting_package_with_attachment_flag1
    :parameters (?preparation_case - preparation_case ?review_case - review_case ?control_check - control_check ?control_finding - control_finding ?reporting_package - reporting_package)
    :precondition
      (and
        (preparer_stage_flag ?preparation_case)
        (reviewer_stage_flag ?review_case)
        (case_mapped_controlcheck ?preparation_case ?control_check)
        (case_mapped_finding ?review_case ?control_finding)
        (controlcheck_mark_failed ?control_check)
        (finding_flag_passed ?control_finding)
        (not
          (preparer_validation_completed ?preparation_case)
        )
        (reviewer_validation_completed ?review_case)
        (package_open_for_assembly ?reporting_package)
      )
    :effect
      (and
        (package_sealed_for_review ?reporting_package)
        (package_includes_controlcheck ?reporting_package ?control_check)
        (package_includes_finding ?reporting_package ?control_finding)
        (package_has_attachment_flag1 ?reporting_package)
        (not
          (package_open_for_assembly ?reporting_package)
        )
      )
  )
  (:action assemble_and_seal_reporting_package_with_attachment_flag2
    :parameters (?preparation_case - preparation_case ?review_case - review_case ?control_check - control_check ?control_finding - control_finding ?reporting_package - reporting_package)
    :precondition
      (and
        (preparer_stage_flag ?preparation_case)
        (reviewer_stage_flag ?review_case)
        (case_mapped_controlcheck ?preparation_case ?control_check)
        (case_mapped_finding ?review_case ?control_finding)
        (controlcheck_mark_passed ?control_check)
        (finding_flag_failed ?control_finding)
        (preparer_validation_completed ?preparation_case)
        (not
          (reviewer_validation_completed ?review_case)
        )
        (package_open_for_assembly ?reporting_package)
      )
    :effect
      (and
        (package_sealed_for_review ?reporting_package)
        (package_includes_controlcheck ?reporting_package ?control_check)
        (package_includes_finding ?reporting_package ?control_finding)
        (package_has_attachment_flag2 ?reporting_package)
        (not
          (package_open_for_assembly ?reporting_package)
        )
      )
  )
  (:action assemble_and_seal_reporting_package_with_both_attachment_flags
    :parameters (?preparation_case - preparation_case ?review_case - review_case ?control_check - control_check ?control_finding - control_finding ?reporting_package - reporting_package)
    :precondition
      (and
        (preparer_stage_flag ?preparation_case)
        (reviewer_stage_flag ?review_case)
        (case_mapped_controlcheck ?preparation_case ?control_check)
        (case_mapped_finding ?review_case ?control_finding)
        (controlcheck_mark_failed ?control_check)
        (finding_flag_failed ?control_finding)
        (not
          (preparer_validation_completed ?preparation_case)
        )
        (not
          (reviewer_validation_completed ?review_case)
        )
        (package_open_for_assembly ?reporting_package)
      )
    :effect
      (and
        (package_sealed_for_review ?reporting_package)
        (package_includes_controlcheck ?reporting_package ?control_check)
        (package_includes_finding ?reporting_package ?control_finding)
        (package_has_attachment_flag1 ?reporting_package)
        (package_has_attachment_flag2 ?reporting_package)
        (not
          (package_open_for_assembly ?reporting_package)
        )
      )
  )
  (:action verify_package_attachments
    :parameters (?reporting_package - reporting_package ?preparation_case - preparation_case ?adjustment_entry - adjustment_entry)
    :precondition
      (and
        (package_sealed_for_review ?reporting_package)
        (preparer_stage_flag ?preparation_case)
        (case_contains_entry ?preparation_case ?adjustment_entry)
        (not
          (package_attachment_verified ?reporting_package)
        )
      )
    :effect (package_attachment_verified ?reporting_package)
  )
  (:action ingest_attachment_into_package
    :parameters (?case_work_item - case_work_item ?attachment_file - attachment_file ?reporting_package - reporting_package)
    :precondition
      (and
        (case_ready_for_assignment ?case_work_item)
        (workitem_links_package ?case_work_item ?reporting_package)
        (workitem_has_attachment ?case_work_item ?attachment_file)
        (attachment_available ?attachment_file)
        (package_sealed_for_review ?reporting_package)
        (package_attachment_verified ?reporting_package)
        (not
          (attachment_ingested ?attachment_file)
        )
      )
    :effect
      (and
        (attachment_ingested ?attachment_file)
        (attachment_linked_to_package ?attachment_file ?reporting_package)
        (not
          (attachment_available ?attachment_file)
        )
      )
  )
  (:action start_approver_stage_for_workitem
    :parameters (?case_work_item - case_work_item ?attachment_file - attachment_file ?reporting_package - reporting_package ?adjustment_entry - adjustment_entry)
    :precondition
      (and
        (case_ready_for_assignment ?case_work_item)
        (workitem_has_attachment ?case_work_item ?attachment_file)
        (attachment_ingested ?attachment_file)
        (attachment_linked_to_package ?attachment_file ?reporting_package)
        (case_contains_entry ?case_work_item ?adjustment_entry)
        (not
          (package_has_attachment_flag1 ?reporting_package)
        )
        (not
          (approver_stage_started ?case_work_item)
        )
      )
    :effect (approver_stage_started ?case_work_item)
  )
  (:action attach_compliance_certificate_to_workitem
    :parameters (?case_work_item - case_work_item ?compliance_certificate - compliance_certificate)
    :precondition
      (and
        (case_ready_for_assignment ?case_work_item)
        (compliance_certificate_available_flag ?compliance_certificate)
        (not
          (workitem_compliance_certificate_flag ?case_work_item)
        )
      )
    :effect
      (and
        (workitem_compliance_certificate_flag ?case_work_item)
        (workitem_has_compliance_certificate ?case_work_item ?compliance_certificate)
        (not
          (compliance_certificate_available_flag ?compliance_certificate)
        )
      )
  )
  (:action activate_approver_stage_with_certificate
    :parameters (?case_work_item - case_work_item ?attachment_file - attachment_file ?reporting_package - reporting_package ?adjustment_entry - adjustment_entry ?compliance_certificate - compliance_certificate)
    :precondition
      (and
        (case_ready_for_assignment ?case_work_item)
        (workitem_has_attachment ?case_work_item ?attachment_file)
        (attachment_ingested ?attachment_file)
        (attachment_linked_to_package ?attachment_file ?reporting_package)
        (case_contains_entry ?case_work_item ?adjustment_entry)
        (package_has_attachment_flag1 ?reporting_package)
        (workitem_compliance_certificate_flag ?case_work_item)
        (workitem_has_compliance_certificate ?case_work_item ?compliance_certificate)
        (not
          (approver_stage_started ?case_work_item)
        )
      )
    :effect
      (and
        (approver_stage_started ?case_work_item)
        (approver_evidence_enhanced ?case_work_item)
      )
  )
  (:action record_internal_approver_signature_without_attachment_flag2
    :parameters (?case_work_item - case_work_item ?reviewer_signature - reviewer_signature ?approver_resource - approver_resource ?attachment_file - attachment_file ?reporting_package - reporting_package)
    :precondition
      (and
        (approver_stage_started ?case_work_item)
        (workitem_bound_reviewer_signature ?case_work_item ?reviewer_signature)
        (case_assigned_approver ?case_work_item ?approver_resource)
        (workitem_has_attachment ?case_work_item ?attachment_file)
        (attachment_linked_to_package ?attachment_file ?reporting_package)
        (not
          (package_has_attachment_flag2 ?reporting_package)
        )
        (not
          (approver_signature_recorded ?case_work_item)
        )
      )
    :effect (approver_signature_recorded ?case_work_item)
  )
  (:action record_internal_approver_signature_with_attachment_flag2
    :parameters (?case_work_item - case_work_item ?reviewer_signature - reviewer_signature ?approver_resource - approver_resource ?attachment_file - attachment_file ?reporting_package - reporting_package)
    :precondition
      (and
        (approver_stage_started ?case_work_item)
        (workitem_bound_reviewer_signature ?case_work_item ?reviewer_signature)
        (case_assigned_approver ?case_work_item ?approver_resource)
        (workitem_has_attachment ?case_work_item ?attachment_file)
        (attachment_linked_to_package ?attachment_file ?reporting_package)
        (package_has_attachment_flag2 ?reporting_package)
        (not
          (approver_signature_recorded ?case_work_item)
        )
      )
    :effect (approver_signature_recorded ?case_work_item)
  )
  (:action flag_workitem_for_approver_action_without_attachment_flags
    :parameters (?case_work_item - case_work_item ?external_signature - external_signature ?attachment_file - attachment_file ?reporting_package - reporting_package)
    :precondition
      (and
        (approver_signature_recorded ?case_work_item)
        (workitem_bound_external_signature ?case_work_item ?external_signature)
        (workitem_has_attachment ?case_work_item ?attachment_file)
        (attachment_linked_to_package ?attachment_file ?reporting_package)
        (not
          (package_has_attachment_flag1 ?reporting_package)
        )
        (not
          (package_has_attachment_flag2 ?reporting_package)
        )
        (not
          (approver_action_required ?case_work_item)
        )
      )
    :effect (approver_action_required ?case_work_item)
  )
  (:action record_approver_additional_checks_with_attachment_flag1
    :parameters (?case_work_item - case_work_item ?external_signature - external_signature ?attachment_file - attachment_file ?reporting_package - reporting_package)
    :precondition
      (and
        (approver_signature_recorded ?case_work_item)
        (workitem_bound_external_signature ?case_work_item ?external_signature)
        (workitem_has_attachment ?case_work_item ?attachment_file)
        (attachment_linked_to_package ?attachment_file ?reporting_package)
        (package_has_attachment_flag1 ?reporting_package)
        (not
          (package_has_attachment_flag2 ?reporting_package)
        )
        (not
          (approver_action_required ?case_work_item)
        )
      )
    :effect
      (and
        (approver_action_required ?case_work_item)
        (approver_additional_checks_passed ?case_work_item)
      )
  )
  (:action record_approver_additional_checks_with_attachment_flag2
    :parameters (?case_work_item - case_work_item ?external_signature - external_signature ?attachment_file - attachment_file ?reporting_package - reporting_package)
    :precondition
      (and
        (approver_signature_recorded ?case_work_item)
        (workitem_bound_external_signature ?case_work_item ?external_signature)
        (workitem_has_attachment ?case_work_item ?attachment_file)
        (attachment_linked_to_package ?attachment_file ?reporting_package)
        (not
          (package_has_attachment_flag1 ?reporting_package)
        )
        (package_has_attachment_flag2 ?reporting_package)
        (not
          (approver_action_required ?case_work_item)
        )
      )
    :effect
      (and
        (approver_action_required ?case_work_item)
        (approver_additional_checks_passed ?case_work_item)
      )
  )
  (:action record_approver_additional_checks_with_both_attachment_flags
    :parameters (?case_work_item - case_work_item ?external_signature - external_signature ?attachment_file - attachment_file ?reporting_package - reporting_package)
    :precondition
      (and
        (approver_signature_recorded ?case_work_item)
        (workitem_bound_external_signature ?case_work_item ?external_signature)
        (workitem_has_attachment ?case_work_item ?attachment_file)
        (attachment_linked_to_package ?attachment_file ?reporting_package)
        (package_has_attachment_flag1 ?reporting_package)
        (package_has_attachment_flag2 ?reporting_package)
        (not
          (approver_action_required ?case_work_item)
        )
      )
    :effect
      (and
        (approver_action_required ?case_work_item)
        (approver_additional_checks_passed ?case_work_item)
      )
  )
  (:action finalize_approver_signoff_without_additional_checks
    :parameters (?case_work_item - case_work_item)
    :precondition
      (and
        (approver_action_required ?case_work_item)
        (not
          (approver_additional_checks_passed ?case_work_item)
        )
        (not
          (approver_signoff_recorded ?case_work_item)
        )
      )
    :effect
      (and
        (approver_signoff_recorded ?case_work_item)
        (case_ready_for_signoff ?case_work_item)
      )
  )
  (:action attach_audit_note_to_workitem
    :parameters (?case_work_item - case_work_item ?audit_note - audit_note)
    :precondition
      (and
        (approver_action_required ?case_work_item)
        (approver_additional_checks_passed ?case_work_item)
        (audit_note_available ?audit_note)
      )
    :effect
      (and
        (workitem_has_audit_note ?case_work_item ?audit_note)
        (not
          (audit_note_available ?audit_note)
        )
      )
  )
  (:action complete_approver_certification
    :parameters (?case_work_item - case_work_item ?preparation_case - preparation_case ?review_case - review_case ?adjustment_entry - adjustment_entry ?audit_note - audit_note)
    :precondition
      (and
        (approver_action_required ?case_work_item)
        (approver_additional_checks_passed ?case_work_item)
        (workitem_has_audit_note ?case_work_item ?audit_note)
        (workitem_links_preparer_case ?case_work_item ?preparation_case)
        (workitem_links_reviewer_case ?case_work_item ?review_case)
        (preparer_validation_completed ?preparation_case)
        (reviewer_validation_completed ?review_case)
        (case_contains_entry ?case_work_item ?adjustment_entry)
        (not
          (approver_certified ?case_work_item)
        )
      )
    :effect (approver_certified ?case_work_item)
  )
  (:action finalize_approver_signoff_after_certification
    :parameters (?case_work_item - case_work_item)
    :precondition
      (and
        (approver_action_required ?case_work_item)
        (approver_certified ?case_work_item)
        (not
          (approver_signoff_recorded ?case_work_item)
        )
      )
    :effect
      (and
        (approver_signoff_recorded ?case_work_item)
        (case_ready_for_signoff ?case_work_item)
      )
  )
  (:action engage_external_reviewer_for_workitem
    :parameters (?case_work_item - case_work_item ?external_reviewer - external_reviewer ?adjustment_entry - adjustment_entry)
    :precondition
      (and
        (case_ready_for_assignment ?case_work_item)
        (case_contains_entry ?case_work_item ?adjustment_entry)
        (external_reviewer_candidate ?external_reviewer)
        (workitem_assigned_external_reviewer ?case_work_item ?external_reviewer)
        (not
          (external_reviewer_engaged_flag ?case_work_item)
        )
      )
    :effect
      (and
        (external_reviewer_engaged_flag ?case_work_item)
        (not
          (external_reviewer_candidate ?external_reviewer)
        )
      )
  )
  (:action flag_external_reviewer_action_required
    :parameters (?case_work_item - case_work_item ?approver_resource - approver_resource)
    :precondition
      (and
        (external_reviewer_engaged_flag ?case_work_item)
        (case_assigned_approver ?case_work_item ?approver_resource)
        (not
          (external_reviewer_action_required ?case_work_item)
        )
      )
    :effect (external_reviewer_action_required ?case_work_item)
  )
  (:action record_external_reviewer_signature
    :parameters (?case_work_item - case_work_item ?external_signature - external_signature)
    :precondition
      (and
        (external_reviewer_action_required ?case_work_item)
        (workitem_bound_external_signature ?case_work_item ?external_signature)
        (not
          (external_reviewer_signed ?case_work_item)
        )
      )
    :effect (external_reviewer_signed ?case_work_item)
  )
  (:action finalize_external_reviewer_signoff
    :parameters (?case_work_item - case_work_item)
    :precondition
      (and
        (external_reviewer_signed ?case_work_item)
        (not
          (approver_signoff_recorded ?case_work_item)
        )
      )
    :effect
      (and
        (approver_signoff_recorded ?case_work_item)
        (case_ready_for_signoff ?case_work_item)
      )
  )
  (:action preparer_mark_case_ready_for_signoff
    :parameters (?preparation_case - preparation_case ?reporting_package - reporting_package)
    :precondition
      (and
        (preparer_stage_flag ?preparation_case)
        (preparer_validation_completed ?preparation_case)
        (package_sealed_for_review ?reporting_package)
        (package_attachment_verified ?reporting_package)
        (not
          (case_ready_for_signoff ?preparation_case)
        )
      )
    :effect (case_ready_for_signoff ?preparation_case)
  )
  (:action reviewer_mark_case_ready_for_signoff
    :parameters (?review_case - review_case ?reporting_package - reporting_package)
    :precondition
      (and
        (reviewer_stage_flag ?review_case)
        (reviewer_validation_completed ?review_case)
        (package_sealed_for_review ?reporting_package)
        (package_attachment_verified ?reporting_package)
        (not
          (case_ready_for_signoff ?review_case)
        )
      )
    :effect (case_ready_for_signoff ?review_case)
  )
  (:action authorize_case_with_authorization_token
    :parameters (?approval_case - approval_case ?authorization_token - authorization_token ?adjustment_entry - adjustment_entry)
    :precondition
      (and
        (case_ready_for_signoff ?approval_case)
        (case_contains_entry ?approval_case ?adjustment_entry)
        (authorization_token_available ?authorization_token)
        (not
          (case_authorized_flag ?approval_case)
        )
      )
    :effect
      (and
        (case_authorized_flag ?approval_case)
        (case_bound_authorization_token ?approval_case ?authorization_token)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action release_preparation_case_for_posting
    :parameters (?preparation_case - preparation_case ?preparer_resource - preparer_resource ?authorization_token - authorization_token)
    :precondition
      (and
        (case_authorized_flag ?preparation_case)
        (case_assigned_preparer ?preparation_case ?preparer_resource)
        (case_bound_authorization_token ?preparation_case ?authorization_token)
        (not
          (case_released_for_posting ?preparation_case)
        )
      )
    :effect
      (and
        (case_released_for_posting ?preparation_case)
        (preparer_available ?preparer_resource)
        (authorization_token_available ?authorization_token)
      )
  )
  (:action release_review_case_for_posting
    :parameters (?review_case - review_case ?preparer_resource - preparer_resource ?authorization_token - authorization_token)
    :precondition
      (and
        (case_authorized_flag ?review_case)
        (case_assigned_preparer ?review_case ?preparer_resource)
        (case_bound_authorization_token ?review_case ?authorization_token)
        (not
          (case_released_for_posting ?review_case)
        )
      )
    :effect
      (and
        (case_released_for_posting ?review_case)
        (preparer_available ?preparer_resource)
        (authorization_token_available ?authorization_token)
      )
  )
  (:action release_workitem_for_posting
    :parameters (?case_work_item - case_work_item ?preparer_resource - preparer_resource ?authorization_token - authorization_token)
    :precondition
      (and
        (case_authorized_flag ?case_work_item)
        (case_assigned_preparer ?case_work_item ?preparer_resource)
        (case_bound_authorization_token ?case_work_item ?authorization_token)
        (not
          (case_released_for_posting ?case_work_item)
        )
      )
    :effect
      (and
        (case_released_for_posting ?case_work_item)
        (preparer_available ?preparer_resource)
        (authorization_token_available ?authorization_token)
      )
  )
)

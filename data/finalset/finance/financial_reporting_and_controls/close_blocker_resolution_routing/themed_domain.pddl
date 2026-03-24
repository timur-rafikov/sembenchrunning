(define (domain finance_close_blocker_resolution_routing)
  (:requirements :strips :typing :negative-preconditions)
  (:types workflow_resource - object work_product_type - object document_category - object blocker_category - object blocker_entity - blocker_category routing_queue - workflow_resource investigator - workflow_resource approver - workflow_resource support_document_template - workflow_resource control_attachment_template - workflow_resource routing_token - workflow_resource technical_reviewer - workflow_resource audit_reviewer - workflow_resource support_evidence - work_product_type reporting_component - work_product_type audit_finding_reference - work_product_type reconciliation - document_category variance_record - document_category close_package - document_category account_scope - blocker_entity entity_scope - blocker_entity account - account_scope operating_unit - account_scope close_task - entity_scope)
  (:predicates
    (blocker_entity_created ?blocker_ticket - blocker_entity)
    (blocker_entity_triaged ?blocker_ticket - blocker_entity)
    (blocker_entity_queued ?blocker_ticket - blocker_entity)
    (blocker_entity_resolved ?blocker_ticket - blocker_entity)
    (blocker_entity_ready_for_routing_completion ?blocker_ticket - blocker_entity)
    (blocker_entity_routing_initiated ?blocker_ticket - blocker_entity)
    (routing_queue_available ?routing_queue - routing_queue)
    (blocker_entity_assigned_to_routing_queue ?blocker_ticket - blocker_entity ?routing_queue - routing_queue)
    (investigator_available ?investigator - investigator)
    (blocker_entity_assigned_investigator ?blocker_ticket - blocker_entity ?investigator - investigator)
    (approver_available ?approver - approver)
    (blocker_entity_assigned_approver ?blocker_ticket - blocker_entity ?approver - approver)
    (support_evidence_available ?support_evidence - support_evidence)
    (account_attached_support_evidence ?account - account ?support_evidence - support_evidence)
    (operating_unit_attached_support_evidence ?operating_unit - operating_unit ?support_evidence - support_evidence)
    (account_linked_reconciliation ?account - account ?reconciliation - reconciliation)
    (reconciliation_investigation_started ?reconciliation - reconciliation)
    (reconciliation_support_attached ?reconciliation - reconciliation)
    (account_investigation_complete ?account - account)
    (operating_unit_linked_variance_record ?operating_unit - operating_unit ?variance_record - variance_record)
    (variance_record_active ?variance_record - variance_record)
    (variance_record_support_attached ?variance_record - variance_record)
    (operating_unit_ready_for_package ?operating_unit - operating_unit)
    (close_package_pending_assembly ?close_package - close_package)
    (close_package_populated ?close_package - close_package)
    (close_package_linked_reconciliation ?close_package - close_package ?reconciliation - reconciliation)
    (close_package_linked_variance_record ?close_package - close_package ?variance_record - variance_record)
    (close_package_requires_technical_review ?close_package - close_package)
    (close_package_requires_audit_review ?close_package - close_package)
    (close_package_prevalidated ?close_package - close_package)
    (close_task_assigned_account ?close_task - close_task ?account - account)
    (close_task_assigned_operating_unit ?close_task - close_task ?operating_unit - operating_unit)
    (close_task_linked_close_package ?close_task - close_task ?close_package - close_package)
    (reporting_component_available ?reporting_component - reporting_component)
    (close_task_attached_reporting_component ?close_task - close_task ?reporting_component - reporting_component)
    (reporting_component_allocated ?reporting_component - reporting_component)
    (reporting_component_linked_close_package ?reporting_component - reporting_component ?close_package - close_package)
    (close_task_reporting_component_prevalidated ?close_task - close_task)
    (close_task_specialist_validated ?close_task - close_task)
    (close_task_specialist_reviews_complete ?close_task - close_task)
    (close_task_assigned_support_document_template ?close_task - close_task)
    (close_task_support_document_processed ?close_task - close_task)
    (close_task_requires_control_attachment ?close_task - close_task)
    (close_task_final_control_checks_complete ?close_task - close_task)
    (audit_finding_reference_available ?audit_finding_reference - audit_finding_reference)
    (close_task_linked_audit_finding_reference ?close_task - close_task ?audit_finding_reference - audit_finding_reference)
    (close_task_audit_reference_onboarded ?close_task - close_task)
    (close_task_approver_engaged ?close_task - close_task)
    (close_task_approval_obtained ?close_task - close_task)
    (support_document_template_available ?support_document_template - support_document_template)
    (close_task_linked_support_document_template ?close_task - close_task ?support_document_template - support_document_template)
    (control_attachment_template_available ?control_attachment_template - control_attachment_template)
    (close_task_linked_control_attachment_template ?close_task - close_task ?control_attachment_template - control_attachment_template)
    (technical_reviewer_available ?technical_reviewer - technical_reviewer)
    (close_task_assigned_technical_reviewer ?close_task - close_task ?technical_reviewer - technical_reviewer)
    (audit_reviewer_available ?audit_reviewer - audit_reviewer)
    (close_task_assigned_audit_reviewer ?close_task - close_task ?audit_reviewer - audit_reviewer)
    (routing_token_available ?routing_token - routing_token)
    (blocker_entity_assigned_routing_token ?blocker_ticket - blocker_entity ?routing_token - routing_token)
    (account_investigation_in_progress ?account - account)
    (operating_unit_investigation_in_progress ?operating_unit - operating_unit)
    (close_task_finalized ?close_task - close_task)
  )
  (:action create_blocker_entity
    :parameters (?blocker_ticket - blocker_entity)
    :precondition
      (and
        (not
          (blocker_entity_created ?blocker_ticket)
        )
        (not
          (blocker_entity_resolved ?blocker_ticket)
        )
      )
    :effect (blocker_entity_created ?blocker_ticket)
  )
  (:action assign_blocker_to_routing_queue
    :parameters (?blocker_ticket - blocker_entity ?routing_queue - routing_queue)
    :precondition
      (and
        (blocker_entity_created ?blocker_ticket)
        (not
          (blocker_entity_queued ?blocker_ticket)
        )
        (routing_queue_available ?routing_queue)
      )
    :effect
      (and
        (blocker_entity_queued ?blocker_ticket)
        (blocker_entity_assigned_to_routing_queue ?blocker_ticket ?routing_queue)
        (not
          (routing_queue_available ?routing_queue)
        )
      )
  )
  (:action assign_investigator_to_blocker_entity
    :parameters (?blocker_ticket - blocker_entity ?investigator - investigator)
    :precondition
      (and
        (blocker_entity_created ?blocker_ticket)
        (blocker_entity_queued ?blocker_ticket)
        (investigator_available ?investigator)
      )
    :effect
      (and
        (blocker_entity_assigned_investigator ?blocker_ticket ?investigator)
        (not
          (investigator_available ?investigator)
        )
      )
  )
  (:action mark_blocker_entity_triaged
    :parameters (?blocker_ticket - blocker_entity ?investigator - investigator)
    :precondition
      (and
        (blocker_entity_created ?blocker_ticket)
        (blocker_entity_queued ?blocker_ticket)
        (blocker_entity_assigned_investigator ?blocker_ticket ?investigator)
        (not
          (blocker_entity_triaged ?blocker_ticket)
        )
      )
    :effect (blocker_entity_triaged ?blocker_ticket)
  )
  (:action unassign_investigator_from_blocker_entity
    :parameters (?blocker_ticket - blocker_entity ?investigator - investigator)
    :precondition
      (and
        (blocker_entity_assigned_investigator ?blocker_ticket ?investigator)
      )
    :effect
      (and
        (investigator_available ?investigator)
        (not
          (blocker_entity_assigned_investigator ?blocker_ticket ?investigator)
        )
      )
  )
  (:action assign_approver_to_blocker_entity
    :parameters (?blocker_ticket - blocker_entity ?approver - approver)
    :precondition
      (and
        (blocker_entity_triaged ?blocker_ticket)
        (approver_available ?approver)
      )
    :effect
      (and
        (blocker_entity_assigned_approver ?blocker_ticket ?approver)
        (not
          (approver_available ?approver)
        )
      )
  )
  (:action unassign_approver_from_blocker_entity
    :parameters (?blocker_ticket - blocker_entity ?approver - approver)
    :precondition
      (and
        (blocker_entity_assigned_approver ?blocker_ticket ?approver)
      )
    :effect
      (and
        (approver_available ?approver)
        (not
          (blocker_entity_assigned_approver ?blocker_ticket ?approver)
        )
      )
  )
  (:action assign_technical_reviewer_to_close_task
    :parameters (?close_task - close_task ?technical_reviewer - technical_reviewer)
    :precondition
      (and
        (blocker_entity_triaged ?close_task)
        (technical_reviewer_available ?technical_reviewer)
      )
    :effect
      (and
        (close_task_assigned_technical_reviewer ?close_task ?technical_reviewer)
        (not
          (technical_reviewer_available ?technical_reviewer)
        )
      )
  )
  (:action unassign_technical_reviewer_from_close_task
    :parameters (?close_task - close_task ?technical_reviewer - technical_reviewer)
    :precondition
      (and
        (close_task_assigned_technical_reviewer ?close_task ?technical_reviewer)
      )
    :effect
      (and
        (technical_reviewer_available ?technical_reviewer)
        (not
          (close_task_assigned_technical_reviewer ?close_task ?technical_reviewer)
        )
      )
  )
  (:action assign_audit_reviewer_to_close_task
    :parameters (?close_task - close_task ?audit_reviewer - audit_reviewer)
    :precondition
      (and
        (blocker_entity_triaged ?close_task)
        (audit_reviewer_available ?audit_reviewer)
      )
    :effect
      (and
        (close_task_assigned_audit_reviewer ?close_task ?audit_reviewer)
        (not
          (audit_reviewer_available ?audit_reviewer)
        )
      )
  )
  (:action unassign_audit_reviewer_from_close_task
    :parameters (?close_task - close_task ?audit_reviewer - audit_reviewer)
    :precondition
      (and
        (close_task_assigned_audit_reviewer ?close_task ?audit_reviewer)
      )
    :effect
      (and
        (audit_reviewer_available ?audit_reviewer)
        (not
          (close_task_assigned_audit_reviewer ?close_task ?audit_reviewer)
        )
      )
  )
  (:action start_reconciliation_investigation_for_account
    :parameters (?account - account ?reconciliation - reconciliation ?investigator - investigator)
    :precondition
      (and
        (blocker_entity_triaged ?account)
        (blocker_entity_assigned_investigator ?account ?investigator)
        (account_linked_reconciliation ?account ?reconciliation)
        (not
          (reconciliation_investigation_started ?reconciliation)
        )
        (not
          (reconciliation_support_attached ?reconciliation)
        )
      )
    :effect (reconciliation_investigation_started ?reconciliation)
  )
  (:action approver_validate_account_reconciliation
    :parameters (?account - account ?reconciliation - reconciliation ?approver - approver)
    :precondition
      (and
        (blocker_entity_triaged ?account)
        (blocker_entity_assigned_approver ?account ?approver)
        (account_linked_reconciliation ?account ?reconciliation)
        (reconciliation_investigation_started ?reconciliation)
        (not
          (account_investigation_in_progress ?account)
        )
      )
    :effect
      (and
        (account_investigation_in_progress ?account)
        (account_investigation_complete ?account)
      )
  )
  (:action attach_support_evidence_to_account_reconciliation
    :parameters (?account - account ?reconciliation - reconciliation ?support_evidence - support_evidence)
    :precondition
      (and
        (blocker_entity_triaged ?account)
        (account_linked_reconciliation ?account ?reconciliation)
        (support_evidence_available ?support_evidence)
        (not
          (account_investigation_in_progress ?account)
        )
      )
    :effect
      (and
        (reconciliation_support_attached ?reconciliation)
        (account_investigation_in_progress ?account)
        (account_attached_support_evidence ?account ?support_evidence)
        (not
          (support_evidence_available ?support_evidence)
        )
      )
  )
  (:action finalize_account_reconciliation_investigation
    :parameters (?account - account ?reconciliation - reconciliation ?investigator - investigator ?support_evidence - support_evidence)
    :precondition
      (and
        (blocker_entity_triaged ?account)
        (blocker_entity_assigned_investigator ?account ?investigator)
        (account_linked_reconciliation ?account ?reconciliation)
        (reconciliation_support_attached ?reconciliation)
        (account_attached_support_evidence ?account ?support_evidence)
        (not
          (account_investigation_complete ?account)
        )
      )
    :effect
      (and
        (reconciliation_investigation_started ?reconciliation)
        (account_investigation_complete ?account)
        (support_evidence_available ?support_evidence)
        (not
          (account_attached_support_evidence ?account ?support_evidence)
        )
      )
  )
  (:action start_variance_investigation_for_operating_unit
    :parameters (?operating_unit - operating_unit ?variance_record - variance_record ?investigator - investigator)
    :precondition
      (and
        (blocker_entity_triaged ?operating_unit)
        (blocker_entity_assigned_investigator ?operating_unit ?investigator)
        (operating_unit_linked_variance_record ?operating_unit ?variance_record)
        (not
          (variance_record_active ?variance_record)
        )
        (not
          (variance_record_support_attached ?variance_record)
        )
      )
    :effect (variance_record_active ?variance_record)
  )
  (:action approver_validate_variance_for_operating_unit
    :parameters (?operating_unit - operating_unit ?variance_record - variance_record ?approver - approver)
    :precondition
      (and
        (blocker_entity_triaged ?operating_unit)
        (blocker_entity_assigned_approver ?operating_unit ?approver)
        (operating_unit_linked_variance_record ?operating_unit ?variance_record)
        (variance_record_active ?variance_record)
        (not
          (operating_unit_investigation_in_progress ?operating_unit)
        )
      )
    :effect
      (and
        (operating_unit_investigation_in_progress ?operating_unit)
        (operating_unit_ready_for_package ?operating_unit)
      )
  )
  (:action attach_support_evidence_to_variance_record
    :parameters (?operating_unit - operating_unit ?variance_record - variance_record ?support_evidence - support_evidence)
    :precondition
      (and
        (blocker_entity_triaged ?operating_unit)
        (operating_unit_linked_variance_record ?operating_unit ?variance_record)
        (support_evidence_available ?support_evidence)
        (not
          (operating_unit_investigation_in_progress ?operating_unit)
        )
      )
    :effect
      (and
        (variance_record_support_attached ?variance_record)
        (operating_unit_investigation_in_progress ?operating_unit)
        (operating_unit_attached_support_evidence ?operating_unit ?support_evidence)
        (not
          (support_evidence_available ?support_evidence)
        )
      )
  )
  (:action finalize_variance_investigation_for_operating_unit
    :parameters (?operating_unit - operating_unit ?variance_record - variance_record ?investigator - investigator ?support_evidence - support_evidence)
    :precondition
      (and
        (blocker_entity_triaged ?operating_unit)
        (blocker_entity_assigned_investigator ?operating_unit ?investigator)
        (operating_unit_linked_variance_record ?operating_unit ?variance_record)
        (variance_record_support_attached ?variance_record)
        (operating_unit_attached_support_evidence ?operating_unit ?support_evidence)
        (not
          (operating_unit_ready_for_package ?operating_unit)
        )
      )
    :effect
      (and
        (variance_record_active ?variance_record)
        (operating_unit_ready_for_package ?operating_unit)
        (support_evidence_available ?support_evidence)
        (not
          (operating_unit_attached_support_evidence ?operating_unit ?support_evidence)
        )
      )
  )
  (:action assemble_close_package_basic
    :parameters (?account - account ?operating_unit - operating_unit ?reconciliation - reconciliation ?variance_record - variance_record ?close_package - close_package)
    :precondition
      (and
        (account_investigation_in_progress ?account)
        (operating_unit_investigation_in_progress ?operating_unit)
        (account_linked_reconciliation ?account ?reconciliation)
        (operating_unit_linked_variance_record ?operating_unit ?variance_record)
        (reconciliation_investigation_started ?reconciliation)
        (variance_record_active ?variance_record)
        (account_investigation_complete ?account)
        (operating_unit_ready_for_package ?operating_unit)
        (close_package_pending_assembly ?close_package)
      )
    :effect
      (and
        (close_package_populated ?close_package)
        (close_package_linked_reconciliation ?close_package ?reconciliation)
        (close_package_linked_variance_record ?close_package ?variance_record)
        (not
          (close_package_pending_assembly ?close_package)
        )
      )
  )
  (:action assemble_close_package_with_technical_review
    :parameters (?account - account ?operating_unit - operating_unit ?reconciliation - reconciliation ?variance_record - variance_record ?close_package - close_package)
    :precondition
      (and
        (account_investigation_in_progress ?account)
        (operating_unit_investigation_in_progress ?operating_unit)
        (account_linked_reconciliation ?account ?reconciliation)
        (operating_unit_linked_variance_record ?operating_unit ?variance_record)
        (reconciliation_support_attached ?reconciliation)
        (variance_record_active ?variance_record)
        (not
          (account_investigation_complete ?account)
        )
        (operating_unit_ready_for_package ?operating_unit)
        (close_package_pending_assembly ?close_package)
      )
    :effect
      (and
        (close_package_populated ?close_package)
        (close_package_linked_reconciliation ?close_package ?reconciliation)
        (close_package_linked_variance_record ?close_package ?variance_record)
        (close_package_requires_technical_review ?close_package)
        (not
          (close_package_pending_assembly ?close_package)
        )
      )
  )
  (:action assemble_close_package_with_audit_review
    :parameters (?account - account ?operating_unit - operating_unit ?reconciliation - reconciliation ?variance_record - variance_record ?close_package - close_package)
    :precondition
      (and
        (account_investigation_in_progress ?account)
        (operating_unit_investigation_in_progress ?operating_unit)
        (account_linked_reconciliation ?account ?reconciliation)
        (operating_unit_linked_variance_record ?operating_unit ?variance_record)
        (reconciliation_investigation_started ?reconciliation)
        (variance_record_support_attached ?variance_record)
        (account_investigation_complete ?account)
        (not
          (operating_unit_ready_for_package ?operating_unit)
        )
        (close_package_pending_assembly ?close_package)
      )
    :effect
      (and
        (close_package_populated ?close_package)
        (close_package_linked_reconciliation ?close_package ?reconciliation)
        (close_package_linked_variance_record ?close_package ?variance_record)
        (close_package_requires_audit_review ?close_package)
        (not
          (close_package_pending_assembly ?close_package)
        )
      )
  )
  (:action assemble_close_package_with_specialist_reviews
    :parameters (?account - account ?operating_unit - operating_unit ?reconciliation - reconciliation ?variance_record - variance_record ?close_package - close_package)
    :precondition
      (and
        (account_investigation_in_progress ?account)
        (operating_unit_investigation_in_progress ?operating_unit)
        (account_linked_reconciliation ?account ?reconciliation)
        (operating_unit_linked_variance_record ?operating_unit ?variance_record)
        (reconciliation_support_attached ?reconciliation)
        (variance_record_support_attached ?variance_record)
        (not
          (account_investigation_complete ?account)
        )
        (not
          (operating_unit_ready_for_package ?operating_unit)
        )
        (close_package_pending_assembly ?close_package)
      )
    :effect
      (and
        (close_package_populated ?close_package)
        (close_package_linked_reconciliation ?close_package ?reconciliation)
        (close_package_linked_variance_record ?close_package ?variance_record)
        (close_package_requires_technical_review ?close_package)
        (close_package_requires_audit_review ?close_package)
        (not
          (close_package_pending_assembly ?close_package)
        )
      )
  )
  (:action prevalidate_close_package_by_account
    :parameters (?close_package - close_package ?account - account ?investigator - investigator)
    :precondition
      (and
        (close_package_populated ?close_package)
        (account_investigation_in_progress ?account)
        (blocker_entity_assigned_investigator ?account ?investigator)
        (not
          (close_package_prevalidated ?close_package)
        )
      )
    :effect (close_package_prevalidated ?close_package)
  )
  (:action allocate_reporting_component_to_close_package
    :parameters (?close_task - close_task ?reporting_component - reporting_component ?close_package - close_package)
    :precondition
      (and
        (blocker_entity_triaged ?close_task)
        (close_task_linked_close_package ?close_task ?close_package)
        (close_task_attached_reporting_component ?close_task ?reporting_component)
        (reporting_component_available ?reporting_component)
        (close_package_populated ?close_package)
        (close_package_prevalidated ?close_package)
        (not
          (reporting_component_allocated ?reporting_component)
        )
      )
    :effect
      (and
        (reporting_component_allocated ?reporting_component)
        (reporting_component_linked_close_package ?reporting_component ?close_package)
        (not
          (reporting_component_available ?reporting_component)
        )
      )
  )
  (:action prevalidate_reporting_component_for_close_task
    :parameters (?close_task - close_task ?reporting_component - reporting_component ?close_package - close_package ?investigator - investigator)
    :precondition
      (and
        (blocker_entity_triaged ?close_task)
        (close_task_attached_reporting_component ?close_task ?reporting_component)
        (reporting_component_allocated ?reporting_component)
        (reporting_component_linked_close_package ?reporting_component ?close_package)
        (blocker_entity_assigned_investigator ?close_task ?investigator)
        (not
          (close_package_requires_technical_review ?close_package)
        )
        (not
          (close_task_reporting_component_prevalidated ?close_task)
        )
      )
    :effect (close_task_reporting_component_prevalidated ?close_task)
  )
  (:action assign_support_document_template_to_close_task
    :parameters (?close_task - close_task ?support_document_template - support_document_template)
    :precondition
      (and
        (blocker_entity_triaged ?close_task)
        (support_document_template_available ?support_document_template)
        (not
          (close_task_assigned_support_document_template ?close_task)
        )
      )
    :effect
      (and
        (close_task_assigned_support_document_template ?close_task)
        (close_task_linked_support_document_template ?close_task ?support_document_template)
        (not
          (support_document_template_available ?support_document_template)
        )
      )
  )
  (:action process_support_document_and_prevalidate_task
    :parameters (?close_task - close_task ?reporting_component - reporting_component ?close_package - close_package ?investigator - investigator ?support_document_template - support_document_template)
    :precondition
      (and
        (blocker_entity_triaged ?close_task)
        (close_task_attached_reporting_component ?close_task ?reporting_component)
        (reporting_component_allocated ?reporting_component)
        (reporting_component_linked_close_package ?reporting_component ?close_package)
        (blocker_entity_assigned_investigator ?close_task ?investigator)
        (close_package_requires_technical_review ?close_package)
        (close_task_assigned_support_document_template ?close_task)
        (close_task_linked_support_document_template ?close_task ?support_document_template)
        (not
          (close_task_reporting_component_prevalidated ?close_task)
        )
      )
    :effect
      (and
        (close_task_reporting_component_prevalidated ?close_task)
        (close_task_support_document_processed ?close_task)
      )
  )
  (:action perform_technical_validation_on_task
    :parameters (?close_task - close_task ?technical_reviewer - technical_reviewer ?approver - approver ?reporting_component - reporting_component ?close_package - close_package)
    :precondition
      (and
        (close_task_reporting_component_prevalidated ?close_task)
        (close_task_assigned_technical_reviewer ?close_task ?technical_reviewer)
        (blocker_entity_assigned_approver ?close_task ?approver)
        (close_task_attached_reporting_component ?close_task ?reporting_component)
        (reporting_component_linked_close_package ?reporting_component ?close_package)
        (not
          (close_package_requires_audit_review ?close_package)
        )
        (not
          (close_task_specialist_validated ?close_task)
        )
      )
    :effect (close_task_specialist_validated ?close_task)
  )
  (:action perform_technical_validation_on_task_audit_required
    :parameters (?close_task - close_task ?technical_reviewer - technical_reviewer ?approver - approver ?reporting_component - reporting_component ?close_package - close_package)
    :precondition
      (and
        (close_task_reporting_component_prevalidated ?close_task)
        (close_task_assigned_technical_reviewer ?close_task ?technical_reviewer)
        (blocker_entity_assigned_approver ?close_task ?approver)
        (close_task_attached_reporting_component ?close_task ?reporting_component)
        (reporting_component_linked_close_package ?reporting_component ?close_package)
        (close_package_requires_audit_review ?close_package)
        (not
          (close_task_specialist_validated ?close_task)
        )
      )
    :effect (close_task_specialist_validated ?close_task)
  )
  (:action perform_audit_review_for_close_task
    :parameters (?close_task - close_task ?audit_reviewer - audit_reviewer ?reporting_component - reporting_component ?close_package - close_package)
    :precondition
      (and
        (close_task_specialist_validated ?close_task)
        (close_task_assigned_audit_reviewer ?close_task ?audit_reviewer)
        (close_task_attached_reporting_component ?close_task ?reporting_component)
        (reporting_component_linked_close_package ?reporting_component ?close_package)
        (not
          (close_package_requires_technical_review ?close_package)
        )
        (not
          (close_package_requires_audit_review ?close_package)
        )
        (not
          (close_task_specialist_reviews_complete ?close_task)
        )
      )
    :effect (close_task_specialist_reviews_complete ?close_task)
  )
  (:action perform_audit_review_and_flag_control_attachment
    :parameters (?close_task - close_task ?audit_reviewer - audit_reviewer ?reporting_component - reporting_component ?close_package - close_package)
    :precondition
      (and
        (close_task_specialist_validated ?close_task)
        (close_task_assigned_audit_reviewer ?close_task ?audit_reviewer)
        (close_task_attached_reporting_component ?close_task ?reporting_component)
        (reporting_component_linked_close_package ?reporting_component ?close_package)
        (close_package_requires_technical_review ?close_package)
        (not
          (close_package_requires_audit_review ?close_package)
        )
        (not
          (close_task_specialist_reviews_complete ?close_task)
        )
      )
    :effect
      (and
        (close_task_specialist_reviews_complete ?close_task)
        (close_task_requires_control_attachment ?close_task)
      )
  )
  (:action perform_audit_review_and_set_control_attachment_mode_b
    :parameters (?close_task - close_task ?audit_reviewer - audit_reviewer ?reporting_component - reporting_component ?close_package - close_package)
    :precondition
      (and
        (close_task_specialist_validated ?close_task)
        (close_task_assigned_audit_reviewer ?close_task ?audit_reviewer)
        (close_task_attached_reporting_component ?close_task ?reporting_component)
        (reporting_component_linked_close_package ?reporting_component ?close_package)
        (not
          (close_package_requires_technical_review ?close_package)
        )
        (close_package_requires_audit_review ?close_package)
        (not
          (close_task_specialist_reviews_complete ?close_task)
        )
      )
    :effect
      (and
        (close_task_specialist_reviews_complete ?close_task)
        (close_task_requires_control_attachment ?close_task)
      )
  )
  (:action perform_audit_review_and_set_control_attachment_mode_c
    :parameters (?close_task - close_task ?audit_reviewer - audit_reviewer ?reporting_component - reporting_component ?close_package - close_package)
    :precondition
      (and
        (close_task_specialist_validated ?close_task)
        (close_task_assigned_audit_reviewer ?close_task ?audit_reviewer)
        (close_task_attached_reporting_component ?close_task ?reporting_component)
        (reporting_component_linked_close_package ?reporting_component ?close_package)
        (close_package_requires_technical_review ?close_package)
        (close_package_requires_audit_review ?close_package)
        (not
          (close_task_specialist_reviews_complete ?close_task)
        )
      )
    :effect
      (and
        (close_task_specialist_reviews_complete ?close_task)
        (close_task_requires_control_attachment ?close_task)
      )
  )
  (:action finalize_task_without_control_attachment
    :parameters (?close_task - close_task)
    :precondition
      (and
        (close_task_specialist_reviews_complete ?close_task)
        (not
          (close_task_requires_control_attachment ?close_task)
        )
        (not
          (close_task_finalized ?close_task)
        )
      )
    :effect
      (and
        (close_task_finalized ?close_task)
        (blocker_entity_ready_for_routing_completion ?close_task)
      )
  )
  (:action attach_control_attachment_template_to_task
    :parameters (?close_task - close_task ?control_attachment_template - control_attachment_template)
    :precondition
      (and
        (close_task_specialist_reviews_complete ?close_task)
        (close_task_requires_control_attachment ?close_task)
        (control_attachment_template_available ?control_attachment_template)
      )
    :effect
      (and
        (close_task_linked_control_attachment_template ?close_task ?control_attachment_template)
        (not
          (control_attachment_template_available ?control_attachment_template)
        )
      )
  )
  (:action perform_final_control_checks_for_task
    :parameters (?close_task - close_task ?account - account ?operating_unit - operating_unit ?investigator - investigator ?control_attachment_template - control_attachment_template)
    :precondition
      (and
        (close_task_specialist_reviews_complete ?close_task)
        (close_task_requires_control_attachment ?close_task)
        (close_task_linked_control_attachment_template ?close_task ?control_attachment_template)
        (close_task_assigned_account ?close_task ?account)
        (close_task_assigned_operating_unit ?close_task ?operating_unit)
        (account_investigation_complete ?account)
        (operating_unit_ready_for_package ?operating_unit)
        (blocker_entity_assigned_investigator ?close_task ?investigator)
        (not
          (close_task_final_control_checks_complete ?close_task)
        )
      )
    :effect (close_task_final_control_checks_complete ?close_task)
  )
  (:action finalize_task_after_control_checks
    :parameters (?close_task - close_task)
    :precondition
      (and
        (close_task_specialist_reviews_complete ?close_task)
        (close_task_final_control_checks_complete ?close_task)
        (not
          (close_task_finalized ?close_task)
        )
      )
    :effect
      (and
        (close_task_finalized ?close_task)
        (blocker_entity_ready_for_routing_completion ?close_task)
      )
  )
  (:action attach_audit_finding_reference_to_task
    :parameters (?close_task - close_task ?audit_finding_reference - audit_finding_reference ?investigator - investigator)
    :precondition
      (and
        (blocker_entity_triaged ?close_task)
        (blocker_entity_assigned_investigator ?close_task ?investigator)
        (audit_finding_reference_available ?audit_finding_reference)
        (close_task_linked_audit_finding_reference ?close_task ?audit_finding_reference)
        (not
          (close_task_audit_reference_onboarded ?close_task)
        )
      )
    :effect
      (and
        (close_task_audit_reference_onboarded ?close_task)
        (not
          (audit_finding_reference_available ?audit_finding_reference)
        )
      )
  )
  (:action engage_approver_for_audit_reference
    :parameters (?close_task - close_task ?approver - approver)
    :precondition
      (and
        (close_task_audit_reference_onboarded ?close_task)
        (blocker_entity_assigned_approver ?close_task ?approver)
        (not
          (close_task_approver_engaged ?close_task)
        )
      )
    :effect (close_task_approver_engaged ?close_task)
  )
  (:action perform_approver_review_after_audit_reference
    :parameters (?close_task - close_task ?audit_reviewer - audit_reviewer)
    :precondition
      (and
        (close_task_approver_engaged ?close_task)
        (close_task_assigned_audit_reviewer ?close_task ?audit_reviewer)
        (not
          (close_task_approval_obtained ?close_task)
        )
      )
    :effect (close_task_approval_obtained ?close_task)
  )
  (:action finalize_task_after_approver_review
    :parameters (?close_task - close_task)
    :precondition
      (and
        (close_task_approval_obtained ?close_task)
        (not
          (close_task_finalized ?close_task)
        )
      )
    :effect
      (and
        (close_task_finalized ?close_task)
        (blocker_entity_ready_for_routing_completion ?close_task)
      )
  )
  (:action mark_account_ready_for_routing_completion
    :parameters (?account - account ?close_package - close_package)
    :precondition
      (and
        (account_investigation_in_progress ?account)
        (account_investigation_complete ?account)
        (close_package_populated ?close_package)
        (close_package_prevalidated ?close_package)
        (not
          (blocker_entity_ready_for_routing_completion ?account)
        )
      )
    :effect (blocker_entity_ready_for_routing_completion ?account)
  )
  (:action mark_operating_unit_ready_for_routing_completion
    :parameters (?operating_unit - operating_unit ?close_package - close_package)
    :precondition
      (and
        (operating_unit_investigation_in_progress ?operating_unit)
        (operating_unit_ready_for_package ?operating_unit)
        (close_package_populated ?close_package)
        (close_package_prevalidated ?close_package)
        (not
          (blocker_entity_ready_for_routing_completion ?operating_unit)
        )
      )
    :effect (blocker_entity_ready_for_routing_completion ?operating_unit)
  )
  (:action assign_routing_token_to_blocker_entity
    :parameters (?blocker_ticket - blocker_entity ?routing_token - routing_token ?investigator - investigator)
    :precondition
      (and
        (blocker_entity_ready_for_routing_completion ?blocker_ticket)
        (blocker_entity_assigned_investigator ?blocker_ticket ?investigator)
        (routing_token_available ?routing_token)
        (not
          (blocker_entity_routing_initiated ?blocker_ticket)
        )
      )
    :effect
      (and
        (blocker_entity_routing_initiated ?blocker_ticket)
        (blocker_entity_assigned_routing_token ?blocker_ticket ?routing_token)
        (not
          (routing_token_available ?routing_token)
        )
      )
  )
  (:action complete_routing_for_account
    :parameters (?account - account ?routing_queue - routing_queue ?routing_token - routing_token)
    :precondition
      (and
        (blocker_entity_routing_initiated ?account)
        (blocker_entity_assigned_to_routing_queue ?account ?routing_queue)
        (blocker_entity_assigned_routing_token ?account ?routing_token)
        (not
          (blocker_entity_resolved ?account)
        )
      )
    :effect
      (and
        (blocker_entity_resolved ?account)
        (routing_queue_available ?routing_queue)
        (routing_token_available ?routing_token)
      )
  )
  (:action complete_routing_for_operating_unit
    :parameters (?operating_unit - operating_unit ?routing_queue - routing_queue ?routing_token - routing_token)
    :precondition
      (and
        (blocker_entity_routing_initiated ?operating_unit)
        (blocker_entity_assigned_to_routing_queue ?operating_unit ?routing_queue)
        (blocker_entity_assigned_routing_token ?operating_unit ?routing_token)
        (not
          (blocker_entity_resolved ?operating_unit)
        )
      )
    :effect
      (and
        (blocker_entity_resolved ?operating_unit)
        (routing_queue_available ?routing_queue)
        (routing_token_available ?routing_token)
      )
  )
  (:action complete_routing_for_close_task
    :parameters (?close_task - close_task ?routing_queue - routing_queue ?routing_token - routing_token)
    :precondition
      (and
        (blocker_entity_routing_initiated ?close_task)
        (blocker_entity_assigned_to_routing_queue ?close_task ?routing_queue)
        (blocker_entity_assigned_routing_token ?close_task ?routing_token)
        (not
          (blocker_entity_resolved ?close_task)
        )
      )
    :effect
      (and
        (blocker_entity_resolved ?close_task)
        (routing_queue_available ?routing_queue)
        (routing_token_available ?routing_token)
      )
  )
)

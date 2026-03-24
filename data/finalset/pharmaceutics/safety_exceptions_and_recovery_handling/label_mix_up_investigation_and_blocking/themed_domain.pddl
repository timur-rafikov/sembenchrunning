(define (domain pharm_label_mixup_blocking_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource - object logistics_resource_group - object product_resource_group - object case_root_type - object investigation_case - case_root_type labeling_line_resource - operational_resource lab_analyst - operational_resource quality_supervisor - operational_resource regulatory_document - operational_resource logistics_ticket - operational_resource notification_template - operational_resource external_vendor - operational_resource third_party_lab - operational_resource spare_label_stock - logistics_resource_group sample_report - logistics_resource_group regulator_contact - logistics_resource_group affected_packaging_unit - product_resource_group affected_shipment - product_resource_group remediation_order - product_resource_group site_case_group - investigation_case product_case_group - investigation_case manufacturing_site_case - site_case_group distribution_site_case - site_case_group product_record - product_case_group)
  (:predicates
    (investigation_case_opened ?investigation_case - investigation_case)
    (case_triaged ?investigation_case - investigation_case)
    (case_labeling_assigned ?investigation_case - investigation_case)
    (case_blocked ?investigation_case - investigation_case)
    (remediation_authorized ?investigation_case - investigation_case)
    (notifications_dispatched ?investigation_case - investigation_case)
    (labeling_line_available ?labeling_line_resource - labeling_line_resource)
    (case_assigned_labeling_line ?investigation_case - investigation_case ?labeling_line_resource - labeling_line_resource)
    (lab_analyst_available ?lab_analyst - lab_analyst)
    (case_assigned_lab_analyst ?investigation_case - investigation_case ?lab_analyst - lab_analyst)
    (qa_supervisor_available ?quality_supervisor - quality_supervisor)
    (case_assigned_qa_supervisor ?investigation_case - investigation_case ?quality_supervisor - quality_supervisor)
    (spare_label_available ?spare_label_stock - spare_label_stock)
    (site_allocated_spare_label ?manufacturing_site_case - manufacturing_site_case ?spare_label_stock - spare_label_stock)
    (distribution_allocated_spare_label ?distribution_site_case - distribution_site_case ?spare_label_stock - spare_label_stock)
    (site_has_affected_packaging_unit ?manufacturing_site_case - manufacturing_site_case ?affected_packaging_unit - affected_packaging_unit)
    (packaging_unit_lock_initiated ?affected_packaging_unit - affected_packaging_unit)
    (packaging_unit_quarantine_initiated ?affected_packaging_unit - affected_packaging_unit)
    (manufacturing_site_lock_recorded ?manufacturing_site_case - manufacturing_site_case)
    (distribution_case_has_affected_shipment ?distribution_site_case - distribution_site_case ?affected_shipment - affected_shipment)
    (shipment_lock_initiated ?affected_shipment - affected_shipment)
    (shipment_quarantine_initiated ?affected_shipment - affected_shipment)
    (distribution_site_lock_recorded ?distribution_site_case - distribution_site_case)
    (remediation_order_ready ?remediation_order - remediation_order)
    (remediation_order_issued ?remediation_order - remediation_order)
    (remediation_order_covers_packaging_unit ?remediation_order - remediation_order ?affected_packaging_unit - affected_packaging_unit)
    (remediation_order_covers_shipment ?remediation_order - remediation_order ?affected_shipment - affected_shipment)
    (remediation_order_flag_quarantine ?remediation_order - remediation_order)
    (remediation_order_flag_recall ?remediation_order - remediation_order)
    (remediation_order_execution_confirmed ?remediation_order - remediation_order)
    (product_linked_to_manufacturing_case ?product_record - product_record ?manufacturing_site_case - manufacturing_site_case)
    (product_linked_to_distribution_case ?product_record - product_record ?distribution_site_case - distribution_site_case)
    (product_linked_to_remediation_order ?product_record - product_record ?remediation_order - remediation_order)
    (sample_report_available ?sample_report - sample_report)
    (product_has_sample_report ?product_record - product_record ?sample_report - sample_report)
    (sample_report_processed ?sample_report - sample_report)
    (sample_report_linked_to_order ?sample_report - sample_report ?remediation_order - remediation_order)
    (crossfunctional_review_started ?product_record - product_record)
    (technical_signoff_initiated ?product_record - product_record)
    (crossfunctional_approvals_completed ?product_record - product_record)
    (regulatory_document_attached ?product_record - product_record)
    (regulatory_review_in_progress ?product_record - product_record)
    (external_vendor_approval_obtained ?product_record - product_record)
    (final_internal_approval ?product_record - product_record)
    (regulator_contact_available ?regulator_contact - regulator_contact)
    (product_linked_to_regulator_contact ?product_record - product_record ?regulator_contact - regulator_contact)
    (regulatory_review_started ?product_record - product_record)
    (regulatory_review_assigned ?product_record - product_record)
    (regulatory_signoff_obtained ?product_record - product_record)
    (regulatory_document_available ?regulatory_document - regulatory_document)
    (product_has_regulatory_document ?product_record - product_record ?regulatory_document - regulatory_document)
    (logistics_ticket_available ?logistics_ticket - logistics_ticket)
    (product_linked_to_logistics_ticket ?product_record - product_record ?logistics_ticket - logistics_ticket)
    (external_vendor_available ?external_vendor - external_vendor)
    (product_linked_to_external_vendor ?product_record - product_record ?external_vendor - external_vendor)
    (third_party_lab_available ?third_party_lab - third_party_lab)
    (product_linked_to_third_party_lab ?product_record - product_record ?third_party_lab - third_party_lab)
    (notification_template_available ?notification_template - notification_template)
    (case_linked_to_notification_template ?investigation_case - investigation_case ?notification_template - notification_template)
    (manufacturing_site_ready ?manufacturing_site_case - manufacturing_site_case)
    (distribution_site_ready ?distribution_site_case - distribution_site_case)
    (final_authorization_recorded ?product_record - product_record)
  )
  (:action create_investigation_case
    :parameters (?investigation_case - investigation_case)
    :precondition
      (and
        (not
          (investigation_case_opened ?investigation_case)
        )
        (not
          (case_blocked ?investigation_case)
        )
      )
    :effect (investigation_case_opened ?investigation_case)
  )
  (:action assign_labeling_line_to_case
    :parameters (?investigation_case - investigation_case ?labeling_line_resource - labeling_line_resource)
    :precondition
      (and
        (investigation_case_opened ?investigation_case)
        (not
          (case_labeling_assigned ?investigation_case)
        )
        (labeling_line_available ?labeling_line_resource)
      )
    :effect
      (and
        (case_labeling_assigned ?investigation_case)
        (case_assigned_labeling_line ?investigation_case ?labeling_line_resource)
        (not
          (labeling_line_available ?labeling_line_resource)
        )
      )
  )
  (:action assign_lab_analyst_to_case
    :parameters (?investigation_case - investigation_case ?lab_analyst - lab_analyst)
    :precondition
      (and
        (investigation_case_opened ?investigation_case)
        (case_labeling_assigned ?investigation_case)
        (lab_analyst_available ?lab_analyst)
      )
    :effect
      (and
        (case_assigned_lab_analyst ?investigation_case ?lab_analyst)
        (not
          (lab_analyst_available ?lab_analyst)
        )
      )
  )
  (:action complete_case_triage
    :parameters (?investigation_case - investigation_case ?lab_analyst - lab_analyst)
    :precondition
      (and
        (investigation_case_opened ?investigation_case)
        (case_labeling_assigned ?investigation_case)
        (case_assigned_lab_analyst ?investigation_case ?lab_analyst)
        (not
          (case_triaged ?investigation_case)
        )
      )
    :effect (case_triaged ?investigation_case)
  )
  (:action release_lab_analyst_from_case
    :parameters (?investigation_case - investigation_case ?lab_analyst - lab_analyst)
    :precondition
      (and
        (case_assigned_lab_analyst ?investigation_case ?lab_analyst)
      )
    :effect
      (and
        (lab_analyst_available ?lab_analyst)
        (not
          (case_assigned_lab_analyst ?investigation_case ?lab_analyst)
        )
      )
  )
  (:action assign_qa_supervisor_to_case
    :parameters (?investigation_case - investigation_case ?quality_supervisor - quality_supervisor)
    :precondition
      (and
        (case_triaged ?investigation_case)
        (qa_supervisor_available ?quality_supervisor)
      )
    :effect
      (and
        (case_assigned_qa_supervisor ?investigation_case ?quality_supervisor)
        (not
          (qa_supervisor_available ?quality_supervisor)
        )
      )
  )
  (:action release_qa_supervisor_from_case
    :parameters (?investigation_case - investigation_case ?quality_supervisor - quality_supervisor)
    :precondition
      (and
        (case_assigned_qa_supervisor ?investigation_case ?quality_supervisor)
      )
    :effect
      (and
        (qa_supervisor_available ?quality_supervisor)
        (not
          (case_assigned_qa_supervisor ?investigation_case ?quality_supervisor)
        )
      )
  )
  (:action assign_external_vendor_to_product
    :parameters (?product_record - product_record ?external_vendor - external_vendor)
    :precondition
      (and
        (case_triaged ?product_record)
        (external_vendor_available ?external_vendor)
      )
    :effect
      (and
        (product_linked_to_external_vendor ?product_record ?external_vendor)
        (not
          (external_vendor_available ?external_vendor)
        )
      )
  )
  (:action release_external_vendor_from_product
    :parameters (?product_record - product_record ?external_vendor - external_vendor)
    :precondition
      (and
        (product_linked_to_external_vendor ?product_record ?external_vendor)
      )
    :effect
      (and
        (external_vendor_available ?external_vendor)
        (not
          (product_linked_to_external_vendor ?product_record ?external_vendor)
        )
      )
  )
  (:action assign_third_party_lab_to_product
    :parameters (?product_record - product_record ?third_party_lab - third_party_lab)
    :precondition
      (and
        (case_triaged ?product_record)
        (third_party_lab_available ?third_party_lab)
      )
    :effect
      (and
        (product_linked_to_third_party_lab ?product_record ?third_party_lab)
        (not
          (third_party_lab_available ?third_party_lab)
        )
      )
  )
  (:action release_third_party_lab_from_product
    :parameters (?product_record - product_record ?third_party_lab - third_party_lab)
    :precondition
      (and
        (product_linked_to_third_party_lab ?product_record ?third_party_lab)
      )
    :effect
      (and
        (third_party_lab_available ?third_party_lab)
        (not
          (product_linked_to_third_party_lab ?product_record ?third_party_lab)
        )
      )
  )
  (:action initiate_packaging_unit_lock
    :parameters (?manufacturing_site_case - manufacturing_site_case ?affected_packaging_unit - affected_packaging_unit ?lab_analyst - lab_analyst)
    :precondition
      (and
        (case_triaged ?manufacturing_site_case)
        (case_assigned_lab_analyst ?manufacturing_site_case ?lab_analyst)
        (site_has_affected_packaging_unit ?manufacturing_site_case ?affected_packaging_unit)
        (not
          (packaging_unit_lock_initiated ?affected_packaging_unit)
        )
        (not
          (packaging_unit_quarantine_initiated ?affected_packaging_unit)
        )
      )
    :effect (packaging_unit_lock_initiated ?affected_packaging_unit)
  )
  (:action confirm_packaging_unit_lock_by_qa
    :parameters (?manufacturing_site_case - manufacturing_site_case ?affected_packaging_unit - affected_packaging_unit ?quality_supervisor - quality_supervisor)
    :precondition
      (and
        (case_triaged ?manufacturing_site_case)
        (case_assigned_qa_supervisor ?manufacturing_site_case ?quality_supervisor)
        (site_has_affected_packaging_unit ?manufacturing_site_case ?affected_packaging_unit)
        (packaging_unit_lock_initiated ?affected_packaging_unit)
        (not
          (manufacturing_site_ready ?manufacturing_site_case)
        )
      )
    :effect
      (and
        (manufacturing_site_ready ?manufacturing_site_case)
        (manufacturing_site_lock_recorded ?manufacturing_site_case)
      )
  )
  (:action allocate_spare_label_and_quarantine_unit
    :parameters (?manufacturing_site_case - manufacturing_site_case ?affected_packaging_unit - affected_packaging_unit ?spare_label_stock - spare_label_stock)
    :precondition
      (and
        (case_triaged ?manufacturing_site_case)
        (site_has_affected_packaging_unit ?manufacturing_site_case ?affected_packaging_unit)
        (spare_label_available ?spare_label_stock)
        (not
          (manufacturing_site_ready ?manufacturing_site_case)
        )
      )
    :effect
      (and
        (packaging_unit_quarantine_initiated ?affected_packaging_unit)
        (manufacturing_site_ready ?manufacturing_site_case)
        (site_allocated_spare_label ?manufacturing_site_case ?spare_label_stock)
        (not
          (spare_label_available ?spare_label_stock)
        )
      )
  )
  (:action complete_packaging_unit_quarantine
    :parameters (?manufacturing_site_case - manufacturing_site_case ?affected_packaging_unit - affected_packaging_unit ?lab_analyst - lab_analyst ?spare_label_stock - spare_label_stock)
    :precondition
      (and
        (case_triaged ?manufacturing_site_case)
        (case_assigned_lab_analyst ?manufacturing_site_case ?lab_analyst)
        (site_has_affected_packaging_unit ?manufacturing_site_case ?affected_packaging_unit)
        (packaging_unit_quarantine_initiated ?affected_packaging_unit)
        (site_allocated_spare_label ?manufacturing_site_case ?spare_label_stock)
        (not
          (manufacturing_site_lock_recorded ?manufacturing_site_case)
        )
      )
    :effect
      (and
        (packaging_unit_lock_initiated ?affected_packaging_unit)
        (manufacturing_site_lock_recorded ?manufacturing_site_case)
        (spare_label_available ?spare_label_stock)
        (not
          (site_allocated_spare_label ?manufacturing_site_case ?spare_label_stock)
        )
      )
  )
  (:action initiate_shipment_lock
    :parameters (?distribution_site_case - distribution_site_case ?affected_shipment - affected_shipment ?lab_analyst - lab_analyst)
    :precondition
      (and
        (case_triaged ?distribution_site_case)
        (case_assigned_lab_analyst ?distribution_site_case ?lab_analyst)
        (distribution_case_has_affected_shipment ?distribution_site_case ?affected_shipment)
        (not
          (shipment_lock_initiated ?affected_shipment)
        )
        (not
          (shipment_quarantine_initiated ?affected_shipment)
        )
      )
    :effect (shipment_lock_initiated ?affected_shipment)
  )
  (:action confirm_shipment_lock_by_qa
    :parameters (?distribution_site_case - distribution_site_case ?affected_shipment - affected_shipment ?quality_supervisor - quality_supervisor)
    :precondition
      (and
        (case_triaged ?distribution_site_case)
        (case_assigned_qa_supervisor ?distribution_site_case ?quality_supervisor)
        (distribution_case_has_affected_shipment ?distribution_site_case ?affected_shipment)
        (shipment_lock_initiated ?affected_shipment)
        (not
          (distribution_site_ready ?distribution_site_case)
        )
      )
    :effect
      (and
        (distribution_site_ready ?distribution_site_case)
        (distribution_site_lock_recorded ?distribution_site_case)
      )
  )
  (:action allocate_spare_label_and_quarantine_shipment
    :parameters (?distribution_site_case - distribution_site_case ?affected_shipment - affected_shipment ?spare_label_stock - spare_label_stock)
    :precondition
      (and
        (case_triaged ?distribution_site_case)
        (distribution_case_has_affected_shipment ?distribution_site_case ?affected_shipment)
        (spare_label_available ?spare_label_stock)
        (not
          (distribution_site_ready ?distribution_site_case)
        )
      )
    :effect
      (and
        (shipment_quarantine_initiated ?affected_shipment)
        (distribution_site_ready ?distribution_site_case)
        (distribution_allocated_spare_label ?distribution_site_case ?spare_label_stock)
        (not
          (spare_label_available ?spare_label_stock)
        )
      )
  )
  (:action complete_shipment_quarantine
    :parameters (?distribution_site_case - distribution_site_case ?affected_shipment - affected_shipment ?lab_analyst - lab_analyst ?spare_label_stock - spare_label_stock)
    :precondition
      (and
        (case_triaged ?distribution_site_case)
        (case_assigned_lab_analyst ?distribution_site_case ?lab_analyst)
        (distribution_case_has_affected_shipment ?distribution_site_case ?affected_shipment)
        (shipment_quarantine_initiated ?affected_shipment)
        (distribution_allocated_spare_label ?distribution_site_case ?spare_label_stock)
        (not
          (distribution_site_lock_recorded ?distribution_site_case)
        )
      )
    :effect
      (and
        (shipment_lock_initiated ?affected_shipment)
        (distribution_site_lock_recorded ?distribution_site_case)
        (spare_label_available ?spare_label_stock)
        (not
          (distribution_allocated_spare_label ?distribution_site_case ?spare_label_stock)
        )
      )
  )
  (:action issue_remediation_order
    :parameters (?manufacturing_site_case - manufacturing_site_case ?distribution_site_case - distribution_site_case ?affected_packaging_unit - affected_packaging_unit ?affected_shipment - affected_shipment ?remediation_order - remediation_order)
    :precondition
      (and
        (manufacturing_site_ready ?manufacturing_site_case)
        (distribution_site_ready ?distribution_site_case)
        (site_has_affected_packaging_unit ?manufacturing_site_case ?affected_packaging_unit)
        (distribution_case_has_affected_shipment ?distribution_site_case ?affected_shipment)
        (packaging_unit_lock_initiated ?affected_packaging_unit)
        (shipment_lock_initiated ?affected_shipment)
        (manufacturing_site_lock_recorded ?manufacturing_site_case)
        (distribution_site_lock_recorded ?distribution_site_case)
        (remediation_order_ready ?remediation_order)
      )
    :effect
      (and
        (remediation_order_issued ?remediation_order)
        (remediation_order_covers_packaging_unit ?remediation_order ?affected_packaging_unit)
        (remediation_order_covers_shipment ?remediation_order ?affected_shipment)
        (not
          (remediation_order_ready ?remediation_order)
        )
      )
  )
  (:action issue_remediation_order_with_quarantine_flag
    :parameters (?manufacturing_site_case - manufacturing_site_case ?distribution_site_case - distribution_site_case ?affected_packaging_unit - affected_packaging_unit ?affected_shipment - affected_shipment ?remediation_order - remediation_order)
    :precondition
      (and
        (manufacturing_site_ready ?manufacturing_site_case)
        (distribution_site_ready ?distribution_site_case)
        (site_has_affected_packaging_unit ?manufacturing_site_case ?affected_packaging_unit)
        (distribution_case_has_affected_shipment ?distribution_site_case ?affected_shipment)
        (packaging_unit_quarantine_initiated ?affected_packaging_unit)
        (shipment_lock_initiated ?affected_shipment)
        (not
          (manufacturing_site_lock_recorded ?manufacturing_site_case)
        )
        (distribution_site_lock_recorded ?distribution_site_case)
        (remediation_order_ready ?remediation_order)
      )
    :effect
      (and
        (remediation_order_issued ?remediation_order)
        (remediation_order_covers_packaging_unit ?remediation_order ?affected_packaging_unit)
        (remediation_order_covers_shipment ?remediation_order ?affected_shipment)
        (remediation_order_flag_quarantine ?remediation_order)
        (not
          (remediation_order_ready ?remediation_order)
        )
      )
  )
  (:action issue_remediation_order_with_recall_flag
    :parameters (?manufacturing_site_case - manufacturing_site_case ?distribution_site_case - distribution_site_case ?affected_packaging_unit - affected_packaging_unit ?affected_shipment - affected_shipment ?remediation_order - remediation_order)
    :precondition
      (and
        (manufacturing_site_ready ?manufacturing_site_case)
        (distribution_site_ready ?distribution_site_case)
        (site_has_affected_packaging_unit ?manufacturing_site_case ?affected_packaging_unit)
        (distribution_case_has_affected_shipment ?distribution_site_case ?affected_shipment)
        (packaging_unit_lock_initiated ?affected_packaging_unit)
        (shipment_quarantine_initiated ?affected_shipment)
        (manufacturing_site_lock_recorded ?manufacturing_site_case)
        (not
          (distribution_site_lock_recorded ?distribution_site_case)
        )
        (remediation_order_ready ?remediation_order)
      )
    :effect
      (and
        (remediation_order_issued ?remediation_order)
        (remediation_order_covers_packaging_unit ?remediation_order ?affected_packaging_unit)
        (remediation_order_covers_shipment ?remediation_order ?affected_shipment)
        (remediation_order_flag_recall ?remediation_order)
        (not
          (remediation_order_ready ?remediation_order)
        )
      )
  )
  (:action issue_remediation_order_with_quarantine_and_recall_flags
    :parameters (?manufacturing_site_case - manufacturing_site_case ?distribution_site_case - distribution_site_case ?affected_packaging_unit - affected_packaging_unit ?affected_shipment - affected_shipment ?remediation_order - remediation_order)
    :precondition
      (and
        (manufacturing_site_ready ?manufacturing_site_case)
        (distribution_site_ready ?distribution_site_case)
        (site_has_affected_packaging_unit ?manufacturing_site_case ?affected_packaging_unit)
        (distribution_case_has_affected_shipment ?distribution_site_case ?affected_shipment)
        (packaging_unit_quarantine_initiated ?affected_packaging_unit)
        (shipment_quarantine_initiated ?affected_shipment)
        (not
          (manufacturing_site_lock_recorded ?manufacturing_site_case)
        )
        (not
          (distribution_site_lock_recorded ?distribution_site_case)
        )
        (remediation_order_ready ?remediation_order)
      )
    :effect
      (and
        (remediation_order_issued ?remediation_order)
        (remediation_order_covers_packaging_unit ?remediation_order ?affected_packaging_unit)
        (remediation_order_covers_shipment ?remediation_order ?affected_shipment)
        (remediation_order_flag_quarantine ?remediation_order)
        (remediation_order_flag_recall ?remediation_order)
        (not
          (remediation_order_ready ?remediation_order)
        )
      )
  )
  (:action confirm_order_execution_at_site
    :parameters (?remediation_order - remediation_order ?manufacturing_site_case - manufacturing_site_case ?lab_analyst - lab_analyst)
    :precondition
      (and
        (remediation_order_issued ?remediation_order)
        (manufacturing_site_ready ?manufacturing_site_case)
        (case_assigned_lab_analyst ?manufacturing_site_case ?lab_analyst)
        (not
          (remediation_order_execution_confirmed ?remediation_order)
        )
      )
    :effect (remediation_order_execution_confirmed ?remediation_order)
  )
  (:action process_sample_and_link_to_order
    :parameters (?product_record - product_record ?sample_report - sample_report ?remediation_order - remediation_order)
    :precondition
      (and
        (case_triaged ?product_record)
        (product_linked_to_remediation_order ?product_record ?remediation_order)
        (product_has_sample_report ?product_record ?sample_report)
        (sample_report_available ?sample_report)
        (remediation_order_issued ?remediation_order)
        (remediation_order_execution_confirmed ?remediation_order)
        (not
          (sample_report_processed ?sample_report)
        )
      )
    :effect
      (and
        (sample_report_processed ?sample_report)
        (sample_report_linked_to_order ?sample_report ?remediation_order)
        (not
          (sample_report_available ?sample_report)
        )
      )
  )
  (:action initiate_crossfunctional_review_on_product
    :parameters (?product_record - product_record ?sample_report - sample_report ?remediation_order - remediation_order ?lab_analyst - lab_analyst)
    :precondition
      (and
        (case_triaged ?product_record)
        (product_has_sample_report ?product_record ?sample_report)
        (sample_report_processed ?sample_report)
        (sample_report_linked_to_order ?sample_report ?remediation_order)
        (case_assigned_lab_analyst ?product_record ?lab_analyst)
        (not
          (remediation_order_flag_quarantine ?remediation_order)
        )
        (not
          (crossfunctional_review_started ?product_record)
        )
      )
    :effect (crossfunctional_review_started ?product_record)
  )
  (:action assign_regulatory_document_to_product
    :parameters (?product_record - product_record ?regulatory_document - regulatory_document)
    :precondition
      (and
        (case_triaged ?product_record)
        (regulatory_document_available ?regulatory_document)
        (not
          (regulatory_document_attached ?product_record)
        )
      )
    :effect
      (and
        (regulatory_document_attached ?product_record)
        (product_has_regulatory_document ?product_record ?regulatory_document)
        (not
          (regulatory_document_available ?regulatory_document)
        )
      )
  )
  (:action start_regulatory_review_for_product
    :parameters (?product_record - product_record ?sample_report - sample_report ?remediation_order - remediation_order ?lab_analyst - lab_analyst ?regulatory_document - regulatory_document)
    :precondition
      (and
        (case_triaged ?product_record)
        (product_has_sample_report ?product_record ?sample_report)
        (sample_report_processed ?sample_report)
        (sample_report_linked_to_order ?sample_report ?remediation_order)
        (case_assigned_lab_analyst ?product_record ?lab_analyst)
        (remediation_order_flag_quarantine ?remediation_order)
        (regulatory_document_attached ?product_record)
        (product_has_regulatory_document ?product_record ?regulatory_document)
        (not
          (crossfunctional_review_started ?product_record)
        )
      )
    :effect
      (and
        (crossfunctional_review_started ?product_record)
        (regulatory_review_in_progress ?product_record)
      )
  )
  (:action initiate_technical_signoff_with_external_vendor
    :parameters (?product_record - product_record ?external_vendor - external_vendor ?quality_supervisor - quality_supervisor ?sample_report - sample_report ?remediation_order - remediation_order)
    :precondition
      (and
        (crossfunctional_review_started ?product_record)
        (product_linked_to_external_vendor ?product_record ?external_vendor)
        (case_assigned_qa_supervisor ?product_record ?quality_supervisor)
        (product_has_sample_report ?product_record ?sample_report)
        (sample_report_linked_to_order ?sample_report ?remediation_order)
        (not
          (remediation_order_flag_recall ?remediation_order)
        )
        (not
          (technical_signoff_initiated ?product_record)
        )
      )
    :effect (technical_signoff_initiated ?product_record)
  )
  (:action initiate_technical_signoff_alternate
    :parameters (?product_record - product_record ?external_vendor - external_vendor ?quality_supervisor - quality_supervisor ?sample_report - sample_report ?remediation_order - remediation_order)
    :precondition
      (and
        (crossfunctional_review_started ?product_record)
        (product_linked_to_external_vendor ?product_record ?external_vendor)
        (case_assigned_qa_supervisor ?product_record ?quality_supervisor)
        (product_has_sample_report ?product_record ?sample_report)
        (sample_report_linked_to_order ?sample_report ?remediation_order)
        (remediation_order_flag_recall ?remediation_order)
        (not
          (technical_signoff_initiated ?product_record)
        )
      )
    :effect (technical_signoff_initiated ?product_record)
  )
  (:action initiate_third_party_lab_review
    :parameters (?product_record - product_record ?third_party_lab - third_party_lab ?sample_report - sample_report ?remediation_order - remediation_order)
    :precondition
      (and
        (technical_signoff_initiated ?product_record)
        (product_linked_to_third_party_lab ?product_record ?third_party_lab)
        (product_has_sample_report ?product_record ?sample_report)
        (sample_report_linked_to_order ?sample_report ?remediation_order)
        (not
          (remediation_order_flag_quarantine ?remediation_order)
        )
        (not
          (remediation_order_flag_recall ?remediation_order)
        )
        (not
          (crossfunctional_approvals_completed ?product_record)
        )
      )
    :effect (crossfunctional_approvals_completed ?product_record)
  )
  (:action complete_third_party_lab_review_and_record_approvals
    :parameters (?product_record - product_record ?third_party_lab - third_party_lab ?sample_report - sample_report ?remediation_order - remediation_order)
    :precondition
      (and
        (technical_signoff_initiated ?product_record)
        (product_linked_to_third_party_lab ?product_record ?third_party_lab)
        (product_has_sample_report ?product_record ?sample_report)
        (sample_report_linked_to_order ?sample_report ?remediation_order)
        (remediation_order_flag_quarantine ?remediation_order)
        (not
          (remediation_order_flag_recall ?remediation_order)
        )
        (not
          (crossfunctional_approvals_completed ?product_record)
        )
      )
    :effect
      (and
        (crossfunctional_approvals_completed ?product_record)
        (external_vendor_approval_obtained ?product_record)
      )
  )
  (:action complete_third_party_lab_review_variant
    :parameters (?product_record - product_record ?third_party_lab - third_party_lab ?sample_report - sample_report ?remediation_order - remediation_order)
    :precondition
      (and
        (technical_signoff_initiated ?product_record)
        (product_linked_to_third_party_lab ?product_record ?third_party_lab)
        (product_has_sample_report ?product_record ?sample_report)
        (sample_report_linked_to_order ?sample_report ?remediation_order)
        (not
          (remediation_order_flag_quarantine ?remediation_order)
        )
        (remediation_order_flag_recall ?remediation_order)
        (not
          (crossfunctional_approvals_completed ?product_record)
        )
      )
    :effect
      (and
        (crossfunctional_approvals_completed ?product_record)
        (external_vendor_approval_obtained ?product_record)
      )
  )
  (:action complete_third_party_lab_review_variant_two
    :parameters (?product_record - product_record ?third_party_lab - third_party_lab ?sample_report - sample_report ?remediation_order - remediation_order)
    :precondition
      (and
        (technical_signoff_initiated ?product_record)
        (product_linked_to_third_party_lab ?product_record ?third_party_lab)
        (product_has_sample_report ?product_record ?sample_report)
        (sample_report_linked_to_order ?sample_report ?remediation_order)
        (remediation_order_flag_quarantine ?remediation_order)
        (remediation_order_flag_recall ?remediation_order)
        (not
          (crossfunctional_approvals_completed ?product_record)
        )
      )
    :effect
      (and
        (crossfunctional_approvals_completed ?product_record)
        (external_vendor_approval_obtained ?product_record)
      )
  )
  (:action finalize_crossfunctional_approval
    :parameters (?product_record - product_record)
    :precondition
      (and
        (crossfunctional_approvals_completed ?product_record)
        (not
          (external_vendor_approval_obtained ?product_record)
        )
        (not
          (final_authorization_recorded ?product_record)
        )
      )
    :effect
      (and
        (final_authorization_recorded ?product_record)
        (remediation_authorized ?product_record)
      )
  )
  (:action attach_logistics_ticket_to_product
    :parameters (?product_record - product_record ?logistics_ticket - logistics_ticket)
    :precondition
      (and
        (crossfunctional_approvals_completed ?product_record)
        (external_vendor_approval_obtained ?product_record)
        (logistics_ticket_available ?logistics_ticket)
      )
    :effect
      (and
        (product_linked_to_logistics_ticket ?product_record ?logistics_ticket)
        (not
          (logistics_ticket_available ?logistics_ticket)
        )
      )
  )
  (:action record_site_authorizations_for_product
    :parameters (?product_record - product_record ?manufacturing_site_case - manufacturing_site_case ?distribution_site_case - distribution_site_case ?lab_analyst - lab_analyst ?logistics_ticket - logistics_ticket)
    :precondition
      (and
        (crossfunctional_approvals_completed ?product_record)
        (external_vendor_approval_obtained ?product_record)
        (product_linked_to_logistics_ticket ?product_record ?logistics_ticket)
        (product_linked_to_manufacturing_case ?product_record ?manufacturing_site_case)
        (product_linked_to_distribution_case ?product_record ?distribution_site_case)
        (manufacturing_site_lock_recorded ?manufacturing_site_case)
        (distribution_site_lock_recorded ?distribution_site_case)
        (case_assigned_lab_analyst ?product_record ?lab_analyst)
        (not
          (final_internal_approval ?product_record)
        )
      )
    :effect (final_internal_approval ?product_record)
  )
  (:action finalize_internal_authorization
    :parameters (?product_record - product_record)
    :precondition
      (and
        (crossfunctional_approvals_completed ?product_record)
        (final_internal_approval ?product_record)
        (not
          (final_authorization_recorded ?product_record)
        )
      )
    :effect
      (and
        (final_authorization_recorded ?product_record)
        (remediation_authorized ?product_record)
      )
  )
  (:action engage_regulator_contact_for_product
    :parameters (?product_record - product_record ?regulator_contact - regulator_contact ?lab_analyst - lab_analyst)
    :precondition
      (and
        (case_triaged ?product_record)
        (case_assigned_lab_analyst ?product_record ?lab_analyst)
        (regulator_contact_available ?regulator_contact)
        (product_linked_to_regulator_contact ?product_record ?regulator_contact)
        (not
          (regulatory_review_started ?product_record)
        )
      )
    :effect
      (and
        (regulatory_review_started ?product_record)
        (not
          (regulator_contact_available ?regulator_contact)
        )
      )
  )
  (:action assign_qa_reviewer_for_regulatory_review
    :parameters (?product_record - product_record ?quality_supervisor - quality_supervisor)
    :precondition
      (and
        (regulatory_review_started ?product_record)
        (case_assigned_qa_supervisor ?product_record ?quality_supervisor)
        (not
          (regulatory_review_assigned ?product_record)
        )
      )
    :effect (regulatory_review_assigned ?product_record)
  )
  (:action request_regulatory_signoff
    :parameters (?product_record - product_record ?third_party_lab - third_party_lab)
    :precondition
      (and
        (regulatory_review_assigned ?product_record)
        (product_linked_to_third_party_lab ?product_record ?third_party_lab)
        (not
          (regulatory_signoff_obtained ?product_record)
        )
      )
    :effect (regulatory_signoff_obtained ?product_record)
  )
  (:action finalize_regulatory_authorization
    :parameters (?product_record - product_record)
    :precondition
      (and
        (regulatory_signoff_obtained ?product_record)
        (not
          (final_authorization_recorded ?product_record)
        )
      )
    :effect
      (and
        (final_authorization_recorded ?product_record)
        (remediation_authorized ?product_record)
      )
  )
  (:action authorize_manufacturing_site_for_remediation
    :parameters (?manufacturing_site_case - manufacturing_site_case ?remediation_order - remediation_order)
    :precondition
      (and
        (manufacturing_site_ready ?manufacturing_site_case)
        (manufacturing_site_lock_recorded ?manufacturing_site_case)
        (remediation_order_issued ?remediation_order)
        (remediation_order_execution_confirmed ?remediation_order)
        (not
          (remediation_authorized ?manufacturing_site_case)
        )
      )
    :effect (remediation_authorized ?manufacturing_site_case)
  )
  (:action authorize_distribution_site_for_remediation
    :parameters (?distribution_site_case - distribution_site_case ?remediation_order - remediation_order)
    :precondition
      (and
        (distribution_site_ready ?distribution_site_case)
        (distribution_site_lock_recorded ?distribution_site_case)
        (remediation_order_issued ?remediation_order)
        (remediation_order_execution_confirmed ?remediation_order)
        (not
          (remediation_authorized ?distribution_site_case)
        )
      )
    :effect (remediation_authorized ?distribution_site_case)
  )
  (:action dispatch_notification_and_flag_case
    :parameters (?investigation_case - investigation_case ?notification_template - notification_template ?lab_analyst - lab_analyst)
    :precondition
      (and
        (remediation_authorized ?investigation_case)
        (case_assigned_lab_analyst ?investigation_case ?lab_analyst)
        (notification_template_available ?notification_template)
        (not
          (notifications_dispatched ?investigation_case)
        )
      )
    :effect
      (and
        (notifications_dispatched ?investigation_case)
        (case_linked_to_notification_template ?investigation_case ?notification_template)
        (not
          (notification_template_available ?notification_template)
        )
      )
  )
  (:action execute_block_at_manufacturing_site
    :parameters (?manufacturing_site_case - manufacturing_site_case ?labeling_line_resource - labeling_line_resource ?notification_template - notification_template)
    :precondition
      (and
        (notifications_dispatched ?manufacturing_site_case)
        (case_assigned_labeling_line ?manufacturing_site_case ?labeling_line_resource)
        (case_linked_to_notification_template ?manufacturing_site_case ?notification_template)
        (not
          (case_blocked ?manufacturing_site_case)
        )
      )
    :effect
      (and
        (case_blocked ?manufacturing_site_case)
        (labeling_line_available ?labeling_line_resource)
        (notification_template_available ?notification_template)
      )
  )
  (:action execute_block_at_distribution_site
    :parameters (?distribution_site_case - distribution_site_case ?labeling_line_resource - labeling_line_resource ?notification_template - notification_template)
    :precondition
      (and
        (notifications_dispatched ?distribution_site_case)
        (case_assigned_labeling_line ?distribution_site_case ?labeling_line_resource)
        (case_linked_to_notification_template ?distribution_site_case ?notification_template)
        (not
          (case_blocked ?distribution_site_case)
        )
      )
    :effect
      (and
        (case_blocked ?distribution_site_case)
        (labeling_line_available ?labeling_line_resource)
        (notification_template_available ?notification_template)
      )
  )
  (:action execute_block_on_product_record
    :parameters (?product_record - product_record ?labeling_line_resource - labeling_line_resource ?notification_template - notification_template)
    :precondition
      (and
        (notifications_dispatched ?product_record)
        (case_assigned_labeling_line ?product_record ?labeling_line_resource)
        (case_linked_to_notification_template ?product_record ?notification_template)
        (not
          (case_blocked ?product_record)
        )
      )
    :effect
      (and
        (case_blocked ?product_record)
        (labeling_line_available ?labeling_line_resource)
        (notification_template_available ?notification_template)
      )
  )
)

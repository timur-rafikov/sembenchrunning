(define (domain rejected_receipt_reallocation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource - object logistics_asset - object location_role - object exception_case_root - object rejected_receipt_case - exception_case_root carrier - operational_resource inspection_team - operational_resource facility - operational_resource compliance_document - operational_resource service_profile - operational_resource claim_document - operational_resource operational_certificate - operational_resource incident_report - operational_resource inventory_unit - logistics_asset staging_slot - logistics_asset vendor_authorization - logistics_asset candidate_source - location_role candidate_destination - location_role reallocation_shipment - location_role manifest_segment - rejected_receipt_case allocation_block - rejected_receipt_case order_line - manifest_segment shipment_unit - manifest_segment reallocation_plan - allocation_block)
  (:predicates
    (entity_opened ?rejected_receipt_case - rejected_receipt_case)
    (entity_validated ?rejected_receipt_case - rejected_receipt_case)
    (entity_carrier_assignment_registered ?rejected_receipt_case - rejected_receipt_case)
    (entity_reallocation_finalized ?rejected_receipt_case - rejected_receipt_case)
    (entity_execution_ready ?rejected_receipt_case - rejected_receipt_case)
    (entity_claim_registered ?rejected_receipt_case - rejected_receipt_case)
    (carrier_available ?carrier - carrier)
    (entity_assigned_carrier ?rejected_receipt_case - rejected_receipt_case ?carrier - carrier)
    (inspection_team_available ?inspection_team - inspection_team)
    (entity_inspection_assigned ?rejected_receipt_case - rejected_receipt_case ?inspection_team - inspection_team)
    (facility_available ?facility - facility)
    (entity_assigned_facility ?rejected_receipt_case - rejected_receipt_case ?facility - facility)
    (inventory_unit_available ?inventory_unit - inventory_unit)
    (order_line_allocated_inventory ?order_line - order_line ?inventory_unit - inventory_unit)
    (shipment_unit_allocated_inventory ?shipment_unit - shipment_unit ?inventory_unit - inventory_unit)
    (order_line_candidate_source ?order_line - order_line ?candidate_source - candidate_source)
    (source_shortlisted ?candidate_source - candidate_source)
    (source_inventory_reserved ?candidate_source - candidate_source)
    (order_line_allocation_confirmed ?order_line - order_line)
    (shipment_unit_candidate_destination ?shipment_unit - shipment_unit ?candidate_destination - candidate_destination)
    (destination_shortlisted ?candidate_destination - candidate_destination)
    (destination_inventory_reserved ?candidate_destination - candidate_destination)
    (shipment_unit_allocation_confirmed ?shipment_unit - shipment_unit)
    (reallocation_shipment_draft ?reallocation_shipment - reallocation_shipment)
    (reallocation_shipment_booked ?reallocation_shipment - reallocation_shipment)
    (reallocation_shipment_origin_assigned ?reallocation_shipment - reallocation_shipment ?candidate_source - candidate_source)
    (reallocation_shipment_destination_assigned ?reallocation_shipment - reallocation_shipment ?candidate_destination - candidate_destination)
    (shipment_origin_window_set ?reallocation_shipment - reallocation_shipment)
    (shipment_destination_window_set ?reallocation_shipment - reallocation_shipment)
    (shipment_ready_for_staging ?reallocation_shipment - reallocation_shipment)
    (plan_has_order_line ?reallocation_plan - reallocation_plan ?order_line - order_line)
    (plan_has_shipment_unit ?reallocation_plan - reallocation_plan ?shipment_unit - shipment_unit)
    (plan_bound_shipment ?reallocation_plan - reallocation_plan ?reallocation_shipment - reallocation_shipment)
    (staging_slot_available ?staging_slot - staging_slot)
    (plan_staging_slot_assigned ?reallocation_plan - reallocation_plan ?staging_slot - staging_slot)
    (staging_slot_reserved ?staging_slot - staging_slot)
    (staging_slot_assigned_to_shipment ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment)
    (plan_validation_passed ?reallocation_plan - reallocation_plan)
    (plan_certificate_checks_passed ?reallocation_plan - reallocation_plan)
    (plan_ready_for_approval ?reallocation_plan - reallocation_plan)
    (plan_has_compliance_document ?reallocation_plan - reallocation_plan)
    (plan_compliance_verified ?reallocation_plan - reallocation_plan)
    (plan_service_profile_attached ?reallocation_plan - reallocation_plan)
    (plan_final_checks_passed ?reallocation_plan - reallocation_plan)
    (vendor_authorization_available ?vendor_authorization - vendor_authorization)
    (plan_vendor_authorization_attached ?reallocation_plan - reallocation_plan ?vendor_authorization - vendor_authorization)
    (plan_vendor_authorization_acknowledged ?reallocation_plan - reallocation_plan)
    (plan_vendor_authorization_processed ?reallocation_plan - reallocation_plan)
    (plan_vendor_authorization_finalized ?reallocation_plan - reallocation_plan)
    (compliance_document_available ?compliance_document - compliance_document)
    (plan_compliance_document_attached ?reallocation_plan - reallocation_plan ?compliance_document - compliance_document)
    (service_profile_available ?service_profile - service_profile)
    (plan_service_profile_binding ?reallocation_plan - reallocation_plan ?service_profile - service_profile)
    (operational_certificate_available ?operational_certificate - operational_certificate)
    (plan_operational_certificate_attached ?reallocation_plan - reallocation_plan ?operational_certificate - operational_certificate)
    (incident_report_available ?incident_report - incident_report)
    (plan_incident_report_attached ?reallocation_plan - reallocation_plan ?incident_report - incident_report)
    (claim_document_available ?claim_document - claim_document)
    (entity_claim_document_attached ?rejected_receipt_case - rejected_receipt_case ?claim_document - claim_document)
    (order_line_allocation_active ?order_line - order_line)
    (shipment_unit_allocation_active ?shipment_unit - shipment_unit)
    (plan_finalized ?reallocation_plan - reallocation_plan)
  )
  (:action open_rejected_receipt_case
    :parameters (?rejected_receipt_case - rejected_receipt_case)
    :precondition
      (and
        (not
          (entity_opened ?rejected_receipt_case)
        )
        (not
          (entity_reallocation_finalized ?rejected_receipt_case)
        )
      )
    :effect (entity_opened ?rejected_receipt_case)
  )
  (:action assign_carrier_to_case
    :parameters (?rejected_receipt_case - rejected_receipt_case ?carrier - carrier)
    :precondition
      (and
        (entity_opened ?rejected_receipt_case)
        (not
          (entity_carrier_assignment_registered ?rejected_receipt_case)
        )
        (carrier_available ?carrier)
      )
    :effect
      (and
        (entity_carrier_assignment_registered ?rejected_receipt_case)
        (entity_assigned_carrier ?rejected_receipt_case ?carrier)
        (not
          (carrier_available ?carrier)
        )
      )
  )
  (:action assign_inspection_team_to_case
    :parameters (?rejected_receipt_case - rejected_receipt_case ?inspection_team - inspection_team)
    :precondition
      (and
        (entity_opened ?rejected_receipt_case)
        (entity_carrier_assignment_registered ?rejected_receipt_case)
        (inspection_team_available ?inspection_team)
      )
    :effect
      (and
        (entity_inspection_assigned ?rejected_receipt_case ?inspection_team)
        (not
          (inspection_team_available ?inspection_team)
        )
      )
  )
  (:action record_inspection_outcome
    :parameters (?rejected_receipt_case - rejected_receipt_case ?inspection_team - inspection_team)
    :precondition
      (and
        (entity_opened ?rejected_receipt_case)
        (entity_carrier_assignment_registered ?rejected_receipt_case)
        (entity_inspection_assigned ?rejected_receipt_case ?inspection_team)
        (not
          (entity_validated ?rejected_receipt_case)
        )
      )
    :effect (entity_validated ?rejected_receipt_case)
  )
  (:action release_inspection_team
    :parameters (?rejected_receipt_case - rejected_receipt_case ?inspection_team - inspection_team)
    :precondition
      (and
        (entity_inspection_assigned ?rejected_receipt_case ?inspection_team)
      )
    :effect
      (and
        (inspection_team_available ?inspection_team)
        (not
          (entity_inspection_assigned ?rejected_receipt_case ?inspection_team)
        )
      )
  )
  (:action reserve_facility_for_case
    :parameters (?rejected_receipt_case - rejected_receipt_case ?facility - facility)
    :precondition
      (and
        (entity_validated ?rejected_receipt_case)
        (facility_available ?facility)
      )
    :effect
      (and
        (entity_assigned_facility ?rejected_receipt_case ?facility)
        (not
          (facility_available ?facility)
        )
      )
  )
  (:action release_facility_from_case
    :parameters (?rejected_receipt_case - rejected_receipt_case ?facility - facility)
    :precondition
      (and
        (entity_assigned_facility ?rejected_receipt_case ?facility)
      )
    :effect
      (and
        (facility_available ?facility)
        (not
          (entity_assigned_facility ?rejected_receipt_case ?facility)
        )
      )
  )
  (:action attach_operational_certificate_to_plan
    :parameters (?reallocation_plan - reallocation_plan ?operational_certificate - operational_certificate)
    :precondition
      (and
        (entity_validated ?reallocation_plan)
        (operational_certificate_available ?operational_certificate)
      )
    :effect
      (and
        (plan_operational_certificate_attached ?reallocation_plan ?operational_certificate)
        (not
          (operational_certificate_available ?operational_certificate)
        )
      )
  )
  (:action detach_operational_certificate_from_plan
    :parameters (?reallocation_plan - reallocation_plan ?operational_certificate - operational_certificate)
    :precondition
      (and
        (plan_operational_certificate_attached ?reallocation_plan ?operational_certificate)
      )
    :effect
      (and
        (operational_certificate_available ?operational_certificate)
        (not
          (plan_operational_certificate_attached ?reallocation_plan ?operational_certificate)
        )
      )
  )
  (:action attach_incident_report_to_plan
    :parameters (?reallocation_plan - reallocation_plan ?incident_report - incident_report)
    :precondition
      (and
        (entity_validated ?reallocation_plan)
        (incident_report_available ?incident_report)
      )
    :effect
      (and
        (plan_incident_report_attached ?reallocation_plan ?incident_report)
        (not
          (incident_report_available ?incident_report)
        )
      )
  )
  (:action detach_incident_report_from_plan
    :parameters (?reallocation_plan - reallocation_plan ?incident_report - incident_report)
    :precondition
      (and
        (plan_incident_report_attached ?reallocation_plan ?incident_report)
      )
    :effect
      (and
        (incident_report_available ?incident_report)
        (not
          (plan_incident_report_attached ?reallocation_plan ?incident_report)
        )
      )
  )
  (:action shortlist_candidate_source_for_order_line
    :parameters (?order_line - order_line ?candidate_source - candidate_source ?inspection_team - inspection_team)
    :precondition
      (and
        (entity_validated ?order_line)
        (entity_inspection_assigned ?order_line ?inspection_team)
        (order_line_candidate_source ?order_line ?candidate_source)
        (not
          (source_shortlisted ?candidate_source)
        )
        (not
          (source_inventory_reserved ?candidate_source)
        )
      )
    :effect (source_shortlisted ?candidate_source)
  )
  (:action confirm_order_line_allocation_with_facility
    :parameters (?order_line - order_line ?candidate_source - candidate_source ?facility - facility)
    :precondition
      (and
        (entity_validated ?order_line)
        (entity_assigned_facility ?order_line ?facility)
        (order_line_candidate_source ?order_line ?candidate_source)
        (source_shortlisted ?candidate_source)
        (not
          (order_line_allocation_active ?order_line)
        )
      )
    :effect
      (and
        (order_line_allocation_active ?order_line)
        (order_line_allocation_confirmed ?order_line)
      )
  )
  (:action reserve_inventory_at_candidate_source
    :parameters (?order_line - order_line ?candidate_source - candidate_source ?inventory_unit - inventory_unit)
    :precondition
      (and
        (entity_validated ?order_line)
        (order_line_candidate_source ?order_line ?candidate_source)
        (inventory_unit_available ?inventory_unit)
        (not
          (order_line_allocation_active ?order_line)
        )
      )
    :effect
      (and
        (source_inventory_reserved ?candidate_source)
        (order_line_allocation_active ?order_line)
        (order_line_allocated_inventory ?order_line ?inventory_unit)
        (not
          (inventory_unit_available ?inventory_unit)
        )
      )
  )
  (:action finalize_order_line_allocation
    :parameters (?order_line - order_line ?candidate_source - candidate_source ?inspection_team - inspection_team ?inventory_unit - inventory_unit)
    :precondition
      (and
        (entity_validated ?order_line)
        (entity_inspection_assigned ?order_line ?inspection_team)
        (order_line_candidate_source ?order_line ?candidate_source)
        (source_inventory_reserved ?candidate_source)
        (order_line_allocated_inventory ?order_line ?inventory_unit)
        (not
          (order_line_allocation_confirmed ?order_line)
        )
      )
    :effect
      (and
        (source_shortlisted ?candidate_source)
        (order_line_allocation_confirmed ?order_line)
        (inventory_unit_available ?inventory_unit)
        (not
          (order_line_allocated_inventory ?order_line ?inventory_unit)
        )
      )
  )
  (:action shortlist_candidate_destination_for_shipment_unit
    :parameters (?shipment_unit - shipment_unit ?candidate_destination - candidate_destination ?inspection_team - inspection_team)
    :precondition
      (and
        (entity_validated ?shipment_unit)
        (entity_inspection_assigned ?shipment_unit ?inspection_team)
        (shipment_unit_candidate_destination ?shipment_unit ?candidate_destination)
        (not
          (destination_shortlisted ?candidate_destination)
        )
        (not
          (destination_inventory_reserved ?candidate_destination)
        )
      )
    :effect (destination_shortlisted ?candidate_destination)
  )
  (:action confirm_shipment_unit_destination_with_facility
    :parameters (?shipment_unit - shipment_unit ?candidate_destination - candidate_destination ?facility - facility)
    :precondition
      (and
        (entity_validated ?shipment_unit)
        (entity_assigned_facility ?shipment_unit ?facility)
        (shipment_unit_candidate_destination ?shipment_unit ?candidate_destination)
        (destination_shortlisted ?candidate_destination)
        (not
          (shipment_unit_allocation_active ?shipment_unit)
        )
      )
    :effect
      (and
        (shipment_unit_allocation_active ?shipment_unit)
        (shipment_unit_allocation_confirmed ?shipment_unit)
      )
  )
  (:action reserve_inventory_for_destination
    :parameters (?shipment_unit - shipment_unit ?candidate_destination - candidate_destination ?inventory_unit - inventory_unit)
    :precondition
      (and
        (entity_validated ?shipment_unit)
        (shipment_unit_candidate_destination ?shipment_unit ?candidate_destination)
        (inventory_unit_available ?inventory_unit)
        (not
          (shipment_unit_allocation_active ?shipment_unit)
        )
      )
    :effect
      (and
        (destination_inventory_reserved ?candidate_destination)
        (shipment_unit_allocation_active ?shipment_unit)
        (shipment_unit_allocated_inventory ?shipment_unit ?inventory_unit)
        (not
          (inventory_unit_available ?inventory_unit)
        )
      )
  )
  (:action finalize_shipment_unit_allocation
    :parameters (?shipment_unit - shipment_unit ?candidate_destination - candidate_destination ?inspection_team - inspection_team ?inventory_unit - inventory_unit)
    :precondition
      (and
        (entity_validated ?shipment_unit)
        (entity_inspection_assigned ?shipment_unit ?inspection_team)
        (shipment_unit_candidate_destination ?shipment_unit ?candidate_destination)
        (destination_inventory_reserved ?candidate_destination)
        (shipment_unit_allocated_inventory ?shipment_unit ?inventory_unit)
        (not
          (shipment_unit_allocation_confirmed ?shipment_unit)
        )
      )
    :effect
      (and
        (destination_shortlisted ?candidate_destination)
        (shipment_unit_allocation_confirmed ?shipment_unit)
        (inventory_unit_available ?inventory_unit)
        (not
          (shipment_unit_allocated_inventory ?shipment_unit ?inventory_unit)
        )
      )
  )
  (:action create_reallocation_shipment_booking
    :parameters (?order_line - order_line ?shipment_unit - shipment_unit ?candidate_source - candidate_source ?candidate_destination - candidate_destination ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (order_line_allocation_active ?order_line)
        (shipment_unit_allocation_active ?shipment_unit)
        (order_line_candidate_source ?order_line ?candidate_source)
        (shipment_unit_candidate_destination ?shipment_unit ?candidate_destination)
        (source_shortlisted ?candidate_source)
        (destination_shortlisted ?candidate_destination)
        (order_line_allocation_confirmed ?order_line)
        (shipment_unit_allocation_confirmed ?shipment_unit)
        (reallocation_shipment_draft ?reallocation_shipment)
      )
    :effect
      (and
        (reallocation_shipment_booked ?reallocation_shipment)
        (reallocation_shipment_origin_assigned ?reallocation_shipment ?candidate_source)
        (reallocation_shipment_destination_assigned ?reallocation_shipment ?candidate_destination)
        (not
          (reallocation_shipment_draft ?reallocation_shipment)
        )
      )
  )
  (:action book_reallocation_shipment_with_origin_window
    :parameters (?order_line - order_line ?shipment_unit - shipment_unit ?candidate_source - candidate_source ?candidate_destination - candidate_destination ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (order_line_allocation_active ?order_line)
        (shipment_unit_allocation_active ?shipment_unit)
        (order_line_candidate_source ?order_line ?candidate_source)
        (shipment_unit_candidate_destination ?shipment_unit ?candidate_destination)
        (source_inventory_reserved ?candidate_source)
        (destination_shortlisted ?candidate_destination)
        (not
          (order_line_allocation_confirmed ?order_line)
        )
        (shipment_unit_allocation_confirmed ?shipment_unit)
        (reallocation_shipment_draft ?reallocation_shipment)
      )
    :effect
      (and
        (reallocation_shipment_booked ?reallocation_shipment)
        (reallocation_shipment_origin_assigned ?reallocation_shipment ?candidate_source)
        (reallocation_shipment_destination_assigned ?reallocation_shipment ?candidate_destination)
        (shipment_origin_window_set ?reallocation_shipment)
        (not
          (reallocation_shipment_draft ?reallocation_shipment)
        )
      )
  )
  (:action book_reallocation_shipment_with_destination_window
    :parameters (?order_line - order_line ?shipment_unit - shipment_unit ?candidate_source - candidate_source ?candidate_destination - candidate_destination ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (order_line_allocation_active ?order_line)
        (shipment_unit_allocation_active ?shipment_unit)
        (order_line_candidate_source ?order_line ?candidate_source)
        (shipment_unit_candidate_destination ?shipment_unit ?candidate_destination)
        (source_shortlisted ?candidate_source)
        (destination_inventory_reserved ?candidate_destination)
        (order_line_allocation_confirmed ?order_line)
        (not
          (shipment_unit_allocation_confirmed ?shipment_unit)
        )
        (reallocation_shipment_draft ?reallocation_shipment)
      )
    :effect
      (and
        (reallocation_shipment_booked ?reallocation_shipment)
        (reallocation_shipment_origin_assigned ?reallocation_shipment ?candidate_source)
        (reallocation_shipment_destination_assigned ?reallocation_shipment ?candidate_destination)
        (shipment_destination_window_set ?reallocation_shipment)
        (not
          (reallocation_shipment_draft ?reallocation_shipment)
        )
      )
  )
  (:action book_reallocation_shipment_with_both_windows
    :parameters (?order_line - order_line ?shipment_unit - shipment_unit ?candidate_source - candidate_source ?candidate_destination - candidate_destination ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (order_line_allocation_active ?order_line)
        (shipment_unit_allocation_active ?shipment_unit)
        (order_line_candidate_source ?order_line ?candidate_source)
        (shipment_unit_candidate_destination ?shipment_unit ?candidate_destination)
        (source_inventory_reserved ?candidate_source)
        (destination_inventory_reserved ?candidate_destination)
        (not
          (order_line_allocation_confirmed ?order_line)
        )
        (not
          (shipment_unit_allocation_confirmed ?shipment_unit)
        )
        (reallocation_shipment_draft ?reallocation_shipment)
      )
    :effect
      (and
        (reallocation_shipment_booked ?reallocation_shipment)
        (reallocation_shipment_origin_assigned ?reallocation_shipment ?candidate_source)
        (reallocation_shipment_destination_assigned ?reallocation_shipment ?candidate_destination)
        (shipment_origin_window_set ?reallocation_shipment)
        (shipment_destination_window_set ?reallocation_shipment)
        (not
          (reallocation_shipment_draft ?reallocation_shipment)
        )
      )
  )
  (:action mark_shipment_ready_for_staging
    :parameters (?reallocation_shipment - reallocation_shipment ?order_line - order_line ?inspection_team - inspection_team)
    :precondition
      (and
        (reallocation_shipment_booked ?reallocation_shipment)
        (order_line_allocation_active ?order_line)
        (entity_inspection_assigned ?order_line ?inspection_team)
        (not
          (shipment_ready_for_staging ?reallocation_shipment)
        )
      )
    :effect (shipment_ready_for_staging ?reallocation_shipment)
  )
  (:action assign_staging_slot_to_shipment
    :parameters (?reallocation_plan - reallocation_plan ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (entity_validated ?reallocation_plan)
        (plan_bound_shipment ?reallocation_plan ?reallocation_shipment)
        (plan_staging_slot_assigned ?reallocation_plan ?staging_slot)
        (staging_slot_available ?staging_slot)
        (reallocation_shipment_booked ?reallocation_shipment)
        (shipment_ready_for_staging ?reallocation_shipment)
        (not
          (staging_slot_reserved ?staging_slot)
        )
      )
    :effect
      (and
        (staging_slot_reserved ?staging_slot)
        (staging_slot_assigned_to_shipment ?staging_slot ?reallocation_shipment)
        (not
          (staging_slot_available ?staging_slot)
        )
      )
  )
  (:action validate_plan_after_staging
    :parameters (?reallocation_plan - reallocation_plan ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment ?inspection_team - inspection_team)
    :precondition
      (and
        (entity_validated ?reallocation_plan)
        (plan_staging_slot_assigned ?reallocation_plan ?staging_slot)
        (staging_slot_reserved ?staging_slot)
        (staging_slot_assigned_to_shipment ?staging_slot ?reallocation_shipment)
        (entity_inspection_assigned ?reallocation_plan ?inspection_team)
        (not
          (shipment_origin_window_set ?reallocation_shipment)
        )
        (not
          (plan_validation_passed ?reallocation_plan)
        )
      )
    :effect (plan_validation_passed ?reallocation_plan)
  )
  (:action attach_compliance_document_to_plan
    :parameters (?reallocation_plan - reallocation_plan ?compliance_document - compliance_document)
    :precondition
      (and
        (entity_validated ?reallocation_plan)
        (compliance_document_available ?compliance_document)
        (not
          (plan_has_compliance_document ?reallocation_plan)
        )
      )
    :effect
      (and
        (plan_has_compliance_document ?reallocation_plan)
        (plan_compliance_document_attached ?reallocation_plan ?compliance_document)
        (not
          (compliance_document_available ?compliance_document)
        )
      )
  )
  (:action apply_compliance_and_progress_plan
    :parameters (?reallocation_plan - reallocation_plan ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment ?inspection_team - inspection_team ?compliance_document - compliance_document)
    :precondition
      (and
        (entity_validated ?reallocation_plan)
        (plan_staging_slot_assigned ?reallocation_plan ?staging_slot)
        (staging_slot_reserved ?staging_slot)
        (staging_slot_assigned_to_shipment ?staging_slot ?reallocation_shipment)
        (entity_inspection_assigned ?reallocation_plan ?inspection_team)
        (shipment_origin_window_set ?reallocation_shipment)
        (plan_has_compliance_document ?reallocation_plan)
        (plan_compliance_document_attached ?reallocation_plan ?compliance_document)
        (not
          (plan_validation_passed ?reallocation_plan)
        )
      )
    :effect
      (and
        (plan_validation_passed ?reallocation_plan)
        (plan_compliance_verified ?reallocation_plan)
      )
  )
  (:action apply_operational_certificate_for_plan
    :parameters (?reallocation_plan - reallocation_plan ?operational_certificate - operational_certificate ?facility - facility ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (plan_validation_passed ?reallocation_plan)
        (plan_operational_certificate_attached ?reallocation_plan ?operational_certificate)
        (entity_assigned_facility ?reallocation_plan ?facility)
        (plan_staging_slot_assigned ?reallocation_plan ?staging_slot)
        (staging_slot_assigned_to_shipment ?staging_slot ?reallocation_shipment)
        (not
          (shipment_destination_window_set ?reallocation_shipment)
        )
        (not
          (plan_certificate_checks_passed ?reallocation_plan)
        )
      )
    :effect (plan_certificate_checks_passed ?reallocation_plan)
  )
  (:action confirm_operational_certificate_for_plan
    :parameters (?reallocation_plan - reallocation_plan ?operational_certificate - operational_certificate ?facility - facility ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (plan_validation_passed ?reallocation_plan)
        (plan_operational_certificate_attached ?reallocation_plan ?operational_certificate)
        (entity_assigned_facility ?reallocation_plan ?facility)
        (plan_staging_slot_assigned ?reallocation_plan ?staging_slot)
        (staging_slot_assigned_to_shipment ?staging_slot ?reallocation_shipment)
        (shipment_destination_window_set ?reallocation_shipment)
        (not
          (plan_certificate_checks_passed ?reallocation_plan)
        )
      )
    :effect (plan_certificate_checks_passed ?reallocation_plan)
  )
  (:action apply_incident_report_and_mark_plan_ready
    :parameters (?reallocation_plan - reallocation_plan ?incident_report - incident_report ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (plan_certificate_checks_passed ?reallocation_plan)
        (plan_incident_report_attached ?reallocation_plan ?incident_report)
        (plan_staging_slot_assigned ?reallocation_plan ?staging_slot)
        (staging_slot_assigned_to_shipment ?staging_slot ?reallocation_shipment)
        (not
          (shipment_origin_window_set ?reallocation_shipment)
        )
        (not
          (shipment_destination_window_set ?reallocation_shipment)
        )
        (not
          (plan_ready_for_approval ?reallocation_plan)
        )
      )
    :effect (plan_ready_for_approval ?reallocation_plan)
  )
  (:action apply_incident_report_and_attach_service_profile
    :parameters (?reallocation_plan - reallocation_plan ?incident_report - incident_report ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (plan_certificate_checks_passed ?reallocation_plan)
        (plan_incident_report_attached ?reallocation_plan ?incident_report)
        (plan_staging_slot_assigned ?reallocation_plan ?staging_slot)
        (staging_slot_assigned_to_shipment ?staging_slot ?reallocation_shipment)
        (shipment_origin_window_set ?reallocation_shipment)
        (not
          (shipment_destination_window_set ?reallocation_shipment)
        )
        (not
          (plan_ready_for_approval ?reallocation_plan)
        )
      )
    :effect
      (and
        (plan_ready_for_approval ?reallocation_plan)
        (plan_service_profile_attached ?reallocation_plan)
      )
  )
  (:action apply_incident_report_with_profile_alternate
    :parameters (?reallocation_plan - reallocation_plan ?incident_report - incident_report ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (plan_certificate_checks_passed ?reallocation_plan)
        (plan_incident_report_attached ?reallocation_plan ?incident_report)
        (plan_staging_slot_assigned ?reallocation_plan ?staging_slot)
        (staging_slot_assigned_to_shipment ?staging_slot ?reallocation_shipment)
        (not
          (shipment_origin_window_set ?reallocation_shipment)
        )
        (shipment_destination_window_set ?reallocation_shipment)
        (not
          (plan_ready_for_approval ?reallocation_plan)
        )
      )
    :effect
      (and
        (plan_ready_for_approval ?reallocation_plan)
        (plan_service_profile_attached ?reallocation_plan)
      )
  )
  (:action apply_incident_report_and_attach_profiles
    :parameters (?reallocation_plan - reallocation_plan ?incident_report - incident_report ?staging_slot - staging_slot ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (plan_certificate_checks_passed ?reallocation_plan)
        (plan_incident_report_attached ?reallocation_plan ?incident_report)
        (plan_staging_slot_assigned ?reallocation_plan ?staging_slot)
        (staging_slot_assigned_to_shipment ?staging_slot ?reallocation_shipment)
        (shipment_origin_window_set ?reallocation_shipment)
        (shipment_destination_window_set ?reallocation_shipment)
        (not
          (plan_ready_for_approval ?reallocation_plan)
        )
      )
    :effect
      (and
        (plan_ready_for_approval ?reallocation_plan)
        (plan_service_profile_attached ?reallocation_plan)
      )
  )
  (:action finalize_reallocation_plan
    :parameters (?reallocation_plan - reallocation_plan)
    :precondition
      (and
        (plan_ready_for_approval ?reallocation_plan)
        (not
          (plan_service_profile_attached ?reallocation_plan)
        )
        (not
          (plan_finalized ?reallocation_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?reallocation_plan)
        (entity_execution_ready ?reallocation_plan)
      )
  )
  (:action attach_service_profile_to_plan
    :parameters (?reallocation_plan - reallocation_plan ?service_profile - service_profile)
    :precondition
      (and
        (plan_ready_for_approval ?reallocation_plan)
        (plan_service_profile_attached ?reallocation_plan)
        (service_profile_available ?service_profile)
      )
    :effect
      (and
        (plan_service_profile_binding ?reallocation_plan ?service_profile)
        (not
          (service_profile_available ?service_profile)
        )
      )
  )
  (:action validate_plan_with_resources_and_profiles
    :parameters (?reallocation_plan - reallocation_plan ?order_line - order_line ?shipment_unit - shipment_unit ?inspection_team - inspection_team ?service_profile - service_profile)
    :precondition
      (and
        (plan_ready_for_approval ?reallocation_plan)
        (plan_service_profile_attached ?reallocation_plan)
        (plan_service_profile_binding ?reallocation_plan ?service_profile)
        (plan_has_order_line ?reallocation_plan ?order_line)
        (plan_has_shipment_unit ?reallocation_plan ?shipment_unit)
        (order_line_allocation_confirmed ?order_line)
        (shipment_unit_allocation_confirmed ?shipment_unit)
        (entity_inspection_assigned ?reallocation_plan ?inspection_team)
        (not
          (plan_final_checks_passed ?reallocation_plan)
        )
      )
    :effect (plan_final_checks_passed ?reallocation_plan)
  )
  (:action finalize_and_activate_plan_for_execution
    :parameters (?reallocation_plan - reallocation_plan)
    :precondition
      (and
        (plan_ready_for_approval ?reallocation_plan)
        (plan_final_checks_passed ?reallocation_plan)
        (not
          (plan_finalized ?reallocation_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?reallocation_plan)
        (entity_execution_ready ?reallocation_plan)
      )
  )
  (:action acknowledge_vendor_authorization_for_plan
    :parameters (?reallocation_plan - reallocation_plan ?vendor_authorization - vendor_authorization ?inspection_team - inspection_team)
    :precondition
      (and
        (entity_validated ?reallocation_plan)
        (entity_inspection_assigned ?reallocation_plan ?inspection_team)
        (vendor_authorization_available ?vendor_authorization)
        (plan_vendor_authorization_attached ?reallocation_plan ?vendor_authorization)
        (not
          (plan_vendor_authorization_acknowledged ?reallocation_plan)
        )
      )
    :effect
      (and
        (plan_vendor_authorization_acknowledged ?reallocation_plan)
        (not
          (vendor_authorization_available ?vendor_authorization)
        )
      )
  )
  (:action process_vendor_authorization_with_facility
    :parameters (?reallocation_plan - reallocation_plan ?facility - facility)
    :precondition
      (and
        (plan_vendor_authorization_acknowledged ?reallocation_plan)
        (entity_assigned_facility ?reallocation_plan ?facility)
        (not
          (plan_vendor_authorization_processed ?reallocation_plan)
        )
      )
    :effect (plan_vendor_authorization_processed ?reallocation_plan)
  )
  (:action confirm_vendor_authorization_after_incident_review
    :parameters (?reallocation_plan - reallocation_plan ?incident_report - incident_report)
    :precondition
      (and
        (plan_vendor_authorization_processed ?reallocation_plan)
        (plan_incident_report_attached ?reallocation_plan ?incident_report)
        (not
          (plan_vendor_authorization_finalized ?reallocation_plan)
        )
      )
    :effect (plan_vendor_authorization_finalized ?reallocation_plan)
  )
  (:action finalize_vendor_authorization_and_mark_plan_ready
    :parameters (?reallocation_plan - reallocation_plan)
    :precondition
      (and
        (plan_vendor_authorization_finalized ?reallocation_plan)
        (not
          (plan_finalized ?reallocation_plan)
        )
      )
    :effect
      (and
        (plan_finalized ?reallocation_plan)
        (entity_execution_ready ?reallocation_plan)
      )
  )
  (:action dispatch_order_line_on_shipment
    :parameters (?order_line - order_line ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (order_line_allocation_active ?order_line)
        (order_line_allocation_confirmed ?order_line)
        (reallocation_shipment_booked ?reallocation_shipment)
        (shipment_ready_for_staging ?reallocation_shipment)
        (not
          (entity_execution_ready ?order_line)
        )
      )
    :effect (entity_execution_ready ?order_line)
  )
  (:action dispatch_shipment_unit_on_shipment
    :parameters (?shipment_unit - shipment_unit ?reallocation_shipment - reallocation_shipment)
    :precondition
      (and
        (shipment_unit_allocation_active ?shipment_unit)
        (shipment_unit_allocation_confirmed ?shipment_unit)
        (reallocation_shipment_booked ?reallocation_shipment)
        (shipment_ready_for_staging ?reallocation_shipment)
        (not
          (entity_execution_ready ?shipment_unit)
        )
      )
    :effect (entity_execution_ready ?shipment_unit)
  )
  (:action attach_claim_document_to_case
    :parameters (?rejected_receipt_case - rejected_receipt_case ?claim_document - claim_document ?inspection_team - inspection_team)
    :precondition
      (and
        (entity_execution_ready ?rejected_receipt_case)
        (entity_inspection_assigned ?rejected_receipt_case ?inspection_team)
        (claim_document_available ?claim_document)
        (not
          (entity_claim_registered ?rejected_receipt_case)
        )
      )
    :effect
      (and
        (entity_claim_registered ?rejected_receipt_case)
        (entity_claim_document_attached ?rejected_receipt_case ?claim_document)
        (not
          (claim_document_available ?claim_document)
        )
      )
  )
  (:action finalize_order_line_reallocation
    :parameters (?order_line - order_line ?carrier - carrier ?claim_document - claim_document)
    :precondition
      (and
        (entity_claim_registered ?order_line)
        (entity_assigned_carrier ?order_line ?carrier)
        (entity_claim_document_attached ?order_line ?claim_document)
        (not
          (entity_reallocation_finalized ?order_line)
        )
      )
    :effect
      (and
        (entity_reallocation_finalized ?order_line)
        (carrier_available ?carrier)
        (claim_document_available ?claim_document)
      )
  )
  (:action finalize_shipment_unit_reallocation
    :parameters (?shipment_unit - shipment_unit ?carrier - carrier ?claim_document - claim_document)
    :precondition
      (and
        (entity_claim_registered ?shipment_unit)
        (entity_assigned_carrier ?shipment_unit ?carrier)
        (entity_claim_document_attached ?shipment_unit ?claim_document)
        (not
          (entity_reallocation_finalized ?shipment_unit)
        )
      )
    :effect
      (and
        (entity_reallocation_finalized ?shipment_unit)
        (carrier_available ?carrier)
        (claim_document_available ?claim_document)
      )
  )
  (:action close_reallocation_plan_and_release_carrier
    :parameters (?reallocation_plan - reallocation_plan ?carrier - carrier ?claim_document - claim_document)
    :precondition
      (and
        (entity_claim_registered ?reallocation_plan)
        (entity_assigned_carrier ?reallocation_plan ?carrier)
        (entity_claim_document_attached ?reallocation_plan ?claim_document)
        (not
          (entity_reallocation_finalized ?reallocation_plan)
        )
      )
    :effect
      (and
        (entity_reallocation_finalized ?reallocation_plan)
        (carrier_available ?carrier)
        (claim_document_available ?claim_document)
      )
  )
)

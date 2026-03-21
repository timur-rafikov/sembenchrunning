(define (domain pharmacy_high_risk_release_checks_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types high_risk_release_task - object primary_pharmacist - object medication_order - object dispensing_location - object drug_lot - object administration_protocol - object scanning_terminal - object nurse_witness - object authorization_document - object quality_document - object patient_identifier - object prescriber - object staff_role - object pharmacy_witness_staff - staff_role secondary_checker - staff_role release_task_variant_a - high_risk_release_task release_task_variant_b - high_risk_release_task)
  (:predicates
    (nurse_witness_available ?nurse_witness - nurse_witness)
    (task_reserved_dispensing_location ?release_task - high_risk_release_task ?dispensing_location - dispensing_location)
    (ready_for_final_signoff ?release_task - high_risk_release_task)
    (assigned_primary_pharmacist ?release_task - high_risk_release_task ?primary_pharmacist - primary_pharmacist)
    (task_role_available ?release_task - high_risk_release_task ?staff_role - staff_role)
    (administration_protocol_available ?administration_protocol - administration_protocol)
    (dispensing_location_available ?dispensing_location - dispensing_location)
    (task_prescriber_association ?release_task - high_risk_release_task ?prescriber - prescriber)
    (task_finalized ?release_task - high_risk_release_task)
    (variant_a_task ?release_task_variant_a - high_risk_release_task)
    (eligible_primary_pharmacist ?release_task - high_risk_release_task ?primary_pharmacist - primary_pharmacist)
    (medication_order_active ?medication_order - medication_order)
    (patient_identifier_available ?patient_identifier - patient_identifier)
    (scanning_terminal_available ?scanning_terminal - scanning_terminal)
    (clinical_verification_flag ?release_task - high_risk_release_task)
    (task_can_reserve_dispensing_location ?release_task - high_risk_release_task ?dispensing_location - dispensing_location)
    (task_prescriber_linked ?release_task - high_risk_release_task ?prescriber - prescriber)
    (order_marked_approved ?release_task - high_risk_release_task ?medication_order - medication_order)
    (secondary_check_completed ?release_task - high_risk_release_task)
    (task_can_reserve_protocol ?release_task - high_risk_release_task ?administration_protocol - administration_protocol)
    (prescriber_available ?prescriber - prescriber)
    (variant_b_task ?release_task_variant_b - high_risk_release_task)
    (quality_document_attached ?release_task - high_risk_release_task)
    (task_can_reserve_drug_lot ?release_task - high_risk_release_task ?drug_lot - drug_lot)
    (task_reserved_drug_lot ?release_task - high_risk_release_task ?drug_lot - drug_lot)
    (secondary_check_triggered ?release_task - high_risk_release_task)
    (task_reserved_scanning_terminal ?release_task - high_risk_release_task ?scanning_terminal - scanning_terminal)
    (quality_review_completed ?release_task - high_risk_release_task)
    (task_patient_identifier_linked ?release_task - high_risk_release_task ?patient_identifier - patient_identifier)
    (task_active ?release_task - high_risk_release_task)
    (pharmacist_available ?primary_pharmacist - primary_pharmacist)
    (pharmacist_reserved ?release_task - high_risk_release_task)
    (quality_document_available ?quality_document - quality_document)
    (authorization_document_available ?authorization_document - authorization_document)
    (task_reserved_protocol ?release_task - high_risk_release_task ?administration_protocol - administration_protocol)
    (task_authorization_link ?release_task - high_risk_release_task ?authorization_document - authorization_document)
    (witness_confirmed ?release_task - high_risk_release_task)
    (device_scan_verified ?release_task - high_risk_release_task)
    (task_can_attach_authorization_doc ?release_task - high_risk_release_task ?authorization_document - authorization_document)
    (drug_lot_available ?drug_lot - drug_lot)
    (task_requires_authorization_document ?release_task - high_risk_release_task ?authorization_document - authorization_document)
    (task_linked_medication_order ?release_task - high_risk_release_task ?medication_order - medication_order)
    (witness_signature_recorded ?release_task - high_risk_release_task)
    (authorization_attached ?release_task - high_risk_release_task ?authorization_document - authorization_document)
  )
  (:action release_prescriber_link
    :parameters (?release_task - high_risk_release_task ?prescriber - prescriber)
    :precondition
      (and
        (task_prescriber_linked ?release_task ?prescriber)
      )
    :effect
      (and
        (prescriber_available ?prescriber)
        (not
          (task_prescriber_linked ?release_task ?prescriber)
        )
      )
  )
  (:action complete_secondary_check_with_secondary_checker
    :parameters (?release_task - high_risk_release_task ?administration_protocol - administration_protocol ?prescriber - prescriber ?secondary_checker - secondary_checker)
    :precondition
      (and
        (not
          (secondary_check_completed ?release_task)
        )
        (clinical_verification_flag ?release_task)
        (quality_document_attached ?release_task)
        (task_prescriber_linked ?release_task ?prescriber)
        (task_role_available ?release_task ?secondary_checker)
        (task_reserved_protocol ?release_task ?administration_protocol)
      )
    :effect
      (and
        (witness_signature_recorded ?release_task)
        (secondary_check_completed ?release_task)
      )
  )
  (:action final_signoff_variant_a
    :parameters (?release_task - high_risk_release_task)
    :precondition
      (and
        (quality_document_attached ?release_task)
        (pharmacist_reserved ?release_task)
        (clinical_verification_flag ?release_task)
        (task_active ?release_task)
        (device_scan_verified ?release_task)
        (not
          (task_finalized ?release_task)
        )
        (variant_a_task ?release_task)
        (secondary_check_completed ?release_task)
      )
    :effect
      (and
        (task_finalized ?release_task)
      )
  )
  (:action clear_secondary_check_trigger
    :parameters (?release_task - high_risk_release_task ?drug_lot - drug_lot ?dispensing_location - dispensing_location)
    :precondition
      (and
        (clinical_verification_flag ?release_task)
        (secondary_check_triggered ?release_task)
        (task_reserved_drug_lot ?release_task ?drug_lot)
        (task_reserved_dispensing_location ?release_task ?dispensing_location)
      )
    :effect
      (and
        (not
          (secondary_check_triggered ?release_task)
        )
        (not
          (witness_signature_recorded ?release_task)
        )
      )
  )
  (:action reserve_scanning_terminal
    :parameters (?release_task - high_risk_release_task ?scanning_terminal - scanning_terminal)
    :precondition
      (and
        (scanning_terminal_available ?scanning_terminal)
        (task_active ?release_task)
      )
    :effect
      (and
        (not
          (scanning_terminal_available ?scanning_terminal)
        )
        (task_reserved_scanning_terminal ?release_task ?scanning_terminal)
      )
  )
  (:action complete_secondary_check_with_pharmacy_witness
    :parameters (?release_task - high_risk_release_task ?drug_lot - drug_lot ?dispensing_location - dispensing_location ?pharmacy_witness_staff - pharmacy_witness_staff)
    :precondition
      (and
        (task_role_available ?release_task ?pharmacy_witness_staff)
        (quality_document_attached ?release_task)
        (not
          (witness_signature_recorded ?release_task)
        )
        (task_reserved_drug_lot ?release_task ?drug_lot)
        (clinical_verification_flag ?release_task)
        (task_reserved_dispensing_location ?release_task ?dispensing_location)
        (not
          (secondary_check_completed ?release_task)
        )
      )
    :effect
      (and
        (secondary_check_completed ?release_task)
      )
  )
  (:action apply_authorization_document_check
    :parameters (?release_task - high_risk_release_task ?authorization_document - authorization_document)
    :precondition
      (and
        (pharmacist_reserved ?release_task)
        (authorization_attached ?release_task ?authorization_document)
        (not
          (quality_document_attached ?release_task)
        )
      )
    :effect
      (and
        (quality_document_attached ?release_task)
        (not
          (witness_signature_recorded ?release_task)
        )
      )
  )
  (:action reserve_administration_protocol
    :parameters (?release_task - high_risk_release_task ?administration_protocol - administration_protocol)
    :precondition
      (and
        (task_can_reserve_protocol ?release_task ?administration_protocol)
        (task_active ?release_task)
        (administration_protocol_available ?administration_protocol)
      )
    :effect
      (and
        (task_reserved_protocol ?release_task ?administration_protocol)
        (not
          (administration_protocol_available ?administration_protocol)
        )
      )
  )
  (:action reserve_drug_lot
    :parameters (?release_task - high_risk_release_task ?drug_lot - drug_lot)
    :precondition
      (and
        (task_active ?release_task)
        (drug_lot_available ?drug_lot)
        (task_can_reserve_drug_lot ?release_task ?drug_lot)
      )
    :effect
      (and
        (not
          (drug_lot_available ?drug_lot)
        )
        (task_reserved_drug_lot ?release_task ?drug_lot)
      )
  )
  (:action release_administration_protocol
    :parameters (?release_task - high_risk_release_task ?administration_protocol - administration_protocol)
    :precondition
      (and
        (task_reserved_protocol ?release_task ?administration_protocol)
      )
    :effect
      (and
        (administration_protocol_available ?administration_protocol)
        (not
          (task_reserved_protocol ?release_task ?administration_protocol)
        )
      )
  )
  (:action release_dispensing_location
    :parameters (?release_task - high_risk_release_task ?dispensing_location - dispensing_location)
    :precondition
      (and
        (task_reserved_dispensing_location ?release_task ?dispensing_location)
      )
    :effect
      (and
        (dispensing_location_available ?dispensing_location)
        (not
          (task_reserved_dispensing_location ?release_task ?dispensing_location)
        )
      )
  )
  (:action attach_authorization_to_task_via_doc
    :parameters (?release_task - high_risk_release_task ?authorization_document - authorization_document)
    :precondition
      (and
        (device_scan_verified ?release_task)
        (authorization_document_available ?authorization_document)
        (task_can_attach_authorization_doc ?release_task ?authorization_document)
      )
    :effect
      (and
        (task_authorization_link ?release_task ?authorization_document)
        (not
          (authorization_document_available ?authorization_document)
        )
      )
  )
  (:action reserve_dispensing_location
    :parameters (?release_task - high_risk_release_task ?dispensing_location - dispensing_location)
    :precondition
      (and
        (task_active ?release_task)
        (dispensing_location_available ?dispensing_location)
        (task_can_reserve_dispensing_location ?release_task ?dispensing_location)
      )
    :effect
      (and
        (task_reserved_dispensing_location ?release_task ?dispensing_location)
        (not
          (dispensing_location_available ?dispensing_location)
        )
      )
  )
  (:action perform_order_clinical_verification
    :parameters (?release_task - high_risk_release_task ?medication_order - medication_order ?drug_lot - drug_lot ?dispensing_location - dispensing_location)
    :precondition
      (and
        (pharmacist_reserved ?release_task)
        (medication_order_active ?medication_order)
        (task_linked_medication_order ?release_task ?medication_order)
        (not
          (clinical_verification_flag ?release_task)
        )
        (task_reserved_dispensing_location ?release_task ?dispensing_location)
        (task_reserved_drug_lot ?release_task ?drug_lot)
      )
    :effect
      (and
        (order_marked_approved ?release_task ?medication_order)
        (not
          (medication_order_active ?medication_order)
        )
        (clinical_verification_flag ?release_task)
      )
  )
  (:action finalize_checks_and_mark_ready
    :parameters (?release_task - high_risk_release_task ?drug_lot - drug_lot ?dispensing_location - dispensing_location)
    :precondition
      (and
        (task_reserved_drug_lot ?release_task ?drug_lot)
        (secondary_check_completed ?release_task)
        (task_reserved_dispensing_location ?release_task ?dispensing_location)
        (witness_signature_recorded ?release_task)
      )
    :effect
      (and
        (not
          (secondary_check_triggered ?release_task)
        )
        (not
          (witness_signature_recorded ?release_task)
        )
        (not
          (quality_document_attached ?release_task)
        )
        (ready_for_final_signoff ?release_task)
      )
  )
  (:action release_scanning_terminal
    :parameters (?release_task - high_risk_release_task ?scanning_terminal - scanning_terminal)
    :precondition
      (and
        (task_reserved_scanning_terminal ?release_task ?scanning_terminal)
      )
    :effect
      (and
        (scanning_terminal_available ?scanning_terminal)
        (not
          (task_reserved_scanning_terminal ?release_task ?scanning_terminal)
        )
      )
  )
  (:action attach_quality_document_and_mark
    :parameters (?release_task - high_risk_release_task ?scanning_terminal - scanning_terminal ?quality_document - quality_document)
    :precondition
      (and
        (not
          (quality_document_attached ?release_task)
        )
        (pharmacist_reserved ?release_task)
        (quality_document_available ?quality_document)
        (task_reserved_scanning_terminal ?release_task ?scanning_terminal)
        (witness_confirmed ?release_task)
      )
    :effect
      (and
        (not
          (witness_signature_recorded ?release_task)
        )
        (quality_document_attached ?release_task)
      )
  )
  (:action final_signoff_with_quality_review
    :parameters (?release_task - high_risk_release_task)
    :precondition
      (and
        (task_active ?release_task)
        (variant_b_task ?release_task)
        (quality_review_completed ?release_task)
        (pharmacist_reserved ?release_task)
        (quality_document_attached ?release_task)
        (not
          (task_finalized ?release_task)
        )
        (device_scan_verified ?release_task)
        (clinical_verification_flag ?release_task)
        (secondary_check_completed ?release_task)
      )
    :effect
      (and
        (task_finalized ?release_task)
      )
  )
  (:action record_quality_review_for_variant
    :parameters (?release_task - high_risk_release_task ?scanning_terminal - scanning_terminal ?quality_document - quality_document)
    :precondition
      (and
        (quality_document_attached ?release_task)
        (quality_document_available ?quality_document)
        (not
          (quality_review_completed ?release_task)
        )
        (device_scan_verified ?release_task)
        (task_active ?release_task)
        (variant_b_task ?release_task)
        (task_reserved_scanning_terminal ?release_task ?scanning_terminal)
      )
    :effect
      (and
        (quality_review_completed ?release_task)
      )
  )
  (:action release_drug_lot
    :parameters (?release_task - high_risk_release_task ?drug_lot - drug_lot)
    :precondition
      (and
        (task_reserved_drug_lot ?release_task ?drug_lot)
      )
    :effect
      (and
        (drug_lot_available ?drug_lot)
        (not
          (task_reserved_drug_lot ?release_task ?drug_lot)
        )
      )
  )
  (:action reserve_prescriber_link
    :parameters (?release_task - high_risk_release_task ?prescriber - prescriber)
    :precondition
      (and
        (prescriber_available ?prescriber)
        (task_active ?release_task)
        (task_prescriber_association ?release_task ?prescriber)
      )
    :effect
      (and
        (task_prescriber_linked ?release_task ?prescriber)
        (not
          (prescriber_available ?prescriber)
        )
      )
  )
  (:action create_activate_release_task
    :parameters (?release_task - high_risk_release_task)
    :precondition
      (and
        (not
          (task_active ?release_task)
        )
        (not
          (task_finalized ?release_task)
        )
      )
    :effect
      (and
        (task_active ?release_task)
      )
  )
  (:action record_nurse_witness_signature
    :parameters (?release_task - high_risk_release_task ?nurse_witness - nurse_witness)
    :precondition
      (and
        (not
          (witness_confirmed ?release_task)
        )
        (task_active ?release_task)
        (nurse_witness_available ?nurse_witness)
        (pharmacist_reserved ?release_task)
      )
    :effect
      (and
        (witness_signature_recorded ?release_task)
        (not
          (nurse_witness_available ?nurse_witness)
        )
        (witness_confirmed ?release_task)
      )
  )
  (:action perform_order_clinical_verification_with_protocol
    :parameters (?release_task - high_risk_release_task ?medication_order - medication_order ?administration_protocol - administration_protocol ?patient_identifier - patient_identifier)
    :precondition
      (and
        (patient_identifier_available ?patient_identifier)
        (task_patient_identifier_linked ?release_task ?patient_identifier)
        (not
          (clinical_verification_flag ?release_task)
        )
        (pharmacist_reserved ?release_task)
        (medication_order_active ?medication_order)
        (task_linked_medication_order ?release_task ?medication_order)
        (task_reserved_protocol ?release_task ?administration_protocol)
      )
    :effect
      (and
        (order_marked_approved ?release_task ?medication_order)
        (not
          (patient_identifier_available ?patient_identifier)
        )
        (secondary_check_triggered ?release_task)
        (not
          (medication_order_active ?medication_order)
        )
        (witness_signature_recorded ?release_task)
        (clinical_verification_flag ?release_task)
      )
  )
  (:action record_nurse_witness_for_device_scan
    :parameters (?release_task - high_risk_release_task ?nurse_witness - nurse_witness)
    :precondition
      (and
        (nurse_witness_available ?nurse_witness)
        (not
          (witness_signature_recorded ?release_task)
        )
        (quality_document_attached ?release_task)
        (secondary_check_completed ?release_task)
        (not
          (device_scan_verified ?release_task)
        )
      )
    :effect
      (and
        (device_scan_verified ?release_task)
        (not
          (nurse_witness_available ?nurse_witness)
        )
      )
  )
  (:action unassign_primary_pharmacist_and_release
    :parameters (?release_task - high_risk_release_task ?primary_pharmacist - primary_pharmacist)
    :precondition
      (and
        (assigned_primary_pharmacist ?release_task ?primary_pharmacist)
        (not
          (secondary_check_completed ?release_task)
        )
        (not
          (clinical_verification_flag ?release_task)
        )
      )
    :effect
      (and
        (not
          (assigned_primary_pharmacist ?release_task ?primary_pharmacist)
        )
        (pharmacist_available ?primary_pharmacist)
        (not
          (pharmacist_reserved ?release_task)
        )
        (not
          (witness_confirmed ?release_task)
        )
        (not
          (ready_for_final_signoff ?release_task)
        )
        (not
          (quality_document_attached ?release_task)
        )
        (not
          (secondary_check_triggered ?release_task)
        )
        (not
          (witness_signature_recorded ?release_task)
        )
      )
  )
  (:action mark_device_scan_verified
    :parameters (?release_task - high_risk_release_task ?scanning_terminal - scanning_terminal)
    :precondition
      (and
        (not
          (device_scan_verified ?release_task)
        )
        (task_reserved_scanning_terminal ?release_task ?scanning_terminal)
        (quality_document_attached ?release_task)
        (secondary_check_completed ?release_task)
        (not
          (witness_signature_recorded ?release_task)
        )
      )
    :effect
      (and
        (device_scan_verified ?release_task)
      )
  )
  (:action final_signoff_with_authorization
    :parameters (?release_task - high_risk_release_task ?authorization_document - authorization_document)
    :precondition
      (and
        (device_scan_verified ?release_task)
        (secondary_check_completed ?release_task)
        (clinical_verification_flag ?release_task)
        (authorization_attached ?release_task ?authorization_document)
        (quality_document_attached ?release_task)
        (pharmacist_reserved ?release_task)
        (task_active ?release_task)
        (not
          (task_finalized ?release_task)
        )
        (variant_b_task ?release_task)
      )
    :effect
      (and
        (task_finalized ?release_task)
      )
  )
  (:action use_scanning_terminal_for_check
    :parameters (?release_task - high_risk_release_task ?scanning_terminal - scanning_terminal)
    :precondition
      (and
        (task_active ?release_task)
        (pharmacist_reserved ?release_task)
        (not
          (witness_confirmed ?release_task)
        )
        (task_reserved_scanning_terminal ?release_task ?scanning_terminal)
      )
    :effect
      (and
        (witness_confirmed ?release_task)
      )
  )
  (:action assign_primary_pharmacist_and_reserve
    :parameters (?release_task - high_risk_release_task ?primary_pharmacist - primary_pharmacist)
    :precondition
      (and
        (not
          (pharmacist_reserved ?release_task)
        )
        (task_active ?release_task)
        (pharmacist_available ?primary_pharmacist)
        (eligible_primary_pharmacist ?release_task ?primary_pharmacist)
      )
    :effect
      (and
        (pharmacist_reserved ?release_task)
        (not
          (pharmacist_available ?primary_pharmacist)
        )
        (assigned_primary_pharmacist ?release_task ?primary_pharmacist)
      )
  )
  (:action use_scanner_in_ready_state_attach_quality_doc
    :parameters (?release_task - high_risk_release_task ?scanning_terminal - scanning_terminal ?quality_document - quality_document)
    :precondition
      (and
        (pharmacist_reserved ?release_task)
        (not
          (quality_document_attached ?release_task)
        )
        (task_reserved_scanning_terminal ?release_task ?scanning_terminal)
        (secondary_check_completed ?release_task)
        (quality_document_available ?quality_document)
        (ready_for_final_signoff ?release_task)
      )
    :effect
      (and
        (quality_document_attached ?release_task)
      )
  )
  (:action variant_b_record_authorization
    :parameters (?release_task_variant_b - release_task_variant_b ?release_task_variant_a - release_task_variant_a ?authorization_document - authorization_document)
    :precondition
      (and
        (task_active ?release_task_variant_b)
        (task_authorization_link ?release_task_variant_a ?authorization_document)
        (variant_b_task ?release_task_variant_b)
        (not
          (authorization_attached ?release_task_variant_b ?authorization_document)
        )
        (task_requires_authorization_document ?release_task_variant_b ?authorization_document)
      )
    :effect
      (and
        (authorization_attached ?release_task_variant_b ?authorization_document)
      )
  )
)

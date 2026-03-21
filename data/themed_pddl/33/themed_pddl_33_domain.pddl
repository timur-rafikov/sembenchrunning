(define (domain sepsis_bundle_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types sepsis_encounter - object physician - object diagnostic_test - object supply - object medication_formulation - object device_resource - object bed - object nurse - object antibiotic_pack - object phlebotomy_station - object specimen_container - object culture_media - object clinical_support - object bedside_sepsis_nurse - clinical_support clinical_pharmacist - clinical_support adult_encounter - sepsis_encounter pediatric_encounter - sepsis_encounter)
  (:predicates
    (nurse_available ?nurse - nurse)
    (supply_reserved ?encounter - sepsis_encounter ?supply - supply)
    (bundle_administered ?encounter - sepsis_encounter)
    (assigned_physician ?encounter - sepsis_encounter ?provider - physician)
    (support_role_compatible_with_encounter ?encounter - sepsis_encounter ?clinical_support - clinical_support)
    (device_available ?device - device_resource)
    (supply_available ?supply - supply)
    (culture_media_compatible_with_encounter ?encounter - sepsis_encounter ?culture_media - culture_media)
    (bundle_completed ?encounter - sepsis_encounter)
    (adult_encounter_flag ?encounter - sepsis_encounter)
    (physician_compatible_with_encounter ?encounter - sepsis_encounter ?provider - physician)
    (test_available ?test_type - diagnostic_test)
    (container_available ?container - specimen_container)
    (bed_available ?bed - bed)
    (diagnostic_order_finalized ?encounter - sepsis_encounter)
    (supply_compatible_with_encounter ?encounter - sepsis_encounter ?supply - supply)
    (culture_media_reserved ?encounter - sepsis_encounter ?culture_media - culture_media)
    (test_ordered ?encounter - sepsis_encounter ?test_type - diagnostic_test)
    (bundle_ready_for_execution ?encounter - sepsis_encounter)
    (device_compatible_with_encounter ?encounter - sepsis_encounter ?device - device_resource)
    (culture_media_available ?culture_media - culture_media)
    (pediatric_encounter_flag ?encounter - sepsis_encounter)
    (specimen_collected ?encounter - sepsis_encounter)
    (medication_compatible_with_encounter ?encounter - sepsis_encounter ?medication - medication_formulation)
    (medication_reserved ?encounter - sepsis_encounter ?medication - medication_formulation)
    (specimen_verified ?encounter - sepsis_encounter)
    (bed_assigned ?encounter - sepsis_encounter ?bed - bed)
    (pharmacy_notified ?encounter - sepsis_encounter)
    (container_compatible_with_encounter ?encounter - sepsis_encounter ?container - specimen_container)
    (encounter_triggered ?encounter - sepsis_encounter)
    (physician_available ?provider - physician)
    (primary_assignment_confirmed ?encounter - sepsis_encounter)
    (phlebotomy_station_available ?station - phlebotomy_station)
    (antibiotic_pack_available ?antibiotic_pack - antibiotic_pack)
    (device_reserved ?encounter - sepsis_encounter ?device - device_resource)
    (antibiotic_reserved_for_encounter ?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    (nursing_assessment_completed ?encounter - sepsis_encounter)
    (administration_authorized ?encounter - sepsis_encounter)
    (pack_encounter_compatibility ?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    (medication_available ?medication - medication_formulation)
    (pack_compatible_with_encounter ?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    (test_compatible_with_encounter ?encounter - sepsis_encounter ?test_type - diagnostic_test)
    (sample_pending_collection ?encounter - sepsis_encounter)
    (pack_linked_to_encounter ?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
  )
  (:action release_culture_media
    :parameters (?encounter - sepsis_encounter ?culture_media - culture_media)
    :precondition
      (and
        (culture_media_reserved ?encounter ?culture_media)
      )
    :effect
      (and
        (culture_media_available ?culture_media)
        (not
          (culture_media_reserved ?encounter ?culture_media)
        )
      )
  )
  (:action perform_bundle_pharmacy_actions
    :parameters (?encounter - sepsis_encounter ?device - device_resource ?culture_media - culture_media ?clinical_pharmacist - clinical_pharmacist)
    :precondition
      (and
        (not
          (bundle_ready_for_execution ?encounter)
        )
        (diagnostic_order_finalized ?encounter)
        (specimen_collected ?encounter)
        (culture_media_reserved ?encounter ?culture_media)
        (support_role_compatible_with_encounter ?encounter ?clinical_pharmacist)
        (device_reserved ?encounter ?device)
      )
    :effect
      (and
        (sample_pending_collection ?encounter)
        (bundle_ready_for_execution ?encounter)
      )
  )
  (:action finalize_and_mark_bundle_completed
    :parameters (?encounter - sepsis_encounter)
    :precondition
      (and
        (specimen_collected ?encounter)
        (primary_assignment_confirmed ?encounter)
        (diagnostic_order_finalized ?encounter)
        (encounter_triggered ?encounter)
        (administration_authorized ?encounter)
        (not
          (bundle_completed ?encounter)
        )
        (adult_encounter_flag ?encounter)
        (bundle_ready_for_execution ?encounter)
      )
    :effect
      (and
        (bundle_completed ?encounter)
      )
  )
  (:action finalize_diagnostic_order
    :parameters (?encounter - sepsis_encounter ?medication - medication_formulation ?supply - supply)
    :precondition
      (and
        (diagnostic_order_finalized ?encounter)
        (specimen_verified ?encounter)
        (medication_reserved ?encounter ?medication)
        (supply_reserved ?encounter ?supply)
      )
    :effect
      (and
        (not
          (specimen_verified ?encounter)
        )
        (not
          (sample_pending_collection ?encounter)
        )
      )
  )
  (:action assign_bed
    :parameters (?encounter - sepsis_encounter ?bed - bed)
    :precondition
      (and
        (bed_available ?bed)
        (encounter_triggered ?encounter)
      )
    :effect
      (and
        (not
          (bed_available ?bed)
        )
        (bed_assigned ?encounter ?bed)
      )
  )
  (:action perform_bundle_nursing_actions
    :parameters (?encounter - sepsis_encounter ?medication - medication_formulation ?supply - supply ?bedside_sepsis_nurse - bedside_sepsis_nurse)
    :precondition
      (and
        (support_role_compatible_with_encounter ?encounter ?bedside_sepsis_nurse)
        (specimen_collected ?encounter)
        (not
          (sample_pending_collection ?encounter)
        )
        (medication_reserved ?encounter ?medication)
        (diagnostic_order_finalized ?encounter)
        (supply_reserved ?encounter ?supply)
        (not
          (bundle_ready_for_execution ?encounter)
        )
      )
    :effect
      (and
        (bundle_ready_for_execution ?encounter)
      )
  )
  (:action collect_specimen_with_pack
    :parameters (?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    :precondition
      (and
        (primary_assignment_confirmed ?encounter)
        (pack_linked_to_encounter ?encounter ?antibiotic_pack)
        (not
          (specimen_collected ?encounter)
        )
      )
    :effect
      (and
        (specimen_collected ?encounter)
        (not
          (sample_pending_collection ?encounter)
        )
      )
  )
  (:action reserve_device
    :parameters (?encounter - sepsis_encounter ?device - device_resource)
    :precondition
      (and
        (device_compatible_with_encounter ?encounter ?device)
        (encounter_triggered ?encounter)
        (device_available ?device)
      )
    :effect
      (and
        (device_reserved ?encounter ?device)
        (not
          (device_available ?device)
        )
      )
  )
  (:action reserve_medication
    :parameters (?encounter - sepsis_encounter ?medication - medication_formulation)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (medication_available ?medication)
        (medication_compatible_with_encounter ?encounter ?medication)
      )
    :effect
      (and
        (not
          (medication_available ?medication)
        )
        (medication_reserved ?encounter ?medication)
      )
  )
  (:action release_device
    :parameters (?encounter - sepsis_encounter ?device - device_resource)
    :precondition
      (and
        (device_reserved ?encounter ?device)
      )
    :effect
      (and
        (device_available ?device)
        (not
          (device_reserved ?encounter ?device)
        )
      )
  )
  (:action release_supply
    :parameters (?encounter - sepsis_encounter ?supply - supply)
    :precondition
      (and
        (supply_reserved ?encounter ?supply)
      )
    :effect
      (and
        (supply_available ?supply)
        (not
          (supply_reserved ?encounter ?supply)
        )
      )
  )
  (:action reserve_antibiotic_pack_for_encounter
    :parameters (?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    :precondition
      (and
        (administration_authorized ?encounter)
        (antibiotic_pack_available ?antibiotic_pack)
        (pack_encounter_compatibility ?encounter ?antibiotic_pack)
      )
    :effect
      (and
        (antibiotic_reserved_for_encounter ?encounter ?antibiotic_pack)
        (not
          (antibiotic_pack_available ?antibiotic_pack)
        )
      )
  )
  (:action reserve_supply
    :parameters (?encounter - sepsis_encounter ?supply - supply)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (supply_available ?supply)
        (supply_compatible_with_encounter ?encounter ?supply)
      )
    :effect
      (and
        (supply_reserved ?encounter ?supply)
        (not
          (supply_available ?supply)
        )
      )
  )
  (:action place_diagnostic_and_allocate_resources
    :parameters (?encounter - sepsis_encounter ?test_type - diagnostic_test ?medication - medication_formulation ?supply - supply)
    :precondition
      (and
        (primary_assignment_confirmed ?encounter)
        (test_available ?test_type)
        (test_compatible_with_encounter ?encounter ?test_type)
        (not
          (diagnostic_order_finalized ?encounter)
        )
        (supply_reserved ?encounter ?supply)
        (medication_reserved ?encounter ?medication)
      )
    :effect
      (and
        (test_ordered ?encounter ?test_type)
        (not
          (test_available ?test_type)
        )
        (diagnostic_order_finalized ?encounter)
      )
  )
  (:action confirm_bundle_component_administered
    :parameters (?encounter - sepsis_encounter ?medication - medication_formulation ?supply - supply)
    :precondition
      (and
        (medication_reserved ?encounter ?medication)
        (bundle_ready_for_execution ?encounter)
        (supply_reserved ?encounter ?supply)
        (sample_pending_collection ?encounter)
      )
    :effect
      (and
        (not
          (specimen_verified ?encounter)
        )
        (not
          (sample_pending_collection ?encounter)
        )
        (not
          (specimen_collected ?encounter)
        )
        (bundle_administered ?encounter)
      )
  )
  (:action release_bed
    :parameters (?encounter - sepsis_encounter ?bed - bed)
    :precondition
      (and
        (bed_assigned ?encounter ?bed)
      )
    :effect
      (and
        (bed_available ?bed)
        (not
          (bed_assigned ?encounter ?bed)
        )
      )
  )
  (:action phlebotomy_collect_specimen
    :parameters (?encounter - sepsis_encounter ?bed - bed ?station - phlebotomy_station)
    :precondition
      (and
        (not
          (specimen_collected ?encounter)
        )
        (primary_assignment_confirmed ?encounter)
        (phlebotomy_station_available ?station)
        (bed_assigned ?encounter ?bed)
        (nursing_assessment_completed ?encounter)
      )
    :effect
      (and
        (not
          (sample_pending_collection ?encounter)
        )
        (specimen_collected ?encounter)
      )
  )
  (:action pharmacy_finalize_and_mark_completed
    :parameters (?encounter - sepsis_encounter)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (pediatric_encounter_flag ?encounter)
        (pharmacy_notified ?encounter)
        (primary_assignment_confirmed ?encounter)
        (specimen_collected ?encounter)
        (not
          (bundle_completed ?encounter)
        )
        (administration_authorized ?encounter)
        (diagnostic_order_finalized ?encounter)
        (bundle_ready_for_execution ?encounter)
      )
    :effect
      (and
        (bundle_completed ?encounter)
      )
  )
  (:action send_pharmacy_notification
    :parameters (?encounter - sepsis_encounter ?bed - bed ?station - phlebotomy_station)
    :precondition
      (and
        (specimen_collected ?encounter)
        (phlebotomy_station_available ?station)
        (not
          (pharmacy_notified ?encounter)
        )
        (administration_authorized ?encounter)
        (encounter_triggered ?encounter)
        (pediatric_encounter_flag ?encounter)
        (bed_assigned ?encounter ?bed)
      )
    :effect
      (and
        (pharmacy_notified ?encounter)
      )
  )
  (:action release_medication
    :parameters (?encounter - sepsis_encounter ?medication - medication_formulation)
    :precondition
      (and
        (medication_reserved ?encounter ?medication)
      )
    :effect
      (and
        (medication_available ?medication)
        (not
          (medication_reserved ?encounter ?medication)
        )
      )
  )
  (:action reserve_culture_media
    :parameters (?encounter - sepsis_encounter ?culture_media - culture_media)
    :precondition
      (and
        (culture_media_available ?culture_media)
        (encounter_triggered ?encounter)
        (culture_media_compatible_with_encounter ?encounter ?culture_media)
      )
    :effect
      (and
        (culture_media_reserved ?encounter ?culture_media)
        (not
          (culture_media_available ?culture_media)
        )
      )
  )
  (:action activate_sepsis_encounter
    :parameters (?encounter - sepsis_encounter)
    :precondition
      (and
        (not
          (encounter_triggered ?encounter)
        )
        (not
          (bundle_completed ?encounter)
        )
      )
    :effect
      (and
        (encounter_triggered ?encounter)
      )
  )
  (:action nurse_initial_assessment
    :parameters (?encounter - sepsis_encounter ?nurse - nurse)
    :precondition
      (and
        (not
          (nursing_assessment_completed ?encounter)
        )
        (encounter_triggered ?encounter)
        (nurse_available ?nurse)
        (primary_assignment_confirmed ?encounter)
      )
    :effect
      (and
        (sample_pending_collection ?encounter)
        (not
          (nurse_available ?nurse)
        )
        (nursing_assessment_completed ?encounter)
      )
  )
  (:action place_diagnostic_with_device_and_container
    :parameters (?encounter - sepsis_encounter ?test_type - diagnostic_test ?device - device_resource ?container - specimen_container)
    :precondition
      (and
        (container_available ?container)
        (container_compatible_with_encounter ?encounter ?container)
        (not
          (diagnostic_order_finalized ?encounter)
        )
        (primary_assignment_confirmed ?encounter)
        (test_available ?test_type)
        (test_compatible_with_encounter ?encounter ?test_type)
        (device_reserved ?encounter ?device)
      )
    :effect
      (and
        (test_ordered ?encounter ?test_type)
        (not
          (container_available ?container)
        )
        (specimen_verified ?encounter)
        (not
          (test_available ?test_type)
        )
        (sample_pending_collection ?encounter)
        (diagnostic_order_finalized ?encounter)
      )
  )
  (:action authorize_administration_with_nurse
    :parameters (?encounter - sepsis_encounter ?nurse - nurse)
    :precondition
      (and
        (nurse_available ?nurse)
        (not
          (sample_pending_collection ?encounter)
        )
        (specimen_collected ?encounter)
        (bundle_ready_for_execution ?encounter)
        (not
          (administration_authorized ?encounter)
        )
      )
    :effect
      (and
        (administration_authorized ?encounter)
        (not
          (nurse_available ?nurse)
        )
      )
  )
  (:action unassign_primary_physician
    :parameters (?encounter - sepsis_encounter ?provider - physician)
    :precondition
      (and
        (assigned_physician ?encounter ?provider)
        (not
          (bundle_ready_for_execution ?encounter)
        )
        (not
          (diagnostic_order_finalized ?encounter)
        )
      )
    :effect
      (and
        (not
          (assigned_physician ?encounter ?provider)
        )
        (physician_available ?provider)
        (not
          (primary_assignment_confirmed ?encounter)
        )
        (not
          (nursing_assessment_completed ?encounter)
        )
        (not
          (bundle_administered ?encounter)
        )
        (not
          (specimen_collected ?encounter)
        )
        (not
          (specimen_verified ?encounter)
        )
        (not
          (sample_pending_collection ?encounter)
        )
      )
  )
  (:action authorize_administration_at_bed
    :parameters (?encounter - sepsis_encounter ?bed - bed)
    :precondition
      (and
        (not
          (administration_authorized ?encounter)
        )
        (bed_assigned ?encounter ?bed)
        (specimen_collected ?encounter)
        (bundle_ready_for_execution ?encounter)
        (not
          (sample_pending_collection ?encounter)
        )
      )
    :effect
      (and
        (administration_authorized ?encounter)
      )
  )
  (:action activate_antibiotic_and_finalize
    :parameters (?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    :precondition
      (and
        (administration_authorized ?encounter)
        (bundle_ready_for_execution ?encounter)
        (diagnostic_order_finalized ?encounter)
        (pack_linked_to_encounter ?encounter ?antibiotic_pack)
        (specimen_collected ?encounter)
        (primary_assignment_confirmed ?encounter)
        (encounter_triggered ?encounter)
        (not
          (bundle_completed ?encounter)
        )
        (pediatric_encounter_flag ?encounter)
      )
    :effect
      (and
        (bundle_completed ?encounter)
      )
  )
  (:action complete_bed_dependent_assessment
    :parameters (?encounter - sepsis_encounter ?bed - bed)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (primary_assignment_confirmed ?encounter)
        (not
          (nursing_assessment_completed ?encounter)
        )
        (bed_assigned ?encounter ?bed)
      )
    :effect
      (and
        (nursing_assessment_completed ?encounter)
      )
  )
  (:action assign_primary_physician
    :parameters (?encounter - sepsis_encounter ?provider - physician)
    :precondition
      (and
        (not
          (primary_assignment_confirmed ?encounter)
        )
        (encounter_triggered ?encounter)
        (physician_available ?provider)
        (physician_compatible_with_encounter ?encounter ?provider)
      )
    :effect
      (and
        (primary_assignment_confirmed ?encounter)
        (not
          (physician_available ?provider)
        )
        (assigned_physician ?encounter ?provider)
      )
  )
  (:action recollect_specimen_at_station
    :parameters (?encounter - sepsis_encounter ?bed - bed ?station - phlebotomy_station)
    :precondition
      (and
        (primary_assignment_confirmed ?encounter)
        (not
          (specimen_collected ?encounter)
        )
        (bed_assigned ?encounter ?bed)
        (bundle_ready_for_execution ?encounter)
        (phlebotomy_station_available ?station)
        (bundle_administered ?encounter)
      )
    :effect
      (and
        (specimen_collected ?encounter)
      )
  )
  (:action activate_cross_encounter_antibiotic_link
    :parameters (?pediatric_encounter - pediatric_encounter ?adult_encounter - adult_encounter ?antibiotic_pack - antibiotic_pack)
    :precondition
      (and
        (encounter_triggered ?pediatric_encounter)
        (antibiotic_reserved_for_encounter ?adult_encounter ?antibiotic_pack)
        (pediatric_encounter_flag ?pediatric_encounter)
        (not
          (pack_linked_to_encounter ?pediatric_encounter ?antibiotic_pack)
        )
        (pack_compatible_with_encounter ?pediatric_encounter ?antibiotic_pack)
      )
    :effect
      (and
        (pack_linked_to_encounter ?pediatric_encounter ?antibiotic_pack)
      )
  )
)

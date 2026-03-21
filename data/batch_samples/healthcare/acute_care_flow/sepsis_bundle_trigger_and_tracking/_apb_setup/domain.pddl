(define (domain sepsis_bundle_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types sepsis_encounter - object physician - object diagnostic_test - object supply - object medication_formulation - object device_resource - object bed - object nurse - object antibiotic_pack - object phlebotomy_station - object specimen_container - object culture_media - object clinical_support - object bedside_sepsis_nurse - clinical_support clinical_pharmacist - clinical_support adult_encounter - sepsis_encounter pediatric_encounter - sepsis_encounter)
  (:predicates
    (encounter_triggered ?encounter - sepsis_encounter)
    (assigned_physician ?encounter - sepsis_encounter ?provider - physician)
    (primary_assignment_confirmed ?encounter - sepsis_encounter)
    (nursing_assessment_completed ?encounter - sepsis_encounter)
    (specimen_collected ?encounter - sepsis_encounter)
    (medication_reserved ?encounter - sepsis_encounter ?medication - medication_formulation)
    (supply_reserved ?encounter - sepsis_encounter ?supply - supply)
    (device_reserved ?encounter - sepsis_encounter ?device - device_resource)
    (culture_media_reserved ?encounter - sepsis_encounter ?culture_media - culture_media)
    (test_ordered ?encounter - sepsis_encounter ?test_type - diagnostic_test)
    (diagnostic_order_finalized ?encounter - sepsis_encounter)
    (bundle_ready_for_execution ?encounter - sepsis_encounter)
    (administration_authorized ?encounter - sepsis_encounter)
    (bundle_completed ?encounter - sepsis_encounter)
    (sample_pending_collection ?encounter - sepsis_encounter)
    (bundle_administered ?encounter - sepsis_encounter)
    (pack_compatible_with_encounter ?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    (pack_linked_to_encounter ?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    (pharmacy_notified ?encounter - sepsis_encounter)
    (physician_available ?provider - physician)
    (test_available ?test_type - diagnostic_test)
    (medication_available ?medication - medication_formulation)
    (supply_available ?supply - supply)
    (device_available ?device - device_resource)
    (bed_available ?bed - bed)
    (nurse_available ?nurse - nurse)
    (antibiotic_pack_available ?antibiotic_pack - antibiotic_pack)
    (phlebotomy_station_available ?station - phlebotomy_station)
    (container_available ?container - specimen_container)
    (culture_media_available ?culture_media - culture_media)
    (physician_compatible_with_encounter ?encounter - sepsis_encounter ?provider - physician)
    (test_compatible_with_encounter ?encounter - sepsis_encounter ?test_type - diagnostic_test)
    (medication_compatible_with_encounter ?encounter - sepsis_encounter ?medication - medication_formulation)
    (supply_compatible_with_encounter ?encounter - sepsis_encounter ?supply - supply)
    (device_compatible_with_encounter ?encounter - sepsis_encounter ?device - device_resource)
    (container_compatible_with_encounter ?encounter - sepsis_encounter ?container - specimen_container)
    (culture_media_compatible_with_encounter ?encounter - sepsis_encounter ?culture_media - culture_media)
    (support_role_compatible_with_encounter ?encounter - sepsis_encounter ?clinical_support - clinical_support)
    (antibiotic_reserved_for_encounter ?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    (adult_encounter_flag ?encounter - sepsis_encounter)
    (pediatric_encounter_flag ?encounter - sepsis_encounter)
    (bed_assigned ?encounter - sepsis_encounter ?bed - bed)
    (specimen_verified ?encounter - sepsis_encounter)
    (pack_encounter_compatibility ?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
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
  (:action assign_primary_physician
    :parameters (?encounter - sepsis_encounter ?provider - physician)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (physician_available ?provider)
        (physician_compatible_with_encounter ?encounter ?provider)
        (not
          (primary_assignment_confirmed ?encounter)
        )
      )
    :effect
      (and
        (assigned_physician ?encounter ?provider)
        (primary_assignment_confirmed ?encounter)
        (not
          (physician_available ?provider)
        )
      )
  )
  (:action unassign_primary_physician
    :parameters (?encounter - sepsis_encounter ?provider - physician)
    :precondition
      (and
        (assigned_physician ?encounter ?provider)
        (not
          (diagnostic_order_finalized ?encounter)
        )
        (not
          (bundle_ready_for_execution ?encounter)
        )
      )
    :effect
      (and
        (not
          (assigned_physician ?encounter ?provider)
        )
        (not
          (primary_assignment_confirmed ?encounter)
        )
        (not
          (nursing_assessment_completed ?encounter)
        )
        (not
          (specimen_collected ?encounter)
        )
        (not
          (sample_pending_collection ?encounter)
        )
        (not
          (bundle_administered ?encounter)
        )
        (not
          (specimen_verified ?encounter)
        )
        (physician_available ?provider)
      )
  )
  (:action assign_bed
    :parameters (?encounter - sepsis_encounter ?bed - bed)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (bed_available ?bed)
      )
    :effect
      (and
        (bed_assigned ?encounter ?bed)
        (not
          (bed_available ?bed)
        )
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
  (:action complete_bed_dependent_assessment
    :parameters (?encounter - sepsis_encounter ?bed - bed)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (primary_assignment_confirmed ?encounter)
        (bed_assigned ?encounter ?bed)
        (not
          (nursing_assessment_completed ?encounter)
        )
      )
    :effect
      (and
        (nursing_assessment_completed ?encounter)
      )
  )
  (:action nurse_initial_assessment
    :parameters (?encounter - sepsis_encounter ?nurse - nurse)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (primary_assignment_confirmed ?encounter)
        (nurse_available ?nurse)
        (not
          (nursing_assessment_completed ?encounter)
        )
      )
    :effect
      (and
        (nursing_assessment_completed ?encounter)
        (sample_pending_collection ?encounter)
        (not
          (nurse_available ?nurse)
        )
      )
  )
  (:action phlebotomy_collect_specimen
    :parameters (?encounter - sepsis_encounter ?bed - bed ?station - phlebotomy_station)
    :precondition
      (and
        (nursing_assessment_completed ?encounter)
        (primary_assignment_confirmed ?encounter)
        (bed_assigned ?encounter ?bed)
        (phlebotomy_station_available ?station)
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
        (medication_reserved ?encounter ?medication)
        (not
          (medication_available ?medication)
        )
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
  (:action reserve_device
    :parameters (?encounter - sepsis_encounter ?device - device_resource)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (device_available ?device)
        (device_compatible_with_encounter ?encounter ?device)
      )
    :effect
      (and
        (device_reserved ?encounter ?device)
        (not
          (device_available ?device)
        )
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
  (:action reserve_culture_media
    :parameters (?encounter - sepsis_encounter ?culture_media - culture_media)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (culture_media_available ?culture_media)
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
  (:action place_diagnostic_and_allocate_resources
    :parameters (?encounter - sepsis_encounter ?test_type - diagnostic_test ?medication - medication_formulation ?supply - supply)
    :precondition
      (and
        (primary_assignment_confirmed ?encounter)
        (medication_reserved ?encounter ?medication)
        (supply_reserved ?encounter ?supply)
        (test_available ?test_type)
        (test_compatible_with_encounter ?encounter ?test_type)
        (not
          (diagnostic_order_finalized ?encounter)
        )
      )
    :effect
      (and
        (test_ordered ?encounter ?test_type)
        (diagnostic_order_finalized ?encounter)
        (not
          (test_available ?test_type)
        )
      )
  )
  (:action place_diagnostic_with_device_and_container
    :parameters (?encounter - sepsis_encounter ?test_type - diagnostic_test ?device - device_resource ?container - specimen_container)
    :precondition
      (and
        (primary_assignment_confirmed ?encounter)
        (device_reserved ?encounter ?device)
        (container_available ?container)
        (test_available ?test_type)
        (test_compatible_with_encounter ?encounter ?test_type)
        (container_compatible_with_encounter ?encounter ?container)
        (not
          (diagnostic_order_finalized ?encounter)
        )
      )
    :effect
      (and
        (test_ordered ?encounter ?test_type)
        (diagnostic_order_finalized ?encounter)
        (specimen_verified ?encounter)
        (sample_pending_collection ?encounter)
        (not
          (test_available ?test_type)
        )
        (not
          (container_available ?container)
        )
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
  (:action perform_bundle_nursing_actions
    :parameters (?encounter - sepsis_encounter ?medication - medication_formulation ?supply - supply ?bedside_sepsis_nurse - bedside_sepsis_nurse)
    :precondition
      (and
        (specimen_collected ?encounter)
        (diagnostic_order_finalized ?encounter)
        (medication_reserved ?encounter ?medication)
        (supply_reserved ?encounter ?supply)
        (support_role_compatible_with_encounter ?encounter ?bedside_sepsis_nurse)
        (not
          (sample_pending_collection ?encounter)
        )
        (not
          (bundle_ready_for_execution ?encounter)
        )
      )
    :effect
      (and
        (bundle_ready_for_execution ?encounter)
      )
  )
  (:action perform_bundle_pharmacy_actions
    :parameters (?encounter - sepsis_encounter ?device - device_resource ?culture_media - culture_media ?clinical_pharmacist - clinical_pharmacist)
    :precondition
      (and
        (specimen_collected ?encounter)
        (diagnostic_order_finalized ?encounter)
        (device_reserved ?encounter ?device)
        (culture_media_reserved ?encounter ?culture_media)
        (support_role_compatible_with_encounter ?encounter ?clinical_pharmacist)
        (not
          (bundle_ready_for_execution ?encounter)
        )
      )
    :effect
      (and
        (bundle_ready_for_execution ?encounter)
        (sample_pending_collection ?encounter)
      )
  )
  (:action confirm_bundle_component_administered
    :parameters (?encounter - sepsis_encounter ?medication - medication_formulation ?supply - supply)
    :precondition
      (and
        (bundle_ready_for_execution ?encounter)
        (sample_pending_collection ?encounter)
        (medication_reserved ?encounter ?medication)
        (supply_reserved ?encounter ?supply)
      )
    :effect
      (and
        (bundle_administered ?encounter)
        (not
          (sample_pending_collection ?encounter)
        )
        (not
          (specimen_collected ?encounter)
        )
        (not
          (specimen_verified ?encounter)
        )
      )
  )
  (:action recollect_specimen_at_station
    :parameters (?encounter - sepsis_encounter ?bed - bed ?station - phlebotomy_station)
    :precondition
      (and
        (bundle_administered ?encounter)
        (bundle_ready_for_execution ?encounter)
        (primary_assignment_confirmed ?encounter)
        (bed_assigned ?encounter ?bed)
        (phlebotomy_station_available ?station)
        (not
          (specimen_collected ?encounter)
        )
      )
    :effect
      (and
        (specimen_collected ?encounter)
      )
  )
  (:action authorize_administration_at_bed
    :parameters (?encounter - sepsis_encounter ?bed - bed)
    :precondition
      (and
        (bundle_ready_for_execution ?encounter)
        (specimen_collected ?encounter)
        (not
          (sample_pending_collection ?encounter)
        )
        (bed_assigned ?encounter ?bed)
        (not
          (administration_authorized ?encounter)
        )
      )
    :effect
      (and
        (administration_authorized ?encounter)
      )
  )
  (:action authorize_administration_with_nurse
    :parameters (?encounter - sepsis_encounter ?nurse - nurse)
    :precondition
      (and
        (bundle_ready_for_execution ?encounter)
        (specimen_collected ?encounter)
        (not
          (sample_pending_collection ?encounter)
        )
        (nurse_available ?nurse)
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
  (:action activate_cross_encounter_antibiotic_link
    :parameters (?pediatric_encounter - pediatric_encounter ?adult_encounter - adult_encounter ?antibiotic_pack - antibiotic_pack)
    :precondition
      (and
        (encounter_triggered ?pediatric_encounter)
        (pediatric_encounter_flag ?pediatric_encounter)
        (pack_compatible_with_encounter ?pediatric_encounter ?antibiotic_pack)
        (antibiotic_reserved_for_encounter ?adult_encounter ?antibiotic_pack)
        (not
          (pack_linked_to_encounter ?pediatric_encounter ?antibiotic_pack)
        )
      )
    :effect
      (and
        (pack_linked_to_encounter ?pediatric_encounter ?antibiotic_pack)
      )
  )
  (:action send_pharmacy_notification
    :parameters (?encounter - sepsis_encounter ?bed - bed ?station - phlebotomy_station)
    :precondition
      (and
        (encounter_triggered ?encounter)
        (pediatric_encounter_flag ?encounter)
        (specimen_collected ?encounter)
        (administration_authorized ?encounter)
        (bed_assigned ?encounter ?bed)
        (phlebotomy_station_available ?station)
        (not
          (pharmacy_notified ?encounter)
        )
      )
    :effect
      (and
        (pharmacy_notified ?encounter)
      )
  )
  (:action finalize_and_mark_bundle_completed
    :parameters (?encounter - sepsis_encounter)
    :precondition
      (and
        (adult_encounter_flag ?encounter)
        (encounter_triggered ?encounter)
        (primary_assignment_confirmed ?encounter)
        (diagnostic_order_finalized ?encounter)
        (bundle_ready_for_execution ?encounter)
        (administration_authorized ?encounter)
        (specimen_collected ?encounter)
        (not
          (bundle_completed ?encounter)
        )
      )
    :effect
      (and
        (bundle_completed ?encounter)
      )
  )
  (:action activate_antibiotic_and_finalize
    :parameters (?encounter - sepsis_encounter ?antibiotic_pack - antibiotic_pack)
    :precondition
      (and
        (pediatric_encounter_flag ?encounter)
        (encounter_triggered ?encounter)
        (primary_assignment_confirmed ?encounter)
        (diagnostic_order_finalized ?encounter)
        (bundle_ready_for_execution ?encounter)
        (administration_authorized ?encounter)
        (specimen_collected ?encounter)
        (pack_linked_to_encounter ?encounter ?antibiotic_pack)
        (not
          (bundle_completed ?encounter)
        )
      )
    :effect
      (and
        (bundle_completed ?encounter)
      )
  )
  (:action pharmacy_finalize_and_mark_completed
    :parameters (?encounter - sepsis_encounter)
    :precondition
      (and
        (pediatric_encounter_flag ?encounter)
        (encounter_triggered ?encounter)
        (primary_assignment_confirmed ?encounter)
        (diagnostic_order_finalized ?encounter)
        (bundle_ready_for_execution ?encounter)
        (administration_authorized ?encounter)
        (specimen_collected ?encounter)
        (pharmacy_notified ?encounter)
        (not
          (bundle_completed ?encounter)
        )
      )
    :effect
      (and
        (bundle_completed ?encounter)
      )
  )
)

(define (domain post_harvest_loss_minimization_rotation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types facility_resource - object material_or_asset - object condition_or_container - object lot_supertype - object harvest_lot - lot_supertype grading_station - facility_resource quality_inspector - facility_resource operator - facility_resource label_spec - facility_resource packing_configuration - facility_resource release_slot - facility_resource temperature_profile - facility_resource handling_protocol - facility_resource treatment_kit - material_or_asset packaging_material - material_or_asset certification - material_or_asset storage_condition - condition_or_container channel_condition - condition_or_container container - condition_or_container storage_subtype - harvest_lot outbound_subtype - harvest_lot storage_unit - storage_subtype outbound_batch - storage_subtype handling_unit - outbound_subtype)
  (:predicates
    (item_received ?harvest_lot - harvest_lot)
    (item_graded ?harvest_lot - harvest_lot)
    (item_assigned_for_grading ?harvest_lot - harvest_lot)
    (released_for_distribution ?harvest_lot - harvest_lot)
    (ready_for_release ?harvest_lot - harvest_lot)
    (item_release_scheduled ?harvest_lot - harvest_lot)
    (grading_station_available ?grading_station - grading_station)
    (item_assigned_to_grading_station ?harvest_lot - harvest_lot ?grading_station - grading_station)
    (inspector_available ?quality_inspector - quality_inspector)
    (inspector_assigned_to_item ?harvest_lot - harvest_lot ?quality_inspector - quality_inspector)
    (operator_available ?operator - operator)
    (operator_assigned_to_item ?harvest_lot - harvest_lot ?operator - operator)
    (treatment_kit_available ?treatment_kit - treatment_kit)
    (storage_unit_assigned_treatment ?storage_unit - storage_unit ?treatment_kit - treatment_kit)
    (outbound_batch_assigned_treatment ?outbound_batch - outbound_batch ?treatment_kit - treatment_kit)
    (storage_unit_has_condition ?storage_unit - storage_unit ?storage_condition - storage_condition)
    (storage_condition_engaged ?storage_condition - storage_condition)
    (storage_condition_reserved ?storage_condition - storage_condition)
    (storage_unit_condition_verified ?storage_unit - storage_unit)
    (outbound_batch_has_channel_condition ?outbound_batch - outbound_batch ?channel_condition - channel_condition)
    (channel_condition_engaged ?channel_condition - channel_condition)
    (channel_condition_reserved ?channel_condition - channel_condition)
    (outbound_batch_ready ?outbound_batch - outbound_batch)
    (container_available ?container - container)
    (container_prepared ?container - container)
    (container_has_storage_condition ?container - container ?storage_condition - storage_condition)
    (container_has_channel_condition ?container - container ?channel_condition - channel_condition)
    (container_has_flag_a ?container - container)
    (container_has_flag_b ?container - container)
    (container_sealed ?container - container)
    (handling_unit_linked_to_storage_unit ?handling_unit - handling_unit ?storage_unit - storage_unit)
    (handling_unit_linked_to_outbound_batch ?handling_unit - handling_unit ?outbound_batch - outbound_batch)
    (handling_unit_assigned_container ?handling_unit - handling_unit ?container - container)
    (packaging_material_available ?packaging_material - packaging_material)
    (handling_unit_has_packaging_material ?handling_unit - handling_unit ?packaging_material - packaging_material)
    (packaging_material_allocated ?packaging_material - packaging_material)
    (packaging_material_assigned_to_container ?packaging_material - packaging_material ?container - container)
    (handling_unit_packaging_initiated ?handling_unit - handling_unit)
    (handling_unit_packaged ?handling_unit - handling_unit)
    (handling_unit_qc_passed ?handling_unit - handling_unit)
    (labeling_initiated ?handling_unit - handling_unit)
    (label_applied ?handling_unit - handling_unit)
    (packing_configuration_required ?handling_unit - handling_unit)
    (handling_unit_processed_final ?handling_unit - handling_unit)
    (certification_available ?certification - certification)
    (handling_unit_assigned_certification ?handling_unit - handling_unit ?certification - certification)
    (handling_unit_certification_applied ?handling_unit - handling_unit)
    (handling_unit_certification_labeling_initiated ?handling_unit - handling_unit)
    (handling_unit_certification_processed ?handling_unit - handling_unit)
    (label_spec_available ?label_spec - label_spec)
    (handling_unit_assigned_label_spec ?handling_unit - handling_unit ?label_spec - label_spec)
    (packing_configuration_available ?packing_configuration - packing_configuration)
    (handling_unit_has_packing_configuration ?handling_unit - handling_unit ?packing_configuration - packing_configuration)
    (temperature_profile_available ?temperature_profile - temperature_profile)
    (handling_unit_assigned_temperature_profile ?handling_unit - handling_unit ?temperature_profile - temperature_profile)
    (handling_protocol_available ?handling_protocol - handling_protocol)
    (handling_unit_assigned_protocol ?handling_unit - handling_unit ?handling_protocol - handling_protocol)
    (release_slot_available ?release_slot - release_slot)
    (item_assigned_to_release_slot ?harvest_lot - harvest_lot ?release_slot - release_slot)
    (storage_unit_ready ?storage_unit - storage_unit)
    (outbound_batch_operator_assigned ?outbound_batch - outbound_batch)
    (handling_unit_finalized ?handling_unit - handling_unit)
  )
  (:action register_harvest_lot
    :parameters (?harvest_lot - harvest_lot)
    :precondition
      (and
        (not
          (item_received ?harvest_lot)
        )
        (not
          (released_for_distribution ?harvest_lot)
        )
      )
    :effect (item_received ?harvest_lot)
  )
  (:action assign_item_to_grading_station
    :parameters (?harvest_lot - harvest_lot ?grading_station - grading_station)
    :precondition
      (and
        (item_received ?harvest_lot)
        (not
          (item_assigned_for_grading ?harvest_lot)
        )
        (grading_station_available ?grading_station)
      )
    :effect
      (and
        (item_assigned_for_grading ?harvest_lot)
        (item_assigned_to_grading_station ?harvest_lot ?grading_station)
        (not
          (grading_station_available ?grading_station)
        )
      )
  )
  (:action assign_inspector_to_item
    :parameters (?harvest_lot - harvest_lot ?quality_inspector - quality_inspector)
    :precondition
      (and
        (item_received ?harvest_lot)
        (item_assigned_for_grading ?harvest_lot)
        (inspector_available ?quality_inspector)
      )
    :effect
      (and
        (inspector_assigned_to_item ?harvest_lot ?quality_inspector)
        (not
          (inspector_available ?quality_inspector)
        )
      )
  )
  (:action finalize_item_grading
    :parameters (?harvest_lot - harvest_lot ?quality_inspector - quality_inspector)
    :precondition
      (and
        (item_received ?harvest_lot)
        (item_assigned_for_grading ?harvest_lot)
        (inspector_assigned_to_item ?harvest_lot ?quality_inspector)
        (not
          (item_graded ?harvest_lot)
        )
      )
    :effect (item_graded ?harvest_lot)
  )
  (:action release_inspector
    :parameters (?harvest_lot - harvest_lot ?quality_inspector - quality_inspector)
    :precondition
      (and
        (inspector_assigned_to_item ?harvest_lot ?quality_inspector)
      )
    :effect
      (and
        (inspector_available ?quality_inspector)
        (not
          (inspector_assigned_to_item ?harvest_lot ?quality_inspector)
        )
      )
  )
  (:action assign_operator_for_conditioning
    :parameters (?harvest_lot - harvest_lot ?operator - operator)
    :precondition
      (and
        (item_graded ?harvest_lot)
        (operator_available ?operator)
      )
    :effect
      (and
        (operator_assigned_to_item ?harvest_lot ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action unassign_operator_from_item
    :parameters (?harvest_lot - harvest_lot ?operator - operator)
    :precondition
      (and
        (operator_assigned_to_item ?harvest_lot ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (operator_assigned_to_item ?harvest_lot ?operator)
        )
      )
  )
  (:action assign_temperature_profile_to_handling_unit
    :parameters (?handling_unit - handling_unit ?temperature_profile - temperature_profile)
    :precondition
      (and
        (item_graded ?handling_unit)
        (temperature_profile_available ?temperature_profile)
      )
    :effect
      (and
        (handling_unit_assigned_temperature_profile ?handling_unit ?temperature_profile)
        (not
          (temperature_profile_available ?temperature_profile)
        )
      )
  )
  (:action remove_temperature_profile_from_handling_unit
    :parameters (?handling_unit - handling_unit ?temperature_profile - temperature_profile)
    :precondition
      (and
        (handling_unit_assigned_temperature_profile ?handling_unit ?temperature_profile)
      )
    :effect
      (and
        (temperature_profile_available ?temperature_profile)
        (not
          (handling_unit_assigned_temperature_profile ?handling_unit ?temperature_profile)
        )
      )
  )
  (:action assign_handling_protocol_to_handling_unit
    :parameters (?handling_unit - handling_unit ?handling_protocol - handling_protocol)
    :precondition
      (and
        (item_graded ?handling_unit)
        (handling_protocol_available ?handling_protocol)
      )
    :effect
      (and
        (handling_unit_assigned_protocol ?handling_unit ?handling_protocol)
        (not
          (handling_protocol_available ?handling_protocol)
        )
      )
  )
  (:action remove_handling_protocol_from_handling_unit
    :parameters (?handling_unit - handling_unit ?handling_protocol - handling_protocol)
    :precondition
      (and
        (handling_unit_assigned_protocol ?handling_unit ?handling_protocol)
      )
    :effect
      (and
        (handling_protocol_available ?handling_protocol)
        (not
          (handling_unit_assigned_protocol ?handling_unit ?handling_protocol)
        )
      )
  )
  (:action activate_storage_condition
    :parameters (?storage_unit - storage_unit ?storage_condition - storage_condition ?quality_inspector - quality_inspector)
    :precondition
      (and
        (item_graded ?storage_unit)
        (inspector_assigned_to_item ?storage_unit ?quality_inspector)
        (storage_unit_has_condition ?storage_unit ?storage_condition)
        (not
          (storage_condition_engaged ?storage_condition)
        )
        (not
          (storage_condition_reserved ?storage_condition)
        )
      )
    :effect (storage_condition_engaged ?storage_condition)
  )
  (:action verify_storage_unit_condition_and_mark_ready
    :parameters (?storage_unit - storage_unit ?storage_condition - storage_condition ?operator - operator)
    :precondition
      (and
        (item_graded ?storage_unit)
        (operator_assigned_to_item ?storage_unit ?operator)
        (storage_unit_has_condition ?storage_unit ?storage_condition)
        (storage_condition_engaged ?storage_condition)
        (not
          (storage_unit_ready ?storage_unit)
        )
      )
    :effect
      (and
        (storage_unit_ready ?storage_unit)
        (storage_unit_condition_verified ?storage_unit)
      )
  )
  (:action apply_treatment_kit_to_storage_unit
    :parameters (?storage_unit - storage_unit ?storage_condition - storage_condition ?treatment_kit - treatment_kit)
    :precondition
      (and
        (item_graded ?storage_unit)
        (storage_unit_has_condition ?storage_unit ?storage_condition)
        (treatment_kit_available ?treatment_kit)
        (not
          (storage_unit_ready ?storage_unit)
        )
      )
    :effect
      (and
        (storage_condition_reserved ?storage_condition)
        (storage_unit_ready ?storage_unit)
        (storage_unit_assigned_treatment ?storage_unit ?treatment_kit)
        (not
          (treatment_kit_available ?treatment_kit)
        )
      )
  )
  (:action finalize_storage_unit_treatment
    :parameters (?storage_unit - storage_unit ?storage_condition - storage_condition ?quality_inspector - quality_inspector ?treatment_kit - treatment_kit)
    :precondition
      (and
        (item_graded ?storage_unit)
        (inspector_assigned_to_item ?storage_unit ?quality_inspector)
        (storage_unit_has_condition ?storage_unit ?storage_condition)
        (storage_condition_reserved ?storage_condition)
        (storage_unit_assigned_treatment ?storage_unit ?treatment_kit)
        (not
          (storage_unit_condition_verified ?storage_unit)
        )
      )
    :effect
      (and
        (storage_condition_engaged ?storage_condition)
        (storage_unit_condition_verified ?storage_unit)
        (treatment_kit_available ?treatment_kit)
        (not
          (storage_unit_assigned_treatment ?storage_unit ?treatment_kit)
        )
      )
  )
  (:action activate_channel_condition
    :parameters (?outbound_batch - outbound_batch ?channel_condition - channel_condition ?quality_inspector - quality_inspector)
    :precondition
      (and
        (item_graded ?outbound_batch)
        (inspector_assigned_to_item ?outbound_batch ?quality_inspector)
        (outbound_batch_has_channel_condition ?outbound_batch ?channel_condition)
        (not
          (channel_condition_engaged ?channel_condition)
        )
        (not
          (channel_condition_reserved ?channel_condition)
        )
      )
    :effect (channel_condition_engaged ?channel_condition)
  )
  (:action assign_operator_for_outbound_batch
    :parameters (?outbound_batch - outbound_batch ?channel_condition - channel_condition ?operator - operator)
    :precondition
      (and
        (item_graded ?outbound_batch)
        (operator_assigned_to_item ?outbound_batch ?operator)
        (outbound_batch_has_channel_condition ?outbound_batch ?channel_condition)
        (channel_condition_engaged ?channel_condition)
        (not
          (outbound_batch_operator_assigned ?outbound_batch)
        )
      )
    :effect
      (and
        (outbound_batch_operator_assigned ?outbound_batch)
        (outbound_batch_ready ?outbound_batch)
      )
  )
  (:action apply_treatment_kit_to_outbound_batch
    :parameters (?outbound_batch - outbound_batch ?channel_condition - channel_condition ?treatment_kit - treatment_kit)
    :precondition
      (and
        (item_graded ?outbound_batch)
        (outbound_batch_has_channel_condition ?outbound_batch ?channel_condition)
        (treatment_kit_available ?treatment_kit)
        (not
          (outbound_batch_operator_assigned ?outbound_batch)
        )
      )
    :effect
      (and
        (channel_condition_reserved ?channel_condition)
        (outbound_batch_operator_assigned ?outbound_batch)
        (outbound_batch_assigned_treatment ?outbound_batch ?treatment_kit)
        (not
          (treatment_kit_available ?treatment_kit)
        )
      )
  )
  (:action finalize_outbound_batch_treatment
    :parameters (?outbound_batch - outbound_batch ?channel_condition - channel_condition ?quality_inspector - quality_inspector ?treatment_kit - treatment_kit)
    :precondition
      (and
        (item_graded ?outbound_batch)
        (inspector_assigned_to_item ?outbound_batch ?quality_inspector)
        (outbound_batch_has_channel_condition ?outbound_batch ?channel_condition)
        (channel_condition_reserved ?channel_condition)
        (outbound_batch_assigned_treatment ?outbound_batch ?treatment_kit)
        (not
          (outbound_batch_ready ?outbound_batch)
        )
      )
    :effect
      (and
        (channel_condition_engaged ?channel_condition)
        (outbound_batch_ready ?outbound_batch)
        (treatment_kit_available ?treatment_kit)
        (not
          (outbound_batch_assigned_treatment ?outbound_batch ?treatment_kit)
        )
      )
  )
  (:action assemble_and_configure_container
    :parameters (?storage_unit - storage_unit ?outbound_batch - outbound_batch ?storage_condition - storage_condition ?channel_condition - channel_condition ?container - container)
    :precondition
      (and
        (storage_unit_ready ?storage_unit)
        (outbound_batch_operator_assigned ?outbound_batch)
        (storage_unit_has_condition ?storage_unit ?storage_condition)
        (outbound_batch_has_channel_condition ?outbound_batch ?channel_condition)
        (storage_condition_engaged ?storage_condition)
        (channel_condition_engaged ?channel_condition)
        (storage_unit_condition_verified ?storage_unit)
        (outbound_batch_ready ?outbound_batch)
        (container_available ?container)
      )
    :effect
      (and
        (container_prepared ?container)
        (container_has_storage_condition ?container ?storage_condition)
        (container_has_channel_condition ?container ?channel_condition)
        (not
          (container_available ?container)
        )
      )
  )
  (:action assemble_and_configure_container_with_reserved_condition
    :parameters (?storage_unit - storage_unit ?outbound_batch - outbound_batch ?storage_condition - storage_condition ?channel_condition - channel_condition ?container - container)
    :precondition
      (and
        (storage_unit_ready ?storage_unit)
        (outbound_batch_operator_assigned ?outbound_batch)
        (storage_unit_has_condition ?storage_unit ?storage_condition)
        (outbound_batch_has_channel_condition ?outbound_batch ?channel_condition)
        (storage_condition_reserved ?storage_condition)
        (channel_condition_engaged ?channel_condition)
        (not
          (storage_unit_condition_verified ?storage_unit)
        )
        (outbound_batch_ready ?outbound_batch)
        (container_available ?container)
      )
    :effect
      (and
        (container_prepared ?container)
        (container_has_storage_condition ?container ?storage_condition)
        (container_has_channel_condition ?container ?channel_condition)
        (container_has_flag_a ?container)
        (not
          (container_available ?container)
        )
      )
  )
  (:action assemble_and_configure_container_with_secondary_condition
    :parameters (?storage_unit - storage_unit ?outbound_batch - outbound_batch ?storage_condition - storage_condition ?channel_condition - channel_condition ?container - container)
    :precondition
      (and
        (storage_unit_ready ?storage_unit)
        (outbound_batch_operator_assigned ?outbound_batch)
        (storage_unit_has_condition ?storage_unit ?storage_condition)
        (outbound_batch_has_channel_condition ?outbound_batch ?channel_condition)
        (storage_condition_engaged ?storage_condition)
        (channel_condition_reserved ?channel_condition)
        (storage_unit_condition_verified ?storage_unit)
        (not
          (outbound_batch_ready ?outbound_batch)
        )
        (container_available ?container)
      )
    :effect
      (and
        (container_prepared ?container)
        (container_has_storage_condition ?container ?storage_condition)
        (container_has_channel_condition ?container ?channel_condition)
        (container_has_flag_b ?container)
        (not
          (container_available ?container)
        )
      )
  )
  (:action assemble_and_configure_container_with_dual_condition_flags
    :parameters (?storage_unit - storage_unit ?outbound_batch - outbound_batch ?storage_condition - storage_condition ?channel_condition - channel_condition ?container - container)
    :precondition
      (and
        (storage_unit_ready ?storage_unit)
        (outbound_batch_operator_assigned ?outbound_batch)
        (storage_unit_has_condition ?storage_unit ?storage_condition)
        (outbound_batch_has_channel_condition ?outbound_batch ?channel_condition)
        (storage_condition_reserved ?storage_condition)
        (channel_condition_reserved ?channel_condition)
        (not
          (storage_unit_condition_verified ?storage_unit)
        )
        (not
          (outbound_batch_ready ?outbound_batch)
        )
        (container_available ?container)
      )
    :effect
      (and
        (container_prepared ?container)
        (container_has_storage_condition ?container ?storage_condition)
        (container_has_channel_condition ?container ?channel_condition)
        (container_has_flag_a ?container)
        (container_has_flag_b ?container)
        (not
          (container_available ?container)
        )
      )
  )
  (:action seal_container_for_dispatch
    :parameters (?container - container ?storage_unit - storage_unit ?quality_inspector - quality_inspector)
    :precondition
      (and
        (container_prepared ?container)
        (storage_unit_ready ?storage_unit)
        (inspector_assigned_to_item ?storage_unit ?quality_inspector)
        (not
          (container_sealed ?container)
        )
      )
    :effect (container_sealed ?container)
  )
  (:action reserve_packaging_material_for_container
    :parameters (?handling_unit - handling_unit ?packaging_material - packaging_material ?container - container)
    :precondition
      (and
        (item_graded ?handling_unit)
        (handling_unit_assigned_container ?handling_unit ?container)
        (handling_unit_has_packaging_material ?handling_unit ?packaging_material)
        (packaging_material_available ?packaging_material)
        (container_prepared ?container)
        (container_sealed ?container)
        (not
          (packaging_material_allocated ?packaging_material)
        )
      )
    :effect
      (and
        (packaging_material_allocated ?packaging_material)
        (packaging_material_assigned_to_container ?packaging_material ?container)
        (not
          (packaging_material_available ?packaging_material)
        )
      )
  )
  (:action initiate_handling_unit_packaging
    :parameters (?handling_unit - handling_unit ?packaging_material - packaging_material ?container - container ?quality_inspector - quality_inspector)
    :precondition
      (and
        (item_graded ?handling_unit)
        (handling_unit_has_packaging_material ?handling_unit ?packaging_material)
        (packaging_material_allocated ?packaging_material)
        (packaging_material_assigned_to_container ?packaging_material ?container)
        (inspector_assigned_to_item ?handling_unit ?quality_inspector)
        (not
          (container_has_flag_a ?container)
        )
        (not
          (handling_unit_packaging_initiated ?handling_unit)
        )
      )
    :effect (handling_unit_packaging_initiated ?handling_unit)
  )
  (:action assign_label_spec_to_handling_unit
    :parameters (?handling_unit - handling_unit ?label_spec - label_spec)
    :precondition
      (and
        (item_graded ?handling_unit)
        (label_spec_available ?label_spec)
        (not
          (labeling_initiated ?handling_unit)
        )
      )
    :effect
      (and
        (labeling_initiated ?handling_unit)
        (handling_unit_assigned_label_spec ?handling_unit ?label_spec)
        (not
          (label_spec_available ?label_spec)
        )
      )
  )
  (:action apply_label_and_initiate_packaging
    :parameters (?handling_unit - handling_unit ?packaging_material - packaging_material ?container - container ?quality_inspector - quality_inspector ?label_spec - label_spec)
    :precondition
      (and
        (item_graded ?handling_unit)
        (handling_unit_has_packaging_material ?handling_unit ?packaging_material)
        (packaging_material_allocated ?packaging_material)
        (packaging_material_assigned_to_container ?packaging_material ?container)
        (inspector_assigned_to_item ?handling_unit ?quality_inspector)
        (container_has_flag_a ?container)
        (labeling_initiated ?handling_unit)
        (handling_unit_assigned_label_spec ?handling_unit ?label_spec)
        (not
          (handling_unit_packaging_initiated ?handling_unit)
        )
      )
    :effect
      (and
        (handling_unit_packaging_initiated ?handling_unit)
        (label_applied ?handling_unit)
      )
  )
  (:action complete_packaging_with_temperature_profile
    :parameters (?handling_unit - handling_unit ?temperature_profile - temperature_profile ?operator - operator ?packaging_material - packaging_material ?container - container)
    :precondition
      (and
        (handling_unit_packaging_initiated ?handling_unit)
        (handling_unit_assigned_temperature_profile ?handling_unit ?temperature_profile)
        (operator_assigned_to_item ?handling_unit ?operator)
        (handling_unit_has_packaging_material ?handling_unit ?packaging_material)
        (packaging_material_assigned_to_container ?packaging_material ?container)
        (not
          (container_has_flag_b ?container)
        )
        (not
          (handling_unit_packaged ?handling_unit)
        )
      )
    :effect (handling_unit_packaged ?handling_unit)
  )
  (:action complete_packaging_with_temperature_profile_alternate
    :parameters (?handling_unit - handling_unit ?temperature_profile - temperature_profile ?operator - operator ?packaging_material - packaging_material ?container - container)
    :precondition
      (and
        (handling_unit_packaging_initiated ?handling_unit)
        (handling_unit_assigned_temperature_profile ?handling_unit ?temperature_profile)
        (operator_assigned_to_item ?handling_unit ?operator)
        (handling_unit_has_packaging_material ?handling_unit ?packaging_material)
        (packaging_material_assigned_to_container ?packaging_material ?container)
        (container_has_flag_b ?container)
        (not
          (handling_unit_packaged ?handling_unit)
        )
      )
    :effect (handling_unit_packaged ?handling_unit)
  )
  (:action perform_quality_control_checks
    :parameters (?handling_unit - handling_unit ?handling_protocol - handling_protocol ?packaging_material - packaging_material ?container - container)
    :precondition
      (and
        (handling_unit_packaged ?handling_unit)
        (handling_unit_assigned_protocol ?handling_unit ?handling_protocol)
        (handling_unit_has_packaging_material ?handling_unit ?packaging_material)
        (packaging_material_assigned_to_container ?packaging_material ?container)
        (not
          (container_has_flag_a ?container)
        )
        (not
          (container_has_flag_b ?container)
        )
        (not
          (handling_unit_qc_passed ?handling_unit)
        )
      )
    :effect (handling_unit_qc_passed ?handling_unit)
  )
  (:action perform_quality_control_and_require_packing_configuration
    :parameters (?handling_unit - handling_unit ?handling_protocol - handling_protocol ?packaging_material - packaging_material ?container - container)
    :precondition
      (and
        (handling_unit_packaged ?handling_unit)
        (handling_unit_assigned_protocol ?handling_unit ?handling_protocol)
        (handling_unit_has_packaging_material ?handling_unit ?packaging_material)
        (packaging_material_assigned_to_container ?packaging_material ?container)
        (container_has_flag_a ?container)
        (not
          (container_has_flag_b ?container)
        )
        (not
          (handling_unit_qc_passed ?handling_unit)
        )
      )
    :effect
      (and
        (handling_unit_qc_passed ?handling_unit)
        (packing_configuration_required ?handling_unit)
      )
  )
  (:action perform_quality_control_and_require_packing_configuration_variant
    :parameters (?handling_unit - handling_unit ?handling_protocol - handling_protocol ?packaging_material - packaging_material ?container - container)
    :precondition
      (and
        (handling_unit_packaged ?handling_unit)
        (handling_unit_assigned_protocol ?handling_unit ?handling_protocol)
        (handling_unit_has_packaging_material ?handling_unit ?packaging_material)
        (packaging_material_assigned_to_container ?packaging_material ?container)
        (not
          (container_has_flag_a ?container)
        )
        (container_has_flag_b ?container)
        (not
          (handling_unit_qc_passed ?handling_unit)
        )
      )
    :effect
      (and
        (handling_unit_qc_passed ?handling_unit)
        (packing_configuration_required ?handling_unit)
      )
  )
  (:action perform_quality_control_with_packing_configuration
    :parameters (?handling_unit - handling_unit ?handling_protocol - handling_protocol ?packaging_material - packaging_material ?container - container)
    :precondition
      (and
        (handling_unit_packaged ?handling_unit)
        (handling_unit_assigned_protocol ?handling_unit ?handling_protocol)
        (handling_unit_has_packaging_material ?handling_unit ?packaging_material)
        (packaging_material_assigned_to_container ?packaging_material ?container)
        (container_has_flag_a ?container)
        (container_has_flag_b ?container)
        (not
          (handling_unit_qc_passed ?handling_unit)
        )
      )
    :effect
      (and
        (handling_unit_qc_passed ?handling_unit)
        (packing_configuration_required ?handling_unit)
      )
  )
  (:action finalize_handling_unit_processing_and_mark_ready
    :parameters (?handling_unit - handling_unit)
    :precondition
      (and
        (handling_unit_qc_passed ?handling_unit)
        (not
          (packing_configuration_required ?handling_unit)
        )
        (not
          (handling_unit_finalized ?handling_unit)
        )
      )
    :effect
      (and
        (handling_unit_finalized ?handling_unit)
        (ready_for_release ?handling_unit)
      )
  )
  (:action assign_packing_configuration_to_handling_unit
    :parameters (?handling_unit - handling_unit ?packing_configuration - packing_configuration)
    :precondition
      (and
        (handling_unit_qc_passed ?handling_unit)
        (packing_configuration_required ?handling_unit)
        (packing_configuration_available ?packing_configuration)
      )
    :effect
      (and
        (handling_unit_has_packing_configuration ?handling_unit ?packing_configuration)
        (not
          (packing_configuration_available ?packing_configuration)
        )
      )
  )
  (:action pack_handling_unit_and_mark_processed
    :parameters (?handling_unit - handling_unit ?storage_unit - storage_unit ?outbound_batch - outbound_batch ?quality_inspector - quality_inspector ?packing_configuration - packing_configuration)
    :precondition
      (and
        (handling_unit_qc_passed ?handling_unit)
        (packing_configuration_required ?handling_unit)
        (handling_unit_has_packing_configuration ?handling_unit ?packing_configuration)
        (handling_unit_linked_to_storage_unit ?handling_unit ?storage_unit)
        (handling_unit_linked_to_outbound_batch ?handling_unit ?outbound_batch)
        (storage_unit_condition_verified ?storage_unit)
        (outbound_batch_ready ?outbound_batch)
        (inspector_assigned_to_item ?handling_unit ?quality_inspector)
        (not
          (handling_unit_processed_final ?handling_unit)
        )
      )
    :effect (handling_unit_processed_final ?handling_unit)
  )
  (:action finalize_handling_unit_processing_alternate
    :parameters (?handling_unit - handling_unit)
    :precondition
      (and
        (handling_unit_qc_passed ?handling_unit)
        (handling_unit_processed_final ?handling_unit)
        (not
          (handling_unit_finalized ?handling_unit)
        )
      )
    :effect
      (and
        (handling_unit_finalized ?handling_unit)
        (ready_for_release ?handling_unit)
      )
  )
  (:action apply_certification_to_handling_unit
    :parameters (?handling_unit - handling_unit ?certification - certification ?quality_inspector - quality_inspector)
    :precondition
      (and
        (item_graded ?handling_unit)
        (inspector_assigned_to_item ?handling_unit ?quality_inspector)
        (certification_available ?certification)
        (handling_unit_assigned_certification ?handling_unit ?certification)
        (not
          (handling_unit_certification_applied ?handling_unit)
        )
      )
    :effect
      (and
        (handling_unit_certification_applied ?handling_unit)
        (not
          (certification_available ?certification)
        )
      )
  )
  (:action initiate_certification_labeling
    :parameters (?handling_unit - handling_unit ?operator - operator)
    :precondition
      (and
        (handling_unit_certification_applied ?handling_unit)
        (operator_assigned_to_item ?handling_unit ?operator)
        (not
          (handling_unit_certification_labeling_initiated ?handling_unit)
        )
      )
    :effect (handling_unit_certification_labeling_initiated ?handling_unit)
  )
  (:action finalize_certification_for_handling_unit
    :parameters (?handling_unit - handling_unit ?handling_protocol - handling_protocol)
    :precondition
      (and
        (handling_unit_certification_labeling_initiated ?handling_unit)
        (handling_unit_assigned_protocol ?handling_unit ?handling_protocol)
        (not
          (handling_unit_certification_processed ?handling_unit)
        )
      )
    :effect (handling_unit_certification_processed ?handling_unit)
  )
  (:action finalize_certification_and_mark_ready
    :parameters (?handling_unit - handling_unit)
    :precondition
      (and
        (handling_unit_certification_processed ?handling_unit)
        (not
          (handling_unit_finalized ?handling_unit)
        )
      )
    :effect
      (and
        (handling_unit_finalized ?handling_unit)
        (ready_for_release ?handling_unit)
      )
  )
  (:action release_storage_unit_for_dispatch
    :parameters (?storage_unit - storage_unit ?container - container)
    :precondition
      (and
        (storage_unit_ready ?storage_unit)
        (storage_unit_condition_verified ?storage_unit)
        (container_prepared ?container)
        (container_sealed ?container)
        (not
          (ready_for_release ?storage_unit)
        )
      )
    :effect (ready_for_release ?storage_unit)
  )
  (:action release_outbound_batch_for_dispatch
    :parameters (?outbound_batch - outbound_batch ?container - container)
    :precondition
      (and
        (outbound_batch_operator_assigned ?outbound_batch)
        (outbound_batch_ready ?outbound_batch)
        (container_prepared ?container)
        (container_sealed ?container)
        (not
          (ready_for_release ?outbound_batch)
        )
      )
    :effect (ready_for_release ?outbound_batch)
  )
  (:action schedule_item_release_slot
    :parameters (?harvest_lot - harvest_lot ?release_slot - release_slot ?quality_inspector - quality_inspector)
    :precondition
      (and
        (ready_for_release ?harvest_lot)
        (inspector_assigned_to_item ?harvest_lot ?quality_inspector)
        (release_slot_available ?release_slot)
        (not
          (item_release_scheduled ?harvest_lot)
        )
      )
    :effect
      (and
        (item_release_scheduled ?harvest_lot)
        (item_assigned_to_release_slot ?harvest_lot ?release_slot)
        (not
          (release_slot_available ?release_slot)
        )
      )
  )
  (:action finalize_storage_unit_dispatch
    :parameters (?storage_unit - storage_unit ?grading_station - grading_station ?release_slot - release_slot)
    :precondition
      (and
        (item_release_scheduled ?storage_unit)
        (item_assigned_to_grading_station ?storage_unit ?grading_station)
        (item_assigned_to_release_slot ?storage_unit ?release_slot)
        (not
          (released_for_distribution ?storage_unit)
        )
      )
    :effect
      (and
        (released_for_distribution ?storage_unit)
        (grading_station_available ?grading_station)
        (release_slot_available ?release_slot)
      )
  )
  (:action finalize_outbound_batch_dispatch
    :parameters (?outbound_batch - outbound_batch ?grading_station - grading_station ?release_slot - release_slot)
    :precondition
      (and
        (item_release_scheduled ?outbound_batch)
        (item_assigned_to_grading_station ?outbound_batch ?grading_station)
        (item_assigned_to_release_slot ?outbound_batch ?release_slot)
        (not
          (released_for_distribution ?outbound_batch)
        )
      )
    :effect
      (and
        (released_for_distribution ?outbound_batch)
        (grading_station_available ?grading_station)
        (release_slot_available ?release_slot)
      )
  )
  (:action finalize_handling_unit_dispatch
    :parameters (?handling_unit - handling_unit ?grading_station - grading_station ?release_slot - release_slot)
    :precondition
      (and
        (item_release_scheduled ?handling_unit)
        (item_assigned_to_grading_station ?handling_unit ?grading_station)
        (item_assigned_to_release_slot ?handling_unit ?release_slot)
        (not
          (released_for_distribution ?handling_unit)
        )
      )
    :effect
      (and
        (released_for_distribution ?handling_unit)
        (grading_station_available ?grading_station)
        (release_slot_available ?release_slot)
      )
  )
)

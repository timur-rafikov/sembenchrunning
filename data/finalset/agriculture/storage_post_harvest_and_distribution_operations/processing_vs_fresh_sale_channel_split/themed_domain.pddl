(define (domain post_harvest_processing_vs_fresh_sale)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object resource - domain_object material_resource - domain_object option_group - domain_object produce_asset_class - domain_object produce_asset - produce_asset_class grader_station - resource sampling_kit - resource conditioning_station - resource retail_label_spec - resource transport_asset - resource release_document - resource processing_parameter - resource inspection_rule - resource treatment_material - material_resource packaging_batch - material_resource certification_record - material_resource processing_option - option_group fresh_sale_option - option_group outbound_handling_unit - option_group palletable_form - produce_asset operational_super - produce_asset processing_pallet - palletable_form fresh_sale_pallet - palletable_form operational_unit - operational_super)

  (:predicates
    (intake_registered ?produce_lot - produce_asset)
    (grade_recorded_for_unit ?produce_lot - produce_asset)
    (assignment_recorded_for_unit ?produce_lot - produce_asset)
    (authorized_for_dispatch ?produce_lot - produce_asset)
    (ready_for_dispatch ?produce_lot - produce_asset)
    (release_authorized_for_unit ?produce_lot - produce_asset)
    (grader_available ?grader_station - grader_station)
    (unit_assigned_to_grader_station ?produce_lot - produce_asset ?grader_station - grader_station)
    (sampling_kit_available ?sampling_kit - sampling_kit)
    (unit_sample_assigned ?produce_lot - produce_asset ?sampling_kit - sampling_kit)
    (conditioning_station_available ?conditioning_station - conditioning_station)
    (unit_assigned_to_conditioning_station ?produce_lot - produce_asset ?conditioning_station - conditioning_station)
    (treatment_material_available ?treatment_material - treatment_material)
    (processing_pallet_assigned_treatment_material ?processing_pallet - processing_pallet ?treatment_material - treatment_material)
    (fresh_sale_pallet_assigned_treatment_material ?fresh_sale_pallet - fresh_sale_pallet ?treatment_material - treatment_material)
    (processing_pallet_assigned_processing_option ?processing_pallet - processing_pallet ?processing_option - processing_option)
    (processing_option_reserved ?processing_option - processing_option)
    (processing_option_pending_treatment ?processing_option - processing_option)
    (processing_pallet_condition_confirmed ?processing_pallet - processing_pallet)
    (fresh_sale_pallet_assigned_fresh_sale_option ?fresh_sale_pallet - fresh_sale_pallet ?fresh_sale_option - fresh_sale_option)
    (fresh_sale_option_reserved ?fresh_sale_option - fresh_sale_option)
    (fresh_sale_option_pending_treatment ?fresh_sale_option - fresh_sale_option)
    (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet - fresh_sale_pallet)
    (outbound_unit_available ?outbound_unit - outbound_handling_unit)
    (outbound_unit_reserved ?outbound_unit - outbound_handling_unit)
    (outbound_unit_assigned_processing_option ?outbound_unit - outbound_handling_unit ?processing_option - processing_option)
    (outbound_unit_assigned_fresh_sale_option ?outbound_unit - outbound_handling_unit ?fresh_sale_option - fresh_sale_option)
    (outbound_unit_includes_processing_pallets ?outbound_unit - outbound_handling_unit)
    (outbound_unit_includes_fresh_sale_pallets ?outbound_unit - outbound_handling_unit)
    (outbound_unit_packing_ready ?outbound_unit - outbound_handling_unit)
    (operational_unit_manages_processing_pallet ?operational_unit - operational_unit ?processing_pallet - processing_pallet)
    (operational_unit_manages_fresh_sale_pallet ?operational_unit - operational_unit ?fresh_sale_pallet - fresh_sale_pallet)
    (operational_unit_manages_outbound_unit ?operational_unit - operational_unit ?outbound_unit - outbound_handling_unit)
    (packaging_batch_available ?packaging_batch - packaging_batch)
    (operational_unit_assigned_packaging_batch ?operational_unit - operational_unit ?packaging_batch - packaging_batch)
    (packaging_batch_prepared ?packaging_batch - packaging_batch)
    (packaging_batch_assigned_to_outbound_unit ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit)
    (operational_unit_packing_authorized ?operational_unit - operational_unit)
    (operational_unit_packaging_initiated ?operational_unit - operational_unit)
    (operational_unit_inspected ?operational_unit - operational_unit)
    (operational_unit_retail_label_applied ?operational_unit - operational_unit)
    (operational_unit_label_verified ?operational_unit - operational_unit)
    (operational_unit_packaging_confirmed ?operational_unit - operational_unit)
    (operational_unit_quality_confirmed ?operational_unit - operational_unit)
    (certification_record_available ?certification_record - certification_record)
    (operational_unit_assigned_certification ?operational_unit - operational_unit ?certification_record - certification_record)
    (operational_unit_certification_applied ?operational_unit - operational_unit)
    (operational_unit_certification_ready ?operational_unit - operational_unit)
    (operational_unit_certification_confirmed ?operational_unit - operational_unit)
    (retail_label_spec_available ?retail_label_spec - retail_label_spec)
    (operational_unit_assigned_retail_label_spec ?operational_unit - operational_unit ?retail_label_spec - retail_label_spec)
    (transport_asset_available ?transport_asset - transport_asset)
    (operational_unit_assigned_transport_asset ?operational_unit - operational_unit ?transport_asset - transport_asset)
    (processing_parameter_available ?processing_parameter - processing_parameter)
    (operational_unit_processing_parameter_applied ?operational_unit - operational_unit ?processing_parameter - processing_parameter)
    (inspection_rule_available ?inspection_rule - inspection_rule)
    (operational_unit_assigned_inspection_rule ?operational_unit - operational_unit ?inspection_rule - inspection_rule)
    (release_document_available ?release_document - release_document)
    (unit_assigned_release_document ?produce_lot - produce_asset ?release_document - release_document)
    (processing_pallet_conditioned ?processing_pallet - processing_pallet)
    (fresh_sale_pallet_conditioned ?fresh_sale_pallet - fresh_sale_pallet)
    (operational_unit_finalized ?operational_unit - operational_unit)
  )
  (:action receive_and_register_lot
    :parameters (?produce_lot - produce_asset)
    :precondition
      (and
        (not
          (intake_registered ?produce_lot)
        )
        (not
          (authorized_for_dispatch ?produce_lot)
        )
      )
    :effect (intake_registered ?produce_lot)
  )
  (:action assign_lot_to_grader
    :parameters (?produce_lot - produce_asset ?grader_station - grader_station)
    :precondition
      (and
        (intake_registered ?produce_lot)
        (not
          (assignment_recorded_for_unit ?produce_lot)
        )
        (grader_available ?grader_station)
      )
    :effect
      (and
        (assignment_recorded_for_unit ?produce_lot)
        (unit_assigned_to_grader_station ?produce_lot ?grader_station)
        (not
          (grader_available ?grader_station)
        )
      )
  )
  (:action assign_sampling_kit_to_lot
    :parameters (?produce_lot - produce_asset ?sampling_kit - sampling_kit)
    :precondition
      (and
        (intake_registered ?produce_lot)
        (assignment_recorded_for_unit ?produce_lot)
        (sampling_kit_available ?sampling_kit)
      )
    :effect
      (and
        (unit_sample_assigned ?produce_lot ?sampling_kit)
        (not
          (sampling_kit_available ?sampling_kit)
        )
      )
  )
  (:action record_grading_result
    :parameters (?produce_lot - produce_asset ?sampling_kit - sampling_kit)
    :precondition
      (and
        (intake_registered ?produce_lot)
        (assignment_recorded_for_unit ?produce_lot)
        (unit_sample_assigned ?produce_lot ?sampling_kit)
        (not
          (grade_recorded_for_unit ?produce_lot)
        )
      )
    :effect (grade_recorded_for_unit ?produce_lot)
  )
  (:action release_sampling_kit_from_lot
    :parameters (?produce_lot - produce_asset ?sampling_kit - sampling_kit)
    :precondition
      (and
        (unit_sample_assigned ?produce_lot ?sampling_kit)
      )
    :effect
      (and
        (sampling_kit_available ?sampling_kit)
        (not
          (unit_sample_assigned ?produce_lot ?sampling_kit)
        )
      )
  )
  (:action assign_conditioning_station_to_lot
    :parameters (?produce_lot - produce_asset ?conditioning_station - conditioning_station)
    :precondition
      (and
        (grade_recorded_for_unit ?produce_lot)
        (conditioning_station_available ?conditioning_station)
      )
    :effect
      (and
        (unit_assigned_to_conditioning_station ?produce_lot ?conditioning_station)
        (not
          (conditioning_station_available ?conditioning_station)
        )
      )
  )
  (:action release_conditioning_station
    :parameters (?produce_lot - produce_asset ?conditioning_station - conditioning_station)
    :precondition
      (and
        (unit_assigned_to_conditioning_station ?produce_lot ?conditioning_station)
      )
    :effect
      (and
        (conditioning_station_available ?conditioning_station)
        (not
          (unit_assigned_to_conditioning_station ?produce_lot ?conditioning_station)
        )
      )
  )
  (:action apply_processing_parameter_to_unit
    :parameters (?operational_unit - operational_unit ?processing_parameter - processing_parameter)
    :precondition
      (and
        (grade_recorded_for_unit ?operational_unit)
        (processing_parameter_available ?processing_parameter)
      )
    :effect
      (and
        (operational_unit_processing_parameter_applied ?operational_unit ?processing_parameter)
        (not
          (processing_parameter_available ?processing_parameter)
        )
      )
  )
  (:action retract_processing_parameter_from_unit
    :parameters (?operational_unit - operational_unit ?processing_parameter - processing_parameter)
    :precondition
      (and
        (operational_unit_processing_parameter_applied ?operational_unit ?processing_parameter)
      )
    :effect
      (and
        (processing_parameter_available ?processing_parameter)
        (not
          (operational_unit_processing_parameter_applied ?operational_unit ?processing_parameter)
        )
      )
  )
  (:action apply_inspection_rule_to_unit
    :parameters (?operational_unit - operational_unit ?inspection_rule - inspection_rule)
    :precondition
      (and
        (grade_recorded_for_unit ?operational_unit)
        (inspection_rule_available ?inspection_rule)
      )
    :effect
      (and
        (operational_unit_assigned_inspection_rule ?operational_unit ?inspection_rule)
        (not
          (inspection_rule_available ?inspection_rule)
        )
      )
  )
  (:action retract_inspection_rule_from_unit
    :parameters (?operational_unit - operational_unit ?inspection_rule - inspection_rule)
    :precondition
      (and
        (operational_unit_assigned_inspection_rule ?operational_unit ?inspection_rule)
      )
    :effect
      (and
        (inspection_rule_available ?inspection_rule)
        (not
          (operational_unit_assigned_inspection_rule ?operational_unit ?inspection_rule)
        )
      )
  )
  (:action claim_processing_option_for_pallet
    :parameters (?processing_pallet - processing_pallet ?processing_option - processing_option ?sampling_kit - sampling_kit)
    :precondition
      (and
        (grade_recorded_for_unit ?processing_pallet)
        (unit_sample_assigned ?processing_pallet ?sampling_kit)
        (processing_pallet_assigned_processing_option ?processing_pallet ?processing_option)
        (not
          (processing_option_reserved ?processing_option)
        )
        (not
          (processing_option_pending_treatment ?processing_option)
        )
      )
    :effect (processing_option_reserved ?processing_option)
  )
  (:action start_conditioning_for_processing_pallet
    :parameters (?processing_pallet - processing_pallet ?processing_option - processing_option ?conditioning_station - conditioning_station)
    :precondition
      (and
        (grade_recorded_for_unit ?processing_pallet)
        (unit_assigned_to_conditioning_station ?processing_pallet ?conditioning_station)
        (processing_pallet_assigned_processing_option ?processing_pallet ?processing_option)
        (processing_option_reserved ?processing_option)
        (not
          (processing_pallet_conditioned ?processing_pallet)
        )
      )
    :effect
      (and
        (processing_pallet_conditioned ?processing_pallet)
        (processing_pallet_condition_confirmed ?processing_pallet)
      )
  )
  (:action assign_treatment_material_to_processing_pallet
    :parameters (?processing_pallet - processing_pallet ?processing_option - processing_option ?treatment_material - treatment_material)
    :precondition
      (and
        (grade_recorded_for_unit ?processing_pallet)
        (processing_pallet_assigned_processing_option ?processing_pallet ?processing_option)
        (treatment_material_available ?treatment_material)
        (not
          (processing_pallet_conditioned ?processing_pallet)
        )
      )
    :effect
      (and
        (processing_option_pending_treatment ?processing_option)
        (processing_pallet_conditioned ?processing_pallet)
        (processing_pallet_assigned_treatment_material ?processing_pallet ?treatment_material)
        (not
          (treatment_material_available ?treatment_material)
        )
      )
  )
  (:action complete_treatment_and_confirm_processing_pallet
    :parameters (?processing_pallet - processing_pallet ?processing_option - processing_option ?sampling_kit - sampling_kit ?treatment_material - treatment_material)
    :precondition
      (and
        (grade_recorded_for_unit ?processing_pallet)
        (unit_sample_assigned ?processing_pallet ?sampling_kit)
        (processing_pallet_assigned_processing_option ?processing_pallet ?processing_option)
        (processing_option_pending_treatment ?processing_option)
        (processing_pallet_assigned_treatment_material ?processing_pallet ?treatment_material)
        (not
          (processing_pallet_condition_confirmed ?processing_pallet)
        )
      )
    :effect
      (and
        (processing_option_reserved ?processing_option)
        (processing_pallet_condition_confirmed ?processing_pallet)
        (treatment_material_available ?treatment_material)
        (not
          (processing_pallet_assigned_treatment_material ?processing_pallet ?treatment_material)
        )
      )
  )
  (:action claim_fresh_sale_option_for_pallet
    :parameters (?fresh_sale_pallet - fresh_sale_pallet ?fresh_sale_option - fresh_sale_option ?sampling_kit - sampling_kit)
    :precondition
      (and
        (grade_recorded_for_unit ?fresh_sale_pallet)
        (unit_sample_assigned ?fresh_sale_pallet ?sampling_kit)
        (fresh_sale_pallet_assigned_fresh_sale_option ?fresh_sale_pallet ?fresh_sale_option)
        (not
          (fresh_sale_option_reserved ?fresh_sale_option)
        )
        (not
          (fresh_sale_option_pending_treatment ?fresh_sale_option)
        )
      )
    :effect (fresh_sale_option_reserved ?fresh_sale_option)
  )
  (:action start_conditioning_for_fresh_sale_pallet
    :parameters (?fresh_sale_pallet - fresh_sale_pallet ?fresh_sale_option - fresh_sale_option ?conditioning_station - conditioning_station)
    :precondition
      (and
        (grade_recorded_for_unit ?fresh_sale_pallet)
        (unit_assigned_to_conditioning_station ?fresh_sale_pallet ?conditioning_station)
        (fresh_sale_pallet_assigned_fresh_sale_option ?fresh_sale_pallet ?fresh_sale_option)
        (fresh_sale_option_reserved ?fresh_sale_option)
        (not
          (fresh_sale_pallet_conditioned ?fresh_sale_pallet)
        )
      )
    :effect
      (and
        (fresh_sale_pallet_conditioned ?fresh_sale_pallet)
        (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet)
      )
  )
  (:action assign_treatment_material_to_fresh_sale_pallet
    :parameters (?fresh_sale_pallet - fresh_sale_pallet ?fresh_sale_option - fresh_sale_option ?treatment_material - treatment_material)
    :precondition
      (and
        (grade_recorded_for_unit ?fresh_sale_pallet)
        (fresh_sale_pallet_assigned_fresh_sale_option ?fresh_sale_pallet ?fresh_sale_option)
        (treatment_material_available ?treatment_material)
        (not
          (fresh_sale_pallet_conditioned ?fresh_sale_pallet)
        )
      )
    :effect
      (and
        (fresh_sale_option_pending_treatment ?fresh_sale_option)
        (fresh_sale_pallet_conditioned ?fresh_sale_pallet)
        (fresh_sale_pallet_assigned_treatment_material ?fresh_sale_pallet ?treatment_material)
        (not
          (treatment_material_available ?treatment_material)
        )
      )
  )
  (:action complete_treatment_and_confirm_fresh_sale_pallet
    :parameters (?fresh_sale_pallet - fresh_sale_pallet ?fresh_sale_option - fresh_sale_option ?sampling_kit - sampling_kit ?treatment_material - treatment_material)
    :precondition
      (and
        (grade_recorded_for_unit ?fresh_sale_pallet)
        (unit_sample_assigned ?fresh_sale_pallet ?sampling_kit)
        (fresh_sale_pallet_assigned_fresh_sale_option ?fresh_sale_pallet ?fresh_sale_option)
        (fresh_sale_option_pending_treatment ?fresh_sale_option)
        (fresh_sale_pallet_assigned_treatment_material ?fresh_sale_pallet ?treatment_material)
        (not
          (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet)
        )
      )
    :effect
      (and
        (fresh_sale_option_reserved ?fresh_sale_option)
        (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet)
        (treatment_material_available ?treatment_material)
        (not
          (fresh_sale_pallet_assigned_treatment_material ?fresh_sale_pallet ?treatment_material)
        )
      )
  )
  (:action stage_outbound_unit_for_claimed_channels
    :parameters (?processing_pallet - processing_pallet ?fresh_sale_pallet - fresh_sale_pallet ?processing_option - processing_option ?fresh_sale_option - fresh_sale_option ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (processing_pallet_conditioned ?processing_pallet)
        (fresh_sale_pallet_conditioned ?fresh_sale_pallet)
        (processing_pallet_assigned_processing_option ?processing_pallet ?processing_option)
        (fresh_sale_pallet_assigned_fresh_sale_option ?fresh_sale_pallet ?fresh_sale_option)
        (processing_option_reserved ?processing_option)
        (fresh_sale_option_reserved ?fresh_sale_option)
        (processing_pallet_condition_confirmed ?processing_pallet)
        (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet)
        (outbound_unit_available ?outbound_unit)
      )
    :effect
      (and
        (outbound_unit_reserved ?outbound_unit)
        (outbound_unit_assigned_processing_option ?outbound_unit ?processing_option)
        (outbound_unit_assigned_fresh_sale_option ?outbound_unit ?fresh_sale_option)
        (not
          (outbound_unit_available ?outbound_unit)
        )
      )
  )
  (:action stage_outbound_unit_processing_material_case
    :parameters (?processing_pallet - processing_pallet ?fresh_sale_pallet - fresh_sale_pallet ?processing_option - processing_option ?fresh_sale_option - fresh_sale_option ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (processing_pallet_conditioned ?processing_pallet)
        (fresh_sale_pallet_conditioned ?fresh_sale_pallet)
        (processing_pallet_assigned_processing_option ?processing_pallet ?processing_option)
        (fresh_sale_pallet_assigned_fresh_sale_option ?fresh_sale_pallet ?fresh_sale_option)
        (processing_option_pending_treatment ?processing_option)
        (fresh_sale_option_reserved ?fresh_sale_option)
        (not
          (processing_pallet_condition_confirmed ?processing_pallet)
        )
        (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet)
        (outbound_unit_available ?outbound_unit)
      )
    :effect
      (and
        (outbound_unit_reserved ?outbound_unit)
        (outbound_unit_assigned_processing_option ?outbound_unit ?processing_option)
        (outbound_unit_assigned_fresh_sale_option ?outbound_unit ?fresh_sale_option)
        (outbound_unit_includes_processing_pallets ?outbound_unit)
        (not
          (outbound_unit_available ?outbound_unit)
        )
      )
  )
  (:action stage_outbound_unit_fresh_sale_material_case
    :parameters (?processing_pallet - processing_pallet ?fresh_sale_pallet - fresh_sale_pallet ?processing_option - processing_option ?fresh_sale_option - fresh_sale_option ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (processing_pallet_conditioned ?processing_pallet)
        (fresh_sale_pallet_conditioned ?fresh_sale_pallet)
        (processing_pallet_assigned_processing_option ?processing_pallet ?processing_option)
        (fresh_sale_pallet_assigned_fresh_sale_option ?fresh_sale_pallet ?fresh_sale_option)
        (processing_option_reserved ?processing_option)
        (fresh_sale_option_pending_treatment ?fresh_sale_option)
        (processing_pallet_condition_confirmed ?processing_pallet)
        (not
          (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet)
        )
        (outbound_unit_available ?outbound_unit)
      )
    :effect
      (and
        (outbound_unit_reserved ?outbound_unit)
        (outbound_unit_assigned_processing_option ?outbound_unit ?processing_option)
        (outbound_unit_assigned_fresh_sale_option ?outbound_unit ?fresh_sale_option)
        (outbound_unit_includes_fresh_sale_pallets ?outbound_unit)
        (not
          (outbound_unit_available ?outbound_unit)
        )
      )
  )
  (:action stage_outbound_unit_mixed_material_case
    :parameters (?processing_pallet - processing_pallet ?fresh_sale_pallet - fresh_sale_pallet ?processing_option - processing_option ?fresh_sale_option - fresh_sale_option ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (processing_pallet_conditioned ?processing_pallet)
        (fresh_sale_pallet_conditioned ?fresh_sale_pallet)
        (processing_pallet_assigned_processing_option ?processing_pallet ?processing_option)
        (fresh_sale_pallet_assigned_fresh_sale_option ?fresh_sale_pallet ?fresh_sale_option)
        (processing_option_pending_treatment ?processing_option)
        (fresh_sale_option_pending_treatment ?fresh_sale_option)
        (not
          (processing_pallet_condition_confirmed ?processing_pallet)
        )
        (not
          (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet)
        )
        (outbound_unit_available ?outbound_unit)
      )
    :effect
      (and
        (outbound_unit_reserved ?outbound_unit)
        (outbound_unit_assigned_processing_option ?outbound_unit ?processing_option)
        (outbound_unit_assigned_fresh_sale_option ?outbound_unit ?fresh_sale_option)
        (outbound_unit_includes_processing_pallets ?outbound_unit)
        (outbound_unit_includes_fresh_sale_pallets ?outbound_unit)
        (not
          (outbound_unit_available ?outbound_unit)
        )
      )
  )
  (:action mark_outbound_unit_packing_ready
    :parameters (?outbound_unit - outbound_handling_unit ?processing_pallet - processing_pallet ?sampling_kit - sampling_kit)
    :precondition
      (and
        (outbound_unit_reserved ?outbound_unit)
        (processing_pallet_conditioned ?processing_pallet)
        (unit_sample_assigned ?processing_pallet ?sampling_kit)
        (not
          (outbound_unit_packing_ready ?outbound_unit)
        )
      )
    :effect (outbound_unit_packing_ready ?outbound_unit)
  )
  (:action assign_packaging_batch_to_outbound
    :parameters (?operational_unit - operational_unit ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (grade_recorded_for_unit ?operational_unit)
        (operational_unit_manages_outbound_unit ?operational_unit ?outbound_unit)
        (operational_unit_assigned_packaging_batch ?operational_unit ?packaging_batch)
        (packaging_batch_available ?packaging_batch)
        (outbound_unit_reserved ?outbound_unit)
        (outbound_unit_packing_ready ?outbound_unit)
        (not
          (packaging_batch_prepared ?packaging_batch)
        )
      )
    :effect
      (and
        (packaging_batch_prepared ?packaging_batch)
        (packaging_batch_assigned_to_outbound_unit ?packaging_batch ?outbound_unit)
        (not
          (packaging_batch_available ?packaging_batch)
        )
      )
  )
  (:action authorize_packing_for_operational_unit
    :parameters (?operational_unit - operational_unit ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit ?sampling_kit - sampling_kit)
    :precondition
      (and
        (grade_recorded_for_unit ?operational_unit)
        (operational_unit_assigned_packaging_batch ?operational_unit ?packaging_batch)
        (packaging_batch_prepared ?packaging_batch)
        (packaging_batch_assigned_to_outbound_unit ?packaging_batch ?outbound_unit)
        (unit_sample_assigned ?operational_unit ?sampling_kit)
        (not
          (outbound_unit_includes_processing_pallets ?outbound_unit)
        )
        (not
          (operational_unit_packing_authorized ?operational_unit)
        )
      )
    :effect (operational_unit_packing_authorized ?operational_unit)
  )
  (:action assign_retail_label_spec_to_unit
    :parameters (?operational_unit - operational_unit ?retail_label_spec - retail_label_spec)
    :precondition
      (and
        (grade_recorded_for_unit ?operational_unit)
        (retail_label_spec_available ?retail_label_spec)
        (not
          (operational_unit_retail_label_applied ?operational_unit)
        )
      )
    :effect
      (and
        (operational_unit_retail_label_applied ?operational_unit)
        (operational_unit_assigned_retail_label_spec ?operational_unit ?retail_label_spec)
        (not
          (retail_label_spec_available ?retail_label_spec)
        )
      )
  )
  (:action initiate_labeling_and_packaging_sequence
    :parameters (?operational_unit - operational_unit ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit ?sampling_kit - sampling_kit ?retail_label_spec - retail_label_spec)
    :precondition
      (and
        (grade_recorded_for_unit ?operational_unit)
        (operational_unit_assigned_packaging_batch ?operational_unit ?packaging_batch)
        (packaging_batch_prepared ?packaging_batch)
        (packaging_batch_assigned_to_outbound_unit ?packaging_batch ?outbound_unit)
        (unit_sample_assigned ?operational_unit ?sampling_kit)
        (outbound_unit_includes_processing_pallets ?outbound_unit)
        (operational_unit_retail_label_applied ?operational_unit)
        (operational_unit_assigned_retail_label_spec ?operational_unit ?retail_label_spec)
        (not
          (operational_unit_packing_authorized ?operational_unit)
        )
      )
    :effect
      (and
        (operational_unit_packing_authorized ?operational_unit)
        (operational_unit_label_verified ?operational_unit)
      )
  )
  (:action apply_processing_parameter_and_initiate_packing
    :parameters (?operational_unit - operational_unit ?processing_parameter - processing_parameter ?conditioning_station - conditioning_station ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (operational_unit_packing_authorized ?operational_unit)
        (operational_unit_processing_parameter_applied ?operational_unit ?processing_parameter)
        (unit_assigned_to_conditioning_station ?operational_unit ?conditioning_station)
        (operational_unit_assigned_packaging_batch ?operational_unit ?packaging_batch)
        (packaging_batch_assigned_to_outbound_unit ?packaging_batch ?outbound_unit)
        (not
          (outbound_unit_includes_fresh_sale_pallets ?outbound_unit)
        )
        (not
          (operational_unit_packaging_initiated ?operational_unit)
        )
      )
    :effect (operational_unit_packaging_initiated ?operational_unit)
  )
  (:action apply_processing_parameter_and_initiate_packing_variant
    :parameters (?operational_unit - operational_unit ?processing_parameter - processing_parameter ?conditioning_station - conditioning_station ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (operational_unit_packing_authorized ?operational_unit)
        (operational_unit_processing_parameter_applied ?operational_unit ?processing_parameter)
        (unit_assigned_to_conditioning_station ?operational_unit ?conditioning_station)
        (operational_unit_assigned_packaging_batch ?operational_unit ?packaging_batch)
        (packaging_batch_assigned_to_outbound_unit ?packaging_batch ?outbound_unit)
        (outbound_unit_includes_fresh_sale_pallets ?outbound_unit)
        (not
          (operational_unit_packaging_initiated ?operational_unit)
        )
      )
    :effect (operational_unit_packaging_initiated ?operational_unit)
  )
  (:action run_inspection_and_mark_inspected
    :parameters (?operational_unit - operational_unit ?inspection_rule - inspection_rule ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (operational_unit_packaging_initiated ?operational_unit)
        (operational_unit_assigned_inspection_rule ?operational_unit ?inspection_rule)
        (operational_unit_assigned_packaging_batch ?operational_unit ?packaging_batch)
        (packaging_batch_assigned_to_outbound_unit ?packaging_batch ?outbound_unit)
        (not
          (outbound_unit_includes_processing_pallets ?outbound_unit)
        )
        (not
          (outbound_unit_includes_fresh_sale_pallets ?outbound_unit)
        )
        (not
          (operational_unit_inspected ?operational_unit)
        )
      )
    :effect (operational_unit_inspected ?operational_unit)
  )
  (:action run_inspection_and_attach_pack_confirmation
    :parameters (?operational_unit - operational_unit ?inspection_rule - inspection_rule ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (operational_unit_packaging_initiated ?operational_unit)
        (operational_unit_assigned_inspection_rule ?operational_unit ?inspection_rule)
        (operational_unit_assigned_packaging_batch ?operational_unit ?packaging_batch)
        (packaging_batch_assigned_to_outbound_unit ?packaging_batch ?outbound_unit)
        (outbound_unit_includes_processing_pallets ?outbound_unit)
        (not
          (outbound_unit_includes_fresh_sale_pallets ?outbound_unit)
        )
        (not
          (operational_unit_inspected ?operational_unit)
        )
      )
    :effect
      (and
        (operational_unit_inspected ?operational_unit)
        (operational_unit_packaging_confirmed ?operational_unit)
      )
  )
  (:action run_inspection_and_attach_pack_confirmation_variant
    :parameters (?operational_unit - operational_unit ?inspection_rule - inspection_rule ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (operational_unit_packaging_initiated ?operational_unit)
        (operational_unit_assigned_inspection_rule ?operational_unit ?inspection_rule)
        (operational_unit_assigned_packaging_batch ?operational_unit ?packaging_batch)
        (packaging_batch_assigned_to_outbound_unit ?packaging_batch ?outbound_unit)
        (not
          (outbound_unit_includes_processing_pallets ?outbound_unit)
        )
        (outbound_unit_includes_fresh_sale_pallets ?outbound_unit)
        (not
          (operational_unit_inspected ?operational_unit)
        )
      )
    :effect
      (and
        (operational_unit_inspected ?operational_unit)
        (operational_unit_packaging_confirmed ?operational_unit)
      )
  )
  (:action run_inspection_and_attach_pack_confirmation_complete
    :parameters (?operational_unit - operational_unit ?inspection_rule - inspection_rule ?packaging_batch - packaging_batch ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (operational_unit_packaging_initiated ?operational_unit)
        (operational_unit_assigned_inspection_rule ?operational_unit ?inspection_rule)
        (operational_unit_assigned_packaging_batch ?operational_unit ?packaging_batch)
        (packaging_batch_assigned_to_outbound_unit ?packaging_batch ?outbound_unit)
        (outbound_unit_includes_processing_pallets ?outbound_unit)
        (outbound_unit_includes_fresh_sale_pallets ?outbound_unit)
        (not
          (operational_unit_inspected ?operational_unit)
        )
      )
    :effect
      (and
        (operational_unit_inspected ?operational_unit)
        (operational_unit_packaging_confirmed ?operational_unit)
      )
  )
  (:action finalize_operational_unit
    :parameters (?operational_unit - operational_unit)
    :precondition
      (and
        (operational_unit_inspected ?operational_unit)
        (not
          (operational_unit_packaging_confirmed ?operational_unit)
        )
        (not
          (operational_unit_finalized ?operational_unit)
        )
      )
    :effect
      (and
        (operational_unit_finalized ?operational_unit)
        (ready_for_dispatch ?operational_unit)
      )
  )
  (:action assign_transport_asset_to_operational_unit
    :parameters (?operational_unit - operational_unit ?transport_asset - transport_asset)
    :precondition
      (and
        (operational_unit_inspected ?operational_unit)
        (operational_unit_packaging_confirmed ?operational_unit)
        (transport_asset_available ?transport_asset)
      )
    :effect
      (and
        (operational_unit_assigned_transport_asset ?operational_unit ?transport_asset)
        (not
          (transport_asset_available ?transport_asset)
        )
      )
  )
  (:action confirm_packing_and_quality_for_unit
    :parameters (?operational_unit - operational_unit ?processing_pallet - processing_pallet ?fresh_sale_pallet - fresh_sale_pallet ?sampling_kit - sampling_kit ?transport_asset - transport_asset)
    :precondition
      (and
        (operational_unit_inspected ?operational_unit)
        (operational_unit_packaging_confirmed ?operational_unit)
        (operational_unit_assigned_transport_asset ?operational_unit ?transport_asset)
        (operational_unit_manages_processing_pallet ?operational_unit ?processing_pallet)
        (operational_unit_manages_fresh_sale_pallet ?operational_unit ?fresh_sale_pallet)
        (processing_pallet_condition_confirmed ?processing_pallet)
        (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet)
        (unit_sample_assigned ?operational_unit ?sampling_kit)
        (not
          (operational_unit_quality_confirmed ?operational_unit)
        )
      )
    :effect (operational_unit_quality_confirmed ?operational_unit)
  )
  (:action finalize_unit_and_mark_ready
    :parameters (?operational_unit - operational_unit)
    :precondition
      (and
        (operational_unit_inspected ?operational_unit)
        (operational_unit_quality_confirmed ?operational_unit)
        (not
          (operational_unit_finalized ?operational_unit)
        )
      )
    :effect
      (and
        (operational_unit_finalized ?operational_unit)
        (ready_for_dispatch ?operational_unit)
      )
  )
  (:action apply_certification_to_operational_unit
    :parameters (?operational_unit - operational_unit ?certification_record - certification_record ?sampling_kit - sampling_kit)
    :precondition
      (and
        (grade_recorded_for_unit ?operational_unit)
        (unit_sample_assigned ?operational_unit ?sampling_kit)
        (certification_record_available ?certification_record)
        (operational_unit_assigned_certification ?operational_unit ?certification_record)
        (not
          (operational_unit_certification_applied ?operational_unit)
        )
      )
    :effect
      (and
        (operational_unit_certification_applied ?operational_unit)
        (not
          (certification_record_available ?certification_record)
        )
      )
  )
  (:action request_unit_inspection
    :parameters (?operational_unit - operational_unit ?conditioning_station - conditioning_station)
    :precondition
      (and
        (operational_unit_certification_applied ?operational_unit)
        (unit_assigned_to_conditioning_station ?operational_unit ?conditioning_station)
        (not
          (operational_unit_certification_ready ?operational_unit)
        )
      )
    :effect (operational_unit_certification_ready ?operational_unit)
  )
  (:action record_inspection_result
    :parameters (?operational_unit - operational_unit ?inspection_rule - inspection_rule)
    :precondition
      (and
        (operational_unit_certification_ready ?operational_unit)
        (operational_unit_assigned_inspection_rule ?operational_unit ?inspection_rule)
        (not
          (operational_unit_certification_confirmed ?operational_unit)
        )
      )
    :effect (operational_unit_certification_confirmed ?operational_unit)
  )
  (:action finalize_unit_after_inspection
    :parameters (?operational_unit - operational_unit)
    :precondition
      (and
        (operational_unit_certification_confirmed ?operational_unit)
        (not
          (operational_unit_finalized ?operational_unit)
        )
      )
    :effect
      (and
        (operational_unit_finalized ?operational_unit)
        (ready_for_dispatch ?operational_unit)
      )
  )
  (:action release_processing_pallet_to_outbound_unit
    :parameters (?processing_pallet - processing_pallet ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (processing_pallet_conditioned ?processing_pallet)
        (processing_pallet_condition_confirmed ?processing_pallet)
        (outbound_unit_reserved ?outbound_unit)
        (outbound_unit_packing_ready ?outbound_unit)
        (not
          (ready_for_dispatch ?processing_pallet)
        )
      )
    :effect (ready_for_dispatch ?processing_pallet)
  )
  (:action release_fresh_sale_pallet_to_outbound_unit
    :parameters (?fresh_sale_pallet - fresh_sale_pallet ?outbound_unit - outbound_handling_unit)
    :precondition
      (and
        (fresh_sale_pallet_conditioned ?fresh_sale_pallet)
        (fresh_sale_pallet_condition_confirmed ?fresh_sale_pallet)
        (outbound_unit_reserved ?outbound_unit)
        (outbound_unit_packing_ready ?outbound_unit)
        (not
          (ready_for_dispatch ?fresh_sale_pallet)
        )
      )
    :effect (ready_for_dispatch ?fresh_sale_pallet)
  )
  (:action authorize_lot_release_and_attach_document
    :parameters (?produce_lot - produce_asset ?release_document - release_document ?sampling_kit - sampling_kit)
    :precondition
      (and
        (ready_for_dispatch ?produce_lot)
        (unit_sample_assigned ?produce_lot ?sampling_kit)
        (release_document_available ?release_document)
        (not
          (release_authorized_for_unit ?produce_lot)
        )
      )
    :effect
      (and
        (release_authorized_for_unit ?produce_lot)
        (unit_assigned_release_document ?produce_lot ?release_document)
        (not
          (release_document_available ?release_document)
        )
      )
  )
  (:action finalize_dispatch_for_processing_pallet
    :parameters (?processing_pallet - processing_pallet ?grader_station - grader_station ?release_document - release_document)
    :precondition
      (and
        (release_authorized_for_unit ?processing_pallet)
        (unit_assigned_to_grader_station ?processing_pallet ?grader_station)
        (unit_assigned_release_document ?processing_pallet ?release_document)
        (not
          (authorized_for_dispatch ?processing_pallet)
        )
      )
    :effect
      (and
        (authorized_for_dispatch ?processing_pallet)
        (grader_available ?grader_station)
        (release_document_available ?release_document)
      )
  )
  (:action finalize_dispatch_for_fresh_sale_pallet
    :parameters (?fresh_sale_pallet - fresh_sale_pallet ?grader_station - grader_station ?release_document - release_document)
    :precondition
      (and
        (release_authorized_for_unit ?fresh_sale_pallet)
        (unit_assigned_to_grader_station ?fresh_sale_pallet ?grader_station)
        (unit_assigned_release_document ?fresh_sale_pallet ?release_document)
        (not
          (authorized_for_dispatch ?fresh_sale_pallet)
        )
      )
    :effect
      (and
        (authorized_for_dispatch ?fresh_sale_pallet)
        (grader_available ?grader_station)
        (release_document_available ?release_document)
      )
  )
  (:action finalize_dispatch_for_operational_unit
    :parameters (?operational_unit - operational_unit ?grader_station - grader_station ?release_document - release_document)
    :precondition
      (and
        (release_authorized_for_unit ?operational_unit)
        (unit_assigned_to_grader_station ?operational_unit ?grader_station)
        (unit_assigned_release_document ?operational_unit ?release_document)
        (not
          (authorized_for_dispatch ?operational_unit)
        )
      )
    :effect
      (and
        (authorized_for_dispatch ?operational_unit)
        (grader_available ?grader_station)
        (release_document_available ?release_document)
      )
  )
)

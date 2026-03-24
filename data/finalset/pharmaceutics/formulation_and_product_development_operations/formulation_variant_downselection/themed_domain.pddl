(define (domain pharmaceutics_formulation_variant_downselection)
  (:requirements :strips :typing :negative-preconditions)
  (:types physical_object - object development_resource_category - physical_object material_or_attribute_category - physical_object study_related_category - physical_object variant_abstract_class - physical_object formulation_variant - variant_abstract_class resource_slot - development_resource_category analytical_method - development_resource_category process_expert - development_resource_category regulatory_constraint - development_resource_category acceptance_criterion - development_resource_category evidence_artifact - development_resource_category equipment_qualification - development_resource_category risk_descriptor - development_resource_category excipient_or_material - material_or_attribute_category analytical_descriptor - material_or_attribute_category vendor_constraint - material_or_attribute_category stability_condition - study_related_category manufacturing_platform - study_related_category study_record - study_related_category lab_variant_class - formulation_variant portfolio_variant_class - formulation_variant lab_scale_variant - lab_variant_class alternate_lab_variant - lab_variant_class development_portfolio_item - portfolio_variant_class)

  (:predicates
    (item_registered ?formulation_variant - formulation_variant)
    (item_ready_for_characterization ?formulation_variant - formulation_variant)
    (item_slot_reserved ?formulation_variant - formulation_variant)
    (item_selected ?formulation_variant - formulation_variant)
    (evaluation_completed ?formulation_variant - formulation_variant)
    (item_has_evidence ?formulation_variant - formulation_variant)
    (resource_slot_available ?resource_slot - resource_slot)
    (item_allocated_to_resource_slot ?formulation_variant - formulation_variant ?resource_slot - resource_slot)
    (analytical_method_available ?analytical_method - analytical_method)
    (item_assigned_method ?formulation_variant - formulation_variant ?analytical_method - analytical_method)
    (process_expert_available ?process_expert - process_expert)
    (item_assigned_process_expert ?formulation_variant - formulation_variant ?process_expert - process_expert)
    (material_available ?excipient_or_material - excipient_or_material)
    (lab_variant_assigned_material ?lab_scale_variant - lab_scale_variant ?excipient_or_material - excipient_or_material)
    (alt_lab_variant_assigned_material ?alternate_lab_variant - alternate_lab_variant ?excipient_or_material - excipient_or_material)
    (lab_variant_paired_with_stability_condition ?lab_scale_variant - lab_scale_variant ?stability_condition - stability_condition)
    (stability_condition_reserved ?stability_condition - stability_condition)
    (stability_condition_material_assigned ?stability_condition - stability_condition)
    (lab_variant_ready_for_study ?lab_scale_variant - lab_scale_variant)
    (alt_lab_variant_paired_manufacturing_platform ?alternate_lab_variant - alternate_lab_variant ?manufacturing_platform - manufacturing_platform)
    (manufacturing_platform_reserved ?manufacturing_platform - manufacturing_platform)
    (manufacturing_platform_material_assigned ?manufacturing_platform - manufacturing_platform)
    (alt_lab_variant_ready_for_study ?alternate_lab_variant - alternate_lab_variant)
    (study_record_available ?study_record - study_record)
    (study_record_initiated ?study_record - study_record)
    (study_linked_to_stability_condition ?study_record - study_record ?stability_condition - stability_condition)
    (study_linked_to_manufacturing_platform ?study_record - study_record ?manufacturing_platform - manufacturing_platform)
    (study_condition_completed ?study_record - study_record)
    (study_platform_completed ?study_record - study_record)
    (study_results_recorded ?study_record - study_record)
    (portfolio_item_includes_lab_variant ?development_portfolio_item - development_portfolio_item ?lab_scale_variant - lab_scale_variant)
    (portfolio_item_includes_alt_lab_variant ?development_portfolio_item - development_portfolio_item ?alternate_lab_variant - alternate_lab_variant)
    (portfolio_item_has_study_record ?development_portfolio_item - development_portfolio_item ?study_record - study_record)
    (analytical_descriptor_available ?analytical_descriptor - analytical_descriptor)
    (portfolio_item_has_analytical_descriptor ?development_portfolio_item - development_portfolio_item ?analytical_descriptor - analytical_descriptor)
    (analytical_descriptor_allocated ?analytical_descriptor - analytical_descriptor)
    (analytical_descriptor_linked_to_study_record ?analytical_descriptor - analytical_descriptor ?study_record - study_record)
    (portfolio_item_initial_review_complete ?development_portfolio_item - development_portfolio_item)
    (portfolio_item_vendor_constraints_verified ?development_portfolio_item - development_portfolio_item)
    (portfolio_item_risk_assessed ?development_portfolio_item - development_portfolio_item)
    (portfolio_item_regulatory_constraint_applied ?development_portfolio_item - development_portfolio_item)
    (portfolio_item_regulatory_compliance_verified ?development_portfolio_item - development_portfolio_item)
    (portfolio_item_ready_for_evaluation ?development_portfolio_item - development_portfolio_item)
    (portfolio_item_evaluation_in_progress ?development_portfolio_item - development_portfolio_item)
    (vendor_constraint_available ?vendor_constraint - vendor_constraint)
    (portfolio_item_has_vendor_constraint ?development_portfolio_item - development_portfolio_item ?vendor_constraint - vendor_constraint)
    (portfolio_item_vendor_constraint_acknowledged ?development_portfolio_item - development_portfolio_item)
    (portfolio_item_vendor_constraint_confirmed ?development_portfolio_item - development_portfolio_item)
    (portfolio_item_vendor_constraint_reviewed ?development_portfolio_item - development_portfolio_item)
    (regulatory_constraint_available ?regulatory_constraint - regulatory_constraint)
    (portfolio_item_linked_regulatory_constraint ?development_portfolio_item - development_portfolio_item ?regulatory_constraint - regulatory_constraint)
    (acceptance_criterion_available ?acceptance_criterion - acceptance_criterion)
    (portfolio_item_has_acceptance_criterion ?development_portfolio_item - development_portfolio_item ?acceptance_criterion - acceptance_criterion)
    (equipment_qualification_available ?equipment_qualification - equipment_qualification)
    (portfolio_item_has_equipment_qualification ?development_portfolio_item - development_portfolio_item ?equipment_qualification - equipment_qualification)
    (risk_descriptor_available ?risk_descriptor - risk_descriptor)
    (portfolio_item_has_risk_descriptor ?development_portfolio_item - development_portfolio_item ?risk_descriptor - risk_descriptor)
    (evidence_artifact_available ?evidence_artifact - evidence_artifact)
    (item_linked_evidence_artifact ?formulation_variant - formulation_variant ?evidence_artifact - evidence_artifact)
    (lab_variant_prepared_for_study ?lab_scale_variant - lab_scale_variant)
    (alt_lab_variant_prepared_for_study ?alternate_lab_variant - alternate_lab_variant)
    (portfolio_item_finalized ?development_portfolio_item - development_portfolio_item)
  )
  (:action register_formulation_variant
    :parameters (?formulation_variant - formulation_variant)
    :precondition
      (and
        (not
          (item_registered ?formulation_variant)
        )
        (not
          (item_selected ?formulation_variant)
        )
      )
    :effect (item_registered ?formulation_variant)
  )
  (:action assign_resource_slot_to_variant
    :parameters (?formulation_variant - formulation_variant ?resource_slot - resource_slot)
    :precondition
      (and
        (item_registered ?formulation_variant)
        (not
          (item_slot_reserved ?formulation_variant)
        )
        (resource_slot_available ?resource_slot)
      )
    :effect
      (and
        (item_slot_reserved ?formulation_variant)
        (item_allocated_to_resource_slot ?formulation_variant ?resource_slot)
        (not
          (resource_slot_available ?resource_slot)
        )
      )
  )
  (:action assign_analytical_method_to_variant
    :parameters (?formulation_variant - formulation_variant ?analytical_method - analytical_method)
    :precondition
      (and
        (item_registered ?formulation_variant)
        (item_slot_reserved ?formulation_variant)
        (analytical_method_available ?analytical_method)
      )
    :effect
      (and
        (item_assigned_method ?formulation_variant ?analytical_method)
        (not
          (analytical_method_available ?analytical_method)
        )
      )
  )
  (:action mark_variant_ready_for_characterization
    :parameters (?formulation_variant - formulation_variant ?analytical_method - analytical_method)
    :precondition
      (and
        (item_registered ?formulation_variant)
        (item_slot_reserved ?formulation_variant)
        (item_assigned_method ?formulation_variant ?analytical_method)
        (not
          (item_ready_for_characterization ?formulation_variant)
        )
      )
    :effect (item_ready_for_characterization ?formulation_variant)
  )
  (:action release_analytical_method_from_variant
    :parameters (?formulation_variant - formulation_variant ?analytical_method - analytical_method)
    :precondition
      (and
        (item_assigned_method ?formulation_variant ?analytical_method)
      )
    :effect
      (and
        (analytical_method_available ?analytical_method)
        (not
          (item_assigned_method ?formulation_variant ?analytical_method)
        )
      )
  )
  (:action assign_process_expert_to_variant
    :parameters (?formulation_variant - formulation_variant ?process_expert - process_expert)
    :precondition
      (and
        (item_ready_for_characterization ?formulation_variant)
        (process_expert_available ?process_expert)
      )
    :effect
      (and
        (item_assigned_process_expert ?formulation_variant ?process_expert)
        (not
          (process_expert_available ?process_expert)
        )
      )
  )
  (:action release_process_expert_from_variant
    :parameters (?formulation_variant - formulation_variant ?process_expert - process_expert)
    :precondition
      (and
        (item_assigned_process_expert ?formulation_variant ?process_expert)
      )
    :effect
      (and
        (process_expert_available ?process_expert)
        (not
          (item_assigned_process_expert ?formulation_variant ?process_expert)
        )
      )
  )
  (:action assign_equipment_qualification_to_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?equipment_qualification - equipment_qualification)
    :precondition
      (and
        (item_ready_for_characterization ?development_portfolio_item)
        (equipment_qualification_available ?equipment_qualification)
      )
    :effect
      (and
        (portfolio_item_has_equipment_qualification ?development_portfolio_item ?equipment_qualification)
        (not
          (equipment_qualification_available ?equipment_qualification)
        )
      )
  )
  (:action release_equipment_qualification_from_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?equipment_qualification - equipment_qualification)
    :precondition
      (and
        (portfolio_item_has_equipment_qualification ?development_portfolio_item ?equipment_qualification)
      )
    :effect
      (and
        (equipment_qualification_available ?equipment_qualification)
        (not
          (portfolio_item_has_equipment_qualification ?development_portfolio_item ?equipment_qualification)
        )
      )
  )
  (:action assign_risk_descriptor_to_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?risk_descriptor - risk_descriptor)
    :precondition
      (and
        (item_ready_for_characterization ?development_portfolio_item)
        (risk_descriptor_available ?risk_descriptor)
      )
    :effect
      (and
        (portfolio_item_has_risk_descriptor ?development_portfolio_item ?risk_descriptor)
        (not
          (risk_descriptor_available ?risk_descriptor)
        )
      )
  )
  (:action release_risk_descriptor_from_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?risk_descriptor - risk_descriptor)
    :precondition
      (and
        (portfolio_item_has_risk_descriptor ?development_portfolio_item ?risk_descriptor)
      )
    :effect
      (and
        (risk_descriptor_available ?risk_descriptor)
        (not
          (portfolio_item_has_risk_descriptor ?development_portfolio_item ?risk_descriptor)
        )
      )
  )
  (:action reserve_stability_condition_for_lab_variant
    :parameters (?lab_scale_variant - lab_scale_variant ?stability_condition - stability_condition ?analytical_method - analytical_method)
    :precondition
      (and
        (item_ready_for_characterization ?lab_scale_variant)
        (item_assigned_method ?lab_scale_variant ?analytical_method)
        (lab_variant_paired_with_stability_condition ?lab_scale_variant ?stability_condition)
        (not
          (stability_condition_reserved ?stability_condition)
        )
        (not
          (stability_condition_material_assigned ?stability_condition)
        )
      )
    :effect (stability_condition_reserved ?stability_condition)
  )
  (:action confirm_stability_condition_assignment_with_expert
    :parameters (?lab_scale_variant - lab_scale_variant ?stability_condition - stability_condition ?process_expert - process_expert)
    :precondition
      (and
        (item_ready_for_characterization ?lab_scale_variant)
        (item_assigned_process_expert ?lab_scale_variant ?process_expert)
        (lab_variant_paired_with_stability_condition ?lab_scale_variant ?stability_condition)
        (stability_condition_reserved ?stability_condition)
        (not
          (lab_variant_prepared_for_study ?lab_scale_variant)
        )
      )
    :effect
      (and
        (lab_variant_prepared_for_study ?lab_scale_variant)
        (lab_variant_ready_for_study ?lab_scale_variant)
      )
  )
  (:action assign_material_to_lab_variant_for_condition
    :parameters (?lab_scale_variant - lab_scale_variant ?stability_condition - stability_condition ?excipient_or_material - excipient_or_material)
    :precondition
      (and
        (item_ready_for_characterization ?lab_scale_variant)
        (lab_variant_paired_with_stability_condition ?lab_scale_variant ?stability_condition)
        (material_available ?excipient_or_material)
        (not
          (lab_variant_prepared_for_study ?lab_scale_variant)
        )
      )
    :effect
      (and
        (stability_condition_material_assigned ?stability_condition)
        (lab_variant_prepared_for_study ?lab_scale_variant)
        (lab_variant_assigned_material ?lab_scale_variant ?excipient_or_material)
        (not
          (material_available ?excipient_or_material)
        )
      )
  )
  (:action finalize_lab_variant_condition_preparation
    :parameters (?lab_scale_variant - lab_scale_variant ?stability_condition - stability_condition ?analytical_method - analytical_method ?excipient_or_material - excipient_or_material)
    :precondition
      (and
        (item_ready_for_characterization ?lab_scale_variant)
        (item_assigned_method ?lab_scale_variant ?analytical_method)
        (lab_variant_paired_with_stability_condition ?lab_scale_variant ?stability_condition)
        (stability_condition_material_assigned ?stability_condition)
        (lab_variant_assigned_material ?lab_scale_variant ?excipient_or_material)
        (not
          (lab_variant_ready_for_study ?lab_scale_variant)
        )
      )
    :effect
      (and
        (stability_condition_reserved ?stability_condition)
        (lab_variant_ready_for_study ?lab_scale_variant)
        (material_available ?excipient_or_material)
        (not
          (lab_variant_assigned_material ?lab_scale_variant ?excipient_or_material)
        )
      )
  )
  (:action reserve_manufacturing_platform_for_alt_lab_variant
    :parameters (?alternate_lab_variant - alternate_lab_variant ?manufacturing_platform - manufacturing_platform ?analytical_method - analytical_method)
    :precondition
      (and
        (item_ready_for_characterization ?alternate_lab_variant)
        (item_assigned_method ?alternate_lab_variant ?analytical_method)
        (alt_lab_variant_paired_manufacturing_platform ?alternate_lab_variant ?manufacturing_platform)
        (not
          (manufacturing_platform_reserved ?manufacturing_platform)
        )
        (not
          (manufacturing_platform_material_assigned ?manufacturing_platform)
        )
      )
    :effect (manufacturing_platform_reserved ?manufacturing_platform)
  )
  (:action confirm_expert_assignment_for_alt_lab_variant_platform
    :parameters (?alternate_lab_variant - alternate_lab_variant ?manufacturing_platform - manufacturing_platform ?process_expert - process_expert)
    :precondition
      (and
        (item_ready_for_characterization ?alternate_lab_variant)
        (item_assigned_process_expert ?alternate_lab_variant ?process_expert)
        (alt_lab_variant_paired_manufacturing_platform ?alternate_lab_variant ?manufacturing_platform)
        (manufacturing_platform_reserved ?manufacturing_platform)
        (not
          (alt_lab_variant_prepared_for_study ?alternate_lab_variant)
        )
      )
    :effect
      (and
        (alt_lab_variant_prepared_for_study ?alternate_lab_variant)
        (alt_lab_variant_ready_for_study ?alternate_lab_variant)
      )
  )
  (:action assign_material_to_alt_lab_variant_for_platform
    :parameters (?alternate_lab_variant - alternate_lab_variant ?manufacturing_platform - manufacturing_platform ?excipient_or_material - excipient_or_material)
    :precondition
      (and
        (item_ready_for_characterization ?alternate_lab_variant)
        (alt_lab_variant_paired_manufacturing_platform ?alternate_lab_variant ?manufacturing_platform)
        (material_available ?excipient_or_material)
        (not
          (alt_lab_variant_prepared_for_study ?alternate_lab_variant)
        )
      )
    :effect
      (and
        (manufacturing_platform_material_assigned ?manufacturing_platform)
        (alt_lab_variant_prepared_for_study ?alternate_lab_variant)
        (alt_lab_variant_assigned_material ?alternate_lab_variant ?excipient_or_material)
        (not
          (material_available ?excipient_or_material)
        )
      )
  )
  (:action finalize_alt_lab_variant_platform_preparation
    :parameters (?alternate_lab_variant - alternate_lab_variant ?manufacturing_platform - manufacturing_platform ?analytical_method - analytical_method ?excipient_or_material - excipient_or_material)
    :precondition
      (and
        (item_ready_for_characterization ?alternate_lab_variant)
        (item_assigned_method ?alternate_lab_variant ?analytical_method)
        (alt_lab_variant_paired_manufacturing_platform ?alternate_lab_variant ?manufacturing_platform)
        (manufacturing_platform_material_assigned ?manufacturing_platform)
        (alt_lab_variant_assigned_material ?alternate_lab_variant ?excipient_or_material)
        (not
          (alt_lab_variant_ready_for_study ?alternate_lab_variant)
        )
      )
    :effect
      (and
        (manufacturing_platform_reserved ?manufacturing_platform)
        (alt_lab_variant_ready_for_study ?alternate_lab_variant)
        (material_available ?excipient_or_material)
        (not
          (alt_lab_variant_assigned_material ?alternate_lab_variant ?excipient_or_material)
        )
      )
  )
  (:action initialize_study_record
    :parameters (?lab_scale_variant - lab_scale_variant ?alternate_lab_variant - alternate_lab_variant ?stability_condition - stability_condition ?manufacturing_platform - manufacturing_platform ?study_record - study_record)
    :precondition
      (and
        (lab_variant_prepared_for_study ?lab_scale_variant)
        (alt_lab_variant_prepared_for_study ?alternate_lab_variant)
        (lab_variant_paired_with_stability_condition ?lab_scale_variant ?stability_condition)
        (alt_lab_variant_paired_manufacturing_platform ?alternate_lab_variant ?manufacturing_platform)
        (stability_condition_reserved ?stability_condition)
        (manufacturing_platform_reserved ?manufacturing_platform)
        (lab_variant_ready_for_study ?lab_scale_variant)
        (alt_lab_variant_ready_for_study ?alternate_lab_variant)
        (study_record_available ?study_record)
      )
    :effect
      (and
        (study_record_initiated ?study_record)
        (study_linked_to_stability_condition ?study_record ?stability_condition)
        (study_linked_to_manufacturing_platform ?study_record ?manufacturing_platform)
        (not
          (study_record_available ?study_record)
        )
      )
  )
  (:action initialize_study_record_and_mark_condition_completed
    :parameters (?lab_scale_variant - lab_scale_variant ?alternate_lab_variant - alternate_lab_variant ?stability_condition - stability_condition ?manufacturing_platform - manufacturing_platform ?study_record - study_record)
    :precondition
      (and
        (lab_variant_prepared_for_study ?lab_scale_variant)
        (alt_lab_variant_prepared_for_study ?alternate_lab_variant)
        (lab_variant_paired_with_stability_condition ?lab_scale_variant ?stability_condition)
        (alt_lab_variant_paired_manufacturing_platform ?alternate_lab_variant ?manufacturing_platform)
        (stability_condition_material_assigned ?stability_condition)
        (manufacturing_platform_reserved ?manufacturing_platform)
        (not
          (lab_variant_ready_for_study ?lab_scale_variant)
        )
        (alt_lab_variant_ready_for_study ?alternate_lab_variant)
        (study_record_available ?study_record)
      )
    :effect
      (and
        (study_record_initiated ?study_record)
        (study_linked_to_stability_condition ?study_record ?stability_condition)
        (study_linked_to_manufacturing_platform ?study_record ?manufacturing_platform)
        (study_condition_completed ?study_record)
        (not
          (study_record_available ?study_record)
        )
      )
  )
  (:action initialize_study_record_and_mark_platform_completed
    :parameters (?lab_scale_variant - lab_scale_variant ?alternate_lab_variant - alternate_lab_variant ?stability_condition - stability_condition ?manufacturing_platform - manufacturing_platform ?study_record - study_record)
    :precondition
      (and
        (lab_variant_prepared_for_study ?lab_scale_variant)
        (alt_lab_variant_prepared_for_study ?alternate_lab_variant)
        (lab_variant_paired_with_stability_condition ?lab_scale_variant ?stability_condition)
        (alt_lab_variant_paired_manufacturing_platform ?alternate_lab_variant ?manufacturing_platform)
        (stability_condition_reserved ?stability_condition)
        (manufacturing_platform_material_assigned ?manufacturing_platform)
        (lab_variant_ready_for_study ?lab_scale_variant)
        (not
          (alt_lab_variant_ready_for_study ?alternate_lab_variant)
        )
        (study_record_available ?study_record)
      )
    :effect
      (and
        (study_record_initiated ?study_record)
        (study_linked_to_stability_condition ?study_record ?stability_condition)
        (study_linked_to_manufacturing_platform ?study_record ?manufacturing_platform)
        (study_platform_completed ?study_record)
        (not
          (study_record_available ?study_record)
        )
      )
  )
  (:action initialize_study_record_and_mark_condition_and_platform_completed
    :parameters (?lab_scale_variant - lab_scale_variant ?alternate_lab_variant - alternate_lab_variant ?stability_condition - stability_condition ?manufacturing_platform - manufacturing_platform ?study_record - study_record)
    :precondition
      (and
        (lab_variant_prepared_for_study ?lab_scale_variant)
        (alt_lab_variant_prepared_for_study ?alternate_lab_variant)
        (lab_variant_paired_with_stability_condition ?lab_scale_variant ?stability_condition)
        (alt_lab_variant_paired_manufacturing_platform ?alternate_lab_variant ?manufacturing_platform)
        (stability_condition_material_assigned ?stability_condition)
        (manufacturing_platform_material_assigned ?manufacturing_platform)
        (not
          (lab_variant_ready_for_study ?lab_scale_variant)
        )
        (not
          (alt_lab_variant_ready_for_study ?alternate_lab_variant)
        )
        (study_record_available ?study_record)
      )
    :effect
      (and
        (study_record_initiated ?study_record)
        (study_linked_to_stability_condition ?study_record ?stability_condition)
        (study_linked_to_manufacturing_platform ?study_record ?manufacturing_platform)
        (study_condition_completed ?study_record)
        (study_platform_completed ?study_record)
        (not
          (study_record_available ?study_record)
        )
      )
  )
  (:action record_study_results
    :parameters (?study_record - study_record ?lab_scale_variant - lab_scale_variant ?analytical_method - analytical_method)
    :precondition
      (and
        (study_record_initiated ?study_record)
        (lab_variant_prepared_for_study ?lab_scale_variant)
        (item_assigned_method ?lab_scale_variant ?analytical_method)
        (not
          (study_results_recorded ?study_record)
        )
      )
    :effect (study_results_recorded ?study_record)
  )
  (:action allocate_analytical_descriptor_to_study_record
    :parameters (?development_portfolio_item - development_portfolio_item ?analytical_descriptor - analytical_descriptor ?study_record - study_record)
    :precondition
      (and
        (item_ready_for_characterization ?development_portfolio_item)
        (portfolio_item_has_study_record ?development_portfolio_item ?study_record)
        (portfolio_item_has_analytical_descriptor ?development_portfolio_item ?analytical_descriptor)
        (analytical_descriptor_available ?analytical_descriptor)
        (study_record_initiated ?study_record)
        (study_results_recorded ?study_record)
        (not
          (analytical_descriptor_allocated ?analytical_descriptor)
        )
      )
    :effect
      (and
        (analytical_descriptor_allocated ?analytical_descriptor)
        (analytical_descriptor_linked_to_study_record ?analytical_descriptor ?study_record)
        (not
          (analytical_descriptor_available ?analytical_descriptor)
        )
      )
  )
  (:action perform_portfolio_item_initial_review
    :parameters (?development_portfolio_item - development_portfolio_item ?analytical_descriptor - analytical_descriptor ?study_record - study_record ?analytical_method - analytical_method)
    :precondition
      (and
        (item_ready_for_characterization ?development_portfolio_item)
        (portfolio_item_has_analytical_descriptor ?development_portfolio_item ?analytical_descriptor)
        (analytical_descriptor_allocated ?analytical_descriptor)
        (analytical_descriptor_linked_to_study_record ?analytical_descriptor ?study_record)
        (item_assigned_method ?development_portfolio_item ?analytical_method)
        (not
          (study_condition_completed ?study_record)
        )
        (not
          (portfolio_item_initial_review_complete ?development_portfolio_item)
        )
      )
    :effect (portfolio_item_initial_review_complete ?development_portfolio_item)
  )
  (:action link_regulatory_constraint_to_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?regulatory_constraint - regulatory_constraint)
    :precondition
      (and
        (item_ready_for_characterization ?development_portfolio_item)
        (regulatory_constraint_available ?regulatory_constraint)
        (not
          (portfolio_item_regulatory_constraint_applied ?development_portfolio_item)
        )
      )
    :effect
      (and
        (portfolio_item_regulatory_constraint_applied ?development_portfolio_item)
        (portfolio_item_linked_regulatory_constraint ?development_portfolio_item ?regulatory_constraint)
        (not
          (regulatory_constraint_available ?regulatory_constraint)
        )
      )
  )
  (:action perform_regulatory_compliance_check_for_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?analytical_descriptor - analytical_descriptor ?study_record - study_record ?analytical_method - analytical_method ?regulatory_constraint - regulatory_constraint)
    :precondition
      (and
        (item_ready_for_characterization ?development_portfolio_item)
        (portfolio_item_has_analytical_descriptor ?development_portfolio_item ?analytical_descriptor)
        (analytical_descriptor_allocated ?analytical_descriptor)
        (analytical_descriptor_linked_to_study_record ?analytical_descriptor ?study_record)
        (item_assigned_method ?development_portfolio_item ?analytical_method)
        (study_condition_completed ?study_record)
        (portfolio_item_regulatory_constraint_applied ?development_portfolio_item)
        (portfolio_item_linked_regulatory_constraint ?development_portfolio_item ?regulatory_constraint)
        (not
          (portfolio_item_initial_review_complete ?development_portfolio_item)
        )
      )
    :effect
      (and
        (portfolio_item_initial_review_complete ?development_portfolio_item)
        (portfolio_item_regulatory_compliance_verified ?development_portfolio_item)
      )
  )
  (:action apply_vendor_constraints_to_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?equipment_qualification - equipment_qualification ?process_expert - process_expert ?analytical_descriptor - analytical_descriptor ?study_record - study_record)
    :precondition
      (and
        (portfolio_item_initial_review_complete ?development_portfolio_item)
        (portfolio_item_has_equipment_qualification ?development_portfolio_item ?equipment_qualification)
        (item_assigned_process_expert ?development_portfolio_item ?process_expert)
        (portfolio_item_has_analytical_descriptor ?development_portfolio_item ?analytical_descriptor)
        (analytical_descriptor_linked_to_study_record ?analytical_descriptor ?study_record)
        (not
          (study_platform_completed ?study_record)
        )
        (not
          (portfolio_item_vendor_constraints_verified ?development_portfolio_item)
        )
      )
    :effect (portfolio_item_vendor_constraints_verified ?development_portfolio_item)
  )
  (:action apply_vendor_constraints_to_portfolio_item_finalize
    :parameters (?development_portfolio_item - development_portfolio_item ?equipment_qualification - equipment_qualification ?process_expert - process_expert ?analytical_descriptor - analytical_descriptor ?study_record - study_record)
    :precondition
      (and
        (portfolio_item_initial_review_complete ?development_portfolio_item)
        (portfolio_item_has_equipment_qualification ?development_portfolio_item ?equipment_qualification)
        (item_assigned_process_expert ?development_portfolio_item ?process_expert)
        (portfolio_item_has_analytical_descriptor ?development_portfolio_item ?analytical_descriptor)
        (analytical_descriptor_linked_to_study_record ?analytical_descriptor ?study_record)
        (study_platform_completed ?study_record)
        (not
          (portfolio_item_vendor_constraints_verified ?development_portfolio_item)
        )
      )
    :effect (portfolio_item_vendor_constraints_verified ?development_portfolio_item)
  )
  (:action perform_risk_assessment_for_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?risk_descriptor - risk_descriptor ?analytical_descriptor - analytical_descriptor ?study_record - study_record)
    :precondition
      (and
        (portfolio_item_vendor_constraints_verified ?development_portfolio_item)
        (portfolio_item_has_risk_descriptor ?development_portfolio_item ?risk_descriptor)
        (portfolio_item_has_analytical_descriptor ?development_portfolio_item ?analytical_descriptor)
        (analytical_descriptor_linked_to_study_record ?analytical_descriptor ?study_record)
        (not
          (study_condition_completed ?study_record)
        )
        (not
          (study_platform_completed ?study_record)
        )
        (not
          (portfolio_item_risk_assessed ?development_portfolio_item)
        )
      )
    :effect (portfolio_item_risk_assessed ?development_portfolio_item)
  )
  (:action perform_risk_assessment_and_mark_ready_condition_flag
    :parameters (?development_portfolio_item - development_portfolio_item ?risk_descriptor - risk_descriptor ?analytical_descriptor - analytical_descriptor ?study_record - study_record)
    :precondition
      (and
        (portfolio_item_vendor_constraints_verified ?development_portfolio_item)
        (portfolio_item_has_risk_descriptor ?development_portfolio_item ?risk_descriptor)
        (portfolio_item_has_analytical_descriptor ?development_portfolio_item ?analytical_descriptor)
        (analytical_descriptor_linked_to_study_record ?analytical_descriptor ?study_record)
        (study_condition_completed ?study_record)
        (not
          (study_platform_completed ?study_record)
        )
        (not
          (portfolio_item_risk_assessed ?development_portfolio_item)
        )
      )
    :effect
      (and
        (portfolio_item_risk_assessed ?development_portfolio_item)
        (portfolio_item_ready_for_evaluation ?development_portfolio_item)
      )
  )
  (:action perform_risk_assessment_and_mark_ready_platform_flag
    :parameters (?development_portfolio_item - development_portfolio_item ?risk_descriptor - risk_descriptor ?analytical_descriptor - analytical_descriptor ?study_record - study_record)
    :precondition
      (and
        (portfolio_item_vendor_constraints_verified ?development_portfolio_item)
        (portfolio_item_has_risk_descriptor ?development_portfolio_item ?risk_descriptor)
        (portfolio_item_has_analytical_descriptor ?development_portfolio_item ?analytical_descriptor)
        (analytical_descriptor_linked_to_study_record ?analytical_descriptor ?study_record)
        (not
          (study_condition_completed ?study_record)
        )
        (study_platform_completed ?study_record)
        (not
          (portfolio_item_risk_assessed ?development_portfolio_item)
        )
      )
    :effect
      (and
        (portfolio_item_risk_assessed ?development_portfolio_item)
        (portfolio_item_ready_for_evaluation ?development_portfolio_item)
      )
  )
  (:action final_risk_assessment_and_mark_ready
    :parameters (?development_portfolio_item - development_portfolio_item ?risk_descriptor - risk_descriptor ?analytical_descriptor - analytical_descriptor ?study_record - study_record)
    :precondition
      (and
        (portfolio_item_vendor_constraints_verified ?development_portfolio_item)
        (portfolio_item_has_risk_descriptor ?development_portfolio_item ?risk_descriptor)
        (portfolio_item_has_analytical_descriptor ?development_portfolio_item ?analytical_descriptor)
        (analytical_descriptor_linked_to_study_record ?analytical_descriptor ?study_record)
        (study_condition_completed ?study_record)
        (study_platform_completed ?study_record)
        (not
          (portfolio_item_risk_assessed ?development_portfolio_item)
        )
      )
    :effect
      (and
        (portfolio_item_risk_assessed ?development_portfolio_item)
        (portfolio_item_ready_for_evaluation ?development_portfolio_item)
      )
  )
  (:action finalize_portfolio_item_evaluation
    :parameters (?development_portfolio_item - development_portfolio_item)
    :precondition
      (and
        (portfolio_item_risk_assessed ?development_portfolio_item)
        (not
          (portfolio_item_ready_for_evaluation ?development_portfolio_item)
        )
        (not
          (portfolio_item_finalized ?development_portfolio_item)
        )
      )
    :effect
      (and
        (portfolio_item_finalized ?development_portfolio_item)
        (evaluation_completed ?development_portfolio_item)
      )
  )
  (:action attach_acceptance_criterion_to_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?acceptance_criterion - acceptance_criterion)
    :precondition
      (and
        (portfolio_item_risk_assessed ?development_portfolio_item)
        (portfolio_item_ready_for_evaluation ?development_portfolio_item)
        (acceptance_criterion_available ?acceptance_criterion)
      )
    :effect
      (and
        (portfolio_item_has_acceptance_criterion ?development_portfolio_item ?acceptance_criterion)
        (not
          (acceptance_criterion_available ?acceptance_criterion)
        )
      )
  )
  (:action perform_portfolio_item_evaluation
    :parameters (?development_portfolio_item - development_portfolio_item ?lab_scale_variant - lab_scale_variant ?alternate_lab_variant - alternate_lab_variant ?analytical_method - analytical_method ?acceptance_criterion - acceptance_criterion)
    :precondition
      (and
        (portfolio_item_risk_assessed ?development_portfolio_item)
        (portfolio_item_ready_for_evaluation ?development_portfolio_item)
        (portfolio_item_has_acceptance_criterion ?development_portfolio_item ?acceptance_criterion)
        (portfolio_item_includes_lab_variant ?development_portfolio_item ?lab_scale_variant)
        (portfolio_item_includes_alt_lab_variant ?development_portfolio_item ?alternate_lab_variant)
        (lab_variant_ready_for_study ?lab_scale_variant)
        (alt_lab_variant_ready_for_study ?alternate_lab_variant)
        (item_assigned_method ?development_portfolio_item ?analytical_method)
        (not
          (portfolio_item_evaluation_in_progress ?development_portfolio_item)
        )
      )
    :effect (portfolio_item_evaluation_in_progress ?development_portfolio_item)
  )
  (:action complete_portfolio_item_evaluation
    :parameters (?development_portfolio_item - development_portfolio_item)
    :precondition
      (and
        (portfolio_item_risk_assessed ?development_portfolio_item)
        (portfolio_item_evaluation_in_progress ?development_portfolio_item)
        (not
          (portfolio_item_finalized ?development_portfolio_item)
        )
      )
    :effect
      (and
        (portfolio_item_finalized ?development_portfolio_item)
        (evaluation_completed ?development_portfolio_item)
      )
  )
  (:action acknowledge_vendor_constraint_for_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?vendor_constraint - vendor_constraint ?analytical_method - analytical_method)
    :precondition
      (and
        (item_ready_for_characterization ?development_portfolio_item)
        (item_assigned_method ?development_portfolio_item ?analytical_method)
        (vendor_constraint_available ?vendor_constraint)
        (portfolio_item_has_vendor_constraint ?development_portfolio_item ?vendor_constraint)
        (not
          (portfolio_item_vendor_constraint_acknowledged ?development_portfolio_item)
        )
      )
    :effect
      (and
        (portfolio_item_vendor_constraint_acknowledged ?development_portfolio_item)
        (not
          (vendor_constraint_available ?vendor_constraint)
        )
      )
  )
  (:action confirm_vendor_constraint_with_expert
    :parameters (?development_portfolio_item - development_portfolio_item ?process_expert - process_expert)
    :precondition
      (and
        (portfolio_item_vendor_constraint_acknowledged ?development_portfolio_item)
        (item_assigned_process_expert ?development_portfolio_item ?process_expert)
        (not
          (portfolio_item_vendor_constraint_confirmed ?development_portfolio_item)
        )
      )
    :effect (portfolio_item_vendor_constraint_confirmed ?development_portfolio_item)
  )
  (:action review_vendor_constraint_risk_for_portfolio_item
    :parameters (?development_portfolio_item - development_portfolio_item ?risk_descriptor - risk_descriptor)
    :precondition
      (and
        (portfolio_item_vendor_constraint_confirmed ?development_portfolio_item)
        (portfolio_item_has_risk_descriptor ?development_portfolio_item ?risk_descriptor)
        (not
          (portfolio_item_vendor_constraint_reviewed ?development_portfolio_item)
        )
      )
    :effect (portfolio_item_vendor_constraint_reviewed ?development_portfolio_item)
  )
  (:action finalize_vendor_constraint_review
    :parameters (?development_portfolio_item - development_portfolio_item)
    :precondition
      (and
        (portfolio_item_vendor_constraint_reviewed ?development_portfolio_item)
        (not
          (portfolio_item_finalized ?development_portfolio_item)
        )
      )
    :effect
      (and
        (portfolio_item_finalized ?development_portfolio_item)
        (evaluation_completed ?development_portfolio_item)
      )
  )
  (:action mark_lab_variant_as_evaluated
    :parameters (?lab_scale_variant - lab_scale_variant ?study_record - study_record)
    :precondition
      (and
        (lab_variant_prepared_for_study ?lab_scale_variant)
        (lab_variant_ready_for_study ?lab_scale_variant)
        (study_record_initiated ?study_record)
        (study_results_recorded ?study_record)
        (not
          (evaluation_completed ?lab_scale_variant)
        )
      )
    :effect (evaluation_completed ?lab_scale_variant)
  )
  (:action mark_alt_lab_variant_as_evaluated
    :parameters (?alternate_lab_variant - alternate_lab_variant ?study_record - study_record)
    :precondition
      (and
        (alt_lab_variant_prepared_for_study ?alternate_lab_variant)
        (alt_lab_variant_ready_for_study ?alternate_lab_variant)
        (study_record_initiated ?study_record)
        (study_results_recorded ?study_record)
        (not
          (evaluation_completed ?alternate_lab_variant)
        )
      )
    :effect (evaluation_completed ?alternate_lab_variant)
  )
  (:action attach_evidence_artifact_to_variant
    :parameters (?formulation_variant - formulation_variant ?evidence_artifact - evidence_artifact ?analytical_method - analytical_method)
    :precondition
      (and
        (evaluation_completed ?formulation_variant)
        (item_assigned_method ?formulation_variant ?analytical_method)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (item_has_evidence ?formulation_variant)
        )
      )
    :effect
      (and
        (item_has_evidence ?formulation_variant)
        (item_linked_evidence_artifact ?formulation_variant ?evidence_artifact)
        (not
          (evidence_artifact_available ?evidence_artifact)
        )
      )
  )
  (:action select_lab_variant_for_development
    :parameters (?lab_scale_variant - lab_scale_variant ?resource_slot - resource_slot ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (item_has_evidence ?lab_scale_variant)
        (item_allocated_to_resource_slot ?lab_scale_variant ?resource_slot)
        (item_linked_evidence_artifact ?lab_scale_variant ?evidence_artifact)
        (not
          (item_selected ?lab_scale_variant)
        )
      )
    :effect
      (and
        (item_selected ?lab_scale_variant)
        (resource_slot_available ?resource_slot)
        (evidence_artifact_available ?evidence_artifact)
      )
  )
  (:action select_alt_lab_variant_for_development
    :parameters (?alternate_lab_variant - alternate_lab_variant ?resource_slot - resource_slot ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (item_has_evidence ?alternate_lab_variant)
        (item_allocated_to_resource_slot ?alternate_lab_variant ?resource_slot)
        (item_linked_evidence_artifact ?alternate_lab_variant ?evidence_artifact)
        (not
          (item_selected ?alternate_lab_variant)
        )
      )
    :effect
      (and
        (item_selected ?alternate_lab_variant)
        (resource_slot_available ?resource_slot)
        (evidence_artifact_available ?evidence_artifact)
      )
  )
  (:action select_portfolio_item_for_development
    :parameters (?development_portfolio_item - development_portfolio_item ?resource_slot - resource_slot ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (item_has_evidence ?development_portfolio_item)
        (item_allocated_to_resource_slot ?development_portfolio_item ?resource_slot)
        (item_linked_evidence_artifact ?development_portfolio_item ?evidence_artifact)
        (not
          (item_selected ?development_portfolio_item)
        )
      )
    :effect
      (and
        (item_selected ?development_portfolio_item)
        (resource_slot_available ?resource_slot)
        (evidence_artifact_available ?evidence_artifact)
      )
  )
)

(define (domain pharmaceutics_scaleup_feasibility_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_supertype - object document_supertype - object experiment_supertype - object case_supertype - object development_item - case_supertype equipment_resource - resource_supertype analytical_assay - resource_supertype subject_matter_expert - resource_supertype regulatory_requirement - resource_supertype quality_attribute - resource_supertype evidence_artifact - resource_supertype critical_process_parameter - resource_supertype supplier_qualification_record - resource_supertype material_sample_document - document_supertype stability_study_protocol - document_supertype executive_approval_record - document_supertype lab_scale_experiment - experiment_supertype pilot_scale_experiment - experiment_supertype process_fit_document - experiment_supertype formulation_stream - development_item development_stream - development_item formulation_variant - formulation_stream process_prototype - formulation_stream scaleup_feasibility_case - development_stream)
  (:predicates
    (development_item_registered ?development_item - development_item)
    (assay_assignment_confirmed ?development_item - development_item)
    (equipment_allocated ?development_item - development_item)
    (approved_for_scale_up ?development_item - development_item)
    (review_package_finalized ?development_item - development_item)
    (final_readiness_confirmed ?development_item - development_item)
    (equipment_available ?equipment_resource - equipment_resource)
    (development_item_allocated_to_equipment ?development_item - development_item ?equipment_resource - equipment_resource)
    (assay_available ?analytical_assay - analytical_assay)
    (assay_assigned_to_development_item ?development_item - development_item ?analytical_assay - analytical_assay)
    (sme_available ?subject_matter_expert - subject_matter_expert)
    (subject_matter_expert_assigned_to_development_item ?development_item - development_item ?subject_matter_expert - subject_matter_expert)
    (sample_available ?material_sample - material_sample_document)
    (formulation_variant_has_sample ?formulation_variant - formulation_variant ?material_sample - material_sample_document)
    (process_prototype_has_sample ?process_prototype - process_prototype ?material_sample - material_sample_document)
    (formulation_assigned_to_lab_experiment ?formulation_variant - formulation_variant ?lab_scale_experiment - lab_scale_experiment)
    (lab_experiment_completed ?lab_scale_experiment - lab_scale_experiment)
    (lab_experiment_sample_assigned ?lab_scale_experiment - lab_scale_experiment)
    (formulation_variant_experiment_result_recorded ?formulation_variant - formulation_variant)
    (process_prototype_assigned_to_pilot_experiment ?process_prototype - process_prototype ?pilot_scale_experiment - pilot_scale_experiment)
    (pilot_experiment_completed ?pilot_scale_experiment - pilot_scale_experiment)
    (pilot_experiment_sample_assigned ?pilot_scale_experiment - pilot_scale_experiment)
    (process_prototype_experiment_result_recorded ?process_prototype - process_prototype)
    (process_fit_document_ready_for_compilation ?process_fit_report - process_fit_document)
    (process_fit_document_compiled ?process_fit_report - process_fit_document)
    (process_fit_document_includes_lab_experiment ?process_fit_report - process_fit_document ?lab_scale_experiment - lab_scale_experiment)
    (process_fit_document_includes_pilot_experiment ?process_fit_report - process_fit_document ?pilot_scale_experiment - pilot_scale_experiment)
    (process_fit_document_lab_evidence_marker ?process_fit_report - process_fit_document)
    (process_fit_document_pilot_evidence_marker ?process_fit_report - process_fit_document)
    (process_fit_document_validated ?process_fit_report - process_fit_document)
    (development_item_includes_formulation_variant ?scaleup_feasibility_case - scaleup_feasibility_case ?formulation_variant - formulation_variant)
    (development_item_includes_process_prototype ?scaleup_feasibility_case - scaleup_feasibility_case ?process_prototype - process_prototype)
    (development_item_includes_process_fit_document ?scaleup_feasibility_case - scaleup_feasibility_case ?process_fit_report - process_fit_document)
    (stability_protocol_available ?stability_study_protocol - stability_study_protocol)
    (development_item_includes_stability_protocol ?scaleup_feasibility_case - scaleup_feasibility_case ?stability_study_protocol - stability_study_protocol)
    (stability_protocol_activated ?stability_study_protocol - stability_study_protocol)
    (stability_protocol_linked_to_process_fit_document ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document)
    (stability_execution_ready ?scaleup_feasibility_case - scaleup_feasibility_case)
    (stability_execution_started ?scaleup_feasibility_case - scaleup_feasibility_case)
    (stability_execution_completed ?scaleup_feasibility_case - scaleup_feasibility_case)
    (regulatory_requirement_attached_to_development_item ?scaleup_feasibility_case - scaleup_feasibility_case)
    (regulatory_requirement_acknowledged ?scaleup_feasibility_case - scaleup_feasibility_case)
    (stability_results_verified ?scaleup_feasibility_case - scaleup_feasibility_case)
    (review_package_assembled ?scaleup_feasibility_case - scaleup_feasibility_case)
    (executive_approval_available ?executive_approval_record - executive_approval_record)
    (development_item_has_executive_approval_record ?scaleup_feasibility_case - scaleup_feasibility_case ?executive_approval_record - executive_approval_record)
    (executive_approval_attached ?scaleup_feasibility_case - scaleup_feasibility_case)
    (development_item_approval_in_review ?scaleup_feasibility_case - scaleup_feasibility_case)
    (development_item_approval_confirmed ?scaleup_feasibility_case - scaleup_feasibility_case)
    (regulatory_requirement_available ?regulatory_requirement - regulatory_requirement)
    (development_item_has_regulatory_requirement ?scaleup_feasibility_case - scaleup_feasibility_case ?regulatory_requirement - regulatory_requirement)
    (quality_attribute_available ?quality_attribute - quality_attribute)
    (development_item_has_quality_attribute ?scaleup_feasibility_case - scaleup_feasibility_case ?quality_attribute - quality_attribute)
    (critical_process_parameter_available ?critical_process_parameter - critical_process_parameter)
    (development_item_has_critical_process_parameter ?scaleup_feasibility_case - scaleup_feasibility_case ?critical_process_parameter - critical_process_parameter)
    (supplier_qualification_available ?supplier_qualification_record - supplier_qualification_record)
    (development_item_has_supplier_qualification_record ?scaleup_feasibility_case - scaleup_feasibility_case ?supplier_qualification_record - supplier_qualification_record)
    (evidence_artifact_available ?evidence_artifact - evidence_artifact)
    (development_item_linked_to_evidence_artifact ?development_item - development_item ?evidence_artifact - evidence_artifact)
    (formulation_variant_ready_for_integration ?formulation_variant - formulation_variant)
    (process_prototype_ready_for_integration ?process_prototype - process_prototype)
    (development_item_finalization_marker ?scaleup_feasibility_case - scaleup_feasibility_case)
  )
  (:action register_development_item
    :parameters (?development_item - development_item)
    :precondition
      (and
        (not
          (development_item_registered ?development_item)
        )
        (not
          (approved_for_scale_up ?development_item)
        )
      )
    :effect (development_item_registered ?development_item)
  )
  (:action allocate_equipment_to_development_item
    :parameters (?development_item - development_item ?equipment_resource - equipment_resource)
    :precondition
      (and
        (development_item_registered ?development_item)
        (not
          (equipment_allocated ?development_item)
        )
        (equipment_available ?equipment_resource)
      )
    :effect
      (and
        (equipment_allocated ?development_item)
        (development_item_allocated_to_equipment ?development_item ?equipment_resource)
        (not
          (equipment_available ?equipment_resource)
        )
      )
  )
  (:action assign_assay_to_development_item
    :parameters (?development_item - development_item ?analytical_assay - analytical_assay)
    :precondition
      (and
        (development_item_registered ?development_item)
        (equipment_allocated ?development_item)
        (assay_available ?analytical_assay)
      )
    :effect
      (and
        (assay_assigned_to_development_item ?development_item ?analytical_assay)
        (not
          (assay_available ?analytical_assay)
        )
      )
  )
  (:action finalize_assay_assignment
    :parameters (?development_item - development_item ?analytical_assay - analytical_assay)
    :precondition
      (and
        (development_item_registered ?development_item)
        (equipment_allocated ?development_item)
        (assay_assigned_to_development_item ?development_item ?analytical_assay)
        (not
          (assay_assignment_confirmed ?development_item)
        )
      )
    :effect (assay_assignment_confirmed ?development_item)
  )
  (:action release_assay
    :parameters (?development_item - development_item ?analytical_assay - analytical_assay)
    :precondition
      (and
        (assay_assigned_to_development_item ?development_item ?analytical_assay)
      )
    :effect
      (and
        (assay_available ?analytical_assay)
        (not
          (assay_assigned_to_development_item ?development_item ?analytical_assay)
        )
      )
  )
  (:action assign_subject_matter_expert_to_development_item
    :parameters (?development_item - development_item ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (assay_assignment_confirmed ?development_item)
        (sme_available ?subject_matter_expert)
      )
    :effect
      (and
        (subject_matter_expert_assigned_to_development_item ?development_item ?subject_matter_expert)
        (not
          (sme_available ?subject_matter_expert)
        )
      )
  )
  (:action release_sme
    :parameters (?development_item - development_item ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (subject_matter_expert_assigned_to_development_item ?development_item ?subject_matter_expert)
      )
    :effect
      (and
        (sme_available ?subject_matter_expert)
        (not
          (subject_matter_expert_assigned_to_development_item ?development_item ?subject_matter_expert)
        )
      )
  )
  (:action capture_critical_process_parameter_into_development_item
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?critical_process_parameter - critical_process_parameter)
    :precondition
      (and
        (assay_assignment_confirmed ?scaleup_feasibility_case)
        (critical_process_parameter_available ?critical_process_parameter)
      )
    :effect
      (and
        (development_item_has_critical_process_parameter ?scaleup_feasibility_case ?critical_process_parameter)
        (not
          (critical_process_parameter_available ?critical_process_parameter)
        )
      )
  )
  (:action detach_critical_process_parameter_from_development_item
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?critical_process_parameter - critical_process_parameter)
    :precondition
      (and
        (development_item_has_critical_process_parameter ?scaleup_feasibility_case ?critical_process_parameter)
      )
    :effect
      (and
        (critical_process_parameter_available ?critical_process_parameter)
        (not
          (development_item_has_critical_process_parameter ?scaleup_feasibility_case ?critical_process_parameter)
        )
      )
  )
  (:action attach_supplier_qualification_to_development_item
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?supplier_qualification_record - supplier_qualification_record)
    :precondition
      (and
        (assay_assignment_confirmed ?scaleup_feasibility_case)
        (supplier_qualification_available ?supplier_qualification_record)
      )
    :effect
      (and
        (development_item_has_supplier_qualification_record ?scaleup_feasibility_case ?supplier_qualification_record)
        (not
          (supplier_qualification_available ?supplier_qualification_record)
        )
      )
  )
  (:action detach_supplier_qualification_from_development_item
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?supplier_qualification_record - supplier_qualification_record)
    :precondition
      (and
        (development_item_has_supplier_qualification_record ?scaleup_feasibility_case ?supplier_qualification_record)
      )
    :effect
      (and
        (supplier_qualification_available ?supplier_qualification_record)
        (not
          (development_item_has_supplier_qualification_record ?scaleup_feasibility_case ?supplier_qualification_record)
        )
      )
  )
  (:action mark_lab_experiment_completed
    :parameters (?formulation_variant - formulation_variant ?lab_scale_experiment - lab_scale_experiment ?analytical_assay - analytical_assay)
    :precondition
      (and
        (assay_assignment_confirmed ?formulation_variant)
        (assay_assigned_to_development_item ?formulation_variant ?analytical_assay)
        (formulation_assigned_to_lab_experiment ?formulation_variant ?lab_scale_experiment)
        (not
          (lab_experiment_completed ?lab_scale_experiment)
        )
        (not
          (lab_experiment_sample_assigned ?lab_scale_experiment)
        )
      )
    :effect (lab_experiment_completed ?lab_scale_experiment)
  )
  (:action sme_review_lab_experiment_results
    :parameters (?formulation_variant - formulation_variant ?lab_scale_experiment - lab_scale_experiment ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (assay_assignment_confirmed ?formulation_variant)
        (subject_matter_expert_assigned_to_development_item ?formulation_variant ?subject_matter_expert)
        (formulation_assigned_to_lab_experiment ?formulation_variant ?lab_scale_experiment)
        (lab_experiment_completed ?lab_scale_experiment)
        (not
          (formulation_variant_ready_for_integration ?formulation_variant)
        )
      )
    :effect
      (and
        (formulation_variant_ready_for_integration ?formulation_variant)
        (formulation_variant_experiment_result_recorded ?formulation_variant)
      )
  )
  (:action create_sample_from_lab_experiment
    :parameters (?formulation_variant - formulation_variant ?lab_scale_experiment - lab_scale_experiment ?material_sample - material_sample_document)
    :precondition
      (and
        (assay_assignment_confirmed ?formulation_variant)
        (formulation_assigned_to_lab_experiment ?formulation_variant ?lab_scale_experiment)
        (sample_available ?material_sample)
        (not
          (formulation_variant_ready_for_integration ?formulation_variant)
        )
      )
    :effect
      (and
        (lab_experiment_sample_assigned ?lab_scale_experiment)
        (formulation_variant_ready_for_integration ?formulation_variant)
        (formulation_variant_has_sample ?formulation_variant ?material_sample)
        (not
          (sample_available ?material_sample)
        )
      )
  )
  (:action process_lab_sample_and_record_results
    :parameters (?formulation_variant - formulation_variant ?lab_scale_experiment - lab_scale_experiment ?analytical_assay - analytical_assay ?material_sample - material_sample_document)
    :precondition
      (and
        (assay_assignment_confirmed ?formulation_variant)
        (assay_assigned_to_development_item ?formulation_variant ?analytical_assay)
        (formulation_assigned_to_lab_experiment ?formulation_variant ?lab_scale_experiment)
        (lab_experiment_sample_assigned ?lab_scale_experiment)
        (formulation_variant_has_sample ?formulation_variant ?material_sample)
        (not
          (formulation_variant_experiment_result_recorded ?formulation_variant)
        )
      )
    :effect
      (and
        (lab_experiment_completed ?lab_scale_experiment)
        (formulation_variant_experiment_result_recorded ?formulation_variant)
        (sample_available ?material_sample)
        (not
          (formulation_variant_has_sample ?formulation_variant ?material_sample)
        )
      )
  )
  (:action mark_pilot_experiment_completed
    :parameters (?process_prototype - process_prototype ?pilot_scale_experiment - pilot_scale_experiment ?analytical_assay - analytical_assay)
    :precondition
      (and
        (assay_assignment_confirmed ?process_prototype)
        (assay_assigned_to_development_item ?process_prototype ?analytical_assay)
        (process_prototype_assigned_to_pilot_experiment ?process_prototype ?pilot_scale_experiment)
        (not
          (pilot_experiment_completed ?pilot_scale_experiment)
        )
        (not
          (pilot_experiment_sample_assigned ?pilot_scale_experiment)
        )
      )
    :effect (pilot_experiment_completed ?pilot_scale_experiment)
  )
  (:action sme_review_pilot_experiment_results
    :parameters (?process_prototype - process_prototype ?pilot_scale_experiment - pilot_scale_experiment ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (assay_assignment_confirmed ?process_prototype)
        (subject_matter_expert_assigned_to_development_item ?process_prototype ?subject_matter_expert)
        (process_prototype_assigned_to_pilot_experiment ?process_prototype ?pilot_scale_experiment)
        (pilot_experiment_completed ?pilot_scale_experiment)
        (not
          (process_prototype_ready_for_integration ?process_prototype)
        )
      )
    :effect
      (and
        (process_prototype_ready_for_integration ?process_prototype)
        (process_prototype_experiment_result_recorded ?process_prototype)
      )
  )
  (:action create_sample_from_pilot_experiment
    :parameters (?process_prototype - process_prototype ?pilot_scale_experiment - pilot_scale_experiment ?material_sample - material_sample_document)
    :precondition
      (and
        (assay_assignment_confirmed ?process_prototype)
        (process_prototype_assigned_to_pilot_experiment ?process_prototype ?pilot_scale_experiment)
        (sample_available ?material_sample)
        (not
          (process_prototype_ready_for_integration ?process_prototype)
        )
      )
    :effect
      (and
        (pilot_experiment_sample_assigned ?pilot_scale_experiment)
        (process_prototype_ready_for_integration ?process_prototype)
        (process_prototype_has_sample ?process_prototype ?material_sample)
        (not
          (sample_available ?material_sample)
        )
      )
  )
  (:action process_pilot_sample_and_record_results
    :parameters (?process_prototype - process_prototype ?pilot_scale_experiment - pilot_scale_experiment ?analytical_assay - analytical_assay ?material_sample - material_sample_document)
    :precondition
      (and
        (assay_assignment_confirmed ?process_prototype)
        (assay_assigned_to_development_item ?process_prototype ?analytical_assay)
        (process_prototype_assigned_to_pilot_experiment ?process_prototype ?pilot_scale_experiment)
        (pilot_experiment_sample_assigned ?pilot_scale_experiment)
        (process_prototype_has_sample ?process_prototype ?material_sample)
        (not
          (process_prototype_experiment_result_recorded ?process_prototype)
        )
      )
    :effect
      (and
        (pilot_experiment_completed ?pilot_scale_experiment)
        (process_prototype_experiment_result_recorded ?process_prototype)
        (sample_available ?material_sample)
        (not
          (process_prototype_has_sample ?process_prototype ?material_sample)
        )
      )
  )
  (:action generate_process_fit_document
    :parameters (?formulation_variant - formulation_variant ?process_prototype - process_prototype ?lab_scale_experiment - lab_scale_experiment ?pilot_scale_experiment - pilot_scale_experiment ?process_fit_report - process_fit_document)
    :precondition
      (and
        (formulation_variant_ready_for_integration ?formulation_variant)
        (process_prototype_ready_for_integration ?process_prototype)
        (formulation_assigned_to_lab_experiment ?formulation_variant ?lab_scale_experiment)
        (process_prototype_assigned_to_pilot_experiment ?process_prototype ?pilot_scale_experiment)
        (lab_experiment_completed ?lab_scale_experiment)
        (pilot_experiment_completed ?pilot_scale_experiment)
        (formulation_variant_experiment_result_recorded ?formulation_variant)
        (process_prototype_experiment_result_recorded ?process_prototype)
        (process_fit_document_ready_for_compilation ?process_fit_report)
      )
    :effect
      (and
        (process_fit_document_compiled ?process_fit_report)
        (process_fit_document_includes_lab_experiment ?process_fit_report ?lab_scale_experiment)
        (process_fit_document_includes_pilot_experiment ?process_fit_report ?pilot_scale_experiment)
        (not
          (process_fit_document_ready_for_compilation ?process_fit_report)
        )
      )
  )
  (:action generate_process_fit_document_with_lab_evidence_marker
    :parameters (?formulation_variant - formulation_variant ?process_prototype - process_prototype ?lab_scale_experiment - lab_scale_experiment ?pilot_scale_experiment - pilot_scale_experiment ?process_fit_report - process_fit_document)
    :precondition
      (and
        (formulation_variant_ready_for_integration ?formulation_variant)
        (process_prototype_ready_for_integration ?process_prototype)
        (formulation_assigned_to_lab_experiment ?formulation_variant ?lab_scale_experiment)
        (process_prototype_assigned_to_pilot_experiment ?process_prototype ?pilot_scale_experiment)
        (lab_experiment_sample_assigned ?lab_scale_experiment)
        (pilot_experiment_completed ?pilot_scale_experiment)
        (not
          (formulation_variant_experiment_result_recorded ?formulation_variant)
        )
        (process_prototype_experiment_result_recorded ?process_prototype)
        (process_fit_document_ready_for_compilation ?process_fit_report)
      )
    :effect
      (and
        (process_fit_document_compiled ?process_fit_report)
        (process_fit_document_includes_lab_experiment ?process_fit_report ?lab_scale_experiment)
        (process_fit_document_includes_pilot_experiment ?process_fit_report ?pilot_scale_experiment)
        (process_fit_document_lab_evidence_marker ?process_fit_report)
        (not
          (process_fit_document_ready_for_compilation ?process_fit_report)
        )
      )
  )
  (:action generate_process_fit_document_with_pilot_evidence_marker
    :parameters (?formulation_variant - formulation_variant ?process_prototype - process_prototype ?lab_scale_experiment - lab_scale_experiment ?pilot_scale_experiment - pilot_scale_experiment ?process_fit_report - process_fit_document)
    :precondition
      (and
        (formulation_variant_ready_for_integration ?formulation_variant)
        (process_prototype_ready_for_integration ?process_prototype)
        (formulation_assigned_to_lab_experiment ?formulation_variant ?lab_scale_experiment)
        (process_prototype_assigned_to_pilot_experiment ?process_prototype ?pilot_scale_experiment)
        (lab_experiment_completed ?lab_scale_experiment)
        (pilot_experiment_sample_assigned ?pilot_scale_experiment)
        (formulation_variant_experiment_result_recorded ?formulation_variant)
        (not
          (process_prototype_experiment_result_recorded ?process_prototype)
        )
        (process_fit_document_ready_for_compilation ?process_fit_report)
      )
    :effect
      (and
        (process_fit_document_compiled ?process_fit_report)
        (process_fit_document_includes_lab_experiment ?process_fit_report ?lab_scale_experiment)
        (process_fit_document_includes_pilot_experiment ?process_fit_report ?pilot_scale_experiment)
        (process_fit_document_pilot_evidence_marker ?process_fit_report)
        (not
          (process_fit_document_ready_for_compilation ?process_fit_report)
        )
      )
  )
  (:action generate_process_fit_document_with_lab_and_pilot_evidence_markers
    :parameters (?formulation_variant - formulation_variant ?process_prototype - process_prototype ?lab_scale_experiment - lab_scale_experiment ?pilot_scale_experiment - pilot_scale_experiment ?process_fit_report - process_fit_document)
    :precondition
      (and
        (formulation_variant_ready_for_integration ?formulation_variant)
        (process_prototype_ready_for_integration ?process_prototype)
        (formulation_assigned_to_lab_experiment ?formulation_variant ?lab_scale_experiment)
        (process_prototype_assigned_to_pilot_experiment ?process_prototype ?pilot_scale_experiment)
        (lab_experiment_sample_assigned ?lab_scale_experiment)
        (pilot_experiment_sample_assigned ?pilot_scale_experiment)
        (not
          (formulation_variant_experiment_result_recorded ?formulation_variant)
        )
        (not
          (process_prototype_experiment_result_recorded ?process_prototype)
        )
        (process_fit_document_ready_for_compilation ?process_fit_report)
      )
    :effect
      (and
        (process_fit_document_compiled ?process_fit_report)
        (process_fit_document_includes_lab_experiment ?process_fit_report ?lab_scale_experiment)
        (process_fit_document_includes_pilot_experiment ?process_fit_report ?pilot_scale_experiment)
        (process_fit_document_lab_evidence_marker ?process_fit_report)
        (process_fit_document_pilot_evidence_marker ?process_fit_report)
        (not
          (process_fit_document_ready_for_compilation ?process_fit_report)
        )
      )
  )
  (:action validate_process_fit_document
    :parameters (?process_fit_report - process_fit_document ?formulation_variant - formulation_variant ?analytical_assay - analytical_assay)
    :precondition
      (and
        (process_fit_document_compiled ?process_fit_report)
        (formulation_variant_ready_for_integration ?formulation_variant)
        (assay_assigned_to_development_item ?formulation_variant ?analytical_assay)
        (not
          (process_fit_document_validated ?process_fit_report)
        )
      )
    :effect (process_fit_document_validated ?process_fit_report)
  )
  (:action activate_stability_protocol_for_development_item
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document)
    :precondition
      (and
        (assay_assignment_confirmed ?scaleup_feasibility_case)
        (development_item_includes_process_fit_document ?scaleup_feasibility_case ?process_fit_report)
        (development_item_includes_stability_protocol ?scaleup_feasibility_case ?stability_study_protocol)
        (stability_protocol_available ?stability_study_protocol)
        (process_fit_document_compiled ?process_fit_report)
        (process_fit_document_validated ?process_fit_report)
        (not
          (stability_protocol_activated ?stability_study_protocol)
        )
      )
    :effect
      (and
        (stability_protocol_activated ?stability_study_protocol)
        (stability_protocol_linked_to_process_fit_document ?stability_study_protocol ?process_fit_report)
        (not
          (stability_protocol_available ?stability_study_protocol)
        )
      )
  )
  (:action initiate_stability_protocol_execution
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document ?analytical_assay - analytical_assay)
    :precondition
      (and
        (assay_assignment_confirmed ?scaleup_feasibility_case)
        (development_item_includes_stability_protocol ?scaleup_feasibility_case ?stability_study_protocol)
        (stability_protocol_activated ?stability_study_protocol)
        (stability_protocol_linked_to_process_fit_document ?stability_study_protocol ?process_fit_report)
        (assay_assigned_to_development_item ?scaleup_feasibility_case ?analytical_assay)
        (not
          (process_fit_document_lab_evidence_marker ?process_fit_report)
        )
        (not
          (stability_execution_ready ?scaleup_feasibility_case)
        )
      )
    :effect (stability_execution_ready ?scaleup_feasibility_case)
  )
  (:action attach_regulatory_requirement_to_development_item
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?regulatory_requirement - regulatory_requirement)
    :precondition
      (and
        (assay_assignment_confirmed ?scaleup_feasibility_case)
        (regulatory_requirement_available ?regulatory_requirement)
        (not
          (regulatory_requirement_attached_to_development_item ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (regulatory_requirement_attached_to_development_item ?scaleup_feasibility_case)
        (development_item_has_regulatory_requirement ?scaleup_feasibility_case ?regulatory_requirement)
        (not
          (regulatory_requirement_available ?regulatory_requirement)
        )
      )
  )
  (:action acknowledge_regulatory_requirement_and_prepare_stability_execution
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document ?analytical_assay - analytical_assay ?regulatory_requirement - regulatory_requirement)
    :precondition
      (and
        (assay_assignment_confirmed ?scaleup_feasibility_case)
        (development_item_includes_stability_protocol ?scaleup_feasibility_case ?stability_study_protocol)
        (stability_protocol_activated ?stability_study_protocol)
        (stability_protocol_linked_to_process_fit_document ?stability_study_protocol ?process_fit_report)
        (assay_assigned_to_development_item ?scaleup_feasibility_case ?analytical_assay)
        (process_fit_document_lab_evidence_marker ?process_fit_report)
        (regulatory_requirement_attached_to_development_item ?scaleup_feasibility_case)
        (development_item_has_regulatory_requirement ?scaleup_feasibility_case ?regulatory_requirement)
        (not
          (stability_execution_ready ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (stability_execution_ready ?scaleup_feasibility_case)
        (regulatory_requirement_acknowledged ?scaleup_feasibility_case)
      )
  )
  (:action start_stability_execution
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?critical_process_parameter - critical_process_parameter ?subject_matter_expert - subject_matter_expert ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document)
    :precondition
      (and
        (stability_execution_ready ?scaleup_feasibility_case)
        (development_item_has_critical_process_parameter ?scaleup_feasibility_case ?critical_process_parameter)
        (subject_matter_expert_assigned_to_development_item ?scaleup_feasibility_case ?subject_matter_expert)
        (development_item_includes_stability_protocol ?scaleup_feasibility_case ?stability_study_protocol)
        (stability_protocol_linked_to_process_fit_document ?stability_study_protocol ?process_fit_report)
        (not
          (process_fit_document_pilot_evidence_marker ?process_fit_report)
        )
        (not
          (stability_execution_started ?scaleup_feasibility_case)
        )
      )
    :effect (stability_execution_started ?scaleup_feasibility_case)
  )
  (:action start_stability_execution_with_pilot_evidence
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?critical_process_parameter - critical_process_parameter ?subject_matter_expert - subject_matter_expert ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document)
    :precondition
      (and
        (stability_execution_ready ?scaleup_feasibility_case)
        (development_item_has_critical_process_parameter ?scaleup_feasibility_case ?critical_process_parameter)
        (subject_matter_expert_assigned_to_development_item ?scaleup_feasibility_case ?subject_matter_expert)
        (development_item_includes_stability_protocol ?scaleup_feasibility_case ?stability_study_protocol)
        (stability_protocol_linked_to_process_fit_document ?stability_study_protocol ?process_fit_report)
        (process_fit_document_pilot_evidence_marker ?process_fit_report)
        (not
          (stability_execution_started ?scaleup_feasibility_case)
        )
      )
    :effect (stability_execution_started ?scaleup_feasibility_case)
  )
  (:action complete_stability_execution
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?supplier_qualification_record - supplier_qualification_record ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document)
    :precondition
      (and
        (stability_execution_started ?scaleup_feasibility_case)
        (development_item_has_supplier_qualification_record ?scaleup_feasibility_case ?supplier_qualification_record)
        (development_item_includes_stability_protocol ?scaleup_feasibility_case ?stability_study_protocol)
        (stability_protocol_linked_to_process_fit_document ?stability_study_protocol ?process_fit_report)
        (not
          (process_fit_document_lab_evidence_marker ?process_fit_report)
        )
        (not
          (process_fit_document_pilot_evidence_marker ?process_fit_report)
        )
        (not
          (stability_execution_completed ?scaleup_feasibility_case)
        )
      )
    :effect (stability_execution_completed ?scaleup_feasibility_case)
  )
  (:action complete_stability_execution_and_verify_results
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?supplier_qualification_record - supplier_qualification_record ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document)
    :precondition
      (and
        (stability_execution_started ?scaleup_feasibility_case)
        (development_item_has_supplier_qualification_record ?scaleup_feasibility_case ?supplier_qualification_record)
        (development_item_includes_stability_protocol ?scaleup_feasibility_case ?stability_study_protocol)
        (stability_protocol_linked_to_process_fit_document ?stability_study_protocol ?process_fit_report)
        (process_fit_document_lab_evidence_marker ?process_fit_report)
        (not
          (process_fit_document_pilot_evidence_marker ?process_fit_report)
        )
        (not
          (stability_execution_completed ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (stability_execution_completed ?scaleup_feasibility_case)
        (stability_results_verified ?scaleup_feasibility_case)
      )
  )
  (:action complete_stability_execution_and_verify_results_with_pilot_marker
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?supplier_qualification_record - supplier_qualification_record ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document)
    :precondition
      (and
        (stability_execution_started ?scaleup_feasibility_case)
        (development_item_has_supplier_qualification_record ?scaleup_feasibility_case ?supplier_qualification_record)
        (development_item_includes_stability_protocol ?scaleup_feasibility_case ?stability_study_protocol)
        (stability_protocol_linked_to_process_fit_document ?stability_study_protocol ?process_fit_report)
        (not
          (process_fit_document_lab_evidence_marker ?process_fit_report)
        )
        (process_fit_document_pilot_evidence_marker ?process_fit_report)
        (not
          (stability_execution_completed ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (stability_execution_completed ?scaleup_feasibility_case)
        (stability_results_verified ?scaleup_feasibility_case)
      )
  )
  (:action complete_stability_execution_and_verify_results_with_both_markers
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?supplier_qualification_record - supplier_qualification_record ?stability_study_protocol - stability_study_protocol ?process_fit_report - process_fit_document)
    :precondition
      (and
        (stability_execution_started ?scaleup_feasibility_case)
        (development_item_has_supplier_qualification_record ?scaleup_feasibility_case ?supplier_qualification_record)
        (development_item_includes_stability_protocol ?scaleup_feasibility_case ?stability_study_protocol)
        (stability_protocol_linked_to_process_fit_document ?stability_study_protocol ?process_fit_report)
        (process_fit_document_lab_evidence_marker ?process_fit_report)
        (process_fit_document_pilot_evidence_marker ?process_fit_report)
        (not
          (stability_execution_completed ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (stability_execution_completed ?scaleup_feasibility_case)
        (stability_results_verified ?scaleup_feasibility_case)
      )
  )
  (:action finalize_development_item_review
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case)
    :precondition
      (and
        (stability_execution_completed ?scaleup_feasibility_case)
        (not
          (stability_results_verified ?scaleup_feasibility_case)
        )
        (not
          (development_item_finalization_marker ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (development_item_finalization_marker ?scaleup_feasibility_case)
        (review_package_finalized ?scaleup_feasibility_case)
      )
  )
  (:action associate_quality_attribute_with_case
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?quality_attribute - quality_attribute)
    :precondition
      (and
        (stability_execution_completed ?scaleup_feasibility_case)
        (stability_results_verified ?scaleup_feasibility_case)
        (quality_attribute_available ?quality_attribute)
      )
    :effect
      (and
        (development_item_has_quality_attribute ?scaleup_feasibility_case ?quality_attribute)
        (not
          (quality_attribute_available ?quality_attribute)
        )
      )
  )
  (:action assemble_review_package
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?formulation_variant - formulation_variant ?process_prototype - process_prototype ?analytical_assay - analytical_assay ?quality_attribute - quality_attribute)
    :precondition
      (and
        (stability_execution_completed ?scaleup_feasibility_case)
        (stability_results_verified ?scaleup_feasibility_case)
        (development_item_has_quality_attribute ?scaleup_feasibility_case ?quality_attribute)
        (development_item_includes_formulation_variant ?scaleup_feasibility_case ?formulation_variant)
        (development_item_includes_process_prototype ?scaleup_feasibility_case ?process_prototype)
        (formulation_variant_experiment_result_recorded ?formulation_variant)
        (process_prototype_experiment_result_recorded ?process_prototype)
        (assay_assigned_to_development_item ?scaleup_feasibility_case ?analytical_assay)
        (not
          (review_package_assembled ?scaleup_feasibility_case)
        )
      )
    :effect (review_package_assembled ?scaleup_feasibility_case)
  )
  (:action finalize_development_item_review_post_assembly
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case)
    :precondition
      (and
        (stability_execution_completed ?scaleup_feasibility_case)
        (review_package_assembled ?scaleup_feasibility_case)
        (not
          (development_item_finalization_marker ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (development_item_finalization_marker ?scaleup_feasibility_case)
        (review_package_finalized ?scaleup_feasibility_case)
      )
  )
  (:action attach_executive_approval_to_development_item
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?executive_approval_record - executive_approval_record ?analytical_assay - analytical_assay)
    :precondition
      (and
        (assay_assignment_confirmed ?scaleup_feasibility_case)
        (assay_assigned_to_development_item ?scaleup_feasibility_case ?analytical_assay)
        (executive_approval_available ?executive_approval_record)
        (development_item_has_executive_approval_record ?scaleup_feasibility_case ?executive_approval_record)
        (not
          (executive_approval_attached ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (executive_approval_attached ?scaleup_feasibility_case)
        (not
          (executive_approval_available ?executive_approval_record)
        )
      )
  )
  (:action submit_development_item_for_approval_review
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?subject_matter_expert - subject_matter_expert)
    :precondition
      (and
        (executive_approval_attached ?scaleup_feasibility_case)
        (subject_matter_expert_assigned_to_development_item ?scaleup_feasibility_case ?subject_matter_expert)
        (not
          (development_item_approval_in_review ?scaleup_feasibility_case)
        )
      )
    :effect (development_item_approval_in_review ?scaleup_feasibility_case)
  )
  (:action confirm_development_item_approval
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?supplier_qualification_record - supplier_qualification_record)
    :precondition
      (and
        (development_item_approval_in_review ?scaleup_feasibility_case)
        (development_item_has_supplier_qualification_record ?scaleup_feasibility_case ?supplier_qualification_record)
        (not
          (development_item_approval_confirmed ?scaleup_feasibility_case)
        )
      )
    :effect (development_item_approval_confirmed ?scaleup_feasibility_case)
  )
  (:action finalize_development_item_review_after_approval
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case)
    :precondition
      (and
        (development_item_approval_confirmed ?scaleup_feasibility_case)
        (not
          (development_item_finalization_marker ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (development_item_finalization_marker ?scaleup_feasibility_case)
        (review_package_finalized ?scaleup_feasibility_case)
      )
  )
  (:action finalize_formulation_variant
    :parameters (?formulation_variant - formulation_variant ?process_fit_report - process_fit_document)
    :precondition
      (and
        (formulation_variant_ready_for_integration ?formulation_variant)
        (formulation_variant_experiment_result_recorded ?formulation_variant)
        (process_fit_document_compiled ?process_fit_report)
        (process_fit_document_validated ?process_fit_report)
        (not
          (review_package_finalized ?formulation_variant)
        )
      )
    :effect (review_package_finalized ?formulation_variant)
  )
  (:action finalize_process_prototype
    :parameters (?process_prototype - process_prototype ?process_fit_report - process_fit_document)
    :precondition
      (and
        (process_prototype_ready_for_integration ?process_prototype)
        (process_prototype_experiment_result_recorded ?process_prototype)
        (process_fit_document_compiled ?process_fit_report)
        (process_fit_document_validated ?process_fit_report)
        (not
          (review_package_finalized ?process_prototype)
        )
      )
    :effect (review_package_finalized ?process_prototype)
  )
  (:action attach_evidence_and_confirm_readiness
    :parameters (?development_item - development_item ?evidence_artifact - evidence_artifact ?analytical_assay - analytical_assay)
    :precondition
      (and
        (review_package_finalized ?development_item)
        (assay_assigned_to_development_item ?development_item ?analytical_assay)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (final_readiness_confirmed ?development_item)
        )
      )
    :effect
      (and
        (final_readiness_confirmed ?development_item)
        (development_item_linked_to_evidence_artifact ?development_item ?evidence_artifact)
        (not
          (evidence_artifact_available ?evidence_artifact)
        )
      )
  )
  (:action approve_formulation_variant_for_scale_up
    :parameters (?formulation_variant - formulation_variant ?equipment_resource - equipment_resource ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (final_readiness_confirmed ?formulation_variant)
        (development_item_allocated_to_equipment ?formulation_variant ?equipment_resource)
        (development_item_linked_to_evidence_artifact ?formulation_variant ?evidence_artifact)
        (not
          (approved_for_scale_up ?formulation_variant)
        )
      )
    :effect
      (and
        (approved_for_scale_up ?formulation_variant)
        (equipment_available ?equipment_resource)
        (evidence_artifact_available ?evidence_artifact)
      )
  )
  (:action approve_process_prototype_for_scale_up
    :parameters (?process_prototype - process_prototype ?equipment_resource - equipment_resource ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (final_readiness_confirmed ?process_prototype)
        (development_item_allocated_to_equipment ?process_prototype ?equipment_resource)
        (development_item_linked_to_evidence_artifact ?process_prototype ?evidence_artifact)
        (not
          (approved_for_scale_up ?process_prototype)
        )
      )
    :effect
      (and
        (approved_for_scale_up ?process_prototype)
        (equipment_available ?equipment_resource)
        (evidence_artifact_available ?evidence_artifact)
      )
  )
  (:action approve_development_item_for_scale_up
    :parameters (?scaleup_feasibility_case - scaleup_feasibility_case ?equipment_resource - equipment_resource ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (final_readiness_confirmed ?scaleup_feasibility_case)
        (development_item_allocated_to_equipment ?scaleup_feasibility_case ?equipment_resource)
        (development_item_linked_to_evidence_artifact ?scaleup_feasibility_case ?evidence_artifact)
        (not
          (approved_for_scale_up ?scaleup_feasibility_case)
        )
      )
    :effect
      (and
        (approved_for_scale_up ?scaleup_feasibility_case)
        (equipment_available ?equipment_resource)
        (evidence_artifact_available ?evidence_artifact)
      )
  )
)

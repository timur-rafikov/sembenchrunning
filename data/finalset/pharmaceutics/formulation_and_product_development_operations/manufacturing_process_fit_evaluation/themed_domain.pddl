(define (domain pharm_manufacturing_process_fit_evaluation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_entity - object resource_item - domain_entity artifact_bucket - domain_entity implementation_asset_bucket - domain_entity case_container - domain_entity process_fit_case - case_container technology_platform - resource_item analytical_study - resource_item review_task - resource_item regulatory_requirement - resource_item evidence_package_type - resource_item decision_criterion - resource_item equipment_qualification_record - resource_item stability_study_plan - resource_item test_protocol - artifact_bucket test_result - artifact_bucket risk_assessment - artifact_bucket equipment_specification - implementation_asset_bucket scale_specification - implementation_asset_bucket process_variant - implementation_asset_bucket process_deployment_case - process_fit_case evaluation_artifact_case - process_fit_case internal_manufacturing_process - process_deployment_case external_manufacturing_process - process_deployment_case evaluation_report - evaluation_artifact_case)

  (:predicates
    (case_registered ?process_fit_case - process_fit_case)
    (evidence_compiled ?process_fit_case - process_fit_case)
    (platform_assigned ?process_fit_case - process_fit_case)
    (fit_approved ?process_fit_case - process_fit_case)
    (ready_for_approval ?process_fit_case - process_fit_case)
    (final_decision_recorded ?process_fit_case - process_fit_case)
    (platform_available ?technology_platform - technology_platform)
    (has_platform ?process_fit_case - process_fit_case ?technology_platform - technology_platform)
    (analytical_study_available ?analytical_study - analytical_study)
    (has_analytical_study ?process_fit_case - process_fit_case ?analytical_study - analytical_study)
    (review_task_available ?review_task - review_task)
    (assigned_review_task ?process_fit_case - process_fit_case ?review_task - review_task)
    (test_protocol_available ?test_protocol - test_protocol)
    (internal_process_has_test_protocol ?internal_manufacturing_process - internal_manufacturing_process ?test_protocol - test_protocol)
    (external_process_has_test_protocol ?external_manufacturing_process - external_manufacturing_process ?test_protocol - test_protocol)
    (internal_process_has_equipment_spec ?internal_manufacturing_process - internal_manufacturing_process ?equipment_specification - equipment_specification)
    (equipment_identified_by_study ?equipment_specification - equipment_specification)
    (equipment_protocol_assigned ?equipment_specification - equipment_specification)
    (internal_process_compatibility_confirmed ?internal_manufacturing_process - internal_manufacturing_process)
    (external_process_has_scale_spec ?external_manufacturing_process - external_manufacturing_process ?scale_specification - scale_specification)
    (scale_selected ?scale_specification - scale_specification)
    (scale_protocol_assigned ?scale_specification - scale_specification)
    (external_process_compatibility_confirmed ?external_manufacturing_process - external_manufacturing_process)
    (process_variant_available ?process_variant - process_variant)
    (process_variant_created ?process_variant - process_variant)
    (variant_has_equipment_spec ?process_variant - process_variant ?equipment_specification - equipment_specification)
    (variant_has_scale_spec ?process_variant - process_variant ?scale_specification - scale_specification)
    (variant_packaging_path_a_selected ?process_variant - process_variant)
    (variant_packaging_path_b_selected ?process_variant - process_variant)
    (variant_tested ?process_variant - process_variant)
    (report_assesses_internal_process ?evaluation_report - evaluation_report ?internal_manufacturing_process - internal_manufacturing_process)
    (report_assesses_external_process ?evaluation_report - evaluation_report ?external_manufacturing_process - external_manufacturing_process)
    (report_includes_process_variant ?evaluation_report - evaluation_report ?process_variant - process_variant)
    (test_result_available ?test_result - test_result)
    (report_includes_test_result ?evaluation_report - evaluation_report ?test_result - test_result)
    (test_result_packaged ?test_result - test_result)
    (test_result_for_variant ?test_result - test_result ?process_variant - process_variant)
    (report_packaging_ready ?evaluation_report - evaluation_report)
    (report_qualification_pending ?evaluation_report - evaluation_report)
    (report_stability_assessed ?evaluation_report - evaluation_report)
    (report_regulatory_flag ?evaluation_report - evaluation_report)
    (report_regulatory_package_prepared ?evaluation_report - evaluation_report)
    (report_requires_evidence_package ?evaluation_report - evaluation_report)
    (report_qualification_complete ?evaluation_report - evaluation_report)
    (risk_assessment_available ?risk_assessment - risk_assessment)
    (report_has_risk_assessment ?evaluation_report - evaluation_report ?risk_assessment - risk_assessment)
    (report_regulatory_review_requested ?evaluation_report - evaluation_report)
    (regulatory_specialist_assigned ?evaluation_report - evaluation_report)
    (regulatory_specialist_review_complete ?evaluation_report - evaluation_report)
    (regulatory_requirement_available ?regulatory_requirement - regulatory_requirement)
    (report_assigned_regulatory_requirement ?evaluation_report - evaluation_report ?regulatory_requirement - regulatory_requirement)
    (evidence_package_type_available ?evidence_package_type - evidence_package_type)
    (report_has_evidence_package ?evaluation_report - evaluation_report ?evidence_package_type - evidence_package_type)
    (equipment_qualification_record_available ?equipment_qualification_record - equipment_qualification_record)
    (report_has_equipment_qualification ?evaluation_report - evaluation_report ?equipment_qualification_record - equipment_qualification_record)
    (stability_study_plan_available ?stability_study_plan - stability_study_plan)
    (report_has_stability_study_plan ?evaluation_report - evaluation_report ?stability_study_plan - stability_study_plan)
    (decision_criterion_available ?decision_criterion - decision_criterion)
    (has_decision_criterion ?process_fit_case - process_fit_case ?decision_criterion - decision_criterion)
    (internal_process_ready ?internal_manufacturing_process - internal_manufacturing_process)
    (external_process_ready ?external_manufacturing_process - external_manufacturing_process)
    (decision_token_recorded ?evaluation_report - evaluation_report)
  )
  (:action register_process_fit_case
    :parameters (?process_fit_case - process_fit_case)
    :precondition
      (and
        (not
          (case_registered ?process_fit_case)
        )
        (not
          (fit_approved ?process_fit_case)
        )
      )
    :effect (case_registered ?process_fit_case)
  )
  (:action assign_technology_platform_to_case
    :parameters (?process_fit_case - process_fit_case ?technology_platform - technology_platform)
    :precondition
      (and
        (case_registered ?process_fit_case)
        (not
          (platform_assigned ?process_fit_case)
        )
        (platform_available ?technology_platform)
      )
    :effect
      (and
        (platform_assigned ?process_fit_case)
        (has_platform ?process_fit_case ?technology_platform)
        (not
          (platform_available ?technology_platform)
        )
      )
  )
  (:action reserve_analytical_study_for_case
    :parameters (?process_fit_case - process_fit_case ?analytical_study - analytical_study)
    :precondition
      (and
        (case_registered ?process_fit_case)
        (platform_assigned ?process_fit_case)
        (analytical_study_available ?analytical_study)
      )
    :effect
      (and
        (has_analytical_study ?process_fit_case ?analytical_study)
        (not
          (analytical_study_available ?analytical_study)
        )
      )
  )
  (:action compile_initial_evidence
    :parameters (?process_fit_case - process_fit_case ?analytical_study - analytical_study)
    :precondition
      (and
        (case_registered ?process_fit_case)
        (platform_assigned ?process_fit_case)
        (has_analytical_study ?process_fit_case ?analytical_study)
        (not
          (evidence_compiled ?process_fit_case)
        )
      )
    :effect (evidence_compiled ?process_fit_case)
  )
  (:action release_analytical_study
    :parameters (?process_fit_case - process_fit_case ?analytical_study - analytical_study)
    :precondition
      (and
        (has_analytical_study ?process_fit_case ?analytical_study)
      )
    :effect
      (and
        (analytical_study_available ?analytical_study)
        (not
          (has_analytical_study ?process_fit_case ?analytical_study)
        )
      )
  )
  (:action assign_review_task_to_case
    :parameters (?process_fit_case - process_fit_case ?review_task - review_task)
    :precondition
      (and
        (evidence_compiled ?process_fit_case)
        (review_task_available ?review_task)
      )
    :effect
      (and
        (assigned_review_task ?process_fit_case ?review_task)
        (not
          (review_task_available ?review_task)
        )
      )
  )
  (:action unassign_review_task_from_case
    :parameters (?process_fit_case - process_fit_case ?review_task - review_task)
    :precondition
      (and
        (assigned_review_task ?process_fit_case ?review_task)
      )
    :effect
      (and
        (review_task_available ?review_task)
        (not
          (assigned_review_task ?process_fit_case ?review_task)
        )
      )
  )
  (:action attach_equipment_qualification_to_report
    :parameters (?evaluation_report - evaluation_report ?equipment_qualification_record - equipment_qualification_record)
    :precondition
      (and
        (evidence_compiled ?evaluation_report)
        (equipment_qualification_record_available ?equipment_qualification_record)
      )
    :effect
      (and
        (report_has_equipment_qualification ?evaluation_report ?equipment_qualification_record)
        (not
          (equipment_qualification_record_available ?equipment_qualification_record)
        )
      )
  )
  (:action detach_equipment_qualification_from_report
    :parameters (?evaluation_report - evaluation_report ?equipment_qualification_record - equipment_qualification_record)
    :precondition
      (and
        (report_has_equipment_qualification ?evaluation_report ?equipment_qualification_record)
      )
    :effect
      (and
        (equipment_qualification_record_available ?equipment_qualification_record)
        (not
          (report_has_equipment_qualification ?evaluation_report ?equipment_qualification_record)
        )
      )
  )
  (:action attach_stability_plan_to_report
    :parameters (?evaluation_report - evaluation_report ?stability_study_plan - stability_study_plan)
    :precondition
      (and
        (evidence_compiled ?evaluation_report)
        (stability_study_plan_available ?stability_study_plan)
      )
    :effect
      (and
        (report_has_stability_study_plan ?evaluation_report ?stability_study_plan)
        (not
          (stability_study_plan_available ?stability_study_plan)
        )
      )
  )
  (:action detach_stability_plan_from_report
    :parameters (?evaluation_report - evaluation_report ?stability_study_plan - stability_study_plan)
    :precondition
      (and
        (report_has_stability_study_plan ?evaluation_report ?stability_study_plan)
      )
    :effect
      (and
        (stability_study_plan_available ?stability_study_plan)
        (not
          (report_has_stability_study_plan ?evaluation_report ?stability_study_plan)
        )
      )
  )
  (:action identify_equipment_for_screening
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?equipment_specification - equipment_specification ?analytical_study - analytical_study)
    :precondition
      (and
        (evidence_compiled ?internal_manufacturing_process)
        (has_analytical_study ?internal_manufacturing_process ?analytical_study)
        (internal_process_has_equipment_spec ?internal_manufacturing_process ?equipment_specification)
        (not
          (equipment_identified_by_study ?equipment_specification)
        )
        (not
          (equipment_protocol_assigned ?equipment_specification)
        )
      )
    :effect (equipment_identified_by_study ?equipment_specification)
  )
  (:action confirm_internal_process_equipment_compatibility
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?equipment_specification - equipment_specification ?review_task - review_task)
    :precondition
      (and
        (evidence_compiled ?internal_manufacturing_process)
        (assigned_review_task ?internal_manufacturing_process ?review_task)
        (internal_process_has_equipment_spec ?internal_manufacturing_process ?equipment_specification)
        (equipment_identified_by_study ?equipment_specification)
        (not
          (internal_process_ready ?internal_manufacturing_process)
        )
      )
    :effect
      (and
        (internal_process_ready ?internal_manufacturing_process)
        (internal_process_compatibility_confirmed ?internal_manufacturing_process)
      )
  )
  (:action assign_test_protocol_to_internal_process
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?equipment_specification - equipment_specification ?test_protocol - test_protocol)
    :precondition
      (and
        (evidence_compiled ?internal_manufacturing_process)
        (internal_process_has_equipment_spec ?internal_manufacturing_process ?equipment_specification)
        (test_protocol_available ?test_protocol)
        (not
          (internal_process_ready ?internal_manufacturing_process)
        )
      )
    :effect
      (and
        (equipment_protocol_assigned ?equipment_specification)
        (internal_process_ready ?internal_manufacturing_process)
        (internal_process_has_test_protocol ?internal_manufacturing_process ?test_protocol)
        (not
          (test_protocol_available ?test_protocol)
        )
      )
  )
  (:action finalize_internal_process_screening
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?equipment_specification - equipment_specification ?analytical_study - analytical_study ?test_protocol - test_protocol)
    :precondition
      (and
        (evidence_compiled ?internal_manufacturing_process)
        (has_analytical_study ?internal_manufacturing_process ?analytical_study)
        (internal_process_has_equipment_spec ?internal_manufacturing_process ?equipment_specification)
        (equipment_protocol_assigned ?equipment_specification)
        (internal_process_has_test_protocol ?internal_manufacturing_process ?test_protocol)
        (not
          (internal_process_compatibility_confirmed ?internal_manufacturing_process)
        )
      )
    :effect
      (and
        (equipment_identified_by_study ?equipment_specification)
        (internal_process_compatibility_confirmed ?internal_manufacturing_process)
        (test_protocol_available ?test_protocol)
        (not
          (internal_process_has_test_protocol ?internal_manufacturing_process ?test_protocol)
        )
      )
  )
  (:action identify_scale_for_external_screening
    :parameters (?external_manufacturing_process - external_manufacturing_process ?scale_specification - scale_specification ?analytical_study - analytical_study)
    :precondition
      (and
        (evidence_compiled ?external_manufacturing_process)
        (has_analytical_study ?external_manufacturing_process ?analytical_study)
        (external_process_has_scale_spec ?external_manufacturing_process ?scale_specification)
        (not
          (scale_selected ?scale_specification)
        )
        (not
          (scale_protocol_assigned ?scale_specification)
        )
      )
    :effect (scale_selected ?scale_specification)
  )
  (:action confirm_external_process_scale_compatibility
    :parameters (?external_manufacturing_process - external_manufacturing_process ?scale_specification - scale_specification ?review_task - review_task)
    :precondition
      (and
        (evidence_compiled ?external_manufacturing_process)
        (assigned_review_task ?external_manufacturing_process ?review_task)
        (external_process_has_scale_spec ?external_manufacturing_process ?scale_specification)
        (scale_selected ?scale_specification)
        (not
          (external_process_ready ?external_manufacturing_process)
        )
      )
    :effect
      (and
        (external_process_ready ?external_manufacturing_process)
        (external_process_compatibility_confirmed ?external_manufacturing_process)
      )
  )
  (:action assign_test_protocol_to_external_process
    :parameters (?external_manufacturing_process - external_manufacturing_process ?scale_specification - scale_specification ?test_protocol - test_protocol)
    :precondition
      (and
        (evidence_compiled ?external_manufacturing_process)
        (external_process_has_scale_spec ?external_manufacturing_process ?scale_specification)
        (test_protocol_available ?test_protocol)
        (not
          (external_process_ready ?external_manufacturing_process)
        )
      )
    :effect
      (and
        (scale_protocol_assigned ?scale_specification)
        (external_process_ready ?external_manufacturing_process)
        (external_process_has_test_protocol ?external_manufacturing_process ?test_protocol)
        (not
          (test_protocol_available ?test_protocol)
        )
      )
  )
  (:action finalize_external_process_screening
    :parameters (?external_manufacturing_process - external_manufacturing_process ?scale_specification - scale_specification ?analytical_study - analytical_study ?test_protocol - test_protocol)
    :precondition
      (and
        (evidence_compiled ?external_manufacturing_process)
        (has_analytical_study ?external_manufacturing_process ?analytical_study)
        (external_process_has_scale_spec ?external_manufacturing_process ?scale_specification)
        (scale_protocol_assigned ?scale_specification)
        (external_process_has_test_protocol ?external_manufacturing_process ?test_protocol)
        (not
          (external_process_compatibility_confirmed ?external_manufacturing_process)
        )
      )
    :effect
      (and
        (scale_selected ?scale_specification)
        (external_process_compatibility_confirmed ?external_manufacturing_process)
        (test_protocol_available ?test_protocol)
        (not
          (external_process_has_test_protocol ?external_manufacturing_process ?test_protocol)
        )
      )
  )
  (:action create_process_variant
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?external_manufacturing_process - external_manufacturing_process ?equipment_specification - equipment_specification ?scale_specification - scale_specification ?process_variant - process_variant)
    :precondition
      (and
        (internal_process_ready ?internal_manufacturing_process)
        (external_process_ready ?external_manufacturing_process)
        (internal_process_has_equipment_spec ?internal_manufacturing_process ?equipment_specification)
        (external_process_has_scale_spec ?external_manufacturing_process ?scale_specification)
        (equipment_identified_by_study ?equipment_specification)
        (scale_selected ?scale_specification)
        (internal_process_compatibility_confirmed ?internal_manufacturing_process)
        (external_process_compatibility_confirmed ?external_manufacturing_process)
        (process_variant_available ?process_variant)
      )
    :effect
      (and
        (process_variant_created ?process_variant)
        (variant_has_equipment_spec ?process_variant ?equipment_specification)
        (variant_has_scale_spec ?process_variant ?scale_specification)
        (not
          (process_variant_available ?process_variant)
        )
      )
  )
  (:action create_process_variant_with_path_a
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?external_manufacturing_process - external_manufacturing_process ?equipment_specification - equipment_specification ?scale_specification - scale_specification ?process_variant - process_variant)
    :precondition
      (and
        (internal_process_ready ?internal_manufacturing_process)
        (external_process_ready ?external_manufacturing_process)
        (internal_process_has_equipment_spec ?internal_manufacturing_process ?equipment_specification)
        (external_process_has_scale_spec ?external_manufacturing_process ?scale_specification)
        (equipment_protocol_assigned ?equipment_specification)
        (scale_selected ?scale_specification)
        (not
          (internal_process_compatibility_confirmed ?internal_manufacturing_process)
        )
        (external_process_compatibility_confirmed ?external_manufacturing_process)
        (process_variant_available ?process_variant)
      )
    :effect
      (and
        (process_variant_created ?process_variant)
        (variant_has_equipment_spec ?process_variant ?equipment_specification)
        (variant_has_scale_spec ?process_variant ?scale_specification)
        (variant_packaging_path_a_selected ?process_variant)
        (not
          (process_variant_available ?process_variant)
        )
      )
  )
  (:action create_process_variant_with_path_b
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?external_manufacturing_process - external_manufacturing_process ?equipment_specification - equipment_specification ?scale_specification - scale_specification ?process_variant - process_variant)
    :precondition
      (and
        (internal_process_ready ?internal_manufacturing_process)
        (external_process_ready ?external_manufacturing_process)
        (internal_process_has_equipment_spec ?internal_manufacturing_process ?equipment_specification)
        (external_process_has_scale_spec ?external_manufacturing_process ?scale_specification)
        (equipment_identified_by_study ?equipment_specification)
        (scale_protocol_assigned ?scale_specification)
        (internal_process_compatibility_confirmed ?internal_manufacturing_process)
        (not
          (external_process_compatibility_confirmed ?external_manufacturing_process)
        )
        (process_variant_available ?process_variant)
      )
    :effect
      (and
        (process_variant_created ?process_variant)
        (variant_has_equipment_spec ?process_variant ?equipment_specification)
        (variant_has_scale_spec ?process_variant ?scale_specification)
        (variant_packaging_path_b_selected ?process_variant)
        (not
          (process_variant_available ?process_variant)
        )
      )
  )
  (:action create_process_variant_with_both_paths
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?external_manufacturing_process - external_manufacturing_process ?equipment_specification - equipment_specification ?scale_specification - scale_specification ?process_variant - process_variant)
    :precondition
      (and
        (internal_process_ready ?internal_manufacturing_process)
        (external_process_ready ?external_manufacturing_process)
        (internal_process_has_equipment_spec ?internal_manufacturing_process ?equipment_specification)
        (external_process_has_scale_spec ?external_manufacturing_process ?scale_specification)
        (equipment_protocol_assigned ?equipment_specification)
        (scale_protocol_assigned ?scale_specification)
        (not
          (internal_process_compatibility_confirmed ?internal_manufacturing_process)
        )
        (not
          (external_process_compatibility_confirmed ?external_manufacturing_process)
        )
        (process_variant_available ?process_variant)
      )
    :effect
      (and
        (process_variant_created ?process_variant)
        (variant_has_equipment_spec ?process_variant ?equipment_specification)
        (variant_has_scale_spec ?process_variant ?scale_specification)
        (variant_packaging_path_a_selected ?process_variant)
        (variant_packaging_path_b_selected ?process_variant)
        (not
          (process_variant_available ?process_variant)
        )
      )
  )
  (:action mark_variant_tested
    :parameters (?process_variant - process_variant ?internal_manufacturing_process - internal_manufacturing_process ?analytical_study - analytical_study)
    :precondition
      (and
        (process_variant_created ?process_variant)
        (internal_process_ready ?internal_manufacturing_process)
        (has_analytical_study ?internal_manufacturing_process ?analytical_study)
        (not
          (variant_tested ?process_variant)
        )
      )
    :effect (variant_tested ?process_variant)
  )
  (:action package_test_result_into_report
    :parameters (?evaluation_report - evaluation_report ?test_result - test_result ?process_variant - process_variant)
    :precondition
      (and
        (evidence_compiled ?evaluation_report)
        (report_includes_process_variant ?evaluation_report ?process_variant)
        (report_includes_test_result ?evaluation_report ?test_result)
        (test_result_available ?test_result)
        (process_variant_created ?process_variant)
        (variant_tested ?process_variant)
        (not
          (test_result_packaged ?test_result)
        )
      )
    :effect
      (and
        (test_result_packaged ?test_result)
        (test_result_for_variant ?test_result ?process_variant)
        (not
          (test_result_available ?test_result)
        )
      )
  )
  (:action prepare_report_for_packaging
    :parameters (?evaluation_report - evaluation_report ?test_result - test_result ?process_variant - process_variant ?analytical_study - analytical_study)
    :precondition
      (and
        (evidence_compiled ?evaluation_report)
        (report_includes_test_result ?evaluation_report ?test_result)
        (test_result_packaged ?test_result)
        (test_result_for_variant ?test_result ?process_variant)
        (has_analytical_study ?evaluation_report ?analytical_study)
        (not
          (variant_packaging_path_a_selected ?process_variant)
        )
        (not
          (report_packaging_ready ?evaluation_report)
        )
      )
    :effect (report_packaging_ready ?evaluation_report)
  )
  (:action assign_regulatory_requirement_to_report
    :parameters (?evaluation_report - evaluation_report ?regulatory_requirement - regulatory_requirement)
    :precondition
      (and
        (evidence_compiled ?evaluation_report)
        (regulatory_requirement_available ?regulatory_requirement)
        (not
          (report_regulatory_flag ?evaluation_report)
        )
      )
    :effect
      (and
        (report_regulatory_flag ?evaluation_report)
        (report_assigned_regulatory_requirement ?evaluation_report ?regulatory_requirement)
        (not
          (regulatory_requirement_available ?regulatory_requirement)
        )
      )
  )
  (:action prepare_report_for_packaging_with_regulatory
    :parameters (?evaluation_report - evaluation_report ?test_result - test_result ?process_variant - process_variant ?analytical_study - analytical_study ?regulatory_requirement - regulatory_requirement)
    :precondition
      (and
        (evidence_compiled ?evaluation_report)
        (report_includes_test_result ?evaluation_report ?test_result)
        (test_result_packaged ?test_result)
        (test_result_for_variant ?test_result ?process_variant)
        (has_analytical_study ?evaluation_report ?analytical_study)
        (variant_packaging_path_a_selected ?process_variant)
        (report_regulatory_flag ?evaluation_report)
        (report_assigned_regulatory_requirement ?evaluation_report ?regulatory_requirement)
        (not
          (report_packaging_ready ?evaluation_report)
        )
      )
    :effect
      (and
        (report_packaging_ready ?evaluation_report)
        (report_regulatory_package_prepared ?evaluation_report)
      )
  )
  (:action initiate_report_qualification_primary
    :parameters (?evaluation_report - evaluation_report ?equipment_qualification_record - equipment_qualification_record ?review_task - review_task ?test_result - test_result ?process_variant - process_variant)
    :precondition
      (and
        (report_packaging_ready ?evaluation_report)
        (report_has_equipment_qualification ?evaluation_report ?equipment_qualification_record)
        (assigned_review_task ?evaluation_report ?review_task)
        (report_includes_test_result ?evaluation_report ?test_result)
        (test_result_for_variant ?test_result ?process_variant)
        (not
          (variant_packaging_path_b_selected ?process_variant)
        )
        (not
          (report_qualification_pending ?evaluation_report)
        )
      )
    :effect (report_qualification_pending ?evaluation_report)
  )
  (:action initiate_report_qualification_secondary
    :parameters (?evaluation_report - evaluation_report ?equipment_qualification_record - equipment_qualification_record ?review_task - review_task ?test_result - test_result ?process_variant - process_variant)
    :precondition
      (and
        (report_packaging_ready ?evaluation_report)
        (report_has_equipment_qualification ?evaluation_report ?equipment_qualification_record)
        (assigned_review_task ?evaluation_report ?review_task)
        (report_includes_test_result ?evaluation_report ?test_result)
        (test_result_for_variant ?test_result ?process_variant)
        (variant_packaging_path_b_selected ?process_variant)
        (not
          (report_qualification_pending ?evaluation_report)
        )
      )
    :effect (report_qualification_pending ?evaluation_report)
  )
  (:action finalize_qualification_readiness
    :parameters (?evaluation_report - evaluation_report ?stability_study_plan - stability_study_plan ?test_result - test_result ?process_variant - process_variant)
    :precondition
      (and
        (report_qualification_pending ?evaluation_report)
        (report_has_stability_study_plan ?evaluation_report ?stability_study_plan)
        (report_includes_test_result ?evaluation_report ?test_result)
        (test_result_for_variant ?test_result ?process_variant)
        (not
          (variant_packaging_path_a_selected ?process_variant)
        )
        (not
          (variant_packaging_path_b_selected ?process_variant)
        )
        (not
          (report_stability_assessed ?evaluation_report)
        )
      )
    :effect (report_stability_assessed ?evaluation_report)
  )
  (:action finalize_qualification_and_mark_evidence_required
    :parameters (?evaluation_report - evaluation_report ?stability_study_plan - stability_study_plan ?test_result - test_result ?process_variant - process_variant)
    :precondition
      (and
        (report_qualification_pending ?evaluation_report)
        (report_has_stability_study_plan ?evaluation_report ?stability_study_plan)
        (report_includes_test_result ?evaluation_report ?test_result)
        (test_result_for_variant ?test_result ?process_variant)
        (variant_packaging_path_a_selected ?process_variant)
        (not
          (variant_packaging_path_b_selected ?process_variant)
        )
        (not
          (report_stability_assessed ?evaluation_report)
        )
      )
    :effect
      (and
        (report_stability_assessed ?evaluation_report)
        (report_requires_evidence_package ?evaluation_report)
      )
  )
  (:action finalize_qualification_alternate
    :parameters (?evaluation_report - evaluation_report ?stability_study_plan - stability_study_plan ?test_result - test_result ?process_variant - process_variant)
    :precondition
      (and
        (report_qualification_pending ?evaluation_report)
        (report_has_stability_study_plan ?evaluation_report ?stability_study_plan)
        (report_includes_test_result ?evaluation_report ?test_result)
        (test_result_for_variant ?test_result ?process_variant)
        (not
          (variant_packaging_path_a_selected ?process_variant)
        )
        (variant_packaging_path_b_selected ?process_variant)
        (not
          (report_stability_assessed ?evaluation_report)
        )
      )
    :effect
      (and
        (report_stability_assessed ?evaluation_report)
        (report_requires_evidence_package ?evaluation_report)
      )
  )
  (:action finalize_qualification_full
    :parameters (?evaluation_report - evaluation_report ?stability_study_plan - stability_study_plan ?test_result - test_result ?process_variant - process_variant)
    :precondition
      (and
        (report_qualification_pending ?evaluation_report)
        (report_has_stability_study_plan ?evaluation_report ?stability_study_plan)
        (report_includes_test_result ?evaluation_report ?test_result)
        (test_result_for_variant ?test_result ?process_variant)
        (variant_packaging_path_a_selected ?process_variant)
        (variant_packaging_path_b_selected ?process_variant)
        (not
          (report_stability_assessed ?evaluation_report)
        )
      )
    :effect
      (and
        (report_stability_assessed ?evaluation_report)
        (report_requires_evidence_package ?evaluation_report)
      )
  )
  (:action issue_decision_signal_from_report
    :parameters (?evaluation_report - evaluation_report)
    :precondition
      (and
        (report_stability_assessed ?evaluation_report)
        (not
          (report_requires_evidence_package ?evaluation_report)
        )
        (not
          (decision_token_recorded ?evaluation_report)
        )
      )
    :effect
      (and
        (decision_token_recorded ?evaluation_report)
        (ready_for_approval ?evaluation_report)
      )
  )
  (:action attach_evidence_package_to_report
    :parameters (?evaluation_report - evaluation_report ?evidence_package_type - evidence_package_type)
    :precondition
      (and
        (report_stability_assessed ?evaluation_report)
        (report_requires_evidence_package ?evaluation_report)
        (evidence_package_type_available ?evidence_package_type)
      )
    :effect
      (and
        (report_has_evidence_package ?evaluation_report ?evidence_package_type)
        (not
          (evidence_package_type_available ?evidence_package_type)
        )
      )
  )
  (:action execute_report_qualification_activities
    :parameters (?evaluation_report - evaluation_report ?internal_manufacturing_process - internal_manufacturing_process ?external_manufacturing_process - external_manufacturing_process ?analytical_study - analytical_study ?evidence_package_type - evidence_package_type)
    :precondition
      (and
        (report_stability_assessed ?evaluation_report)
        (report_requires_evidence_package ?evaluation_report)
        (report_has_evidence_package ?evaluation_report ?evidence_package_type)
        (report_assesses_internal_process ?evaluation_report ?internal_manufacturing_process)
        (report_assesses_external_process ?evaluation_report ?external_manufacturing_process)
        (internal_process_compatibility_confirmed ?internal_manufacturing_process)
        (external_process_compatibility_confirmed ?external_manufacturing_process)
        (has_analytical_study ?evaluation_report ?analytical_study)
        (not
          (report_qualification_complete ?evaluation_report)
        )
      )
    :effect (report_qualification_complete ?evaluation_report)
  )
  (:action finalize_report_decision_from_qualification
    :parameters (?evaluation_report - evaluation_report)
    :precondition
      (and
        (report_stability_assessed ?evaluation_report)
        (report_qualification_complete ?evaluation_report)
        (not
          (decision_token_recorded ?evaluation_report)
        )
      )
    :effect
      (and
        (decision_token_recorded ?evaluation_report)
        (ready_for_approval ?evaluation_report)
      )
  )
  (:action request_regulatory_review
    :parameters (?evaluation_report - evaluation_report ?risk_assessment - risk_assessment ?analytical_study - analytical_study)
    :precondition
      (and
        (evidence_compiled ?evaluation_report)
        (has_analytical_study ?evaluation_report ?analytical_study)
        (risk_assessment_available ?risk_assessment)
        (report_has_risk_assessment ?evaluation_report ?risk_assessment)
        (not
          (report_regulatory_review_requested ?evaluation_report)
        )
      )
    :effect
      (and
        (report_regulatory_review_requested ?evaluation_report)
        (not
          (risk_assessment_available ?risk_assessment)
        )
      )
  )
  (:action assign_specialist_for_regulatory_review
    :parameters (?evaluation_report - evaluation_report ?review_task - review_task)
    :precondition
      (and
        (report_regulatory_review_requested ?evaluation_report)
        (assigned_review_task ?evaluation_report ?review_task)
        (not
          (regulatory_specialist_assigned ?evaluation_report)
        )
      )
    :effect (regulatory_specialist_assigned ?evaluation_report)
  )
  (:action complete_specialist_regulatory_review
    :parameters (?evaluation_report - evaluation_report ?stability_study_plan - stability_study_plan)
    :precondition
      (and
        (regulatory_specialist_assigned ?evaluation_report)
        (report_has_stability_study_plan ?evaluation_report ?stability_study_plan)
        (not
          (regulatory_specialist_review_complete ?evaluation_report)
        )
      )
    :effect (regulatory_specialist_review_complete ?evaluation_report)
  )
  (:action record_regulatory_decision
    :parameters (?evaluation_report - evaluation_report)
    :precondition
      (and
        (regulatory_specialist_review_complete ?evaluation_report)
        (not
          (decision_token_recorded ?evaluation_report)
        )
      )
    :effect
      (and
        (decision_token_recorded ?evaluation_report)
        (ready_for_approval ?evaluation_report)
      )
  )
  (:action approve_internal_process
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?process_variant - process_variant)
    :precondition
      (and
        (internal_process_ready ?internal_manufacturing_process)
        (internal_process_compatibility_confirmed ?internal_manufacturing_process)
        (process_variant_created ?process_variant)
        (variant_tested ?process_variant)
        (not
          (ready_for_approval ?internal_manufacturing_process)
        )
      )
    :effect (ready_for_approval ?internal_manufacturing_process)
  )
  (:action approve_external_process
    :parameters (?external_manufacturing_process - external_manufacturing_process ?process_variant - process_variant)
    :precondition
      (and
        (external_process_ready ?external_manufacturing_process)
        (external_process_compatibility_confirmed ?external_manufacturing_process)
        (process_variant_created ?process_variant)
        (variant_tested ?process_variant)
        (not
          (ready_for_approval ?external_manufacturing_process)
        )
      )
    :effect (ready_for_approval ?external_manufacturing_process)
  )
  (:action apply_decision_criterion_to_case
    :parameters (?process_fit_case - process_fit_case ?decision_criterion - decision_criterion ?analytical_study - analytical_study)
    :precondition
      (and
        (ready_for_approval ?process_fit_case)
        (has_analytical_study ?process_fit_case ?analytical_study)
        (decision_criterion_available ?decision_criterion)
        (not
          (final_decision_recorded ?process_fit_case)
        )
      )
    :effect
      (and
        (final_decision_recorded ?process_fit_case)
        (has_decision_criterion ?process_fit_case ?decision_criterion)
        (not
          (decision_criterion_available ?decision_criterion)
        )
      )
  )
  (:action finalize_internal_process_approval
    :parameters (?internal_manufacturing_process - internal_manufacturing_process ?technology_platform - technology_platform ?decision_criterion - decision_criterion)
    :precondition
      (and
        (final_decision_recorded ?internal_manufacturing_process)
        (has_platform ?internal_manufacturing_process ?technology_platform)
        (has_decision_criterion ?internal_manufacturing_process ?decision_criterion)
        (not
          (fit_approved ?internal_manufacturing_process)
        )
      )
    :effect
      (and
        (fit_approved ?internal_manufacturing_process)
        (platform_available ?technology_platform)
        (decision_criterion_available ?decision_criterion)
      )
  )
  (:action finalize_external_process_approval
    :parameters (?external_manufacturing_process - external_manufacturing_process ?technology_platform - technology_platform ?decision_criterion - decision_criterion)
    :precondition
      (and
        (final_decision_recorded ?external_manufacturing_process)
        (has_platform ?external_manufacturing_process ?technology_platform)
        (has_decision_criterion ?external_manufacturing_process ?decision_criterion)
        (not
          (fit_approved ?external_manufacturing_process)
        )
      )
    :effect
      (and
        (fit_approved ?external_manufacturing_process)
        (platform_available ?technology_platform)
        (decision_criterion_available ?decision_criterion)
      )
  )
  (:action finalize_report_approval
    :parameters (?evaluation_report - evaluation_report ?technology_platform - technology_platform ?decision_criterion - decision_criterion)
    :precondition
      (and
        (final_decision_recorded ?evaluation_report)
        (has_platform ?evaluation_report ?technology_platform)
        (has_decision_criterion ?evaluation_report ?decision_criterion)
        (not
          (fit_approved ?evaluation_report)
        )
      )
    :effect
      (and
        (fit_approved ?evaluation_report)
        (platform_available ?technology_platform)
        (decision_criterion_available ?decision_criterion)
      )
  )
)

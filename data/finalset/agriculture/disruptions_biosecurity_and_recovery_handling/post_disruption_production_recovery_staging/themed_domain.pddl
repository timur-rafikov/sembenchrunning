(define (domain post_disruption_production_recovery_staging_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types recovery_resource - object staging_asset - object staging_component - object production_site_supertype - object production_site - production_site_supertype assessment_team - recovery_resource sampling_kit - recovery_resource response_decon_team - recovery_resource approval_certificate - recovery_resource transport_asset - recovery_resource recovery_permit - recovery_resource specialized_equipment - recovery_resource external_consultant - recovery_resource treatment_material - staging_asset salvage_batch - staging_asset regulatory_certificate - staging_asset local_staging_point - staging_component secondary_staging_point - staging_component recovery_package - staging_component site_section_group_a - production_site site_section_group_b - production_site primary_site_section - site_section_group_a secondary_site_section - site_section_group_a recovery_staging_plan - site_section_group_b)
  (:predicates
    (site_incident_reported ?production_site - production_site)
    (assessment_completed ?production_site - production_site)
    (site_under_assessment ?production_site - production_site)
    (recovery_confirmed ?production_site - production_site)
    (ready_for_recovery ?production_site - production_site)
    (permit_assigned ?production_site - production_site)
    (assessment_team_available ?assessment_team - assessment_team)
    (assessment_team_assigned_to_site ?production_site - production_site ?assessment_team - assessment_team)
    (sampling_kit_available ?sampling_kit - sampling_kit)
    (sampling_kit_assigned_to_site ?production_site - production_site ?sampling_kit - sampling_kit)
    (response_team_available ?response_decon_team - response_decon_team)
    (response_team_assigned_to_site ?production_site - production_site ?response_decon_team - response_decon_team)
    (treatment_material_available ?treatment_material - treatment_material)
    (primary_section_has_treatment_material ?primary_site_section - primary_site_section ?treatment_material - treatment_material)
    (secondary_section_has_treatment_material ?secondary_site_section - secondary_site_section ?treatment_material - treatment_material)
    (primary_section_linked_to_local_staging_point ?primary_site_section - primary_site_section ?local_staging_point - local_staging_point)
    (local_staging_point_designated ?local_staging_point - local_staging_point)
    (local_staging_point_treatment_applied ?local_staging_point - local_staging_point)
    (primary_section_validated_for_salvage ?primary_site_section - primary_site_section)
    (secondary_section_linked_to_secondary_staging_point ?secondary_site_section - secondary_site_section ?secondary_staging_point - secondary_staging_point)
    (secondary_staging_point_designated ?secondary_staging_point - secondary_staging_point)
    (secondary_staging_point_treatment_applied ?secondary_staging_point - secondary_staging_point)
    (secondary_section_validated_for_salvage ?secondary_site_section - secondary_site_section)
    (recovery_package_available_for_assembly ?recovery_package - recovery_package)
    (recovery_package_assembled ?recovery_package - recovery_package)
    (recovery_package_linked_to_local_staging_point ?recovery_package - recovery_package ?local_staging_point - local_staging_point)
    (recovery_package_linked_to_secondary_staging_point ?recovery_package - recovery_package ?secondary_staging_point - secondary_staging_point)
    (recovery_package_equipment_binding_required ?recovery_package - recovery_package)
    (recovery_package_expert_binding_required ?recovery_package - recovery_package)
    (recovery_package_quality_checked ?recovery_package - recovery_package)
    (plan_includes_primary_section ?recovery_staging_plan - recovery_staging_plan ?primary_site_section - primary_site_section)
    (plan_includes_secondary_section ?recovery_staging_plan - recovery_staging_plan ?secondary_site_section - secondary_site_section)
    (plan_includes_package ?recovery_staging_plan - recovery_staging_plan ?recovery_package - recovery_package)
    (salvage_batch_available ?salvage_batch - salvage_batch)
    (plan_associated_salvage_batch ?recovery_staging_plan - recovery_staging_plan ?salvage_batch - salvage_batch)
    (salvage_batch_validated ?salvage_batch - salvage_batch)
    (salvage_batch_assigned_to_package ?salvage_batch - salvage_batch ?recovery_package - recovery_package)
    (plan_ready_for_resource_binding ?recovery_staging_plan - recovery_staging_plan)
    (plan_resources_bound ?recovery_staging_plan - recovery_staging_plan)
    (plan_validated_for_activation ?recovery_staging_plan - recovery_staging_plan)
    (plan_has_approval_certificate ?recovery_staging_plan - recovery_staging_plan)
    (plan_approval_certificate_confirmed ?recovery_staging_plan - recovery_staging_plan)
    (plan_ready_for_transport_binding ?recovery_staging_plan - recovery_staging_plan)
    (plan_final_checks_passed ?recovery_staging_plan - recovery_staging_plan)
    (regulatory_certificate_available ?regulatory_certificate - regulatory_certificate)
    (plan_linked_regulatory_certificate ?recovery_staging_plan - recovery_staging_plan ?regulatory_certificate - regulatory_certificate)
    (plan_regulatory_certificate_attached ?recovery_staging_plan - recovery_staging_plan)
    (plan_audit_trail_marked ?recovery_staging_plan - recovery_staging_plan)
    (plan_expert_reviewed ?recovery_staging_plan - recovery_staging_plan)
    (approval_certificate_available ?approval_certificate - approval_certificate)
    (plan_linked_approval_certificate ?recovery_staging_plan - recovery_staging_plan ?approval_certificate - approval_certificate)
    (transport_asset_available ?transport_asset - transport_asset)
    (plan_linked_transport_asset ?recovery_staging_plan - recovery_staging_plan ?transport_asset - transport_asset)
    (specialized_equipment_available ?specialized_equipment - specialized_equipment)
    (plan_linked_specialized_equipment ?recovery_staging_plan - recovery_staging_plan ?specialized_equipment - specialized_equipment)
    (external_expert_available ?external_consultant - external_consultant)
    (plan_linked_external_expert ?recovery_staging_plan - recovery_staging_plan ?external_consultant - external_consultant)
    (recovery_permit_available ?recovery_permit - recovery_permit)
    (site_linked_recovery_permit ?production_site - production_site ?recovery_permit - recovery_permit)
    (primary_section_prepared_for_recovery ?primary_site_section - primary_site_section)
    (secondary_section_prepared_for_recovery ?secondary_site_section - secondary_site_section)
    (plan_marked_ready_for_execution ?recovery_staging_plan - recovery_staging_plan)
  )
  (:action report_incident_at_site
    :parameters (?production_site - production_site)
    :precondition
      (and
        (not
          (site_incident_reported ?production_site)
        )
        (not
          (recovery_confirmed ?production_site)
        )
      )
    :effect (site_incident_reported ?production_site)
  )
  (:action assign_assessment_team_to_site
    :parameters (?production_site - production_site ?assessment_team - assessment_team)
    :precondition
      (and
        (site_incident_reported ?production_site)
        (not
          (site_under_assessment ?production_site)
        )
        (assessment_team_available ?assessment_team)
      )
    :effect
      (and
        (site_under_assessment ?production_site)
        (assessment_team_assigned_to_site ?production_site ?assessment_team)
        (not
          (assessment_team_available ?assessment_team)
        )
      )
  )
  (:action assign_sampling_kit_to_site
    :parameters (?production_site - production_site ?sampling_kit - sampling_kit)
    :precondition
      (and
        (site_incident_reported ?production_site)
        (site_under_assessment ?production_site)
        (sampling_kit_available ?sampling_kit)
      )
    :effect
      (and
        (sampling_kit_assigned_to_site ?production_site ?sampling_kit)
        (not
          (sampling_kit_available ?sampling_kit)
        )
      )
  )
  (:action finalize_assessment_for_site
    :parameters (?production_site - production_site ?sampling_kit - sampling_kit)
    :precondition
      (and
        (site_incident_reported ?production_site)
        (site_under_assessment ?production_site)
        (sampling_kit_assigned_to_site ?production_site ?sampling_kit)
        (not
          (assessment_completed ?production_site)
        )
      )
    :effect (assessment_completed ?production_site)
  )
  (:action release_sampling_kit_from_site
    :parameters (?production_site - production_site ?sampling_kit - sampling_kit)
    :precondition
      (and
        (sampling_kit_assigned_to_site ?production_site ?sampling_kit)
      )
    :effect
      (and
        (sampling_kit_available ?sampling_kit)
        (not
          (sampling_kit_assigned_to_site ?production_site ?sampling_kit)
        )
      )
  )
  (:action deploy_response_team_to_site
    :parameters (?production_site - production_site ?response_decon_team - response_decon_team)
    :precondition
      (and
        (assessment_completed ?production_site)
        (response_team_available ?response_decon_team)
      )
    :effect
      (and
        (response_team_assigned_to_site ?production_site ?response_decon_team)
        (not
          (response_team_available ?response_decon_team)
        )
      )
  )
  (:action release_response_team_from_site
    :parameters (?production_site - production_site ?response_decon_team - response_decon_team)
    :precondition
      (and
        (response_team_assigned_to_site ?production_site ?response_decon_team)
      )
    :effect
      (and
        (response_team_available ?response_decon_team)
        (not
          (response_team_assigned_to_site ?production_site ?response_decon_team)
        )
      )
  )
  (:action bind_specialized_equipment_to_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?specialized_equipment - specialized_equipment)
    :precondition
      (and
        (assessment_completed ?recovery_staging_plan)
        (specialized_equipment_available ?specialized_equipment)
      )
    :effect
      (and
        (plan_linked_specialized_equipment ?recovery_staging_plan ?specialized_equipment)
        (not
          (specialized_equipment_available ?specialized_equipment)
        )
      )
  )
  (:action unbind_specialized_equipment_from_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?specialized_equipment - specialized_equipment)
    :precondition
      (and
        (plan_linked_specialized_equipment ?recovery_staging_plan ?specialized_equipment)
      )
    :effect
      (and
        (specialized_equipment_available ?specialized_equipment)
        (not
          (plan_linked_specialized_equipment ?recovery_staging_plan ?specialized_equipment)
        )
      )
  )
  (:action bind_external_expert_to_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?external_consultant - external_consultant)
    :precondition
      (and
        (assessment_completed ?recovery_staging_plan)
        (external_expert_available ?external_consultant)
      )
    :effect
      (and
        (plan_linked_external_expert ?recovery_staging_plan ?external_consultant)
        (not
          (external_expert_available ?external_consultant)
        )
      )
  )
  (:action unbind_external_expert_from_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?external_consultant - external_consultant)
    :precondition
      (and
        (plan_linked_external_expert ?recovery_staging_plan ?external_consultant)
      )
    :effect
      (and
        (external_expert_available ?external_consultant)
        (not
          (plan_linked_external_expert ?recovery_staging_plan ?external_consultant)
        )
      )
  )
  (:action designate_local_staging_point
    :parameters (?primary_site_section - primary_site_section ?local_staging_point - local_staging_point ?sampling_kit - sampling_kit)
    :precondition
      (and
        (assessment_completed ?primary_site_section)
        (sampling_kit_assigned_to_site ?primary_site_section ?sampling_kit)
        (primary_section_linked_to_local_staging_point ?primary_site_section ?local_staging_point)
        (not
          (local_staging_point_designated ?local_staging_point)
        )
        (not
          (local_staging_point_treatment_applied ?local_staging_point)
        )
      )
    :effect (local_staging_point_designated ?local_staging_point)
  )
  (:action validate_primary_section_with_response_team
    :parameters (?primary_site_section - primary_site_section ?local_staging_point - local_staging_point ?response_decon_team - response_decon_team)
    :precondition
      (and
        (assessment_completed ?primary_site_section)
        (response_team_assigned_to_site ?primary_site_section ?response_decon_team)
        (primary_section_linked_to_local_staging_point ?primary_site_section ?local_staging_point)
        (local_staging_point_designated ?local_staging_point)
        (not
          (primary_section_prepared_for_recovery ?primary_site_section)
        )
      )
    :effect
      (and
        (primary_section_prepared_for_recovery ?primary_site_section)
        (primary_section_validated_for_salvage ?primary_site_section)
      )
  )
  (:action apply_treatment_to_primary_section
    :parameters (?primary_site_section - primary_site_section ?local_staging_point - local_staging_point ?treatment_material - treatment_material)
    :precondition
      (and
        (assessment_completed ?primary_site_section)
        (primary_section_linked_to_local_staging_point ?primary_site_section ?local_staging_point)
        (treatment_material_available ?treatment_material)
        (not
          (primary_section_prepared_for_recovery ?primary_site_section)
        )
      )
    :effect
      (and
        (local_staging_point_treatment_applied ?local_staging_point)
        (primary_section_prepared_for_recovery ?primary_site_section)
        (primary_section_has_treatment_material ?primary_site_section ?treatment_material)
        (not
          (treatment_material_available ?treatment_material)
        )
      )
  )
  (:action finalize_treatment_and_prepare_primary_section
    :parameters (?primary_site_section - primary_site_section ?local_staging_point - local_staging_point ?sampling_kit - sampling_kit ?treatment_material - treatment_material)
    :precondition
      (and
        (assessment_completed ?primary_site_section)
        (sampling_kit_assigned_to_site ?primary_site_section ?sampling_kit)
        (primary_section_linked_to_local_staging_point ?primary_site_section ?local_staging_point)
        (local_staging_point_treatment_applied ?local_staging_point)
        (primary_section_has_treatment_material ?primary_site_section ?treatment_material)
        (not
          (primary_section_validated_for_salvage ?primary_site_section)
        )
      )
    :effect
      (and
        (local_staging_point_designated ?local_staging_point)
        (primary_section_validated_for_salvage ?primary_site_section)
        (treatment_material_available ?treatment_material)
        (not
          (primary_section_has_treatment_material ?primary_site_section ?treatment_material)
        )
      )
  )
  (:action designate_secondary_staging_point_for_salvage
    :parameters (?secondary_site_section - secondary_site_section ?secondary_staging_point - secondary_staging_point ?sampling_kit - sampling_kit)
    :precondition
      (and
        (assessment_completed ?secondary_site_section)
        (sampling_kit_assigned_to_site ?secondary_site_section ?sampling_kit)
        (secondary_section_linked_to_secondary_staging_point ?secondary_site_section ?secondary_staging_point)
        (not
          (secondary_staging_point_designated ?secondary_staging_point)
        )
        (not
          (secondary_staging_point_treatment_applied ?secondary_staging_point)
        )
      )
    :effect (secondary_staging_point_designated ?secondary_staging_point)
  )
  (:action validate_secondary_section_with_response_team
    :parameters (?secondary_site_section - secondary_site_section ?secondary_staging_point - secondary_staging_point ?response_decon_team - response_decon_team)
    :precondition
      (and
        (assessment_completed ?secondary_site_section)
        (response_team_assigned_to_site ?secondary_site_section ?response_decon_team)
        (secondary_section_linked_to_secondary_staging_point ?secondary_site_section ?secondary_staging_point)
        (secondary_staging_point_designated ?secondary_staging_point)
        (not
          (secondary_section_prepared_for_recovery ?secondary_site_section)
        )
      )
    :effect
      (and
        (secondary_section_prepared_for_recovery ?secondary_site_section)
        (secondary_section_validated_for_salvage ?secondary_site_section)
      )
  )
  (:action apply_treatment_to_secondary_section
    :parameters (?secondary_site_section - secondary_site_section ?secondary_staging_point - secondary_staging_point ?treatment_material - treatment_material)
    :precondition
      (and
        (assessment_completed ?secondary_site_section)
        (secondary_section_linked_to_secondary_staging_point ?secondary_site_section ?secondary_staging_point)
        (treatment_material_available ?treatment_material)
        (not
          (secondary_section_prepared_for_recovery ?secondary_site_section)
        )
      )
    :effect
      (and
        (secondary_staging_point_treatment_applied ?secondary_staging_point)
        (secondary_section_prepared_for_recovery ?secondary_site_section)
        (secondary_section_has_treatment_material ?secondary_site_section ?treatment_material)
        (not
          (treatment_material_available ?treatment_material)
        )
      )
  )
  (:action finalize_treatment_and_prepare_secondary_section
    :parameters (?secondary_site_section - secondary_site_section ?secondary_staging_point - secondary_staging_point ?sampling_kit - sampling_kit ?treatment_material - treatment_material)
    :precondition
      (and
        (assessment_completed ?secondary_site_section)
        (sampling_kit_assigned_to_site ?secondary_site_section ?sampling_kit)
        (secondary_section_linked_to_secondary_staging_point ?secondary_site_section ?secondary_staging_point)
        (secondary_staging_point_treatment_applied ?secondary_staging_point)
        (secondary_section_has_treatment_material ?secondary_site_section ?treatment_material)
        (not
          (secondary_section_validated_for_salvage ?secondary_site_section)
        )
      )
    :effect
      (and
        (secondary_staging_point_designated ?secondary_staging_point)
        (secondary_section_validated_for_salvage ?secondary_site_section)
        (treatment_material_available ?treatment_material)
        (not
          (secondary_section_has_treatment_material ?secondary_site_section ?treatment_material)
        )
      )
  )
  (:action assemble_recovery_package
    :parameters (?primary_site_section - primary_site_section ?secondary_site_section - secondary_site_section ?local_staging_point - local_staging_point ?secondary_staging_point - secondary_staging_point ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_section_prepared_for_recovery ?primary_site_section)
        (secondary_section_prepared_for_recovery ?secondary_site_section)
        (primary_section_linked_to_local_staging_point ?primary_site_section ?local_staging_point)
        (secondary_section_linked_to_secondary_staging_point ?secondary_site_section ?secondary_staging_point)
        (local_staging_point_designated ?local_staging_point)
        (secondary_staging_point_designated ?secondary_staging_point)
        (primary_section_validated_for_salvage ?primary_site_section)
        (secondary_section_validated_for_salvage ?secondary_site_section)
        (recovery_package_available_for_assembly ?recovery_package)
      )
    :effect
      (and
        (recovery_package_assembled ?recovery_package)
        (recovery_package_linked_to_local_staging_point ?recovery_package ?local_staging_point)
        (recovery_package_linked_to_secondary_staging_point ?recovery_package ?secondary_staging_point)
        (not
          (recovery_package_available_for_assembly ?recovery_package)
        )
      )
  )
  (:action assemble_recovery_package_with_local_treatment
    :parameters (?primary_site_section - primary_site_section ?secondary_site_section - secondary_site_section ?local_staging_point - local_staging_point ?secondary_staging_point - secondary_staging_point ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_section_prepared_for_recovery ?primary_site_section)
        (secondary_section_prepared_for_recovery ?secondary_site_section)
        (primary_section_linked_to_local_staging_point ?primary_site_section ?local_staging_point)
        (secondary_section_linked_to_secondary_staging_point ?secondary_site_section ?secondary_staging_point)
        (local_staging_point_treatment_applied ?local_staging_point)
        (secondary_staging_point_designated ?secondary_staging_point)
        (not
          (primary_section_validated_for_salvage ?primary_site_section)
        )
        (secondary_section_validated_for_salvage ?secondary_site_section)
        (recovery_package_available_for_assembly ?recovery_package)
      )
    :effect
      (and
        (recovery_package_assembled ?recovery_package)
        (recovery_package_linked_to_local_staging_point ?recovery_package ?local_staging_point)
        (recovery_package_linked_to_secondary_staging_point ?recovery_package ?secondary_staging_point)
        (recovery_package_equipment_binding_required ?recovery_package)
        (not
          (recovery_package_available_for_assembly ?recovery_package)
        )
      )
  )
  (:action assemble_recovery_package_with_secondary_treatment
    :parameters (?primary_site_section - primary_site_section ?secondary_site_section - secondary_site_section ?local_staging_point - local_staging_point ?secondary_staging_point - secondary_staging_point ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_section_prepared_for_recovery ?primary_site_section)
        (secondary_section_prepared_for_recovery ?secondary_site_section)
        (primary_section_linked_to_local_staging_point ?primary_site_section ?local_staging_point)
        (secondary_section_linked_to_secondary_staging_point ?secondary_site_section ?secondary_staging_point)
        (local_staging_point_designated ?local_staging_point)
        (secondary_staging_point_treatment_applied ?secondary_staging_point)
        (primary_section_validated_for_salvage ?primary_site_section)
        (not
          (secondary_section_validated_for_salvage ?secondary_site_section)
        )
        (recovery_package_available_for_assembly ?recovery_package)
      )
    :effect
      (and
        (recovery_package_assembled ?recovery_package)
        (recovery_package_linked_to_local_staging_point ?recovery_package ?local_staging_point)
        (recovery_package_linked_to_secondary_staging_point ?recovery_package ?secondary_staging_point)
        (recovery_package_expert_binding_required ?recovery_package)
        (not
          (recovery_package_available_for_assembly ?recovery_package)
        )
      )
  )
  (:action assemble_recovery_package_with_both_treatments
    :parameters (?primary_site_section - primary_site_section ?secondary_site_section - secondary_site_section ?local_staging_point - local_staging_point ?secondary_staging_point - secondary_staging_point ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_section_prepared_for_recovery ?primary_site_section)
        (secondary_section_prepared_for_recovery ?secondary_site_section)
        (primary_section_linked_to_local_staging_point ?primary_site_section ?local_staging_point)
        (secondary_section_linked_to_secondary_staging_point ?secondary_site_section ?secondary_staging_point)
        (local_staging_point_treatment_applied ?local_staging_point)
        (secondary_staging_point_treatment_applied ?secondary_staging_point)
        (not
          (primary_section_validated_for_salvage ?primary_site_section)
        )
        (not
          (secondary_section_validated_for_salvage ?secondary_site_section)
        )
        (recovery_package_available_for_assembly ?recovery_package)
      )
    :effect
      (and
        (recovery_package_assembled ?recovery_package)
        (recovery_package_linked_to_local_staging_point ?recovery_package ?local_staging_point)
        (recovery_package_linked_to_secondary_staging_point ?recovery_package ?secondary_staging_point)
        (recovery_package_equipment_binding_required ?recovery_package)
        (recovery_package_expert_binding_required ?recovery_package)
        (not
          (recovery_package_available_for_assembly ?recovery_package)
        )
      )
  )
  (:action verify_recovery_package_quality
    :parameters (?recovery_package - recovery_package ?primary_site_section - primary_site_section ?sampling_kit - sampling_kit)
    :precondition
      (and
        (recovery_package_assembled ?recovery_package)
        (primary_section_prepared_for_recovery ?primary_site_section)
        (sampling_kit_assigned_to_site ?primary_site_section ?sampling_kit)
        (not
          (recovery_package_quality_checked ?recovery_package)
        )
      )
    :effect (recovery_package_quality_checked ?recovery_package)
  )
  (:action validate_salvage_batch_and_assign_to_package
    :parameters (?recovery_staging_plan - recovery_staging_plan ?salvage_batch - salvage_batch ?recovery_package - recovery_package)
    :precondition
      (and
        (assessment_completed ?recovery_staging_plan)
        (plan_includes_package ?recovery_staging_plan ?recovery_package)
        (plan_associated_salvage_batch ?recovery_staging_plan ?salvage_batch)
        (salvage_batch_available ?salvage_batch)
        (recovery_package_assembled ?recovery_package)
        (recovery_package_quality_checked ?recovery_package)
        (not
          (salvage_batch_validated ?salvage_batch)
        )
      )
    :effect
      (and
        (salvage_batch_validated ?salvage_batch)
        (salvage_batch_assigned_to_package ?salvage_batch ?recovery_package)
        (not
          (salvage_batch_available ?salvage_batch)
        )
      )
  )
  (:action confirm_salvage_batch_for_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?salvage_batch - salvage_batch ?recovery_package - recovery_package ?sampling_kit - sampling_kit)
    :precondition
      (and
        (assessment_completed ?recovery_staging_plan)
        (plan_associated_salvage_batch ?recovery_staging_plan ?salvage_batch)
        (salvage_batch_validated ?salvage_batch)
        (salvage_batch_assigned_to_package ?salvage_batch ?recovery_package)
        (sampling_kit_assigned_to_site ?recovery_staging_plan ?sampling_kit)
        (not
          (recovery_package_equipment_binding_required ?recovery_package)
        )
        (not
          (plan_ready_for_resource_binding ?recovery_staging_plan)
        )
      )
    :effect (plan_ready_for_resource_binding ?recovery_staging_plan)
  )
  (:action attach_approval_certificate_to_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?approval_certificate - approval_certificate)
    :precondition
      (and
        (assessment_completed ?recovery_staging_plan)
        (approval_certificate_available ?approval_certificate)
        (not
          (plan_has_approval_certificate ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (plan_has_approval_certificate ?recovery_staging_plan)
        (plan_linked_approval_certificate ?recovery_staging_plan ?approval_certificate)
        (not
          (approval_certificate_available ?approval_certificate)
        )
      )
  )
  (:action apply_certificate_and_prepare_plan_for_binding
    :parameters (?recovery_staging_plan - recovery_staging_plan ?salvage_batch - salvage_batch ?recovery_package - recovery_package ?sampling_kit - sampling_kit ?approval_certificate - approval_certificate)
    :precondition
      (and
        (assessment_completed ?recovery_staging_plan)
        (plan_associated_salvage_batch ?recovery_staging_plan ?salvage_batch)
        (salvage_batch_validated ?salvage_batch)
        (salvage_batch_assigned_to_package ?salvage_batch ?recovery_package)
        (sampling_kit_assigned_to_site ?recovery_staging_plan ?sampling_kit)
        (recovery_package_equipment_binding_required ?recovery_package)
        (plan_has_approval_certificate ?recovery_staging_plan)
        (plan_linked_approval_certificate ?recovery_staging_plan ?approval_certificate)
        (not
          (plan_ready_for_resource_binding ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (plan_ready_for_resource_binding ?recovery_staging_plan)
        (plan_approval_certificate_confirmed ?recovery_staging_plan)
      )
  )
  (:action allocate_specialized_equipment_to_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?specialized_equipment - specialized_equipment ?response_decon_team - response_decon_team ?salvage_batch - salvage_batch ?recovery_package - recovery_package)
    :precondition
      (and
        (plan_ready_for_resource_binding ?recovery_staging_plan)
        (plan_linked_specialized_equipment ?recovery_staging_plan ?specialized_equipment)
        (response_team_assigned_to_site ?recovery_staging_plan ?response_decon_team)
        (plan_associated_salvage_batch ?recovery_staging_plan ?salvage_batch)
        (salvage_batch_assigned_to_package ?salvage_batch ?recovery_package)
        (not
          (recovery_package_expert_binding_required ?recovery_package)
        )
        (not
          (plan_resources_bound ?recovery_staging_plan)
        )
      )
    :effect (plan_resources_bound ?recovery_staging_plan)
  )
  (:action allocate_specialized_equipment_to_plan_finalize
    :parameters (?recovery_staging_plan - recovery_staging_plan ?specialized_equipment - specialized_equipment ?response_decon_team - response_decon_team ?salvage_batch - salvage_batch ?recovery_package - recovery_package)
    :precondition
      (and
        (plan_ready_for_resource_binding ?recovery_staging_plan)
        (plan_linked_specialized_equipment ?recovery_staging_plan ?specialized_equipment)
        (response_team_assigned_to_site ?recovery_staging_plan ?response_decon_team)
        (plan_associated_salvage_batch ?recovery_staging_plan ?salvage_batch)
        (salvage_batch_assigned_to_package ?salvage_batch ?recovery_package)
        (recovery_package_expert_binding_required ?recovery_package)
        (not
          (plan_resources_bound ?recovery_staging_plan)
        )
      )
    :effect (plan_resources_bound ?recovery_staging_plan)
  )
  (:action complete_plan_validation_with_external_expert
    :parameters (?recovery_staging_plan - recovery_staging_plan ?external_consultant - external_consultant ?salvage_batch - salvage_batch ?recovery_package - recovery_package)
    :precondition
      (and
        (plan_resources_bound ?recovery_staging_plan)
        (plan_linked_external_expert ?recovery_staging_plan ?external_consultant)
        (plan_associated_salvage_batch ?recovery_staging_plan ?salvage_batch)
        (salvage_batch_assigned_to_package ?salvage_batch ?recovery_package)
        (not
          (recovery_package_equipment_binding_required ?recovery_package)
        )
        (not
          (recovery_package_expert_binding_required ?recovery_package)
        )
        (not
          (plan_validated_for_activation ?recovery_staging_plan)
        )
      )
    :effect (plan_validated_for_activation ?recovery_staging_plan)
  )
  (:action confirm_expert_binding_and_mark_logistics_ready
    :parameters (?recovery_staging_plan - recovery_staging_plan ?external_consultant - external_consultant ?salvage_batch - salvage_batch ?recovery_package - recovery_package)
    :precondition
      (and
        (plan_resources_bound ?recovery_staging_plan)
        (plan_linked_external_expert ?recovery_staging_plan ?external_consultant)
        (plan_associated_salvage_batch ?recovery_staging_plan ?salvage_batch)
        (salvage_batch_assigned_to_package ?salvage_batch ?recovery_package)
        (recovery_package_equipment_binding_required ?recovery_package)
        (not
          (recovery_package_expert_binding_required ?recovery_package)
        )
        (not
          (plan_validated_for_activation ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (plan_validated_for_activation ?recovery_staging_plan)
        (plan_ready_for_transport_binding ?recovery_staging_plan)
      )
  )
  (:action confirm_expert_binding_and_mark_logistics_ready_post_equipment
    :parameters (?recovery_staging_plan - recovery_staging_plan ?external_consultant - external_consultant ?salvage_batch - salvage_batch ?recovery_package - recovery_package)
    :precondition
      (and
        (plan_resources_bound ?recovery_staging_plan)
        (plan_linked_external_expert ?recovery_staging_plan ?external_consultant)
        (plan_associated_salvage_batch ?recovery_staging_plan ?salvage_batch)
        (salvage_batch_assigned_to_package ?salvage_batch ?recovery_package)
        (not
          (recovery_package_equipment_binding_required ?recovery_package)
        )
        (recovery_package_expert_binding_required ?recovery_package)
        (not
          (plan_validated_for_activation ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (plan_validated_for_activation ?recovery_staging_plan)
        (plan_ready_for_transport_binding ?recovery_staging_plan)
      )
  )
  (:action confirm_expert_binding_and_mark_logistics_ready_with_all_bindings
    :parameters (?recovery_staging_plan - recovery_staging_plan ?external_consultant - external_consultant ?salvage_batch - salvage_batch ?recovery_package - recovery_package)
    :precondition
      (and
        (plan_resources_bound ?recovery_staging_plan)
        (plan_linked_external_expert ?recovery_staging_plan ?external_consultant)
        (plan_associated_salvage_batch ?recovery_staging_plan ?salvage_batch)
        (salvage_batch_assigned_to_package ?salvage_batch ?recovery_package)
        (recovery_package_equipment_binding_required ?recovery_package)
        (recovery_package_expert_binding_required ?recovery_package)
        (not
          (plan_validated_for_activation ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (plan_validated_for_activation ?recovery_staging_plan)
        (plan_ready_for_transport_binding ?recovery_staging_plan)
      )
  )
  (:action finalize_plan_for_execution_without_logistics
    :parameters (?recovery_staging_plan - recovery_staging_plan)
    :precondition
      (and
        (plan_validated_for_activation ?recovery_staging_plan)
        (not
          (plan_ready_for_transport_binding ?recovery_staging_plan)
        )
        (not
          (plan_marked_ready_for_execution ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (plan_marked_ready_for_execution ?recovery_staging_plan)
        (ready_for_recovery ?recovery_staging_plan)
      )
  )
  (:action bind_transport_asset_to_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?transport_asset - transport_asset)
    :precondition
      (and
        (plan_validated_for_activation ?recovery_staging_plan)
        (plan_ready_for_transport_binding ?recovery_staging_plan)
        (transport_asset_available ?transport_asset)
      )
    :effect
      (and
        (plan_linked_transport_asset ?recovery_staging_plan ?transport_asset)
        (not
          (transport_asset_available ?transport_asset)
        )
      )
  )
  (:action perform_final_preparation_checks_for_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?primary_site_section - primary_site_section ?secondary_site_section - secondary_site_section ?sampling_kit - sampling_kit ?transport_asset - transport_asset)
    :precondition
      (and
        (plan_validated_for_activation ?recovery_staging_plan)
        (plan_ready_for_transport_binding ?recovery_staging_plan)
        (plan_linked_transport_asset ?recovery_staging_plan ?transport_asset)
        (plan_includes_primary_section ?recovery_staging_plan ?primary_site_section)
        (plan_includes_secondary_section ?recovery_staging_plan ?secondary_site_section)
        (primary_section_validated_for_salvage ?primary_site_section)
        (secondary_section_validated_for_salvage ?secondary_site_section)
        (sampling_kit_assigned_to_site ?recovery_staging_plan ?sampling_kit)
        (not
          (plan_final_checks_passed ?recovery_staging_plan)
        )
      )
    :effect (plan_final_checks_passed ?recovery_staging_plan)
  )
  (:action finalize_plan_for_execution_after_checks
    :parameters (?recovery_staging_plan - recovery_staging_plan)
    :precondition
      (and
        (plan_validated_for_activation ?recovery_staging_plan)
        (plan_final_checks_passed ?recovery_staging_plan)
        (not
          (plan_marked_ready_for_execution ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (plan_marked_ready_for_execution ?recovery_staging_plan)
        (ready_for_recovery ?recovery_staging_plan)
      )
  )
  (:action attach_regulatory_certificate_to_plan
    :parameters (?recovery_staging_plan - recovery_staging_plan ?regulatory_certificate - regulatory_certificate ?sampling_kit - sampling_kit)
    :precondition
      (and
        (assessment_completed ?recovery_staging_plan)
        (sampling_kit_assigned_to_site ?recovery_staging_plan ?sampling_kit)
        (regulatory_certificate_available ?regulatory_certificate)
        (plan_linked_regulatory_certificate ?recovery_staging_plan ?regulatory_certificate)
        (not
          (plan_regulatory_certificate_attached ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (plan_regulatory_certificate_attached ?recovery_staging_plan)
        (not
          (regulatory_certificate_available ?regulatory_certificate)
        )
      )
  )
  (:action mark_plan_audit_trail
    :parameters (?recovery_staging_plan - recovery_staging_plan ?response_decon_team - response_decon_team)
    :precondition
      (and
        (plan_regulatory_certificate_attached ?recovery_staging_plan)
        (response_team_assigned_to_site ?recovery_staging_plan ?response_decon_team)
        (not
          (plan_audit_trail_marked ?recovery_staging_plan)
        )
      )
    :effect (plan_audit_trail_marked ?recovery_staging_plan)
  )
  (:action record_external_expert_review
    :parameters (?recovery_staging_plan - recovery_staging_plan ?external_consultant - external_consultant)
    :precondition
      (and
        (plan_audit_trail_marked ?recovery_staging_plan)
        (plan_linked_external_expert ?recovery_staging_plan ?external_consultant)
        (not
          (plan_expert_reviewed ?recovery_staging_plan)
        )
      )
    :effect (plan_expert_reviewed ?recovery_staging_plan)
  )
  (:action finalize_plan_after_expert_review
    :parameters (?recovery_staging_plan - recovery_staging_plan)
    :precondition
      (and
        (plan_expert_reviewed ?recovery_staging_plan)
        (not
          (plan_marked_ready_for_execution ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (plan_marked_ready_for_execution ?recovery_staging_plan)
        (ready_for_recovery ?recovery_staging_plan)
      )
  )
  (:action execute_salvage_on_primary_section
    :parameters (?primary_site_section - primary_site_section ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_section_prepared_for_recovery ?primary_site_section)
        (primary_section_validated_for_salvage ?primary_site_section)
        (recovery_package_assembled ?recovery_package)
        (recovery_package_quality_checked ?recovery_package)
        (not
          (ready_for_recovery ?primary_site_section)
        )
      )
    :effect (ready_for_recovery ?primary_site_section)
  )
  (:action execute_salvage_on_secondary_section
    :parameters (?secondary_site_section - secondary_site_section ?recovery_package - recovery_package)
    :precondition
      (and
        (secondary_section_prepared_for_recovery ?secondary_site_section)
        (secondary_section_validated_for_salvage ?secondary_site_section)
        (recovery_package_assembled ?recovery_package)
        (recovery_package_quality_checked ?recovery_package)
        (not
          (ready_for_recovery ?secondary_site_section)
        )
      )
    :effect (ready_for_recovery ?secondary_site_section)
  )
  (:action assign_recovery_permit_to_site
    :parameters (?production_site - production_site ?recovery_permit - recovery_permit ?sampling_kit - sampling_kit)
    :precondition
      (and
        (ready_for_recovery ?production_site)
        (sampling_kit_assigned_to_site ?production_site ?sampling_kit)
        (recovery_permit_available ?recovery_permit)
        (not
          (permit_assigned ?production_site)
        )
      )
    :effect
      (and
        (permit_assigned ?production_site)
        (site_linked_recovery_permit ?production_site ?recovery_permit)
        (not
          (recovery_permit_available ?recovery_permit)
        )
      )
  )
  (:action complete_recovery_of_primary_section_and_release_resources
    :parameters (?primary_site_section - primary_site_section ?assessment_team - assessment_team ?recovery_permit - recovery_permit)
    :precondition
      (and
        (permit_assigned ?primary_site_section)
        (assessment_team_assigned_to_site ?primary_site_section ?assessment_team)
        (site_linked_recovery_permit ?primary_site_section ?recovery_permit)
        (not
          (recovery_confirmed ?primary_site_section)
        )
      )
    :effect
      (and
        (recovery_confirmed ?primary_site_section)
        (assessment_team_available ?assessment_team)
        (recovery_permit_available ?recovery_permit)
      )
  )
  (:action complete_recovery_of_secondary_section_and_release_resources
    :parameters (?secondary_site_section - secondary_site_section ?assessment_team - assessment_team ?recovery_permit - recovery_permit)
    :precondition
      (and
        (permit_assigned ?secondary_site_section)
        (assessment_team_assigned_to_site ?secondary_site_section ?assessment_team)
        (site_linked_recovery_permit ?secondary_site_section ?recovery_permit)
        (not
          (recovery_confirmed ?secondary_site_section)
        )
      )
    :effect
      (and
        (recovery_confirmed ?secondary_site_section)
        (assessment_team_available ?assessment_team)
        (recovery_permit_available ?recovery_permit)
      )
  )
  (:action complete_recovery_plan_and_release_resources
    :parameters (?recovery_staging_plan - recovery_staging_plan ?assessment_team - assessment_team ?recovery_permit - recovery_permit)
    :precondition
      (and
        (permit_assigned ?recovery_staging_plan)
        (assessment_team_assigned_to_site ?recovery_staging_plan ?assessment_team)
        (site_linked_recovery_permit ?recovery_staging_plan ?recovery_permit)
        (not
          (recovery_confirmed ?recovery_staging_plan)
        )
      )
    :effect
      (and
        (recovery_confirmed ?recovery_staging_plan)
        (assessment_team_available ?assessment_team)
        (recovery_permit_available ?recovery_permit)
      )
  )
)

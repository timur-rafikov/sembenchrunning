(define (domain mission_abort_reentry_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types meta_tag - object asset_tag - object qualification_tag - object mission_entity - object mission_task - mission_entity extraction_asset - meta_tag trajectory_option - meta_tag crew_member - meta_tag upgrade_module - meta_tag consumable_item - meta_tag recovery_point - meta_tag special_tool - meta_tag certification_token - meta_tag equipment_item - asset_tag integration_module - asset_tag priority_marker - asset_tag approach_slot - qualification_tag support_slot - qualification_tag reentry_craft - qualification_tag primary_group - mission_task unit_group - mission_task primary_unit - primary_group secondary_unit - primary_group mission_unit - unit_group)
  (:predicates
    (abort_logged ?mission_item - mission_task)
    (mission_plan_validated ?mission_item - mission_task)
    (asset_reserved ?mission_item - mission_task)
    (reentry_ready ?mission_item - mission_task)
    (mission_salvage_recorded ?mission_item - mission_task)
    (mission_salvage_completed ?mission_item - mission_task)
    (asset_available ?extraction_asset - extraction_asset)
    (asset_assigned_to_mission_entity ?mission_item - mission_task ?extraction_asset - extraction_asset)
    (trajectory_available ?trajectory_option - trajectory_option)
    (trajectory_assigned_to_mission_entity ?mission_item - mission_task ?trajectory_option - trajectory_option)
    (crew_available ?crew_member - crew_member)
    (crew_assigned_to_mission_entity ?mission_item - mission_task ?crew_member - crew_member)
    (equipment_available ?equipment_item - equipment_item)
    (equipment_assigned_to_primary_unit ?primary_unit - primary_unit ?equipment_item - equipment_item)
    (equipment_assigned_to_secondary_unit ?secondary_unit - secondary_unit ?equipment_item - equipment_item)
    (primary_bound_to_approach_slot ?primary_unit - primary_unit ?approach_slot - approach_slot)
    (approach_slot_claimed ?approach_slot - approach_slot)
    (approach_slot_supplied ?approach_slot - approach_slot)
    (primary_unit_confirmed ?primary_unit - primary_unit)
    (secondary_bound_to_support_slot ?secondary_unit - secondary_unit ?support_slot - support_slot)
    (support_slot_claimed ?support_slot - support_slot)
    (support_slot_supplied ?support_slot - support_slot)
    (secondary_unit_confirmed ?secondary_unit - secondary_unit)
    (craft_available ?reentry_craft - reentry_craft)
    (craft_staged ?reentry_craft - reentry_craft)
    (craft_bound_to_approach_slot ?reentry_craft - reentry_craft ?approach_slot - approach_slot)
    (craft_bound_to_support_slot ?reentry_craft - reentry_craft ?support_slot - support_slot)
    (craft_primary_slot_verified ?reentry_craft - reentry_craft)
    (craft_support_slot_verified ?reentry_craft - reentry_craft)
    (craft_integration_ready ?reentry_craft - reentry_craft)
    (unit_has_primary ?mission_unit - mission_unit ?primary_unit - primary_unit)
    (unit_has_secondary ?mission_unit - mission_unit ?secondary_unit - secondary_unit)
    (unit_assigned_to_craft ?mission_unit - mission_unit ?reentry_craft - reentry_craft)
    (module_available ?integration_module - integration_module)
    (unit_has_integration_module ?mission_unit - mission_unit ?integration_module - integration_module)
    (module_installed ?integration_module - integration_module)
    (module_integrated_into_craft ?integration_module - integration_module ?reentry_craft - reentry_craft)
    (unit_module_integration_checked ?mission_unit - mission_unit)
    (unit_module_tool_check_passed ?mission_unit - mission_unit)
    (unit_certification_step_completed ?mission_unit - mission_unit)
    (unit_upgrade_flag ?mission_unit - mission_unit)
    (unit_post_upgrade_check ?mission_unit - mission_unit)
    (unit_ready_for_finalization ?mission_unit - mission_unit)
    (unit_integration_completed ?mission_unit - mission_unit)
    (priority_marker_available ?priority_marker - priority_marker)
    (unit_assigned_priority_marker ?mission_unit - mission_unit ?priority_marker - priority_marker)
    (unit_priority_engaged ?mission_unit - mission_unit)
    (unit_priority_check_passed ?mission_unit - mission_unit)
    (unit_priority_confirmed ?mission_unit - mission_unit)
    (upgrade_available ?upgrade_module - upgrade_module)
    (unit_upgrade_installed ?mission_unit - mission_unit ?upgrade_module - upgrade_module)
    (consumable_available ?consumable_item - consumable_item)
    (unit_consumable_assigned ?mission_unit - mission_unit ?consumable_item - consumable_item)
    (special_tool_available ?special_tool - special_tool)
    (unit_special_tool_assigned ?mission_unit - mission_unit ?special_tool - special_tool)
    (certification_available ?certification_token - certification_token)
    (unit_certification_assigned ?mission_unit - mission_unit ?certification_token - certification_token)
    (recovery_point_available ?recovery_point - recovery_point)
    (recovery_point_assigned_to_mission_entity ?mission_item - mission_task ?recovery_point - recovery_point)
    (primary_unit_prepared ?primary_unit - primary_unit)
    (secondary_unit_prepared ?secondary_unit - secondary_unit)
    (unit_finalized ?mission_unit - mission_unit)
  )
  (:action record_abort
    :parameters (?mission_item - mission_task)
    :precondition
      (and
        (not
          (abort_logged ?mission_item)
        )
        (not
          (reentry_ready ?mission_item)
        )
      )
    :effect (abort_logged ?mission_item)
  )
  (:action reserve_extraction_asset
    :parameters (?mission_item - mission_task ?extraction_asset - extraction_asset)
    :precondition
      (and
        (abort_logged ?mission_item)
        (not
          (asset_reserved ?mission_item)
        )
        (asset_available ?extraction_asset)
      )
    :effect
      (and
        (asset_reserved ?mission_item)
        (asset_assigned_to_mission_entity ?mission_item ?extraction_asset)
        (not
          (asset_available ?extraction_asset)
        )
      )
  )
  (:action assign_trajectory_option
    :parameters (?mission_item - mission_task ?trajectory_option - trajectory_option)
    :precondition
      (and
        (abort_logged ?mission_item)
        (asset_reserved ?mission_item)
        (trajectory_available ?trajectory_option)
      )
    :effect
      (and
        (trajectory_assigned_to_mission_entity ?mission_item ?trajectory_option)
        (not
          (trajectory_available ?trajectory_option)
        )
      )
  )
  (:action validate_recovery_plan
    :parameters (?mission_item - mission_task ?trajectory_option - trajectory_option)
    :precondition
      (and
        (abort_logged ?mission_item)
        (asset_reserved ?mission_item)
        (trajectory_assigned_to_mission_entity ?mission_item ?trajectory_option)
        (not
          (mission_plan_validated ?mission_item)
        )
      )
    :effect (mission_plan_validated ?mission_item)
  )
  (:action release_trajectory_assignment
    :parameters (?mission_item - mission_task ?trajectory_option - trajectory_option)
    :precondition
      (and
        (trajectory_assigned_to_mission_entity ?mission_item ?trajectory_option)
      )
    :effect
      (and
        (trajectory_available ?trajectory_option)
        (not
          (trajectory_assigned_to_mission_entity ?mission_item ?trajectory_option)
        )
      )
  )
  (:action assign_crew_member
    :parameters (?mission_item - mission_task ?crew_member - crew_member)
    :precondition
      (and
        (mission_plan_validated ?mission_item)
        (crew_available ?crew_member)
      )
    :effect
      (and
        (crew_assigned_to_mission_entity ?mission_item ?crew_member)
        (not
          (crew_available ?crew_member)
        )
      )
  )
  (:action release_crew_member
    :parameters (?mission_item - mission_task ?crew_member - crew_member)
    :precondition
      (and
        (crew_assigned_to_mission_entity ?mission_item ?crew_member)
      )
    :effect
      (and
        (crew_available ?crew_member)
        (not
          (crew_assigned_to_mission_entity ?mission_item ?crew_member)
        )
      )
  )
  (:action attach_special_tool_to_unit
    :parameters (?mission_unit - mission_unit ?special_tool - special_tool)
    :precondition
      (and
        (mission_plan_validated ?mission_unit)
        (special_tool_available ?special_tool)
      )
    :effect
      (and
        (unit_special_tool_assigned ?mission_unit ?special_tool)
        (not
          (special_tool_available ?special_tool)
        )
      )
  )
  (:action detach_special_tool_from_unit
    :parameters (?mission_unit - mission_unit ?special_tool - special_tool)
    :precondition
      (and
        (unit_special_tool_assigned ?mission_unit ?special_tool)
      )
    :effect
      (and
        (special_tool_available ?special_tool)
        (not
          (unit_special_tool_assigned ?mission_unit ?special_tool)
        )
      )
  )
  (:action assign_certification_to_unit
    :parameters (?mission_unit - mission_unit ?certification_token - certification_token)
    :precondition
      (and
        (mission_plan_validated ?mission_unit)
        (certification_available ?certification_token)
      )
    :effect
      (and
        (unit_certification_assigned ?mission_unit ?certification_token)
        (not
          (certification_available ?certification_token)
        )
      )
  )
  (:action release_certification_from_unit
    :parameters (?mission_unit - mission_unit ?certification_token - certification_token)
    :precondition
      (and
        (unit_certification_assigned ?mission_unit ?certification_token)
      )
    :effect
      (and
        (certification_available ?certification_token)
        (not
          (unit_certification_assigned ?mission_unit ?certification_token)
        )
      )
  )
  (:action claim_approach_slot_for_primary
    :parameters (?primary_unit - primary_unit ?approach_slot - approach_slot ?trajectory_option - trajectory_option)
    :precondition
      (and
        (mission_plan_validated ?primary_unit)
        (trajectory_assigned_to_mission_entity ?primary_unit ?trajectory_option)
        (primary_bound_to_approach_slot ?primary_unit ?approach_slot)
        (not
          (approach_slot_claimed ?approach_slot)
        )
        (not
          (approach_slot_supplied ?approach_slot)
        )
      )
    :effect (approach_slot_claimed ?approach_slot)
  )
  (:action confirm_primary_unit_assignment
    :parameters (?primary_unit - primary_unit ?approach_slot - approach_slot ?crew_member - crew_member)
    :precondition
      (and
        (mission_plan_validated ?primary_unit)
        (crew_assigned_to_mission_entity ?primary_unit ?crew_member)
        (primary_bound_to_approach_slot ?primary_unit ?approach_slot)
        (approach_slot_claimed ?approach_slot)
        (not
          (primary_unit_prepared ?primary_unit)
        )
      )
    :effect
      (and
        (primary_unit_prepared ?primary_unit)
        (primary_unit_confirmed ?primary_unit)
      )
  )
  (:action supply_equipment_to_primary_unit
    :parameters (?primary_unit - primary_unit ?approach_slot - approach_slot ?equipment_item - equipment_item)
    :precondition
      (and
        (mission_plan_validated ?primary_unit)
        (primary_bound_to_approach_slot ?primary_unit ?approach_slot)
        (equipment_available ?equipment_item)
        (not
          (primary_unit_prepared ?primary_unit)
        )
      )
    :effect
      (and
        (approach_slot_supplied ?approach_slot)
        (primary_unit_prepared ?primary_unit)
        (equipment_assigned_to_primary_unit ?primary_unit ?equipment_item)
        (not
          (equipment_available ?equipment_item)
        )
      )
  )
  (:action finalize_primary_approach_readiness
    :parameters (?primary_unit - primary_unit ?approach_slot - approach_slot ?trajectory_option - trajectory_option ?equipment_item - equipment_item)
    :precondition
      (and
        (mission_plan_validated ?primary_unit)
        (trajectory_assigned_to_mission_entity ?primary_unit ?trajectory_option)
        (primary_bound_to_approach_slot ?primary_unit ?approach_slot)
        (approach_slot_supplied ?approach_slot)
        (equipment_assigned_to_primary_unit ?primary_unit ?equipment_item)
        (not
          (primary_unit_confirmed ?primary_unit)
        )
      )
    :effect
      (and
        (approach_slot_claimed ?approach_slot)
        (primary_unit_confirmed ?primary_unit)
        (equipment_available ?equipment_item)
        (not
          (equipment_assigned_to_primary_unit ?primary_unit ?equipment_item)
        )
      )
  )
  (:action claim_support_slot_for_secondary
    :parameters (?secondary_unit - secondary_unit ?support_slot - support_slot ?trajectory_option - trajectory_option)
    :precondition
      (and
        (mission_plan_validated ?secondary_unit)
        (trajectory_assigned_to_mission_entity ?secondary_unit ?trajectory_option)
        (secondary_bound_to_support_slot ?secondary_unit ?support_slot)
        (not
          (support_slot_claimed ?support_slot)
        )
        (not
          (support_slot_supplied ?support_slot)
        )
      )
    :effect (support_slot_claimed ?support_slot)
  )
  (:action confirm_secondary_unit_assignment
    :parameters (?secondary_unit - secondary_unit ?support_slot - support_slot ?crew_member - crew_member)
    :precondition
      (and
        (mission_plan_validated ?secondary_unit)
        (crew_assigned_to_mission_entity ?secondary_unit ?crew_member)
        (secondary_bound_to_support_slot ?secondary_unit ?support_slot)
        (support_slot_claimed ?support_slot)
        (not
          (secondary_unit_prepared ?secondary_unit)
        )
      )
    :effect
      (and
        (secondary_unit_prepared ?secondary_unit)
        (secondary_unit_confirmed ?secondary_unit)
      )
  )
  (:action supply_equipment_to_secondary_unit
    :parameters (?secondary_unit - secondary_unit ?support_slot - support_slot ?equipment_item - equipment_item)
    :precondition
      (and
        (mission_plan_validated ?secondary_unit)
        (secondary_bound_to_support_slot ?secondary_unit ?support_slot)
        (equipment_available ?equipment_item)
        (not
          (secondary_unit_prepared ?secondary_unit)
        )
      )
    :effect
      (and
        (support_slot_supplied ?support_slot)
        (secondary_unit_prepared ?secondary_unit)
        (equipment_assigned_to_secondary_unit ?secondary_unit ?equipment_item)
        (not
          (equipment_available ?equipment_item)
        )
      )
  )
  (:action finalize_secondary_support_readiness
    :parameters (?secondary_unit - secondary_unit ?support_slot - support_slot ?trajectory_option - trajectory_option ?equipment_item - equipment_item)
    :precondition
      (and
        (mission_plan_validated ?secondary_unit)
        (trajectory_assigned_to_mission_entity ?secondary_unit ?trajectory_option)
        (secondary_bound_to_support_slot ?secondary_unit ?support_slot)
        (support_slot_supplied ?support_slot)
        (equipment_assigned_to_secondary_unit ?secondary_unit ?equipment_item)
        (not
          (secondary_unit_confirmed ?secondary_unit)
        )
      )
    :effect
      (and
        (support_slot_claimed ?support_slot)
        (secondary_unit_confirmed ?secondary_unit)
        (equipment_available ?equipment_item)
        (not
          (equipment_assigned_to_secondary_unit ?secondary_unit ?equipment_item)
        )
      )
  )
  (:action stage_reentry_craft
    :parameters (?primary_unit - primary_unit ?secondary_unit - secondary_unit ?approach_slot - approach_slot ?support_slot - support_slot ?reentry_craft - reentry_craft)
    :precondition
      (and
        (primary_unit_prepared ?primary_unit)
        (secondary_unit_prepared ?secondary_unit)
        (primary_bound_to_approach_slot ?primary_unit ?approach_slot)
        (secondary_bound_to_support_slot ?secondary_unit ?support_slot)
        (approach_slot_claimed ?approach_slot)
        (support_slot_claimed ?support_slot)
        (primary_unit_confirmed ?primary_unit)
        (secondary_unit_confirmed ?secondary_unit)
        (craft_available ?reentry_craft)
      )
    :effect
      (and
        (craft_staged ?reentry_craft)
        (craft_bound_to_approach_slot ?reentry_craft ?approach_slot)
        (craft_bound_to_support_slot ?reentry_craft ?support_slot)
        (not
          (craft_available ?reentry_craft)
        )
      )
  )
  (:action stage_reentry_craft_with_primary_verification
    :parameters (?primary_unit - primary_unit ?secondary_unit - secondary_unit ?approach_slot - approach_slot ?support_slot - support_slot ?reentry_craft - reentry_craft)
    :precondition
      (and
        (primary_unit_prepared ?primary_unit)
        (secondary_unit_prepared ?secondary_unit)
        (primary_bound_to_approach_slot ?primary_unit ?approach_slot)
        (secondary_bound_to_support_slot ?secondary_unit ?support_slot)
        (approach_slot_supplied ?approach_slot)
        (support_slot_claimed ?support_slot)
        (not
          (primary_unit_confirmed ?primary_unit)
        )
        (secondary_unit_confirmed ?secondary_unit)
        (craft_available ?reentry_craft)
      )
    :effect
      (and
        (craft_staged ?reentry_craft)
        (craft_bound_to_approach_slot ?reentry_craft ?approach_slot)
        (craft_bound_to_support_slot ?reentry_craft ?support_slot)
        (craft_primary_slot_verified ?reentry_craft)
        (not
          (craft_available ?reentry_craft)
        )
      )
  )
  (:action stage_reentry_craft_with_secondary_verification
    :parameters (?primary_unit - primary_unit ?secondary_unit - secondary_unit ?approach_slot - approach_slot ?support_slot - support_slot ?reentry_craft - reentry_craft)
    :precondition
      (and
        (primary_unit_prepared ?primary_unit)
        (secondary_unit_prepared ?secondary_unit)
        (primary_bound_to_approach_slot ?primary_unit ?approach_slot)
        (secondary_bound_to_support_slot ?secondary_unit ?support_slot)
        (approach_slot_claimed ?approach_slot)
        (support_slot_supplied ?support_slot)
        (primary_unit_confirmed ?primary_unit)
        (not
          (secondary_unit_confirmed ?secondary_unit)
        )
        (craft_available ?reentry_craft)
      )
    :effect
      (and
        (craft_staged ?reentry_craft)
        (craft_bound_to_approach_slot ?reentry_craft ?approach_slot)
        (craft_bound_to_support_slot ?reentry_craft ?support_slot)
        (craft_support_slot_verified ?reentry_craft)
        (not
          (craft_available ?reentry_craft)
        )
      )
  )
  (:action stage_reentry_craft_full_verification
    :parameters (?primary_unit - primary_unit ?secondary_unit - secondary_unit ?approach_slot - approach_slot ?support_slot - support_slot ?reentry_craft - reentry_craft)
    :precondition
      (and
        (primary_unit_prepared ?primary_unit)
        (secondary_unit_prepared ?secondary_unit)
        (primary_bound_to_approach_slot ?primary_unit ?approach_slot)
        (secondary_bound_to_support_slot ?secondary_unit ?support_slot)
        (approach_slot_supplied ?approach_slot)
        (support_slot_supplied ?support_slot)
        (not
          (primary_unit_confirmed ?primary_unit)
        )
        (not
          (secondary_unit_confirmed ?secondary_unit)
        )
        (craft_available ?reentry_craft)
      )
    :effect
      (and
        (craft_staged ?reentry_craft)
        (craft_bound_to_approach_slot ?reentry_craft ?approach_slot)
        (craft_bound_to_support_slot ?reentry_craft ?support_slot)
        (craft_primary_slot_verified ?reentry_craft)
        (craft_support_slot_verified ?reentry_craft)
        (not
          (craft_available ?reentry_craft)
        )
      )
  )
  (:action mark_craft_integration_ready
    :parameters (?reentry_craft - reentry_craft ?primary_unit - primary_unit ?trajectory_option - trajectory_option)
    :precondition
      (and
        (craft_staged ?reentry_craft)
        (primary_unit_prepared ?primary_unit)
        (trajectory_assigned_to_mission_entity ?primary_unit ?trajectory_option)
        (not
          (craft_integration_ready ?reentry_craft)
        )
      )
    :effect (craft_integration_ready ?reentry_craft)
  )
  (:action install_integration_module
    :parameters (?mission_unit - mission_unit ?integration_module - integration_module ?reentry_craft - reentry_craft)
    :precondition
      (and
        (mission_plan_validated ?mission_unit)
        (unit_assigned_to_craft ?mission_unit ?reentry_craft)
        (unit_has_integration_module ?mission_unit ?integration_module)
        (module_available ?integration_module)
        (craft_staged ?reentry_craft)
        (craft_integration_ready ?reentry_craft)
        (not
          (module_installed ?integration_module)
        )
      )
    :effect
      (and
        (module_installed ?integration_module)
        (module_integrated_into_craft ?integration_module ?reentry_craft)
        (not
          (module_available ?integration_module)
        )
      )
  )
  (:action verify_module_installation
    :parameters (?mission_unit - mission_unit ?integration_module - integration_module ?reentry_craft - reentry_craft ?trajectory_option - trajectory_option)
    :precondition
      (and
        (mission_plan_validated ?mission_unit)
        (unit_has_integration_module ?mission_unit ?integration_module)
        (module_installed ?integration_module)
        (module_integrated_into_craft ?integration_module ?reentry_craft)
        (trajectory_assigned_to_mission_entity ?mission_unit ?trajectory_option)
        (not
          (craft_primary_slot_verified ?reentry_craft)
        )
        (not
          (unit_module_integration_checked ?mission_unit)
        )
      )
    :effect (unit_module_integration_checked ?mission_unit)
  )
  (:action apply_upgrade_module_to_unit
    :parameters (?mission_unit - mission_unit ?upgrade_module - upgrade_module)
    :precondition
      (and
        (mission_plan_validated ?mission_unit)
        (upgrade_available ?upgrade_module)
        (not
          (unit_upgrade_flag ?mission_unit)
        )
      )
    :effect
      (and
        (unit_upgrade_flag ?mission_unit)
        (unit_upgrade_installed ?mission_unit ?upgrade_module)
        (not
          (upgrade_available ?upgrade_module)
        )
      )
  )
  (:action integrate_upgrade_and_verify
    :parameters (?mission_unit - mission_unit ?integration_module - integration_module ?reentry_craft - reentry_craft ?trajectory_option - trajectory_option ?upgrade_module - upgrade_module)
    :precondition
      (and
        (mission_plan_validated ?mission_unit)
        (unit_has_integration_module ?mission_unit ?integration_module)
        (module_installed ?integration_module)
        (module_integrated_into_craft ?integration_module ?reentry_craft)
        (trajectory_assigned_to_mission_entity ?mission_unit ?trajectory_option)
        (craft_primary_slot_verified ?reentry_craft)
        (unit_upgrade_flag ?mission_unit)
        (unit_upgrade_installed ?mission_unit ?upgrade_module)
        (not
          (unit_module_integration_checked ?mission_unit)
        )
      )
    :effect
      (and
        (unit_module_integration_checked ?mission_unit)
        (unit_post_upgrade_check ?mission_unit)
      )
  )
  (:action perform_tool_and_crew_check
    :parameters (?mission_unit - mission_unit ?special_tool - special_tool ?crew_member - crew_member ?integration_module - integration_module ?reentry_craft - reentry_craft)
    :precondition
      (and
        (unit_module_integration_checked ?mission_unit)
        (unit_special_tool_assigned ?mission_unit ?special_tool)
        (crew_assigned_to_mission_entity ?mission_unit ?crew_member)
        (unit_has_integration_module ?mission_unit ?integration_module)
        (module_integrated_into_craft ?integration_module ?reentry_craft)
        (not
          (craft_support_slot_verified ?reentry_craft)
        )
        (not
          (unit_module_tool_check_passed ?mission_unit)
        )
      )
    :effect (unit_module_tool_check_passed ?mission_unit)
  )
  (:action perform_tool_and_crew_check_verified
    :parameters (?mission_unit - mission_unit ?special_tool - special_tool ?crew_member - crew_member ?integration_module - integration_module ?reentry_craft - reentry_craft)
    :precondition
      (and
        (unit_module_integration_checked ?mission_unit)
        (unit_special_tool_assigned ?mission_unit ?special_tool)
        (crew_assigned_to_mission_entity ?mission_unit ?crew_member)
        (unit_has_integration_module ?mission_unit ?integration_module)
        (module_integrated_into_craft ?integration_module ?reentry_craft)
        (craft_support_slot_verified ?reentry_craft)
        (not
          (unit_module_tool_check_passed ?mission_unit)
        )
      )
    :effect (unit_module_tool_check_passed ?mission_unit)
  )
  (:action process_unit_certification
    :parameters (?mission_unit - mission_unit ?certification_token - certification_token ?integration_module - integration_module ?reentry_craft - reentry_craft)
    :precondition
      (and
        (unit_module_tool_check_passed ?mission_unit)
        (unit_certification_assigned ?mission_unit ?certification_token)
        (unit_has_integration_module ?mission_unit ?integration_module)
        (module_integrated_into_craft ?integration_module ?reentry_craft)
        (not
          (craft_primary_slot_verified ?reentry_craft)
        )
        (not
          (craft_support_slot_verified ?reentry_craft)
        )
        (not
          (unit_certification_step_completed ?mission_unit)
        )
      )
    :effect (unit_certification_step_completed ?mission_unit)
  )
  (:action process_unit_certification_and_mark_ready
    :parameters (?mission_unit - mission_unit ?certification_token - certification_token ?integration_module - integration_module ?reentry_craft - reentry_craft)
    :precondition
      (and
        (unit_module_tool_check_passed ?mission_unit)
        (unit_certification_assigned ?mission_unit ?certification_token)
        (unit_has_integration_module ?mission_unit ?integration_module)
        (module_integrated_into_craft ?integration_module ?reentry_craft)
        (craft_primary_slot_verified ?reentry_craft)
        (not
          (craft_support_slot_verified ?reentry_craft)
        )
        (not
          (unit_certification_step_completed ?mission_unit)
        )
      )
    :effect
      (and
        (unit_certification_step_completed ?mission_unit)
        (unit_ready_for_finalization ?mission_unit)
      )
  )
  (:action process_unit_certification_and_finalize_checks
    :parameters (?mission_unit - mission_unit ?certification_token - certification_token ?integration_module - integration_module ?reentry_craft - reentry_craft)
    :precondition
      (and
        (unit_module_tool_check_passed ?mission_unit)
        (unit_certification_assigned ?mission_unit ?certification_token)
        (unit_has_integration_module ?mission_unit ?integration_module)
        (module_integrated_into_craft ?integration_module ?reentry_craft)
        (not
          (craft_primary_slot_verified ?reentry_craft)
        )
        (craft_support_slot_verified ?reentry_craft)
        (not
          (unit_certification_step_completed ?mission_unit)
        )
      )
    :effect
      (and
        (unit_certification_step_completed ?mission_unit)
        (unit_ready_for_finalization ?mission_unit)
      )
  )
  (:action complete_certification_checks
    :parameters (?mission_unit - mission_unit ?certification_token - certification_token ?integration_module - integration_module ?reentry_craft - reentry_craft)
    :precondition
      (and
        (unit_module_tool_check_passed ?mission_unit)
        (unit_certification_assigned ?mission_unit ?certification_token)
        (unit_has_integration_module ?mission_unit ?integration_module)
        (module_integrated_into_craft ?integration_module ?reentry_craft)
        (craft_primary_slot_verified ?reentry_craft)
        (craft_support_slot_verified ?reentry_craft)
        (not
          (unit_certification_step_completed ?mission_unit)
        )
      )
    :effect
      (and
        (unit_certification_step_completed ?mission_unit)
        (unit_ready_for_finalization ?mission_unit)
      )
  )
  (:action finalize_unit_and_record_salvage
    :parameters (?mission_unit - mission_unit)
    :precondition
      (and
        (unit_certification_step_completed ?mission_unit)
        (not
          (unit_ready_for_finalization ?mission_unit)
        )
        (not
          (unit_finalized ?mission_unit)
        )
      )
    :effect
      (and
        (unit_finalized ?mission_unit)
        (mission_salvage_recorded ?mission_unit)
      )
  )
  (:action assign_consumable_to_unit
    :parameters (?mission_unit - mission_unit ?consumable_item - consumable_item)
    :precondition
      (and
        (unit_certification_step_completed ?mission_unit)
        (unit_ready_for_finalization ?mission_unit)
        (consumable_available ?consumable_item)
      )
    :effect
      (and
        (unit_consumable_assigned ?mission_unit ?consumable_item)
        (not
          (consumable_available ?consumable_item)
        )
      )
  )
  (:action complete_unit_integration
    :parameters (?mission_unit - mission_unit ?primary_unit - primary_unit ?secondary_unit - secondary_unit ?trajectory_option - trajectory_option ?consumable_item - consumable_item)
    :precondition
      (and
        (unit_certification_step_completed ?mission_unit)
        (unit_ready_for_finalization ?mission_unit)
        (unit_consumable_assigned ?mission_unit ?consumable_item)
        (unit_has_primary ?mission_unit ?primary_unit)
        (unit_has_secondary ?mission_unit ?secondary_unit)
        (primary_unit_confirmed ?primary_unit)
        (secondary_unit_confirmed ?secondary_unit)
        (trajectory_assigned_to_mission_entity ?mission_unit ?trajectory_option)
        (not
          (unit_integration_completed ?mission_unit)
        )
      )
    :effect (unit_integration_completed ?mission_unit)
  )
  (:action finalize_unit_after_integration
    :parameters (?mission_unit - mission_unit)
    :precondition
      (and
        (unit_certification_step_completed ?mission_unit)
        (unit_integration_completed ?mission_unit)
        (not
          (unit_finalized ?mission_unit)
        )
      )
    :effect
      (and
        (unit_finalized ?mission_unit)
        (mission_salvage_recorded ?mission_unit)
      )
  )
  (:action assign_priority_marker_to_unit
    :parameters (?mission_unit - mission_unit ?priority_marker - priority_marker ?trajectory_option - trajectory_option)
    :precondition
      (and
        (mission_plan_validated ?mission_unit)
        (trajectory_assigned_to_mission_entity ?mission_unit ?trajectory_option)
        (priority_marker_available ?priority_marker)
        (unit_assigned_priority_marker ?mission_unit ?priority_marker)
        (not
          (unit_priority_engaged ?mission_unit)
        )
      )
    :effect
      (and
        (unit_priority_engaged ?mission_unit)
        (not
          (priority_marker_available ?priority_marker)
        )
      )
  )
  (:action confirm_unit_priority_check
    :parameters (?mission_unit - mission_unit ?crew_member - crew_member)
    :precondition
      (and
        (unit_priority_engaged ?mission_unit)
        (crew_assigned_to_mission_entity ?mission_unit ?crew_member)
        (not
          (unit_priority_check_passed ?mission_unit)
        )
      )
    :effect (unit_priority_check_passed ?mission_unit)
  )
  (:action confirm_priority_certification_for_unit
    :parameters (?mission_unit - mission_unit ?certification_token - certification_token)
    :precondition
      (and
        (unit_priority_check_passed ?mission_unit)
        (unit_certification_assigned ?mission_unit ?certification_token)
        (not
          (unit_priority_confirmed ?mission_unit)
        )
      )
    :effect (unit_priority_confirmed ?mission_unit)
  )
  (:action finalize_unit_priority_and_record_salvage
    :parameters (?mission_unit - mission_unit)
    :precondition
      (and
        (unit_priority_confirmed ?mission_unit)
        (not
          (unit_finalized ?mission_unit)
        )
      )
    :effect
      (and
        (unit_finalized ?mission_unit)
        (mission_salvage_recorded ?mission_unit)
      )
  )
  (:action finalize_primary_unit_salvage
    :parameters (?primary_unit - primary_unit ?reentry_craft - reentry_craft)
    :precondition
      (and
        (primary_unit_prepared ?primary_unit)
        (primary_unit_confirmed ?primary_unit)
        (craft_staged ?reentry_craft)
        (craft_integration_ready ?reentry_craft)
        (not
          (mission_salvage_recorded ?primary_unit)
        )
      )
    :effect (mission_salvage_recorded ?primary_unit)
  )
  (:action finalize_secondary_unit_salvage
    :parameters (?secondary_unit - secondary_unit ?reentry_craft - reentry_craft)
    :precondition
      (and
        (secondary_unit_prepared ?secondary_unit)
        (secondary_unit_confirmed ?secondary_unit)
        (craft_staged ?reentry_craft)
        (craft_integration_ready ?reentry_craft)
        (not
          (mission_salvage_recorded ?secondary_unit)
        )
      )
    :effect (mission_salvage_recorded ?secondary_unit)
  )
  (:action finalize_item_recovery_assignment
    :parameters (?mission_item - mission_task ?recovery_point - recovery_point ?trajectory_option - trajectory_option)
    :precondition
      (and
        (mission_salvage_recorded ?mission_item)
        (trajectory_assigned_to_mission_entity ?mission_item ?trajectory_option)
        (recovery_point_available ?recovery_point)
        (not
          (mission_salvage_completed ?mission_item)
        )
      )
    :effect
      (and
        (mission_salvage_completed ?mission_item)
        (recovery_point_assigned_to_mission_entity ?mission_item ?recovery_point)
        (not
          (recovery_point_available ?recovery_point)
        )
      )
  )
  (:action finalize_unit_reentry_binding_primary
    :parameters (?primary_unit - primary_unit ?extraction_asset - extraction_asset ?recovery_point - recovery_point)
    :precondition
      (and
        (mission_salvage_completed ?primary_unit)
        (asset_assigned_to_mission_entity ?primary_unit ?extraction_asset)
        (recovery_point_assigned_to_mission_entity ?primary_unit ?recovery_point)
        (not
          (reentry_ready ?primary_unit)
        )
      )
    :effect
      (and
        (reentry_ready ?primary_unit)
        (asset_available ?extraction_asset)
        (recovery_point_available ?recovery_point)
      )
  )
  (:action finalize_unit_reentry_binding_secondary
    :parameters (?secondary_unit - secondary_unit ?extraction_asset - extraction_asset ?recovery_point - recovery_point)
    :precondition
      (and
        (mission_salvage_completed ?secondary_unit)
        (asset_assigned_to_mission_entity ?secondary_unit ?extraction_asset)
        (recovery_point_assigned_to_mission_entity ?secondary_unit ?recovery_point)
        (not
          (reentry_ready ?secondary_unit)
        )
      )
    :effect
      (and
        (reentry_ready ?secondary_unit)
        (asset_available ?extraction_asset)
        (recovery_point_available ?recovery_point)
      )
  )
  (:action finalize_unit_reentry_binding
    :parameters (?mission_unit - mission_unit ?extraction_asset - extraction_asset ?recovery_point - recovery_point)
    :precondition
      (and
        (mission_salvage_completed ?mission_unit)
        (asset_assigned_to_mission_entity ?mission_unit ?extraction_asset)
        (recovery_point_assigned_to_mission_entity ?mission_unit ?recovery_point)
        (not
          (reentry_ready ?mission_unit)
        )
      )
    :effect
      (and
        (reentry_ready ?mission_unit)
        (asset_available ?extraction_asset)
        (recovery_point_available ?recovery_point)
      )
  )
)

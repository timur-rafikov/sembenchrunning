(define (domain matrix_build_priority_scheduling_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types matrix_job - object runner - object stage - object dependency_image - object platform_target - object hardware_accelerator - object artifact_storage_slot - object scanner_worker - object test_profile - object analysis_tool - object secure_dataset - object security_policy - object approver - object human_approver - approver automated_policy_engine - approver controller_job - matrix_job trigger_job - matrix_job)
  (:predicates
    (job_registered ?matrix_job - matrix_job)
    (job_assigned_runner ?matrix_job - matrix_job ?runner - runner)
    (job_runner_allocated ?matrix_job - matrix_job)
    (job_artifact_prepared ?matrix_job - matrix_job)
    (job_analysis_passed ?matrix_job - matrix_job)
    (job_platform_reserved ?matrix_job - matrix_job ?platform_target - platform_target)
    (job_dependency_reserved ?matrix_job - matrix_job ?dependency_image - dependency_image)
    (job_accelerator_reserved ?matrix_job - matrix_job ?hardware_accelerator - hardware_accelerator)
    (job_policy_reserved ?matrix_job - matrix_job ?security_policy - security_policy)
    (job_stage_started ?matrix_job - matrix_job ?stage - stage)
    (job_any_stage_started ?matrix_job - matrix_job)
    (job_poststage_consolidation_required ?matrix_job - matrix_job)
    (job_artifact_verified ?matrix_job - matrix_job)
    (job_promoted ?matrix_job - matrix_job)
    (job_analysis_requested ?matrix_job - matrix_job)
    (job_finalization_authorized ?matrix_job - matrix_job)
    (trigger_test_profile_compatible ?matrix_job - matrix_job ?test_profile - test_profile)
    (job_test_profile_reserved_by_trigger ?matrix_job - matrix_job ?test_profile - test_profile)
    (job_controller_ready_for_promotion ?matrix_job - matrix_job)
    (runner_available ?runner - runner)
    (stage_available ?stage - stage)
    (platform_available ?platform_target - platform_target)
    (image_available ?dependency_image - dependency_image)
    (accelerator_available ?hardware_accelerator - hardware_accelerator)
    (storage_slot_available ?artifact_storage_slot - artifact_storage_slot)
    (scanner_available ?scanner_worker - scanner_worker)
    (test_profile_available ?test_profile - test_profile)
    (analysis_tool_available ?analysis_tool - analysis_tool)
    (secure_dataset_available ?secure_dataset - secure_dataset)
    (policy_available ?security_policy - security_policy)
    (job_runner_compatible ?matrix_job - matrix_job ?runner - runner)
    (job_stage_compatible ?matrix_job - matrix_job ?stage - stage)
    (job_platform_compatible ?matrix_job - matrix_job ?platform_target - platform_target)
    (job_dependency_compatible ?matrix_job - matrix_job ?dependency_image - dependency_image)
    (job_accelerator_compatible ?matrix_job - matrix_job ?hardware_accelerator - hardware_accelerator)
    (job_dataset_compatible ?matrix_job - matrix_job ?secure_dataset - secure_dataset)
    (job_policy_compatible ?matrix_job - matrix_job ?security_policy - security_policy)
    (job_approver_member ?matrix_job - matrix_job ?approval_group - approver)
    (controller_test_profile_reserved ?matrix_job - matrix_job ?test_profile - test_profile)
    (is_controller_instance ?matrix_job - matrix_job)
    (is_trigger_instance ?matrix_job - matrix_job)
    (job_artifact_slot_reserved ?matrix_job - matrix_job ?artifact_storage_slot - artifact_storage_slot)
    (job_secure_dataset_required ?matrix_job - matrix_job)
    (job_test_profile_compatible ?matrix_job - matrix_job ?test_profile - test_profile)
  )
  (:action register_matrix_job
    :parameters (?matrix_job - matrix_job)
    :precondition
      (and
        (not
          (job_registered ?matrix_job)
        )
        (not
          (job_promoted ?matrix_job)
        )
      )
    :effect
      (and
        (job_registered ?matrix_job)
      )
  )
  (:action allocate_runner_to_job
    :parameters (?matrix_job - matrix_job ?runner - runner)
    :precondition
      (and
        (job_registered ?matrix_job)
        (runner_available ?runner)
        (job_runner_compatible ?matrix_job ?runner)
        (not
          (job_runner_allocated ?matrix_job)
        )
      )
    :effect
      (and
        (job_assigned_runner ?matrix_job ?runner)
        (job_runner_allocated ?matrix_job)
        (not
          (runner_available ?runner)
        )
      )
  )
  (:action release_runner_from_job
    :parameters (?matrix_job - matrix_job ?runner - runner)
    :precondition
      (and
        (job_assigned_runner ?matrix_job ?runner)
        (not
          (job_any_stage_started ?matrix_job)
        )
        (not
          (job_poststage_consolidation_required ?matrix_job)
        )
      )
    :effect
      (and
        (not
          (job_assigned_runner ?matrix_job ?runner)
        )
        (not
          (job_runner_allocated ?matrix_job)
        )
        (not
          (job_artifact_prepared ?matrix_job)
        )
        (not
          (job_analysis_passed ?matrix_job)
        )
        (not
          (job_analysis_requested ?matrix_job)
        )
        (not
          (job_finalization_authorized ?matrix_job)
        )
        (not
          (job_secure_dataset_required ?matrix_job)
        )
        (runner_available ?runner)
      )
  )
  (:action reserve_artifact_slot_for_job
    :parameters (?matrix_job - matrix_job ?artifact_storage_slot - artifact_storage_slot)
    :precondition
      (and
        (job_registered ?matrix_job)
        (storage_slot_available ?artifact_storage_slot)
      )
    :effect
      (and
        (job_artifact_slot_reserved ?matrix_job ?artifact_storage_slot)
        (not
          (storage_slot_available ?artifact_storage_slot)
        )
      )
  )
  (:action release_artifact_slot_from_job
    :parameters (?matrix_job - matrix_job ?artifact_storage_slot - artifact_storage_slot)
    :precondition
      (and
        (job_artifact_slot_reserved ?matrix_job ?artifact_storage_slot)
      )
    :effect
      (and
        (storage_slot_available ?artifact_storage_slot)
        (not
          (job_artifact_slot_reserved ?matrix_job ?artifact_storage_slot)
        )
      )
  )
  (:action prepare_artifacts_for_job
    :parameters (?matrix_job - matrix_job ?artifact_storage_slot - artifact_storage_slot)
    :precondition
      (and
        (job_registered ?matrix_job)
        (job_runner_allocated ?matrix_job)
        (job_artifact_slot_reserved ?matrix_job ?artifact_storage_slot)
        (not
          (job_artifact_prepared ?matrix_job)
        )
      )
    :effect
      (and
        (job_artifact_prepared ?matrix_job)
      )
  )
  (:action invoke_scanner_for_job
    :parameters (?matrix_job - matrix_job ?scanner_worker - scanner_worker)
    :precondition
      (and
        (job_registered ?matrix_job)
        (job_runner_allocated ?matrix_job)
        (scanner_available ?scanner_worker)
        (not
          (job_artifact_prepared ?matrix_job)
        )
      )
    :effect
      (and
        (job_artifact_prepared ?matrix_job)
        (job_analysis_requested ?matrix_job)
        (not
          (scanner_available ?scanner_worker)
        )
      )
  )
  (:action run_analysis_tool_for_job
    :parameters (?matrix_job - matrix_job ?artifact_storage_slot - artifact_storage_slot ?analysis_tool - analysis_tool)
    :precondition
      (and
        (job_artifact_prepared ?matrix_job)
        (job_runner_allocated ?matrix_job)
        (job_artifact_slot_reserved ?matrix_job ?artifact_storage_slot)
        (analysis_tool_available ?analysis_tool)
        (not
          (job_analysis_passed ?matrix_job)
        )
      )
    :effect
      (and
        (job_analysis_passed ?matrix_job)
        (not
          (job_analysis_requested ?matrix_job)
        )
      )
  )
  (:action execute_test_profile_for_job
    :parameters (?matrix_job - matrix_job ?test_profile - test_profile)
    :precondition
      (and
        (job_runner_allocated ?matrix_job)
        (job_test_profile_reserved_by_trigger ?matrix_job ?test_profile)
        (not
          (job_analysis_passed ?matrix_job)
        )
      )
    :effect
      (and
        (job_analysis_passed ?matrix_job)
        (not
          (job_analysis_requested ?matrix_job)
        )
      )
  )
  (:action reserve_platform_for_job
    :parameters (?matrix_job - matrix_job ?platform_target - platform_target)
    :precondition
      (and
        (job_registered ?matrix_job)
        (platform_available ?platform_target)
        (job_platform_compatible ?matrix_job ?platform_target)
      )
    :effect
      (and
        (job_platform_reserved ?matrix_job ?platform_target)
        (not
          (platform_available ?platform_target)
        )
      )
  )
  (:action release_platform_from_job
    :parameters (?matrix_job - matrix_job ?platform_target - platform_target)
    :precondition
      (and
        (job_platform_reserved ?matrix_job ?platform_target)
      )
    :effect
      (and
        (platform_available ?platform_target)
        (not
          (job_platform_reserved ?matrix_job ?platform_target)
        )
      )
  )
  (:action reserve_dependency_image_for_job
    :parameters (?matrix_job - matrix_job ?dependency_image - dependency_image)
    :precondition
      (and
        (job_registered ?matrix_job)
        (image_available ?dependency_image)
        (job_dependency_compatible ?matrix_job ?dependency_image)
      )
    :effect
      (and
        (job_dependency_reserved ?matrix_job ?dependency_image)
        (not
          (image_available ?dependency_image)
        )
      )
  )
  (:action release_dependency_image_from_job
    :parameters (?matrix_job - matrix_job ?dependency_image - dependency_image)
    :precondition
      (and
        (job_dependency_reserved ?matrix_job ?dependency_image)
      )
    :effect
      (and
        (image_available ?dependency_image)
        (not
          (job_dependency_reserved ?matrix_job ?dependency_image)
        )
      )
  )
  (:action reserve_accelerator_for_job
    :parameters (?matrix_job - matrix_job ?hardware_accelerator - hardware_accelerator)
    :precondition
      (and
        (job_registered ?matrix_job)
        (accelerator_available ?hardware_accelerator)
        (job_accelerator_compatible ?matrix_job ?hardware_accelerator)
      )
    :effect
      (and
        (job_accelerator_reserved ?matrix_job ?hardware_accelerator)
        (not
          (accelerator_available ?hardware_accelerator)
        )
      )
  )
  (:action release_accelerator_from_job
    :parameters (?matrix_job - matrix_job ?hardware_accelerator - hardware_accelerator)
    :precondition
      (and
        (job_accelerator_reserved ?matrix_job ?hardware_accelerator)
      )
    :effect
      (and
        (accelerator_available ?hardware_accelerator)
        (not
          (job_accelerator_reserved ?matrix_job ?hardware_accelerator)
        )
      )
  )
  (:action reserve_security_policy_for_job
    :parameters (?matrix_job - matrix_job ?security_policy - security_policy)
    :precondition
      (and
        (job_registered ?matrix_job)
        (policy_available ?security_policy)
        (job_policy_compatible ?matrix_job ?security_policy)
      )
    :effect
      (and
        (job_policy_reserved ?matrix_job ?security_policy)
        (not
          (policy_available ?security_policy)
        )
      )
  )
  (:action release_security_policy_from_job
    :parameters (?matrix_job - matrix_job ?security_policy - security_policy)
    :precondition
      (and
        (job_policy_reserved ?matrix_job ?security_policy)
      )
    :effect
      (and
        (policy_available ?security_policy)
        (not
          (job_policy_reserved ?matrix_job ?security_policy)
        )
      )
  )
  (:action start_stage_execution
    :parameters (?matrix_job - matrix_job ?stage - stage ?platform_target - platform_target ?dependency_image - dependency_image)
    :precondition
      (and
        (job_runner_allocated ?matrix_job)
        (job_platform_reserved ?matrix_job ?platform_target)
        (job_dependency_reserved ?matrix_job ?dependency_image)
        (stage_available ?stage)
        (job_stage_compatible ?matrix_job ?stage)
        (not
          (job_any_stage_started ?matrix_job)
        )
      )
    :effect
      (and
        (job_stage_started ?matrix_job ?stage)
        (job_any_stage_started ?matrix_job)
        (not
          (stage_available ?stage)
        )
      )
  )
  (:action start_stage_with_accelerator_and_dataset
    :parameters (?matrix_job - matrix_job ?stage - stage ?hardware_accelerator - hardware_accelerator ?secure_dataset - secure_dataset)
    :precondition
      (and
        (job_runner_allocated ?matrix_job)
        (job_accelerator_reserved ?matrix_job ?hardware_accelerator)
        (secure_dataset_available ?secure_dataset)
        (stage_available ?stage)
        (job_stage_compatible ?matrix_job ?stage)
        (job_dataset_compatible ?matrix_job ?secure_dataset)
        (not
          (job_any_stage_started ?matrix_job)
        )
      )
    :effect
      (and
        (job_stage_started ?matrix_job ?stage)
        (job_any_stage_started ?matrix_job)
        (job_secure_dataset_required ?matrix_job)
        (job_analysis_requested ?matrix_job)
        (not
          (stage_available ?stage)
        )
        (not
          (secure_dataset_available ?secure_dataset)
        )
      )
  )
  (:action consolidate_stage_outputs
    :parameters (?matrix_job - matrix_job ?platform_target - platform_target ?dependency_image - dependency_image)
    :precondition
      (and
        (job_any_stage_started ?matrix_job)
        (job_secure_dataset_required ?matrix_job)
        (job_platform_reserved ?matrix_job ?platform_target)
        (job_dependency_reserved ?matrix_job ?dependency_image)
      )
    :effect
      (and
        (not
          (job_secure_dataset_required ?matrix_job)
        )
        (not
          (job_analysis_requested ?matrix_job)
        )
      )
  )
  (:action request_manual_approval
    :parameters (?matrix_job - matrix_job ?platform_target - platform_target ?dependency_image - dependency_image ?human_approver - human_approver)
    :precondition
      (and
        (job_analysis_passed ?matrix_job)
        (job_any_stage_started ?matrix_job)
        (job_platform_reserved ?matrix_job ?platform_target)
        (job_dependency_reserved ?matrix_job ?dependency_image)
        (job_approver_member ?matrix_job ?human_approver)
        (not
          (job_analysis_requested ?matrix_job)
        )
        (not
          (job_poststage_consolidation_required ?matrix_job)
        )
      )
    :effect
      (and
        (job_poststage_consolidation_required ?matrix_job)
      )
  )
  (:action request_automated_policy_check
    :parameters (?matrix_job - matrix_job ?hardware_accelerator - hardware_accelerator ?security_policy - security_policy ?automated_policy_engine - automated_policy_engine)
    :precondition
      (and
        (job_analysis_passed ?matrix_job)
        (job_any_stage_started ?matrix_job)
        (job_accelerator_reserved ?matrix_job ?hardware_accelerator)
        (job_policy_reserved ?matrix_job ?security_policy)
        (job_approver_member ?matrix_job ?automated_policy_engine)
        (not
          (job_poststage_consolidation_required ?matrix_job)
        )
      )
    :effect
      (and
        (job_poststage_consolidation_required ?matrix_job)
        (job_analysis_requested ?matrix_job)
      )
  )
  (:action authorize_finalization
    :parameters (?matrix_job - matrix_job ?platform_target - platform_target ?dependency_image - dependency_image)
    :precondition
      (and
        (job_poststage_consolidation_required ?matrix_job)
        (job_analysis_requested ?matrix_job)
        (job_platform_reserved ?matrix_job ?platform_target)
        (job_dependency_reserved ?matrix_job ?dependency_image)
      )
    :effect
      (and
        (job_finalization_authorized ?matrix_job)
        (not
          (job_analysis_requested ?matrix_job)
        )
        (not
          (job_analysis_passed ?matrix_job)
        )
        (not
          (job_secure_dataset_required ?matrix_job)
        )
      )
  )
  (:action finalize_artifacts_with_tool
    :parameters (?matrix_job - matrix_job ?artifact_storage_slot - artifact_storage_slot ?analysis_tool - analysis_tool)
    :precondition
      (and
        (job_finalization_authorized ?matrix_job)
        (job_poststage_consolidation_required ?matrix_job)
        (job_runner_allocated ?matrix_job)
        (job_artifact_slot_reserved ?matrix_job ?artifact_storage_slot)
        (analysis_tool_available ?analysis_tool)
        (not
          (job_analysis_passed ?matrix_job)
        )
      )
    :effect
      (and
        (job_analysis_passed ?matrix_job)
      )
  )
  (:action verify_artifact_with_slot
    :parameters (?matrix_job - matrix_job ?artifact_storage_slot - artifact_storage_slot)
    :precondition
      (and
        (job_poststage_consolidation_required ?matrix_job)
        (job_analysis_passed ?matrix_job)
        (not
          (job_analysis_requested ?matrix_job)
        )
        (job_artifact_slot_reserved ?matrix_job ?artifact_storage_slot)
        (not
          (job_artifact_verified ?matrix_job)
        )
      )
    :effect
      (and
        (job_artifact_verified ?matrix_job)
      )
  )
  (:action verify_artifact_with_scanner
    :parameters (?matrix_job - matrix_job ?scanner_worker - scanner_worker)
    :precondition
      (and
        (job_poststage_consolidation_required ?matrix_job)
        (job_analysis_passed ?matrix_job)
        (not
          (job_analysis_requested ?matrix_job)
        )
        (scanner_available ?scanner_worker)
        (not
          (job_artifact_verified ?matrix_job)
        )
      )
    :effect
      (and
        (job_artifact_verified ?matrix_job)
        (not
          (scanner_available ?scanner_worker)
        )
      )
  )
  (:action reserve_test_profile_on_controller
    :parameters (?matrix_job - matrix_job ?test_profile - test_profile)
    :precondition
      (and
        (job_artifact_verified ?matrix_job)
        (test_profile_available ?test_profile)
        (job_test_profile_compatible ?matrix_job ?test_profile)
      )
    :effect
      (and
        (controller_test_profile_reserved ?matrix_job ?test_profile)
        (not
          (test_profile_available ?test_profile)
        )
      )
  )
  (:action bind_test_profile_to_trigger
    :parameters (?trigger_instance - trigger_job ?controller_instance - controller_job ?test_profile - test_profile)
    :precondition
      (and
        (job_registered ?trigger_instance)
        (is_trigger_instance ?trigger_instance)
        (trigger_test_profile_compatible ?trigger_instance ?test_profile)
        (controller_test_profile_reserved ?controller_instance ?test_profile)
        (not
          (job_test_profile_reserved_by_trigger ?trigger_instance ?test_profile)
        )
      )
    :effect
      (and
        (job_test_profile_reserved_by_trigger ?trigger_instance ?test_profile)
      )
  )
  (:action controller_mark_ready_for_promotion
    :parameters (?matrix_job - matrix_job ?artifact_storage_slot - artifact_storage_slot ?analysis_tool - analysis_tool)
    :precondition
      (and
        (job_registered ?matrix_job)
        (is_trigger_instance ?matrix_job)
        (job_analysis_passed ?matrix_job)
        (job_artifact_verified ?matrix_job)
        (job_artifact_slot_reserved ?matrix_job ?artifact_storage_slot)
        (analysis_tool_available ?analysis_tool)
        (not
          (job_controller_ready_for_promotion ?matrix_job)
        )
      )
    :effect
      (and
        (job_controller_ready_for_promotion ?matrix_job)
      )
  )
  (:action promote_controller_job
    :parameters (?matrix_job - matrix_job)
    :precondition
      (and
        (is_controller_instance ?matrix_job)
        (job_registered ?matrix_job)
        (job_runner_allocated ?matrix_job)
        (job_any_stage_started ?matrix_job)
        (job_poststage_consolidation_required ?matrix_job)
        (job_artifact_verified ?matrix_job)
        (job_analysis_passed ?matrix_job)
        (not
          (job_promoted ?matrix_job)
        )
      )
    :effect
      (and
        (job_promoted ?matrix_job)
      )
  )
  (:action promote_controller_job_with_profile
    :parameters (?matrix_job - matrix_job ?test_profile - test_profile)
    :precondition
      (and
        (is_trigger_instance ?matrix_job)
        (job_registered ?matrix_job)
        (job_runner_allocated ?matrix_job)
        (job_any_stage_started ?matrix_job)
        (job_poststage_consolidation_required ?matrix_job)
        (job_artifact_verified ?matrix_job)
        (job_analysis_passed ?matrix_job)
        (job_test_profile_reserved_by_trigger ?matrix_job ?test_profile)
        (not
          (job_promoted ?matrix_job)
        )
      )
    :effect
      (and
        (job_promoted ?matrix_job)
      )
  )
  (:action promote_trigger_job
    :parameters (?matrix_job - matrix_job)
    :precondition
      (and
        (is_trigger_instance ?matrix_job)
        (job_registered ?matrix_job)
        (job_runner_allocated ?matrix_job)
        (job_any_stage_started ?matrix_job)
        (job_poststage_consolidation_required ?matrix_job)
        (job_artifact_verified ?matrix_job)
        (job_analysis_passed ?matrix_job)
        (job_controller_ready_for_promotion ?matrix_job)
        (not
          (job_promoted ?matrix_job)
        )
      )
    :effect
      (and
        (job_promoted ?matrix_job)
      )
  )
)

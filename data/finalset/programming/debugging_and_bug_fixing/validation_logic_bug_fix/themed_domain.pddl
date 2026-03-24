(define (domain validation_logic_bug_fix_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object resource - entity artifact - entity environment_type - entity issue_container - entity work_item - issue_container engineer - resource test_case - resource patch_candidate - resource compliance_rule - resource deployment_target - resource validation_token - resource reviewer_credential - resource security_credential - resource evidence_artifact - artifact patch_file - artifact stakeholder - artifact runtime_environment - environment_type target_platform - environment_type build_package - environment_type component_type - work_item component_group - work_item frontend_component - component_type backend_component - component_type code_module - component_group)

  (:predicates
    (reported ?issue - work_item)
    (reproducible ?issue - work_item)
    (assigned ?issue - work_item)
    (ready_for_release ?issue - work_item)
    (finalized ?issue - work_item)
    (validation_passed ?issue - work_item)
    (engineer_available ?engineer - engineer)
    (assigned_to ?issue - work_item ?engineer - engineer)
    (test_case_available ?test_case - test_case)
    (linked_test ?issue - work_item ?test_case - test_case)
    (patch_candidate_available ?patch_candidate - patch_candidate)
    (linked_patch_candidate ?issue - work_item ?patch_candidate - patch_candidate)
    (evidence_artifact_available ?evidence_artifact - evidence_artifact)
    (frontend_component_has_evidence ?frontend_component - frontend_component ?evidence_artifact - evidence_artifact)
    (backend_component_has_evidence ?backend_component - backend_component ?evidence_artifact - evidence_artifact)
    (frontend_component_in_runtime ?frontend_component - frontend_component ?runtime_environment - runtime_environment)
    (runtime_environment_allocated ?runtime_environment - runtime_environment)
    (runtime_environment_has_evidence ?runtime_environment - runtime_environment)
    (frontend_component_ready_for_packaging ?frontend_component - frontend_component)
    (backend_component_on_platform ?backend_component - backend_component ?target_platform - target_platform)
    (target_platform_allocated ?target_platform - target_platform)
    (target_platform_has_evidence ?target_platform - target_platform)
    (backend_component_ready_for_packaging ?backend_component - backend_component)
    (build_package_available ?build_package - build_package)
    (build_package_ready ?build_package - build_package)
    (build_package_for_environment ?build_package - build_package ?runtime_environment - runtime_environment)
    (build_package_for_platform ?build_package - build_package ?target_platform - target_platform)
    (package_tag_environment ?build_package - build_package)
    (package_tag_platform ?build_package - build_package)
    (build_package_tested ?build_package - build_package)
    (module_has_frontend_component ?code_module - code_module ?frontend_component - frontend_component)
    (module_has_backend_component ?code_module - code_module ?backend_component - backend_component)
    (module_in_build_package ?code_module - code_module ?build_package - build_package)
    (patch_file_available ?patch_file - patch_file)
    (module_has_patch_file ?code_module - code_module ?patch_file - patch_file)
    (patch_file_prepared ?patch_file - patch_file)
    (patch_file_in_build_package ?patch_file - patch_file ?build_package - build_package)
    (module_review_eligible ?code_module - code_module)
    (module_review_requested ?code_module - code_module)
    (module_review_started ?code_module - code_module)
    (module_policy_attached ?code_module - code_module)
    (module_policy_enforced ?code_module - code_module)
    (module_review_credentials_in_use ?code_module - code_module)
    (module_approvals_collected ?code_module - code_module)
    (stakeholder_available ?stakeholder_identity - stakeholder)
    (module_linked_stakeholder ?code_module - code_module ?stakeholder_identity - stakeholder)
    (module_stakeholder_approved ?code_module - code_module)
    (module_policy_gate_passed ?code_module - code_module)
    (module_security_review_completed ?code_module - code_module)
    (compliance_rule_available ?compliance_rule - compliance_rule)
    (module_compliance_link ?code_module - code_module ?compliance_rule - compliance_rule)
    (deployment_target_available ?deployment_target - deployment_target)
    (module_deployment_target_link ?code_module - code_module ?deployment_target - deployment_target)
    (reviewer_credential_available ?reviewer_credential - reviewer_credential)
    (module_reviewer_credential_link ?code_module - code_module ?reviewer_credential - reviewer_credential)
    (security_credential_available ?security_credential - security_credential)
    (module_security_credential_link ?code_module - code_module ?security_credential - security_credential)
    (validation_token_available ?validation_token - validation_token)
    (validation_token_assigned ?issue - work_item ?validation_token - validation_token)
    (frontend_component_allocated_for_test ?frontend_component - frontend_component)
    (backend_component_allocated_for_test ?backend_component - backend_component)
    (module_finalized_flag ?code_module - code_module)
  )
  (:action report_issue
    :parameters (?issue - work_item)
    :precondition
      (and
        (not
          (reported ?issue)
        )
        (not
          (ready_for_release ?issue)
        )
      )
    :effect (reported ?issue)
  )
  (:action assign_engineer_to_issue
    :parameters (?issue - work_item ?engineer - engineer)
    :precondition
      (and
        (reported ?issue)
        (not
          (assigned ?issue)
        )
        (engineer_available ?engineer)
      )
    :effect
      (and
        (assigned ?issue)
        (assigned_to ?issue ?engineer)
        (not
          (engineer_available ?engineer)
        )
      )
  )
  (:action attach_testcase_to_issue
    :parameters (?issue - work_item ?test_case - test_case)
    :precondition
      (and
        (reported ?issue)
        (assigned ?issue)
        (test_case_available ?test_case)
      )
    :effect
      (and
        (linked_test ?issue ?test_case)
        (not
          (test_case_available ?test_case)
        )
      )
  )
  (:action confirm_issue_reproducible
    :parameters (?issue - work_item ?test_case - test_case)
    :precondition
      (and
        (reported ?issue)
        (assigned ?issue)
        (linked_test ?issue ?test_case)
        (not
          (reproducible ?issue)
        )
      )
    :effect (reproducible ?issue)
  )
  (:action detach_testcase_from_issue
    :parameters (?issue - work_item ?test_case - test_case)
    :precondition
      (and
        (linked_test ?issue ?test_case)
      )
    :effect
      (and
        (test_case_available ?test_case)
        (not
          (linked_test ?issue ?test_case)
        )
      )
  )
  (:action attach_patch_candidate_to_issue
    :parameters (?issue - work_item ?patch_candidate - patch_candidate)
    :precondition
      (and
        (reproducible ?issue)
        (patch_candidate_available ?patch_candidate)
      )
    :effect
      (and
        (linked_patch_candidate ?issue ?patch_candidate)
        (not
          (patch_candidate_available ?patch_candidate)
        )
      )
  )
  (:action detach_patch_candidate_from_issue
    :parameters (?issue - work_item ?patch_candidate - patch_candidate)
    :precondition
      (and
        (linked_patch_candidate ?issue ?patch_candidate)
      )
    :effect
      (and
        (patch_candidate_available ?patch_candidate)
        (not
          (linked_patch_candidate ?issue ?patch_candidate)
        )
      )
  )
  (:action assign_reviewer_credential_to_module
    :parameters (?code_module - code_module ?reviewer_credential - reviewer_credential)
    :precondition
      (and
        (reproducible ?code_module)
        (reviewer_credential_available ?reviewer_credential)
      )
    :effect
      (and
        (module_reviewer_credential_link ?code_module ?reviewer_credential)
        (not
          (reviewer_credential_available ?reviewer_credential)
        )
      )
  )
  (:action release_reviewer_credential_from_module
    :parameters (?code_module - code_module ?reviewer_credential - reviewer_credential)
    :precondition
      (and
        (module_reviewer_credential_link ?code_module ?reviewer_credential)
      )
    :effect
      (and
        (reviewer_credential_available ?reviewer_credential)
        (not
          (module_reviewer_credential_link ?code_module ?reviewer_credential)
        )
      )
  )
  (:action assign_security_credential_to_module
    :parameters (?code_module - code_module ?security_credential - security_credential)
    :precondition
      (and
        (reproducible ?code_module)
        (security_credential_available ?security_credential)
      )
    :effect
      (and
        (module_security_credential_link ?code_module ?security_credential)
        (not
          (security_credential_available ?security_credential)
        )
      )
  )
  (:action release_security_credential_from_module
    :parameters (?code_module - code_module ?security_credential - security_credential)
    :precondition
      (and
        (module_security_credential_link ?code_module ?security_credential)
      )
    :effect
      (and
        (security_credential_available ?security_credential)
        (not
          (module_security_credential_link ?code_module ?security_credential)
        )
      )
  )
  (:action reserve_runtime_environment_for_component
    :parameters (?frontend_component - frontend_component ?runtime_environment - runtime_environment ?test_case - test_case)
    :precondition
      (and
        (reproducible ?frontend_component)
        (linked_test ?frontend_component ?test_case)
        (frontend_component_in_runtime ?frontend_component ?runtime_environment)
        (not
          (runtime_environment_allocated ?runtime_environment)
        )
        (not
          (runtime_environment_has_evidence ?runtime_environment)
        )
      )
    :effect (runtime_environment_allocated ?runtime_environment)
  )
  (:action allocate_component_for_review
    :parameters (?frontend_component - frontend_component ?runtime_environment - runtime_environment ?patch_candidate - patch_candidate)
    :precondition
      (and
        (reproducible ?frontend_component)
        (linked_patch_candidate ?frontend_component ?patch_candidate)
        (frontend_component_in_runtime ?frontend_component ?runtime_environment)
        (runtime_environment_allocated ?runtime_environment)
        (not
          (frontend_component_allocated_for_test ?frontend_component)
        )
      )
    :effect
      (and
        (frontend_component_allocated_for_test ?frontend_component)
        (frontend_component_ready_for_packaging ?frontend_component)
      )
  )
  (:action attach_evidence_and_reserve_component
    :parameters (?frontend_component - frontend_component ?runtime_environment - runtime_environment ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (reproducible ?frontend_component)
        (frontend_component_in_runtime ?frontend_component ?runtime_environment)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (frontend_component_allocated_for_test ?frontend_component)
        )
      )
    :effect
      (and
        (runtime_environment_has_evidence ?runtime_environment)
        (frontend_component_allocated_for_test ?frontend_component)
        (frontend_component_has_evidence ?frontend_component ?evidence_artifact)
        (not
          (evidence_artifact_available ?evidence_artifact)
        )
      )
  )
  (:action execute_test_on_component_environment
    :parameters (?frontend_component - frontend_component ?runtime_environment - runtime_environment ?test_case - test_case ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (reproducible ?frontend_component)
        (linked_test ?frontend_component ?test_case)
        (frontend_component_in_runtime ?frontend_component ?runtime_environment)
        (runtime_environment_has_evidence ?runtime_environment)
        (frontend_component_has_evidence ?frontend_component ?evidence_artifact)
        (not
          (frontend_component_ready_for_packaging ?frontend_component)
        )
      )
    :effect
      (and
        (runtime_environment_allocated ?runtime_environment)
        (frontend_component_ready_for_packaging ?frontend_component)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (frontend_component_has_evidence ?frontend_component ?evidence_artifact)
        )
      )
  )
  (:action reserve_target_platform_for_backend_component
    :parameters (?backend_component - backend_component ?target_platform - target_platform ?test_case - test_case)
    :precondition
      (and
        (reproducible ?backend_component)
        (linked_test ?backend_component ?test_case)
        (backend_component_on_platform ?backend_component ?target_platform)
        (not
          (target_platform_allocated ?target_platform)
        )
        (not
          (target_platform_has_evidence ?target_platform)
        )
      )
    :effect (target_platform_allocated ?target_platform)
  )
  (:action allocate_backend_component_for_review
    :parameters (?backend_component - backend_component ?target_platform - target_platform ?patch_candidate - patch_candidate)
    :precondition
      (and
        (reproducible ?backend_component)
        (linked_patch_candidate ?backend_component ?patch_candidate)
        (backend_component_on_platform ?backend_component ?target_platform)
        (target_platform_allocated ?target_platform)
        (not
          (backend_component_allocated_for_test ?backend_component)
        )
      )
    :effect
      (and
        (backend_component_allocated_for_test ?backend_component)
        (backend_component_ready_for_packaging ?backend_component)
      )
  )
  (:action attach_evidence_and_reserve_backend_component
    :parameters (?backend_component - backend_component ?target_platform - target_platform ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (reproducible ?backend_component)
        (backend_component_on_platform ?backend_component ?target_platform)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (backend_component_allocated_for_test ?backend_component)
        )
      )
    :effect
      (and
        (target_platform_has_evidence ?target_platform)
        (backend_component_allocated_for_test ?backend_component)
        (backend_component_has_evidence ?backend_component ?evidence_artifact)
        (not
          (evidence_artifact_available ?evidence_artifact)
        )
      )
  )
  (:action execute_platform_test_on_backend_component
    :parameters (?backend_component - backend_component ?target_platform - target_platform ?test_case - test_case ?evidence_artifact - evidence_artifact)
    :precondition
      (and
        (reproducible ?backend_component)
        (linked_test ?backend_component ?test_case)
        (backend_component_on_platform ?backend_component ?target_platform)
        (target_platform_has_evidence ?target_platform)
        (backend_component_has_evidence ?backend_component ?evidence_artifact)
        (not
          (backend_component_ready_for_packaging ?backend_component)
        )
      )
    :effect
      (and
        (target_platform_allocated ?target_platform)
        (backend_component_ready_for_packaging ?backend_component)
        (evidence_artifact_available ?evidence_artifact)
        (not
          (backend_component_has_evidence ?backend_component ?evidence_artifact)
        )
      )
  )
  (:action assemble_build_package
    :parameters (?frontend_component - frontend_component ?backend_component - backend_component ?runtime_environment - runtime_environment ?target_platform - target_platform ?build_package - build_package)
    :precondition
      (and
        (frontend_component_allocated_for_test ?frontend_component)
        (backend_component_allocated_for_test ?backend_component)
        (frontend_component_in_runtime ?frontend_component ?runtime_environment)
        (backend_component_on_platform ?backend_component ?target_platform)
        (runtime_environment_allocated ?runtime_environment)
        (target_platform_allocated ?target_platform)
        (frontend_component_ready_for_packaging ?frontend_component)
        (backend_component_ready_for_packaging ?backend_component)
        (build_package_available ?build_package)
      )
    :effect
      (and
        (build_package_ready ?build_package)
        (build_package_for_environment ?build_package ?runtime_environment)
        (build_package_for_platform ?build_package ?target_platform)
        (not
          (build_package_available ?build_package)
        )
      )
  )
  (:action assemble_build_package_with_environment_tag
    :parameters (?frontend_component - frontend_component ?backend_component - backend_component ?runtime_environment - runtime_environment ?target_platform - target_platform ?build_package - build_package)
    :precondition
      (and
        (frontend_component_allocated_for_test ?frontend_component)
        (backend_component_allocated_for_test ?backend_component)
        (frontend_component_in_runtime ?frontend_component ?runtime_environment)
        (backend_component_on_platform ?backend_component ?target_platform)
        (runtime_environment_has_evidence ?runtime_environment)
        (target_platform_allocated ?target_platform)
        (not
          (frontend_component_ready_for_packaging ?frontend_component)
        )
        (backend_component_ready_for_packaging ?backend_component)
        (build_package_available ?build_package)
      )
    :effect
      (and
        (build_package_ready ?build_package)
        (build_package_for_environment ?build_package ?runtime_environment)
        (build_package_for_platform ?build_package ?target_platform)
        (package_tag_environment ?build_package)
        (not
          (build_package_available ?build_package)
        )
      )
  )
  (:action assemble_build_package_with_platform_tag
    :parameters (?frontend_component - frontend_component ?backend_component - backend_component ?runtime_environment - runtime_environment ?target_platform - target_platform ?build_package - build_package)
    :precondition
      (and
        (frontend_component_allocated_for_test ?frontend_component)
        (backend_component_allocated_for_test ?backend_component)
        (frontend_component_in_runtime ?frontend_component ?runtime_environment)
        (backend_component_on_platform ?backend_component ?target_platform)
        (runtime_environment_allocated ?runtime_environment)
        (target_platform_has_evidence ?target_platform)
        (frontend_component_ready_for_packaging ?frontend_component)
        (not
          (backend_component_ready_for_packaging ?backend_component)
        )
        (build_package_available ?build_package)
      )
    :effect
      (and
        (build_package_ready ?build_package)
        (build_package_for_environment ?build_package ?runtime_environment)
        (build_package_for_platform ?build_package ?target_platform)
        (package_tag_platform ?build_package)
        (not
          (build_package_available ?build_package)
        )
      )
  )
  (:action assemble_build_package_with_env_and_platform_tags
    :parameters (?frontend_component - frontend_component ?backend_component - backend_component ?runtime_environment - runtime_environment ?target_platform - target_platform ?build_package - build_package)
    :precondition
      (and
        (frontend_component_allocated_for_test ?frontend_component)
        (backend_component_allocated_for_test ?backend_component)
        (frontend_component_in_runtime ?frontend_component ?runtime_environment)
        (backend_component_on_platform ?backend_component ?target_platform)
        (runtime_environment_has_evidence ?runtime_environment)
        (target_platform_has_evidence ?target_platform)
        (not
          (frontend_component_ready_for_packaging ?frontend_component)
        )
        (not
          (backend_component_ready_for_packaging ?backend_component)
        )
        (build_package_available ?build_package)
      )
    :effect
      (and
        (build_package_ready ?build_package)
        (build_package_for_environment ?build_package ?runtime_environment)
        (build_package_for_platform ?build_package ?target_platform)
        (package_tag_environment ?build_package)
        (package_tag_platform ?build_package)
        (not
          (build_package_available ?build_package)
        )
      )
  )
  (:action mark_build_package_tested
    :parameters (?build_package - build_package ?frontend_component - frontend_component ?test_case - test_case)
    :precondition
      (and
        (build_package_ready ?build_package)
        (frontend_component_allocated_for_test ?frontend_component)
        (linked_test ?frontend_component ?test_case)
        (not
          (build_package_tested ?build_package)
        )
      )
    :effect (build_package_tested ?build_package)
  )
  (:action create_patch_file
    :parameters (?code_module - code_module ?patch_file - patch_file ?build_package - build_package)
    :precondition
      (and
        (reproducible ?code_module)
        (module_in_build_package ?code_module ?build_package)
        (module_has_patch_file ?code_module ?patch_file)
        (patch_file_available ?patch_file)
        (build_package_ready ?build_package)
        (build_package_tested ?build_package)
        (not
          (patch_file_prepared ?patch_file)
        )
      )
    :effect
      (and
        (patch_file_prepared ?patch_file)
        (patch_file_in_build_package ?patch_file ?build_package)
        (not
          (patch_file_available ?patch_file)
        )
      )
  )
  (:action bind_patch_file_and_mark_module_for_review
    :parameters (?code_module - code_module ?patch_file - patch_file ?build_package - build_package ?test_case - test_case)
    :precondition
      (and
        (reproducible ?code_module)
        (module_has_patch_file ?code_module ?patch_file)
        (patch_file_prepared ?patch_file)
        (patch_file_in_build_package ?patch_file ?build_package)
        (linked_test ?code_module ?test_case)
        (not
          (package_tag_environment ?build_package)
        )
        (not
          (module_review_eligible ?code_module)
        )
      )
    :effect (module_review_eligible ?code_module)
  )
  (:action attach_compliance_rule_to_module
    :parameters (?code_module - code_module ?compliance_rule - compliance_rule)
    :precondition
      (and
        (reproducible ?code_module)
        (compliance_rule_available ?compliance_rule)
        (not
          (module_policy_attached ?code_module)
        )
      )
    :effect
      (and
        (module_policy_attached ?code_module)
        (module_compliance_link ?code_module ?compliance_rule)
        (not
          (compliance_rule_available ?compliance_rule)
        )
      )
  )
  (:action apply_compliance_and_progress_module
    :parameters (?code_module - code_module ?patch_file - patch_file ?build_package - build_package ?test_case - test_case ?compliance_rule - compliance_rule)
    :precondition
      (and
        (reproducible ?code_module)
        (module_has_patch_file ?code_module ?patch_file)
        (patch_file_prepared ?patch_file)
        (patch_file_in_build_package ?patch_file ?build_package)
        (linked_test ?code_module ?test_case)
        (package_tag_environment ?build_package)
        (module_policy_attached ?code_module)
        (module_compliance_link ?code_module ?compliance_rule)
        (not
          (module_review_eligible ?code_module)
        )
      )
    :effect
      (and
        (module_review_eligible ?code_module)
        (module_policy_enforced ?code_module)
      )
  )
  (:action initiate_review_assignment
    :parameters (?code_module - code_module ?reviewer_credential - reviewer_credential ?patch_candidate - patch_candidate ?patch_file - patch_file ?build_package - build_package)
    :precondition
      (and
        (module_review_eligible ?code_module)
        (module_reviewer_credential_link ?code_module ?reviewer_credential)
        (linked_patch_candidate ?code_module ?patch_candidate)
        (module_has_patch_file ?code_module ?patch_file)
        (patch_file_in_build_package ?patch_file ?build_package)
        (not
          (package_tag_platform ?build_package)
        )
        (not
          (module_review_requested ?code_module)
        )
      )
    :effect (module_review_requested ?code_module)
  )
  (:action continue_review_assignment
    :parameters (?code_module - code_module ?reviewer_credential - reviewer_credential ?patch_candidate - patch_candidate ?patch_file - patch_file ?build_package - build_package)
    :precondition
      (and
        (module_review_eligible ?code_module)
        (module_reviewer_credential_link ?code_module ?reviewer_credential)
        (linked_patch_candidate ?code_module ?patch_candidate)
        (module_has_patch_file ?code_module ?patch_file)
        (patch_file_in_build_package ?patch_file ?build_package)
        (package_tag_platform ?build_package)
        (not
          (module_review_requested ?code_module)
        )
      )
    :effect (module_review_requested ?code_module)
  )
  (:action start_security_review
    :parameters (?code_module - code_module ?security_credential - security_credential ?patch_file - patch_file ?build_package - build_package)
    :precondition
      (and
        (module_review_requested ?code_module)
        (module_security_credential_link ?code_module ?security_credential)
        (module_has_patch_file ?code_module ?patch_file)
        (patch_file_in_build_package ?patch_file ?build_package)
        (not
          (package_tag_environment ?build_package)
        )
        (not
          (package_tag_platform ?build_package)
        )
        (not
          (module_review_started ?code_module)
        )
      )
    :effect (module_review_started ?code_module)
  )
  (:action progress_security_review
    :parameters (?code_module - code_module ?security_credential - security_credential ?patch_file - patch_file ?build_package - build_package)
    :precondition
      (and
        (module_review_requested ?code_module)
        (module_security_credential_link ?code_module ?security_credential)
        (module_has_patch_file ?code_module ?patch_file)
        (patch_file_in_build_package ?patch_file ?build_package)
        (package_tag_environment ?build_package)
        (not
          (package_tag_platform ?build_package)
        )
        (not
          (module_review_started ?code_module)
        )
      )
    :effect
      (and
        (module_review_started ?code_module)
        (module_review_credentials_in_use ?code_module)
      )
  )
  (:action alternate_security_review_flow
    :parameters (?code_module - code_module ?security_credential - security_credential ?patch_file - patch_file ?build_package - build_package)
    :precondition
      (and
        (module_review_requested ?code_module)
        (module_security_credential_link ?code_module ?security_credential)
        (module_has_patch_file ?code_module ?patch_file)
        (patch_file_in_build_package ?patch_file ?build_package)
        (not
          (package_tag_environment ?build_package)
        )
        (package_tag_platform ?build_package)
        (not
          (module_review_started ?code_module)
        )
      )
    :effect
      (and
        (module_review_started ?code_module)
        (module_review_credentials_in_use ?code_module)
      )
  )
  (:action complete_security_review_flow
    :parameters (?code_module - code_module ?security_credential - security_credential ?patch_file - patch_file ?build_package - build_package)
    :precondition
      (and
        (module_review_requested ?code_module)
        (module_security_credential_link ?code_module ?security_credential)
        (module_has_patch_file ?code_module ?patch_file)
        (patch_file_in_build_package ?patch_file ?build_package)
        (package_tag_environment ?build_package)
        (package_tag_platform ?build_package)
        (not
          (module_review_started ?code_module)
        )
      )
    :effect
      (and
        (module_review_started ?code_module)
        (module_review_credentials_in_use ?code_module)
      )
  )
  (:action finalize_module_review
    :parameters (?code_module - code_module)
    :precondition
      (and
        (module_review_started ?code_module)
        (not
          (module_review_credentials_in_use ?code_module)
        )
        (not
          (module_finalized_flag ?code_module)
        )
      )
    :effect
      (and
        (module_finalized_flag ?code_module)
        (finalized ?code_module)
      )
  )
  (:action assign_deployment_target_to_module
    :parameters (?code_module - code_module ?deployment_target - deployment_target)
    :precondition
      (and
        (module_review_started ?code_module)
        (module_review_credentials_in_use ?code_module)
        (deployment_target_available ?deployment_target)
      )
    :effect
      (and
        (module_deployment_target_link ?code_module ?deployment_target)
        (not
          (deployment_target_available ?deployment_target)
        )
      )
  )
  (:action complete_integration_and_mark_module_ready
    :parameters (?code_module - code_module ?frontend_component - frontend_component ?backend_component - backend_component ?test_case - test_case ?deployment_target - deployment_target)
    :precondition
      (and
        (module_review_started ?code_module)
        (module_review_credentials_in_use ?code_module)
        (module_deployment_target_link ?code_module ?deployment_target)
        (module_has_frontend_component ?code_module ?frontend_component)
        (module_has_backend_component ?code_module ?backend_component)
        (frontend_component_ready_for_packaging ?frontend_component)
        (backend_component_ready_for_packaging ?backend_component)
        (linked_test ?code_module ?test_case)
        (not
          (module_approvals_collected ?code_module)
        )
      )
    :effect (module_approvals_collected ?code_module)
  )
  (:action finalize_module_and_set_ready
    :parameters (?code_module - code_module)
    :precondition
      (and
        (module_review_started ?code_module)
        (module_approvals_collected ?code_module)
        (not
          (module_finalized_flag ?code_module)
        )
      )
    :effect
      (and
        (module_finalized_flag ?code_module)
        (finalized ?code_module)
      )
  )
  (:action request_stakeholder_approval
    :parameters (?code_module - code_module ?stakeholder_identity - stakeholder ?test_case - test_case)
    :precondition
      (and
        (reproducible ?code_module)
        (linked_test ?code_module ?test_case)
        (stakeholder_available ?stakeholder_identity)
        (module_linked_stakeholder ?code_module ?stakeholder_identity)
        (not
          (module_stakeholder_approved ?code_module)
        )
      )
    :effect
      (and
        (module_stakeholder_approved ?code_module)
        (not
          (stakeholder_available ?stakeholder_identity)
        )
      )
  )
  (:action apply_stakeholder_approval_to_module
    :parameters (?code_module - code_module ?patch_candidate - patch_candidate)
    :precondition
      (and
        (module_stakeholder_approved ?code_module)
        (linked_patch_candidate ?code_module ?patch_candidate)
        (not
          (module_policy_gate_passed ?code_module)
        )
      )
    :effect (module_policy_gate_passed ?code_module)
  )
  (:action consume_security_credential_for_module
    :parameters (?code_module - code_module ?security_credential - security_credential)
    :precondition
      (and
        (module_policy_gate_passed ?code_module)
        (module_security_credential_link ?code_module ?security_credential)
        (not
          (module_security_review_completed ?code_module)
        )
      )
    :effect (module_security_review_completed ?code_module)
  )
  (:action finalize_stakeholder_approval
    :parameters (?code_module - code_module)
    :precondition
      (and
        (module_security_review_completed ?code_module)
        (not
          (module_finalized_flag ?code_module)
        )
      )
    :effect
      (and
        (module_finalized_flag ?code_module)
        (finalized ?code_module)
      )
  )
  (:action complete_frontend_component_finalization
    :parameters (?frontend_component - frontend_component ?build_package - build_package)
    :precondition
      (and
        (frontend_component_allocated_for_test ?frontend_component)
        (frontend_component_ready_for_packaging ?frontend_component)
        (build_package_ready ?build_package)
        (build_package_tested ?build_package)
        (not
          (finalized ?frontend_component)
        )
      )
    :effect (finalized ?frontend_component)
  )
  (:action complete_backend_component_finalization
    :parameters (?backend_component - backend_component ?build_package - build_package)
    :precondition
      (and
        (backend_component_allocated_for_test ?backend_component)
        (backend_component_ready_for_packaging ?backend_component)
        (build_package_ready ?build_package)
        (build_package_tested ?build_package)
        (not
          (finalized ?backend_component)
        )
      )
    :effect (finalized ?backend_component)
  )
  (:action consume_validation_token_and_mark_issue_resolved
    :parameters (?issue - work_item ?validation_token - validation_token ?test_case - test_case)
    :precondition
      (and
        (finalized ?issue)
        (linked_test ?issue ?test_case)
        (validation_token_available ?validation_token)
        (not
          (validation_passed ?issue)
        )
      )
    :effect
      (and
        (validation_passed ?issue)
        (validation_token_assigned ?issue ?validation_token)
        (not
          (validation_token_available ?validation_token)
        )
      )
  )
  (:action finalize_component_and_release_engineer
    :parameters (?frontend_component - frontend_component ?engineer - engineer ?validation_token - validation_token)
    :precondition
      (and
        (validation_passed ?frontend_component)
        (assigned_to ?frontend_component ?engineer)
        (validation_token_assigned ?frontend_component ?validation_token)
        (not
          (ready_for_release ?frontend_component)
        )
      )
    :effect
      (and
        (ready_for_release ?frontend_component)
        (engineer_available ?engineer)
        (validation_token_available ?validation_token)
      )
  )
  (:action finalize_backend_component_and_release_engineer
    :parameters (?backend_component - backend_component ?engineer - engineer ?validation_token - validation_token)
    :precondition
      (and
        (validation_passed ?backend_component)
        (assigned_to ?backend_component ?engineer)
        (validation_token_assigned ?backend_component ?validation_token)
        (not
          (ready_for_release ?backend_component)
        )
      )
    :effect
      (and
        (ready_for_release ?backend_component)
        (engineer_available ?engineer)
        (validation_token_available ?validation_token)
      )
  )
  (:action finalize_module_and_release_engineer
    :parameters (?code_module - code_module ?engineer - engineer ?validation_token - validation_token)
    :precondition
      (and
        (validation_passed ?code_module)
        (assigned_to ?code_module ?engineer)
        (validation_token_assigned ?code_module ?validation_token)
        (not
          (ready_for_release ?code_module)
        )
      )
    :effect
      (and
        (ready_for_release ?code_module)
        (engineer_available ?engineer)
        (validation_token_available ?validation_token)
      )
  )
)

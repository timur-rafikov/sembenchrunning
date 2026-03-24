(define (domain serialization_deserialization_bug_fix_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity - object actor_or_tool - entity artifact_category - entity format_or_payload_category - entity case_container - entity bug_report - case_container engineer_resource - actor_or_tool reproducer_test - actor_or_tool code_module - actor_or_tool design_document - actor_or_tool review_checklist - actor_or_tool deployment_environment - actor_or_tool build_artifact_metadata - actor_or_tool integration_metadata - actor_or_tool diagnostic_artifact - artifact_category test_fixture - artifact_category architectural_tag - artifact_category serialization_format - format_or_payload_category deserialization_format - format_or_payload_category test_vector - format_or_payload_category affected_component_role - bug_report owner_role - bug_report serializer_component - affected_component_role deserializer_component - affected_component_role maintainer - owner_role)

  (:predicates
    (bug_report_opened ?bug_report - bug_report)
    (has_valid_reproducer ?bug_report - bug_report)
    (bug_report_triaged ?bug_report - bug_report)
    (patch_deployed ?bug_report - bug_report)
    (ready_for_remediation ?bug_report - bug_report)
    (fix_ready ?bug_report - bug_report)
    (engineer_available ?engineer - engineer_resource)
    (assigned_to_engineer ?bug_report - bug_report ?engineer - engineer_resource)
    (reproducer_available ?reproducer_test - reproducer_test)
    (reproducer_assigned_to ?bug_report - bug_report ?reproducer_test - reproducer_test)
    (code_module_unassigned ?code_module - code_module)
    (linked_to_module ?bug_report - bug_report ?code_module - code_module)
    (diagnostic_artifact_available ?diagnostic_artifact - diagnostic_artifact)
    (artifact_assigned_to_serializer ?serializer - serializer_component ?diagnostic_artifact - diagnostic_artifact)
    (artifact_assigned_to_deserializer ?deserializer - deserializer_component ?diagnostic_artifact - diagnostic_artifact)
    (serializer_uses_format ?serializer - serializer_component ?serialization_format - serialization_format)
    (serialization_format_instrumented ?serialization_format - serialization_format)
    (serialization_format_has_diagnostic_artifact ?serialization_format - serialization_format)
    (serializer_diagnosed ?serializer - serializer_component)
    (deserializer_uses_format ?deserializer - deserializer_component ?deserialization_format - deserialization_format)
    (deserialization_format_instrumented ?deserialization_format - deserialization_format)
    (deserialization_format_has_diagnostic_artifact ?deserialization_format - deserialization_format)
    (deserializer_diagnosed ?deserializer - deserializer_component)
    (test_vector_staged ?test_vector - test_vector)
    (test_vector_assembled ?test_vector - test_vector)
    (test_vector_linked_to_serialization_format ?test_vector - test_vector ?serialization_format - serialization_format)
    (test_vector_linked_to_deserialization_format ?test_vector - test_vector ?deserialization_format - deserialization_format)
    (test_vector_includes_serializer_artifact ?test_vector - test_vector)
    (test_vector_includes_deserializer_artifact ?test_vector - test_vector)
    (test_vector_validated ?test_vector - test_vector)
    (maintainer_responsible_for_serializer ?maintainer - maintainer ?serializer - serializer_component)
    (maintainer_responsible_for_deserializer ?maintainer - maintainer ?deserializer - deserializer_component)
    (maintainer_has_test_vector ?maintainer - maintainer ?test_vector - test_vector)
    (test_fixture_available ?test_fixture - test_fixture)
    (maintainer_has_test_fixture ?maintainer - maintainer ?test_fixture - test_fixture)
    (test_fixture_consumed ?test_fixture - test_fixture)
    (test_fixture_bound_to_test_vector ?test_fixture - test_fixture ?test_vector - test_vector)
    (maintainer_ready_for_review ?maintainer - maintainer)
    (maintainer_builds_prepared ?maintainer - maintainer)
    (maintainer_integration_prepared ?maintainer - maintainer)
    (maintainer_has_design_document ?maintainer - maintainer)
    (maintainer_document_acknowledged ?maintainer - maintainer)
    (maintainer_checklist_verified ?maintainer - maintainer)
    (maintainer_integration_approved ?maintainer - maintainer)
    (architectural_tag_available ?architectural_tag - architectural_tag)
    (maintainer_pending_architectural_tag ?maintainer - maintainer ?architectural_tag - architectural_tag)
    (maintainer_arch_tag_acknowledged ?maintainer - maintainer)
    (maintainer_prepared_for_integration ?maintainer - maintainer)
    (maintainer_integration_tests_ready ?maintainer - maintainer)
    (design_document_available ?design_document - design_document)
    (maintainer_linked_to_design_document ?maintainer - maintainer ?design_document - design_document)
    (review_checklist_available ?review_checklist - review_checklist)
    (maintainer_has_review_checklist ?maintainer - maintainer ?review_checklist - review_checklist)
    (build_metadata_available ?build_artifact_metadata - build_artifact_metadata)
    (maintainer_has_build_metadata ?maintainer - maintainer ?build_artifact_metadata - build_artifact_metadata)
    (integration_metadata_available ?integration_metadata - integration_metadata)
    (maintainer_has_integration_metadata ?maintainer - maintainer ?integration_metadata - integration_metadata)
    (deployment_environment_available ?deployment_environment - deployment_environment)
    (target_environment ?bug_report - bug_report ?deployment_environment - deployment_environment)
    (serializer_ready ?serializer - serializer_component)
    (deserializer_ready ?deserializer - deserializer_component)
    (maintainer_action_initiated ?maintainer - maintainer)
  )
  (:action create_bug_report
    :parameters (?bug_report - bug_report)
    :precondition
      (and
        (not
          (bug_report_opened ?bug_report)
        )
        (not
          (patch_deployed ?bug_report)
        )
      )
    :effect (bug_report_opened ?bug_report)
  )
  (:action assign_engineer_to_bug
    :parameters (?bug_report - bug_report ?engineer - engineer_resource)
    :precondition
      (and
        (bug_report_opened ?bug_report)
        (not
          (bug_report_triaged ?bug_report)
        )
        (engineer_available ?engineer)
      )
    :effect
      (and
        (bug_report_triaged ?bug_report)
        (assigned_to_engineer ?bug_report ?engineer)
        (not
          (engineer_available ?engineer)
        )
      )
  )
  (:action attach_reproducer_to_bug
    :parameters (?bug_report - bug_report ?reproducer_test - reproducer_test)
    :precondition
      (and
        (bug_report_opened ?bug_report)
        (bug_report_triaged ?bug_report)
        (reproducer_available ?reproducer_test)
      )
    :effect
      (and
        (reproducer_assigned_to ?bug_report ?reproducer_test)
        (not
          (reproducer_available ?reproducer_test)
        )
      )
  )
  (:action validate_reproducer
    :parameters (?bug_report - bug_report ?reproducer_test - reproducer_test)
    :precondition
      (and
        (bug_report_opened ?bug_report)
        (bug_report_triaged ?bug_report)
        (reproducer_assigned_to ?bug_report ?reproducer_test)
        (not
          (has_valid_reproducer ?bug_report)
        )
      )
    :effect (has_valid_reproducer ?bug_report)
  )
  (:action unassign_reproducer_from_bug
    :parameters (?bug_report - bug_report ?reproducer_test - reproducer_test)
    :precondition
      (and
        (reproducer_assigned_to ?bug_report ?reproducer_test)
      )
    :effect
      (and
        (reproducer_available ?reproducer_test)
        (not
          (reproducer_assigned_to ?bug_report ?reproducer_test)
        )
      )
  )
  (:action link_module_to_bug
    :parameters (?bug_report - bug_report ?code_module - code_module)
    :precondition
      (and
        (has_valid_reproducer ?bug_report)
        (code_module_unassigned ?code_module)
      )
    :effect
      (and
        (linked_to_module ?bug_report ?code_module)
        (not
          (code_module_unassigned ?code_module)
        )
      )
  )
  (:action unlink_module_from_bug
    :parameters (?bug_report - bug_report ?code_module - code_module)
    :precondition
      (and
        (linked_to_module ?bug_report ?code_module)
      )
    :effect
      (and
        (code_module_unassigned ?code_module)
        (not
          (linked_to_module ?bug_report ?code_module)
        )
      )
  )
  (:action attach_build_metadata_to_maintainer
    :parameters (?maintainer - maintainer ?build_artifact_metadata - build_artifact_metadata)
    :precondition
      (and
        (has_valid_reproducer ?maintainer)
        (build_metadata_available ?build_artifact_metadata)
      )
    :effect
      (and
        (maintainer_has_build_metadata ?maintainer ?build_artifact_metadata)
        (not
          (build_metadata_available ?build_artifact_metadata)
        )
      )
  )
  (:action detach_build_metadata_from_maintainer
    :parameters (?maintainer - maintainer ?build_artifact_metadata - build_artifact_metadata)
    :precondition
      (and
        (maintainer_has_build_metadata ?maintainer ?build_artifact_metadata)
      )
    :effect
      (and
        (build_metadata_available ?build_artifact_metadata)
        (not
          (maintainer_has_build_metadata ?maintainer ?build_artifact_metadata)
        )
      )
  )
  (:action attach_integration_metadata_to_maintainer
    :parameters (?maintainer - maintainer ?integration_metadata - integration_metadata)
    :precondition
      (and
        (has_valid_reproducer ?maintainer)
        (integration_metadata_available ?integration_metadata)
      )
    :effect
      (and
        (maintainer_has_integration_metadata ?maintainer ?integration_metadata)
        (not
          (integration_metadata_available ?integration_metadata)
        )
      )
  )
  (:action detach_integration_metadata_from_maintainer
    :parameters (?maintainer - maintainer ?integration_metadata - integration_metadata)
    :precondition
      (and
        (maintainer_has_integration_metadata ?maintainer ?integration_metadata)
      )
    :effect
      (and
        (integration_metadata_available ?integration_metadata)
        (not
          (maintainer_has_integration_metadata ?maintainer ?integration_metadata)
        )
      )
  )
  (:action instrument_serialization_format
    :parameters (?serializer - serializer_component ?serialization_format - serialization_format ?reproducer_test - reproducer_test)
    :precondition
      (and
        (has_valid_reproducer ?serializer)
        (reproducer_assigned_to ?serializer ?reproducer_test)
        (serializer_uses_format ?serializer ?serialization_format)
        (not
          (serialization_format_instrumented ?serialization_format)
        )
        (not
          (serialization_format_has_diagnostic_artifact ?serialization_format)
        )
      )
    :effect (serialization_format_instrumented ?serialization_format)
  )
  (:action run_serializer_diagnostics
    :parameters (?serializer - serializer_component ?serialization_format - serialization_format ?code_module - code_module)
    :precondition
      (and
        (has_valid_reproducer ?serializer)
        (linked_to_module ?serializer ?code_module)
        (serializer_uses_format ?serializer ?serialization_format)
        (serialization_format_instrumented ?serialization_format)
        (not
          (serializer_ready ?serializer)
        )
      )
    :effect
      (and
        (serializer_ready ?serializer)
        (serializer_diagnosed ?serializer)
      )
  )
  (:action attach_artifact_to_serializer
    :parameters (?serializer - serializer_component ?serialization_format - serialization_format ?diagnostic_artifact - diagnostic_artifact)
    :precondition
      (and
        (has_valid_reproducer ?serializer)
        (serializer_uses_format ?serializer ?serialization_format)
        (diagnostic_artifact_available ?diagnostic_artifact)
        (not
          (serializer_ready ?serializer)
        )
      )
    :effect
      (and
        (serialization_format_has_diagnostic_artifact ?serialization_format)
        (serializer_ready ?serializer)
        (artifact_assigned_to_serializer ?serializer ?diagnostic_artifact)
        (not
          (diagnostic_artifact_available ?diagnostic_artifact)
        )
      )
  )
  (:action analyze_serializer_artifact
    :parameters (?serializer - serializer_component ?serialization_format - serialization_format ?reproducer_test - reproducer_test ?diagnostic_artifact - diagnostic_artifact)
    :precondition
      (and
        (has_valid_reproducer ?serializer)
        (reproducer_assigned_to ?serializer ?reproducer_test)
        (serializer_uses_format ?serializer ?serialization_format)
        (serialization_format_has_diagnostic_artifact ?serialization_format)
        (artifact_assigned_to_serializer ?serializer ?diagnostic_artifact)
        (not
          (serializer_diagnosed ?serializer)
        )
      )
    :effect
      (and
        (serialization_format_instrumented ?serialization_format)
        (serializer_diagnosed ?serializer)
        (diagnostic_artifact_available ?diagnostic_artifact)
        (not
          (artifact_assigned_to_serializer ?serializer ?diagnostic_artifact)
        )
      )
  )
  (:action instrument_deserialization_format
    :parameters (?deserializer - deserializer_component ?deserialization_format - deserialization_format ?reproducer_test - reproducer_test)
    :precondition
      (and
        (has_valid_reproducer ?deserializer)
        (reproducer_assigned_to ?deserializer ?reproducer_test)
        (deserializer_uses_format ?deserializer ?deserialization_format)
        (not
          (deserialization_format_instrumented ?deserialization_format)
        )
        (not
          (deserialization_format_has_diagnostic_artifact ?deserialization_format)
        )
      )
    :effect (deserialization_format_instrumented ?deserialization_format)
  )
  (:action run_deserializer_diagnostics
    :parameters (?deserializer - deserializer_component ?deserialization_format - deserialization_format ?code_module - code_module)
    :precondition
      (and
        (has_valid_reproducer ?deserializer)
        (linked_to_module ?deserializer ?code_module)
        (deserializer_uses_format ?deserializer ?deserialization_format)
        (deserialization_format_instrumented ?deserialization_format)
        (not
          (deserializer_ready ?deserializer)
        )
      )
    :effect
      (and
        (deserializer_ready ?deserializer)
        (deserializer_diagnosed ?deserializer)
      )
  )
  (:action attach_artifact_to_deserializer
    :parameters (?deserializer - deserializer_component ?deserialization_format - deserialization_format ?diagnostic_artifact - diagnostic_artifact)
    :precondition
      (and
        (has_valid_reproducer ?deserializer)
        (deserializer_uses_format ?deserializer ?deserialization_format)
        (diagnostic_artifact_available ?diagnostic_artifact)
        (not
          (deserializer_ready ?deserializer)
        )
      )
    :effect
      (and
        (deserialization_format_has_diagnostic_artifact ?deserialization_format)
        (deserializer_ready ?deserializer)
        (artifact_assigned_to_deserializer ?deserializer ?diagnostic_artifact)
        (not
          (diagnostic_artifact_available ?diagnostic_artifact)
        )
      )
  )
  (:action analyze_deserializer_artifact
    :parameters (?deserializer - deserializer_component ?deserialization_format - deserialization_format ?reproducer_test - reproducer_test ?diagnostic_artifact - diagnostic_artifact)
    :precondition
      (and
        (has_valid_reproducer ?deserializer)
        (reproducer_assigned_to ?deserializer ?reproducer_test)
        (deserializer_uses_format ?deserializer ?deserialization_format)
        (deserialization_format_has_diagnostic_artifact ?deserialization_format)
        (artifact_assigned_to_deserializer ?deserializer ?diagnostic_artifact)
        (not
          (deserializer_diagnosed ?deserializer)
        )
      )
    :effect
      (and
        (deserialization_format_instrumented ?deserialization_format)
        (deserializer_diagnosed ?deserializer)
        (diagnostic_artifact_available ?diagnostic_artifact)
        (not
          (artifact_assigned_to_deserializer ?deserializer ?diagnostic_artifact)
        )
      )
  )
  (:action assemble_test_vector
    :parameters (?serializer - serializer_component ?deserializer - deserializer_component ?serialization_format - serialization_format ?deserialization_format - deserialization_format ?test_vector - test_vector)
    :precondition
      (and
        (serializer_ready ?serializer)
        (deserializer_ready ?deserializer)
        (serializer_uses_format ?serializer ?serialization_format)
        (deserializer_uses_format ?deserializer ?deserialization_format)
        (serialization_format_instrumented ?serialization_format)
        (deserialization_format_instrumented ?deserialization_format)
        (serializer_diagnosed ?serializer)
        (deserializer_diagnosed ?deserializer)
        (test_vector_staged ?test_vector)
      )
    :effect
      (and
        (test_vector_assembled ?test_vector)
        (test_vector_linked_to_serialization_format ?test_vector ?serialization_format)
        (test_vector_linked_to_deserialization_format ?test_vector ?deserialization_format)
        (not
          (test_vector_staged ?test_vector)
        )
      )
  )
  (:action assemble_test_vector_with_serializer_artifact
    :parameters (?serializer - serializer_component ?deserializer - deserializer_component ?serialization_format - serialization_format ?deserialization_format - deserialization_format ?test_vector - test_vector)
    :precondition
      (and
        (serializer_ready ?serializer)
        (deserializer_ready ?deserializer)
        (serializer_uses_format ?serializer ?serialization_format)
        (deserializer_uses_format ?deserializer ?deserialization_format)
        (serialization_format_has_diagnostic_artifact ?serialization_format)
        (deserialization_format_instrumented ?deserialization_format)
        (not
          (serializer_diagnosed ?serializer)
        )
        (deserializer_diagnosed ?deserializer)
        (test_vector_staged ?test_vector)
      )
    :effect
      (and
        (test_vector_assembled ?test_vector)
        (test_vector_linked_to_serialization_format ?test_vector ?serialization_format)
        (test_vector_linked_to_deserialization_format ?test_vector ?deserialization_format)
        (test_vector_includes_serializer_artifact ?test_vector)
        (not
          (test_vector_staged ?test_vector)
        )
      )
  )
  (:action assemble_test_vector_with_deserializer_artifact
    :parameters (?serializer - serializer_component ?deserializer - deserializer_component ?serialization_format - serialization_format ?deserialization_format - deserialization_format ?test_vector - test_vector)
    :precondition
      (and
        (serializer_ready ?serializer)
        (deserializer_ready ?deserializer)
        (serializer_uses_format ?serializer ?serialization_format)
        (deserializer_uses_format ?deserializer ?deserialization_format)
        (serialization_format_instrumented ?serialization_format)
        (deserialization_format_has_diagnostic_artifact ?deserialization_format)
        (serializer_diagnosed ?serializer)
        (not
          (deserializer_diagnosed ?deserializer)
        )
        (test_vector_staged ?test_vector)
      )
    :effect
      (and
        (test_vector_assembled ?test_vector)
        (test_vector_linked_to_serialization_format ?test_vector ?serialization_format)
        (test_vector_linked_to_deserialization_format ?test_vector ?deserialization_format)
        (test_vector_includes_deserializer_artifact ?test_vector)
        (not
          (test_vector_staged ?test_vector)
        )
      )
  )
  (:action assemble_test_vector_with_both_artifacts
    :parameters (?serializer - serializer_component ?deserializer - deserializer_component ?serialization_format - serialization_format ?deserialization_format - deserialization_format ?test_vector - test_vector)
    :precondition
      (and
        (serializer_ready ?serializer)
        (deserializer_ready ?deserializer)
        (serializer_uses_format ?serializer ?serialization_format)
        (deserializer_uses_format ?deserializer ?deserialization_format)
        (serialization_format_has_diagnostic_artifact ?serialization_format)
        (deserialization_format_has_diagnostic_artifact ?deserialization_format)
        (not
          (serializer_diagnosed ?serializer)
        )
        (not
          (deserializer_diagnosed ?deserializer)
        )
        (test_vector_staged ?test_vector)
      )
    :effect
      (and
        (test_vector_assembled ?test_vector)
        (test_vector_linked_to_serialization_format ?test_vector ?serialization_format)
        (test_vector_linked_to_deserialization_format ?test_vector ?deserialization_format)
        (test_vector_includes_serializer_artifact ?test_vector)
        (test_vector_includes_deserializer_artifact ?test_vector)
        (not
          (test_vector_staged ?test_vector)
        )
      )
  )
  (:action validate_test_vector
    :parameters (?test_vector - test_vector ?serializer - serializer_component ?reproducer_test - reproducer_test)
    :precondition
      (and
        (test_vector_assembled ?test_vector)
        (serializer_ready ?serializer)
        (reproducer_assigned_to ?serializer ?reproducer_test)
        (not
          (test_vector_validated ?test_vector)
        )
      )
    :effect (test_vector_validated ?test_vector)
  )
  (:action attach_fixture_to_test_vector
    :parameters (?maintainer - maintainer ?test_fixture - test_fixture ?test_vector - test_vector)
    :precondition
      (and
        (has_valid_reproducer ?maintainer)
        (maintainer_has_test_vector ?maintainer ?test_vector)
        (maintainer_has_test_fixture ?maintainer ?test_fixture)
        (test_fixture_available ?test_fixture)
        (test_vector_assembled ?test_vector)
        (test_vector_validated ?test_vector)
        (not
          (test_fixture_consumed ?test_fixture)
        )
      )
    :effect
      (and
        (test_fixture_consumed ?test_fixture)
        (test_fixture_bound_to_test_vector ?test_fixture ?test_vector)
        (not
          (test_fixture_available ?test_fixture)
        )
      )
  )
  (:action prepare_maintainer_for_review
    :parameters (?maintainer - maintainer ?test_fixture - test_fixture ?test_vector - test_vector ?reproducer_test - reproducer_test)
    :precondition
      (and
        (has_valid_reproducer ?maintainer)
        (maintainer_has_test_fixture ?maintainer ?test_fixture)
        (test_fixture_consumed ?test_fixture)
        (test_fixture_bound_to_test_vector ?test_fixture ?test_vector)
        (reproducer_assigned_to ?maintainer ?reproducer_test)
        (not
          (test_vector_includes_serializer_artifact ?test_vector)
        )
        (not
          (maintainer_ready_for_review ?maintainer)
        )
      )
    :effect (maintainer_ready_for_review ?maintainer)
  )
  (:action link_design_document_to_maintainer
    :parameters (?maintainer - maintainer ?design_document - design_document)
    :precondition
      (and
        (has_valid_reproducer ?maintainer)
        (design_document_available ?design_document)
        (not
          (maintainer_has_design_document ?maintainer)
        )
      )
    :effect
      (and
        (maintainer_has_design_document ?maintainer)
        (maintainer_linked_to_design_document ?maintainer ?design_document)
        (not
          (design_document_available ?design_document)
        )
      )
  )
  (:action provide_maintainer_context
    :parameters (?maintainer - maintainer ?test_fixture - test_fixture ?test_vector - test_vector ?reproducer_test - reproducer_test ?design_document - design_document)
    :precondition
      (and
        (has_valid_reproducer ?maintainer)
        (maintainer_has_test_fixture ?maintainer ?test_fixture)
        (test_fixture_consumed ?test_fixture)
        (test_fixture_bound_to_test_vector ?test_fixture ?test_vector)
        (reproducer_assigned_to ?maintainer ?reproducer_test)
        (test_vector_includes_serializer_artifact ?test_vector)
        (maintainer_has_design_document ?maintainer)
        (maintainer_linked_to_design_document ?maintainer ?design_document)
        (not
          (maintainer_ready_for_review ?maintainer)
        )
      )
    :effect
      (and
        (maintainer_ready_for_review ?maintainer)
        (maintainer_document_acknowledged ?maintainer)
      )
  )
  (:action trigger_maintainer_build
    :parameters (?maintainer - maintainer ?build_artifact_metadata - build_artifact_metadata ?code_module - code_module ?test_fixture - test_fixture ?test_vector - test_vector)
    :precondition
      (and
        (maintainer_ready_for_review ?maintainer)
        (maintainer_has_build_metadata ?maintainer ?build_artifact_metadata)
        (linked_to_module ?maintainer ?code_module)
        (maintainer_has_test_fixture ?maintainer ?test_fixture)
        (test_fixture_bound_to_test_vector ?test_fixture ?test_vector)
        (not
          (test_vector_includes_deserializer_artifact ?test_vector)
        )
        (not
          (maintainer_builds_prepared ?maintainer)
        )
      )
    :effect (maintainer_builds_prepared ?maintainer)
  )
  (:action trigger_maintainer_build_with_deserializer_artifact
    :parameters (?maintainer - maintainer ?build_artifact_metadata - build_artifact_metadata ?code_module - code_module ?test_fixture - test_fixture ?test_vector - test_vector)
    :precondition
      (and
        (maintainer_ready_for_review ?maintainer)
        (maintainer_has_build_metadata ?maintainer ?build_artifact_metadata)
        (linked_to_module ?maintainer ?code_module)
        (maintainer_has_test_fixture ?maintainer ?test_fixture)
        (test_fixture_bound_to_test_vector ?test_fixture ?test_vector)
        (test_vector_includes_deserializer_artifact ?test_vector)
        (not
          (maintainer_builds_prepared ?maintainer)
        )
      )
    :effect (maintainer_builds_prepared ?maintainer)
  )
  (:action generate_integration_metadata_stage1
    :parameters (?maintainer - maintainer ?integration_metadata - integration_metadata ?test_fixture - test_fixture ?test_vector - test_vector)
    :precondition
      (and
        (maintainer_builds_prepared ?maintainer)
        (maintainer_has_integration_metadata ?maintainer ?integration_metadata)
        (maintainer_has_test_fixture ?maintainer ?test_fixture)
        (test_fixture_bound_to_test_vector ?test_fixture ?test_vector)
        (not
          (test_vector_includes_serializer_artifact ?test_vector)
        )
        (not
          (test_vector_includes_deserializer_artifact ?test_vector)
        )
        (not
          (maintainer_integration_prepared ?maintainer)
        )
      )
    :effect (maintainer_integration_prepared ?maintainer)
  )
  (:action generate_integration_metadata_stage2
    :parameters (?maintainer - maintainer ?integration_metadata - integration_metadata ?test_fixture - test_fixture ?test_vector - test_vector)
    :precondition
      (and
        (maintainer_builds_prepared ?maintainer)
        (maintainer_has_integration_metadata ?maintainer ?integration_metadata)
        (maintainer_has_test_fixture ?maintainer ?test_fixture)
        (test_fixture_bound_to_test_vector ?test_fixture ?test_vector)
        (test_vector_includes_serializer_artifact ?test_vector)
        (not
          (test_vector_includes_deserializer_artifact ?test_vector)
        )
        (not
          (maintainer_integration_prepared ?maintainer)
        )
      )
    :effect
      (and
        (maintainer_integration_prepared ?maintainer)
        (maintainer_checklist_verified ?maintainer)
      )
  )
  (:action generate_integration_metadata_stage3
    :parameters (?maintainer - maintainer ?integration_metadata - integration_metadata ?test_fixture - test_fixture ?test_vector - test_vector)
    :precondition
      (and
        (maintainer_builds_prepared ?maintainer)
        (maintainer_has_integration_metadata ?maintainer ?integration_metadata)
        (maintainer_has_test_fixture ?maintainer ?test_fixture)
        (test_fixture_bound_to_test_vector ?test_fixture ?test_vector)
        (not
          (test_vector_includes_serializer_artifact ?test_vector)
        )
        (test_vector_includes_deserializer_artifact ?test_vector)
        (not
          (maintainer_integration_prepared ?maintainer)
        )
      )
    :effect
      (and
        (maintainer_integration_prepared ?maintainer)
        (maintainer_checklist_verified ?maintainer)
      )
  )
  (:action generate_integration_metadata_stage4
    :parameters (?maintainer - maintainer ?integration_metadata - integration_metadata ?test_fixture - test_fixture ?test_vector - test_vector)
    :precondition
      (and
        (maintainer_builds_prepared ?maintainer)
        (maintainer_has_integration_metadata ?maintainer ?integration_metadata)
        (maintainer_has_test_fixture ?maintainer ?test_fixture)
        (test_fixture_bound_to_test_vector ?test_fixture ?test_vector)
        (test_vector_includes_serializer_artifact ?test_vector)
        (test_vector_includes_deserializer_artifact ?test_vector)
        (not
          (maintainer_integration_prepared ?maintainer)
        )
      )
    :effect
      (and
        (maintainer_integration_prepared ?maintainer)
        (maintainer_checklist_verified ?maintainer)
      )
  )
  (:action mark_maintainer_ready_for_remediation
    :parameters (?maintainer - maintainer)
    :precondition
      (and
        (maintainer_integration_prepared ?maintainer)
        (not
          (maintainer_checklist_verified ?maintainer)
        )
        (not
          (maintainer_action_initiated ?maintainer)
        )
      )
    :effect
      (and
        (maintainer_action_initiated ?maintainer)
        (ready_for_remediation ?maintainer)
      )
  )
  (:action assign_review_checklist_to_maintainer
    :parameters (?maintainer - maintainer ?review_checklist - review_checklist)
    :precondition
      (and
        (maintainer_integration_prepared ?maintainer)
        (maintainer_checklist_verified ?maintainer)
        (review_checklist_available ?review_checklist)
      )
    :effect
      (and
        (maintainer_has_review_checklist ?maintainer ?review_checklist)
        (not
          (review_checklist_available ?review_checklist)
        )
      )
  )
  (:action approve_maintainer_for_integration
    :parameters (?maintainer - maintainer ?serializer - serializer_component ?deserializer - deserializer_component ?reproducer_test - reproducer_test ?review_checklist - review_checklist)
    :precondition
      (and
        (maintainer_integration_prepared ?maintainer)
        (maintainer_checklist_verified ?maintainer)
        (maintainer_has_review_checklist ?maintainer ?review_checklist)
        (maintainer_responsible_for_serializer ?maintainer ?serializer)
        (maintainer_responsible_for_deserializer ?maintainer ?deserializer)
        (serializer_diagnosed ?serializer)
        (deserializer_diagnosed ?deserializer)
        (reproducer_assigned_to ?maintainer ?reproducer_test)
        (not
          (maintainer_integration_approved ?maintainer)
        )
      )
    :effect (maintainer_integration_approved ?maintainer)
  )
  (:action finalize_maintainer_onboarding
    :parameters (?maintainer - maintainer)
    :precondition
      (and
        (maintainer_integration_prepared ?maintainer)
        (maintainer_integration_approved ?maintainer)
        (not
          (maintainer_action_initiated ?maintainer)
        )
      )
    :effect
      (and
        (maintainer_action_initiated ?maintainer)
        (ready_for_remediation ?maintainer)
      )
  )
  (:action assign_architectural_tag_to_maintainer
    :parameters (?maintainer - maintainer ?architectural_tag - architectural_tag ?reproducer_test - reproducer_test)
    :precondition
      (and
        (has_valid_reproducer ?maintainer)
        (reproducer_assigned_to ?maintainer ?reproducer_test)
        (architectural_tag_available ?architectural_tag)
        (maintainer_pending_architectural_tag ?maintainer ?architectural_tag)
        (not
          (maintainer_arch_tag_acknowledged ?maintainer)
        )
      )
    :effect
      (and
        (maintainer_arch_tag_acknowledged ?maintainer)
        (not
          (architectural_tag_available ?architectural_tag)
        )
      )
  )
  (:action prepare_maintainer_for_module_integration
    :parameters (?maintainer - maintainer ?code_module - code_module)
    :precondition
      (and
        (maintainer_arch_tag_acknowledged ?maintainer)
        (linked_to_module ?maintainer ?code_module)
        (not
          (maintainer_prepared_for_integration ?maintainer)
        )
      )
    :effect (maintainer_prepared_for_integration ?maintainer)
  )
  (:action prepare_maintainer_integration_tests
    :parameters (?maintainer - maintainer ?integration_metadata - integration_metadata)
    :precondition
      (and
        (maintainer_prepared_for_integration ?maintainer)
        (maintainer_has_integration_metadata ?maintainer ?integration_metadata)
        (not
          (maintainer_integration_tests_ready ?maintainer)
        )
      )
    :effect (maintainer_integration_tests_ready ?maintainer)
  )
  (:action finalize_maintainer_integration_readiness
    :parameters (?maintainer - maintainer)
    :precondition
      (and
        (maintainer_integration_tests_ready ?maintainer)
        (not
          (maintainer_action_initiated ?maintainer)
        )
      )
    :effect
      (and
        (maintainer_action_initiated ?maintainer)
        (ready_for_remediation ?maintainer)
      )
  )
  (:action integrate_fix_into_serializer_component
    :parameters (?serializer - serializer_component ?test_vector - test_vector)
    :precondition
      (and
        (serializer_ready ?serializer)
        (serializer_diagnosed ?serializer)
        (test_vector_assembled ?test_vector)
        (test_vector_validated ?test_vector)
        (not
          (ready_for_remediation ?serializer)
        )
      )
    :effect (ready_for_remediation ?serializer)
  )
  (:action integrate_fix_into_deserializer_component
    :parameters (?deserializer - deserializer_component ?test_vector - test_vector)
    :precondition
      (and
        (deserializer_ready ?deserializer)
        (deserializer_diagnosed ?deserializer)
        (test_vector_assembled ?test_vector)
        (test_vector_validated ?test_vector)
        (not
          (ready_for_remediation ?deserializer)
        )
      )
    :effect (ready_for_remediation ?deserializer)
  )
  (:action validate_reproducer_in_environment
    :parameters (?bug_report - bug_report ?deployment_environment - deployment_environment ?reproducer_test - reproducer_test)
    :precondition
      (and
        (ready_for_remediation ?bug_report)
        (reproducer_assigned_to ?bug_report ?reproducer_test)
        (deployment_environment_available ?deployment_environment)
        (not
          (fix_ready ?bug_report)
        )
      )
    :effect
      (and
        (fix_ready ?bug_report)
        (target_environment ?bug_report ?deployment_environment)
        (not
          (deployment_environment_available ?deployment_environment)
        )
      )
  )
  (:action deploy_patch_to_serializer_component
    :parameters (?serializer - serializer_component ?engineer - engineer_resource ?deployment_environment - deployment_environment)
    :precondition
      (and
        (fix_ready ?serializer)
        (assigned_to_engineer ?serializer ?engineer)
        (target_environment ?serializer ?deployment_environment)
        (not
          (patch_deployed ?serializer)
        )
      )
    :effect
      (and
        (patch_deployed ?serializer)
        (engineer_available ?engineer)
        (deployment_environment_available ?deployment_environment)
      )
  )
  (:action deploy_patch_to_deserializer_component
    :parameters (?deserializer - deserializer_component ?engineer - engineer_resource ?deployment_environment - deployment_environment)
    :precondition
      (and
        (fix_ready ?deserializer)
        (assigned_to_engineer ?deserializer ?engineer)
        (target_environment ?deserializer ?deployment_environment)
        (not
          (patch_deployed ?deserializer)
        )
      )
    :effect
      (and
        (patch_deployed ?deserializer)
        (engineer_available ?engineer)
        (deployment_environment_available ?deployment_environment)
      )
  )
  (:action deploy_patch_to_maintainer
    :parameters (?maintainer - maintainer ?engineer - engineer_resource ?deployment_environment - deployment_environment)
    :precondition
      (and
        (fix_ready ?maintainer)
        (assigned_to_engineer ?maintainer ?engineer)
        (target_environment ?maintainer ?deployment_environment)
        (not
          (patch_deployed ?maintainer)
        )
      )
    :effect
      (and
        (patch_deployed ?maintainer)
        (engineer_available ?engineer)
        (deployment_environment_available ?deployment_environment)
      )
  )
)

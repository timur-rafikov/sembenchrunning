(define (domain caching_strategy_design)
  (:requirements :strips :typing :negative-preconditions)
  (:types behavior_entity - object policy_entity - object artifact_entity - object cache_system - object logical_cache - cache_system compute_node - behavior_entity data_source - behavior_entity operator_adapter - behavior_entity placement_hint - behavior_entity performance_profile - behavior_entity workload_descriptor - behavior_entity resource_tag - behavior_entity security_constraint - behavior_entity policy_template - policy_entity content_bundle - policy_entity sla_profile - policy_entity read_path - artifact_entity write_path - artifact_entity cache_artifact - artifact_entity shard_group - logical_cache controller_group - logical_cache primary_shard - shard_group replica_shard - shard_group design_controller - controller_group)
  (:predicates
    (cache_declared ?logical_cache - logical_cache)
    (component_validated ?logical_cache - logical_cache)
    (compute_attached ?logical_cache - logical_cache)
    (runtime_deployed ?logical_cache - logical_cache)
    (operational_ready ?logical_cache - logical_cache)
    (workload_bound ?logical_cache - logical_cache)
    (node_available ?compute_node - compute_node)
    (node_assignment ?logical_cache - logical_cache ?compute_node - compute_node)
    (data_source_available ?data_source - data_source)
    (source_binding ?logical_cache - logical_cache ?data_source - data_source)
    (operator_adapter_available ?operator_adapter - operator_adapter)
    (adapter_assignment ?logical_cache - logical_cache ?operator_adapter - operator_adapter)
    (policy_template_available ?policy_template - policy_template)
    (primary_policy_binding ?primary_shard - primary_shard ?policy_template - policy_template)
    (replica_policy_binding ?replica_shard - replica_shard ?policy_template - policy_template)
    (primary_shard_read_path_binding ?primary_shard - primary_shard ?read_path - read_path)
    (read_path_primed ?read_path - read_path)
    (read_path_pinned ?read_path - read_path)
    (primary_shard_ready ?primary_shard - primary_shard)
    (replica_shard_write_path_binding ?replica_shard - replica_shard ?write_path - write_path)
    (write_path_primed ?write_path - write_path)
    (write_path_pinned ?write_path - write_path)
    (replica_shard_ready ?replica_shard - replica_shard)
    (artifact_source_available ?cache_artifact - cache_artifact)
    (artifact_packaged ?cache_artifact - cache_artifact)
    (artifact_read_path_binding ?cache_artifact - cache_artifact ?read_path - read_path)
    (artifact_write_path_binding ?cache_artifact - cache_artifact ?write_path - write_path)
    (artifact_includes_read_path ?cache_artifact - cache_artifact)
    (artifact_includes_write_path ?cache_artifact - cache_artifact)
    (artifact_validated ?cache_artifact - cache_artifact)
    (controller_manages_primary_shard ?controller - design_controller ?primary_shard - primary_shard)
    (controller_manages_replica_shard ?controller - design_controller ?replica_shard - replica_shard)
    (controller_artifact_binding ?controller - design_controller ?cache_artifact - cache_artifact)
    (content_bundle_available ?content_bundle - content_bundle)
    (controller_content_binding ?controller - design_controller ?content_bundle - content_bundle)
    (content_bundle_pinned ?content_bundle - content_bundle)
    (bundle_artifact_binding ?content_bundle - content_bundle ?cache_artifact - cache_artifact)
    (controller_prepared ?controller - design_controller)
    (controller_validated ?controller - design_controller)
    (controller_configured ?controller - design_controller)
    (placement_hint_attached ?controller - design_controller)
    (placement_processed ?controller - design_controller)
    (controller_policy_applied ?controller - design_controller)
    (controller_operational_check_passed ?controller - design_controller)
    (sla_profile_available ?sla_profile - sla_profile)
    (controller_sla_binding ?controller - design_controller ?sla_profile - sla_profile)
    (controller_sla_applied ?controller - design_controller)
    (sla_adapter_ready ?controller - design_controller)
    (controller_sla_committed ?controller - design_controller)
    (placement_hint_available ?placement_hint - placement_hint)
    (controller_placement_binding ?controller - design_controller ?placement_hint - placement_hint)
    (performance_profile_available ?performance_profile - performance_profile)
    (controller_performance_binding ?controller - design_controller ?performance_profile - performance_profile)
    (resource_tag_available ?resource_tag - resource_tag)
    (controller_resource_tag_binding ?controller - design_controller ?resource_tag - resource_tag)
    (security_constraint_available ?security_constraint - security_constraint)
    (controller_security_binding ?controller - design_controller ?security_constraint - security_constraint)
    (workload_descriptor_available ?workload_descriptor - workload_descriptor)
    (workload_binding ?logical_cache - logical_cache ?workload_descriptor - workload_descriptor)
    (primary_shard_initialized ?primary_shard - primary_shard)
    (replica_shard_initialized ?replica_shard - replica_shard)
    (controller_finalized ?controller - design_controller)
  )
  (:action provision_logical_cache
    :parameters (?logical_cache - logical_cache)
    :precondition
      (and
        (not
          (cache_declared ?logical_cache)
        )
        (not
          (runtime_deployed ?logical_cache)
        )
      )
    :effect (cache_declared ?logical_cache)
  )
  (:action assign_compute_node_to_cache
    :parameters (?logical_cache - logical_cache ?compute_node - compute_node)
    :precondition
      (and
        (cache_declared ?logical_cache)
        (not
          (compute_attached ?logical_cache)
        )
        (node_available ?compute_node)
      )
    :effect
      (and
        (compute_attached ?logical_cache)
        (node_assignment ?logical_cache ?compute_node)
        (not
          (node_available ?compute_node)
        )
      )
  )
  (:action associate_data_source_with_cache
    :parameters (?logical_cache - logical_cache ?data_source - data_source)
    :precondition
      (and
        (cache_declared ?logical_cache)
        (compute_attached ?logical_cache)
        (data_source_available ?data_source)
      )
    :effect
      (and
        (source_binding ?logical_cache ?data_source)
        (not
          (data_source_available ?data_source)
        )
      )
  )
  (:action complete_source_validation
    :parameters (?logical_cache - logical_cache ?data_source - data_source)
    :precondition
      (and
        (cache_declared ?logical_cache)
        (compute_attached ?logical_cache)
        (source_binding ?logical_cache ?data_source)
        (not
          (component_validated ?logical_cache)
        )
      )
    :effect (component_validated ?logical_cache)
  )
  (:action release_data_source_binding
    :parameters (?logical_cache - logical_cache ?data_source - data_source)
    :precondition
      (and
        (source_binding ?logical_cache ?data_source)
      )
    :effect
      (and
        (data_source_available ?data_source)
        (not
          (source_binding ?logical_cache ?data_source)
        )
      )
  )
  (:action attach_operator_adapter
    :parameters (?logical_cache - logical_cache ?operator_adapter - operator_adapter)
    :precondition
      (and
        (component_validated ?logical_cache)
        (operator_adapter_available ?operator_adapter)
      )
    :effect
      (and
        (adapter_assignment ?logical_cache ?operator_adapter)
        (not
          (operator_adapter_available ?operator_adapter)
        )
      )
  )
  (:action detach_operator_adapter
    :parameters (?logical_cache - logical_cache ?operator_adapter - operator_adapter)
    :precondition
      (and
        (adapter_assignment ?logical_cache ?operator_adapter)
      )
    :effect
      (and
        (operator_adapter_available ?operator_adapter)
        (not
          (adapter_assignment ?logical_cache ?operator_adapter)
        )
      )
  )
  (:action bind_resource_tag_to_controller
    :parameters (?controller - design_controller ?resource_tag - resource_tag)
    :precondition
      (and
        (component_validated ?controller)
        (resource_tag_available ?resource_tag)
      )
    :effect
      (and
        (controller_resource_tag_binding ?controller ?resource_tag)
        (not
          (resource_tag_available ?resource_tag)
        )
      )
  )
  (:action unbind_resource_tag_from_controller
    :parameters (?controller - design_controller ?resource_tag - resource_tag)
    :precondition
      (and
        (controller_resource_tag_binding ?controller ?resource_tag)
      )
    :effect
      (and
        (resource_tag_available ?resource_tag)
        (not
          (controller_resource_tag_binding ?controller ?resource_tag)
        )
      )
  )
  (:action bind_security_constraint_to_controller
    :parameters (?controller - design_controller ?security_constraint - security_constraint)
    :precondition
      (and
        (component_validated ?controller)
        (security_constraint_available ?security_constraint)
      )
    :effect
      (and
        (controller_security_binding ?controller ?security_constraint)
        (not
          (security_constraint_available ?security_constraint)
        )
      )
  )
  (:action unbind_security_constraint_from_controller
    :parameters (?controller - design_controller ?security_constraint - security_constraint)
    :precondition
      (and
        (controller_security_binding ?controller ?security_constraint)
      )
    :effect
      (and
        (security_constraint_available ?security_constraint)
        (not
          (controller_security_binding ?controller ?security_constraint)
        )
      )
  )
  (:action prime_read_path_for_primary_shard
    :parameters (?primary_shard - primary_shard ?read_path - read_path ?data_source - data_source)
    :precondition
      (and
        (component_validated ?primary_shard)
        (source_binding ?primary_shard ?data_source)
        (primary_shard_read_path_binding ?primary_shard ?read_path)
        (not
          (read_path_primed ?read_path)
        )
        (not
          (read_path_pinned ?read_path)
        )
      )
    :effect (read_path_primed ?read_path)
  )
  (:action activate_primary_shard
    :parameters (?primary_shard - primary_shard ?read_path - read_path ?operator_adapter - operator_adapter)
    :precondition
      (and
        (component_validated ?primary_shard)
        (adapter_assignment ?primary_shard ?operator_adapter)
        (primary_shard_read_path_binding ?primary_shard ?read_path)
        (read_path_primed ?read_path)
        (not
          (primary_shard_initialized ?primary_shard)
        )
      )
    :effect
      (and
        (primary_shard_initialized ?primary_shard)
        (primary_shard_ready ?primary_shard)
      )
  )
  (:action apply_policy_to_primary_shard
    :parameters (?primary_shard - primary_shard ?read_path - read_path ?policy_template - policy_template)
    :precondition
      (and
        (component_validated ?primary_shard)
        (primary_shard_read_path_binding ?primary_shard ?read_path)
        (policy_template_available ?policy_template)
        (not
          (primary_shard_initialized ?primary_shard)
        )
      )
    :effect
      (and
        (read_path_pinned ?read_path)
        (primary_shard_initialized ?primary_shard)
        (primary_policy_binding ?primary_shard ?policy_template)
        (not
          (policy_template_available ?policy_template)
        )
      )
  )
  (:action finalize_primary_shard_read_path
    :parameters (?primary_shard - primary_shard ?read_path - read_path ?data_source - data_source ?policy_template - policy_template)
    :precondition
      (and
        (component_validated ?primary_shard)
        (source_binding ?primary_shard ?data_source)
        (primary_shard_read_path_binding ?primary_shard ?read_path)
        (read_path_pinned ?read_path)
        (primary_policy_binding ?primary_shard ?policy_template)
        (not
          (primary_shard_ready ?primary_shard)
        )
      )
    :effect
      (and
        (read_path_primed ?read_path)
        (primary_shard_ready ?primary_shard)
        (policy_template_available ?policy_template)
        (not
          (primary_policy_binding ?primary_shard ?policy_template)
        )
      )
  )
  (:action prime_write_path_for_replica_shard
    :parameters (?replica_shard - replica_shard ?write_path - write_path ?data_source - data_source)
    :precondition
      (and
        (component_validated ?replica_shard)
        (source_binding ?replica_shard ?data_source)
        (replica_shard_write_path_binding ?replica_shard ?write_path)
        (not
          (write_path_primed ?write_path)
        )
        (not
          (write_path_pinned ?write_path)
        )
      )
    :effect (write_path_primed ?write_path)
  )
  (:action activate_replica_shard
    :parameters (?replica_shard - replica_shard ?write_path - write_path ?operator_adapter - operator_adapter)
    :precondition
      (and
        (component_validated ?replica_shard)
        (adapter_assignment ?replica_shard ?operator_adapter)
        (replica_shard_write_path_binding ?replica_shard ?write_path)
        (write_path_primed ?write_path)
        (not
          (replica_shard_initialized ?replica_shard)
        )
      )
    :effect
      (and
        (replica_shard_initialized ?replica_shard)
        (replica_shard_ready ?replica_shard)
      )
  )
  (:action apply_policy_to_replica_shard
    :parameters (?replica_shard - replica_shard ?write_path - write_path ?policy_template - policy_template)
    :precondition
      (and
        (component_validated ?replica_shard)
        (replica_shard_write_path_binding ?replica_shard ?write_path)
        (policy_template_available ?policy_template)
        (not
          (replica_shard_initialized ?replica_shard)
        )
      )
    :effect
      (and
        (write_path_pinned ?write_path)
        (replica_shard_initialized ?replica_shard)
        (replica_policy_binding ?replica_shard ?policy_template)
        (not
          (policy_template_available ?policy_template)
        )
      )
  )
  (:action finalize_replica_shard_write_path
    :parameters (?replica_shard - replica_shard ?write_path - write_path ?data_source - data_source ?policy_template - policy_template)
    :precondition
      (and
        (component_validated ?replica_shard)
        (source_binding ?replica_shard ?data_source)
        (replica_shard_write_path_binding ?replica_shard ?write_path)
        (write_path_pinned ?write_path)
        (replica_policy_binding ?replica_shard ?policy_template)
        (not
          (replica_shard_ready ?replica_shard)
        )
      )
    :effect
      (and
        (write_path_primed ?write_path)
        (replica_shard_ready ?replica_shard)
        (policy_template_available ?policy_template)
        (not
          (replica_policy_binding ?replica_shard ?policy_template)
        )
      )
  )
  (:action compose_cache_artifact
    :parameters (?primary_shard - primary_shard ?replica_shard - replica_shard ?read_path - read_path ?write_path - write_path ?cache_artifact - cache_artifact)
    :precondition
      (and
        (primary_shard_initialized ?primary_shard)
        (replica_shard_initialized ?replica_shard)
        (primary_shard_read_path_binding ?primary_shard ?read_path)
        (replica_shard_write_path_binding ?replica_shard ?write_path)
        (read_path_primed ?read_path)
        (write_path_primed ?write_path)
        (primary_shard_ready ?primary_shard)
        (replica_shard_ready ?replica_shard)
        (artifact_source_available ?cache_artifact)
      )
    :effect
      (and
        (artifact_packaged ?cache_artifact)
        (artifact_read_path_binding ?cache_artifact ?read_path)
        (artifact_write_path_binding ?cache_artifact ?write_path)
        (not
          (artifact_source_available ?cache_artifact)
        )
      )
  )
  (:action assemble_artifact_with_read_path
    :parameters (?primary_shard - primary_shard ?replica_shard - replica_shard ?read_path - read_path ?write_path - write_path ?cache_artifact - cache_artifact)
    :precondition
      (and
        (primary_shard_initialized ?primary_shard)
        (replica_shard_initialized ?replica_shard)
        (primary_shard_read_path_binding ?primary_shard ?read_path)
        (replica_shard_write_path_binding ?replica_shard ?write_path)
        (read_path_pinned ?read_path)
        (write_path_primed ?write_path)
        (not
          (primary_shard_ready ?primary_shard)
        )
        (replica_shard_ready ?replica_shard)
        (artifact_source_available ?cache_artifact)
      )
    :effect
      (and
        (artifact_packaged ?cache_artifact)
        (artifact_read_path_binding ?cache_artifact ?read_path)
        (artifact_write_path_binding ?cache_artifact ?write_path)
        (artifact_includes_read_path ?cache_artifact)
        (not
          (artifact_source_available ?cache_artifact)
        )
      )
  )
  (:action assemble_artifact_with_write_path
    :parameters (?primary_shard - primary_shard ?replica_shard - replica_shard ?read_path - read_path ?write_path - write_path ?cache_artifact - cache_artifact)
    :precondition
      (and
        (primary_shard_initialized ?primary_shard)
        (replica_shard_initialized ?replica_shard)
        (primary_shard_read_path_binding ?primary_shard ?read_path)
        (replica_shard_write_path_binding ?replica_shard ?write_path)
        (read_path_primed ?read_path)
        (write_path_pinned ?write_path)
        (primary_shard_ready ?primary_shard)
        (not
          (replica_shard_ready ?replica_shard)
        )
        (artifact_source_available ?cache_artifact)
      )
    :effect
      (and
        (artifact_packaged ?cache_artifact)
        (artifact_read_path_binding ?cache_artifact ?read_path)
        (artifact_write_path_binding ?cache_artifact ?write_path)
        (artifact_includes_write_path ?cache_artifact)
        (not
          (artifact_source_available ?cache_artifact)
        )
      )
  )
  (:action assemble_artifact_with_both_paths
    :parameters (?primary_shard - primary_shard ?replica_shard - replica_shard ?read_path - read_path ?write_path - write_path ?cache_artifact - cache_artifact)
    :precondition
      (and
        (primary_shard_initialized ?primary_shard)
        (replica_shard_initialized ?replica_shard)
        (primary_shard_read_path_binding ?primary_shard ?read_path)
        (replica_shard_write_path_binding ?replica_shard ?write_path)
        (read_path_pinned ?read_path)
        (write_path_pinned ?write_path)
        (not
          (primary_shard_ready ?primary_shard)
        )
        (not
          (replica_shard_ready ?replica_shard)
        )
        (artifact_source_available ?cache_artifact)
      )
    :effect
      (and
        (artifact_packaged ?cache_artifact)
        (artifact_read_path_binding ?cache_artifact ?read_path)
        (artifact_write_path_binding ?cache_artifact ?write_path)
        (artifact_includes_read_path ?cache_artifact)
        (artifact_includes_write_path ?cache_artifact)
        (not
          (artifact_source_available ?cache_artifact)
        )
      )
  )
  (:action validate_artifact_against_shard
    :parameters (?cache_artifact - cache_artifact ?primary_shard - primary_shard ?data_source - data_source)
    :precondition
      (and
        (artifact_packaged ?cache_artifact)
        (primary_shard_initialized ?primary_shard)
        (source_binding ?primary_shard ?data_source)
        (not
          (artifact_validated ?cache_artifact)
        )
      )
    :effect (artifact_validated ?cache_artifact)
  )
  (:action pin_content_bundle
    :parameters (?controller - design_controller ?content_bundle - content_bundle ?cache_artifact - cache_artifact)
    :precondition
      (and
        (component_validated ?controller)
        (controller_artifact_binding ?controller ?cache_artifact)
        (controller_content_binding ?controller ?content_bundle)
        (content_bundle_available ?content_bundle)
        (artifact_packaged ?cache_artifact)
        (artifact_validated ?cache_artifact)
        (not
          (content_bundle_pinned ?content_bundle)
        )
      )
    :effect
      (and
        (content_bundle_pinned ?content_bundle)
        (bundle_artifact_binding ?content_bundle ?cache_artifact)
        (not
          (content_bundle_available ?content_bundle)
        )
      )
  )
  (:action prepare_controller_for_deployment
    :parameters (?controller - design_controller ?content_bundle - content_bundle ?cache_artifact - cache_artifact ?data_source - data_source)
    :precondition
      (and
        (component_validated ?controller)
        (controller_content_binding ?controller ?content_bundle)
        (content_bundle_pinned ?content_bundle)
        (bundle_artifact_binding ?content_bundle ?cache_artifact)
        (source_binding ?controller ?data_source)
        (not
          (artifact_includes_read_path ?cache_artifact)
        )
        (not
          (controller_prepared ?controller)
        )
      )
    :effect (controller_prepared ?controller)
  )
  (:action attach_placement_hint
    :parameters (?controller - design_controller ?placement_hint - placement_hint)
    :precondition
      (and
        (component_validated ?controller)
        (placement_hint_available ?placement_hint)
        (not
          (placement_hint_attached ?controller)
        )
      )
    :effect
      (and
        (placement_hint_attached ?controller)
        (controller_placement_binding ?controller ?placement_hint)
        (not
          (placement_hint_available ?placement_hint)
        )
      )
  )
  (:action apply_placement_hint_to_controller
    :parameters (?controller - design_controller ?content_bundle - content_bundle ?cache_artifact - cache_artifact ?data_source - data_source ?placement_hint - placement_hint)
    :precondition
      (and
        (component_validated ?controller)
        (controller_content_binding ?controller ?content_bundle)
        (content_bundle_pinned ?content_bundle)
        (bundle_artifact_binding ?content_bundle ?cache_artifact)
        (source_binding ?controller ?data_source)
        (artifact_includes_read_path ?cache_artifact)
        (placement_hint_attached ?controller)
        (controller_placement_binding ?controller ?placement_hint)
        (not
          (controller_prepared ?controller)
        )
      )
    :effect
      (and
        (controller_prepared ?controller)
        (placement_processed ?controller)
      )
  )
  (:action apply_resource_tag_to_controller_stage
    :parameters (?controller - design_controller ?resource_tag - resource_tag ?operator_adapter - operator_adapter ?content_bundle - content_bundle ?cache_artifact - cache_artifact)
    :precondition
      (and
        (controller_prepared ?controller)
        (controller_resource_tag_binding ?controller ?resource_tag)
        (adapter_assignment ?controller ?operator_adapter)
        (controller_content_binding ?controller ?content_bundle)
        (bundle_artifact_binding ?content_bundle ?cache_artifact)
        (not
          (artifact_includes_write_path ?cache_artifact)
        )
        (not
          (controller_validated ?controller)
        )
      )
    :effect (controller_validated ?controller)
  )
  (:action apply_resource_tag_to_controller_stage_with_write_path
    :parameters (?controller - design_controller ?resource_tag - resource_tag ?operator_adapter - operator_adapter ?content_bundle - content_bundle ?cache_artifact - cache_artifact)
    :precondition
      (and
        (controller_prepared ?controller)
        (controller_resource_tag_binding ?controller ?resource_tag)
        (adapter_assignment ?controller ?operator_adapter)
        (controller_content_binding ?controller ?content_bundle)
        (bundle_artifact_binding ?content_bundle ?cache_artifact)
        (artifact_includes_write_path ?cache_artifact)
        (not
          (controller_validated ?controller)
        )
      )
    :effect (controller_validated ?controller)
  )
  (:action apply_security_to_controller_stage
    :parameters (?controller - design_controller ?security_constraint - security_constraint ?content_bundle - content_bundle ?cache_artifact - cache_artifact)
    :precondition
      (and
        (controller_validated ?controller)
        (controller_security_binding ?controller ?security_constraint)
        (controller_content_binding ?controller ?content_bundle)
        (bundle_artifact_binding ?content_bundle ?cache_artifact)
        (not
          (artifact_includes_read_path ?cache_artifact)
        )
        (not
          (artifact_includes_write_path ?cache_artifact)
        )
        (not
          (controller_configured ?controller)
        )
      )
    :effect (controller_configured ?controller)
  )
  (:action apply_security_and_policy_to_controller
    :parameters (?controller - design_controller ?security_constraint - security_constraint ?content_bundle - content_bundle ?cache_artifact - cache_artifact)
    :precondition
      (and
        (controller_validated ?controller)
        (controller_security_binding ?controller ?security_constraint)
        (controller_content_binding ?controller ?content_bundle)
        (bundle_artifact_binding ?content_bundle ?cache_artifact)
        (artifact_includes_read_path ?cache_artifact)
        (not
          (artifact_includes_write_path ?cache_artifact)
        )
        (not
          (controller_configured ?controller)
        )
      )
    :effect
      (and
        (controller_configured ?controller)
        (controller_policy_applied ?controller)
      )
  )
  (:action apply_security_and_policy_to_controller_variant_c
    :parameters (?controller - design_controller ?security_constraint - security_constraint ?content_bundle - content_bundle ?cache_artifact - cache_artifact)
    :precondition
      (and
        (controller_validated ?controller)
        (controller_security_binding ?controller ?security_constraint)
        (controller_content_binding ?controller ?content_bundle)
        (bundle_artifact_binding ?content_bundle ?cache_artifact)
        (not
          (artifact_includes_read_path ?cache_artifact)
        )
        (artifact_includes_write_path ?cache_artifact)
        (not
          (controller_configured ?controller)
        )
      )
    :effect
      (and
        (controller_configured ?controller)
        (controller_policy_applied ?controller)
      )
  )
  (:action apply_security_and_policy_to_controller_variant_d
    :parameters (?controller - design_controller ?security_constraint - security_constraint ?content_bundle - content_bundle ?cache_artifact - cache_artifact)
    :precondition
      (and
        (controller_validated ?controller)
        (controller_security_binding ?controller ?security_constraint)
        (controller_content_binding ?controller ?content_bundle)
        (bundle_artifact_binding ?content_bundle ?cache_artifact)
        (artifact_includes_read_path ?cache_artifact)
        (artifact_includes_write_path ?cache_artifact)
        (not
          (controller_configured ?controller)
        )
      )
    :effect
      (and
        (controller_configured ?controller)
        (controller_policy_applied ?controller)
      )
  )
  (:action finalize_controller_activation
    :parameters (?controller - design_controller)
    :precondition
      (and
        (controller_configured ?controller)
        (not
          (controller_policy_applied ?controller)
        )
        (not
          (controller_finalized ?controller)
        )
      )
    :effect
      (and
        (controller_finalized ?controller)
        (operational_ready ?controller)
      )
  )
  (:action bind_performance_profile_to_controller
    :parameters (?controller - design_controller ?performance_profile - performance_profile)
    :precondition
      (and
        (controller_configured ?controller)
        (controller_policy_applied ?controller)
        (performance_profile_available ?performance_profile)
      )
    :effect
      (and
        (controller_performance_binding ?controller ?performance_profile)
        (not
          (performance_profile_available ?performance_profile)
        )
      )
  )
  (:action run_controller_operational_checks
    :parameters (?controller - design_controller ?primary_shard - primary_shard ?replica_shard - replica_shard ?data_source - data_source ?performance_profile - performance_profile)
    :precondition
      (and
        (controller_configured ?controller)
        (controller_policy_applied ?controller)
        (controller_performance_binding ?controller ?performance_profile)
        (controller_manages_primary_shard ?controller ?primary_shard)
        (controller_manages_replica_shard ?controller ?replica_shard)
        (primary_shard_ready ?primary_shard)
        (replica_shard_ready ?replica_shard)
        (source_binding ?controller ?data_source)
        (not
          (controller_operational_check_passed ?controller)
        )
      )
    :effect (controller_operational_check_passed ?controller)
  )
  (:action finalize_controller_post_checks
    :parameters (?controller - design_controller)
    :precondition
      (and
        (controller_configured ?controller)
        (controller_operational_check_passed ?controller)
        (not
          (controller_finalized ?controller)
        )
      )
    :effect
      (and
        (controller_finalized ?controller)
        (operational_ready ?controller)
      )
  )
  (:action apply_sla_to_controller
    :parameters (?controller - design_controller ?sla_profile - sla_profile ?data_source - data_source)
    :precondition
      (and
        (component_validated ?controller)
        (source_binding ?controller ?data_source)
        (sla_profile_available ?sla_profile)
        (controller_sla_binding ?controller ?sla_profile)
        (not
          (controller_sla_applied ?controller)
        )
      )
    :effect
      (and
        (controller_sla_applied ?controller)
        (not
          (sla_profile_available ?sla_profile)
        )
      )
  )
  (:action prepare_sla_with_adapter
    :parameters (?controller - design_controller ?operator_adapter - operator_adapter)
    :precondition
      (and
        (controller_sla_applied ?controller)
        (adapter_assignment ?controller ?operator_adapter)
        (not
          (sla_adapter_ready ?controller)
        )
      )
    :effect (sla_adapter_ready ?controller)
  )
  (:action commit_sla_on_controller
    :parameters (?controller - design_controller ?security_constraint - security_constraint)
    :precondition
      (and
        (sla_adapter_ready ?controller)
        (controller_security_binding ?controller ?security_constraint)
        (not
          (controller_sla_committed ?controller)
        )
      )
    :effect (controller_sla_committed ?controller)
  )
  (:action finalize_controller_sla_commit
    :parameters (?controller - design_controller)
    :precondition
      (and
        (controller_sla_committed ?controller)
        (not
          (controller_finalized ?controller)
        )
      )
    :effect
      (and
        (controller_finalized ?controller)
        (operational_ready ?controller)
      )
  )
  (:action activate_shard_via_artifact
    :parameters (?primary_shard - primary_shard ?cache_artifact - cache_artifact)
    :precondition
      (and
        (primary_shard_initialized ?primary_shard)
        (primary_shard_ready ?primary_shard)
        (artifact_packaged ?cache_artifact)
        (artifact_validated ?cache_artifact)
        (not
          (operational_ready ?primary_shard)
        )
      )
    :effect (operational_ready ?primary_shard)
  )
  (:action activate_replica_via_artifact
    :parameters (?replica_shard - replica_shard ?cache_artifact - cache_artifact)
    :precondition
      (and
        (replica_shard_initialized ?replica_shard)
        (replica_shard_ready ?replica_shard)
        (artifact_packaged ?cache_artifact)
        (artifact_validated ?cache_artifact)
        (not
          (operational_ready ?replica_shard)
        )
      )
    :effect (operational_ready ?replica_shard)
  )
  (:action bind_workload_descriptor_to_cache
    :parameters (?logical_cache - logical_cache ?workload_descriptor - workload_descriptor ?data_source - data_source)
    :precondition
      (and
        (operational_ready ?logical_cache)
        (source_binding ?logical_cache ?data_source)
        (workload_descriptor_available ?workload_descriptor)
        (not
          (workload_bound ?logical_cache)
        )
      )
    :effect
      (and
        (workload_bound ?logical_cache)
        (workload_binding ?logical_cache ?workload_descriptor)
        (not
          (workload_descriptor_available ?workload_descriptor)
        )
      )
  )
  (:action map_workload_to_primary_shard
    :parameters (?primary_shard - primary_shard ?compute_node - compute_node ?workload_descriptor - workload_descriptor)
    :precondition
      (and
        (workload_bound ?primary_shard)
        (node_assignment ?primary_shard ?compute_node)
        (workload_binding ?primary_shard ?workload_descriptor)
        (not
          (runtime_deployed ?primary_shard)
        )
      )
    :effect
      (and
        (runtime_deployed ?primary_shard)
        (node_available ?compute_node)
        (workload_descriptor_available ?workload_descriptor)
      )
  )
  (:action map_workload_to_replica_shard
    :parameters (?replica_shard - replica_shard ?compute_node - compute_node ?workload_descriptor - workload_descriptor)
    :precondition
      (and
        (workload_bound ?replica_shard)
        (node_assignment ?replica_shard ?compute_node)
        (workload_binding ?replica_shard ?workload_descriptor)
        (not
          (runtime_deployed ?replica_shard)
        )
      )
    :effect
      (and
        (runtime_deployed ?replica_shard)
        (node_available ?compute_node)
        (workload_descriptor_available ?workload_descriptor)
      )
  )
  (:action map_workload_to_controller
    :parameters (?controller - design_controller ?compute_node - compute_node ?workload_descriptor - workload_descriptor)
    :precondition
      (and
        (workload_bound ?controller)
        (node_assignment ?controller ?compute_node)
        (workload_binding ?controller ?workload_descriptor)
        (not
          (runtime_deployed ?controller)
        )
      )
    :effect
      (and
        (runtime_deployed ?controller)
        (node_available ?compute_node)
        (workload_descriptor_available ?workload_descriptor)
      )
  )
)

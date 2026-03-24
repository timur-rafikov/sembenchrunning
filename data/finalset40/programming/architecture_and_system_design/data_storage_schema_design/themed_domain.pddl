(define (domain data_storage_schema_design)
  (:requirements :strips :typing :negative-preconditions)
  (:types base_entity - object resource_class - base_entity feature_class - base_entity deployment_class - base_entity schema_element_class - base_entity schema_entity - schema_element_class storage_backend - resource_class attribute_spec - resource_class configurator_agent - resource_class label_token - resource_class access_policy - resource_class version_token - resource_class optimization_hint - resource_class approval_signature - resource_class optional_feature - feature_class data_asset - feature_class compliance_marker - feature_class shard_spec - deployment_class replica_spec - deployment_class deployment_package - deployment_class schema_entity_group_a - schema_entity schema_entity_group_b - schema_entity primary_entity_instance - schema_entity_group_a secondary_entity_instance - schema_entity_group_a schema_component - schema_entity_group_b)

  (:predicates
    (schema_entity_created ?schema_entity - schema_entity)
    (schema_entity_validated ?schema_entity - schema_entity)
    (schema_entity_backend_assigned ?schema_entity - schema_entity)
    (schema_entity_allocation_committed ?schema_entity - schema_entity)
    (schema_entity_marked_released ?schema_entity - schema_entity)
    (schema_entity_version_stamped ?schema_entity - schema_entity)
    (storage_backend_available ?storage_backend - storage_backend)
    (schema_entity_reserved_storage_backend ?schema_entity - schema_entity ?storage_backend - storage_backend)
    (attribute_spec_available ?attribute_spec - attribute_spec)
    (schema_entity_attribute_attached ?schema_entity - schema_entity ?attribute_spec - attribute_spec)
    (configurator_agent_available ?configurator_agent - configurator_agent)
    (schema_entity_assigned_configurator ?schema_entity - schema_entity ?configurator_agent - configurator_agent)
    (optional_feature_available ?optional_feature - optional_feature)
    (primary_instance_optional_feature_attached ?primary_instance - primary_entity_instance ?optional_feature - optional_feature)
    (secondary_instance_optional_feature_attached ?secondary_instance - secondary_entity_instance ?optional_feature - optional_feature)
    (primary_instance_bound_shard_spec ?primary_instance - primary_entity_instance ?shard_spec - shard_spec)
    (shard_spec_reserved ?shard_spec - shard_spec)
    (shard_spec_has_optional_feature ?shard_spec - shard_spec)
    (primary_instance_ready_for_package ?primary_instance - primary_entity_instance)
    (secondary_instance_bound_replica_spec ?secondary_instance - secondary_entity_instance ?replica_spec - replica_spec)
    (replica_spec_reserved ?replica_spec - replica_spec)
    (replica_spec_has_optional_feature ?replica_spec - replica_spec)
    (secondary_instance_ready_for_package ?secondary_instance - secondary_entity_instance)
    (deployment_package_available ?deployment_package - deployment_package)
    (deployment_package_ready ?deployment_package - deployment_package)
    (deployment_package_contains_shard_spec ?deployment_package - deployment_package ?shard_spec - shard_spec)
    (deployment_package_contains_replica_spec ?deployment_package - deployment_package ?replica_spec - replica_spec)
    (deployment_package_shard_registered ?deployment_package - deployment_package)
    (deployment_package_replica_registered ?deployment_package - deployment_package)
    (deployment_package_finalized ?deployment_package - deployment_package)
    (schema_entity_bound_to_primary_instance ?schema_component - schema_component ?primary_instance - primary_entity_instance)
    (schema_entity_bound_to_secondary_instance ?schema_component - schema_component ?secondary_instance - secondary_entity_instance)
    (schema_entity_bound_to_deployment_package ?schema_component - schema_component ?deployment_package - deployment_package)
    (data_asset_available ?data_asset - data_asset)
    (schema_entity_has_data_asset ?schema_component - schema_component ?data_asset - data_asset)
    (data_asset_attached ?data_asset - data_asset)
    (data_asset_bundled_in_deployment_package ?data_asset - data_asset ?deployment_package - deployment_package)
    (schema_entity_composition_validated ?schema_component - schema_component)
    (schema_entity_extension_ready ?schema_component - schema_component)
    (schema_entity_staging_complete ?schema_component - schema_component)
    (schema_entity_label_applied ?schema_component - schema_component)
    (schema_entity_label_confirmed ?schema_component - schema_component)
    (schema_entity_promotion_ready ?schema_component - schema_component)
    (schema_entity_composition_finalized ?schema_component - schema_component)
    (compliance_marker_available ?compliance_marker - compliance_marker)
    (schema_entity_associated_compliance_marker ?schema_component - schema_component ?compliance_marker - compliance_marker)
    (schema_entity_compliance_acknowledged ?schema_component - schema_component)
    (schema_entity_compliance_stage_ready ?schema_component - schema_component)
    (schema_entity_compliance_stage_finalized ?schema_component - schema_component)
    (label_token_available ?label_token - label_token)
    (schema_entity_has_label_token ?schema_component - schema_component ?label_token - label_token)
    (access_policy_available ?access_policy - access_policy)
    (schema_entity_assigned_access_policy ?schema_component - schema_component ?access_policy - access_policy)
    (optimization_hint_available ?optimization_hint - optimization_hint)
    (schema_entity_has_optimization_hint ?schema_component - schema_component ?optimization_hint - optimization_hint)
    (approval_signature_available ?approval_signature - approval_signature)
    (schema_entity_has_approval_signature ?schema_component - schema_component ?approval_signature - approval_signature)
    (version_token_available ?version_token - version_token)
    (schema_entity_has_version_token ?schema_entity - schema_entity ?version_token - version_token)
    (primary_instance_prepared ?primary_instance - primary_entity_instance)
    (secondary_instance_prepared ?secondary_instance - secondary_entity_instance)
    (schema_entity_finalized ?schema_component - schema_component)
  )
  (:action define_schema_entity
    :parameters (?schema_entity - schema_entity)
    :precondition
      (and
        (not
          (schema_entity_created ?schema_entity)
        )
        (not
          (schema_entity_allocation_committed ?schema_entity)
        )
      )
    :effect (schema_entity_created ?schema_entity)
  )
  (:action reserve_storage_backend_for_entity
    :parameters (?schema_entity - schema_entity ?storage_backend - storage_backend)
    :precondition
      (and
        (schema_entity_created ?schema_entity)
        (not
          (schema_entity_backend_assigned ?schema_entity)
        )
        (storage_backend_available ?storage_backend)
      )
    :effect
      (and
        (schema_entity_backend_assigned ?schema_entity)
        (schema_entity_reserved_storage_backend ?schema_entity ?storage_backend)
        (not
          (storage_backend_available ?storage_backend)
        )
      )
  )
  (:action attach_attribute_spec_to_entity
    :parameters (?schema_entity - schema_entity ?attribute_spec - attribute_spec)
    :precondition
      (and
        (schema_entity_created ?schema_entity)
        (schema_entity_backend_assigned ?schema_entity)
        (attribute_spec_available ?attribute_spec)
      )
    :effect
      (and
        (schema_entity_attribute_attached ?schema_entity ?attribute_spec)
        (not
          (attribute_spec_available ?attribute_spec)
        )
      )
  )
  (:action finalize_attribute_attachment_to_entity
    :parameters (?schema_entity - schema_entity ?attribute_spec - attribute_spec)
    :precondition
      (and
        (schema_entity_created ?schema_entity)
        (schema_entity_backend_assigned ?schema_entity)
        (schema_entity_attribute_attached ?schema_entity ?attribute_spec)
        (not
          (schema_entity_validated ?schema_entity)
        )
      )
    :effect (schema_entity_validated ?schema_entity)
  )
  (:action detach_attribute_from_entity
    :parameters (?schema_entity - schema_entity ?attribute_spec - attribute_spec)
    :precondition
      (and
        (schema_entity_attribute_attached ?schema_entity ?attribute_spec)
      )
    :effect
      (and
        (attribute_spec_available ?attribute_spec)
        (not
          (schema_entity_attribute_attached ?schema_entity ?attribute_spec)
        )
      )
  )
  (:action assign_configurator_to_entity
    :parameters (?schema_entity - schema_entity ?configurator_agent - configurator_agent)
    :precondition
      (and
        (schema_entity_validated ?schema_entity)
        (configurator_agent_available ?configurator_agent)
      )
    :effect
      (and
        (schema_entity_assigned_configurator ?schema_entity ?configurator_agent)
        (not
          (configurator_agent_available ?configurator_agent)
        )
      )
  )
  (:action unassign_configurator_from_entity
    :parameters (?schema_entity - schema_entity ?configurator_agent - configurator_agent)
    :precondition
      (and
        (schema_entity_assigned_configurator ?schema_entity ?configurator_agent)
      )
    :effect
      (and
        (configurator_agent_available ?configurator_agent)
        (not
          (schema_entity_assigned_configurator ?schema_entity ?configurator_agent)
        )
      )
  )
  (:action attach_optimization_hint_to_component
    :parameters (?schema_component - schema_component ?optimization_hint - optimization_hint)
    :precondition
      (and
        (schema_entity_validated ?schema_component)
        (optimization_hint_available ?optimization_hint)
      )
    :effect
      (and
        (schema_entity_has_optimization_hint ?schema_component ?optimization_hint)
        (not
          (optimization_hint_available ?optimization_hint)
        )
      )
  )
  (:action detach_optimization_hint_from_component
    :parameters (?schema_component - schema_component ?optimization_hint - optimization_hint)
    :precondition
      (and
        (schema_entity_has_optimization_hint ?schema_component ?optimization_hint)
      )
    :effect
      (and
        (optimization_hint_available ?optimization_hint)
        (not
          (schema_entity_has_optimization_hint ?schema_component ?optimization_hint)
        )
      )
  )
  (:action attach_approval_signature_to_component
    :parameters (?schema_component - schema_component ?approval_signature - approval_signature)
    :precondition
      (and
        (schema_entity_validated ?schema_component)
        (approval_signature_available ?approval_signature)
      )
    :effect
      (and
        (schema_entity_has_approval_signature ?schema_component ?approval_signature)
        (not
          (approval_signature_available ?approval_signature)
        )
      )
  )
  (:action remove_approval_signature_from_component
    :parameters (?schema_component - schema_component ?approval_signature - approval_signature)
    :precondition
      (and
        (schema_entity_has_approval_signature ?schema_component ?approval_signature)
      )
    :effect
      (and
        (approval_signature_available ?approval_signature)
        (not
          (schema_entity_has_approval_signature ?schema_component ?approval_signature)
        )
      )
  )
  (:action reserve_shard_for_primary_instance
    :parameters (?primary_instance - primary_entity_instance ?shard_spec - shard_spec ?attribute_spec - attribute_spec)
    :precondition
      (and
        (schema_entity_validated ?primary_instance)
        (schema_entity_attribute_attached ?primary_instance ?attribute_spec)
        (primary_instance_bound_shard_spec ?primary_instance ?shard_spec)
        (not
          (shard_spec_reserved ?shard_spec)
        )
        (not
          (shard_spec_has_optional_feature ?shard_spec)
        )
      )
    :effect (shard_spec_reserved ?shard_spec)
  )
  (:action prepare_primary_instance_shard_allocation
    :parameters (?primary_instance - primary_entity_instance ?shard_spec - shard_spec ?configurator_agent - configurator_agent)
    :precondition
      (and
        (schema_entity_validated ?primary_instance)
        (schema_entity_assigned_configurator ?primary_instance ?configurator_agent)
        (primary_instance_bound_shard_spec ?primary_instance ?shard_spec)
        (shard_spec_reserved ?shard_spec)
        (not
          (primary_instance_prepared ?primary_instance)
        )
      )
    :effect
      (and
        (primary_instance_prepared ?primary_instance)
        (primary_instance_ready_for_package ?primary_instance)
      )
  )
  (:action attach_optional_feature_to_primary_shard
    :parameters (?primary_instance - primary_entity_instance ?shard_spec - shard_spec ?optional_feature - optional_feature)
    :precondition
      (and
        (schema_entity_validated ?primary_instance)
        (primary_instance_bound_shard_spec ?primary_instance ?shard_spec)
        (optional_feature_available ?optional_feature)
        (not
          (primary_instance_prepared ?primary_instance)
        )
      )
    :effect
      (and
        (shard_spec_has_optional_feature ?shard_spec)
        (primary_instance_prepared ?primary_instance)
        (primary_instance_optional_feature_attached ?primary_instance ?optional_feature)
        (not
          (optional_feature_available ?optional_feature)
        )
      )
  )
  (:action provision_primary_instance_with_shard_and_feature
    :parameters (?primary_instance - primary_entity_instance ?shard_spec - shard_spec ?attribute_spec - attribute_spec ?optional_feature - optional_feature)
    :precondition
      (and
        (schema_entity_validated ?primary_instance)
        (schema_entity_attribute_attached ?primary_instance ?attribute_spec)
        (primary_instance_bound_shard_spec ?primary_instance ?shard_spec)
        (shard_spec_has_optional_feature ?shard_spec)
        (primary_instance_optional_feature_attached ?primary_instance ?optional_feature)
        (not
          (primary_instance_ready_for_package ?primary_instance)
        )
      )
    :effect
      (and
        (shard_spec_reserved ?shard_spec)
        (primary_instance_ready_for_package ?primary_instance)
        (optional_feature_available ?optional_feature)
        (not
          (primary_instance_optional_feature_attached ?primary_instance ?optional_feature)
        )
      )
  )
  (:action reserve_replica_for_secondary_instance
    :parameters (?secondary_instance - secondary_entity_instance ?replica_spec - replica_spec ?attribute_spec - attribute_spec)
    :precondition
      (and
        (schema_entity_validated ?secondary_instance)
        (schema_entity_attribute_attached ?secondary_instance ?attribute_spec)
        (secondary_instance_bound_replica_spec ?secondary_instance ?replica_spec)
        (not
          (replica_spec_reserved ?replica_spec)
        )
        (not
          (replica_spec_has_optional_feature ?replica_spec)
        )
      )
    :effect (replica_spec_reserved ?replica_spec)
  )
  (:action prepare_secondary_replica_with_configurator
    :parameters (?secondary_instance - secondary_entity_instance ?replica_spec - replica_spec ?configurator_agent - configurator_agent)
    :precondition
      (and
        (schema_entity_validated ?secondary_instance)
        (schema_entity_assigned_configurator ?secondary_instance ?configurator_agent)
        (secondary_instance_bound_replica_spec ?secondary_instance ?replica_spec)
        (replica_spec_reserved ?replica_spec)
        (not
          (secondary_instance_prepared ?secondary_instance)
        )
      )
    :effect
      (and
        (secondary_instance_prepared ?secondary_instance)
        (secondary_instance_ready_for_package ?secondary_instance)
      )
  )
  (:action attach_optional_feature_to_secondary_replica
    :parameters (?secondary_instance - secondary_entity_instance ?replica_spec - replica_spec ?optional_feature - optional_feature)
    :precondition
      (and
        (schema_entity_validated ?secondary_instance)
        (secondary_instance_bound_replica_spec ?secondary_instance ?replica_spec)
        (optional_feature_available ?optional_feature)
        (not
          (secondary_instance_prepared ?secondary_instance)
        )
      )
    :effect
      (and
        (replica_spec_has_optional_feature ?replica_spec)
        (secondary_instance_prepared ?secondary_instance)
        (secondary_instance_optional_feature_attached ?secondary_instance ?optional_feature)
        (not
          (optional_feature_available ?optional_feature)
        )
      )
  )
  (:action provision_secondary_instance_with_replica_and_feature
    :parameters (?secondary_instance - secondary_entity_instance ?replica_spec - replica_spec ?attribute_spec - attribute_spec ?optional_feature - optional_feature)
    :precondition
      (and
        (schema_entity_validated ?secondary_instance)
        (schema_entity_attribute_attached ?secondary_instance ?attribute_spec)
        (secondary_instance_bound_replica_spec ?secondary_instance ?replica_spec)
        (replica_spec_has_optional_feature ?replica_spec)
        (secondary_instance_optional_feature_attached ?secondary_instance ?optional_feature)
        (not
          (secondary_instance_ready_for_package ?secondary_instance)
        )
      )
    :effect
      (and
        (replica_spec_reserved ?replica_spec)
        (secondary_instance_ready_for_package ?secondary_instance)
        (optional_feature_available ?optional_feature)
        (not
          (secondary_instance_optional_feature_attached ?secondary_instance ?optional_feature)
        )
      )
  )
  (:action create_deployment_package_from_prepared_specs
    :parameters (?primary_instance - primary_entity_instance ?secondary_instance - secondary_entity_instance ?shard_spec - shard_spec ?replica_spec - replica_spec ?deployment_package - deployment_package)
    :precondition
      (and
        (primary_instance_prepared ?primary_instance)
        (secondary_instance_prepared ?secondary_instance)
        (primary_instance_bound_shard_spec ?primary_instance ?shard_spec)
        (secondary_instance_bound_replica_spec ?secondary_instance ?replica_spec)
        (shard_spec_reserved ?shard_spec)
        (replica_spec_reserved ?replica_spec)
        (primary_instance_ready_for_package ?primary_instance)
        (secondary_instance_ready_for_package ?secondary_instance)
        (deployment_package_available ?deployment_package)
      )
    :effect
      (and
        (deployment_package_ready ?deployment_package)
        (deployment_package_contains_shard_spec ?deployment_package ?shard_spec)
        (deployment_package_contains_replica_spec ?deployment_package ?replica_spec)
        (not
          (deployment_package_available ?deployment_package)
        )
      )
  )
  (:action assemble_deployment_package_and_register_shard
    :parameters (?primary_instance - primary_entity_instance ?secondary_instance - secondary_entity_instance ?shard_spec - shard_spec ?replica_spec - replica_spec ?deployment_package - deployment_package)
    :precondition
      (and
        (primary_instance_prepared ?primary_instance)
        (secondary_instance_prepared ?secondary_instance)
        (primary_instance_bound_shard_spec ?primary_instance ?shard_spec)
        (secondary_instance_bound_replica_spec ?secondary_instance ?replica_spec)
        (shard_spec_has_optional_feature ?shard_spec)
        (replica_spec_reserved ?replica_spec)
        (not
          (primary_instance_ready_for_package ?primary_instance)
        )
        (secondary_instance_ready_for_package ?secondary_instance)
        (deployment_package_available ?deployment_package)
      )
    :effect
      (and
        (deployment_package_ready ?deployment_package)
        (deployment_package_contains_shard_spec ?deployment_package ?shard_spec)
        (deployment_package_contains_replica_spec ?deployment_package ?replica_spec)
        (deployment_package_shard_registered ?deployment_package)
        (not
          (deployment_package_available ?deployment_package)
        )
      )
  )
  (:action assemble_deployment_package_and_register_replica
    :parameters (?primary_instance - primary_entity_instance ?secondary_instance - secondary_entity_instance ?shard_spec - shard_spec ?replica_spec - replica_spec ?deployment_package - deployment_package)
    :precondition
      (and
        (primary_instance_prepared ?primary_instance)
        (secondary_instance_prepared ?secondary_instance)
        (primary_instance_bound_shard_spec ?primary_instance ?shard_spec)
        (secondary_instance_bound_replica_spec ?secondary_instance ?replica_spec)
        (shard_spec_reserved ?shard_spec)
        (replica_spec_has_optional_feature ?replica_spec)
        (primary_instance_ready_for_package ?primary_instance)
        (not
          (secondary_instance_ready_for_package ?secondary_instance)
        )
        (deployment_package_available ?deployment_package)
      )
    :effect
      (and
        (deployment_package_ready ?deployment_package)
        (deployment_package_contains_shard_spec ?deployment_package ?shard_spec)
        (deployment_package_contains_replica_spec ?deployment_package ?replica_spec)
        (deployment_package_replica_registered ?deployment_package)
        (not
          (deployment_package_available ?deployment_package)
        )
      )
  )
  (:action assemble_deployment_package_and_register_both
    :parameters (?primary_instance - primary_entity_instance ?secondary_instance - secondary_entity_instance ?shard_spec - shard_spec ?replica_spec - replica_spec ?deployment_package - deployment_package)
    :precondition
      (and
        (primary_instance_prepared ?primary_instance)
        (secondary_instance_prepared ?secondary_instance)
        (primary_instance_bound_shard_spec ?primary_instance ?shard_spec)
        (secondary_instance_bound_replica_spec ?secondary_instance ?replica_spec)
        (shard_spec_has_optional_feature ?shard_spec)
        (replica_spec_has_optional_feature ?replica_spec)
        (not
          (primary_instance_ready_for_package ?primary_instance)
        )
        (not
          (secondary_instance_ready_for_package ?secondary_instance)
        )
        (deployment_package_available ?deployment_package)
      )
    :effect
      (and
        (deployment_package_ready ?deployment_package)
        (deployment_package_contains_shard_spec ?deployment_package ?shard_spec)
        (deployment_package_contains_replica_spec ?deployment_package ?replica_spec)
        (deployment_package_shard_registered ?deployment_package)
        (deployment_package_replica_registered ?deployment_package)
        (not
          (deployment_package_available ?deployment_package)
        )
      )
  )
  (:action finalize_deployment_package_before_composition
    :parameters (?deployment_package - deployment_package ?primary_instance - primary_entity_instance ?attribute_spec - attribute_spec)
    :precondition
      (and
        (deployment_package_ready ?deployment_package)
        (primary_instance_prepared ?primary_instance)
        (schema_entity_attribute_attached ?primary_instance ?attribute_spec)
        (not
          (deployment_package_finalized ?deployment_package)
        )
      )
    :effect (deployment_package_finalized ?deployment_package)
  )
  (:action attach_data_asset_to_component_and_package
    :parameters (?schema_component - schema_component ?data_asset - data_asset ?deployment_package - deployment_package)
    :precondition
      (and
        (schema_entity_validated ?schema_component)
        (schema_entity_bound_to_deployment_package ?schema_component ?deployment_package)
        (schema_entity_has_data_asset ?schema_component ?data_asset)
        (data_asset_available ?data_asset)
        (deployment_package_ready ?deployment_package)
        (deployment_package_finalized ?deployment_package)
        (not
          (data_asset_attached ?data_asset)
        )
      )
    :effect
      (and
        (data_asset_attached ?data_asset)
        (data_asset_bundled_in_deployment_package ?data_asset ?deployment_package)
        (not
          (data_asset_available ?data_asset)
        )
      )
  )
  (:action validate_component_composition_with_data_asset
    :parameters (?schema_component - schema_component ?data_asset - data_asset ?deployment_package - deployment_package ?attribute_spec - attribute_spec)
    :precondition
      (and
        (schema_entity_validated ?schema_component)
        (schema_entity_has_data_asset ?schema_component ?data_asset)
        (data_asset_attached ?data_asset)
        (data_asset_bundled_in_deployment_package ?data_asset ?deployment_package)
        (schema_entity_attribute_attached ?schema_component ?attribute_spec)
        (not
          (deployment_package_shard_registered ?deployment_package)
        )
        (not
          (schema_entity_composition_validated ?schema_component)
        )
      )
    :effect (schema_entity_composition_validated ?schema_component)
  )
  (:action apply_label_to_component
    :parameters (?schema_component - schema_component ?label_token - label_token)
    :precondition
      (and
        (schema_entity_validated ?schema_component)
        (label_token_available ?label_token)
        (not
          (schema_entity_label_applied ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_label_applied ?schema_component)
        (schema_entity_has_label_token ?schema_component ?label_token)
        (not
          (label_token_available ?label_token)
        )
      )
  )
  (:action compose_component_with_data_asset_and_label
    :parameters (?schema_component - schema_component ?data_asset - data_asset ?deployment_package - deployment_package ?attribute_spec - attribute_spec ?label_token - label_token)
    :precondition
      (and
        (schema_entity_validated ?schema_component)
        (schema_entity_has_data_asset ?schema_component ?data_asset)
        (data_asset_attached ?data_asset)
        (data_asset_bundled_in_deployment_package ?data_asset ?deployment_package)
        (schema_entity_attribute_attached ?schema_component ?attribute_spec)
        (deployment_package_shard_registered ?deployment_package)
        (schema_entity_label_applied ?schema_component)
        (schema_entity_has_label_token ?schema_component ?label_token)
        (not
          (schema_entity_composition_validated ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_composition_validated ?schema_component)
        (schema_entity_label_confirmed ?schema_component)
      )
  )
  (:action apply_optimization_hint_and_prepare_component
    :parameters (?schema_component - schema_component ?optimization_hint - optimization_hint ?configurator_agent - configurator_agent ?data_asset - data_asset ?deployment_package - deployment_package)
    :precondition
      (and
        (schema_entity_composition_validated ?schema_component)
        (schema_entity_has_optimization_hint ?schema_component ?optimization_hint)
        (schema_entity_assigned_configurator ?schema_component ?configurator_agent)
        (schema_entity_has_data_asset ?schema_component ?data_asset)
        (data_asset_bundled_in_deployment_package ?data_asset ?deployment_package)
        (not
          (deployment_package_replica_registered ?deployment_package)
        )
        (not
          (schema_entity_extension_ready ?schema_component)
        )
      )
    :effect (schema_entity_extension_ready ?schema_component)
  )
  (:action apply_optimization_hint_and_prepare_component_after_replica_registration
    :parameters (?schema_component - schema_component ?optimization_hint - optimization_hint ?configurator_agent - configurator_agent ?data_asset - data_asset ?deployment_package - deployment_package)
    :precondition
      (and
        (schema_entity_composition_validated ?schema_component)
        (schema_entity_has_optimization_hint ?schema_component ?optimization_hint)
        (schema_entity_assigned_configurator ?schema_component ?configurator_agent)
        (schema_entity_has_data_asset ?schema_component ?data_asset)
        (data_asset_bundled_in_deployment_package ?data_asset ?deployment_package)
        (deployment_package_replica_registered ?deployment_package)
        (not
          (schema_entity_extension_ready ?schema_component)
        )
      )
    :effect (schema_entity_extension_ready ?schema_component)
  )
  (:action apply_approval_signature_and_stage_component
    :parameters (?schema_component - schema_component ?approval_signature - approval_signature ?data_asset - data_asset ?deployment_package - deployment_package)
    :precondition
      (and
        (schema_entity_extension_ready ?schema_component)
        (schema_entity_has_approval_signature ?schema_component ?approval_signature)
        (schema_entity_has_data_asset ?schema_component ?data_asset)
        (data_asset_bundled_in_deployment_package ?data_asset ?deployment_package)
        (not
          (deployment_package_shard_registered ?deployment_package)
        )
        (not
          (deployment_package_replica_registered ?deployment_package)
        )
        (not
          (schema_entity_staging_complete ?schema_component)
        )
      )
    :effect (schema_entity_staging_complete ?schema_component)
  )
  (:action apply_approval_and_stage_component_with_shard_flag
    :parameters (?schema_component - schema_component ?approval_signature - approval_signature ?data_asset - data_asset ?deployment_package - deployment_package)
    :precondition
      (and
        (schema_entity_extension_ready ?schema_component)
        (schema_entity_has_approval_signature ?schema_component ?approval_signature)
        (schema_entity_has_data_asset ?schema_component ?data_asset)
        (data_asset_bundled_in_deployment_package ?data_asset ?deployment_package)
        (deployment_package_shard_registered ?deployment_package)
        (not
          (deployment_package_replica_registered ?deployment_package)
        )
        (not
          (schema_entity_staging_complete ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_staging_complete ?schema_component)
        (schema_entity_promotion_ready ?schema_component)
      )
  )
  (:action apply_approval_and_stage_component_with_replica_flag
    :parameters (?schema_component - schema_component ?approval_signature - approval_signature ?data_asset - data_asset ?deployment_package - deployment_package)
    :precondition
      (and
        (schema_entity_extension_ready ?schema_component)
        (schema_entity_has_approval_signature ?schema_component ?approval_signature)
        (schema_entity_has_data_asset ?schema_component ?data_asset)
        (data_asset_bundled_in_deployment_package ?data_asset ?deployment_package)
        (not
          (deployment_package_shard_registered ?deployment_package)
        )
        (deployment_package_replica_registered ?deployment_package)
        (not
          (schema_entity_staging_complete ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_staging_complete ?schema_component)
        (schema_entity_promotion_ready ?schema_component)
      )
  )
  (:action apply_approval_and_stage_component_with_all_flags
    :parameters (?schema_component - schema_component ?approval_signature - approval_signature ?data_asset - data_asset ?deployment_package - deployment_package)
    :precondition
      (and
        (schema_entity_extension_ready ?schema_component)
        (schema_entity_has_approval_signature ?schema_component ?approval_signature)
        (schema_entity_has_data_asset ?schema_component ?data_asset)
        (data_asset_bundled_in_deployment_package ?data_asset ?deployment_package)
        (deployment_package_shard_registered ?deployment_package)
        (deployment_package_replica_registered ?deployment_package)
        (not
          (schema_entity_staging_complete ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_staging_complete ?schema_component)
        (schema_entity_promotion_ready ?schema_component)
      )
  )
  (:action finalize_component_for_release
    :parameters (?schema_component - schema_component)
    :precondition
      (and
        (schema_entity_staging_complete ?schema_component)
        (not
          (schema_entity_promotion_ready ?schema_component)
        )
        (not
          (schema_entity_finalized ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_finalized ?schema_component)
        (schema_entity_marked_released ?schema_component)
      )
  )
  (:action assign_access_policy_to_component
    :parameters (?schema_component - schema_component ?access_policy - access_policy)
    :precondition
      (and
        (schema_entity_staging_complete ?schema_component)
        (schema_entity_promotion_ready ?schema_component)
        (access_policy_available ?access_policy)
      )
    :effect
      (and
        (schema_entity_assigned_access_policy ?schema_component ?access_policy)
        (not
          (access_policy_available ?access_policy)
        )
      )
  )
  (:action validate_component_composition_with_policy_and_instances
    :parameters (?schema_component - schema_component ?primary_instance - primary_entity_instance ?secondary_instance - secondary_entity_instance ?attribute_spec - attribute_spec ?access_policy - access_policy)
    :precondition
      (and
        (schema_entity_staging_complete ?schema_component)
        (schema_entity_promotion_ready ?schema_component)
        (schema_entity_assigned_access_policy ?schema_component ?access_policy)
        (schema_entity_bound_to_primary_instance ?schema_component ?primary_instance)
        (schema_entity_bound_to_secondary_instance ?schema_component ?secondary_instance)
        (primary_instance_ready_for_package ?primary_instance)
        (secondary_instance_ready_for_package ?secondary_instance)
        (schema_entity_attribute_attached ?schema_component ?attribute_spec)
        (not
          (schema_entity_composition_finalized ?schema_component)
        )
      )
    :effect (schema_entity_composition_finalized ?schema_component)
  )
  (:action finalize_component_for_release_with_integration
    :parameters (?schema_component - schema_component)
    :precondition
      (and
        (schema_entity_staging_complete ?schema_component)
        (schema_entity_composition_finalized ?schema_component)
        (not
          (schema_entity_finalized ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_finalized ?schema_component)
        (schema_entity_marked_released ?schema_component)
      )
  )
  (:action claim_compliance_marker_for_component
    :parameters (?schema_component - schema_component ?compliance_marker - compliance_marker ?attribute_spec - attribute_spec)
    :precondition
      (and
        (schema_entity_validated ?schema_component)
        (schema_entity_attribute_attached ?schema_component ?attribute_spec)
        (compliance_marker_available ?compliance_marker)
        (schema_entity_associated_compliance_marker ?schema_component ?compliance_marker)
        (not
          (schema_entity_compliance_acknowledged ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_compliance_acknowledged ?schema_component)
        (not
          (compliance_marker_available ?compliance_marker)
        )
      )
  )
  (:action approve_component_compliance_stage
    :parameters (?schema_component - schema_component ?configurator_agent - configurator_agent)
    :precondition
      (and
        (schema_entity_compliance_acknowledged ?schema_component)
        (schema_entity_assigned_configurator ?schema_component ?configurator_agent)
        (not
          (schema_entity_compliance_stage_ready ?schema_component)
        )
      )
    :effect (schema_entity_compliance_stage_ready ?schema_component)
  )
  (:action apply_approval_signature_and_mark_compliance_ready
    :parameters (?schema_component - schema_component ?approval_signature - approval_signature)
    :precondition
      (and
        (schema_entity_compliance_stage_ready ?schema_component)
        (schema_entity_has_approval_signature ?schema_component ?approval_signature)
        (not
          (schema_entity_compliance_stage_finalized ?schema_component)
        )
      )
    :effect (schema_entity_compliance_stage_finalized ?schema_component)
  )
  (:action finalize_compliance_stage_and_mark_component_releasable
    :parameters (?schema_component - schema_component)
    :precondition
      (and
        (schema_entity_compliance_stage_finalized ?schema_component)
        (not
          (schema_entity_finalized ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_finalized ?schema_component)
        (schema_entity_marked_released ?schema_component)
      )
  )
  (:action publish_primary_instance_with_package
    :parameters (?primary_instance - primary_entity_instance ?deployment_package - deployment_package)
    :precondition
      (and
        (primary_instance_prepared ?primary_instance)
        (primary_instance_ready_for_package ?primary_instance)
        (deployment_package_ready ?deployment_package)
        (deployment_package_finalized ?deployment_package)
        (not
          (schema_entity_marked_released ?primary_instance)
        )
      )
    :effect (schema_entity_marked_released ?primary_instance)
  )
  (:action publish_secondary_instance_with_package
    :parameters (?secondary_instance - secondary_entity_instance ?deployment_package - deployment_package)
    :precondition
      (and
        (secondary_instance_prepared ?secondary_instance)
        (secondary_instance_ready_for_package ?secondary_instance)
        (deployment_package_ready ?deployment_package)
        (deployment_package_finalized ?deployment_package)
        (not
          (schema_entity_marked_released ?secondary_instance)
        )
      )
    :effect (schema_entity_marked_released ?secondary_instance)
  )
  (:action assign_version_token_to_schema_entity
    :parameters (?schema_entity - schema_entity ?version_token - version_token ?attribute_spec - attribute_spec)
    :precondition
      (and
        (schema_entity_marked_released ?schema_entity)
        (schema_entity_attribute_attached ?schema_entity ?attribute_spec)
        (version_token_available ?version_token)
        (not
          (schema_entity_version_stamped ?schema_entity)
        )
      )
    :effect
      (and
        (schema_entity_version_stamped ?schema_entity)
        (schema_entity_has_version_token ?schema_entity ?version_token)
        (not
          (version_token_available ?version_token)
        )
      )
  )
  (:action commit_allocation_to_primary_instance
    :parameters (?primary_instance - primary_entity_instance ?storage_backend - storage_backend ?version_token - version_token)
    :precondition
      (and
        (schema_entity_version_stamped ?primary_instance)
        (schema_entity_reserved_storage_backend ?primary_instance ?storage_backend)
        (schema_entity_has_version_token ?primary_instance ?version_token)
        (not
          (schema_entity_allocation_committed ?primary_instance)
        )
      )
    :effect
      (and
        (schema_entity_allocation_committed ?primary_instance)
        (storage_backend_available ?storage_backend)
        (version_token_available ?version_token)
      )
  )
  (:action commit_allocation_to_secondary_instance
    :parameters (?secondary_instance - secondary_entity_instance ?storage_backend - storage_backend ?version_token - version_token)
    :precondition
      (and
        (schema_entity_version_stamped ?secondary_instance)
        (schema_entity_reserved_storage_backend ?secondary_instance ?storage_backend)
        (schema_entity_has_version_token ?secondary_instance ?version_token)
        (not
          (schema_entity_allocation_committed ?secondary_instance)
        )
      )
    :effect
      (and
        (schema_entity_allocation_committed ?secondary_instance)
        (storage_backend_available ?storage_backend)
        (version_token_available ?version_token)
      )
  )
  (:action commit_allocation_to_component
    :parameters (?schema_component - schema_component ?storage_backend - storage_backend ?version_token - version_token)
    :precondition
      (and
        (schema_entity_version_stamped ?schema_component)
        (schema_entity_reserved_storage_backend ?schema_component ?storage_backend)
        (schema_entity_has_version_token ?schema_component ?version_token)
        (not
          (schema_entity_allocation_committed ?schema_component)
        )
      )
    :effect
      (and
        (schema_entity_allocation_committed ?schema_component)
        (storage_backend_available ?storage_backend)
        (version_token_available ?version_token)
      )
  )
)

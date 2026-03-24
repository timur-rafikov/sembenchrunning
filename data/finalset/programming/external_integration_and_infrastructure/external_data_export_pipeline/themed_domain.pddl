(define (domain external_data_export_pipeline)
  (:requirements :strips :typing :negative-preconditions)
  (:types infrastructure_component - object data_artifact_type - object network_path_type - object export_resource_category - object export_resource - export_resource_category connector - infrastructure_component data_batch - infrastructure_component credential - infrastructure_component notification_template - infrastructure_component delivery_policy - infrastructure_component retry_token - infrastructure_component compression_option - infrastructure_component encryption_key - infrastructure_component transformation - data_artifact_type storage_artifact - data_artifact_type schema_version - data_artifact_type route_path - network_path_type transmission_channel - network_path_type export_package - network_path_type source_category - export_resource service_category - export_resource primary_data_source - source_category secondary_data_source - source_category export_service - service_category)
  (:predicates
    (export_resource_registered ?export_resource - export_resource)
    (component_configured ?export_resource - export_resource)
    (resource_has_connector ?export_resource - export_resource)
    (allocated_to_connector ?export_resource - export_resource)
    (ready_for_delivery ?export_resource - export_resource)
    (dispatch_scheduled ?export_resource - export_resource)
    (connector_available ?connector - connector)
    (bound_to_connector ?export_resource - export_resource ?connector - connector)
    (data_batch_available ?data_batch - data_batch)
    (batch_attached ?export_resource - export_resource ?data_batch - data_batch)
    (credential_available ?credential - credential)
    (credential_bound ?export_resource - export_resource ?credential - credential)
    (transformation_available ?transformation - transformation)
    (assigned_transformation ?primary_data_source - primary_data_source ?transformation - transformation)
    (assigned_transformation_secondary ?secondary_data_source - secondary_data_source ?transformation - transformation)
    (route_assigned_to_source ?primary_data_source - primary_data_source ?route_path - route_path)
    (route_reserved ?route_path - route_path)
    (route_transformed ?route_path - route_path)
    (source_ready_for_package ?primary_data_source - primary_data_source)
    (channel_assigned_to_secondary ?secondary_data_source - secondary_data_source ?transmission_channel - transmission_channel)
    (channel_ready ?transmission_channel - transmission_channel)
    (channel_transformed ?transmission_channel - transmission_channel)
    (secondary_ready_for_package ?secondary_data_source - secondary_data_source)
    (export_package_available ?export_package - export_package)
    (export_package_ready ?export_package - export_package)
    (package_includes_route ?export_package - export_package ?route_path - route_path)
    (package_includes_channel ?export_package - export_package ?transmission_channel - transmission_channel)
    (package_missing_primary_source ?export_package - export_package)
    (package_missing_secondary_source ?export_package - export_package)
    (package_validated ?export_package - export_package)
    (service_bound_to_primary ?export_service - export_service ?primary_data_source - primary_data_source)
    (service_bound_to_secondary ?export_service - export_service ?secondary_data_source - secondary_data_source)
    (service_associated_with_package ?export_service - export_service ?export_package - export_package)
    (storage_artifact_available ?storage_artifact - storage_artifact)
    (service_attached_artifact ?export_service - export_service ?storage_artifact - storage_artifact)
    (artifact_attached ?storage_artifact - storage_artifact)
    (artifact_in_package ?storage_artifact - storage_artifact ?export_package - export_package)
    (service_artifact_attachment_confirmed ?export_service - export_service)
    (compression_selected_for_service ?export_service - export_service)
    (encryption_applied_to_service ?export_service - export_service)
    (service_notification_template_bound ?export_service - export_service)
    (service_notification_template_confirmed ?export_service - export_service)
    (policy_confirmed_for_service ?export_service - export_service)
    (pre_delivery_checks_passed ?export_service - export_service)
    (schema_version_available ?schema_version - schema_version)
    (service_bound_schema_version ?export_service - export_service ?schema_version - schema_version)
    (service_schema_binding_initiated ?export_service - export_service)
    (service_schema_provisioned ?export_service - export_service)
    (service_schema_verified ?export_service - export_service)
    (notification_template_available ?notification_template - notification_template)
    (service_attached_notification_template ?export_service - export_service ?notification_template - notification_template)
    (delivery_policy_available ?delivery_policy - delivery_policy)
    (service_attached_delivery_policy ?export_service - export_service ?delivery_policy - delivery_policy)
    (compression_option_available ?compression_option - compression_option)
    (service_attached_compression_option ?export_service - export_service ?compression_option - compression_option)
    (encryption_key_available ?encryption_key - encryption_key)
    (service_attached_encryption_key ?export_service - export_service ?encryption_key - encryption_key)
    (retry_token_available ?retry_token - retry_token)
    (resource_has_retry_token ?export_resource - export_resource ?retry_token - retry_token)
    (source_prepared ?primary_data_source - primary_data_source)
    (secondary_prepared ?secondary_data_source - secondary_data_source)
    (service_finalized ?export_service - export_service)
  )
  (:action register_export_resource
    :parameters (?export_resource - export_resource)
    :precondition
      (and
        (not
          (export_resource_registered ?export_resource)
        )
        (not
          (allocated_to_connector ?export_resource)
        )
      )
    :effect (export_resource_registered ?export_resource)
  )
  (:action allocate_connector_to_resource
    :parameters (?export_resource - export_resource ?connector - connector)
    :precondition
      (and
        (export_resource_registered ?export_resource)
        (not
          (resource_has_connector ?export_resource)
        )
        (connector_available ?connector)
      )
    :effect
      (and
        (resource_has_connector ?export_resource)
        (bound_to_connector ?export_resource ?connector)
        (not
          (connector_available ?connector)
        )
      )
  )
  (:action attach_data_batch
    :parameters (?export_resource - export_resource ?data_batch - data_batch)
    :precondition
      (and
        (export_resource_registered ?export_resource)
        (resource_has_connector ?export_resource)
        (data_batch_available ?data_batch)
      )
    :effect
      (and
        (batch_attached ?export_resource ?data_batch)
        (not
          (data_batch_available ?data_batch)
        )
      )
  )
  (:action confirm_batch_attachment
    :parameters (?export_resource - export_resource ?data_batch - data_batch)
    :precondition
      (and
        (export_resource_registered ?export_resource)
        (resource_has_connector ?export_resource)
        (batch_attached ?export_resource ?data_batch)
        (not
          (component_configured ?export_resource)
        )
      )
    :effect (component_configured ?export_resource)
  )
  (:action release_data_batch
    :parameters (?export_resource - export_resource ?data_batch - data_batch)
    :precondition
      (and
        (batch_attached ?export_resource ?data_batch)
      )
    :effect
      (and
        (data_batch_available ?data_batch)
        (not
          (batch_attached ?export_resource ?data_batch)
        )
      )
  )
  (:action attach_credential
    :parameters (?export_resource - export_resource ?credential - credential)
    :precondition
      (and
        (component_configured ?export_resource)
        (credential_available ?credential)
      )
    :effect
      (and
        (credential_bound ?export_resource ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action detach_credential
    :parameters (?export_resource - export_resource ?credential - credential)
    :precondition
      (and
        (credential_bound ?export_resource ?credential)
      )
    :effect
      (and
        (credential_available ?credential)
        (not
          (credential_bound ?export_resource ?credential)
        )
      )
  )
  (:action attach_compression_option
    :parameters (?export_service - export_service ?compression_option - compression_option)
    :precondition
      (and
        (component_configured ?export_service)
        (compression_option_available ?compression_option)
      )
    :effect
      (and
        (service_attached_compression_option ?export_service ?compression_option)
        (not
          (compression_option_available ?compression_option)
        )
      )
  )
  (:action detach_compression_option
    :parameters (?export_service - export_service ?compression_option - compression_option)
    :precondition
      (and
        (service_attached_compression_option ?export_service ?compression_option)
      )
    :effect
      (and
        (compression_option_available ?compression_option)
        (not
          (service_attached_compression_option ?export_service ?compression_option)
        )
      )
  )
  (:action attach_encryption_key
    :parameters (?export_service - export_service ?encryption_key - encryption_key)
    :precondition
      (and
        (component_configured ?export_service)
        (encryption_key_available ?encryption_key)
      )
    :effect
      (and
        (service_attached_encryption_key ?export_service ?encryption_key)
        (not
          (encryption_key_available ?encryption_key)
        )
      )
  )
  (:action detach_encryption_key
    :parameters (?export_service - export_service ?encryption_key - encryption_key)
    :precondition
      (and
        (service_attached_encryption_key ?export_service ?encryption_key)
      )
    :effect
      (and
        (encryption_key_available ?encryption_key)
        (not
          (service_attached_encryption_key ?export_service ?encryption_key)
        )
      )
  )
  (:action reserve_route_for_source
    :parameters (?primary_data_source - primary_data_source ?route_path - route_path ?data_batch - data_batch)
    :precondition
      (and
        (component_configured ?primary_data_source)
        (batch_attached ?primary_data_source ?data_batch)
        (route_assigned_to_source ?primary_data_source ?route_path)
        (not
          (route_reserved ?route_path)
        )
        (not
          (route_transformed ?route_path)
        )
      )
    :effect (route_reserved ?route_path)
  )
  (:action confirm_route_and_mark_source_ready
    :parameters (?primary_data_source - primary_data_source ?route_path - route_path ?credential - credential)
    :precondition
      (and
        (component_configured ?primary_data_source)
        (credential_bound ?primary_data_source ?credential)
        (route_assigned_to_source ?primary_data_source ?route_path)
        (route_reserved ?route_path)
        (not
          (source_prepared ?primary_data_source)
        )
      )
    :effect
      (and
        (source_prepared ?primary_data_source)
        (source_ready_for_package ?primary_data_source)
      )
  )
  (:action apply_transformation_to_source
    :parameters (?primary_data_source - primary_data_source ?route_path - route_path ?transformation - transformation)
    :precondition
      (and
        (component_configured ?primary_data_source)
        (route_assigned_to_source ?primary_data_source ?route_path)
        (transformation_available ?transformation)
        (not
          (source_prepared ?primary_data_source)
        )
      )
    :effect
      (and
        (route_transformed ?route_path)
        (source_prepared ?primary_data_source)
        (assigned_transformation ?primary_data_source ?transformation)
        (not
          (transformation_available ?transformation)
        )
      )
  )
  (:action finalize_transformation_on_source
    :parameters (?primary_data_source - primary_data_source ?route_path - route_path ?data_batch - data_batch ?transformation - transformation)
    :precondition
      (and
        (component_configured ?primary_data_source)
        (batch_attached ?primary_data_source ?data_batch)
        (route_assigned_to_source ?primary_data_source ?route_path)
        (route_transformed ?route_path)
        (assigned_transformation ?primary_data_source ?transformation)
        (not
          (source_ready_for_package ?primary_data_source)
        )
      )
    :effect
      (and
        (route_reserved ?route_path)
        (source_ready_for_package ?primary_data_source)
        (transformation_available ?transformation)
        (not
          (assigned_transformation ?primary_data_source ?transformation)
        )
      )
  )
  (:action reserve_channel_for_secondary
    :parameters (?secondary_data_source - secondary_data_source ?transmission_channel - transmission_channel ?data_batch - data_batch)
    :precondition
      (and
        (component_configured ?secondary_data_source)
        (batch_attached ?secondary_data_source ?data_batch)
        (channel_assigned_to_secondary ?secondary_data_source ?transmission_channel)
        (not
          (channel_ready ?transmission_channel)
        )
        (not
          (channel_transformed ?transmission_channel)
        )
      )
    :effect (channel_ready ?transmission_channel)
  )
  (:action confirm_channel_and_mark_secondary_ready
    :parameters (?secondary_data_source - secondary_data_source ?transmission_channel - transmission_channel ?credential - credential)
    :precondition
      (and
        (component_configured ?secondary_data_source)
        (credential_bound ?secondary_data_source ?credential)
        (channel_assigned_to_secondary ?secondary_data_source ?transmission_channel)
        (channel_ready ?transmission_channel)
        (not
          (secondary_prepared ?secondary_data_source)
        )
      )
    :effect
      (and
        (secondary_prepared ?secondary_data_source)
        (secondary_ready_for_package ?secondary_data_source)
      )
  )
  (:action apply_transformation_to_secondary
    :parameters (?secondary_data_source - secondary_data_source ?transmission_channel - transmission_channel ?transformation - transformation)
    :precondition
      (and
        (component_configured ?secondary_data_source)
        (channel_assigned_to_secondary ?secondary_data_source ?transmission_channel)
        (transformation_available ?transformation)
        (not
          (secondary_prepared ?secondary_data_source)
        )
      )
    :effect
      (and
        (channel_transformed ?transmission_channel)
        (secondary_prepared ?secondary_data_source)
        (assigned_transformation_secondary ?secondary_data_source ?transformation)
        (not
          (transformation_available ?transformation)
        )
      )
  )
  (:action finalize_transformation_on_secondary
    :parameters (?secondary_data_source - secondary_data_source ?transmission_channel - transmission_channel ?data_batch - data_batch ?transformation - transformation)
    :precondition
      (and
        (component_configured ?secondary_data_source)
        (batch_attached ?secondary_data_source ?data_batch)
        (channel_assigned_to_secondary ?secondary_data_source ?transmission_channel)
        (channel_transformed ?transmission_channel)
        (assigned_transformation_secondary ?secondary_data_source ?transformation)
        (not
          (secondary_ready_for_package ?secondary_data_source)
        )
      )
    :effect
      (and
        (channel_ready ?transmission_channel)
        (secondary_ready_for_package ?secondary_data_source)
        (transformation_available ?transformation)
        (not
          (assigned_transformation_secondary ?secondary_data_source ?transformation)
        )
      )
  )
  (:action assemble_package_standard
    :parameters (?primary_data_source - primary_data_source ?secondary_data_source - secondary_data_source ?route_path - route_path ?transmission_channel - transmission_channel ?export_package - export_package)
    :precondition
      (and
        (source_prepared ?primary_data_source)
        (secondary_prepared ?secondary_data_source)
        (route_assigned_to_source ?primary_data_source ?route_path)
        (channel_assigned_to_secondary ?secondary_data_source ?transmission_channel)
        (route_reserved ?route_path)
        (channel_ready ?transmission_channel)
        (source_ready_for_package ?primary_data_source)
        (secondary_ready_for_package ?secondary_data_source)
        (export_package_available ?export_package)
      )
    :effect
      (and
        (export_package_ready ?export_package)
        (package_includes_route ?export_package ?route_path)
        (package_includes_channel ?export_package ?transmission_channel)
        (not
          (export_package_available ?export_package)
        )
      )
  )
  (:action assemble_package_primary_missing
    :parameters (?primary_data_source - primary_data_source ?secondary_data_source - secondary_data_source ?route_path - route_path ?transmission_channel - transmission_channel ?export_package - export_package)
    :precondition
      (and
        (source_prepared ?primary_data_source)
        (secondary_prepared ?secondary_data_source)
        (route_assigned_to_source ?primary_data_source ?route_path)
        (channel_assigned_to_secondary ?secondary_data_source ?transmission_channel)
        (route_transformed ?route_path)
        (channel_ready ?transmission_channel)
        (not
          (source_ready_for_package ?primary_data_source)
        )
        (secondary_ready_for_package ?secondary_data_source)
        (export_package_available ?export_package)
      )
    :effect
      (and
        (export_package_ready ?export_package)
        (package_includes_route ?export_package ?route_path)
        (package_includes_channel ?export_package ?transmission_channel)
        (package_missing_primary_source ?export_package)
        (not
          (export_package_available ?export_package)
        )
      )
  )
  (:action assemble_package_secondary_missing
    :parameters (?primary_data_source - primary_data_source ?secondary_data_source - secondary_data_source ?route_path - route_path ?transmission_channel - transmission_channel ?export_package - export_package)
    :precondition
      (and
        (source_prepared ?primary_data_source)
        (secondary_prepared ?secondary_data_source)
        (route_assigned_to_source ?primary_data_source ?route_path)
        (channel_assigned_to_secondary ?secondary_data_source ?transmission_channel)
        (route_reserved ?route_path)
        (channel_transformed ?transmission_channel)
        (source_ready_for_package ?primary_data_source)
        (not
          (secondary_ready_for_package ?secondary_data_source)
        )
        (export_package_available ?export_package)
      )
    :effect
      (and
        (export_package_ready ?export_package)
        (package_includes_route ?export_package ?route_path)
        (package_includes_channel ?export_package ?transmission_channel)
        (package_missing_secondary_source ?export_package)
        (not
          (export_package_available ?export_package)
        )
      )
  )
  (:action assemble_package_both_sources_missing
    :parameters (?primary_data_source - primary_data_source ?secondary_data_source - secondary_data_source ?route_path - route_path ?transmission_channel - transmission_channel ?export_package - export_package)
    :precondition
      (and
        (source_prepared ?primary_data_source)
        (secondary_prepared ?secondary_data_source)
        (route_assigned_to_source ?primary_data_source ?route_path)
        (channel_assigned_to_secondary ?secondary_data_source ?transmission_channel)
        (route_transformed ?route_path)
        (channel_transformed ?transmission_channel)
        (not
          (source_ready_for_package ?primary_data_source)
        )
        (not
          (secondary_ready_for_package ?secondary_data_source)
        )
        (export_package_available ?export_package)
      )
    :effect
      (and
        (export_package_ready ?export_package)
        (package_includes_route ?export_package ?route_path)
        (package_includes_channel ?export_package ?transmission_channel)
        (package_missing_primary_source ?export_package)
        (package_missing_secondary_source ?export_package)
        (not
          (export_package_available ?export_package)
        )
      )
  )
  (:action validate_export_package
    :parameters (?export_package - export_package ?primary_data_source - primary_data_source ?data_batch - data_batch)
    :precondition
      (and
        (export_package_ready ?export_package)
        (source_prepared ?primary_data_source)
        (batch_attached ?primary_data_source ?data_batch)
        (not
          (package_validated ?export_package)
        )
      )
    :effect (package_validated ?export_package)
  )
  (:action attach_storage_artifact_to_service
    :parameters (?export_service - export_service ?storage_artifact - storage_artifact ?export_package - export_package)
    :precondition
      (and
        (component_configured ?export_service)
        (service_associated_with_package ?export_service ?export_package)
        (service_attached_artifact ?export_service ?storage_artifact)
        (storage_artifact_available ?storage_artifact)
        (export_package_ready ?export_package)
        (package_validated ?export_package)
        (not
          (artifact_attached ?storage_artifact)
        )
      )
    :effect
      (and
        (artifact_attached ?storage_artifact)
        (artifact_in_package ?storage_artifact ?export_package)
        (not
          (storage_artifact_available ?storage_artifact)
        )
      )
  )
  (:action confirm_artifact_attachment
    :parameters (?export_service - export_service ?storage_artifact - storage_artifact ?export_package - export_package ?data_batch - data_batch)
    :precondition
      (and
        (component_configured ?export_service)
        (service_attached_artifact ?export_service ?storage_artifact)
        (artifact_attached ?storage_artifact)
        (artifact_in_package ?storage_artifact ?export_package)
        (batch_attached ?export_service ?data_batch)
        (not
          (package_missing_primary_source ?export_package)
        )
        (not
          (service_artifact_attachment_confirmed ?export_service)
        )
      )
    :effect (service_artifact_attachment_confirmed ?export_service)
  )
  (:action attach_notification_template_to_service
    :parameters (?export_service - export_service ?notification_template - notification_template)
    :precondition
      (and
        (component_configured ?export_service)
        (notification_template_available ?notification_template)
        (not
          (service_notification_template_bound ?export_service)
        )
      )
    :effect
      (and
        (service_notification_template_bound ?export_service)
        (service_attached_notification_template ?export_service ?notification_template)
        (not
          (notification_template_available ?notification_template)
        )
      )
  )
  (:action confirm_notification_binding_for_service
    :parameters (?export_service - export_service ?storage_artifact - storage_artifact ?export_package - export_package ?data_batch - data_batch ?notification_template - notification_template)
    :precondition
      (and
        (component_configured ?export_service)
        (service_attached_artifact ?export_service ?storage_artifact)
        (artifact_attached ?storage_artifact)
        (artifact_in_package ?storage_artifact ?export_package)
        (batch_attached ?export_service ?data_batch)
        (package_missing_primary_source ?export_package)
        (service_notification_template_bound ?export_service)
        (service_attached_notification_template ?export_service ?notification_template)
        (not
          (service_artifact_attachment_confirmed ?export_service)
        )
      )
    :effect
      (and
        (service_artifact_attachment_confirmed ?export_service)
        (service_notification_template_confirmed ?export_service)
      )
  )
  (:action select_compression_option_for_service_primary_variant
    :parameters (?export_service - export_service ?compression_option - compression_option ?credential - credential ?storage_artifact - storage_artifact ?export_package - export_package)
    :precondition
      (and
        (service_artifact_attachment_confirmed ?export_service)
        (service_attached_compression_option ?export_service ?compression_option)
        (credential_bound ?export_service ?credential)
        (service_attached_artifact ?export_service ?storage_artifact)
        (artifact_in_package ?storage_artifact ?export_package)
        (not
          (package_missing_secondary_source ?export_package)
        )
        (not
          (compression_selected_for_service ?export_service)
        )
      )
    :effect (compression_selected_for_service ?export_service)
  )
  (:action select_compression_option_for_service_secondary_variant
    :parameters (?export_service - export_service ?compression_option - compression_option ?credential - credential ?storage_artifact - storage_artifact ?export_package - export_package)
    :precondition
      (and
        (service_artifact_attachment_confirmed ?export_service)
        (service_attached_compression_option ?export_service ?compression_option)
        (credential_bound ?export_service ?credential)
        (service_attached_artifact ?export_service ?storage_artifact)
        (artifact_in_package ?storage_artifact ?export_package)
        (package_missing_secondary_source ?export_package)
        (not
          (compression_selected_for_service ?export_service)
        )
      )
    :effect (compression_selected_for_service ?export_service)
  )
  (:action apply_encryption_key_for_service_no_package_flags
    :parameters (?export_service - export_service ?encryption_key - encryption_key ?storage_artifact - storage_artifact ?export_package - export_package)
    :precondition
      (and
        (compression_selected_for_service ?export_service)
        (service_attached_encryption_key ?export_service ?encryption_key)
        (service_attached_artifact ?export_service ?storage_artifact)
        (artifact_in_package ?storage_artifact ?export_package)
        (not
          (package_missing_primary_source ?export_package)
        )
        (not
          (package_missing_secondary_source ?export_package)
        )
        (not
          (encryption_applied_to_service ?export_service)
        )
      )
    :effect (encryption_applied_to_service ?export_service)
  )
  (:action apply_encryption_key_for_service_with_primary_flag
    :parameters (?export_service - export_service ?encryption_key - encryption_key ?storage_artifact - storage_artifact ?export_package - export_package)
    :precondition
      (and
        (compression_selected_for_service ?export_service)
        (service_attached_encryption_key ?export_service ?encryption_key)
        (service_attached_artifact ?export_service ?storage_artifact)
        (artifact_in_package ?storage_artifact ?export_package)
        (package_missing_primary_source ?export_package)
        (not
          (package_missing_secondary_source ?export_package)
        )
        (not
          (encryption_applied_to_service ?export_service)
        )
      )
    :effect
      (and
        (encryption_applied_to_service ?export_service)
        (policy_confirmed_for_service ?export_service)
      )
  )
  (:action apply_encryption_key_for_service_with_secondary_flag
    :parameters (?export_service - export_service ?encryption_key - encryption_key ?storage_artifact - storage_artifact ?export_package - export_package)
    :precondition
      (and
        (compression_selected_for_service ?export_service)
        (service_attached_encryption_key ?export_service ?encryption_key)
        (service_attached_artifact ?export_service ?storage_artifact)
        (artifact_in_package ?storage_artifact ?export_package)
        (not
          (package_missing_primary_source ?export_package)
        )
        (package_missing_secondary_source ?export_package)
        (not
          (encryption_applied_to_service ?export_service)
        )
      )
    :effect
      (and
        (encryption_applied_to_service ?export_service)
        (policy_confirmed_for_service ?export_service)
      )
  )
  (:action apply_encryption_key_for_service_with_both_flags
    :parameters (?export_service - export_service ?encryption_key - encryption_key ?storage_artifact - storage_artifact ?export_package - export_package)
    :precondition
      (and
        (compression_selected_for_service ?export_service)
        (service_attached_encryption_key ?export_service ?encryption_key)
        (service_attached_artifact ?export_service ?storage_artifact)
        (artifact_in_package ?storage_artifact ?export_package)
        (package_missing_primary_source ?export_package)
        (package_missing_secondary_source ?export_package)
        (not
          (encryption_applied_to_service ?export_service)
        )
      )
    :effect
      (and
        (encryption_applied_to_service ?export_service)
        (policy_confirmed_for_service ?export_service)
      )
  )
  (:action finalize_service_and_mark_ready
    :parameters (?export_service - export_service)
    :precondition
      (and
        (encryption_applied_to_service ?export_service)
        (not
          (policy_confirmed_for_service ?export_service)
        )
        (not
          (service_finalized ?export_service)
        )
      )
    :effect
      (and
        (service_finalized ?export_service)
        (ready_for_delivery ?export_service)
      )
  )
  (:action attach_delivery_policy_to_service
    :parameters (?export_service - export_service ?delivery_policy - delivery_policy)
    :precondition
      (and
        (encryption_applied_to_service ?export_service)
        (policy_confirmed_for_service ?export_service)
        (delivery_policy_available ?delivery_policy)
      )
    :effect
      (and
        (service_attached_delivery_policy ?export_service ?delivery_policy)
        (not
          (delivery_policy_available ?delivery_policy)
        )
      )
  )
  (:action perform_policy_pre_delivery_checks
    :parameters (?export_service - export_service ?primary_data_source - primary_data_source ?secondary_data_source - secondary_data_source ?data_batch - data_batch ?delivery_policy - delivery_policy)
    :precondition
      (and
        (encryption_applied_to_service ?export_service)
        (policy_confirmed_for_service ?export_service)
        (service_attached_delivery_policy ?export_service ?delivery_policy)
        (service_bound_to_primary ?export_service ?primary_data_source)
        (service_bound_to_secondary ?export_service ?secondary_data_source)
        (source_ready_for_package ?primary_data_source)
        (secondary_ready_for_package ?secondary_data_source)
        (batch_attached ?export_service ?data_batch)
        (not
          (pre_delivery_checks_passed ?export_service)
        )
      )
    :effect (pre_delivery_checks_passed ?export_service)
  )
  (:action finalize_service_via_policy_checks
    :parameters (?export_service - export_service)
    :precondition
      (and
        (encryption_applied_to_service ?export_service)
        (pre_delivery_checks_passed ?export_service)
        (not
          (service_finalized ?export_service)
        )
      )
    :effect
      (and
        (service_finalized ?export_service)
        (ready_for_delivery ?export_service)
      )
  )
  (:action bind_schema_version_to_service
    :parameters (?export_service - export_service ?schema_version - schema_version ?data_batch - data_batch)
    :precondition
      (and
        (component_configured ?export_service)
        (batch_attached ?export_service ?data_batch)
        (schema_version_available ?schema_version)
        (service_bound_schema_version ?export_service ?schema_version)
        (not
          (service_schema_binding_initiated ?export_service)
        )
      )
    :effect
      (and
        (service_schema_binding_initiated ?export_service)
        (not
          (schema_version_available ?schema_version)
        )
      )
  )
  (:action provision_schema_for_service
    :parameters (?export_service - export_service ?credential - credential)
    :precondition
      (and
        (service_schema_binding_initiated ?export_service)
        (credential_bound ?export_service ?credential)
        (not
          (service_schema_provisioned ?export_service)
        )
      )
    :effect (service_schema_provisioned ?export_service)
  )
  (:action verify_schema_for_service
    :parameters (?export_service - export_service ?encryption_key - encryption_key)
    :precondition
      (and
        (service_schema_provisioned ?export_service)
        (service_attached_encryption_key ?export_service ?encryption_key)
        (not
          (service_schema_verified ?export_service)
        )
      )
    :effect (service_schema_verified ?export_service)
  )
  (:action finalize_service_with_schema
    :parameters (?export_service - export_service)
    :precondition
      (and
        (service_schema_verified ?export_service)
        (not
          (service_finalized ?export_service)
        )
      )
    :effect
      (and
        (service_finalized ?export_service)
        (ready_for_delivery ?export_service)
      )
  )
  (:action mark_primary_ready_for_delivery
    :parameters (?primary_data_source - primary_data_source ?export_package - export_package)
    :precondition
      (and
        (source_prepared ?primary_data_source)
        (source_ready_for_package ?primary_data_source)
        (export_package_ready ?export_package)
        (package_validated ?export_package)
        (not
          (ready_for_delivery ?primary_data_source)
        )
      )
    :effect (ready_for_delivery ?primary_data_source)
  )
  (:action mark_secondary_ready_for_delivery
    :parameters (?secondary_data_source - secondary_data_source ?export_package - export_package)
    :precondition
      (and
        (secondary_prepared ?secondary_data_source)
        (secondary_ready_for_package ?secondary_data_source)
        (export_package_ready ?export_package)
        (package_validated ?export_package)
        (not
          (ready_for_delivery ?secondary_data_source)
        )
      )
    :effect (ready_for_delivery ?secondary_data_source)
  )
  (:action attach_retry_token_and_schedule_dispatch
    :parameters (?export_resource - export_resource ?retry_token - retry_token ?data_batch - data_batch)
    :precondition
      (and
        (ready_for_delivery ?export_resource)
        (batch_attached ?export_resource ?data_batch)
        (retry_token_available ?retry_token)
        (not
          (dispatch_scheduled ?export_resource)
        )
      )
    :effect
      (and
        (dispatch_scheduled ?export_resource)
        (resource_has_retry_token ?export_resource ?retry_token)
        (not
          (retry_token_available ?retry_token)
        )
      )
  )
  (:action finalize_connector_allocation_for_primary_source
    :parameters (?primary_data_source - primary_data_source ?connector - connector ?retry_token - retry_token)
    :precondition
      (and
        (dispatch_scheduled ?primary_data_source)
        (bound_to_connector ?primary_data_source ?connector)
        (resource_has_retry_token ?primary_data_source ?retry_token)
        (not
          (allocated_to_connector ?primary_data_source)
        )
      )
    :effect
      (and
        (allocated_to_connector ?primary_data_source)
        (connector_available ?connector)
        (retry_token_available ?retry_token)
      )
  )
  (:action finalize_connector_allocation_for_secondary_source
    :parameters (?secondary_data_source - secondary_data_source ?connector - connector ?retry_token - retry_token)
    :precondition
      (and
        (dispatch_scheduled ?secondary_data_source)
        (bound_to_connector ?secondary_data_source ?connector)
        (resource_has_retry_token ?secondary_data_source ?retry_token)
        (not
          (allocated_to_connector ?secondary_data_source)
        )
      )
    :effect
      (and
        (allocated_to_connector ?secondary_data_source)
        (connector_available ?connector)
        (retry_token_available ?retry_token)
      )
  )
  (:action finalize_connector_allocation_for_service
    :parameters (?export_service - export_service ?connector - connector ?retry_token - retry_token)
    :precondition
      (and
        (dispatch_scheduled ?export_service)
        (bound_to_connector ?export_service ?connector)
        (resource_has_retry_token ?export_service ?retry_token)
        (not
          (allocated_to_connector ?export_service)
        )
      )
    :effect
      (and
        (allocated_to_connector ?export_service)
        (connector_available ?connector)
        (retry_token_available ?retry_token)
      )
  )
)

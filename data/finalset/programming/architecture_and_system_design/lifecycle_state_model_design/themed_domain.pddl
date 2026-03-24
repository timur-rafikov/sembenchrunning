(define (domain lifecycle_state_model_design)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_class - object asset_class - object slot_class - object element_root_class - object lifecycle_element - element_root_class resource_token - resource_class change_request - resource_class operator_role - resource_class compliance_profile - resource_class requirement_profile - resource_class approval_artifact - resource_class special_capability - resource_class audit_credential - resource_class configuration_unit - asset_class asset_version - asset_class stakeholder_credential - asset_class environment_slot - slot_class deployment_slot - slot_class deployment_package - slot_class runtime_role_class - lifecycle_element design_artifact_class - lifecycle_element orchestrator_instance - runtime_role_class worker_instance - runtime_role_class design_artifact - design_artifact_class)
  (:predicates
    (element_registered ?lifecycle_element - lifecycle_element)
    (element_validated ?lifecycle_element - lifecycle_element)
    (element_staged ?lifecycle_element - lifecycle_element)
    (element_released ?lifecycle_element - lifecycle_element)
    (ready_for_release ?lifecycle_element - lifecycle_element)
    (release_authorized ?lifecycle_element - lifecycle_element)
    (resource_token_available ?resource_token - resource_token)
    (element_resource_assigned ?lifecycle_element - lifecycle_element ?resource_token - resource_token)
    (change_request_available ?change_request - change_request)
    (element_change_request_attached ?lifecycle_element - lifecycle_element ?change_request - change_request)
    (operator_role_available ?operator_role - operator_role)
    (element_operator_assigned ?lifecycle_element - lifecycle_element ?operator_role - operator_role)
    (configuration_unit_available ?configuration_unit - configuration_unit)
    (orchestrator_configuration_attached ?orchestrator_instance - orchestrator_instance ?configuration_unit - configuration_unit)
    (worker_configuration_attached ?worker_instance - worker_instance ?configuration_unit - configuration_unit)
    (orchestrator_environment_slot_assigned ?orchestrator_instance - orchestrator_instance ?environment_slot - environment_slot)
    (environment_slot_reserved ?environment_slot - environment_slot)
    (environment_slot_configured ?environment_slot - environment_slot)
    (orchestrator_confirmed ?orchestrator_instance - orchestrator_instance)
    (worker_deployment_slot_assigned ?worker_instance - worker_instance ?deployment_slot - deployment_slot)
    (deployment_slot_reserved ?deployment_slot - deployment_slot)
    (deployment_slot_configured ?deployment_slot - deployment_slot)
    (worker_confirmed ?worker_instance - worker_instance)
    (deployment_package_available ?deployment_package - deployment_package)
    (deployment_package_assembled ?deployment_package - deployment_package)
    (package_mapped_to_environment_slot ?deployment_package - deployment_package ?environment_slot - environment_slot)
    (package_mapped_to_deployment_slot ?deployment_package - deployment_package ?deployment_slot - deployment_slot)
    (package_signature_orchestrator ?deployment_package - deployment_package)
    (package_signature_worker ?deployment_package - deployment_package)
    (package_finalized ?deployment_package - deployment_package)
    (artifact_assigned_orchestrator ?design_artifact - design_artifact ?orchestrator_instance - orchestrator_instance)
    (artifact_assigned_worker ?design_artifact - design_artifact ?worker_instance - worker_instance)
    (artifact_packaged_in ?design_artifact - design_artifact ?deployment_package - deployment_package)
    (asset_version_available ?asset_version - asset_version)
    (artifact_has_asset_version ?design_artifact - design_artifact ?asset_version - asset_version)
    (asset_version_provisioned ?asset_version - asset_version)
    (asset_version_bound_to_package ?asset_version - asset_version ?deployment_package - deployment_package)
    (artifact_provisioned ?design_artifact - design_artifact)
    (artifact_provision_step1_complete ?design_artifact - design_artifact)
    (artifact_provision_step2_complete ?design_artifact - design_artifact)
    (artifact_compliance_applied ?design_artifact - design_artifact)
    (artifact_compliance_verified ?design_artifact - design_artifact)
    (artifact_capability_verified ?design_artifact - design_artifact)
    (artifact_ready_for_finalization ?design_artifact - design_artifact)
    (stakeholder_credential_available ?stakeholder_credential - stakeholder_credential)
    (artifact_stakeholder_bound ?design_artifact - design_artifact ?stakeholder_credential - stakeholder_credential)
    (artifact_stakeholder_approved ?design_artifact - design_artifact)
    (artifact_operator_verified ?design_artifact - design_artifact)
    (artifact_audit_verified ?design_artifact - design_artifact)
    (compliance_profile_available ?compliance_profile - compliance_profile)
    (artifact_compliance_profile_attached ?design_artifact - design_artifact ?compliance_profile - compliance_profile)
    (requirement_profile_available ?requirement_profile - requirement_profile)
    (artifact_requirement_profile_attached ?design_artifact - design_artifact ?requirement_profile - requirement_profile)
    (special_capability_available ?special_capability - special_capability)
    (artifact_special_capability_attached ?design_artifact - design_artifact ?special_capability - special_capability)
    (audit_credential_available ?audit_credential - audit_credential)
    (artifact_audit_credential_attached ?design_artifact - design_artifact ?audit_credential - audit_credential)
    (approval_artifact_available ?approval_artifact - approval_artifact)
    (element_approval_bound ?lifecycle_element - lifecycle_element ?approval_artifact - approval_artifact)
    (orchestrator_prepared ?orchestrator_instance - orchestrator_instance)
    (worker_prepared ?worker_instance - worker_instance)
    (artifact_finalized ?design_artifact - design_artifact)
  )
  (:action register_element
    :parameters (?lifecycle_element - lifecycle_element)
    :precondition
      (and
        (not
          (element_registered ?lifecycle_element)
        )
        (not
          (element_released ?lifecycle_element)
        )
      )
    :effect (element_registered ?lifecycle_element)
  )
  (:action stage_element_with_resource
    :parameters (?lifecycle_element - lifecycle_element ?resource_token - resource_token)
    :precondition
      (and
        (element_registered ?lifecycle_element)
        (not
          (element_staged ?lifecycle_element)
        )
        (resource_token_available ?resource_token)
      )
    :effect
      (and
        (element_staged ?lifecycle_element)
        (element_resource_assigned ?lifecycle_element ?resource_token)
        (not
          (resource_token_available ?resource_token)
        )
      )
  )
  (:action attach_change_request
    :parameters (?lifecycle_element - lifecycle_element ?change_request - change_request)
    :precondition
      (and
        (element_registered ?lifecycle_element)
        (element_staged ?lifecycle_element)
        (change_request_available ?change_request)
      )
    :effect
      (and
        (element_change_request_attached ?lifecycle_element ?change_request)
        (not
          (change_request_available ?change_request)
        )
      )
  )
  (:action validate_element
    :parameters (?lifecycle_element - lifecycle_element ?change_request - change_request)
    :precondition
      (and
        (element_registered ?lifecycle_element)
        (element_staged ?lifecycle_element)
        (element_change_request_attached ?lifecycle_element ?change_request)
        (not
          (element_validated ?lifecycle_element)
        )
      )
    :effect (element_validated ?lifecycle_element)
  )
  (:action detach_change_request
    :parameters (?lifecycle_element - lifecycle_element ?change_request - change_request)
    :precondition
      (and
        (element_change_request_attached ?lifecycle_element ?change_request)
      )
    :effect
      (and
        (change_request_available ?change_request)
        (not
          (element_change_request_attached ?lifecycle_element ?change_request)
        )
      )
  )
  (:action assign_operator_role
    :parameters (?lifecycle_element - lifecycle_element ?operator_role - operator_role)
    :precondition
      (and
        (element_validated ?lifecycle_element)
        (operator_role_available ?operator_role)
      )
    :effect
      (and
        (element_operator_assigned ?lifecycle_element ?operator_role)
        (not
          (operator_role_available ?operator_role)
        )
      )
  )
  (:action unassign_operator_role
    :parameters (?lifecycle_element - lifecycle_element ?operator_role - operator_role)
    :precondition
      (and
        (element_operator_assigned ?lifecycle_element ?operator_role)
      )
    :effect
      (and
        (operator_role_available ?operator_role)
        (not
          (element_operator_assigned ?lifecycle_element ?operator_role)
        )
      )
  )
  (:action bind_special_capability
    :parameters (?design_artifact - design_artifact ?special_capability - special_capability)
    :precondition
      (and
        (element_validated ?design_artifact)
        (special_capability_available ?special_capability)
      )
    :effect
      (and
        (artifact_special_capability_attached ?design_artifact ?special_capability)
        (not
          (special_capability_available ?special_capability)
        )
      )
  )
  (:action unbind_special_capability
    :parameters (?design_artifact - design_artifact ?special_capability - special_capability)
    :precondition
      (and
        (artifact_special_capability_attached ?design_artifact ?special_capability)
      )
    :effect
      (and
        (special_capability_available ?special_capability)
        (not
          (artifact_special_capability_attached ?design_artifact ?special_capability)
        )
      )
  )
  (:action bind_audit_credential
    :parameters (?design_artifact - design_artifact ?audit_credential - audit_credential)
    :precondition
      (and
        (element_validated ?design_artifact)
        (audit_credential_available ?audit_credential)
      )
    :effect
      (and
        (artifact_audit_credential_attached ?design_artifact ?audit_credential)
        (not
          (audit_credential_available ?audit_credential)
        )
      )
  )
  (:action unbind_audit_credential
    :parameters (?design_artifact - design_artifact ?audit_credential - audit_credential)
    :precondition
      (and
        (artifact_audit_credential_attached ?design_artifact ?audit_credential)
      )
    :effect
      (and
        (audit_credential_available ?audit_credential)
        (not
          (artifact_audit_credential_attached ?design_artifact ?audit_credential)
        )
      )
  )
  (:action claim_environment_slot_by_orchestrator
    :parameters (?orchestrator_instance - orchestrator_instance ?environment_slot - environment_slot ?change_request - change_request)
    :precondition
      (and
        (element_validated ?orchestrator_instance)
        (element_change_request_attached ?orchestrator_instance ?change_request)
        (orchestrator_environment_slot_assigned ?orchestrator_instance ?environment_slot)
        (not
          (environment_slot_reserved ?environment_slot)
        )
        (not
          (environment_slot_configured ?environment_slot)
        )
      )
    :effect (environment_slot_reserved ?environment_slot)
  )
  (:action confirm_slot_with_operator_by_orchestrator
    :parameters (?orchestrator_instance - orchestrator_instance ?environment_slot - environment_slot ?operator_role - operator_role)
    :precondition
      (and
        (element_validated ?orchestrator_instance)
        (element_operator_assigned ?orchestrator_instance ?operator_role)
        (orchestrator_environment_slot_assigned ?orchestrator_instance ?environment_slot)
        (environment_slot_reserved ?environment_slot)
        (not
          (orchestrator_prepared ?orchestrator_instance)
        )
      )
    :effect
      (and
        (orchestrator_prepared ?orchestrator_instance)
        (orchestrator_confirmed ?orchestrator_instance)
      )
  )
  (:action apply_configuration_unit_to_slot
    :parameters (?orchestrator_instance - orchestrator_instance ?environment_slot - environment_slot ?configuration_unit - configuration_unit)
    :precondition
      (and
        (element_validated ?orchestrator_instance)
        (orchestrator_environment_slot_assigned ?orchestrator_instance ?environment_slot)
        (configuration_unit_available ?configuration_unit)
        (not
          (orchestrator_prepared ?orchestrator_instance)
        )
      )
    :effect
      (and
        (environment_slot_configured ?environment_slot)
        (orchestrator_prepared ?orchestrator_instance)
        (orchestrator_configuration_attached ?orchestrator_instance ?configuration_unit)
        (not
          (configuration_unit_available ?configuration_unit)
        )
      )
  )
  (:action finalize_orchestrator_slot_claim
    :parameters (?orchestrator_instance - orchestrator_instance ?environment_slot - environment_slot ?change_request - change_request ?configuration_unit - configuration_unit)
    :precondition
      (and
        (element_validated ?orchestrator_instance)
        (element_change_request_attached ?orchestrator_instance ?change_request)
        (orchestrator_environment_slot_assigned ?orchestrator_instance ?environment_slot)
        (environment_slot_configured ?environment_slot)
        (orchestrator_configuration_attached ?orchestrator_instance ?configuration_unit)
        (not
          (orchestrator_confirmed ?orchestrator_instance)
        )
      )
    :effect
      (and
        (environment_slot_reserved ?environment_slot)
        (orchestrator_confirmed ?orchestrator_instance)
        (configuration_unit_available ?configuration_unit)
        (not
          (orchestrator_configuration_attached ?orchestrator_instance ?configuration_unit)
        )
      )
  )
  (:action claim_deployment_slot_by_worker
    :parameters (?worker_instance - worker_instance ?deployment_slot - deployment_slot ?change_request - change_request)
    :precondition
      (and
        (element_validated ?worker_instance)
        (element_change_request_attached ?worker_instance ?change_request)
        (worker_deployment_slot_assigned ?worker_instance ?deployment_slot)
        (not
          (deployment_slot_reserved ?deployment_slot)
        )
        (not
          (deployment_slot_configured ?deployment_slot)
        )
      )
    :effect (deployment_slot_reserved ?deployment_slot)
  )
  (:action confirm_deployment_slot_with_operator
    :parameters (?worker_instance - worker_instance ?deployment_slot - deployment_slot ?operator_role - operator_role)
    :precondition
      (and
        (element_validated ?worker_instance)
        (element_operator_assigned ?worker_instance ?operator_role)
        (worker_deployment_slot_assigned ?worker_instance ?deployment_slot)
        (deployment_slot_reserved ?deployment_slot)
        (not
          (worker_prepared ?worker_instance)
        )
      )
    :effect
      (and
        (worker_prepared ?worker_instance)
        (worker_confirmed ?worker_instance)
      )
  )
  (:action worker_configure_deployment_slot
    :parameters (?worker_instance - worker_instance ?deployment_slot - deployment_slot ?configuration_unit - configuration_unit)
    :precondition
      (and
        (element_validated ?worker_instance)
        (worker_deployment_slot_assigned ?worker_instance ?deployment_slot)
        (configuration_unit_available ?configuration_unit)
        (not
          (worker_prepared ?worker_instance)
        )
      )
    :effect
      (and
        (deployment_slot_configured ?deployment_slot)
        (worker_prepared ?worker_instance)
        (worker_configuration_attached ?worker_instance ?configuration_unit)
        (not
          (configuration_unit_available ?configuration_unit)
        )
      )
  )
  (:action finalize_worker_slot_claim
    :parameters (?worker_instance - worker_instance ?deployment_slot - deployment_slot ?change_request - change_request ?configuration_unit - configuration_unit)
    :precondition
      (and
        (element_validated ?worker_instance)
        (element_change_request_attached ?worker_instance ?change_request)
        (worker_deployment_slot_assigned ?worker_instance ?deployment_slot)
        (deployment_slot_configured ?deployment_slot)
        (worker_configuration_attached ?worker_instance ?configuration_unit)
        (not
          (worker_confirmed ?worker_instance)
        )
      )
    :effect
      (and
        (deployment_slot_reserved ?deployment_slot)
        (worker_confirmed ?worker_instance)
        (configuration_unit_available ?configuration_unit)
        (not
          (worker_configuration_attached ?worker_instance ?configuration_unit)
        )
      )
  )
  (:action assemble_deployment_package
    :parameters (?orchestrator_instance - orchestrator_instance ?worker_instance - worker_instance ?environment_slot - environment_slot ?deployment_slot - deployment_slot ?deployment_package - deployment_package)
    :precondition
      (and
        (orchestrator_prepared ?orchestrator_instance)
        (worker_prepared ?worker_instance)
        (orchestrator_environment_slot_assigned ?orchestrator_instance ?environment_slot)
        (worker_deployment_slot_assigned ?worker_instance ?deployment_slot)
        (environment_slot_reserved ?environment_slot)
        (deployment_slot_reserved ?deployment_slot)
        (orchestrator_confirmed ?orchestrator_instance)
        (worker_confirmed ?worker_instance)
        (deployment_package_available ?deployment_package)
      )
    :effect
      (and
        (deployment_package_assembled ?deployment_package)
        (package_mapped_to_environment_slot ?deployment_package ?environment_slot)
        (package_mapped_to_deployment_slot ?deployment_package ?deployment_slot)
        (not
          (deployment_package_available ?deployment_package)
        )
      )
  )
  (:action orchestrator_sign_package
    :parameters (?orchestrator_instance - orchestrator_instance ?worker_instance - worker_instance ?environment_slot - environment_slot ?deployment_slot - deployment_slot ?deployment_package - deployment_package)
    :precondition
      (and
        (orchestrator_prepared ?orchestrator_instance)
        (worker_prepared ?worker_instance)
        (orchestrator_environment_slot_assigned ?orchestrator_instance ?environment_slot)
        (worker_deployment_slot_assigned ?worker_instance ?deployment_slot)
        (environment_slot_configured ?environment_slot)
        (deployment_slot_reserved ?deployment_slot)
        (not
          (orchestrator_confirmed ?orchestrator_instance)
        )
        (worker_confirmed ?worker_instance)
        (deployment_package_available ?deployment_package)
      )
    :effect
      (and
        (deployment_package_assembled ?deployment_package)
        (package_mapped_to_environment_slot ?deployment_package ?environment_slot)
        (package_mapped_to_deployment_slot ?deployment_package ?deployment_slot)
        (package_signature_orchestrator ?deployment_package)
        (not
          (deployment_package_available ?deployment_package)
        )
      )
  )
  (:action worker_sign_package
    :parameters (?orchestrator_instance - orchestrator_instance ?worker_instance - worker_instance ?environment_slot - environment_slot ?deployment_slot - deployment_slot ?deployment_package - deployment_package)
    :precondition
      (and
        (orchestrator_prepared ?orchestrator_instance)
        (worker_prepared ?worker_instance)
        (orchestrator_environment_slot_assigned ?orchestrator_instance ?environment_slot)
        (worker_deployment_slot_assigned ?worker_instance ?deployment_slot)
        (environment_slot_reserved ?environment_slot)
        (deployment_slot_configured ?deployment_slot)
        (orchestrator_confirmed ?orchestrator_instance)
        (not
          (worker_confirmed ?worker_instance)
        )
        (deployment_package_available ?deployment_package)
      )
    :effect
      (and
        (deployment_package_assembled ?deployment_package)
        (package_mapped_to_environment_slot ?deployment_package ?environment_slot)
        (package_mapped_to_deployment_slot ?deployment_package ?deployment_slot)
        (package_signature_worker ?deployment_package)
        (not
          (deployment_package_available ?deployment_package)
        )
      )
  )
  (:action finalize_package_signatures
    :parameters (?orchestrator_instance - orchestrator_instance ?worker_instance - worker_instance ?environment_slot - environment_slot ?deployment_slot - deployment_slot ?deployment_package - deployment_package)
    :precondition
      (and
        (orchestrator_prepared ?orchestrator_instance)
        (worker_prepared ?worker_instance)
        (orchestrator_environment_slot_assigned ?orchestrator_instance ?environment_slot)
        (worker_deployment_slot_assigned ?worker_instance ?deployment_slot)
        (environment_slot_configured ?environment_slot)
        (deployment_slot_configured ?deployment_slot)
        (not
          (orchestrator_confirmed ?orchestrator_instance)
        )
        (not
          (worker_confirmed ?worker_instance)
        )
        (deployment_package_available ?deployment_package)
      )
    :effect
      (and
        (deployment_package_assembled ?deployment_package)
        (package_mapped_to_environment_slot ?deployment_package ?environment_slot)
        (package_mapped_to_deployment_slot ?deployment_package ?deployment_slot)
        (package_signature_orchestrator ?deployment_package)
        (package_signature_worker ?deployment_package)
        (not
          (deployment_package_available ?deployment_package)
        )
      )
  )
  (:action finalize_deployment_package
    :parameters (?deployment_package - deployment_package ?orchestrator_instance - orchestrator_instance ?change_request - change_request)
    :precondition
      (and
        (deployment_package_assembled ?deployment_package)
        (orchestrator_prepared ?orchestrator_instance)
        (element_change_request_attached ?orchestrator_instance ?change_request)
        (not
          (package_finalized ?deployment_package)
        )
      )
    :effect (package_finalized ?deployment_package)
  )
  (:action provision_asset_version
    :parameters (?design_artifact - design_artifact ?asset_version - asset_version ?deployment_package - deployment_package)
    :precondition
      (and
        (element_validated ?design_artifact)
        (artifact_packaged_in ?design_artifact ?deployment_package)
        (artifact_has_asset_version ?design_artifact ?asset_version)
        (asset_version_available ?asset_version)
        (deployment_package_assembled ?deployment_package)
        (package_finalized ?deployment_package)
        (not
          (asset_version_provisioned ?asset_version)
        )
      )
    :effect
      (and
        (asset_version_provisioned ?asset_version)
        (asset_version_bound_to_package ?asset_version ?deployment_package)
        (not
          (asset_version_available ?asset_version)
        )
      )
  )
  (:action activate_artifact_with_version
    :parameters (?design_artifact - design_artifact ?asset_version - asset_version ?deployment_package - deployment_package ?change_request - change_request)
    :precondition
      (and
        (element_validated ?design_artifact)
        (artifact_has_asset_version ?design_artifact ?asset_version)
        (asset_version_provisioned ?asset_version)
        (asset_version_bound_to_package ?asset_version ?deployment_package)
        (element_change_request_attached ?design_artifact ?change_request)
        (not
          (package_signature_orchestrator ?deployment_package)
        )
        (not
          (artifact_provisioned ?design_artifact)
        )
      )
    :effect (artifact_provisioned ?design_artifact)
  )
  (:action attach_compliance_profile_to_artifact
    :parameters (?design_artifact - design_artifact ?compliance_profile - compliance_profile)
    :precondition
      (and
        (element_validated ?design_artifact)
        (compliance_profile_available ?compliance_profile)
        (not
          (artifact_compliance_applied ?design_artifact)
        )
      )
    :effect
      (and
        (artifact_compliance_applied ?design_artifact)
        (artifact_compliance_profile_attached ?design_artifact ?compliance_profile)
        (not
          (compliance_profile_available ?compliance_profile)
        )
      )
  )
  (:action apply_compliance_and_prepare_artifact
    :parameters (?design_artifact - design_artifact ?asset_version - asset_version ?deployment_package - deployment_package ?change_request - change_request ?compliance_profile - compliance_profile)
    :precondition
      (and
        (element_validated ?design_artifact)
        (artifact_has_asset_version ?design_artifact ?asset_version)
        (asset_version_provisioned ?asset_version)
        (asset_version_bound_to_package ?asset_version ?deployment_package)
        (element_change_request_attached ?design_artifact ?change_request)
        (package_signature_orchestrator ?deployment_package)
        (artifact_compliance_applied ?design_artifact)
        (artifact_compliance_profile_attached ?design_artifact ?compliance_profile)
        (not
          (artifact_provisioned ?design_artifact)
        )
      )
    :effect
      (and
        (artifact_provisioned ?design_artifact)
        (artifact_compliance_verified ?design_artifact)
      )
  )
  (:action start_capability_provisioning_path
    :parameters (?design_artifact - design_artifact ?special_capability - special_capability ?operator_role - operator_role ?asset_version - asset_version ?deployment_package - deployment_package)
    :precondition
      (and
        (artifact_provisioned ?design_artifact)
        (artifact_special_capability_attached ?design_artifact ?special_capability)
        (element_operator_assigned ?design_artifact ?operator_role)
        (artifact_has_asset_version ?design_artifact ?asset_version)
        (asset_version_bound_to_package ?asset_version ?deployment_package)
        (not
          (package_signature_worker ?deployment_package)
        )
        (not
          (artifact_provision_step1_complete ?design_artifact)
        )
      )
    :effect (artifact_provision_step1_complete ?design_artifact)
  )
  (:action continue_capability_provisioning_path
    :parameters (?design_artifact - design_artifact ?special_capability - special_capability ?operator_role - operator_role ?asset_version - asset_version ?deployment_package - deployment_package)
    :precondition
      (and
        (artifact_provisioned ?design_artifact)
        (artifact_special_capability_attached ?design_artifact ?special_capability)
        (element_operator_assigned ?design_artifact ?operator_role)
        (artifact_has_asset_version ?design_artifact ?asset_version)
        (asset_version_bound_to_package ?asset_version ?deployment_package)
        (package_signature_worker ?deployment_package)
        (not
          (artifact_provision_step1_complete ?design_artifact)
        )
      )
    :effect (artifact_provision_step1_complete ?design_artifact)
  )
  (:action apply_audit_verification_step1
    :parameters (?design_artifact - design_artifact ?audit_credential - audit_credential ?asset_version - asset_version ?deployment_package - deployment_package)
    :precondition
      (and
        (artifact_provision_step1_complete ?design_artifact)
        (artifact_audit_credential_attached ?design_artifact ?audit_credential)
        (artifact_has_asset_version ?design_artifact ?asset_version)
        (asset_version_bound_to_package ?asset_version ?deployment_package)
        (not
          (package_signature_orchestrator ?deployment_package)
        )
        (not
          (package_signature_worker ?deployment_package)
        )
        (not
          (artifact_provision_step2_complete ?design_artifact)
        )
      )
    :effect (artifact_provision_step2_complete ?design_artifact)
  )
  (:action apply_audit_verification_step2
    :parameters (?design_artifact - design_artifact ?audit_credential - audit_credential ?asset_version - asset_version ?deployment_package - deployment_package)
    :precondition
      (and
        (artifact_provision_step1_complete ?design_artifact)
        (artifact_audit_credential_attached ?design_artifact ?audit_credential)
        (artifact_has_asset_version ?design_artifact ?asset_version)
        (asset_version_bound_to_package ?asset_version ?deployment_package)
        (package_signature_orchestrator ?deployment_package)
        (not
          (package_signature_worker ?deployment_package)
        )
        (not
          (artifact_provision_step2_complete ?design_artifact)
        )
      )
    :effect
      (and
        (artifact_provision_step2_complete ?design_artifact)
        (artifact_capability_verified ?design_artifact)
      )
  )
  (:action apply_audit_verification_step3
    :parameters (?design_artifact - design_artifact ?audit_credential - audit_credential ?asset_version - asset_version ?deployment_package - deployment_package)
    :precondition
      (and
        (artifact_provision_step1_complete ?design_artifact)
        (artifact_audit_credential_attached ?design_artifact ?audit_credential)
        (artifact_has_asset_version ?design_artifact ?asset_version)
        (asset_version_bound_to_package ?asset_version ?deployment_package)
        (not
          (package_signature_orchestrator ?deployment_package)
        )
        (package_signature_worker ?deployment_package)
        (not
          (artifact_provision_step2_complete ?design_artifact)
        )
      )
    :effect
      (and
        (artifact_provision_step2_complete ?design_artifact)
        (artifact_capability_verified ?design_artifact)
      )
  )
  (:action apply_audit_verification_step4
    :parameters (?design_artifact - design_artifact ?audit_credential - audit_credential ?asset_version - asset_version ?deployment_package - deployment_package)
    :precondition
      (and
        (artifact_provision_step1_complete ?design_artifact)
        (artifact_audit_credential_attached ?design_artifact ?audit_credential)
        (artifact_has_asset_version ?design_artifact ?asset_version)
        (asset_version_bound_to_package ?asset_version ?deployment_package)
        (package_signature_orchestrator ?deployment_package)
        (package_signature_worker ?deployment_package)
        (not
          (artifact_provision_step2_complete ?design_artifact)
        )
      )
    :effect
      (and
        (artifact_provision_step2_complete ?design_artifact)
        (artifact_capability_verified ?design_artifact)
      )
  )
  (:action finalize_design_artifact_provisioning
    :parameters (?design_artifact - design_artifact)
    :precondition
      (and
        (artifact_provision_step2_complete ?design_artifact)
        (not
          (artifact_capability_verified ?design_artifact)
        )
        (not
          (artifact_finalized ?design_artifact)
        )
      )
    :effect
      (and
        (artifact_finalized ?design_artifact)
        (ready_for_release ?design_artifact)
      )
  )
  (:action attach_requirement_profile_to_artifact
    :parameters (?design_artifact - design_artifact ?requirement_profile - requirement_profile)
    :precondition
      (and
        (artifact_provision_step2_complete ?design_artifact)
        (artifact_capability_verified ?design_artifact)
        (requirement_profile_available ?requirement_profile)
      )
    :effect
      (and
        (artifact_requirement_profile_attached ?design_artifact ?requirement_profile)
        (not
          (requirement_profile_available ?requirement_profile)
        )
      )
  )
  (:action authorize_artifact_for_release
    :parameters (?design_artifact - design_artifact ?orchestrator_instance - orchestrator_instance ?worker_instance - worker_instance ?change_request - change_request ?requirement_profile - requirement_profile)
    :precondition
      (and
        (artifact_provision_step2_complete ?design_artifact)
        (artifact_capability_verified ?design_artifact)
        (artifact_requirement_profile_attached ?design_artifact ?requirement_profile)
        (artifact_assigned_orchestrator ?design_artifact ?orchestrator_instance)
        (artifact_assigned_worker ?design_artifact ?worker_instance)
        (orchestrator_confirmed ?orchestrator_instance)
        (worker_confirmed ?worker_instance)
        (element_change_request_attached ?design_artifact ?change_request)
        (not
          (artifact_ready_for_finalization ?design_artifact)
        )
      )
    :effect (artifact_ready_for_finalization ?design_artifact)
  )
  (:action finalize_artifact_final_readiness
    :parameters (?design_artifact - design_artifact)
    :precondition
      (and
        (artifact_provision_step2_complete ?design_artifact)
        (artifact_ready_for_finalization ?design_artifact)
        (not
          (artifact_finalized ?design_artifact)
        )
      )
    :effect
      (and
        (artifact_finalized ?design_artifact)
        (ready_for_release ?design_artifact)
      )
  )
  (:action apply_stakeholder_credential_to_artifact
    :parameters (?design_artifact - design_artifact ?stakeholder_credential - stakeholder_credential ?change_request - change_request)
    :precondition
      (and
        (element_validated ?design_artifact)
        (element_change_request_attached ?design_artifact ?change_request)
        (stakeholder_credential_available ?stakeholder_credential)
        (artifact_stakeholder_bound ?design_artifact ?stakeholder_credential)
        (not
          (artifact_stakeholder_approved ?design_artifact)
        )
      )
    :effect
      (and
        (artifact_stakeholder_approved ?design_artifact)
        (not
          (stakeholder_credential_available ?stakeholder_credential)
        )
      )
  )
  (:action confirm_operator_verification_on_artifact
    :parameters (?design_artifact - design_artifact ?operator_role - operator_role)
    :precondition
      (and
        (artifact_stakeholder_approved ?design_artifact)
        (element_operator_assigned ?design_artifact ?operator_role)
        (not
          (artifact_operator_verified ?design_artifact)
        )
      )
    :effect (artifact_operator_verified ?design_artifact)
  )
  (:action apply_audit_verification_on_artifact
    :parameters (?design_artifact - design_artifact ?audit_credential - audit_credential)
    :precondition
      (and
        (artifact_operator_verified ?design_artifact)
        (artifact_audit_credential_attached ?design_artifact ?audit_credential)
        (not
          (artifact_audit_verified ?design_artifact)
        )
      )
    :effect (artifact_audit_verified ?design_artifact)
  )
  (:action finalize_artifact_after_audit
    :parameters (?design_artifact - design_artifact)
    :precondition
      (and
        (artifact_audit_verified ?design_artifact)
        (not
          (artifact_finalized ?design_artifact)
        )
      )
    :effect
      (and
        (artifact_finalized ?design_artifact)
        (ready_for_release ?design_artifact)
      )
  )
  (:action finalize_orchestrator_release_state
    :parameters (?orchestrator_instance - orchestrator_instance ?deployment_package - deployment_package)
    :precondition
      (and
        (orchestrator_prepared ?orchestrator_instance)
        (orchestrator_confirmed ?orchestrator_instance)
        (deployment_package_assembled ?deployment_package)
        (package_finalized ?deployment_package)
        (not
          (ready_for_release ?orchestrator_instance)
        )
      )
    :effect (ready_for_release ?orchestrator_instance)
  )
  (:action finalize_worker_release_state
    :parameters (?worker_instance - worker_instance ?deployment_package - deployment_package)
    :precondition
      (and
        (worker_prepared ?worker_instance)
        (worker_confirmed ?worker_instance)
        (deployment_package_assembled ?deployment_package)
        (package_finalized ?deployment_package)
        (not
          (ready_for_release ?worker_instance)
        )
      )
    :effect (ready_for_release ?worker_instance)
  )
  (:action authorize_element_for_release
    :parameters (?lifecycle_element - lifecycle_element ?approval_artifact - approval_artifact ?change_request - change_request)
    :precondition
      (and
        (ready_for_release ?lifecycle_element)
        (element_change_request_attached ?lifecycle_element ?change_request)
        (approval_artifact_available ?approval_artifact)
        (not
          (release_authorized ?lifecycle_element)
        )
      )
    :effect
      (and
        (release_authorized ?lifecycle_element)
        (element_approval_bound ?lifecycle_element ?approval_artifact)
        (not
          (approval_artifact_available ?approval_artifact)
        )
      )
  )
  (:action finalize_orchestrator_release_and_reissue_tokens
    :parameters (?orchestrator_instance - orchestrator_instance ?resource_token - resource_token ?approval_artifact - approval_artifact)
    :precondition
      (and
        (release_authorized ?orchestrator_instance)
        (element_resource_assigned ?orchestrator_instance ?resource_token)
        (element_approval_bound ?orchestrator_instance ?approval_artifact)
        (not
          (element_released ?orchestrator_instance)
        )
      )
    :effect
      (and
        (element_released ?orchestrator_instance)
        (resource_token_available ?resource_token)
        (approval_artifact_available ?approval_artifact)
      )
  )
  (:action finalize_worker_release_and_reissue_tokens
    :parameters (?worker_instance - worker_instance ?resource_token - resource_token ?approval_artifact - approval_artifact)
    :precondition
      (and
        (release_authorized ?worker_instance)
        (element_resource_assigned ?worker_instance ?resource_token)
        (element_approval_bound ?worker_instance ?approval_artifact)
        (not
          (element_released ?worker_instance)
        )
      )
    :effect
      (and
        (element_released ?worker_instance)
        (resource_token_available ?resource_token)
        (approval_artifact_available ?approval_artifact)
      )
  )
  (:action finalize_artifact_release_and_reissue_tokens
    :parameters (?design_artifact - design_artifact ?resource_token - resource_token ?approval_artifact - approval_artifact)
    :precondition
      (and
        (release_authorized ?design_artifact)
        (element_resource_assigned ?design_artifact ?resource_token)
        (element_approval_bound ?design_artifact ?approval_artifact)
        (not
          (element_released ?design_artifact)
        )
      )
    :effect
      (and
        (element_released ?design_artifact)
        (resource_token_available ?resource_token)
        (approval_artifact_available ?approval_artifact)
      )
  )
)

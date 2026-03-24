(define (domain external_identity_provider_auth_integration)
  (:requirements :strips :typing :negative-preconditions)
  (:types component_subtype_group - object endpoint_subtype_group - object resource_subtype_group - object principal_root - object identity_principal - principal_root identity_provider_client_registration - component_subtype_group auth_challenge - component_subtype_group consent_grant - component_subtype_group policy_profile - component_subtype_group feature_flag - component_subtype_group credential_material - component_subtype_group registration_secret - component_subtype_group signing_key_material - component_subtype_group attribute_template - endpoint_subtype_group tenant_scope - endpoint_subtype_group external_service_binding - endpoint_subtype_group identity_provider_endpoint_a - resource_subtype_group identity_provider_endpoint_b - resource_subtype_group provisioning_artifact - resource_subtype_group user_account_subtype - identity_principal connector_subtype - identity_principal application_user_account - user_account_subtype federated_user_representation - user_account_subtype integration_connector - connector_subtype)
  (:predicates
    (identity_principal_registered ?application_identity_subject - identity_principal)
    (identity_principal_verified ?application_identity_subject - identity_principal)
    (identity_principal_association_created ?application_identity_subject - identity_principal)
    (provisioning_propagated ?application_identity_subject - identity_principal)
    (integration_active ?application_identity_subject - identity_principal)
    (identity_principal_credentials_bound ?application_identity_subject - identity_principal)
    (identity_provider_client_registration_available ?identity_provider_client_registration - identity_provider_client_registration)
    (identity_principal_associated_with_identity_provider_client_registration ?application_identity_subject - identity_principal ?identity_provider_client_registration - identity_provider_client_registration)
    (auth_challenge_available ?auth_challenge - auth_challenge)
    (identity_principal_associated_with_auth_challenge ?application_identity_subject - identity_principal ?auth_challenge - auth_challenge)
    (consent_grant_available ?consent_grant - consent_grant)
    (identity_principal_associated_with_consent_grant ?application_identity_subject - identity_principal ?consent_grant - consent_grant)
    (attribute_template_available ?attribute_template - attribute_template)
    (application_user_account_associated_with_attribute_template ?application_user_account - application_user_account ?attribute_template - attribute_template)
    (federated_user_representation_associated_with_attribute_template ?federated_user_representation - federated_user_representation ?attribute_template - attribute_template)
    (application_user_account_associated_with_identity_provider_endpoint_a ?application_user_account - application_user_account ?identity_provider_endpoint_a - identity_provider_endpoint_a)
    (identity_provider_endpoint_a_ready ?identity_provider_endpoint_a - identity_provider_endpoint_a)
    (identity_provider_endpoint_a_has_attribute_template_assigned ?identity_provider_endpoint_a - identity_provider_endpoint_a)
    (application_user_account_ready_for_provisioning ?application_user_account - application_user_account)
    (federated_user_representation_associated_with_identity_provider_endpoint_b ?federated_user_representation - federated_user_representation ?identity_provider_endpoint_b - identity_provider_endpoint_b)
    (identity_provider_endpoint_b_ready ?identity_provider_endpoint_b - identity_provider_endpoint_b)
    (identity_provider_endpoint_b_has_attribute_template_assigned ?identity_provider_endpoint_b - identity_provider_endpoint_b)
    (federated_user_representation_ready_for_provisioning ?federated_user_representation - federated_user_representation)
    (provisioning_artifact_pending_assembly ?provisioning_artifact - provisioning_artifact)
    (provisioning_artifact_assembled ?provisioning_artifact - provisioning_artifact)
    (provisioning_artifact_associated_with_identity_provider_endpoint_a ?provisioning_artifact - provisioning_artifact ?identity_provider_endpoint_a - identity_provider_endpoint_a)
    (provisioning_artifact_associated_with_identity_provider_endpoint_b ?provisioning_artifact - provisioning_artifact ?identity_provider_endpoint_b - identity_provider_endpoint_b)
    (provisioning_artifact_flag_registration_secret_required ?provisioning_artifact - provisioning_artifact)
    (provisioning_artifact_flag_signing_key_required ?provisioning_artifact - provisioning_artifact)
    (provisioning_artifact_registration_confirmed ?provisioning_artifact - provisioning_artifact)
    (integration_connector_associated_with_application_user_account ?integration_connector - integration_connector ?application_user_account - application_user_account)
    (integration_connector_associated_with_federated_user_representation ?integration_connector - integration_connector ?federated_user_representation - federated_user_representation)
    (integration_connector_associated_with_provisioning_artifact ?integration_connector - integration_connector ?provisioning_artifact - provisioning_artifact)
    (tenant_scope_available ?tenant_scope - tenant_scope)
    (integration_connector_associated_with_tenant_scope ?integration_connector - integration_connector ?tenant_scope - tenant_scope)
    (tenant_scope_committed ?tenant_scope - tenant_scope)
    (tenant_scope_associated_with_provisioning_artifact ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact)
    (integration_connector_registration_ready ?integration_connector - integration_connector)
    (integration_connector_signing_key_stage_reached ?integration_connector - integration_connector)
    (integration_connector_signing_key_attached ?integration_connector - integration_connector)
    (integration_connector_policy_profile_attached ?integration_connector - integration_connector)
    (integration_connector_policy_profile_committed ?integration_connector - integration_connector)
    (integration_connector_external_service_binding_attached ?integration_connector - integration_connector)
    (integration_connector_final_checks_completed ?integration_connector - integration_connector)
    (external_service_binding_available ?external_service_binding - external_service_binding)
    (integration_connector_associated_with_external_service_binding ?integration_connector - integration_connector ?external_service_binding - external_service_binding)
    (integration_connector_external_binding_stage_set ?integration_connector - integration_connector)
    (integration_connector_external_binding_finalized ?integration_connector - integration_connector)
    (integration_connector_external_binding_activated ?integration_connector - integration_connector)
    (policy_profile_available ?policy_profile - policy_profile)
    (integration_connector_associated_with_policy_profile ?integration_connector - integration_connector ?policy_profile - policy_profile)
    (feature_flag_available ?feature_flag - feature_flag)
    (integration_connector_associated_with_feature_flag ?integration_connector - integration_connector ?feature_flag - feature_flag)
    (registration_secret_available ?registration_secret - registration_secret)
    (integration_connector_associated_with_registration_secret ?integration_connector - integration_connector ?registration_secret - registration_secret)
    (signing_key_material_available ?signing_key_material - signing_key_material)
    (integration_connector_associated_with_signing_key_material ?integration_connector - integration_connector ?signing_key_material - signing_key_material)
    (credential_material_available ?credential_material - credential_material)
    (identity_principal_associated_with_credential_material ?application_identity_subject - identity_principal ?credential_material - credential_material)
    (application_user_account_processed_by_connector ?application_user_account - application_user_account)
    (federated_user_representation_processed_by_connector ?federated_user_representation - federated_user_representation)
    (integration_connector_finalization_marker ?integration_connector - integration_connector)
  )
  (:action register_identity_principal
    :parameters (?application_identity_subject - identity_principal)
    :precondition
      (and
        (not
          (identity_principal_registered ?application_identity_subject)
        )
        (not
          (provisioning_propagated ?application_identity_subject)
        )
      )
    :effect (identity_principal_registered ?application_identity_subject)
  )
  (:action associate_identity_principal_with_identity_provider_client_registration
    :parameters (?application_identity_subject - identity_principal ?identity_provider_client_registration - identity_provider_client_registration)
    :precondition
      (and
        (identity_principal_registered ?application_identity_subject)
        (not
          (identity_principal_association_created ?application_identity_subject)
        )
        (identity_provider_client_registration_available ?identity_provider_client_registration)
      )
    :effect
      (and
        (identity_principal_association_created ?application_identity_subject)
        (identity_principal_associated_with_identity_provider_client_registration ?application_identity_subject ?identity_provider_client_registration)
        (not
          (identity_provider_client_registration_available ?identity_provider_client_registration)
        )
      )
  )
  (:action assign_auth_challenge_to_identity_principal
    :parameters (?application_identity_subject - identity_principal ?auth_challenge - auth_challenge)
    :precondition
      (and
        (identity_principal_registered ?application_identity_subject)
        (identity_principal_association_created ?application_identity_subject)
        (auth_challenge_available ?auth_challenge)
      )
    :effect
      (and
        (identity_principal_associated_with_auth_challenge ?application_identity_subject ?auth_challenge)
        (not
          (auth_challenge_available ?auth_challenge)
        )
      )
  )
  (:action verify_identity_principal_via_auth_challenge
    :parameters (?application_identity_subject - identity_principal ?auth_challenge - auth_challenge)
    :precondition
      (and
        (identity_principal_registered ?application_identity_subject)
        (identity_principal_association_created ?application_identity_subject)
        (identity_principal_associated_with_auth_challenge ?application_identity_subject ?auth_challenge)
        (not
          (identity_principal_verified ?application_identity_subject)
        )
      )
    :effect (identity_principal_verified ?application_identity_subject)
  )
  (:action unassign_auth_challenge_from_identity_principal
    :parameters (?application_identity_subject - identity_principal ?auth_challenge - auth_challenge)
    :precondition
      (and
        (identity_principal_associated_with_auth_challenge ?application_identity_subject ?auth_challenge)
      )
    :effect
      (and
        (auth_challenge_available ?auth_challenge)
        (not
          (identity_principal_associated_with_auth_challenge ?application_identity_subject ?auth_challenge)
        )
      )
  )
  (:action assign_consent_grant_to_identity_principal
    :parameters (?application_identity_subject - identity_principal ?consent_grant - consent_grant)
    :precondition
      (and
        (identity_principal_verified ?application_identity_subject)
        (consent_grant_available ?consent_grant)
      )
    :effect
      (and
        (identity_principal_associated_with_consent_grant ?application_identity_subject ?consent_grant)
        (not
          (consent_grant_available ?consent_grant)
        )
      )
  )
  (:action revoke_consent_grant_from_identity_principal
    :parameters (?application_identity_subject - identity_principal ?consent_grant - consent_grant)
    :precondition
      (and
        (identity_principal_associated_with_consent_grant ?application_identity_subject ?consent_grant)
      )
    :effect
      (and
        (consent_grant_available ?consent_grant)
        (not
          (identity_principal_associated_with_consent_grant ?application_identity_subject ?consent_grant)
        )
      )
  )
  (:action attach_registration_secret_to_integration_connector
    :parameters (?integration_connector - integration_connector ?registration_secret - registration_secret)
    :precondition
      (and
        (identity_principal_verified ?integration_connector)
        (registration_secret_available ?registration_secret)
      )
    :effect
      (and
        (integration_connector_associated_with_registration_secret ?integration_connector ?registration_secret)
        (not
          (registration_secret_available ?registration_secret)
        )
      )
  )
  (:action detach_registration_secret_from_integration_connector
    :parameters (?integration_connector - integration_connector ?registration_secret - registration_secret)
    :precondition
      (and
        (integration_connector_associated_with_registration_secret ?integration_connector ?registration_secret)
      )
    :effect
      (and
        (registration_secret_available ?registration_secret)
        (not
          (integration_connector_associated_with_registration_secret ?integration_connector ?registration_secret)
        )
      )
  )
  (:action attach_signing_key_to_integration_connector
    :parameters (?integration_connector - integration_connector ?signing_key_material - signing_key_material)
    :precondition
      (and
        (identity_principal_verified ?integration_connector)
        (signing_key_material_available ?signing_key_material)
      )
    :effect
      (and
        (integration_connector_associated_with_signing_key_material ?integration_connector ?signing_key_material)
        (not
          (signing_key_material_available ?signing_key_material)
        )
      )
  )
  (:action detach_signing_key_from_integration_connector
    :parameters (?integration_connector - integration_connector ?signing_key_material - signing_key_material)
    :precondition
      (and
        (integration_connector_associated_with_signing_key_material ?integration_connector ?signing_key_material)
      )
    :effect
      (and
        (signing_key_material_available ?signing_key_material)
        (not
          (integration_connector_associated_with_signing_key_material ?integration_connector ?signing_key_material)
        )
      )
  )
  (:action negotiate_and_mark_identity_provider_endpoint_a_ready
    :parameters (?application_user_account - application_user_account ?identity_provider_endpoint_a - identity_provider_endpoint_a ?auth_challenge - auth_challenge)
    :precondition
      (and
        (identity_principal_verified ?application_user_account)
        (identity_principal_associated_with_auth_challenge ?application_user_account ?auth_challenge)
        (application_user_account_associated_with_identity_provider_endpoint_a ?application_user_account ?identity_provider_endpoint_a)
        (not
          (identity_provider_endpoint_a_ready ?identity_provider_endpoint_a)
        )
        (not
          (identity_provider_endpoint_a_has_attribute_template_assigned ?identity_provider_endpoint_a)
        )
      )
    :effect (identity_provider_endpoint_a_ready ?identity_provider_endpoint_a)
  )
  (:action bind_consent_and_mark_application_user_account_ready
    :parameters (?application_user_account - application_user_account ?identity_provider_endpoint_a - identity_provider_endpoint_a ?consent_grant - consent_grant)
    :precondition
      (and
        (identity_principal_verified ?application_user_account)
        (identity_principal_associated_with_consent_grant ?application_user_account ?consent_grant)
        (application_user_account_associated_with_identity_provider_endpoint_a ?application_user_account ?identity_provider_endpoint_a)
        (identity_provider_endpoint_a_ready ?identity_provider_endpoint_a)
        (not
          (application_user_account_processed_by_connector ?application_user_account)
        )
      )
    :effect
      (and
        (application_user_account_processed_by_connector ?application_user_account)
        (application_user_account_ready_for_provisioning ?application_user_account)
      )
  )
  (:action assign_attribute_template_to_application_user_account_for_endpoint_a
    :parameters (?application_user_account - application_user_account ?identity_provider_endpoint_a - identity_provider_endpoint_a ?attribute_template - attribute_template)
    :precondition
      (and
        (identity_principal_verified ?application_user_account)
        (application_user_account_associated_with_identity_provider_endpoint_a ?application_user_account ?identity_provider_endpoint_a)
        (attribute_template_available ?attribute_template)
        (not
          (application_user_account_processed_by_connector ?application_user_account)
        )
      )
    :effect
      (and
        (identity_provider_endpoint_a_has_attribute_template_assigned ?identity_provider_endpoint_a)
        (application_user_account_processed_by_connector ?application_user_account)
        (application_user_account_associated_with_attribute_template ?application_user_account ?attribute_template)
        (not
          (attribute_template_available ?attribute_template)
        )
      )
  )
  (:action finalize_attribute_template_exchange_for_application_user_account_and_endpoint_a
    :parameters (?application_user_account - application_user_account ?identity_provider_endpoint_a - identity_provider_endpoint_a ?auth_challenge - auth_challenge ?attribute_template - attribute_template)
    :precondition
      (and
        (identity_principal_verified ?application_user_account)
        (identity_principal_associated_with_auth_challenge ?application_user_account ?auth_challenge)
        (application_user_account_associated_with_identity_provider_endpoint_a ?application_user_account ?identity_provider_endpoint_a)
        (identity_provider_endpoint_a_has_attribute_template_assigned ?identity_provider_endpoint_a)
        (application_user_account_associated_with_attribute_template ?application_user_account ?attribute_template)
        (not
          (application_user_account_ready_for_provisioning ?application_user_account)
        )
      )
    :effect
      (and
        (identity_provider_endpoint_a_ready ?identity_provider_endpoint_a)
        (application_user_account_ready_for_provisioning ?application_user_account)
        (attribute_template_available ?attribute_template)
        (not
          (application_user_account_associated_with_attribute_template ?application_user_account ?attribute_template)
        )
      )
  )
  (:action negotiate_and_mark_identity_provider_endpoint_b_ready
    :parameters (?federated_user_representation - federated_user_representation ?identity_provider_endpoint_b - identity_provider_endpoint_b ?auth_challenge - auth_challenge)
    :precondition
      (and
        (identity_principal_verified ?federated_user_representation)
        (identity_principal_associated_with_auth_challenge ?federated_user_representation ?auth_challenge)
        (federated_user_representation_associated_with_identity_provider_endpoint_b ?federated_user_representation ?identity_provider_endpoint_b)
        (not
          (identity_provider_endpoint_b_ready ?identity_provider_endpoint_b)
        )
        (not
          (identity_provider_endpoint_b_has_attribute_template_assigned ?identity_provider_endpoint_b)
        )
      )
    :effect (identity_provider_endpoint_b_ready ?identity_provider_endpoint_b)
  )
  (:action bind_consent_and_mark_federated_user_representation_ready
    :parameters (?federated_user_representation - federated_user_representation ?identity_provider_endpoint_b - identity_provider_endpoint_b ?consent_grant - consent_grant)
    :precondition
      (and
        (identity_principal_verified ?federated_user_representation)
        (identity_principal_associated_with_consent_grant ?federated_user_representation ?consent_grant)
        (federated_user_representation_associated_with_identity_provider_endpoint_b ?federated_user_representation ?identity_provider_endpoint_b)
        (identity_provider_endpoint_b_ready ?identity_provider_endpoint_b)
        (not
          (federated_user_representation_processed_by_connector ?federated_user_representation)
        )
      )
    :effect
      (and
        (federated_user_representation_processed_by_connector ?federated_user_representation)
        (federated_user_representation_ready_for_provisioning ?federated_user_representation)
      )
  )
  (:action assign_attribute_template_to_federated_user_representation_for_endpoint_b
    :parameters (?federated_user_representation - federated_user_representation ?identity_provider_endpoint_b - identity_provider_endpoint_b ?attribute_template - attribute_template)
    :precondition
      (and
        (identity_principal_verified ?federated_user_representation)
        (federated_user_representation_associated_with_identity_provider_endpoint_b ?federated_user_representation ?identity_provider_endpoint_b)
        (attribute_template_available ?attribute_template)
        (not
          (federated_user_representation_processed_by_connector ?federated_user_representation)
        )
      )
    :effect
      (and
        (identity_provider_endpoint_b_has_attribute_template_assigned ?identity_provider_endpoint_b)
        (federated_user_representation_processed_by_connector ?federated_user_representation)
        (federated_user_representation_associated_with_attribute_template ?federated_user_representation ?attribute_template)
        (not
          (attribute_template_available ?attribute_template)
        )
      )
  )
  (:action finalize_attribute_template_exchange_for_federated_user_representation_and_endpoint_b
    :parameters (?federated_user_representation - federated_user_representation ?identity_provider_endpoint_b - identity_provider_endpoint_b ?auth_challenge - auth_challenge ?attribute_template - attribute_template)
    :precondition
      (and
        (identity_principal_verified ?federated_user_representation)
        (identity_principal_associated_with_auth_challenge ?federated_user_representation ?auth_challenge)
        (federated_user_representation_associated_with_identity_provider_endpoint_b ?federated_user_representation ?identity_provider_endpoint_b)
        (identity_provider_endpoint_b_has_attribute_template_assigned ?identity_provider_endpoint_b)
        (federated_user_representation_associated_with_attribute_template ?federated_user_representation ?attribute_template)
        (not
          (federated_user_representation_ready_for_provisioning ?federated_user_representation)
        )
      )
    :effect
      (and
        (identity_provider_endpoint_b_ready ?identity_provider_endpoint_b)
        (federated_user_representation_ready_for_provisioning ?federated_user_representation)
        (attribute_template_available ?attribute_template)
        (not
          (federated_user_representation_associated_with_attribute_template ?federated_user_representation ?attribute_template)
        )
      )
  )
  (:action assemble_provisioning_artifact_from_endpoints_and_scopes
    :parameters (?application_user_account - application_user_account ?federated_user_representation - federated_user_representation ?identity_provider_endpoint_a - identity_provider_endpoint_a ?identity_provider_endpoint_b - identity_provider_endpoint_b ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (application_user_account_processed_by_connector ?application_user_account)
        (federated_user_representation_processed_by_connector ?federated_user_representation)
        (application_user_account_associated_with_identity_provider_endpoint_a ?application_user_account ?identity_provider_endpoint_a)
        (federated_user_representation_associated_with_identity_provider_endpoint_b ?federated_user_representation ?identity_provider_endpoint_b)
        (identity_provider_endpoint_a_ready ?identity_provider_endpoint_a)
        (identity_provider_endpoint_b_ready ?identity_provider_endpoint_b)
        (application_user_account_ready_for_provisioning ?application_user_account)
        (federated_user_representation_ready_for_provisioning ?federated_user_representation)
        (provisioning_artifact_pending_assembly ?provisioning_artifact)
      )
    :effect
      (and
        (provisioning_artifact_assembled ?provisioning_artifact)
        (provisioning_artifact_associated_with_identity_provider_endpoint_a ?provisioning_artifact ?identity_provider_endpoint_a)
        (provisioning_artifact_associated_with_identity_provider_endpoint_b ?provisioning_artifact ?identity_provider_endpoint_b)
        (not
          (provisioning_artifact_pending_assembly ?provisioning_artifact)
        )
      )
  )
  (:action assemble_provisioning_artifact_with_endpoint_a_attribute_flag
    :parameters (?application_user_account - application_user_account ?federated_user_representation - federated_user_representation ?identity_provider_endpoint_a - identity_provider_endpoint_a ?identity_provider_endpoint_b - identity_provider_endpoint_b ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (application_user_account_processed_by_connector ?application_user_account)
        (federated_user_representation_processed_by_connector ?federated_user_representation)
        (application_user_account_associated_with_identity_provider_endpoint_a ?application_user_account ?identity_provider_endpoint_a)
        (federated_user_representation_associated_with_identity_provider_endpoint_b ?federated_user_representation ?identity_provider_endpoint_b)
        (identity_provider_endpoint_a_has_attribute_template_assigned ?identity_provider_endpoint_a)
        (identity_provider_endpoint_b_ready ?identity_provider_endpoint_b)
        (not
          (application_user_account_ready_for_provisioning ?application_user_account)
        )
        (federated_user_representation_ready_for_provisioning ?federated_user_representation)
        (provisioning_artifact_pending_assembly ?provisioning_artifact)
      )
    :effect
      (and
        (provisioning_artifact_assembled ?provisioning_artifact)
        (provisioning_artifact_associated_with_identity_provider_endpoint_a ?provisioning_artifact ?identity_provider_endpoint_a)
        (provisioning_artifact_associated_with_identity_provider_endpoint_b ?provisioning_artifact ?identity_provider_endpoint_b)
        (provisioning_artifact_flag_registration_secret_required ?provisioning_artifact)
        (not
          (provisioning_artifact_pending_assembly ?provisioning_artifact)
        )
      )
  )
  (:action assemble_provisioning_artifact_with_endpoint_b_attribute_flag
    :parameters (?application_user_account - application_user_account ?federated_user_representation - federated_user_representation ?identity_provider_endpoint_a - identity_provider_endpoint_a ?identity_provider_endpoint_b - identity_provider_endpoint_b ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (application_user_account_processed_by_connector ?application_user_account)
        (federated_user_representation_processed_by_connector ?federated_user_representation)
        (application_user_account_associated_with_identity_provider_endpoint_a ?application_user_account ?identity_provider_endpoint_a)
        (federated_user_representation_associated_with_identity_provider_endpoint_b ?federated_user_representation ?identity_provider_endpoint_b)
        (identity_provider_endpoint_a_ready ?identity_provider_endpoint_a)
        (identity_provider_endpoint_b_has_attribute_template_assigned ?identity_provider_endpoint_b)
        (application_user_account_ready_for_provisioning ?application_user_account)
        (not
          (federated_user_representation_ready_for_provisioning ?federated_user_representation)
        )
        (provisioning_artifact_pending_assembly ?provisioning_artifact)
      )
    :effect
      (and
        (provisioning_artifact_assembled ?provisioning_artifact)
        (provisioning_artifact_associated_with_identity_provider_endpoint_a ?provisioning_artifact ?identity_provider_endpoint_a)
        (provisioning_artifact_associated_with_identity_provider_endpoint_b ?provisioning_artifact ?identity_provider_endpoint_b)
        (provisioning_artifact_flag_signing_key_required ?provisioning_artifact)
        (not
          (provisioning_artifact_pending_assembly ?provisioning_artifact)
        )
      )
  )
  (:action assemble_provisioning_artifact_with_both_endpoint_flags
    :parameters (?application_user_account - application_user_account ?federated_user_representation - federated_user_representation ?identity_provider_endpoint_a - identity_provider_endpoint_a ?identity_provider_endpoint_b - identity_provider_endpoint_b ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (application_user_account_processed_by_connector ?application_user_account)
        (federated_user_representation_processed_by_connector ?federated_user_representation)
        (application_user_account_associated_with_identity_provider_endpoint_a ?application_user_account ?identity_provider_endpoint_a)
        (federated_user_representation_associated_with_identity_provider_endpoint_b ?federated_user_representation ?identity_provider_endpoint_b)
        (identity_provider_endpoint_a_has_attribute_template_assigned ?identity_provider_endpoint_a)
        (identity_provider_endpoint_b_has_attribute_template_assigned ?identity_provider_endpoint_b)
        (not
          (application_user_account_ready_for_provisioning ?application_user_account)
        )
        (not
          (federated_user_representation_ready_for_provisioning ?federated_user_representation)
        )
        (provisioning_artifact_pending_assembly ?provisioning_artifact)
      )
    :effect
      (and
        (provisioning_artifact_assembled ?provisioning_artifact)
        (provisioning_artifact_associated_with_identity_provider_endpoint_a ?provisioning_artifact ?identity_provider_endpoint_a)
        (provisioning_artifact_associated_with_identity_provider_endpoint_b ?provisioning_artifact ?identity_provider_endpoint_b)
        (provisioning_artifact_flag_registration_secret_required ?provisioning_artifact)
        (provisioning_artifact_flag_signing_key_required ?provisioning_artifact)
        (not
          (provisioning_artifact_pending_assembly ?provisioning_artifact)
        )
      )
  )
  (:action confirm_provisioning_artifact_registration
    :parameters (?provisioning_artifact - provisioning_artifact ?application_user_account - application_user_account ?auth_challenge - auth_challenge)
    :precondition
      (and
        (provisioning_artifact_assembled ?provisioning_artifact)
        (application_user_account_processed_by_connector ?application_user_account)
        (identity_principal_associated_with_auth_challenge ?application_user_account ?auth_challenge)
        (not
          (provisioning_artifact_registration_confirmed ?provisioning_artifact)
        )
      )
    :effect (provisioning_artifact_registration_confirmed ?provisioning_artifact)
  )
  (:action commit_tenant_scope_and_associate_with_provisioning_artifact
    :parameters (?integration_connector - integration_connector ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (identity_principal_verified ?integration_connector)
        (integration_connector_associated_with_provisioning_artifact ?integration_connector ?provisioning_artifact)
        (integration_connector_associated_with_tenant_scope ?integration_connector ?tenant_scope)
        (tenant_scope_available ?tenant_scope)
        (provisioning_artifact_assembled ?provisioning_artifact)
        (provisioning_artifact_registration_confirmed ?provisioning_artifact)
        (not
          (tenant_scope_committed ?tenant_scope)
        )
      )
    :effect
      (and
        (tenant_scope_committed ?tenant_scope)
        (tenant_scope_associated_with_provisioning_artifact ?tenant_scope ?provisioning_artifact)
        (not
          (tenant_scope_available ?tenant_scope)
        )
      )
  )
  (:action mark_integration_connector_registration_ready
    :parameters (?integration_connector - integration_connector ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact ?auth_challenge - auth_challenge)
    :precondition
      (and
        (identity_principal_verified ?integration_connector)
        (integration_connector_associated_with_tenant_scope ?integration_connector ?tenant_scope)
        (tenant_scope_committed ?tenant_scope)
        (tenant_scope_associated_with_provisioning_artifact ?tenant_scope ?provisioning_artifact)
        (identity_principal_associated_with_auth_challenge ?integration_connector ?auth_challenge)
        (not
          (provisioning_artifact_flag_registration_secret_required ?provisioning_artifact)
        )
        (not
          (integration_connector_registration_ready ?integration_connector)
        )
      )
    :effect (integration_connector_registration_ready ?integration_connector)
  )
  (:action attach_policy_profile_to_integration_connector
    :parameters (?integration_connector - integration_connector ?policy_profile - policy_profile)
    :precondition
      (and
        (identity_principal_verified ?integration_connector)
        (policy_profile_available ?policy_profile)
        (not
          (integration_connector_policy_profile_attached ?integration_connector)
        )
      )
    :effect
      (and
        (integration_connector_policy_profile_attached ?integration_connector)
        (integration_connector_associated_with_policy_profile ?integration_connector ?policy_profile)
        (not
          (policy_profile_available ?policy_profile)
        )
      )
  )
  (:action attach_registration_secret_and_policy_profile_to_integration_connector
    :parameters (?integration_connector - integration_connector ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact ?auth_challenge - auth_challenge ?policy_profile - policy_profile)
    :precondition
      (and
        (identity_principal_verified ?integration_connector)
        (integration_connector_associated_with_tenant_scope ?integration_connector ?tenant_scope)
        (tenant_scope_committed ?tenant_scope)
        (tenant_scope_associated_with_provisioning_artifact ?tenant_scope ?provisioning_artifact)
        (identity_principal_associated_with_auth_challenge ?integration_connector ?auth_challenge)
        (provisioning_artifact_flag_registration_secret_required ?provisioning_artifact)
        (integration_connector_policy_profile_attached ?integration_connector)
        (integration_connector_associated_with_policy_profile ?integration_connector ?policy_profile)
        (not
          (integration_connector_registration_ready ?integration_connector)
        )
      )
    :effect
      (and
        (integration_connector_registration_ready ?integration_connector)
        (integration_connector_policy_profile_committed ?integration_connector)
      )
  )
  (:action progress_connector_with_registration_secret_to_signing_key_stage
    :parameters (?integration_connector - integration_connector ?registration_secret - registration_secret ?consent_grant - consent_grant ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (integration_connector_registration_ready ?integration_connector)
        (integration_connector_associated_with_registration_secret ?integration_connector ?registration_secret)
        (identity_principal_associated_with_consent_grant ?integration_connector ?consent_grant)
        (integration_connector_associated_with_tenant_scope ?integration_connector ?tenant_scope)
        (tenant_scope_associated_with_provisioning_artifact ?tenant_scope ?provisioning_artifact)
        (not
          (provisioning_artifact_flag_signing_key_required ?provisioning_artifact)
        )
        (not
          (integration_connector_signing_key_stage_reached ?integration_connector)
        )
      )
    :effect (integration_connector_signing_key_stage_reached ?integration_connector)
  )
  (:action progress_connector_with_registration_secret_and_flags_to_signing_key_stage
    :parameters (?integration_connector - integration_connector ?registration_secret - registration_secret ?consent_grant - consent_grant ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (integration_connector_registration_ready ?integration_connector)
        (integration_connector_associated_with_registration_secret ?integration_connector ?registration_secret)
        (identity_principal_associated_with_consent_grant ?integration_connector ?consent_grant)
        (integration_connector_associated_with_tenant_scope ?integration_connector ?tenant_scope)
        (tenant_scope_associated_with_provisioning_artifact ?tenant_scope ?provisioning_artifact)
        (provisioning_artifact_flag_signing_key_required ?provisioning_artifact)
        (not
          (integration_connector_signing_key_stage_reached ?integration_connector)
        )
      )
    :effect (integration_connector_signing_key_stage_reached ?integration_connector)
  )
  (:action attach_signing_key_and_mark_integration_connector_ready
    :parameters (?integration_connector - integration_connector ?signing_key_material - signing_key_material ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (integration_connector_signing_key_stage_reached ?integration_connector)
        (integration_connector_associated_with_signing_key_material ?integration_connector ?signing_key_material)
        (integration_connector_associated_with_tenant_scope ?integration_connector ?tenant_scope)
        (tenant_scope_associated_with_provisioning_artifact ?tenant_scope ?provisioning_artifact)
        (not
          (provisioning_artifact_flag_registration_secret_required ?provisioning_artifact)
        )
        (not
          (provisioning_artifact_flag_signing_key_required ?provisioning_artifact)
        )
        (not
          (integration_connector_signing_key_attached ?integration_connector)
        )
      )
    :effect (integration_connector_signing_key_attached ?integration_connector)
  )
  (:action attach_signing_key_and_enable_external_service_binding
    :parameters (?integration_connector - integration_connector ?signing_key_material - signing_key_material ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (integration_connector_signing_key_stage_reached ?integration_connector)
        (integration_connector_associated_with_signing_key_material ?integration_connector ?signing_key_material)
        (integration_connector_associated_with_tenant_scope ?integration_connector ?tenant_scope)
        (tenant_scope_associated_with_provisioning_artifact ?tenant_scope ?provisioning_artifact)
        (provisioning_artifact_flag_registration_secret_required ?provisioning_artifact)
        (not
          (provisioning_artifact_flag_signing_key_required ?provisioning_artifact)
        )
        (not
          (integration_connector_signing_key_attached ?integration_connector)
        )
      )
    :effect
      (and
        (integration_connector_signing_key_attached ?integration_connector)
        (integration_connector_external_service_binding_attached ?integration_connector)
      )
  )
  (:action attach_signing_key_and_finalize_external_binding_stage
    :parameters (?integration_connector - integration_connector ?signing_key_material - signing_key_material ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (integration_connector_signing_key_stage_reached ?integration_connector)
        (integration_connector_associated_with_signing_key_material ?integration_connector ?signing_key_material)
        (integration_connector_associated_with_tenant_scope ?integration_connector ?tenant_scope)
        (tenant_scope_associated_with_provisioning_artifact ?tenant_scope ?provisioning_artifact)
        (not
          (provisioning_artifact_flag_registration_secret_required ?provisioning_artifact)
        )
        (provisioning_artifact_flag_signing_key_required ?provisioning_artifact)
        (not
          (integration_connector_signing_key_attached ?integration_connector)
        )
      )
    :effect
      (and
        (integration_connector_signing_key_attached ?integration_connector)
        (integration_connector_external_service_binding_attached ?integration_connector)
      )
  )
  (:action attach_signing_key_and_commit_external_binding_stage
    :parameters (?integration_connector - integration_connector ?signing_key_material - signing_key_material ?tenant_scope - tenant_scope ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (integration_connector_signing_key_stage_reached ?integration_connector)
        (integration_connector_associated_with_signing_key_material ?integration_connector ?signing_key_material)
        (integration_connector_associated_with_tenant_scope ?integration_connector ?tenant_scope)
        (tenant_scope_associated_with_provisioning_artifact ?tenant_scope ?provisioning_artifact)
        (provisioning_artifact_flag_registration_secret_required ?provisioning_artifact)
        (provisioning_artifact_flag_signing_key_required ?provisioning_artifact)
        (not
          (integration_connector_signing_key_attached ?integration_connector)
        )
      )
    :effect
      (and
        (integration_connector_signing_key_attached ?integration_connector)
        (integration_connector_external_service_binding_attached ?integration_connector)
      )
  )
  (:action finalize_connector_activation_step_one
    :parameters (?integration_connector - integration_connector)
    :precondition
      (and
        (integration_connector_signing_key_attached ?integration_connector)
        (not
          (integration_connector_external_service_binding_attached ?integration_connector)
        )
        (not
          (integration_connector_finalization_marker ?integration_connector)
        )
      )
    :effect
      (and
        (integration_connector_finalization_marker ?integration_connector)
        (integration_active ?integration_connector)
      )
  )
  (:action associate_feature_flag_with_integration_connector
    :parameters (?integration_connector - integration_connector ?feature_flag - feature_flag)
    :precondition
      (and
        (integration_connector_signing_key_attached ?integration_connector)
        (integration_connector_external_service_binding_attached ?integration_connector)
        (feature_flag_available ?feature_flag)
      )
    :effect
      (and
        (integration_connector_associated_with_feature_flag ?integration_connector ?feature_flag)
        (not
          (feature_flag_available ?feature_flag)
        )
      )
  )
  (:action activate_integration_connector_with_account_mappings
    :parameters (?integration_connector - integration_connector ?application_user_account - application_user_account ?federated_user_representation - federated_user_representation ?auth_challenge - auth_challenge ?feature_flag - feature_flag)
    :precondition
      (and
        (integration_connector_signing_key_attached ?integration_connector)
        (integration_connector_external_service_binding_attached ?integration_connector)
        (integration_connector_associated_with_feature_flag ?integration_connector ?feature_flag)
        (integration_connector_associated_with_application_user_account ?integration_connector ?application_user_account)
        (integration_connector_associated_with_federated_user_representation ?integration_connector ?federated_user_representation)
        (application_user_account_ready_for_provisioning ?application_user_account)
        (federated_user_representation_ready_for_provisioning ?federated_user_representation)
        (identity_principal_associated_with_auth_challenge ?integration_connector ?auth_challenge)
        (not
          (integration_connector_final_checks_completed ?integration_connector)
        )
      )
    :effect (integration_connector_final_checks_completed ?integration_connector)
  )
  (:action finalize_connector_activation_step_two
    :parameters (?integration_connector - integration_connector)
    :precondition
      (and
        (integration_connector_signing_key_attached ?integration_connector)
        (integration_connector_final_checks_completed ?integration_connector)
        (not
          (integration_connector_finalization_marker ?integration_connector)
        )
      )
    :effect
      (and
        (integration_connector_finalization_marker ?integration_connector)
        (integration_active ?integration_connector)
      )
  )
  (:action stage_external_service_binding_on_connector
    :parameters (?integration_connector - integration_connector ?external_service_binding - external_service_binding ?auth_challenge - auth_challenge)
    :precondition
      (and
        (identity_principal_verified ?integration_connector)
        (identity_principal_associated_with_auth_challenge ?integration_connector ?auth_challenge)
        (external_service_binding_available ?external_service_binding)
        (integration_connector_associated_with_external_service_binding ?integration_connector ?external_service_binding)
        (not
          (integration_connector_external_binding_stage_set ?integration_connector)
        )
      )
    :effect
      (and
        (integration_connector_external_binding_stage_set ?integration_connector)
        (not
          (external_service_binding_available ?external_service_binding)
        )
      )
  )
  (:action finalize_external_service_binding_on_connector
    :parameters (?integration_connector - integration_connector ?consent_grant - consent_grant)
    :precondition
      (and
        (integration_connector_external_binding_stage_set ?integration_connector)
        (identity_principal_associated_with_consent_grant ?integration_connector ?consent_grant)
        (not
          (integration_connector_external_binding_finalized ?integration_connector)
        )
      )
    :effect (integration_connector_external_binding_finalized ?integration_connector)
  )
  (:action activate_external_service_binding_on_connector
    :parameters (?integration_connector - integration_connector ?signing_key_material - signing_key_material)
    :precondition
      (and
        (integration_connector_external_binding_finalized ?integration_connector)
        (integration_connector_associated_with_signing_key_material ?integration_connector ?signing_key_material)
        (not
          (integration_connector_external_binding_activated ?integration_connector)
        )
      )
    :effect (integration_connector_external_binding_activated ?integration_connector)
  )
  (:action finalize_connector_activation_via_external_binding
    :parameters (?integration_connector - integration_connector)
    :precondition
      (and
        (integration_connector_external_binding_activated ?integration_connector)
        (not
          (integration_connector_finalization_marker ?integration_connector)
        )
      )
    :effect
      (and
        (integration_connector_finalization_marker ?integration_connector)
        (integration_active ?integration_connector)
      )
  )
  (:action propagate_provisioning_to_application_user_account
    :parameters (?application_user_account - application_user_account ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (application_user_account_processed_by_connector ?application_user_account)
        (application_user_account_ready_for_provisioning ?application_user_account)
        (provisioning_artifact_assembled ?provisioning_artifact)
        (provisioning_artifact_registration_confirmed ?provisioning_artifact)
        (not
          (integration_active ?application_user_account)
        )
      )
    :effect (integration_active ?application_user_account)
  )
  (:action propagate_provisioning_to_federated_user_representation
    :parameters (?federated_user_representation - federated_user_representation ?provisioning_artifact - provisioning_artifact)
    :precondition
      (and
        (federated_user_representation_processed_by_connector ?federated_user_representation)
        (federated_user_representation_ready_for_provisioning ?federated_user_representation)
        (provisioning_artifact_assembled ?provisioning_artifact)
        (provisioning_artifact_registration_confirmed ?provisioning_artifact)
        (not
          (integration_active ?federated_user_representation)
        )
      )
    :effect (integration_active ?federated_user_representation)
  )
  (:action issue_credential_material_to_identity_principal
    :parameters (?application_identity_subject - identity_principal ?credential_material - credential_material ?auth_challenge - auth_challenge)
    :precondition
      (and
        (integration_active ?application_identity_subject)
        (identity_principal_associated_with_auth_challenge ?application_identity_subject ?auth_challenge)
        (credential_material_available ?credential_material)
        (not
          (identity_principal_credentials_bound ?application_identity_subject)
        )
      )
    :effect
      (and
        (identity_principal_credentials_bound ?application_identity_subject)
        (identity_principal_associated_with_credential_material ?application_identity_subject ?credential_material)
        (not
          (credential_material_available ?credential_material)
        )
      )
  )
  (:action propagate_provisioning_to_application_user_account_and_reissue_credential
    :parameters (?application_user_account - application_user_account ?identity_provider_client_registration - identity_provider_client_registration ?credential_material - credential_material)
    :precondition
      (and
        (identity_principal_credentials_bound ?application_user_account)
        (identity_principal_associated_with_identity_provider_client_registration ?application_user_account ?identity_provider_client_registration)
        (identity_principal_associated_with_credential_material ?application_user_account ?credential_material)
        (not
          (provisioning_propagated ?application_user_account)
        )
      )
    :effect
      (and
        (provisioning_propagated ?application_user_account)
        (identity_provider_client_registration_available ?identity_provider_client_registration)
        (credential_material_available ?credential_material)
      )
  )
  (:action propagate_provisioning_to_federated_user_representation_and_reissue_credential
    :parameters (?federated_user_representation - federated_user_representation ?identity_provider_client_registration - identity_provider_client_registration ?credential_material - credential_material)
    :precondition
      (and
        (identity_principal_credentials_bound ?federated_user_representation)
        (identity_principal_associated_with_identity_provider_client_registration ?federated_user_representation ?identity_provider_client_registration)
        (identity_principal_associated_with_credential_material ?federated_user_representation ?credential_material)
        (not
          (provisioning_propagated ?federated_user_representation)
        )
      )
    :effect
      (and
        (provisioning_propagated ?federated_user_representation)
        (identity_provider_client_registration_available ?identity_provider_client_registration)
        (credential_material_available ?credential_material)
      )
  )
  (:action propagate_provisioning_to_integration_connector_and_reissue_credential
    :parameters (?integration_connector - integration_connector ?identity_provider_client_registration - identity_provider_client_registration ?credential_material - credential_material)
    :precondition
      (and
        (identity_principal_credentials_bound ?integration_connector)
        (identity_principal_associated_with_identity_provider_client_registration ?integration_connector ?identity_provider_client_registration)
        (identity_principal_associated_with_credential_material ?integration_connector ?credential_material)
        (not
          (provisioning_propagated ?integration_connector)
        )
      )
    :effect
      (and
        (provisioning_propagated ?integration_connector)
        (identity_provider_client_registration_available ?identity_provider_client_registration)
        (credential_material_available ?credential_material)
      )
  )
)

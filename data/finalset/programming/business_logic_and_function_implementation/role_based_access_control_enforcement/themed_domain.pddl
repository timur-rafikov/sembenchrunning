(define (domain rbac_enforcement_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_entity - object resource_category - object scope_category - object identity_root - object principal - identity_root rbac_role - domain_entity permission - domain_entity approval_token - domain_entity feature_flag - domain_entity constraint - domain_entity policy_document - domain_entity credential - domain_entity audit_record - domain_entity entitlement - resource_category resource - resource_category delegation_ticket - resource_category context_scope_a - scope_category context_scope_b - scope_category access_request - scope_category principal_kind - principal principal_subclass - principal end_user - principal_kind service_account - principal_kind policy_engine - principal_subclass)
  (:predicates
    (principal_registered ?principal - principal)
    (principal_authorized ?principal - principal)
    (role_assignment_pending ?principal - principal)
    (principal_active ?principal - principal)
    (authorization_grant_issued ?principal - principal)
    (identity_verified ?principal - principal)
    (role_available ?role - rbac_role)
    (principal_role_binding ?principal - principal ?role - rbac_role)
    (permission_available ?permission - permission)
    (principal_permission_binding ?principal - principal ?permission - permission)
    (approval_token_available ?approval_token - approval_token)
    (principal_approval_link ?principal - principal ?approval_token - approval_token)
    (entitlement_available ?entitlement - entitlement)
    (end_user_entitlement ?end_user - end_user ?entitlement - entitlement)
    (service_account_entitlement ?service_account - service_account ?entitlement - entitlement)
    (end_user_scope_a_binding ?end_user - end_user ?scope_a - context_scope_a)
    (scope_a_ready ?scope_a - context_scope_a)
    (scope_a_bound ?scope_a - context_scope_a)
    (end_user_context_confirmed ?end_user - end_user)
    (service_account_scope_b_binding ?service_account - service_account ?scope_b - context_scope_b)
    (scope_b_ready ?scope_b - context_scope_b)
    (scope_b_bound ?scope_b - context_scope_b)
    (service_account_context_confirmed ?service_account - service_account)
    (access_request_pending ?access_request - access_request)
    (access_request_qualified ?access_request - access_request)
    (access_request_has_scope_a ?access_request - access_request ?scope_a - context_scope_a)
    (access_request_has_scope_b ?access_request - access_request ?scope_b - context_scope_b)
    (access_request_option_a ?access_request - access_request)
    (access_request_option_b ?access_request - access_request)
    (access_request_locked ?access_request - access_request)
    (policy_engine_end_user_binding ?policy_engine - policy_engine ?end_user - end_user)
    (policy_engine_service_account_binding ?policy_engine - policy_engine ?service_account - service_account)
    (policy_engine_access_request_binding ?policy_engine - policy_engine ?access_request - access_request)
    (resource_available ?resource - resource)
    (policy_engine_resource_binding ?policy_engine - policy_engine ?resource - resource)
    (resource_reserved ?resource - resource)
    (resource_bound_to_request ?resource - resource ?access_request - access_request)
    (policy_engine_evaluation_ready ?policy_engine - policy_engine)
    (policy_engine_authorization_ready ?policy_engine - policy_engine)
    (policy_engine_issue_ready ?policy_engine - policy_engine)
    (policy_engine_feature_activated ?policy_engine - policy_engine)
    (policy_engine_feature_promoted ?policy_engine - policy_engine)
    (policy_engine_credentialing_enabled ?policy_engine - policy_engine)
    (policy_engine_finalized ?policy_engine - policy_engine)
    (delegation_ticket_available ?delegation_ticket - delegation_ticket)
    (policy_engine_delegation_binding ?policy_engine - policy_engine ?delegation_ticket - delegation_ticket)
    (policy_engine_delegation_activated ?policy_engine - policy_engine)
    (policy_engine_approval_requested ?policy_engine - policy_engine)
    (policy_engine_approval_granted ?policy_engine - policy_engine)
    (feature_flag_available ?feature_flag - feature_flag)
    (policy_engine_feature_link ?policy_engine - policy_engine ?feature_flag - feature_flag)
    (constraint_available ?constraint - constraint)
    (policy_engine_constraint_link ?policy_engine - policy_engine ?constraint - constraint)
    (credential_available ?credential - credential)
    (policy_engine_credential_binding ?policy_engine - policy_engine ?credential - credential)
    (audit_record_available ?audit_record - audit_record)
    (policy_engine_audit_bound ?policy_engine - policy_engine ?audit_record - audit_record)
    (policy_document_available ?policy_document - policy_document)
    (principal_policy_document_binding ?principal - principal ?policy_document - policy_document)
    (end_user_context_initialized ?end_user - end_user)
    (service_account_context_initialized ?service_account - service_account)
    (audit_record_committed ?policy_engine - policy_engine)
  )
  (:action register_principal
    :parameters (?principal - principal)
    :precondition
      (and
        (not
          (principal_registered ?principal)
        )
        (not
          (principal_active ?principal)
        )
      )
    :effect (principal_registered ?principal)
  )
  (:action request_role_assignment
    :parameters (?principal - principal ?role - rbac_role)
    :precondition
      (and
        (principal_registered ?principal)
        (not
          (role_assignment_pending ?principal)
        )
        (role_available ?role)
      )
    :effect
      (and
        (role_assignment_pending ?principal)
        (principal_role_binding ?principal ?role)
        (not
          (role_available ?role)
        )
      )
  )
  (:action bind_permission_to_principal
    :parameters (?principal - principal ?permission - permission)
    :precondition
      (and
        (principal_registered ?principal)
        (role_assignment_pending ?principal)
        (permission_available ?permission)
      )
    :effect
      (and
        (principal_permission_binding ?principal ?permission)
        (not
          (permission_available ?permission)
        )
      )
  )
  (:action finalize_permission_assignment
    :parameters (?principal - principal ?permission - permission)
    :precondition
      (and
        (principal_registered ?principal)
        (role_assignment_pending ?principal)
        (principal_permission_binding ?principal ?permission)
        (not
          (principal_authorized ?principal)
        )
      )
    :effect (principal_authorized ?principal)
  )
  (:action release_permission_token
    :parameters (?principal - principal ?permission - permission)
    :precondition
      (and
        (principal_permission_binding ?principal ?permission)
      )
    :effect
      (and
        (permission_available ?permission)
        (not
          (principal_permission_binding ?principal ?permission)
        )
      )
  )
  (:action apply_approval_token
    :parameters (?principal - principal ?approval_token - approval_token)
    :precondition
      (and
        (principal_authorized ?principal)
        (approval_token_available ?approval_token)
      )
    :effect
      (and
        (principal_approval_link ?principal ?approval_token)
        (not
          (approval_token_available ?approval_token)
        )
      )
  )
  (:action revoke_approval_token
    :parameters (?principal - principal ?approval_token - approval_token)
    :precondition
      (and
        (principal_approval_link ?principal ?approval_token)
      )
    :effect
      (and
        (approval_token_available ?approval_token)
        (not
          (principal_approval_link ?principal ?approval_token)
        )
      )
  )
  (:action issue_credential_by_engine
    :parameters (?policy_engine - policy_engine ?credential - credential)
    :precondition
      (and
        (principal_authorized ?policy_engine)
        (credential_available ?credential)
      )
    :effect
      (and
        (policy_engine_credential_binding ?policy_engine ?credential)
        (not
          (credential_available ?credential)
        )
      )
  )
  (:action revoke_credential_by_engine
    :parameters (?policy_engine - policy_engine ?credential - credential)
    :precondition
      (and
        (policy_engine_credential_binding ?policy_engine ?credential)
      )
    :effect
      (and
        (credential_available ?credential)
        (not
          (policy_engine_credential_binding ?policy_engine ?credential)
        )
      )
  )
  (:action bind_audit_record
    :parameters (?policy_engine - policy_engine ?audit_record - audit_record)
    :precondition
      (and
        (principal_authorized ?policy_engine)
        (audit_record_available ?audit_record)
      )
    :effect
      (and
        (policy_engine_audit_bound ?policy_engine ?audit_record)
        (not
          (audit_record_available ?audit_record)
        )
      )
  )
  (:action unbind_audit_record
    :parameters (?policy_engine - policy_engine ?audit_record - audit_record)
    :precondition
      (and
        (policy_engine_audit_bound ?policy_engine ?audit_record)
      )
    :effect
      (and
        (audit_record_available ?audit_record)
        (not
          (policy_engine_audit_bound ?policy_engine ?audit_record)
        )
      )
  )
  (:action evaluate_end_user_scope_a
    :parameters (?end_user - end_user ?scope_a - context_scope_a ?permission - permission)
    :precondition
      (and
        (principal_authorized ?end_user)
        (principal_permission_binding ?end_user ?permission)
        (end_user_scope_a_binding ?end_user ?scope_a)
        (not
          (scope_a_ready ?scope_a)
        )
        (not
          (scope_a_bound ?scope_a)
        )
      )
    :effect (scope_a_ready ?scope_a)
  )
  (:action authorize_end_user_with_approval
    :parameters (?end_user - end_user ?scope_a - context_scope_a ?approval_token - approval_token)
    :precondition
      (and
        (principal_authorized ?end_user)
        (principal_approval_link ?end_user ?approval_token)
        (end_user_scope_a_binding ?end_user ?scope_a)
        (scope_a_ready ?scope_a)
        (not
          (end_user_context_initialized ?end_user)
        )
      )
    :effect
      (and
        (end_user_context_initialized ?end_user)
        (end_user_context_confirmed ?end_user)
      )
  )
  (:action bind_entitlement_to_end_user_scope
    :parameters (?end_user - end_user ?scope_a - context_scope_a ?entitlement - entitlement)
    :precondition
      (and
        (principal_authorized ?end_user)
        (end_user_scope_a_binding ?end_user ?scope_a)
        (entitlement_available ?entitlement)
        (not
          (end_user_context_initialized ?end_user)
        )
      )
    :effect
      (and
        (scope_a_bound ?scope_a)
        (end_user_context_initialized ?end_user)
        (end_user_entitlement ?end_user ?entitlement)
        (not
          (entitlement_available ?entitlement)
        )
      )
  )
  (:action finalize_end_user_scope_entitlement
    :parameters (?end_user - end_user ?scope_a - context_scope_a ?permission - permission ?entitlement - entitlement)
    :precondition
      (and
        (principal_authorized ?end_user)
        (principal_permission_binding ?end_user ?permission)
        (end_user_scope_a_binding ?end_user ?scope_a)
        (scope_a_bound ?scope_a)
        (end_user_entitlement ?end_user ?entitlement)
        (not
          (end_user_context_confirmed ?end_user)
        )
      )
    :effect
      (and
        (scope_a_ready ?scope_a)
        (end_user_context_confirmed ?end_user)
        (entitlement_available ?entitlement)
        (not
          (end_user_entitlement ?end_user ?entitlement)
        )
      )
  )
  (:action evaluate_service_scope_b
    :parameters (?service_account - service_account ?scope_b - context_scope_b ?permission - permission)
    :precondition
      (and
        (principal_authorized ?service_account)
        (principal_permission_binding ?service_account ?permission)
        (service_account_scope_b_binding ?service_account ?scope_b)
        (not
          (scope_b_ready ?scope_b)
        )
        (not
          (scope_b_bound ?scope_b)
        )
      )
    :effect (scope_b_ready ?scope_b)
  )
  (:action authorize_service_account_with_approval
    :parameters (?service_account - service_account ?scope_b - context_scope_b ?approval_token - approval_token)
    :precondition
      (and
        (principal_authorized ?service_account)
        (principal_approval_link ?service_account ?approval_token)
        (service_account_scope_b_binding ?service_account ?scope_b)
        (scope_b_ready ?scope_b)
        (not
          (service_account_context_initialized ?service_account)
        )
      )
    :effect
      (and
        (service_account_context_initialized ?service_account)
        (service_account_context_confirmed ?service_account)
      )
  )
  (:action bind_entitlement_to_service_scope
    :parameters (?service_account - service_account ?scope_b - context_scope_b ?entitlement - entitlement)
    :precondition
      (and
        (principal_authorized ?service_account)
        (service_account_scope_b_binding ?service_account ?scope_b)
        (entitlement_available ?entitlement)
        (not
          (service_account_context_initialized ?service_account)
        )
      )
    :effect
      (and
        (scope_b_bound ?scope_b)
        (service_account_context_initialized ?service_account)
        (service_account_entitlement ?service_account ?entitlement)
        (not
          (entitlement_available ?entitlement)
        )
      )
  )
  (:action finalize_service_scope_entitlement
    :parameters (?service_account - service_account ?scope_b - context_scope_b ?permission - permission ?entitlement - entitlement)
    :precondition
      (and
        (principal_authorized ?service_account)
        (principal_permission_binding ?service_account ?permission)
        (service_account_scope_b_binding ?service_account ?scope_b)
        (scope_b_bound ?scope_b)
        (service_account_entitlement ?service_account ?entitlement)
        (not
          (service_account_context_confirmed ?service_account)
        )
      )
    :effect
      (and
        (scope_b_ready ?scope_b)
        (service_account_context_confirmed ?service_account)
        (entitlement_available ?entitlement)
        (not
          (service_account_entitlement ?service_account ?entitlement)
        )
      )
  )
  (:action compose_access_request
    :parameters (?end_user - end_user ?service_account - service_account ?scope_a - context_scope_a ?scope_b - context_scope_b ?access_request - access_request)
    :precondition
      (and
        (end_user_context_initialized ?end_user)
        (service_account_context_initialized ?service_account)
        (end_user_scope_a_binding ?end_user ?scope_a)
        (service_account_scope_b_binding ?service_account ?scope_b)
        (scope_a_ready ?scope_a)
        (scope_b_ready ?scope_b)
        (end_user_context_confirmed ?end_user)
        (service_account_context_confirmed ?service_account)
        (access_request_pending ?access_request)
      )
    :effect
      (and
        (access_request_qualified ?access_request)
        (access_request_has_scope_a ?access_request ?scope_a)
        (access_request_has_scope_b ?access_request ?scope_b)
        (not
          (access_request_pending ?access_request)
        )
      )
  )
  (:action compose_access_request_option_a
    :parameters (?end_user - end_user ?service_account - service_account ?scope_a - context_scope_a ?scope_b - context_scope_b ?access_request - access_request)
    :precondition
      (and
        (end_user_context_initialized ?end_user)
        (service_account_context_initialized ?service_account)
        (end_user_scope_a_binding ?end_user ?scope_a)
        (service_account_scope_b_binding ?service_account ?scope_b)
        (scope_a_bound ?scope_a)
        (scope_b_ready ?scope_b)
        (not
          (end_user_context_confirmed ?end_user)
        )
        (service_account_context_confirmed ?service_account)
        (access_request_pending ?access_request)
      )
    :effect
      (and
        (access_request_qualified ?access_request)
        (access_request_has_scope_a ?access_request ?scope_a)
        (access_request_has_scope_b ?access_request ?scope_b)
        (access_request_option_a ?access_request)
        (not
          (access_request_pending ?access_request)
        )
      )
  )
  (:action compose_access_request_option_b
    :parameters (?end_user - end_user ?service_account - service_account ?scope_a - context_scope_a ?scope_b - context_scope_b ?access_request - access_request)
    :precondition
      (and
        (end_user_context_initialized ?end_user)
        (service_account_context_initialized ?service_account)
        (end_user_scope_a_binding ?end_user ?scope_a)
        (service_account_scope_b_binding ?service_account ?scope_b)
        (scope_a_ready ?scope_a)
        (scope_b_bound ?scope_b)
        (end_user_context_confirmed ?end_user)
        (not
          (service_account_context_confirmed ?service_account)
        )
        (access_request_pending ?access_request)
      )
    :effect
      (and
        (access_request_qualified ?access_request)
        (access_request_has_scope_a ?access_request ?scope_a)
        (access_request_has_scope_b ?access_request ?scope_b)
        (access_request_option_b ?access_request)
        (not
          (access_request_pending ?access_request)
        )
      )
  )
  (:action compose_access_request_both_options
    :parameters (?end_user - end_user ?service_account - service_account ?scope_a - context_scope_a ?scope_b - context_scope_b ?access_request - access_request)
    :precondition
      (and
        (end_user_context_initialized ?end_user)
        (service_account_context_initialized ?service_account)
        (end_user_scope_a_binding ?end_user ?scope_a)
        (service_account_scope_b_binding ?service_account ?scope_b)
        (scope_a_bound ?scope_a)
        (scope_b_bound ?scope_b)
        (not
          (end_user_context_confirmed ?end_user)
        )
        (not
          (service_account_context_confirmed ?service_account)
        )
        (access_request_pending ?access_request)
      )
    :effect
      (and
        (access_request_qualified ?access_request)
        (access_request_has_scope_a ?access_request ?scope_a)
        (access_request_has_scope_b ?access_request ?scope_b)
        (access_request_option_a ?access_request)
        (access_request_option_b ?access_request)
        (not
          (access_request_pending ?access_request)
        )
      )
  )
  (:action lock_access_request
    :parameters (?access_request - access_request ?end_user - end_user ?permission - permission)
    :precondition
      (and
        (access_request_qualified ?access_request)
        (end_user_context_initialized ?end_user)
        (principal_permission_binding ?end_user ?permission)
        (not
          (access_request_locked ?access_request)
        )
      )
    :effect (access_request_locked ?access_request)
  )
  (:action bind_resource_to_request
    :parameters (?policy_engine - policy_engine ?resource - resource ?access_request - access_request)
    :precondition
      (and
        (principal_authorized ?policy_engine)
        (policy_engine_access_request_binding ?policy_engine ?access_request)
        (policy_engine_resource_binding ?policy_engine ?resource)
        (resource_available ?resource)
        (access_request_qualified ?access_request)
        (access_request_locked ?access_request)
        (not
          (resource_reserved ?resource)
        )
      )
    :effect
      (and
        (resource_reserved ?resource)
        (resource_bound_to_request ?resource ?access_request)
        (not
          (resource_available ?resource)
        )
      )
  )
  (:action prepare_engine_for_evaluation
    :parameters (?policy_engine - policy_engine ?resource - resource ?access_request - access_request ?permission - permission)
    :precondition
      (and
        (principal_authorized ?policy_engine)
        (policy_engine_resource_binding ?policy_engine ?resource)
        (resource_reserved ?resource)
        (resource_bound_to_request ?resource ?access_request)
        (principal_permission_binding ?policy_engine ?permission)
        (not
          (access_request_option_a ?access_request)
        )
        (not
          (policy_engine_evaluation_ready ?policy_engine)
        )
      )
    :effect (policy_engine_evaluation_ready ?policy_engine)
  )
  (:action attach_feature_to_engine
    :parameters (?policy_engine - policy_engine ?feature_flag - feature_flag)
    :precondition
      (and
        (principal_authorized ?policy_engine)
        (feature_flag_available ?feature_flag)
        (not
          (policy_engine_feature_activated ?policy_engine)
        )
      )
    :effect
      (and
        (policy_engine_feature_activated ?policy_engine)
        (policy_engine_feature_link ?policy_engine ?feature_flag)
        (not
          (feature_flag_available ?feature_flag)
        )
      )
  )
  (:action promote_engine_with_feature_and_resource
    :parameters (?policy_engine - policy_engine ?resource - resource ?access_request - access_request ?permission - permission ?feature_flag - feature_flag)
    :precondition
      (and
        (principal_authorized ?policy_engine)
        (policy_engine_resource_binding ?policy_engine ?resource)
        (resource_reserved ?resource)
        (resource_bound_to_request ?resource ?access_request)
        (principal_permission_binding ?policy_engine ?permission)
        (access_request_option_a ?access_request)
        (policy_engine_feature_activated ?policy_engine)
        (policy_engine_feature_link ?policy_engine ?feature_flag)
        (not
          (policy_engine_evaluation_ready ?policy_engine)
        )
      )
    :effect
      (and
        (policy_engine_evaluation_ready ?policy_engine)
        (policy_engine_feature_promoted ?policy_engine)
      )
  )
  (:action advance_engine_evaluation_stage_two
    :parameters (?policy_engine - policy_engine ?credential - credential ?approval_token - approval_token ?resource - resource ?access_request - access_request)
    :precondition
      (and
        (policy_engine_evaluation_ready ?policy_engine)
        (policy_engine_credential_binding ?policy_engine ?credential)
        (principal_approval_link ?policy_engine ?approval_token)
        (policy_engine_resource_binding ?policy_engine ?resource)
        (resource_bound_to_request ?resource ?access_request)
        (not
          (access_request_option_b ?access_request)
        )
        (not
          (policy_engine_authorization_ready ?policy_engine)
        )
      )
    :effect (policy_engine_authorization_ready ?policy_engine)
  )
  (:action advance_engine_evaluation_stage_two_alt
    :parameters (?policy_engine - policy_engine ?credential - credential ?approval_token - approval_token ?resource - resource ?access_request - access_request)
    :precondition
      (and
        (policy_engine_evaluation_ready ?policy_engine)
        (policy_engine_credential_binding ?policy_engine ?credential)
        (principal_approval_link ?policy_engine ?approval_token)
        (policy_engine_resource_binding ?policy_engine ?resource)
        (resource_bound_to_request ?resource ?access_request)
        (access_request_option_b ?access_request)
        (not
          (policy_engine_authorization_ready ?policy_engine)
        )
      )
    :effect (policy_engine_authorization_ready ?policy_engine)
  )
  (:action prepare_engine_issue
    :parameters (?policy_engine - policy_engine ?audit_record - audit_record ?resource - resource ?access_request - access_request)
    :precondition
      (and
        (policy_engine_authorization_ready ?policy_engine)
        (policy_engine_audit_bound ?policy_engine ?audit_record)
        (policy_engine_resource_binding ?policy_engine ?resource)
        (resource_bound_to_request ?resource ?access_request)
        (not
          (access_request_option_a ?access_request)
        )
        (not
          (access_request_option_b ?access_request)
        )
        (not
          (policy_engine_issue_ready ?policy_engine)
        )
      )
    :effect (policy_engine_issue_ready ?policy_engine)
  )
  (:action enable_engine_credentialing
    :parameters (?policy_engine - policy_engine ?audit_record - audit_record ?resource - resource ?access_request - access_request)
    :precondition
      (and
        (policy_engine_authorization_ready ?policy_engine)
        (policy_engine_audit_bound ?policy_engine ?audit_record)
        (policy_engine_resource_binding ?policy_engine ?resource)
        (resource_bound_to_request ?resource ?access_request)
        (access_request_option_a ?access_request)
        (not
          (access_request_option_b ?access_request)
        )
        (not
          (policy_engine_issue_ready ?policy_engine)
        )
      )
    :effect
      (and
        (policy_engine_issue_ready ?policy_engine)
        (policy_engine_credentialing_enabled ?policy_engine)
      )
  )
  (:action enable_engine_credentialing_with_conditions
    :parameters (?policy_engine - policy_engine ?audit_record - audit_record ?resource - resource ?access_request - access_request)
    :precondition
      (and
        (policy_engine_authorization_ready ?policy_engine)
        (policy_engine_audit_bound ?policy_engine ?audit_record)
        (policy_engine_resource_binding ?policy_engine ?resource)
        (resource_bound_to_request ?resource ?access_request)
        (not
          (access_request_option_a ?access_request)
        )
        (access_request_option_b ?access_request)
        (not
          (policy_engine_issue_ready ?policy_engine)
        )
      )
    :effect
      (and
        (policy_engine_issue_ready ?policy_engine)
        (policy_engine_credentialing_enabled ?policy_engine)
      )
  )
  (:action enable_engine_credentialing_full
    :parameters (?policy_engine - policy_engine ?audit_record - audit_record ?resource - resource ?access_request - access_request)
    :precondition
      (and
        (policy_engine_authorization_ready ?policy_engine)
        (policy_engine_audit_bound ?policy_engine ?audit_record)
        (policy_engine_resource_binding ?policy_engine ?resource)
        (resource_bound_to_request ?resource ?access_request)
        (access_request_option_a ?access_request)
        (access_request_option_b ?access_request)
        (not
          (policy_engine_issue_ready ?policy_engine)
        )
      )
    :effect
      (and
        (policy_engine_issue_ready ?policy_engine)
        (policy_engine_credentialing_enabled ?policy_engine)
      )
  )
  (:action finalize_engine_issuance
    :parameters (?policy_engine - policy_engine)
    :precondition
      (and
        (policy_engine_issue_ready ?policy_engine)
        (not
          (policy_engine_credentialing_enabled ?policy_engine)
        )
        (not
          (audit_record_committed ?policy_engine)
        )
      )
    :effect
      (and
        (audit_record_committed ?policy_engine)
        (authorization_grant_issued ?policy_engine)
      )
  )
  (:action attach_constraint_to_engine
    :parameters (?policy_engine - policy_engine ?constraint - constraint)
    :precondition
      (and
        (policy_engine_issue_ready ?policy_engine)
        (policy_engine_credentialing_enabled ?policy_engine)
        (constraint_available ?constraint)
      )
    :effect
      (and
        (policy_engine_constraint_link ?policy_engine ?constraint)
        (not
          (constraint_available ?constraint)
        )
      )
  )
  (:action finalize_engine_evaluation
    :parameters (?policy_engine - policy_engine ?end_user - end_user ?service_account - service_account ?permission - permission ?constraint - constraint)
    :precondition
      (and
        (policy_engine_issue_ready ?policy_engine)
        (policy_engine_credentialing_enabled ?policy_engine)
        (policy_engine_constraint_link ?policy_engine ?constraint)
        (policy_engine_end_user_binding ?policy_engine ?end_user)
        (policy_engine_service_account_binding ?policy_engine ?service_account)
        (end_user_context_confirmed ?end_user)
        (service_account_context_confirmed ?service_account)
        (principal_permission_binding ?policy_engine ?permission)
        (not
          (policy_engine_finalized ?policy_engine)
        )
      )
    :effect (policy_engine_finalized ?policy_engine)
  )
  (:action finalize_engine_audit_and_mark
    :parameters (?policy_engine - policy_engine)
    :precondition
      (and
        (policy_engine_issue_ready ?policy_engine)
        (policy_engine_finalized ?policy_engine)
        (not
          (audit_record_committed ?policy_engine)
        )
      )
    :effect
      (and
        (audit_record_committed ?policy_engine)
        (authorization_grant_issued ?policy_engine)
      )
  )
  (:action activate_engine_delegation
    :parameters (?policy_engine - policy_engine ?delegation_ticket - delegation_ticket ?permission - permission)
    :precondition
      (and
        (principal_authorized ?policy_engine)
        (principal_permission_binding ?policy_engine ?permission)
        (delegation_ticket_available ?delegation_ticket)
        (policy_engine_delegation_binding ?policy_engine ?delegation_ticket)
        (not
          (policy_engine_delegation_activated ?policy_engine)
        )
      )
    :effect
      (and
        (policy_engine_delegation_activated ?policy_engine)
        (not
          (delegation_ticket_available ?delegation_ticket)
        )
      )
  )
  (:action request_engine_approval
    :parameters (?policy_engine - policy_engine ?approval_token - approval_token)
    :precondition
      (and
        (policy_engine_delegation_activated ?policy_engine)
        (principal_approval_link ?policy_engine ?approval_token)
        (not
          (policy_engine_approval_requested ?policy_engine)
        )
      )
    :effect (policy_engine_approval_requested ?policy_engine)
  )
  (:action grant_engine_approval_with_audit
    :parameters (?policy_engine - policy_engine ?audit_record - audit_record)
    :precondition
      (and
        (policy_engine_approval_requested ?policy_engine)
        (policy_engine_audit_bound ?policy_engine ?audit_record)
        (not
          (policy_engine_approval_granted ?policy_engine)
        )
      )
    :effect (policy_engine_approval_granted ?policy_engine)
  )
  (:action commit_engine_approval
    :parameters (?policy_engine - policy_engine)
    :precondition
      (and
        (policy_engine_approval_granted ?policy_engine)
        (not
          (audit_record_committed ?policy_engine)
        )
      )
    :effect
      (and
        (audit_record_committed ?policy_engine)
        (authorization_grant_issued ?policy_engine)
      )
  )
  (:action grant_principal_access
    :parameters (?end_user - end_user ?access_request - access_request)
    :precondition
      (and
        (end_user_context_initialized ?end_user)
        (end_user_context_confirmed ?end_user)
        (access_request_qualified ?access_request)
        (access_request_locked ?access_request)
        (not
          (authorization_grant_issued ?end_user)
        )
      )
    :effect (authorization_grant_issued ?end_user)
  )
  (:action grant_service_account_access
    :parameters (?service_account - service_account ?access_request - access_request)
    :precondition
      (and
        (service_account_context_initialized ?service_account)
        (service_account_context_confirmed ?service_account)
        (access_request_qualified ?access_request)
        (access_request_locked ?access_request)
        (not
          (authorization_grant_issued ?service_account)
        )
      )
    :effect (authorization_grant_issued ?service_account)
  )
  (:action finalize_principal_verification
    :parameters (?principal - principal ?policy_document - policy_document ?permission - permission)
    :precondition
      (and
        (authorization_grant_issued ?principal)
        (principal_permission_binding ?principal ?permission)
        (policy_document_available ?policy_document)
        (not
          (identity_verified ?principal)
        )
      )
    :effect
      (and
        (identity_verified ?principal)
        (principal_policy_document_binding ?principal ?policy_document)
        (not
          (policy_document_available ?policy_document)
        )
      )
  )
  (:action activate_principal_with_role
    :parameters (?end_user - end_user ?role - rbac_role ?policy_document - policy_document)
    :precondition
      (and
        (identity_verified ?end_user)
        (principal_role_binding ?end_user ?role)
        (principal_policy_document_binding ?end_user ?policy_document)
        (not
          (principal_active ?end_user)
        )
      )
    :effect
      (and
        (principal_active ?end_user)
        (role_available ?role)
        (policy_document_available ?policy_document)
      )
  )
  (:action activate_service_account_with_role
    :parameters (?service_account - service_account ?role - rbac_role ?policy_document - policy_document)
    :precondition
      (and
        (identity_verified ?service_account)
        (principal_role_binding ?service_account ?role)
        (principal_policy_document_binding ?service_account ?policy_document)
        (not
          (principal_active ?service_account)
        )
      )
    :effect
      (and
        (principal_active ?service_account)
        (role_available ?role)
        (policy_document_available ?policy_document)
      )
  )
  (:action activate_engine_with_role
    :parameters (?policy_engine - policy_engine ?role - rbac_role ?policy_document - policy_document)
    :precondition
      (and
        (identity_verified ?policy_engine)
        (principal_role_binding ?policy_engine ?role)
        (principal_policy_document_binding ?policy_engine ?policy_document)
        (not
          (principal_active ?policy_engine)
        )
      )
    :effect
      (and
        (principal_active ?policy_engine)
        (role_available ?role)
        (policy_document_available ?policy_document)
      )
  )
)

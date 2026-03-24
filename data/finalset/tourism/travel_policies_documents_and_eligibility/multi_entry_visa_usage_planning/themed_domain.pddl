(define (domain multi_entry_visa_usage_planning)
  (:requirements :strips :typing :negative-preconditions)
  (:types visa_domain_resource - object entry_requirement_domain - object passenger_requirement_domain - object domain_root - object profile_entity - domain_root visa_product - visa_domain_resource entry_leg - visa_domain_resource supporting_document_item - visa_domain_resource special_authorization - visa_domain_resource fare_condition - visa_domain_resource nationality - visa_domain_resource health_certificate - visa_domain_resource consular_exception_request - visa_domain_resource fare_option - entry_requirement_domain supporting_document_type - entry_requirement_domain prior_visit_record - entry_requirement_domain primary_entry_requirement - passenger_requirement_domain companion_entry_requirement - passenger_requirement_domain visa_entitlement_record - passenger_requirement_domain passenger_role - profile_entity case_role - profile_entity primary_passenger - passenger_role companion_passenger - passenger_role visa_case - case_role)
  (:predicates
    (profile_registered ?traveler_profile - profile_entity)
    (profile_verified ?traveler_profile - profile_entity)
    (visa_product_assigned ?traveler_profile - profile_entity)
    (usage_authorized ?traveler_profile - profile_entity)
    (clearance_granted ?traveler_profile - profile_entity)
    (profile_entitlement_allocated ?traveler_profile - profile_entity)
    (visa_product_available ?visa_product - visa_product)
    (profile_assigned_visa_product ?traveler_profile - profile_entity ?visa_product - visa_product)
    (entry_leg_available ?entry_leg - entry_leg)
    (profile_leg_linked ?traveler_profile - profile_entity ?entry_leg - entry_leg)
    (supporting_document_available ?supporting_document_item - supporting_document_item)
    (profile_attached_supporting_document ?traveler_profile - profile_entity ?supporting_document_item - supporting_document_item)
    (fare_option_available ?fare_option - fare_option)
    (primary_passenger_has_fare_option ?primary_passenger - primary_passenger ?fare_option - fare_option)
    (companion_passenger_has_fare_option ?companion_passenger - companion_passenger ?fare_option - fare_option)
    (primary_passenger_has_entry_requirement ?primary_passenger - primary_passenger ?primary_entry_requirement - primary_entry_requirement)
    (primary_requirement_verified ?primary_entry_requirement - primary_entry_requirement)
    (primary_requirement_verified_via_fare ?primary_entry_requirement - primary_entry_requirement)
    (primary_passenger_requirement_satisfied ?primary_passenger - primary_passenger)
    (companion_passenger_has_entry_requirement ?companion_passenger - companion_passenger ?companion_entry_requirement - companion_entry_requirement)
    (companion_requirement_verified ?companion_entry_requirement - companion_entry_requirement)
    (companion_requirement_verified_via_fare ?companion_entry_requirement - companion_entry_requirement)
    (companion_passenger_requirement_satisfied ?companion_passenger - companion_passenger)
    (entitlement_record_available ?visa_entitlement_record - visa_entitlement_record)
    (entitlement_record_allocated ?visa_entitlement_record - visa_entitlement_record)
    (entitlement_links_primary_requirement ?visa_entitlement_record - visa_entitlement_record ?primary_entry_requirement - primary_entry_requirement)
    (entitlement_links_companion_requirement ?visa_entitlement_record - visa_entitlement_record ?companion_entry_requirement - companion_entry_requirement)
    (entitlement_primary_verified_by_fare ?visa_entitlement_record - visa_entitlement_record)
    (entitlement_companion_verified_by_fare ?visa_entitlement_record - visa_entitlement_record)
    (entitlement_validated ?visa_entitlement_record - visa_entitlement_record)
    (case_has_primary_passenger ?visa_case - visa_case ?primary_passenger - primary_passenger)
    (case_has_companion_passenger ?visa_case - visa_case ?companion_passenger - companion_passenger)
    (case_has_entitlement_record ?visa_case - visa_case ?visa_entitlement_record - visa_entitlement_record)
    (supporting_document_type_available ?supporting_document_type - supporting_document_type)
    (case_requires_document_type ?visa_case - visa_case ?supporting_document_type - supporting_document_type)
    (supporting_document_type_bound ?supporting_document_type - supporting_document_type)
    (supporting_document_type_linked_to_entitlement ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record)
    (case_document_binding_confirmed ?visa_case - visa_case)
    (case_documentation_validated ?visa_case - visa_case)
    (case_adjudication_triggered ?visa_case - visa_case)
    (case_special_authorization_flag ?visa_case - visa_case)
    (case_special_authorization_validated ?visa_case - visa_case)
    (case_ready_for_fare_condition_binding ?visa_case - visa_case)
    (case_final_verification_completed ?visa_case - visa_case)
    (prior_visit_record_available ?prior_visit_record - prior_visit_record)
    (case_has_prior_visit_record ?visa_case - visa_case ?prior_visit_record - prior_visit_record)
    (case_prior_visit_verified ?visa_case - visa_case)
    (case_prior_visit_check_confirmed ?visa_case - visa_case)
    (case_prior_visit_adjudicated ?visa_case - visa_case)
    (special_authorization_available ?special_authorization - special_authorization)
    (case_linked_special_authorization ?visa_case - visa_case ?special_authorization - special_authorization)
    (fare_condition_available ?fare_condition - fare_condition)
    (case_has_fare_condition ?visa_case - visa_case ?fare_condition - fare_condition)
    (health_certificate_available ?health_certificate - health_certificate)
    (case_has_health_certificate ?visa_case - visa_case ?health_certificate - health_certificate)
    (consular_exception_request_available ?consular_exception_request - consular_exception_request)
    (case_has_consular_exception_request ?visa_case - visa_case ?consular_exception_request - consular_exception_request)
    (nationality_available ?nationality - nationality)
    (profile_has_nationality ?traveler_profile - profile_entity ?nationality - nationality)
    (primary_passenger_ready_for_entitlement ?primary_passenger - primary_passenger)
    (companion_passenger_ready_for_entitlement ?companion_passenger - companion_passenger)
    (case_decision_recorded ?visa_case - visa_case)
  )
  (:action intake_traveler_profile
    :parameters (?traveler_profile - profile_entity)
    :precondition
      (and
        (not
          (profile_registered ?traveler_profile)
        )
        (not
          (usage_authorized ?traveler_profile)
        )
      )
    :effect (profile_registered ?traveler_profile)
  )
  (:action assign_visa_product_to_profile
    :parameters (?traveler_profile - profile_entity ?visa_product - visa_product)
    :precondition
      (and
        (profile_registered ?traveler_profile)
        (not
          (visa_product_assigned ?traveler_profile)
        )
        (visa_product_available ?visa_product)
      )
    :effect
      (and
        (visa_product_assigned ?traveler_profile)
        (profile_assigned_visa_product ?traveler_profile ?visa_product)
        (not
          (visa_product_available ?visa_product)
        )
      )
  )
  (:action link_profile_to_entry_leg
    :parameters (?traveler_profile - profile_entity ?entry_leg - entry_leg)
    :precondition
      (and
        (profile_registered ?traveler_profile)
        (visa_product_assigned ?traveler_profile)
        (entry_leg_available ?entry_leg)
      )
    :effect
      (and
        (profile_leg_linked ?traveler_profile ?entry_leg)
        (not
          (entry_leg_available ?entry_leg)
        )
      )
  )
  (:action verify_profile_for_processing
    :parameters (?traveler_profile - profile_entity ?entry_leg - entry_leg)
    :precondition
      (and
        (profile_registered ?traveler_profile)
        (visa_product_assigned ?traveler_profile)
        (profile_leg_linked ?traveler_profile ?entry_leg)
        (not
          (profile_verified ?traveler_profile)
        )
      )
    :effect (profile_verified ?traveler_profile)
  )
  (:action release_entry_leg_from_profile
    :parameters (?traveler_profile - profile_entity ?entry_leg - entry_leg)
    :precondition
      (and
        (profile_leg_linked ?traveler_profile ?entry_leg)
      )
    :effect
      (and
        (entry_leg_available ?entry_leg)
        (not
          (profile_leg_linked ?traveler_profile ?entry_leg)
        )
      )
  )
  (:action attach_supporting_document_to_profile
    :parameters (?traveler_profile - profile_entity ?supporting_document_item - supporting_document_item)
    :precondition
      (and
        (profile_verified ?traveler_profile)
        (supporting_document_available ?supporting_document_item)
      )
    :effect
      (and
        (profile_attached_supporting_document ?traveler_profile ?supporting_document_item)
        (not
          (supporting_document_available ?supporting_document_item)
        )
      )
  )
  (:action detach_supporting_document_from_profile
    :parameters (?traveler_profile - profile_entity ?supporting_document_item - supporting_document_item)
    :precondition
      (and
        (profile_attached_supporting_document ?traveler_profile ?supporting_document_item)
      )
    :effect
      (and
        (supporting_document_available ?supporting_document_item)
        (not
          (profile_attached_supporting_document ?traveler_profile ?supporting_document_item)
        )
      )
  )
  (:action attach_health_certificate_to_case
    :parameters (?visa_case - visa_case ?health_certificate - health_certificate)
    :precondition
      (and
        (profile_verified ?visa_case)
        (health_certificate_available ?health_certificate)
      )
    :effect
      (and
        (case_has_health_certificate ?visa_case ?health_certificate)
        (not
          (health_certificate_available ?health_certificate)
        )
      )
  )
  (:action detach_health_certificate_from_case
    :parameters (?visa_case - visa_case ?health_certificate - health_certificate)
    :precondition
      (and
        (case_has_health_certificate ?visa_case ?health_certificate)
      )
    :effect
      (and
        (health_certificate_available ?health_certificate)
        (not
          (case_has_health_certificate ?visa_case ?health_certificate)
        )
      )
  )
  (:action attach_consular_exception_to_case
    :parameters (?visa_case - visa_case ?consular_exception_request - consular_exception_request)
    :precondition
      (and
        (profile_verified ?visa_case)
        (consular_exception_request_available ?consular_exception_request)
      )
    :effect
      (and
        (case_has_consular_exception_request ?visa_case ?consular_exception_request)
        (not
          (consular_exception_request_available ?consular_exception_request)
        )
      )
  )
  (:action detach_consular_exception_from_case
    :parameters (?visa_case - visa_case ?consular_exception_request - consular_exception_request)
    :precondition
      (and
        (case_has_consular_exception_request ?visa_case ?consular_exception_request)
      )
    :effect
      (and
        (consular_exception_request_available ?consular_exception_request)
        (not
          (case_has_consular_exception_request ?visa_case ?consular_exception_request)
        )
      )
  )
  (:action evaluate_primary_entry_requirement
    :parameters (?primary_passenger - primary_passenger ?primary_entry_requirement - primary_entry_requirement ?entry_leg - entry_leg)
    :precondition
      (and
        (profile_verified ?primary_passenger)
        (profile_leg_linked ?primary_passenger ?entry_leg)
        (primary_passenger_has_entry_requirement ?primary_passenger ?primary_entry_requirement)
        (not
          (primary_requirement_verified ?primary_entry_requirement)
        )
        (not
          (primary_requirement_verified_via_fare ?primary_entry_requirement)
        )
      )
    :effect (primary_requirement_verified ?primary_entry_requirement)
  )
  (:action validate_primary_requirement_with_document
    :parameters (?primary_passenger - primary_passenger ?primary_entry_requirement - primary_entry_requirement ?supporting_document_item - supporting_document_item)
    :precondition
      (and
        (profile_verified ?primary_passenger)
        (profile_attached_supporting_document ?primary_passenger ?supporting_document_item)
        (primary_passenger_has_entry_requirement ?primary_passenger ?primary_entry_requirement)
        (primary_requirement_verified ?primary_entry_requirement)
        (not
          (primary_passenger_ready_for_entitlement ?primary_passenger)
        )
      )
    :effect
      (and
        (primary_passenger_ready_for_entitlement ?primary_passenger)
        (primary_passenger_requirement_satisfied ?primary_passenger)
      )
  )
  (:action validate_primary_requirement_with_fare
    :parameters (?primary_passenger - primary_passenger ?primary_entry_requirement - primary_entry_requirement ?fare_option - fare_option)
    :precondition
      (and
        (profile_verified ?primary_passenger)
        (primary_passenger_has_entry_requirement ?primary_passenger ?primary_entry_requirement)
        (fare_option_available ?fare_option)
        (not
          (primary_passenger_ready_for_entitlement ?primary_passenger)
        )
      )
    :effect
      (and
        (primary_requirement_verified_via_fare ?primary_entry_requirement)
        (primary_passenger_ready_for_entitlement ?primary_passenger)
        (primary_passenger_has_fare_option ?primary_passenger ?fare_option)
        (not
          (fare_option_available ?fare_option)
        )
      )
  )
  (:action reconcile_primary_requirement
    :parameters (?primary_passenger - primary_passenger ?primary_entry_requirement - primary_entry_requirement ?entry_leg - entry_leg ?fare_option - fare_option)
    :precondition
      (and
        (profile_verified ?primary_passenger)
        (profile_leg_linked ?primary_passenger ?entry_leg)
        (primary_passenger_has_entry_requirement ?primary_passenger ?primary_entry_requirement)
        (primary_requirement_verified_via_fare ?primary_entry_requirement)
        (primary_passenger_has_fare_option ?primary_passenger ?fare_option)
        (not
          (primary_passenger_requirement_satisfied ?primary_passenger)
        )
      )
    :effect
      (and
        (primary_requirement_verified ?primary_entry_requirement)
        (primary_passenger_requirement_satisfied ?primary_passenger)
        (fare_option_available ?fare_option)
        (not
          (primary_passenger_has_fare_option ?primary_passenger ?fare_option)
        )
      )
  )
  (:action evaluate_companion_entry_requirement
    :parameters (?companion_passenger - companion_passenger ?companion_entry_requirement - companion_entry_requirement ?entry_leg - entry_leg)
    :precondition
      (and
        (profile_verified ?companion_passenger)
        (profile_leg_linked ?companion_passenger ?entry_leg)
        (companion_passenger_has_entry_requirement ?companion_passenger ?companion_entry_requirement)
        (not
          (companion_requirement_verified ?companion_entry_requirement)
        )
        (not
          (companion_requirement_verified_via_fare ?companion_entry_requirement)
        )
      )
    :effect (companion_requirement_verified ?companion_entry_requirement)
  )
  (:action validate_companion_requirement_with_document
    :parameters (?companion_passenger - companion_passenger ?companion_entry_requirement - companion_entry_requirement ?supporting_document_item - supporting_document_item)
    :precondition
      (and
        (profile_verified ?companion_passenger)
        (profile_attached_supporting_document ?companion_passenger ?supporting_document_item)
        (companion_passenger_has_entry_requirement ?companion_passenger ?companion_entry_requirement)
        (companion_requirement_verified ?companion_entry_requirement)
        (not
          (companion_passenger_ready_for_entitlement ?companion_passenger)
        )
      )
    :effect
      (and
        (companion_passenger_ready_for_entitlement ?companion_passenger)
        (companion_passenger_requirement_satisfied ?companion_passenger)
      )
  )
  (:action validate_companion_requirement_with_fare
    :parameters (?companion_passenger - companion_passenger ?companion_entry_requirement - companion_entry_requirement ?fare_option - fare_option)
    :precondition
      (and
        (profile_verified ?companion_passenger)
        (companion_passenger_has_entry_requirement ?companion_passenger ?companion_entry_requirement)
        (fare_option_available ?fare_option)
        (not
          (companion_passenger_ready_for_entitlement ?companion_passenger)
        )
      )
    :effect
      (and
        (companion_requirement_verified_via_fare ?companion_entry_requirement)
        (companion_passenger_ready_for_entitlement ?companion_passenger)
        (companion_passenger_has_fare_option ?companion_passenger ?fare_option)
        (not
          (fare_option_available ?fare_option)
        )
      )
  )
  (:action reconcile_companion_requirement
    :parameters (?companion_passenger - companion_passenger ?companion_entry_requirement - companion_entry_requirement ?entry_leg - entry_leg ?fare_option - fare_option)
    :precondition
      (and
        (profile_verified ?companion_passenger)
        (profile_leg_linked ?companion_passenger ?entry_leg)
        (companion_passenger_has_entry_requirement ?companion_passenger ?companion_entry_requirement)
        (companion_requirement_verified_via_fare ?companion_entry_requirement)
        (companion_passenger_has_fare_option ?companion_passenger ?fare_option)
        (not
          (companion_passenger_requirement_satisfied ?companion_passenger)
        )
      )
    :effect
      (and
        (companion_requirement_verified ?companion_entry_requirement)
        (companion_passenger_requirement_satisfied ?companion_passenger)
        (fare_option_available ?fare_option)
        (not
          (companion_passenger_has_fare_option ?companion_passenger ?fare_option)
        )
      )
  )
  (:action assemble_visa_entitlement_record
    :parameters (?primary_passenger - primary_passenger ?companion_passenger - companion_passenger ?primary_entry_requirement - primary_entry_requirement ?companion_entry_requirement - companion_entry_requirement ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (primary_passenger_ready_for_entitlement ?primary_passenger)
        (companion_passenger_ready_for_entitlement ?companion_passenger)
        (primary_passenger_has_entry_requirement ?primary_passenger ?primary_entry_requirement)
        (companion_passenger_has_entry_requirement ?companion_passenger ?companion_entry_requirement)
        (primary_requirement_verified ?primary_entry_requirement)
        (companion_requirement_verified ?companion_entry_requirement)
        (primary_passenger_requirement_satisfied ?primary_passenger)
        (companion_passenger_requirement_satisfied ?companion_passenger)
        (entitlement_record_available ?visa_entitlement_record)
      )
    :effect
      (and
        (entitlement_record_allocated ?visa_entitlement_record)
        (entitlement_links_primary_requirement ?visa_entitlement_record ?primary_entry_requirement)
        (entitlement_links_companion_requirement ?visa_entitlement_record ?companion_entry_requirement)
        (not
          (entitlement_record_available ?visa_entitlement_record)
        )
      )
  )
  (:action assemble_visa_entitlement_record_primary_fare
    :parameters (?primary_passenger - primary_passenger ?companion_passenger - companion_passenger ?primary_entry_requirement - primary_entry_requirement ?companion_entry_requirement - companion_entry_requirement ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (primary_passenger_ready_for_entitlement ?primary_passenger)
        (companion_passenger_ready_for_entitlement ?companion_passenger)
        (primary_passenger_has_entry_requirement ?primary_passenger ?primary_entry_requirement)
        (companion_passenger_has_entry_requirement ?companion_passenger ?companion_entry_requirement)
        (primary_requirement_verified_via_fare ?primary_entry_requirement)
        (companion_requirement_verified ?companion_entry_requirement)
        (not
          (primary_passenger_requirement_satisfied ?primary_passenger)
        )
        (companion_passenger_requirement_satisfied ?companion_passenger)
        (entitlement_record_available ?visa_entitlement_record)
      )
    :effect
      (and
        (entitlement_record_allocated ?visa_entitlement_record)
        (entitlement_links_primary_requirement ?visa_entitlement_record ?primary_entry_requirement)
        (entitlement_links_companion_requirement ?visa_entitlement_record ?companion_entry_requirement)
        (entitlement_primary_verified_by_fare ?visa_entitlement_record)
        (not
          (entitlement_record_available ?visa_entitlement_record)
        )
      )
  )
  (:action assemble_visa_entitlement_record_companion_fare
    :parameters (?primary_passenger - primary_passenger ?companion_passenger - companion_passenger ?primary_entry_requirement - primary_entry_requirement ?companion_entry_requirement - companion_entry_requirement ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (primary_passenger_ready_for_entitlement ?primary_passenger)
        (companion_passenger_ready_for_entitlement ?companion_passenger)
        (primary_passenger_has_entry_requirement ?primary_passenger ?primary_entry_requirement)
        (companion_passenger_has_entry_requirement ?companion_passenger ?companion_entry_requirement)
        (primary_requirement_verified ?primary_entry_requirement)
        (companion_requirement_verified_via_fare ?companion_entry_requirement)
        (primary_passenger_requirement_satisfied ?primary_passenger)
        (not
          (companion_passenger_requirement_satisfied ?companion_passenger)
        )
        (entitlement_record_available ?visa_entitlement_record)
      )
    :effect
      (and
        (entitlement_record_allocated ?visa_entitlement_record)
        (entitlement_links_primary_requirement ?visa_entitlement_record ?primary_entry_requirement)
        (entitlement_links_companion_requirement ?visa_entitlement_record ?companion_entry_requirement)
        (entitlement_companion_verified_by_fare ?visa_entitlement_record)
        (not
          (entitlement_record_available ?visa_entitlement_record)
        )
      )
  )
  (:action assemble_visa_entitlement_record_both_fares
    :parameters (?primary_passenger - primary_passenger ?companion_passenger - companion_passenger ?primary_entry_requirement - primary_entry_requirement ?companion_entry_requirement - companion_entry_requirement ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (primary_passenger_ready_for_entitlement ?primary_passenger)
        (companion_passenger_ready_for_entitlement ?companion_passenger)
        (primary_passenger_has_entry_requirement ?primary_passenger ?primary_entry_requirement)
        (companion_passenger_has_entry_requirement ?companion_passenger ?companion_entry_requirement)
        (primary_requirement_verified_via_fare ?primary_entry_requirement)
        (companion_requirement_verified_via_fare ?companion_entry_requirement)
        (not
          (primary_passenger_requirement_satisfied ?primary_passenger)
        )
        (not
          (companion_passenger_requirement_satisfied ?companion_passenger)
        )
        (entitlement_record_available ?visa_entitlement_record)
      )
    :effect
      (and
        (entitlement_record_allocated ?visa_entitlement_record)
        (entitlement_links_primary_requirement ?visa_entitlement_record ?primary_entry_requirement)
        (entitlement_links_companion_requirement ?visa_entitlement_record ?companion_entry_requirement)
        (entitlement_primary_verified_by_fare ?visa_entitlement_record)
        (entitlement_companion_verified_by_fare ?visa_entitlement_record)
        (not
          (entitlement_record_available ?visa_entitlement_record)
        )
      )
  )
  (:action validate_entitlement_record
    :parameters (?visa_entitlement_record - visa_entitlement_record ?primary_passenger - primary_passenger ?entry_leg - entry_leg)
    :precondition
      (and
        (entitlement_record_allocated ?visa_entitlement_record)
        (primary_passenger_ready_for_entitlement ?primary_passenger)
        (profile_leg_linked ?primary_passenger ?entry_leg)
        (not
          (entitlement_validated ?visa_entitlement_record)
        )
      )
    :effect (entitlement_validated ?visa_entitlement_record)
  )
  (:action bind_document_type_to_case_and_entitlement
    :parameters (?visa_case - visa_case ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (profile_verified ?visa_case)
        (case_has_entitlement_record ?visa_case ?visa_entitlement_record)
        (case_requires_document_type ?visa_case ?supporting_document_type)
        (supporting_document_type_available ?supporting_document_type)
        (entitlement_record_allocated ?visa_entitlement_record)
        (entitlement_validated ?visa_entitlement_record)
        (not
          (supporting_document_type_bound ?supporting_document_type)
        )
      )
    :effect
      (and
        (supporting_document_type_bound ?supporting_document_type)
        (supporting_document_type_linked_to_entitlement ?supporting_document_type ?visa_entitlement_record)
        (not
          (supporting_document_type_available ?supporting_document_type)
        )
      )
  )
  (:action confirm_document_binding_for_case
    :parameters (?visa_case - visa_case ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record ?entry_leg - entry_leg)
    :precondition
      (and
        (profile_verified ?visa_case)
        (case_requires_document_type ?visa_case ?supporting_document_type)
        (supporting_document_type_bound ?supporting_document_type)
        (supporting_document_type_linked_to_entitlement ?supporting_document_type ?visa_entitlement_record)
        (profile_leg_linked ?visa_case ?entry_leg)
        (not
          (entitlement_primary_verified_by_fare ?visa_entitlement_record)
        )
        (not
          (case_document_binding_confirmed ?visa_case)
        )
      )
    :effect (case_document_binding_confirmed ?visa_case)
  )
  (:action attach_special_authorization_to_case
    :parameters (?visa_case - visa_case ?special_authorization - special_authorization)
    :precondition
      (and
        (profile_verified ?visa_case)
        (special_authorization_available ?special_authorization)
        (not
          (case_special_authorization_flag ?visa_case)
        )
      )
    :effect
      (and
        (case_special_authorization_flag ?visa_case)
        (case_linked_special_authorization ?visa_case ?special_authorization)
        (not
          (special_authorization_available ?special_authorization)
        )
      )
  )
  (:action validate_special_authorization_and_bindings
    :parameters (?visa_case - visa_case ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record ?entry_leg - entry_leg ?special_authorization - special_authorization)
    :precondition
      (and
        (profile_verified ?visa_case)
        (case_requires_document_type ?visa_case ?supporting_document_type)
        (supporting_document_type_bound ?supporting_document_type)
        (supporting_document_type_linked_to_entitlement ?supporting_document_type ?visa_entitlement_record)
        (profile_leg_linked ?visa_case ?entry_leg)
        (entitlement_primary_verified_by_fare ?visa_entitlement_record)
        (case_special_authorization_flag ?visa_case)
        (case_linked_special_authorization ?visa_case ?special_authorization)
        (not
          (case_document_binding_confirmed ?visa_case)
        )
      )
    :effect
      (and
        (case_document_binding_confirmed ?visa_case)
        (case_special_authorization_validated ?visa_case)
      )
  )
  (:action validate_case_documentation_with_health_certificate
    :parameters (?visa_case - visa_case ?health_certificate - health_certificate ?supporting_document_item - supporting_document_item ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (case_document_binding_confirmed ?visa_case)
        (case_has_health_certificate ?visa_case ?health_certificate)
        (profile_attached_supporting_document ?visa_case ?supporting_document_item)
        (case_requires_document_type ?visa_case ?supporting_document_type)
        (supporting_document_type_linked_to_entitlement ?supporting_document_type ?visa_entitlement_record)
        (not
          (entitlement_companion_verified_by_fare ?visa_entitlement_record)
        )
        (not
          (case_documentation_validated ?visa_case)
        )
      )
    :effect (case_documentation_validated ?visa_case)
  )
  (:action validate_case_documentation_with_health_certificate_variant
    :parameters (?visa_case - visa_case ?health_certificate - health_certificate ?supporting_document_item - supporting_document_item ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (case_document_binding_confirmed ?visa_case)
        (case_has_health_certificate ?visa_case ?health_certificate)
        (profile_attached_supporting_document ?visa_case ?supporting_document_item)
        (case_requires_document_type ?visa_case ?supporting_document_type)
        (supporting_document_type_linked_to_entitlement ?supporting_document_type ?visa_entitlement_record)
        (entitlement_companion_verified_by_fare ?visa_entitlement_record)
        (not
          (case_documentation_validated ?visa_case)
        )
      )
    :effect (case_documentation_validated ?visa_case)
  )
  (:action process_consular_exception_and_mark_verification
    :parameters (?visa_case - visa_case ?consular_exception_request - consular_exception_request ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (case_documentation_validated ?visa_case)
        (case_has_consular_exception_request ?visa_case ?consular_exception_request)
        (case_requires_document_type ?visa_case ?supporting_document_type)
        (supporting_document_type_linked_to_entitlement ?supporting_document_type ?visa_entitlement_record)
        (not
          (entitlement_primary_verified_by_fare ?visa_entitlement_record)
        )
        (not
          (entitlement_companion_verified_by_fare ?visa_entitlement_record)
        )
        (not
          (case_adjudication_triggered ?visa_case)
        )
      )
    :effect (case_adjudication_triggered ?visa_case)
  )
  (:action process_consular_exception_and_add_verification_flag
    :parameters (?visa_case - visa_case ?consular_exception_request - consular_exception_request ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (case_documentation_validated ?visa_case)
        (case_has_consular_exception_request ?visa_case ?consular_exception_request)
        (case_requires_document_type ?visa_case ?supporting_document_type)
        (supporting_document_type_linked_to_entitlement ?supporting_document_type ?visa_entitlement_record)
        (entitlement_primary_verified_by_fare ?visa_entitlement_record)
        (not
          (entitlement_companion_verified_by_fare ?visa_entitlement_record)
        )
        (not
          (case_adjudication_triggered ?visa_case)
        )
      )
    :effect
      (and
        (case_adjudication_triggered ?visa_case)
        (case_ready_for_fare_condition_binding ?visa_case)
      )
  )
  (:action process_consular_exception_and_add_verification_flag_variant
    :parameters (?visa_case - visa_case ?consular_exception_request - consular_exception_request ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (case_documentation_validated ?visa_case)
        (case_has_consular_exception_request ?visa_case ?consular_exception_request)
        (case_requires_document_type ?visa_case ?supporting_document_type)
        (supporting_document_type_linked_to_entitlement ?supporting_document_type ?visa_entitlement_record)
        (not
          (entitlement_primary_verified_by_fare ?visa_entitlement_record)
        )
        (entitlement_companion_verified_by_fare ?visa_entitlement_record)
        (not
          (case_adjudication_triggered ?visa_case)
        )
      )
    :effect
      (and
        (case_adjudication_triggered ?visa_case)
        (case_ready_for_fare_condition_binding ?visa_case)
      )
  )
  (:action process_consular_exception_and_confirm
    :parameters (?visa_case - visa_case ?consular_exception_request - consular_exception_request ?supporting_document_type - supporting_document_type ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (case_documentation_validated ?visa_case)
        (case_has_consular_exception_request ?visa_case ?consular_exception_request)
        (case_requires_document_type ?visa_case ?supporting_document_type)
        (supporting_document_type_linked_to_entitlement ?supporting_document_type ?visa_entitlement_record)
        (entitlement_primary_verified_by_fare ?visa_entitlement_record)
        (entitlement_companion_verified_by_fare ?visa_entitlement_record)
        (not
          (case_adjudication_triggered ?visa_case)
        )
      )
    :effect
      (and
        (case_adjudication_triggered ?visa_case)
        (case_ready_for_fare_condition_binding ?visa_case)
      )
  )
  (:action finalize_case_and_grant_clearance
    :parameters (?visa_case - visa_case)
    :precondition
      (and
        (case_adjudication_triggered ?visa_case)
        (not
          (case_ready_for_fare_condition_binding ?visa_case)
        )
        (not
          (case_decision_recorded ?visa_case)
        )
      )
    :effect
      (and
        (case_decision_recorded ?visa_case)
        (clearance_granted ?visa_case)
      )
  )
  (:action attach_fare_condition_to_case
    :parameters (?visa_case - visa_case ?fare_condition - fare_condition)
    :precondition
      (and
        (case_adjudication_triggered ?visa_case)
        (case_ready_for_fare_condition_binding ?visa_case)
        (fare_condition_available ?fare_condition)
      )
    :effect
      (and
        (case_has_fare_condition ?visa_case ?fare_condition)
        (not
          (fare_condition_available ?fare_condition)
        )
      )
  )
  (:action complete_case_verification
    :parameters (?visa_case - visa_case ?primary_passenger - primary_passenger ?companion_passenger - companion_passenger ?entry_leg - entry_leg ?fare_condition - fare_condition)
    :precondition
      (and
        (case_adjudication_triggered ?visa_case)
        (case_ready_for_fare_condition_binding ?visa_case)
        (case_has_fare_condition ?visa_case ?fare_condition)
        (case_has_primary_passenger ?visa_case ?primary_passenger)
        (case_has_companion_passenger ?visa_case ?companion_passenger)
        (primary_passenger_requirement_satisfied ?primary_passenger)
        (companion_passenger_requirement_satisfied ?companion_passenger)
        (profile_leg_linked ?visa_case ?entry_leg)
        (not
          (case_final_verification_completed ?visa_case)
        )
      )
    :effect (case_final_verification_completed ?visa_case)
  )
  (:action issue_case_clearance
    :parameters (?visa_case - visa_case)
    :precondition
      (and
        (case_adjudication_triggered ?visa_case)
        (case_final_verification_completed ?visa_case)
        (not
          (case_decision_recorded ?visa_case)
        )
      )
    :effect
      (and
        (case_decision_recorded ?visa_case)
        (clearance_granted ?visa_case)
      )
  )
  (:action verify_prior_visit_for_case
    :parameters (?visa_case - visa_case ?prior_visit_record - prior_visit_record ?entry_leg - entry_leg)
    :precondition
      (and
        (profile_verified ?visa_case)
        (profile_leg_linked ?visa_case ?entry_leg)
        (prior_visit_record_available ?prior_visit_record)
        (case_has_prior_visit_record ?visa_case ?prior_visit_record)
        (not
          (case_prior_visit_verified ?visa_case)
        )
      )
    :effect
      (and
        (case_prior_visit_verified ?visa_case)
        (not
          (prior_visit_record_available ?prior_visit_record)
        )
      )
  )
  (:action apply_prior_visit_to_case
    :parameters (?visa_case - visa_case ?supporting_document_item - supporting_document_item)
    :precondition
      (and
        (case_prior_visit_verified ?visa_case)
        (profile_attached_supporting_document ?visa_case ?supporting_document_item)
        (not
          (case_prior_visit_check_confirmed ?visa_case)
        )
      )
    :effect (case_prior_visit_check_confirmed ?visa_case)
  )
  (:action evaluate_consular_exception
    :parameters (?visa_case - visa_case ?consular_exception_request - consular_exception_request)
    :precondition
      (and
        (case_prior_visit_check_confirmed ?visa_case)
        (case_has_consular_exception_request ?visa_case ?consular_exception_request)
        (not
          (case_prior_visit_adjudicated ?visa_case)
        )
      )
    :effect (case_prior_visit_adjudicated ?visa_case)
  )
  (:action finalize_consular_exception_decision
    :parameters (?visa_case - visa_case)
    :precondition
      (and
        (case_prior_visit_adjudicated ?visa_case)
        (not
          (case_decision_recorded ?visa_case)
        )
      )
    :effect
      (and
        (case_decision_recorded ?visa_case)
        (clearance_granted ?visa_case)
      )
  )
  (:action propagate_clearance_to_primary_passenger
    :parameters (?primary_passenger - primary_passenger ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (primary_passenger_ready_for_entitlement ?primary_passenger)
        (primary_passenger_requirement_satisfied ?primary_passenger)
        (entitlement_record_allocated ?visa_entitlement_record)
        (entitlement_validated ?visa_entitlement_record)
        (not
          (clearance_granted ?primary_passenger)
        )
      )
    :effect (clearance_granted ?primary_passenger)
  )
  (:action propagate_clearance_to_companion_passenger
    :parameters (?companion_passenger - companion_passenger ?visa_entitlement_record - visa_entitlement_record)
    :precondition
      (and
        (companion_passenger_ready_for_entitlement ?companion_passenger)
        (companion_passenger_requirement_satisfied ?companion_passenger)
        (entitlement_record_allocated ?visa_entitlement_record)
        (entitlement_validated ?visa_entitlement_record)
        (not
          (clearance_granted ?companion_passenger)
        )
      )
    :effect (clearance_granted ?companion_passenger)
  )
  (:action request_entitlement_for_profile
    :parameters (?traveler_profile - profile_entity ?nationality - nationality ?entry_leg - entry_leg)
    :precondition
      (and
        (clearance_granted ?traveler_profile)
        (profile_leg_linked ?traveler_profile ?entry_leg)
        (nationality_available ?nationality)
        (not
          (profile_entitlement_allocated ?traveler_profile)
        )
      )
    :effect
      (and
        (profile_entitlement_allocated ?traveler_profile)
        (profile_has_nationality ?traveler_profile ?nationality)
        (not
          (nationality_available ?nationality)
        )
      )
  )
  (:action approve_entitlement_and_mark_product_used
    :parameters (?primary_passenger - primary_passenger ?visa_product - visa_product ?nationality - nationality)
    :precondition
      (and
        (profile_entitlement_allocated ?primary_passenger)
        (profile_assigned_visa_product ?primary_passenger ?visa_product)
        (profile_has_nationality ?primary_passenger ?nationality)
        (not
          (usage_authorized ?primary_passenger)
        )
      )
    :effect
      (and
        (usage_authorized ?primary_passenger)
        (visa_product_available ?visa_product)
        (nationality_available ?nationality)
      )
  )
  (:action approve_entitlement_and_mark_product_used_for_companion
    :parameters (?companion_passenger - companion_passenger ?visa_product - visa_product ?nationality - nationality)
    :precondition
      (and
        (profile_entitlement_allocated ?companion_passenger)
        (profile_assigned_visa_product ?companion_passenger ?visa_product)
        (profile_has_nationality ?companion_passenger ?nationality)
        (not
          (usage_authorized ?companion_passenger)
        )
      )
    :effect
      (and
        (usage_authorized ?companion_passenger)
        (visa_product_available ?visa_product)
        (nationality_available ?nationality)
      )
  )
  (:action assign_product_and_record_nationality_for_case
    :parameters (?visa_case - visa_case ?visa_product - visa_product ?nationality - nationality)
    :precondition
      (and
        (profile_entitlement_allocated ?visa_case)
        (profile_assigned_visa_product ?visa_case ?visa_product)
        (profile_has_nationality ?visa_case ?nationality)
        (not
          (usage_authorized ?visa_case)
        )
      )
    :effect
      (and
        (usage_authorized ?visa_case)
        (visa_product_available ?visa_product)
        (nationality_available ?nationality)
      )
  )
)

(define (domain destination_permit_adjudication)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_category - object document_category - object resource_category - object person_or_case_root - object traveler_entity - person_or_case_root permit_type_option - domain_category destination_jurisdiction - domain_category service_channel - domain_category policy_exception_tag - domain_category fee_option - domain_category verification_token - domain_category health_certificate_type - domain_category clearance_certificate - domain_category supporting_document_type - document_category document_requirement_item - document_category sponsorship_document - document_category condition_profile_primary - resource_category condition_profile_companion - resource_category permit_product_variant - resource_category traveler_subtype_container - traveler_entity application_subtype_container - traveler_entity primary_traveler - traveler_subtype_container companion_traveler - traveler_subtype_container application_case - application_subtype_container)
  (:predicates
    (entity_case_opened ?traveler_entity - traveler_entity)
    (entity_rule_interpretation_applied ?traveler_entity - traveler_entity)
    (option_selected ?traveler_entity - traveler_entity)
    (permit_determination_flag ?traveler_entity - traveler_entity)
    (eligibility_finalized ?traveler_entity - traveler_entity)
    (ready_for_determination ?traveler_entity - traveler_entity)
    (permit_option_available ?permit_type_option - permit_type_option)
    (entity_allocated_permit_option ?traveler_entity - traveler_entity ?permit_type_option - permit_type_option)
    (jurisdiction_rule_available ?destination_jurisdiction - destination_jurisdiction)
    (jurisdiction_linked ?traveler_entity - traveler_entity ?destination_jurisdiction - destination_jurisdiction)
    (service_channel_available ?service_channel - service_channel)
    (entity_channel_associated ?traveler_entity - traveler_entity ?service_channel - service_channel)
    (supporting_document_available ?supporting_document_type - supporting_document_type)
    (attached_document_primary ?primary_traveler - primary_traveler ?supporting_document_type - supporting_document_type)
    (attached_document_companion ?companion_traveler - companion_traveler ?supporting_document_type - supporting_document_type)
    (primary_condition_profile_linked ?primary_traveler - primary_traveler ?condition_profile_primary - condition_profile_primary)
    (primary_condition_profile_confirmed ?condition_profile_primary - condition_profile_primary)
    (primary_condition_profile_evidenced ?condition_profile_primary - condition_profile_primary)
    (primary_condition_satisfied ?primary_traveler - primary_traveler)
    (companion_condition_profile_linked ?companion_traveler - companion_traveler ?condition_profile_companion - condition_profile_companion)
    (companion_condition_profile_confirmed ?condition_profile_companion - condition_profile_companion)
    (companion_condition_profile_evidenced ?condition_profile_companion - condition_profile_companion)
    (companion_condition_satisfied ?companion_traveler - companion_traveler)
    (product_variant_available ?permit_product_variant - permit_product_variant)
    (product_variant_reserved ?permit_product_variant - permit_product_variant)
    (product_variant_links_primary_profile ?permit_product_variant - permit_product_variant ?condition_profile_primary - condition_profile_primary)
    (product_variant_links_companion_profile ?permit_product_variant - permit_product_variant ?condition_profile_companion - condition_profile_companion)
    (product_variant_primary_evidence_flag ?permit_product_variant - permit_product_variant)
    (product_variant_companion_evidence_flag ?permit_product_variant - permit_product_variant)
    (product_variant_ready_for_document_binding ?permit_product_variant - permit_product_variant)
    (case_includes_primary_traveler ?application_case - application_case ?primary_traveler - primary_traveler)
    (case_includes_companion_traveler ?application_case - application_case ?companion_traveler - companion_traveler)
    (case_includes_product_variant ?application_case - application_case ?permit_product_variant - permit_product_variant)
    (requirement_item_available ?document_requirement_item - document_requirement_item)
    (case_has_requirement_item ?application_case - application_case ?document_requirement_item - document_requirement_item)
    (requirement_item_bound ?document_requirement_item - document_requirement_item)
    (requirement_item_linked_to_product ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant)
    (case_prechecks_completed ?application_case - application_case)
    (specialized_checks_linked ?application_case - application_case)
    (all_special_requirements_satisfied ?application_case - application_case)
    (policy_exception_flag ?application_case - application_case)
    (policy_exception_processed ?application_case - application_case)
    (fee_option_attached_flag ?application_case - application_case)
    (final_checks_aggregated ?application_case - application_case)
    (sponsorship_document_available ?sponsorship_document - sponsorship_document)
    (case_has_sponsorship_document ?application_case - application_case ?sponsorship_document - sponsorship_document)
    (sponsorship_confirmed ?application_case - application_case)
    (sponsorship_channel_processed ?application_case - application_case)
    (sponsorship_cleared ?application_case - application_case)
    (policy_exception_available ?policy_exception_tag - policy_exception_tag)
    (policy_exception_attached ?application_case - application_case ?policy_exception_tag - policy_exception_tag)
    (fee_option_available ?fee_option - fee_option)
    (case_fee_option_attached ?application_case - application_case ?fee_option - fee_option)
    (health_certificate_available ?health_certificate_type - health_certificate_type)
    (case_health_certificate_attached ?application_case - application_case ?health_certificate_type - health_certificate_type)
    (clearance_certificate_available ?clearance_certificate - clearance_certificate)
    (case_clearance_certificate_attached ?application_case - application_case ?clearance_certificate - clearance_certificate)
    (verification_token_available ?verification_token - verification_token)
    (entity_verification_token_linked ?traveler_entity - traveler_entity ?verification_token - verification_token)
    (primary_ready_for_product_assembly ?primary_traveler - primary_traveler)
    (companion_ready_for_product_assembly ?companion_traveler - companion_traveler)
    (case_decision_recorded ?application_case - application_case)
  )
  (:action initialize_traveler_case
    :parameters (?traveler_entity - traveler_entity)
    :precondition
      (and
        (not
          (entity_case_opened ?traveler_entity)
        )
        (not
          (permit_determination_flag ?traveler_entity)
        )
      )
    :effect (entity_case_opened ?traveler_entity)
  )
  (:action assign_permit_option
    :parameters (?traveler_entity - traveler_entity ?permit_type_option - permit_type_option)
    :precondition
      (and
        (entity_case_opened ?traveler_entity)
        (not
          (option_selected ?traveler_entity)
        )
        (permit_option_available ?permit_type_option)
      )
    :effect
      (and
        (option_selected ?traveler_entity)
        (entity_allocated_permit_option ?traveler_entity ?permit_type_option)
        (not
          (permit_option_available ?permit_type_option)
        )
      )
  )
  (:action bind_jurisdiction_rule_to_case
    :parameters (?traveler_entity - traveler_entity ?destination_jurisdiction - destination_jurisdiction)
    :precondition
      (and
        (entity_case_opened ?traveler_entity)
        (option_selected ?traveler_entity)
        (jurisdiction_rule_available ?destination_jurisdiction)
      )
    :effect
      (and
        (jurisdiction_linked ?traveler_entity ?destination_jurisdiction)
        (not
          (jurisdiction_rule_available ?destination_jurisdiction)
        )
      )
  )
  (:action finalize_rule_interpretation
    :parameters (?traveler_entity - traveler_entity ?destination_jurisdiction - destination_jurisdiction)
    :precondition
      (and
        (entity_case_opened ?traveler_entity)
        (option_selected ?traveler_entity)
        (jurisdiction_linked ?traveler_entity ?destination_jurisdiction)
        (not
          (entity_rule_interpretation_applied ?traveler_entity)
        )
      )
    :effect (entity_rule_interpretation_applied ?traveler_entity)
  )
  (:action revert_jurisdiction_link
    :parameters (?traveler_entity - traveler_entity ?destination_jurisdiction - destination_jurisdiction)
    :precondition
      (and
        (jurisdiction_linked ?traveler_entity ?destination_jurisdiction)
      )
    :effect
      (and
        (jurisdiction_rule_available ?destination_jurisdiction)
        (not
          (jurisdiction_linked ?traveler_entity ?destination_jurisdiction)
        )
      )
  )
  (:action associate_service_channel_with_case
    :parameters (?traveler_entity - traveler_entity ?service_channel - service_channel)
    :precondition
      (and
        (entity_rule_interpretation_applied ?traveler_entity)
        (service_channel_available ?service_channel)
      )
    :effect
      (and
        (entity_channel_associated ?traveler_entity ?service_channel)
        (not
          (service_channel_available ?service_channel)
        )
      )
  )
  (:action release_service_channel_from_case
    :parameters (?traveler_entity - traveler_entity ?service_channel - service_channel)
    :precondition
      (and
        (entity_channel_associated ?traveler_entity ?service_channel)
      )
    :effect
      (and
        (service_channel_available ?service_channel)
        (not
          (entity_channel_associated ?traveler_entity ?service_channel)
        )
      )
  )
  (:action attach_health_certificate_to_case
    :parameters (?application_case - application_case ?health_certificate_type - health_certificate_type)
    :precondition
      (and
        (entity_rule_interpretation_applied ?application_case)
        (health_certificate_available ?health_certificate_type)
      )
    :effect
      (and
        (case_health_certificate_attached ?application_case ?health_certificate_type)
        (not
          (health_certificate_available ?health_certificate_type)
        )
      )
  )
  (:action remove_health_certificate_from_case
    :parameters (?application_case - application_case ?health_certificate_type - health_certificate_type)
    :precondition
      (and
        (case_health_certificate_attached ?application_case ?health_certificate_type)
      )
    :effect
      (and
        (health_certificate_available ?health_certificate_type)
        (not
          (case_health_certificate_attached ?application_case ?health_certificate_type)
        )
      )
  )
  (:action attach_clearance_certificate_to_case
    :parameters (?application_case - application_case ?clearance_certificate - clearance_certificate)
    :precondition
      (and
        (entity_rule_interpretation_applied ?application_case)
        (clearance_certificate_available ?clearance_certificate)
      )
    :effect
      (and
        (case_clearance_certificate_attached ?application_case ?clearance_certificate)
        (not
          (clearance_certificate_available ?clearance_certificate)
        )
      )
  )
  (:action remove_clearance_certificate_from_case
    :parameters (?application_case - application_case ?clearance_certificate - clearance_certificate)
    :precondition
      (and
        (case_clearance_certificate_attached ?application_case ?clearance_certificate)
      )
    :effect
      (and
        (clearance_certificate_available ?clearance_certificate)
        (not
          (case_clearance_certificate_attached ?application_case ?clearance_certificate)
        )
      )
  )
  (:action verify_primary_condition_profile_by_rule
    :parameters (?primary_traveler - primary_traveler ?condition_profile_primary - condition_profile_primary ?destination_jurisdiction - destination_jurisdiction)
    :precondition
      (and
        (entity_rule_interpretation_applied ?primary_traveler)
        (jurisdiction_linked ?primary_traveler ?destination_jurisdiction)
        (primary_condition_profile_linked ?primary_traveler ?condition_profile_primary)
        (not
          (primary_condition_profile_confirmed ?condition_profile_primary)
        )
        (not
          (primary_condition_profile_evidenced ?condition_profile_primary)
        )
      )
    :effect (primary_condition_profile_confirmed ?condition_profile_primary)
  )
  (:action record_primary_condition_and_prepare_product
    :parameters (?primary_traveler - primary_traveler ?condition_profile_primary - condition_profile_primary ?service_channel - service_channel)
    :precondition
      (and
        (entity_rule_interpretation_applied ?primary_traveler)
        (entity_channel_associated ?primary_traveler ?service_channel)
        (primary_condition_profile_linked ?primary_traveler ?condition_profile_primary)
        (primary_condition_profile_confirmed ?condition_profile_primary)
        (not
          (primary_ready_for_product_assembly ?primary_traveler)
        )
      )
    :effect
      (and
        (primary_ready_for_product_assembly ?primary_traveler)
        (primary_condition_satisfied ?primary_traveler)
      )
  )
  (:action apply_supporting_document_to_primary
    :parameters (?primary_traveler - primary_traveler ?condition_profile_primary - condition_profile_primary ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (entity_rule_interpretation_applied ?primary_traveler)
        (primary_condition_profile_linked ?primary_traveler ?condition_profile_primary)
        (supporting_document_available ?supporting_document_type)
        (not
          (primary_ready_for_product_assembly ?primary_traveler)
        )
      )
    :effect
      (and
        (primary_condition_profile_evidenced ?condition_profile_primary)
        (primary_ready_for_product_assembly ?primary_traveler)
        (attached_document_primary ?primary_traveler ?supporting_document_type)
        (not
          (supporting_document_available ?supporting_document_type)
        )
      )
  )
  (:action resolve_primary_condition_from_evidence
    :parameters (?primary_traveler - primary_traveler ?condition_profile_primary - condition_profile_primary ?destination_jurisdiction - destination_jurisdiction ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (entity_rule_interpretation_applied ?primary_traveler)
        (jurisdiction_linked ?primary_traveler ?destination_jurisdiction)
        (primary_condition_profile_linked ?primary_traveler ?condition_profile_primary)
        (primary_condition_profile_evidenced ?condition_profile_primary)
        (attached_document_primary ?primary_traveler ?supporting_document_type)
        (not
          (primary_condition_satisfied ?primary_traveler)
        )
      )
    :effect
      (and
        (primary_condition_profile_confirmed ?condition_profile_primary)
        (primary_condition_satisfied ?primary_traveler)
        (supporting_document_available ?supporting_document_type)
        (not
          (attached_document_primary ?primary_traveler ?supporting_document_type)
        )
      )
  )
  (:action verify_companion_condition_profile_by_rule
    :parameters (?companion_traveler - companion_traveler ?condition_profile_companion - condition_profile_companion ?destination_jurisdiction - destination_jurisdiction)
    :precondition
      (and
        (entity_rule_interpretation_applied ?companion_traveler)
        (jurisdiction_linked ?companion_traveler ?destination_jurisdiction)
        (companion_condition_profile_linked ?companion_traveler ?condition_profile_companion)
        (not
          (companion_condition_profile_confirmed ?condition_profile_companion)
        )
        (not
          (companion_condition_profile_evidenced ?condition_profile_companion)
        )
      )
    :effect (companion_condition_profile_confirmed ?condition_profile_companion)
  )
  (:action record_companion_condition_and_prepare_product
    :parameters (?companion_traveler - companion_traveler ?condition_profile_companion - condition_profile_companion ?service_channel - service_channel)
    :precondition
      (and
        (entity_rule_interpretation_applied ?companion_traveler)
        (entity_channel_associated ?companion_traveler ?service_channel)
        (companion_condition_profile_linked ?companion_traveler ?condition_profile_companion)
        (companion_condition_profile_confirmed ?condition_profile_companion)
        (not
          (companion_ready_for_product_assembly ?companion_traveler)
        )
      )
    :effect
      (and
        (companion_ready_for_product_assembly ?companion_traveler)
        (companion_condition_satisfied ?companion_traveler)
      )
  )
  (:action apply_supporting_document_to_companion
    :parameters (?companion_traveler - companion_traveler ?condition_profile_companion - condition_profile_companion ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (entity_rule_interpretation_applied ?companion_traveler)
        (companion_condition_profile_linked ?companion_traveler ?condition_profile_companion)
        (supporting_document_available ?supporting_document_type)
        (not
          (companion_ready_for_product_assembly ?companion_traveler)
        )
      )
    :effect
      (and
        (companion_condition_profile_evidenced ?condition_profile_companion)
        (companion_ready_for_product_assembly ?companion_traveler)
        (attached_document_companion ?companion_traveler ?supporting_document_type)
        (not
          (supporting_document_available ?supporting_document_type)
        )
      )
  )
  (:action resolve_companion_condition_from_evidence
    :parameters (?companion_traveler - companion_traveler ?condition_profile_companion - condition_profile_companion ?destination_jurisdiction - destination_jurisdiction ?supporting_document_type - supporting_document_type)
    :precondition
      (and
        (entity_rule_interpretation_applied ?companion_traveler)
        (jurisdiction_linked ?companion_traveler ?destination_jurisdiction)
        (companion_condition_profile_linked ?companion_traveler ?condition_profile_companion)
        (companion_condition_profile_evidenced ?condition_profile_companion)
        (attached_document_companion ?companion_traveler ?supporting_document_type)
        (not
          (companion_condition_satisfied ?companion_traveler)
        )
      )
    :effect
      (and
        (companion_condition_profile_confirmed ?condition_profile_companion)
        (companion_condition_satisfied ?companion_traveler)
        (supporting_document_available ?supporting_document_type)
        (not
          (attached_document_companion ?companion_traveler ?supporting_document_type)
        )
      )
  )
  (:action assemble_permit_product_variant
    :parameters (?primary_traveler - primary_traveler ?companion_traveler - companion_traveler ?condition_profile_primary - condition_profile_primary ?condition_profile_companion - condition_profile_companion ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (primary_ready_for_product_assembly ?primary_traveler)
        (companion_ready_for_product_assembly ?companion_traveler)
        (primary_condition_profile_linked ?primary_traveler ?condition_profile_primary)
        (companion_condition_profile_linked ?companion_traveler ?condition_profile_companion)
        (primary_condition_profile_confirmed ?condition_profile_primary)
        (companion_condition_profile_confirmed ?condition_profile_companion)
        (primary_condition_satisfied ?primary_traveler)
        (companion_condition_satisfied ?companion_traveler)
        (product_variant_available ?permit_product_variant)
      )
    :effect
      (and
        (product_variant_reserved ?permit_product_variant)
        (product_variant_links_primary_profile ?permit_product_variant ?condition_profile_primary)
        (product_variant_links_companion_profile ?permit_product_variant ?condition_profile_companion)
        (not
          (product_variant_available ?permit_product_variant)
        )
      )
  )
  (:action assemble_permit_product_with_primary_evidence
    :parameters (?primary_traveler - primary_traveler ?companion_traveler - companion_traveler ?condition_profile_primary - condition_profile_primary ?condition_profile_companion - condition_profile_companion ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (primary_ready_for_product_assembly ?primary_traveler)
        (companion_ready_for_product_assembly ?companion_traveler)
        (primary_condition_profile_linked ?primary_traveler ?condition_profile_primary)
        (companion_condition_profile_linked ?companion_traveler ?condition_profile_companion)
        (primary_condition_profile_evidenced ?condition_profile_primary)
        (companion_condition_profile_confirmed ?condition_profile_companion)
        (not
          (primary_condition_satisfied ?primary_traveler)
        )
        (companion_condition_satisfied ?companion_traveler)
        (product_variant_available ?permit_product_variant)
      )
    :effect
      (and
        (product_variant_reserved ?permit_product_variant)
        (product_variant_links_primary_profile ?permit_product_variant ?condition_profile_primary)
        (product_variant_links_companion_profile ?permit_product_variant ?condition_profile_companion)
        (product_variant_primary_evidence_flag ?permit_product_variant)
        (not
          (product_variant_available ?permit_product_variant)
        )
      )
  )
  (:action assemble_permit_product_with_companion_evidence
    :parameters (?primary_traveler - primary_traveler ?companion_traveler - companion_traveler ?condition_profile_primary - condition_profile_primary ?condition_profile_companion - condition_profile_companion ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (primary_ready_for_product_assembly ?primary_traveler)
        (companion_ready_for_product_assembly ?companion_traveler)
        (primary_condition_profile_linked ?primary_traveler ?condition_profile_primary)
        (companion_condition_profile_linked ?companion_traveler ?condition_profile_companion)
        (primary_condition_profile_confirmed ?condition_profile_primary)
        (companion_condition_profile_evidenced ?condition_profile_companion)
        (primary_condition_satisfied ?primary_traveler)
        (not
          (companion_condition_satisfied ?companion_traveler)
        )
        (product_variant_available ?permit_product_variant)
      )
    :effect
      (and
        (product_variant_reserved ?permit_product_variant)
        (product_variant_links_primary_profile ?permit_product_variant ?condition_profile_primary)
        (product_variant_links_companion_profile ?permit_product_variant ?condition_profile_companion)
        (product_variant_companion_evidence_flag ?permit_product_variant)
        (not
          (product_variant_available ?permit_product_variant)
        )
      )
  )
  (:action assemble_permit_product_with_both_evidence
    :parameters (?primary_traveler - primary_traveler ?companion_traveler - companion_traveler ?condition_profile_primary - condition_profile_primary ?condition_profile_companion - condition_profile_companion ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (primary_ready_for_product_assembly ?primary_traveler)
        (companion_ready_for_product_assembly ?companion_traveler)
        (primary_condition_profile_linked ?primary_traveler ?condition_profile_primary)
        (companion_condition_profile_linked ?companion_traveler ?condition_profile_companion)
        (primary_condition_profile_evidenced ?condition_profile_primary)
        (companion_condition_profile_evidenced ?condition_profile_companion)
        (not
          (primary_condition_satisfied ?primary_traveler)
        )
        (not
          (companion_condition_satisfied ?companion_traveler)
        )
        (product_variant_available ?permit_product_variant)
      )
    :effect
      (and
        (product_variant_reserved ?permit_product_variant)
        (product_variant_links_primary_profile ?permit_product_variant ?condition_profile_primary)
        (product_variant_links_companion_profile ?permit_product_variant ?condition_profile_companion)
        (product_variant_primary_evidence_flag ?permit_product_variant)
        (product_variant_companion_evidence_flag ?permit_product_variant)
        (not
          (product_variant_available ?permit_product_variant)
        )
      )
  )
  (:action mark_product_variant_ready_for_document_binding
    :parameters (?permit_product_variant - permit_product_variant ?primary_traveler - primary_traveler ?destination_jurisdiction - destination_jurisdiction)
    :precondition
      (and
        (product_variant_reserved ?permit_product_variant)
        (primary_ready_for_product_assembly ?primary_traveler)
        (jurisdiction_linked ?primary_traveler ?destination_jurisdiction)
        (not
          (product_variant_ready_for_document_binding ?permit_product_variant)
        )
      )
    :effect (product_variant_ready_for_document_binding ?permit_product_variant)
  )
  (:action attach_requirement_item_to_product
    :parameters (?application_case - application_case ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (entity_rule_interpretation_applied ?application_case)
        (case_includes_product_variant ?application_case ?permit_product_variant)
        (case_has_requirement_item ?application_case ?document_requirement_item)
        (requirement_item_available ?document_requirement_item)
        (product_variant_reserved ?permit_product_variant)
        (product_variant_ready_for_document_binding ?permit_product_variant)
        (not
          (requirement_item_bound ?document_requirement_item)
        )
      )
    :effect
      (and
        (requirement_item_bound ?document_requirement_item)
        (requirement_item_linked_to_product ?document_requirement_item ?permit_product_variant)
        (not
          (requirement_item_available ?document_requirement_item)
        )
      )
  )
  (:action finalize_case_prechecks
    :parameters (?application_case - application_case ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant ?destination_jurisdiction - destination_jurisdiction)
    :precondition
      (and
        (entity_rule_interpretation_applied ?application_case)
        (case_has_requirement_item ?application_case ?document_requirement_item)
        (requirement_item_bound ?document_requirement_item)
        (requirement_item_linked_to_product ?document_requirement_item ?permit_product_variant)
        (jurisdiction_linked ?application_case ?destination_jurisdiction)
        (not
          (product_variant_primary_evidence_flag ?permit_product_variant)
        )
        (not
          (case_prechecks_completed ?application_case)
        )
      )
    :effect (case_prechecks_completed ?application_case)
  )
  (:action attach_policy_exception_to_case
    :parameters (?application_case - application_case ?policy_exception_tag - policy_exception_tag)
    :precondition
      (and
        (entity_rule_interpretation_applied ?application_case)
        (policy_exception_available ?policy_exception_tag)
        (not
          (policy_exception_flag ?application_case)
        )
      )
    :effect
      (and
        (policy_exception_flag ?application_case)
        (policy_exception_attached ?application_case ?policy_exception_tag)
        (not
          (policy_exception_available ?policy_exception_tag)
        )
      )
  )
  (:action process_policy_exception_for_case
    :parameters (?application_case - application_case ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant ?destination_jurisdiction - destination_jurisdiction ?policy_exception_tag - policy_exception_tag)
    :precondition
      (and
        (entity_rule_interpretation_applied ?application_case)
        (case_has_requirement_item ?application_case ?document_requirement_item)
        (requirement_item_bound ?document_requirement_item)
        (requirement_item_linked_to_product ?document_requirement_item ?permit_product_variant)
        (jurisdiction_linked ?application_case ?destination_jurisdiction)
        (product_variant_primary_evidence_flag ?permit_product_variant)
        (policy_exception_flag ?application_case)
        (policy_exception_attached ?application_case ?policy_exception_tag)
        (not
          (case_prechecks_completed ?application_case)
        )
      )
    :effect
      (and
        (case_prechecks_completed ?application_case)
        (policy_exception_processed ?application_case)
      )
  )
  (:action initiate_specialized_checks_with_health_certificate
    :parameters (?application_case - application_case ?health_certificate_type - health_certificate_type ?service_channel - service_channel ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (case_prechecks_completed ?application_case)
        (case_health_certificate_attached ?application_case ?health_certificate_type)
        (entity_channel_associated ?application_case ?service_channel)
        (case_has_requirement_item ?application_case ?document_requirement_item)
        (requirement_item_linked_to_product ?document_requirement_item ?permit_product_variant)
        (not
          (product_variant_companion_evidence_flag ?permit_product_variant)
        )
        (not
          (specialized_checks_linked ?application_case)
        )
      )
    :effect (specialized_checks_linked ?application_case)
  )
  (:action initiate_specialized_checks_with_health_certificate_variant
    :parameters (?application_case - application_case ?health_certificate_type - health_certificate_type ?service_channel - service_channel ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (case_prechecks_completed ?application_case)
        (case_health_certificate_attached ?application_case ?health_certificate_type)
        (entity_channel_associated ?application_case ?service_channel)
        (case_has_requirement_item ?application_case ?document_requirement_item)
        (requirement_item_linked_to_product ?document_requirement_item ?permit_product_variant)
        (product_variant_companion_evidence_flag ?permit_product_variant)
        (not
          (specialized_checks_linked ?application_case)
        )
      )
    :effect (specialized_checks_linked ?application_case)
  )
  (:action apply_clearance_certificate_to_case
    :parameters (?application_case - application_case ?clearance_certificate - clearance_certificate ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (specialized_checks_linked ?application_case)
        (case_clearance_certificate_attached ?application_case ?clearance_certificate)
        (case_has_requirement_item ?application_case ?document_requirement_item)
        (requirement_item_linked_to_product ?document_requirement_item ?permit_product_variant)
        (not
          (product_variant_primary_evidence_flag ?permit_product_variant)
        )
        (not
          (product_variant_companion_evidence_flag ?permit_product_variant)
        )
        (not
          (all_special_requirements_satisfied ?application_case)
        )
      )
    :effect (all_special_requirements_satisfied ?application_case)
  )
  (:action apply_clearance_certificate_and_attach_fee
    :parameters (?application_case - application_case ?clearance_certificate - clearance_certificate ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (specialized_checks_linked ?application_case)
        (case_clearance_certificate_attached ?application_case ?clearance_certificate)
        (case_has_requirement_item ?application_case ?document_requirement_item)
        (requirement_item_linked_to_product ?document_requirement_item ?permit_product_variant)
        (product_variant_primary_evidence_flag ?permit_product_variant)
        (not
          (product_variant_companion_evidence_flag ?permit_product_variant)
        )
        (not
          (all_special_requirements_satisfied ?application_case)
        )
      )
    :effect
      (and
        (all_special_requirements_satisfied ?application_case)
        (fee_option_attached_flag ?application_case)
      )
  )
  (:action apply_clearance_certificate_and_attach_fee_variant
    :parameters (?application_case - application_case ?clearance_certificate - clearance_certificate ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (specialized_checks_linked ?application_case)
        (case_clearance_certificate_attached ?application_case ?clearance_certificate)
        (case_has_requirement_item ?application_case ?document_requirement_item)
        (requirement_item_linked_to_product ?document_requirement_item ?permit_product_variant)
        (not
          (product_variant_primary_evidence_flag ?permit_product_variant)
        )
        (product_variant_companion_evidence_flag ?permit_product_variant)
        (not
          (all_special_requirements_satisfied ?application_case)
        )
      )
    :effect
      (and
        (all_special_requirements_satisfied ?application_case)
        (fee_option_attached_flag ?application_case)
      )
  )
  (:action apply_clearance_certificate_and_attach_fee_both
    :parameters (?application_case - application_case ?clearance_certificate - clearance_certificate ?document_requirement_item - document_requirement_item ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (specialized_checks_linked ?application_case)
        (case_clearance_certificate_attached ?application_case ?clearance_certificate)
        (case_has_requirement_item ?application_case ?document_requirement_item)
        (requirement_item_linked_to_product ?document_requirement_item ?permit_product_variant)
        (product_variant_primary_evidence_flag ?permit_product_variant)
        (product_variant_companion_evidence_flag ?permit_product_variant)
        (not
          (all_special_requirements_satisfied ?application_case)
        )
      )
    :effect
      (and
        (all_special_requirements_satisfied ?application_case)
        (fee_option_attached_flag ?application_case)
      )
  )
  (:action finalize_case_decision_no_fee
    :parameters (?application_case - application_case)
    :precondition
      (and
        (all_special_requirements_satisfied ?application_case)
        (not
          (fee_option_attached_flag ?application_case)
        )
        (not
          (case_decision_recorded ?application_case)
        )
      )
    :effect
      (and
        (case_decision_recorded ?application_case)
        (eligibility_finalized ?application_case)
      )
  )
  (:action attach_fee_option_to_case
    :parameters (?application_case - application_case ?fee_option - fee_option)
    :precondition
      (and
        (all_special_requirements_satisfied ?application_case)
        (fee_option_attached_flag ?application_case)
        (fee_option_available ?fee_option)
      )
    :effect
      (and
        (case_fee_option_attached ?application_case ?fee_option)
        (not
          (fee_option_available ?fee_option)
        )
      )
  )
  (:action aggregate_final_checks_for_case
    :parameters (?application_case - application_case ?primary_traveler - primary_traveler ?companion_traveler - companion_traveler ?destination_jurisdiction - destination_jurisdiction ?fee_option - fee_option)
    :precondition
      (and
        (all_special_requirements_satisfied ?application_case)
        (fee_option_attached_flag ?application_case)
        (case_fee_option_attached ?application_case ?fee_option)
        (case_includes_primary_traveler ?application_case ?primary_traveler)
        (case_includes_companion_traveler ?application_case ?companion_traveler)
        (primary_condition_satisfied ?primary_traveler)
        (companion_condition_satisfied ?companion_traveler)
        (jurisdiction_linked ?application_case ?destination_jurisdiction)
        (not
          (final_checks_aggregated ?application_case)
        )
      )
    :effect (final_checks_aggregated ?application_case)
  )
  (:action finalize_case_decision_after_aggregation
    :parameters (?application_case - application_case)
    :precondition
      (and
        (all_special_requirements_satisfied ?application_case)
        (final_checks_aggregated ?application_case)
        (not
          (case_decision_recorded ?application_case)
        )
      )
    :effect
      (and
        (case_decision_recorded ?application_case)
        (eligibility_finalized ?application_case)
      )
  )
  (:action confirm_sponsorship_for_case
    :parameters (?application_case - application_case ?sponsorship_document - sponsorship_document ?destination_jurisdiction - destination_jurisdiction)
    :precondition
      (and
        (entity_rule_interpretation_applied ?application_case)
        (jurisdiction_linked ?application_case ?destination_jurisdiction)
        (sponsorship_document_available ?sponsorship_document)
        (case_has_sponsorship_document ?application_case ?sponsorship_document)
        (not
          (sponsorship_confirmed ?application_case)
        )
      )
    :effect
      (and
        (sponsorship_confirmed ?application_case)
        (not
          (sponsorship_document_available ?sponsorship_document)
        )
      )
  )
  (:action process_sponsorship_via_channel
    :parameters (?application_case - application_case ?service_channel - service_channel)
    :precondition
      (and
        (sponsorship_confirmed ?application_case)
        (entity_channel_associated ?application_case ?service_channel)
        (not
          (sponsorship_channel_processed ?application_case)
        )
      )
    :effect (sponsorship_channel_processed ?application_case)
  )
  (:action confirm_clearance_for_case
    :parameters (?application_case - application_case ?clearance_certificate - clearance_certificate)
    :precondition
      (and
        (sponsorship_channel_processed ?application_case)
        (case_clearance_certificate_attached ?application_case ?clearance_certificate)
        (not
          (sponsorship_cleared ?application_case)
        )
      )
    :effect (sponsorship_cleared ?application_case)
  )
  (:action finalize_case_decision_after_sponsorship
    :parameters (?application_case - application_case)
    :precondition
      (and
        (sponsorship_cleared ?application_case)
        (not
          (case_decision_recorded ?application_case)
        )
      )
    :effect
      (and
        (case_decision_recorded ?application_case)
        (eligibility_finalized ?application_case)
      )
  )
  (:action finalize_primary_traveler_eligibility
    :parameters (?primary_traveler - primary_traveler ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (primary_ready_for_product_assembly ?primary_traveler)
        (primary_condition_satisfied ?primary_traveler)
        (product_variant_reserved ?permit_product_variant)
        (product_variant_ready_for_document_binding ?permit_product_variant)
        (not
          (eligibility_finalized ?primary_traveler)
        )
      )
    :effect (eligibility_finalized ?primary_traveler)
  )
  (:action finalize_companion_traveler_eligibility
    :parameters (?companion_traveler - companion_traveler ?permit_product_variant - permit_product_variant)
    :precondition
      (and
        (companion_ready_for_product_assembly ?companion_traveler)
        (companion_condition_satisfied ?companion_traveler)
        (product_variant_reserved ?permit_product_variant)
        (product_variant_ready_for_document_binding ?permit_product_variant)
        (not
          (eligibility_finalized ?companion_traveler)
        )
      )
    :effect (eligibility_finalized ?companion_traveler)
  )
  (:action consume_verification_token
    :parameters (?traveler_entity - traveler_entity ?verification_token - verification_token ?destination_jurisdiction - destination_jurisdiction)
    :precondition
      (and
        (eligibility_finalized ?traveler_entity)
        (jurisdiction_linked ?traveler_entity ?destination_jurisdiction)
        (verification_token_available ?verification_token)
        (not
          (ready_for_determination ?traveler_entity)
        )
      )
    :effect
      (and
        (ready_for_determination ?traveler_entity)
        (entity_verification_token_linked ?traveler_entity ?verification_token)
        (not
          (verification_token_available ?verification_token)
        )
      )
  )
  (:action finalize_primary_traveler_determination_and_allocate_option
    :parameters (?primary_traveler - primary_traveler ?permit_type_option - permit_type_option ?verification_token - verification_token)
    :precondition
      (and
        (ready_for_determination ?primary_traveler)
        (entity_allocated_permit_option ?primary_traveler ?permit_type_option)
        (entity_verification_token_linked ?primary_traveler ?verification_token)
        (not
          (permit_determination_flag ?primary_traveler)
        )
      )
    :effect
      (and
        (permit_determination_flag ?primary_traveler)
        (permit_option_available ?permit_type_option)
        (verification_token_available ?verification_token)
      )
  )
  (:action finalize_companion_traveler_determination_and_allocate_option
    :parameters (?companion_traveler - companion_traveler ?permit_type_option - permit_type_option ?verification_token - verification_token)
    :precondition
      (and
        (ready_for_determination ?companion_traveler)
        (entity_allocated_permit_option ?companion_traveler ?permit_type_option)
        (entity_verification_token_linked ?companion_traveler ?verification_token)
        (not
          (permit_determination_flag ?companion_traveler)
        )
      )
    :effect
      (and
        (permit_determination_flag ?companion_traveler)
        (permit_option_available ?permit_type_option)
        (verification_token_available ?verification_token)
      )
  )
  (:action finalize_case_determination_and_allocate_option
    :parameters (?application_case - application_case ?permit_type_option - permit_type_option ?verification_token - verification_token)
    :precondition
      (and
        (ready_for_determination ?application_case)
        (entity_allocated_permit_option ?application_case ?permit_type_option)
        (entity_verification_token_linked ?application_case ?verification_token)
        (not
          (permit_determination_flag ?application_case)
        )
      )
    :effect
      (and
        (permit_determination_flag ?application_case)
        (permit_option_available ?permit_type_option)
        (verification_token_available ?verification_token)
      )
  )
)

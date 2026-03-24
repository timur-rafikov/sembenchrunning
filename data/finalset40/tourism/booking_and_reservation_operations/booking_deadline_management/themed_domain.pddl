(define (domain tourism_booking_deadline_management)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object service_component_category - domain_object supporting_artifact_category - domain_object reservation_element_category - domain_object abstract_booking_category - domain_object booking_proposal - abstract_booking_category inventory_item - service_component_category confirmation_token - service_component_category provider_endpoint - service_component_category payment_instrument - service_component_category pricing_profile - service_component_category deadline_policy - service_component_category supplier_confirmation_token - service_component_category regulatory_authorization - service_component_category service_addon - supporting_artifact_category fulfillment_document - supporting_artifact_category partner_reference - supporting_artifact_category service_deadline_slot_a - reservation_element_category service_deadline_slot_b - reservation_element_category reservation_record - reservation_element_category proposal_component_subtype - booking_proposal proposal_workflow_subtype - booking_proposal lead_service_component - proposal_component_subtype ancillary_service_component - proposal_component_subtype booking_workflow_instance - proposal_workflow_subtype)

  (:predicates
    (booking_entity_open ?booking_proposal - booking_proposal)
    (booking_entity_confirmed ?booking_proposal - booking_proposal)
    (booking_entity_inventory_held ?booking_proposal - booking_proposal)
    (booking_entity_commit_applied ?booking_proposal - booking_proposal)
    (booking_entity_committed_to_customer ?booking_proposal - booking_proposal)
    (booking_entity_commit_bound ?booking_proposal - booking_proposal)
    (inventory_available ?inventory_item - inventory_item)
    (booking_entity_holds_inventory_item ?booking_proposal - booking_proposal ?inventory_item - inventory_item)
    (confirmation_token_available ?confirmation_token - confirmation_token)
    (booking_entity_confirmation_token_attached ?booking_proposal - booking_proposal ?confirmation_token - confirmation_token)
    (provider_endpoint_available ?provider_endpoint - provider_endpoint)
    (booking_entity_provider_hold ?booking_proposal - booking_proposal ?provider_endpoint - provider_endpoint)
    (service_addon_available ?service_addon - service_addon)
    (lead_component_has_addon ?lead_service_component - lead_service_component ?service_addon - service_addon)
    (ancillary_component_has_addon ?ancillary_service_component - ancillary_service_component ?service_addon - service_addon)
    (lead_component_has_deadline_slot ?lead_service_component - lead_service_component ?service_deadline_slot_a - service_deadline_slot_a)
    (deadline_slot_a_ready ?service_deadline_slot_a - service_deadline_slot_a)
    (deadline_slot_a_has_addon ?service_deadline_slot_a - service_deadline_slot_a)
    (lead_component_ready ?lead_service_component - lead_service_component)
    (ancillary_component_has_deadline_slot ?ancillary_service_component - ancillary_service_component ?service_deadline_slot_b - service_deadline_slot_b)
    (deadline_slot_b_ready ?service_deadline_slot_b - service_deadline_slot_b)
    (deadline_slot_b_has_addon ?service_deadline_slot_b - service_deadline_slot_b)
    (ancillary_component_ready ?ancillary_service_component - ancillary_service_component)
    (reservation_record_template_available ?reservation_record - reservation_record)
    (reservation_record_initialized ?reservation_record - reservation_record)
    (reservation_record_linked_deadline_slot_a ?reservation_record - reservation_record ?service_deadline_slot_a - service_deadline_slot_a)
    (reservation_record_linked_deadline_slot_b ?reservation_record - reservation_record ?service_deadline_slot_b - service_deadline_slot_b)
    (reservation_record_slot_a_flag ?reservation_record - reservation_record)
    (reservation_record_slot_b_flag ?reservation_record - reservation_record)
    (reservation_ready_for_documents ?reservation_record - reservation_record)
    (workflow_has_lead_component ?booking_workflow_instance - booking_workflow_instance ?lead_service_component - lead_service_component)
    (workflow_has_ancillary_component ?booking_workflow_instance - booking_workflow_instance ?ancillary_service_component - ancillary_service_component)
    (workflow_linked_to_reservation_record ?booking_workflow_instance - booking_workflow_instance ?reservation_record - reservation_record)
    (fulfillment_document_available ?fulfillment_document - fulfillment_document)
    (workflow_has_fulfillment_document ?booking_workflow_instance - booking_workflow_instance ?fulfillment_document - fulfillment_document)
    (fulfillment_document_processed ?fulfillment_document - fulfillment_document)
    (fulfillment_document_linked_to_reservation ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record)
    (workflow_document_processed ?booking_workflow_instance - booking_workflow_instance)
    (workflow_supplier_confirmed ?booking_workflow_instance - booking_workflow_instance)
    (workflow_authorizations_attached ?booking_workflow_instance - booking_workflow_instance)
    (workflow_payment_attached ?booking_workflow_instance - booking_workflow_instance)
    (workflow_payment_verified ?booking_workflow_instance - booking_workflow_instance)
    (workflow_pricing_profile_ready ?booking_workflow_instance - booking_workflow_instance)
    (workflow_validated ?booking_workflow_instance - booking_workflow_instance)
    (partner_reference_available ?partner_reference - partner_reference)
    (workflow_has_partner_reference ?booking_workflow_instance - booking_workflow_instance ?partner_reference - partner_reference)
    (workflow_partner_reference_attached ?booking_workflow_instance - booking_workflow_instance)
    (workflow_partner_reference_validated ?booking_workflow_instance - booking_workflow_instance)
    (workflow_authorization_confirmed ?booking_workflow_instance - booking_workflow_instance)
    (payment_instrument_available ?payment_instrument - payment_instrument)
    (workflow_attached_payment_instrument ?booking_workflow_instance - booking_workflow_instance ?payment_instrument - payment_instrument)
    (pricing_profile_available ?pricing_profile - pricing_profile)
    (workflow_has_pricing_profile ?booking_workflow_instance - booking_workflow_instance ?pricing_profile - pricing_profile)
    (supplier_confirmation_token_available ?supplier_confirmation_token - supplier_confirmation_token)
    (workflow_has_supplier_confirmation_token ?booking_workflow_instance - booking_workflow_instance ?supplier_confirmation_token - supplier_confirmation_token)
    (regulatory_authorization_available ?regulatory_authorization - regulatory_authorization)
    (workflow_has_regulatory_authorization ?booking_workflow_instance - booking_workflow_instance ?regulatory_authorization - regulatory_authorization)
    (deadline_policy_available ?deadline_policy - deadline_policy)
    (booking_entity_linked_deadline_policy ?booking_proposal - booking_proposal ?deadline_policy - deadline_policy)
    (lead_component_hold_registered ?lead_service_component - lead_service_component)
    (ancillary_component_hold_registered ?ancillary_service_component - ancillary_service_component)
    (workflow_finalized ?booking_workflow_instance - booking_workflow_instance)
  )
  (:action create_booking_proposal
    :parameters (?booking_proposal - booking_proposal)
    :precondition
      (and
        (not
          (booking_entity_open ?booking_proposal)
        )
        (not
          (booking_entity_commit_applied ?booking_proposal)
        )
      )
    :effect (booking_entity_open ?booking_proposal)
  )
  (:action place_inventory_hold_on_proposal
    :parameters (?booking_proposal - booking_proposal ?inventory_item - inventory_item)
    :precondition
      (and
        (booking_entity_open ?booking_proposal)
        (not
          (booking_entity_inventory_held ?booking_proposal)
        )
        (inventory_available ?inventory_item)
      )
    :effect
      (and
        (booking_entity_inventory_held ?booking_proposal)
        (booking_entity_holds_inventory_item ?booking_proposal ?inventory_item)
        (not
          (inventory_available ?inventory_item)
        )
      )
  )
  (:action attach_confirmation_token_to_proposal
    :parameters (?booking_proposal - booking_proposal ?confirmation_token - confirmation_token)
    :precondition
      (and
        (booking_entity_open ?booking_proposal)
        (booking_entity_inventory_held ?booking_proposal)
        (confirmation_token_available ?confirmation_token)
      )
    :effect
      (and
        (booking_entity_confirmation_token_attached ?booking_proposal ?confirmation_token)
        (not
          (confirmation_token_available ?confirmation_token)
        )
      )
  )
  (:action confirm_proposal
    :parameters (?booking_proposal - booking_proposal ?confirmation_token - confirmation_token)
    :precondition
      (and
        (booking_entity_open ?booking_proposal)
        (booking_entity_inventory_held ?booking_proposal)
        (booking_entity_confirmation_token_attached ?booking_proposal ?confirmation_token)
        (not
          (booking_entity_confirmed ?booking_proposal)
        )
      )
    :effect (booking_entity_confirmed ?booking_proposal)
  )
  (:action revoke_confirmation_token_from_proposal
    :parameters (?booking_proposal - booking_proposal ?confirmation_token - confirmation_token)
    :precondition
      (and
        (booking_entity_confirmation_token_attached ?booking_proposal ?confirmation_token)
      )
    :effect
      (and
        (confirmation_token_available ?confirmation_token)
        (not
          (booking_entity_confirmation_token_attached ?booking_proposal ?confirmation_token)
        )
      )
  )
  (:action request_provider_hold
    :parameters (?booking_proposal - booking_proposal ?provider_endpoint - provider_endpoint)
    :precondition
      (and
        (booking_entity_confirmed ?booking_proposal)
        (provider_endpoint_available ?provider_endpoint)
      )
    :effect
      (and
        (booking_entity_provider_hold ?booking_proposal ?provider_endpoint)
        (not
          (provider_endpoint_available ?provider_endpoint)
        )
      )
  )
  (:action release_provider_hold
    :parameters (?booking_proposal - booking_proposal ?provider_endpoint - provider_endpoint)
    :precondition
      (and
        (booking_entity_provider_hold ?booking_proposal ?provider_endpoint)
      )
    :effect
      (and
        (provider_endpoint_available ?provider_endpoint)
        (not
          (booking_entity_provider_hold ?booking_proposal ?provider_endpoint)
        )
      )
  )
  (:action attach_supplier_confirmation_to_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?supplier_confirmation_token - supplier_confirmation_token)
    :precondition
      (and
        (booking_entity_confirmed ?booking_workflow_instance)
        (supplier_confirmation_token_available ?supplier_confirmation_token)
      )
    :effect
      (and
        (workflow_has_supplier_confirmation_token ?booking_workflow_instance ?supplier_confirmation_token)
        (not
          (supplier_confirmation_token_available ?supplier_confirmation_token)
        )
      )
  )
  (:action detach_supplier_confirmation_from_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?supplier_confirmation_token - supplier_confirmation_token)
    :precondition
      (and
        (workflow_has_supplier_confirmation_token ?booking_workflow_instance ?supplier_confirmation_token)
      )
    :effect
      (and
        (supplier_confirmation_token_available ?supplier_confirmation_token)
        (not
          (workflow_has_supplier_confirmation_token ?booking_workflow_instance ?supplier_confirmation_token)
        )
      )
  )
  (:action attach_regulatory_authorization_to_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?regulatory_authorization - regulatory_authorization)
    :precondition
      (and
        (booking_entity_confirmed ?booking_workflow_instance)
        (regulatory_authorization_available ?regulatory_authorization)
      )
    :effect
      (and
        (workflow_has_regulatory_authorization ?booking_workflow_instance ?regulatory_authorization)
        (not
          (regulatory_authorization_available ?regulatory_authorization)
        )
      )
  )
  (:action detach_regulatory_authorization_from_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?regulatory_authorization - regulatory_authorization)
    :precondition
      (and
        (workflow_has_regulatory_authorization ?booking_workflow_instance ?regulatory_authorization)
      )
    :effect
      (and
        (regulatory_authorization_available ?regulatory_authorization)
        (not
          (workflow_has_regulatory_authorization ?booking_workflow_instance ?regulatory_authorization)
        )
      )
  )
  (:action mark_deadline_slot_a_ready
    :parameters (?lead_service_component - lead_service_component ?service_deadline_slot_a - service_deadline_slot_a ?confirmation_token - confirmation_token)
    :precondition
      (and
        (booking_entity_confirmed ?lead_service_component)
        (booking_entity_confirmation_token_attached ?lead_service_component ?confirmation_token)
        (lead_component_has_deadline_slot ?lead_service_component ?service_deadline_slot_a)
        (not
          (deadline_slot_a_ready ?service_deadline_slot_a)
        )
        (not
          (deadline_slot_a_has_addon ?service_deadline_slot_a)
        )
      )
    :effect (deadline_slot_a_ready ?service_deadline_slot_a)
  )
  (:action register_lead_component_hold
    :parameters (?lead_service_component - lead_service_component ?service_deadline_slot_a - service_deadline_slot_a ?provider_endpoint - provider_endpoint)
    :precondition
      (and
        (booking_entity_confirmed ?lead_service_component)
        (booking_entity_provider_hold ?lead_service_component ?provider_endpoint)
        (lead_component_has_deadline_slot ?lead_service_component ?service_deadline_slot_a)
        (deadline_slot_a_ready ?service_deadline_slot_a)
        (not
          (lead_component_hold_registered ?lead_service_component)
        )
      )
    :effect
      (and
        (lead_component_hold_registered ?lead_service_component)
        (lead_component_ready ?lead_service_component)
      )
  )
  (:action apply_addon_to_lead_component
    :parameters (?lead_service_component - lead_service_component ?service_deadline_slot_a - service_deadline_slot_a ?service_addon - service_addon)
    :precondition
      (and
        (booking_entity_confirmed ?lead_service_component)
        (lead_component_has_deadline_slot ?lead_service_component ?service_deadline_slot_a)
        (service_addon_available ?service_addon)
        (not
          (lead_component_hold_registered ?lead_service_component)
        )
      )
    :effect
      (and
        (deadline_slot_a_has_addon ?service_deadline_slot_a)
        (lead_component_hold_registered ?lead_service_component)
        (lead_component_has_addon ?lead_service_component ?service_addon)
        (not
          (service_addon_available ?service_addon)
        )
      )
  )
  (:action finalize_lead_addon_assignment
    :parameters (?lead_service_component - lead_service_component ?service_deadline_slot_a - service_deadline_slot_a ?confirmation_token - confirmation_token ?service_addon - service_addon)
    :precondition
      (and
        (booking_entity_confirmed ?lead_service_component)
        (booking_entity_confirmation_token_attached ?lead_service_component ?confirmation_token)
        (lead_component_has_deadline_slot ?lead_service_component ?service_deadline_slot_a)
        (deadline_slot_a_has_addon ?service_deadline_slot_a)
        (lead_component_has_addon ?lead_service_component ?service_addon)
        (not
          (lead_component_ready ?lead_service_component)
        )
      )
    :effect
      (and
        (deadline_slot_a_ready ?service_deadline_slot_a)
        (lead_component_ready ?lead_service_component)
        (service_addon_available ?service_addon)
        (not
          (lead_component_has_addon ?lead_service_component ?service_addon)
        )
      )
  )
  (:action mark_deadline_slot_b_ready
    :parameters (?ancillary_service_component - ancillary_service_component ?service_deadline_slot_b - service_deadline_slot_b ?confirmation_token - confirmation_token)
    :precondition
      (and
        (booking_entity_confirmed ?ancillary_service_component)
        (booking_entity_confirmation_token_attached ?ancillary_service_component ?confirmation_token)
        (ancillary_component_has_deadline_slot ?ancillary_service_component ?service_deadline_slot_b)
        (not
          (deadline_slot_b_ready ?service_deadline_slot_b)
        )
        (not
          (deadline_slot_b_has_addon ?service_deadline_slot_b)
        )
      )
    :effect (deadline_slot_b_ready ?service_deadline_slot_b)
  )
  (:action register_ancillary_hold_with_provider
    :parameters (?ancillary_service_component - ancillary_service_component ?service_deadline_slot_b - service_deadline_slot_b ?provider_endpoint - provider_endpoint)
    :precondition
      (and
        (booking_entity_confirmed ?ancillary_service_component)
        (booking_entity_provider_hold ?ancillary_service_component ?provider_endpoint)
        (ancillary_component_has_deadline_slot ?ancillary_service_component ?service_deadline_slot_b)
        (deadline_slot_b_ready ?service_deadline_slot_b)
        (not
          (ancillary_component_hold_registered ?ancillary_service_component)
        )
      )
    :effect
      (and
        (ancillary_component_hold_registered ?ancillary_service_component)
        (ancillary_component_ready ?ancillary_service_component)
      )
  )
  (:action apply_addon_to_ancillary_component
    :parameters (?ancillary_service_component - ancillary_service_component ?service_deadline_slot_b - service_deadline_slot_b ?service_addon - service_addon)
    :precondition
      (and
        (booking_entity_confirmed ?ancillary_service_component)
        (ancillary_component_has_deadline_slot ?ancillary_service_component ?service_deadline_slot_b)
        (service_addon_available ?service_addon)
        (not
          (ancillary_component_hold_registered ?ancillary_service_component)
        )
      )
    :effect
      (and
        (deadline_slot_b_has_addon ?service_deadline_slot_b)
        (ancillary_component_hold_registered ?ancillary_service_component)
        (ancillary_component_has_addon ?ancillary_service_component ?service_addon)
        (not
          (service_addon_available ?service_addon)
        )
      )
  )
  (:action finalize_ancillary_addon_assignment
    :parameters (?ancillary_service_component - ancillary_service_component ?service_deadline_slot_b - service_deadline_slot_b ?confirmation_token - confirmation_token ?service_addon - service_addon)
    :precondition
      (and
        (booking_entity_confirmed ?ancillary_service_component)
        (booking_entity_confirmation_token_attached ?ancillary_service_component ?confirmation_token)
        (ancillary_component_has_deadline_slot ?ancillary_service_component ?service_deadline_slot_b)
        (deadline_slot_b_has_addon ?service_deadline_slot_b)
        (ancillary_component_has_addon ?ancillary_service_component ?service_addon)
        (not
          (ancillary_component_ready ?ancillary_service_component)
        )
      )
    :effect
      (and
        (deadline_slot_b_ready ?service_deadline_slot_b)
        (ancillary_component_ready ?ancillary_service_component)
        (service_addon_available ?service_addon)
        (not
          (ancillary_component_has_addon ?ancillary_service_component ?service_addon)
        )
      )
  )
  (:action assemble_reservation_record
    :parameters (?lead_service_component - lead_service_component ?ancillary_service_component - ancillary_service_component ?service_deadline_slot_a - service_deadline_slot_a ?service_deadline_slot_b - service_deadline_slot_b ?reservation_record - reservation_record)
    :precondition
      (and
        (lead_component_hold_registered ?lead_service_component)
        (ancillary_component_hold_registered ?ancillary_service_component)
        (lead_component_has_deadline_slot ?lead_service_component ?service_deadline_slot_a)
        (ancillary_component_has_deadline_slot ?ancillary_service_component ?service_deadline_slot_b)
        (deadline_slot_a_ready ?service_deadline_slot_a)
        (deadline_slot_b_ready ?service_deadline_slot_b)
        (lead_component_ready ?lead_service_component)
        (ancillary_component_ready ?ancillary_service_component)
        (reservation_record_template_available ?reservation_record)
      )
    :effect
      (and
        (reservation_record_initialized ?reservation_record)
        (reservation_record_linked_deadline_slot_a ?reservation_record ?service_deadline_slot_a)
        (reservation_record_linked_deadline_slot_b ?reservation_record ?service_deadline_slot_b)
        (not
          (reservation_record_template_available ?reservation_record)
        )
      )
  )
  (:action assemble_reservation_record_with_slot_a_marker
    :parameters (?lead_service_component - lead_service_component ?ancillary_service_component - ancillary_service_component ?service_deadline_slot_a - service_deadline_slot_a ?service_deadline_slot_b - service_deadline_slot_b ?reservation_record - reservation_record)
    :precondition
      (and
        (lead_component_hold_registered ?lead_service_component)
        (ancillary_component_hold_registered ?ancillary_service_component)
        (lead_component_has_deadline_slot ?lead_service_component ?service_deadline_slot_a)
        (ancillary_component_has_deadline_slot ?ancillary_service_component ?service_deadline_slot_b)
        (deadline_slot_a_has_addon ?service_deadline_slot_a)
        (deadline_slot_b_ready ?service_deadline_slot_b)
        (not
          (lead_component_ready ?lead_service_component)
        )
        (ancillary_component_ready ?ancillary_service_component)
        (reservation_record_template_available ?reservation_record)
      )
    :effect
      (and
        (reservation_record_initialized ?reservation_record)
        (reservation_record_linked_deadline_slot_a ?reservation_record ?service_deadline_slot_a)
        (reservation_record_linked_deadline_slot_b ?reservation_record ?service_deadline_slot_b)
        (reservation_record_slot_a_flag ?reservation_record)
        (not
          (reservation_record_template_available ?reservation_record)
        )
      )
  )
  (:action assemble_reservation_record_with_slot_b_marker
    :parameters (?lead_service_component - lead_service_component ?ancillary_service_component - ancillary_service_component ?service_deadline_slot_a - service_deadline_slot_a ?service_deadline_slot_b - service_deadline_slot_b ?reservation_record - reservation_record)
    :precondition
      (and
        (lead_component_hold_registered ?lead_service_component)
        (ancillary_component_hold_registered ?ancillary_service_component)
        (lead_component_has_deadline_slot ?lead_service_component ?service_deadline_slot_a)
        (ancillary_component_has_deadline_slot ?ancillary_service_component ?service_deadline_slot_b)
        (deadline_slot_a_ready ?service_deadline_slot_a)
        (deadline_slot_b_has_addon ?service_deadline_slot_b)
        (lead_component_ready ?lead_service_component)
        (not
          (ancillary_component_ready ?ancillary_service_component)
        )
        (reservation_record_template_available ?reservation_record)
      )
    :effect
      (and
        (reservation_record_initialized ?reservation_record)
        (reservation_record_linked_deadline_slot_a ?reservation_record ?service_deadline_slot_a)
        (reservation_record_linked_deadline_slot_b ?reservation_record ?service_deadline_slot_b)
        (reservation_record_slot_b_flag ?reservation_record)
        (not
          (reservation_record_template_available ?reservation_record)
        )
      )
  )
  (:action assemble_reservation_record_with_both_slot_markers
    :parameters (?lead_service_component - lead_service_component ?ancillary_service_component - ancillary_service_component ?service_deadline_slot_a - service_deadline_slot_a ?service_deadline_slot_b - service_deadline_slot_b ?reservation_record - reservation_record)
    :precondition
      (and
        (lead_component_hold_registered ?lead_service_component)
        (ancillary_component_hold_registered ?ancillary_service_component)
        (lead_component_has_deadline_slot ?lead_service_component ?service_deadline_slot_a)
        (ancillary_component_has_deadline_slot ?ancillary_service_component ?service_deadline_slot_b)
        (deadline_slot_a_has_addon ?service_deadline_slot_a)
        (deadline_slot_b_has_addon ?service_deadline_slot_b)
        (not
          (lead_component_ready ?lead_service_component)
        )
        (not
          (ancillary_component_ready ?ancillary_service_component)
        )
        (reservation_record_template_available ?reservation_record)
      )
    :effect
      (and
        (reservation_record_initialized ?reservation_record)
        (reservation_record_linked_deadline_slot_a ?reservation_record ?service_deadline_slot_a)
        (reservation_record_linked_deadline_slot_b ?reservation_record ?service_deadline_slot_b)
        (reservation_record_slot_a_flag ?reservation_record)
        (reservation_record_slot_b_flag ?reservation_record)
        (not
          (reservation_record_template_available ?reservation_record)
        )
      )
  )
  (:action flag_reservation_ready_for_documents
    :parameters (?reservation_record - reservation_record ?lead_service_component - lead_service_component ?confirmation_token - confirmation_token)
    :precondition
      (and
        (reservation_record_initialized ?reservation_record)
        (lead_component_hold_registered ?lead_service_component)
        (booking_entity_confirmation_token_attached ?lead_service_component ?confirmation_token)
        (not
          (reservation_ready_for_documents ?reservation_record)
        )
      )
    :effect (reservation_ready_for_documents ?reservation_record)
  )
  (:action generate_fulfillment_document
    :parameters (?booking_workflow_instance - booking_workflow_instance ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record)
    :precondition
      (and
        (booking_entity_confirmed ?booking_workflow_instance)
        (workflow_linked_to_reservation_record ?booking_workflow_instance ?reservation_record)
        (workflow_has_fulfillment_document ?booking_workflow_instance ?fulfillment_document)
        (fulfillment_document_available ?fulfillment_document)
        (reservation_record_initialized ?reservation_record)
        (reservation_ready_for_documents ?reservation_record)
        (not
          (fulfillment_document_processed ?fulfillment_document)
        )
      )
    :effect
      (and
        (fulfillment_document_processed ?fulfillment_document)
        (fulfillment_document_linked_to_reservation ?fulfillment_document ?reservation_record)
        (not
          (fulfillment_document_available ?fulfillment_document)
        )
      )
  )
  (:action mark_workflow_document_processed
    :parameters (?booking_workflow_instance - booking_workflow_instance ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record ?confirmation_token - confirmation_token)
    :precondition
      (and
        (booking_entity_confirmed ?booking_workflow_instance)
        (workflow_has_fulfillment_document ?booking_workflow_instance ?fulfillment_document)
        (fulfillment_document_processed ?fulfillment_document)
        (fulfillment_document_linked_to_reservation ?fulfillment_document ?reservation_record)
        (booking_entity_confirmation_token_attached ?booking_workflow_instance ?confirmation_token)
        (not
          (reservation_record_slot_a_flag ?reservation_record)
        )
        (not
          (workflow_document_processed ?booking_workflow_instance)
        )
      )
    :effect (workflow_document_processed ?booking_workflow_instance)
  )
  (:action attach_payment_instrument_to_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?payment_instrument - payment_instrument)
    :precondition
      (and
        (booking_entity_confirmed ?booking_workflow_instance)
        (payment_instrument_available ?payment_instrument)
        (not
          (workflow_payment_attached ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_payment_attached ?booking_workflow_instance)
        (workflow_attached_payment_instrument ?booking_workflow_instance ?payment_instrument)
        (not
          (payment_instrument_available ?payment_instrument)
        )
      )
  )
  (:action process_payment_and_update_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record ?confirmation_token - confirmation_token ?payment_instrument - payment_instrument)
    :precondition
      (and
        (booking_entity_confirmed ?booking_workflow_instance)
        (workflow_has_fulfillment_document ?booking_workflow_instance ?fulfillment_document)
        (fulfillment_document_processed ?fulfillment_document)
        (fulfillment_document_linked_to_reservation ?fulfillment_document ?reservation_record)
        (booking_entity_confirmation_token_attached ?booking_workflow_instance ?confirmation_token)
        (reservation_record_slot_a_flag ?reservation_record)
        (workflow_payment_attached ?booking_workflow_instance)
        (workflow_attached_payment_instrument ?booking_workflow_instance ?payment_instrument)
        (not
          (workflow_document_processed ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_document_processed ?booking_workflow_instance)
        (workflow_payment_verified ?booking_workflow_instance)
      )
  )
  (:action finalize_supplier_confirmation_for_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?supplier_confirmation_token - supplier_confirmation_token ?provider_endpoint - provider_endpoint ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record)
    :precondition
      (and
        (workflow_document_processed ?booking_workflow_instance)
        (workflow_has_supplier_confirmation_token ?booking_workflow_instance ?supplier_confirmation_token)
        (booking_entity_provider_hold ?booking_workflow_instance ?provider_endpoint)
        (workflow_has_fulfillment_document ?booking_workflow_instance ?fulfillment_document)
        (fulfillment_document_linked_to_reservation ?fulfillment_document ?reservation_record)
        (not
          (reservation_record_slot_b_flag ?reservation_record)
        )
        (not
          (workflow_supplier_confirmed ?booking_workflow_instance)
        )
      )
    :effect (workflow_supplier_confirmed ?booking_workflow_instance)
  )
  (:action finalize_supplier_confirmation_for_workflow_slot_b
    :parameters (?booking_workflow_instance - booking_workflow_instance ?supplier_confirmation_token - supplier_confirmation_token ?provider_endpoint - provider_endpoint ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record)
    :precondition
      (and
        (workflow_document_processed ?booking_workflow_instance)
        (workflow_has_supplier_confirmation_token ?booking_workflow_instance ?supplier_confirmation_token)
        (booking_entity_provider_hold ?booking_workflow_instance ?provider_endpoint)
        (workflow_has_fulfillment_document ?booking_workflow_instance ?fulfillment_document)
        (fulfillment_document_linked_to_reservation ?fulfillment_document ?reservation_record)
        (reservation_record_slot_b_flag ?reservation_record)
        (not
          (workflow_supplier_confirmed ?booking_workflow_instance)
        )
      )
    :effect (workflow_supplier_confirmed ?booking_workflow_instance)
  )
  (:action confirm_regulatory_authorization_for_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?regulatory_authorization - regulatory_authorization ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record)
    :precondition
      (and
        (workflow_supplier_confirmed ?booking_workflow_instance)
        (workflow_has_regulatory_authorization ?booking_workflow_instance ?regulatory_authorization)
        (workflow_has_fulfillment_document ?booking_workflow_instance ?fulfillment_document)
        (fulfillment_document_linked_to_reservation ?fulfillment_document ?reservation_record)
        (not
          (reservation_record_slot_a_flag ?reservation_record)
        )
        (not
          (reservation_record_slot_b_flag ?reservation_record)
        )
        (not
          (workflow_authorizations_attached ?booking_workflow_instance)
        )
      )
    :effect (workflow_authorizations_attached ?booking_workflow_instance)
  )
  (:action apply_regulatory_authorization_and_prepare_pricing_with_slot_a
    :parameters (?booking_workflow_instance - booking_workflow_instance ?regulatory_authorization - regulatory_authorization ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record)
    :precondition
      (and
        (workflow_supplier_confirmed ?booking_workflow_instance)
        (workflow_has_regulatory_authorization ?booking_workflow_instance ?regulatory_authorization)
        (workflow_has_fulfillment_document ?booking_workflow_instance ?fulfillment_document)
        (fulfillment_document_linked_to_reservation ?fulfillment_document ?reservation_record)
        (reservation_record_slot_a_flag ?reservation_record)
        (not
          (reservation_record_slot_b_flag ?reservation_record)
        )
        (not
          (workflow_authorizations_attached ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_authorizations_attached ?booking_workflow_instance)
        (workflow_pricing_profile_ready ?booking_workflow_instance)
      )
  )
  (:action apply_regulatory_authorization_and_prepare_pricing_with_slot_b
    :parameters (?booking_workflow_instance - booking_workflow_instance ?regulatory_authorization - regulatory_authorization ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record)
    :precondition
      (and
        (workflow_supplier_confirmed ?booking_workflow_instance)
        (workflow_has_regulatory_authorization ?booking_workflow_instance ?regulatory_authorization)
        (workflow_has_fulfillment_document ?booking_workflow_instance ?fulfillment_document)
        (fulfillment_document_linked_to_reservation ?fulfillment_document ?reservation_record)
        (not
          (reservation_record_slot_a_flag ?reservation_record)
        )
        (reservation_record_slot_b_flag ?reservation_record)
        (not
          (workflow_authorizations_attached ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_authorizations_attached ?booking_workflow_instance)
        (workflow_pricing_profile_ready ?booking_workflow_instance)
      )
  )
  (:action apply_regulatory_authorization_and_prepare_pricing_with_both_slots
    :parameters (?booking_workflow_instance - booking_workflow_instance ?regulatory_authorization - regulatory_authorization ?fulfillment_document - fulfillment_document ?reservation_record - reservation_record)
    :precondition
      (and
        (workflow_supplier_confirmed ?booking_workflow_instance)
        (workflow_has_regulatory_authorization ?booking_workflow_instance ?regulatory_authorization)
        (workflow_has_fulfillment_document ?booking_workflow_instance ?fulfillment_document)
        (fulfillment_document_linked_to_reservation ?fulfillment_document ?reservation_record)
        (reservation_record_slot_a_flag ?reservation_record)
        (reservation_record_slot_b_flag ?reservation_record)
        (not
          (workflow_authorizations_attached ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_authorizations_attached ?booking_workflow_instance)
        (workflow_pricing_profile_ready ?booking_workflow_instance)
      )
  )
  (:action finalize_workflow_commit_to_customer
    :parameters (?booking_workflow_instance - booking_workflow_instance)
    :precondition
      (and
        (workflow_authorizations_attached ?booking_workflow_instance)
        (not
          (workflow_pricing_profile_ready ?booking_workflow_instance)
        )
        (not
          (workflow_finalized ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_finalized ?booking_workflow_instance)
        (booking_entity_committed_to_customer ?booking_workflow_instance)
      )
  )
  (:action attach_pricing_profile_to_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?pricing_profile - pricing_profile)
    :precondition
      (and
        (workflow_authorizations_attached ?booking_workflow_instance)
        (workflow_pricing_profile_ready ?booking_workflow_instance)
        (pricing_profile_available ?pricing_profile)
      )
    :effect
      (and
        (workflow_has_pricing_profile ?booking_workflow_instance ?pricing_profile)
        (not
          (pricing_profile_available ?pricing_profile)
        )
      )
  )
  (:action validate_workflow_for_finalization
    :parameters (?booking_workflow_instance - booking_workflow_instance ?lead_service_component - lead_service_component ?ancillary_service_component - ancillary_service_component ?confirmation_token - confirmation_token ?pricing_profile - pricing_profile)
    :precondition
      (and
        (workflow_authorizations_attached ?booking_workflow_instance)
        (workflow_pricing_profile_ready ?booking_workflow_instance)
        (workflow_has_pricing_profile ?booking_workflow_instance ?pricing_profile)
        (workflow_has_lead_component ?booking_workflow_instance ?lead_service_component)
        (workflow_has_ancillary_component ?booking_workflow_instance ?ancillary_service_component)
        (lead_component_ready ?lead_service_component)
        (ancillary_component_ready ?ancillary_service_component)
        (booking_entity_confirmation_token_attached ?booking_workflow_instance ?confirmation_token)
        (not
          (workflow_validated ?booking_workflow_instance)
        )
      )
    :effect (workflow_validated ?booking_workflow_instance)
  )
  (:action finalize_validated_workflow_commit
    :parameters (?booking_workflow_instance - booking_workflow_instance)
    :precondition
      (and
        (workflow_authorizations_attached ?booking_workflow_instance)
        (workflow_validated ?booking_workflow_instance)
        (not
          (workflow_finalized ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_finalized ?booking_workflow_instance)
        (booking_entity_committed_to_customer ?booking_workflow_instance)
      )
  )
  (:action attach_partner_reference_to_workflow
    :parameters (?booking_workflow_instance - booking_workflow_instance ?partner_reference - partner_reference ?confirmation_token - confirmation_token)
    :precondition
      (and
        (booking_entity_confirmed ?booking_workflow_instance)
        (booking_entity_confirmation_token_attached ?booking_workflow_instance ?confirmation_token)
        (partner_reference_available ?partner_reference)
        (workflow_has_partner_reference ?booking_workflow_instance ?partner_reference)
        (not
          (workflow_partner_reference_attached ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_partner_reference_attached ?booking_workflow_instance)
        (not
          (partner_reference_available ?partner_reference)
        )
      )
  )
  (:action confirm_partner_reference_with_provider
    :parameters (?booking_workflow_instance - booking_workflow_instance ?provider_endpoint - provider_endpoint)
    :precondition
      (and
        (workflow_partner_reference_attached ?booking_workflow_instance)
        (booking_entity_provider_hold ?booking_workflow_instance ?provider_endpoint)
        (not
          (workflow_partner_reference_validated ?booking_workflow_instance)
        )
      )
    :effect (workflow_partner_reference_validated ?booking_workflow_instance)
  )
  (:action confirm_regulatory_authorization
    :parameters (?booking_workflow_instance - booking_workflow_instance ?regulatory_authorization - regulatory_authorization)
    :precondition
      (and
        (workflow_partner_reference_validated ?booking_workflow_instance)
        (workflow_has_regulatory_authorization ?booking_workflow_instance ?regulatory_authorization)
        (not
          (workflow_authorization_confirmed ?booking_workflow_instance)
        )
      )
    :effect (workflow_authorization_confirmed ?booking_workflow_instance)
  )
  (:action finalize_workflow_after_authorization
    :parameters (?booking_workflow_instance - booking_workflow_instance)
    :precondition
      (and
        (workflow_authorization_confirmed ?booking_workflow_instance)
        (not
          (workflow_finalized ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (workflow_finalized ?booking_workflow_instance)
        (booking_entity_committed_to_customer ?booking_workflow_instance)
      )
  )
  (:action commit_reservation_for_lead_component
    :parameters (?lead_service_component - lead_service_component ?reservation_record - reservation_record)
    :precondition
      (and
        (lead_component_hold_registered ?lead_service_component)
        (lead_component_ready ?lead_service_component)
        (reservation_record_initialized ?reservation_record)
        (reservation_ready_for_documents ?reservation_record)
        (not
          (booking_entity_committed_to_customer ?lead_service_component)
        )
      )
    :effect (booking_entity_committed_to_customer ?lead_service_component)
  )
  (:action commit_reservation_for_ancillary_component
    :parameters (?ancillary_service_component - ancillary_service_component ?reservation_record - reservation_record)
    :precondition
      (and
        (ancillary_component_hold_registered ?ancillary_service_component)
        (ancillary_component_ready ?ancillary_service_component)
        (reservation_record_initialized ?reservation_record)
        (reservation_ready_for_documents ?reservation_record)
        (not
          (booking_entity_committed_to_customer ?ancillary_service_component)
        )
      )
    :effect (booking_entity_committed_to_customer ?ancillary_service_component)
  )
  (:action bind_deadline_policy_to_proposal
    :parameters (?booking_proposal - booking_proposal ?deadline_policy - deadline_policy ?confirmation_token - confirmation_token)
    :precondition
      (and
        (booking_entity_committed_to_customer ?booking_proposal)
        (booking_entity_confirmation_token_attached ?booking_proposal ?confirmation_token)
        (deadline_policy_available ?deadline_policy)
        (not
          (booking_entity_commit_bound ?booking_proposal)
        )
      )
    :effect
      (and
        (booking_entity_commit_bound ?booking_proposal)
        (booking_entity_linked_deadline_policy ?booking_proposal ?deadline_policy)
        (not
          (deadline_policy_available ?deadline_policy)
        )
      )
  )
  (:action propagate_commit_to_lead_component
    :parameters (?lead_service_component - lead_service_component ?inventory_item - inventory_item ?deadline_policy - deadline_policy)
    :precondition
      (and
        (booking_entity_commit_bound ?lead_service_component)
        (booking_entity_holds_inventory_item ?lead_service_component ?inventory_item)
        (booking_entity_linked_deadline_policy ?lead_service_component ?deadline_policy)
        (not
          (booking_entity_commit_applied ?lead_service_component)
        )
      )
    :effect
      (and
        (booking_entity_commit_applied ?lead_service_component)
        (inventory_available ?inventory_item)
        (deadline_policy_available ?deadline_policy)
      )
  )
  (:action propagate_commit_to_ancillary_component
    :parameters (?ancillary_service_component - ancillary_service_component ?inventory_item - inventory_item ?deadline_policy - deadline_policy)
    :precondition
      (and
        (booking_entity_commit_bound ?ancillary_service_component)
        (booking_entity_holds_inventory_item ?ancillary_service_component ?inventory_item)
        (booking_entity_linked_deadline_policy ?ancillary_service_component ?deadline_policy)
        (not
          (booking_entity_commit_applied ?ancillary_service_component)
        )
      )
    :effect
      (and
        (booking_entity_commit_applied ?ancillary_service_component)
        (inventory_available ?inventory_item)
        (deadline_policy_available ?deadline_policy)
      )
  )
  (:action propagate_commit_to_workflow_instance
    :parameters (?booking_workflow_instance - booking_workflow_instance ?inventory_item - inventory_item ?deadline_policy - deadline_policy)
    :precondition
      (and
        (booking_entity_commit_bound ?booking_workflow_instance)
        (booking_entity_holds_inventory_item ?booking_workflow_instance ?inventory_item)
        (booking_entity_linked_deadline_policy ?booking_workflow_instance ?deadline_policy)
        (not
          (booking_entity_commit_applied ?booking_workflow_instance)
        )
      )
    :effect
      (and
        (booking_entity_commit_applied ?booking_workflow_instance)
        (inventory_available ?inventory_item)
        (deadline_policy_available ?deadline_policy)
      )
  )
)

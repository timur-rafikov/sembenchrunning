(define (domain hazmat_route_restriction_handling_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource - object asset_group - object location_group - object shipment_descriptor - object hazmat_shipment - shipment_descriptor transport_unit - resource hazard_profile - resource escort_team - resource regulatory_document - resource crew_credential - resource route_restriction - resource special_equipment - resource authority_clearance - resource cargo_item - asset_group container - asset_group operator_license - asset_group origin_node - location_group destination_node - location_group manifest - location_group pickup_delivery_group - hazmat_shipment segment_group - hazmat_shipment pickup_leg - pickup_delivery_group delivery_leg - pickup_delivery_group dispatch_operator - segment_group)
  (:predicates
    (shipment_registered ?hazmat_shipment - hazmat_shipment)
    (entity_validated_for_processing ?hazmat_shipment - hazmat_shipment)
    (shipment_assigned ?hazmat_shipment - hazmat_shipment)
    (route_restriction_applied_entity ?hazmat_shipment - hazmat_shipment)
    (execution_ready_entity ?hazmat_shipment - hazmat_shipment)
    (final_clearance_granted_entity ?hazmat_shipment - hazmat_shipment)
    (transport_unit_available ?transport_unit - transport_unit)
    (assigned_to_transport_unit ?hazmat_shipment - hazmat_shipment ?transport_unit - transport_unit)
    (hazard_profile_available ?hazard_profile - hazard_profile)
    (hazard_profile_assigned_entity ?hazmat_shipment - hazmat_shipment ?hazard_profile - hazard_profile)
    (escort_team_available ?escort_team - escort_team)
    (escort_assigned_to_entity ?hazmat_shipment - hazmat_shipment ?escort_team - escort_team)
    (cargo_item_available ?cargo_item - cargo_item)
    (pickup_leg_has_cargo_item ?pickup_leg - pickup_leg ?cargo_item - cargo_item)
    (delivery_leg_has_cargo_item ?delivery_leg - delivery_leg ?cargo_item - cargo_item)
    (pickup_leg_origin_assigned ?pickup_leg - pickup_leg ?origin_node - origin_node)
    (origin_node_reserved ?origin_node - origin_node)
    (origin_node_staged ?origin_node - origin_node)
    (pickup_leg_ready ?pickup_leg - pickup_leg)
    (delivery_leg_destination_assigned ?delivery_leg - delivery_leg ?destination_node - destination_node)
    (destination_node_reserved ?destination_node - destination_node)
    (destination_node_staged ?destination_node - destination_node)
    (delivery_leg_ready ?delivery_leg - delivery_leg)
    (manifest_available ?manifest - manifest)
    (manifest_reserved ?manifest - manifest)
    (manifest_origin_assigned ?manifest - manifest ?origin_node - origin_node)
    (manifest_destination_assigned ?manifest - manifest ?destination_node - destination_node)
    (manifest_origin_confirmed ?manifest - manifest)
    (manifest_destination_confirmed ?manifest - manifest)
    (manifest_loading_confirmed ?manifest - manifest)
    (operator_assigned_to_pickup_leg ?dispatch_operator - dispatch_operator ?pickup_leg - pickup_leg)
    (operator_assigned_to_delivery_leg ?dispatch_operator - dispatch_operator ?delivery_leg - delivery_leg)
    (operator_assigned_to_manifest ?dispatch_operator - dispatch_operator ?manifest - manifest)
    (container_available ?container - container)
    (operator_has_container ?dispatch_operator - dispatch_operator ?container - container)
    (container_allocated ?container - container)
    (container_assigned_to_manifest ?container - container ?manifest - manifest)
    (operator_containerized ?dispatch_operator - dispatch_operator)
    (operator_prequalified ?dispatch_operator - dispatch_operator)
    (operator_authorized ?dispatch_operator - dispatch_operator)
    (operator_document_attached ?dispatch_operator - dispatch_operator)
    (operator_document_containerized ?dispatch_operator - dispatch_operator)
    (operator_documentation_verified ?dispatch_operator - dispatch_operator)
    (operator_execution_ready ?dispatch_operator - dispatch_operator)
    (operator_license_available ?operator_license - operator_license)
    (operator_has_license ?dispatch_operator - dispatch_operator ?operator_license - operator_license)
    (operator_license_applied ?dispatch_operator - dispatch_operator)
    (operator_license_confirmed ?dispatch_operator - dispatch_operator)
    (operator_clearance_validated ?dispatch_operator - dispatch_operator)
    (regulatory_document_available ?regulatory_document - regulatory_document)
    (operator_regulatory_document_assigned ?dispatch_operator - dispatch_operator ?regulatory_document - regulatory_document)
    (crew_credential_available ?crew_credential - crew_credential)
    (operator_has_crew_credential ?dispatch_operator - dispatch_operator ?crew_credential - crew_credential)
    (special_equipment_available ?special_equipment - special_equipment)
    (operator_has_special_equipment ?dispatch_operator - dispatch_operator ?special_equipment - special_equipment)
    (authority_clearance_available ?authority_clearance - authority_clearance)
    (operator_has_authority_clearance ?dispatch_operator - dispatch_operator ?authority_clearance - authority_clearance)
    (route_restriction_available ?route_restriction - route_restriction)
    (assigned_route_restriction ?hazmat_shipment - hazmat_shipment ?route_restriction - route_restriction)
    (pickup_leg_activated ?pickup_leg - pickup_leg)
    (delivery_leg_activated ?delivery_leg - delivery_leg)
    (operator_dispatch_scheduled ?dispatch_operator - dispatch_operator)
  )
  (:action register_hazmat_shipment
    :parameters (?hazmat_shipment - hazmat_shipment)
    :precondition
      (and
        (not
          (shipment_registered ?hazmat_shipment)
        )
        (not
          (route_restriction_applied_entity ?hazmat_shipment)
        )
      )
    :effect (shipment_registered ?hazmat_shipment)
  )
  (:action assign_transport_unit_to_shipment
    :parameters (?hazmat_shipment - hazmat_shipment ?transport_unit - transport_unit)
    :precondition
      (and
        (shipment_registered ?hazmat_shipment)
        (not
          (shipment_assigned ?hazmat_shipment)
        )
        (transport_unit_available ?transport_unit)
      )
    :effect
      (and
        (shipment_assigned ?hazmat_shipment)
        (assigned_to_transport_unit ?hazmat_shipment ?transport_unit)
        (not
          (transport_unit_available ?transport_unit)
        )
      )
  )
  (:action attach_hazard_profile
    :parameters (?hazmat_shipment - hazmat_shipment ?hazard_profile - hazard_profile)
    :precondition
      (and
        (shipment_registered ?hazmat_shipment)
        (shipment_assigned ?hazmat_shipment)
        (hazard_profile_available ?hazard_profile)
      )
    :effect
      (and
        (hazard_profile_assigned_entity ?hazmat_shipment ?hazard_profile)
        (not
          (hazard_profile_available ?hazard_profile)
        )
      )
  )
  (:action validate_hazard_profile
    :parameters (?hazmat_shipment - hazmat_shipment ?hazard_profile - hazard_profile)
    :precondition
      (and
        (shipment_registered ?hazmat_shipment)
        (shipment_assigned ?hazmat_shipment)
        (hazard_profile_assigned_entity ?hazmat_shipment ?hazard_profile)
        (not
          (entity_validated_for_processing ?hazmat_shipment)
        )
      )
    :effect (entity_validated_for_processing ?hazmat_shipment)
  )
  (:action rollback_hazard_profile_attachment
    :parameters (?hazmat_shipment - hazmat_shipment ?hazard_profile - hazard_profile)
    :precondition
      (and
        (hazard_profile_assigned_entity ?hazmat_shipment ?hazard_profile)
      )
    :effect
      (and
        (hazard_profile_available ?hazard_profile)
        (not
          (hazard_profile_assigned_entity ?hazmat_shipment ?hazard_profile)
        )
      )
  )
  (:action assign_escort_team_to_shipment
    :parameters (?hazmat_shipment - hazmat_shipment ?escort_team - escort_team)
    :precondition
      (and
        (entity_validated_for_processing ?hazmat_shipment)
        (escort_team_available ?escort_team)
      )
    :effect
      (and
        (escort_assigned_to_entity ?hazmat_shipment ?escort_team)
        (not
          (escort_team_available ?escort_team)
        )
      )
  )
  (:action release_escort_team_from_shipment
    :parameters (?hazmat_shipment - hazmat_shipment ?escort_team - escort_team)
    :precondition
      (and
        (escort_assigned_to_entity ?hazmat_shipment ?escort_team)
      )
    :effect
      (and
        (escort_team_available ?escort_team)
        (not
          (escort_assigned_to_entity ?hazmat_shipment ?escort_team)
        )
      )
  )
  (:action assign_special_equipment_to_operator
    :parameters (?dispatch_operator - dispatch_operator ?special_equipment - special_equipment)
    :precondition
      (and
        (entity_validated_for_processing ?dispatch_operator)
        (special_equipment_available ?special_equipment)
      )
    :effect
      (and
        (operator_has_special_equipment ?dispatch_operator ?special_equipment)
        (not
          (special_equipment_available ?special_equipment)
        )
      )
  )
  (:action release_special_equipment_from_operator
    :parameters (?dispatch_operator - dispatch_operator ?special_equipment - special_equipment)
    :precondition
      (and
        (operator_has_special_equipment ?dispatch_operator ?special_equipment)
      )
    :effect
      (and
        (special_equipment_available ?special_equipment)
        (not
          (operator_has_special_equipment ?dispatch_operator ?special_equipment)
        )
      )
  )
  (:action assign_authority_clearance_to_operator
    :parameters (?dispatch_operator - dispatch_operator ?authority_clearance - authority_clearance)
    :precondition
      (and
        (entity_validated_for_processing ?dispatch_operator)
        (authority_clearance_available ?authority_clearance)
      )
    :effect
      (and
        (operator_has_authority_clearance ?dispatch_operator ?authority_clearance)
        (not
          (authority_clearance_available ?authority_clearance)
        )
      )
  )
  (:action revoke_authority_clearance_from_operator
    :parameters (?dispatch_operator - dispatch_operator ?authority_clearance - authority_clearance)
    :precondition
      (and
        (operator_has_authority_clearance ?dispatch_operator ?authority_clearance)
      )
    :effect
      (and
        (authority_clearance_available ?authority_clearance)
        (not
          (operator_has_authority_clearance ?dispatch_operator ?authority_clearance)
        )
      )
  )
  (:action reserve_origin_node_for_pickup_leg
    :parameters (?pickup_leg - pickup_leg ?origin_node - origin_node ?hazard_profile - hazard_profile)
    :precondition
      (and
        (entity_validated_for_processing ?pickup_leg)
        (hazard_profile_assigned_entity ?pickup_leg ?hazard_profile)
        (pickup_leg_origin_assigned ?pickup_leg ?origin_node)
        (not
          (origin_node_reserved ?origin_node)
        )
        (not
          (origin_node_staged ?origin_node)
        )
      )
    :effect (origin_node_reserved ?origin_node)
  )
  (:action assign_escort_to_pickup_leg
    :parameters (?pickup_leg - pickup_leg ?origin_node - origin_node ?escort_team - escort_team)
    :precondition
      (and
        (entity_validated_for_processing ?pickup_leg)
        (escort_assigned_to_entity ?pickup_leg ?escort_team)
        (pickup_leg_origin_assigned ?pickup_leg ?origin_node)
        (origin_node_reserved ?origin_node)
        (not
          (pickup_leg_activated ?pickup_leg)
        )
      )
    :effect
      (and
        (pickup_leg_activated ?pickup_leg)
        (pickup_leg_ready ?pickup_leg)
      )
  )
  (:action stage_cargo_at_origin_node
    :parameters (?pickup_leg - pickup_leg ?origin_node - origin_node ?cargo_item - cargo_item)
    :precondition
      (and
        (entity_validated_for_processing ?pickup_leg)
        (pickup_leg_origin_assigned ?pickup_leg ?origin_node)
        (cargo_item_available ?cargo_item)
        (not
          (pickup_leg_activated ?pickup_leg)
        )
      )
    :effect
      (and
        (origin_node_staged ?origin_node)
        (pickup_leg_activated ?pickup_leg)
        (pickup_leg_has_cargo_item ?pickup_leg ?cargo_item)
        (not
          (cargo_item_available ?cargo_item)
        )
      )
  )
  (:action complete_pickup_staging
    :parameters (?pickup_leg - pickup_leg ?origin_node - origin_node ?hazard_profile - hazard_profile ?cargo_item - cargo_item)
    :precondition
      (and
        (entity_validated_for_processing ?pickup_leg)
        (hazard_profile_assigned_entity ?pickup_leg ?hazard_profile)
        (pickup_leg_origin_assigned ?pickup_leg ?origin_node)
        (origin_node_staged ?origin_node)
        (pickup_leg_has_cargo_item ?pickup_leg ?cargo_item)
        (not
          (pickup_leg_ready ?pickup_leg)
        )
      )
    :effect
      (and
        (origin_node_reserved ?origin_node)
        (pickup_leg_ready ?pickup_leg)
        (cargo_item_available ?cargo_item)
        (not
          (pickup_leg_has_cargo_item ?pickup_leg ?cargo_item)
        )
      )
  )
  (:action reserve_destination_node_for_delivery_leg
    :parameters (?delivery_leg - delivery_leg ?destination_node - destination_node ?hazard_profile - hazard_profile)
    :precondition
      (and
        (entity_validated_for_processing ?delivery_leg)
        (hazard_profile_assigned_entity ?delivery_leg ?hazard_profile)
        (delivery_leg_destination_assigned ?delivery_leg ?destination_node)
        (not
          (destination_node_reserved ?destination_node)
        )
        (not
          (destination_node_staged ?destination_node)
        )
      )
    :effect (destination_node_reserved ?destination_node)
  )
  (:action assign_escort_to_delivery_leg
    :parameters (?delivery_leg - delivery_leg ?destination_node - destination_node ?escort_team - escort_team)
    :precondition
      (and
        (entity_validated_for_processing ?delivery_leg)
        (escort_assigned_to_entity ?delivery_leg ?escort_team)
        (delivery_leg_destination_assigned ?delivery_leg ?destination_node)
        (destination_node_reserved ?destination_node)
        (not
          (delivery_leg_activated ?delivery_leg)
        )
      )
    :effect
      (and
        (delivery_leg_activated ?delivery_leg)
        (delivery_leg_ready ?delivery_leg)
      )
  )
  (:action stage_cargo_at_destination_node
    :parameters (?delivery_leg - delivery_leg ?destination_node - destination_node ?cargo_item - cargo_item)
    :precondition
      (and
        (entity_validated_for_processing ?delivery_leg)
        (delivery_leg_destination_assigned ?delivery_leg ?destination_node)
        (cargo_item_available ?cargo_item)
        (not
          (delivery_leg_activated ?delivery_leg)
        )
      )
    :effect
      (and
        (destination_node_staged ?destination_node)
        (delivery_leg_activated ?delivery_leg)
        (delivery_leg_has_cargo_item ?delivery_leg ?cargo_item)
        (not
          (cargo_item_available ?cargo_item)
        )
      )
  )
  (:action complete_delivery_staging
    :parameters (?delivery_leg - delivery_leg ?destination_node - destination_node ?hazard_profile - hazard_profile ?cargo_item - cargo_item)
    :precondition
      (and
        (entity_validated_for_processing ?delivery_leg)
        (hazard_profile_assigned_entity ?delivery_leg ?hazard_profile)
        (delivery_leg_destination_assigned ?delivery_leg ?destination_node)
        (destination_node_staged ?destination_node)
        (delivery_leg_has_cargo_item ?delivery_leg ?cargo_item)
        (not
          (delivery_leg_ready ?delivery_leg)
        )
      )
    :effect
      (and
        (destination_node_reserved ?destination_node)
        (delivery_leg_ready ?delivery_leg)
        (cargo_item_available ?cargo_item)
        (not
          (delivery_leg_has_cargo_item ?delivery_leg ?cargo_item)
        )
      )
  )
  (:action consolidate_manifest_and_bind_nodes
    :parameters (?pickup_leg - pickup_leg ?delivery_leg - delivery_leg ?origin_node - origin_node ?destination_node - destination_node ?manifest - manifest)
    :precondition
      (and
        (pickup_leg_activated ?pickup_leg)
        (delivery_leg_activated ?delivery_leg)
        (pickup_leg_origin_assigned ?pickup_leg ?origin_node)
        (delivery_leg_destination_assigned ?delivery_leg ?destination_node)
        (origin_node_reserved ?origin_node)
        (destination_node_reserved ?destination_node)
        (pickup_leg_ready ?pickup_leg)
        (delivery_leg_ready ?delivery_leg)
        (manifest_available ?manifest)
      )
    :effect
      (and
        (manifest_reserved ?manifest)
        (manifest_origin_assigned ?manifest ?origin_node)
        (manifest_destination_assigned ?manifest ?destination_node)
        (not
          (manifest_available ?manifest)
        )
      )
  )
  (:action consolidate_manifest_with_origin_staged
    :parameters (?pickup_leg - pickup_leg ?delivery_leg - delivery_leg ?origin_node - origin_node ?destination_node - destination_node ?manifest - manifest)
    :precondition
      (and
        (pickup_leg_activated ?pickup_leg)
        (delivery_leg_activated ?delivery_leg)
        (pickup_leg_origin_assigned ?pickup_leg ?origin_node)
        (delivery_leg_destination_assigned ?delivery_leg ?destination_node)
        (origin_node_staged ?origin_node)
        (destination_node_reserved ?destination_node)
        (not
          (pickup_leg_ready ?pickup_leg)
        )
        (delivery_leg_ready ?delivery_leg)
        (manifest_available ?manifest)
      )
    :effect
      (and
        (manifest_reserved ?manifest)
        (manifest_origin_assigned ?manifest ?origin_node)
        (manifest_destination_assigned ?manifest ?destination_node)
        (manifest_origin_confirmed ?manifest)
        (not
          (manifest_available ?manifest)
        )
      )
  )
  (:action consolidate_manifest_with_destination_staged
    :parameters (?pickup_leg - pickup_leg ?delivery_leg - delivery_leg ?origin_node - origin_node ?destination_node - destination_node ?manifest - manifest)
    :precondition
      (and
        (pickup_leg_activated ?pickup_leg)
        (delivery_leg_activated ?delivery_leg)
        (pickup_leg_origin_assigned ?pickup_leg ?origin_node)
        (delivery_leg_destination_assigned ?delivery_leg ?destination_node)
        (origin_node_reserved ?origin_node)
        (destination_node_staged ?destination_node)
        (pickup_leg_ready ?pickup_leg)
        (not
          (delivery_leg_ready ?delivery_leg)
        )
        (manifest_available ?manifest)
      )
    :effect
      (and
        (manifest_reserved ?manifest)
        (manifest_origin_assigned ?manifest ?origin_node)
        (manifest_destination_assigned ?manifest ?destination_node)
        (manifest_destination_confirmed ?manifest)
        (not
          (manifest_available ?manifest)
        )
      )
  )
  (:action consolidate_manifest_with_both_nodes_staged
    :parameters (?pickup_leg - pickup_leg ?delivery_leg - delivery_leg ?origin_node - origin_node ?destination_node - destination_node ?manifest - manifest)
    :precondition
      (and
        (pickup_leg_activated ?pickup_leg)
        (delivery_leg_activated ?delivery_leg)
        (pickup_leg_origin_assigned ?pickup_leg ?origin_node)
        (delivery_leg_destination_assigned ?delivery_leg ?destination_node)
        (origin_node_staged ?origin_node)
        (destination_node_staged ?destination_node)
        (not
          (pickup_leg_ready ?pickup_leg)
        )
        (not
          (delivery_leg_ready ?delivery_leg)
        )
        (manifest_available ?manifest)
      )
    :effect
      (and
        (manifest_reserved ?manifest)
        (manifest_origin_assigned ?manifest ?origin_node)
        (manifest_destination_assigned ?manifest ?destination_node)
        (manifest_origin_confirmed ?manifest)
        (manifest_destination_confirmed ?manifest)
        (not
          (manifest_available ?manifest)
        )
      )
  )
  (:action confirm_manifest_loading
    :parameters (?manifest - manifest ?pickup_leg - pickup_leg ?hazard_profile - hazard_profile)
    :precondition
      (and
        (manifest_reserved ?manifest)
        (pickup_leg_activated ?pickup_leg)
        (hazard_profile_assigned_entity ?pickup_leg ?hazard_profile)
        (not
          (manifest_loading_confirmed ?manifest)
        )
      )
    :effect (manifest_loading_confirmed ?manifest)
  )
  (:action assign_container_to_manifest
    :parameters (?dispatch_operator - dispatch_operator ?container - container ?manifest - manifest)
    :precondition
      (and
        (entity_validated_for_processing ?dispatch_operator)
        (operator_assigned_to_manifest ?dispatch_operator ?manifest)
        (operator_has_container ?dispatch_operator ?container)
        (container_available ?container)
        (manifest_reserved ?manifest)
        (manifest_loading_confirmed ?manifest)
        (not
          (container_allocated ?container)
        )
      )
    :effect
      (and
        (container_allocated ?container)
        (container_assigned_to_manifest ?container ?manifest)
        (not
          (container_available ?container)
        )
      )
  )
  (:action confirm_operator_containerization
    :parameters (?dispatch_operator - dispatch_operator ?container - container ?manifest - manifest ?hazard_profile - hazard_profile)
    :precondition
      (and
        (entity_validated_for_processing ?dispatch_operator)
        (operator_has_container ?dispatch_operator ?container)
        (container_allocated ?container)
        (container_assigned_to_manifest ?container ?manifest)
        (hazard_profile_assigned_entity ?dispatch_operator ?hazard_profile)
        (not
          (manifest_origin_confirmed ?manifest)
        )
        (not
          (operator_containerized ?dispatch_operator)
        )
      )
    :effect (operator_containerized ?dispatch_operator)
  )
  (:action attach_regulatory_document_to_operator
    :parameters (?dispatch_operator - dispatch_operator ?regulatory_document - regulatory_document)
    :precondition
      (and
        (entity_validated_for_processing ?dispatch_operator)
        (regulatory_document_available ?regulatory_document)
        (not
          (operator_document_attached ?dispatch_operator)
        )
      )
    :effect
      (and
        (operator_document_attached ?dispatch_operator)
        (operator_regulatory_document_assigned ?dispatch_operator ?regulatory_document)
        (not
          (regulatory_document_available ?regulatory_document)
        )
      )
  )
  (:action associate_document_and_container_with_operator
    :parameters (?dispatch_operator - dispatch_operator ?container - container ?manifest - manifest ?hazard_profile - hazard_profile ?regulatory_document - regulatory_document)
    :precondition
      (and
        (entity_validated_for_processing ?dispatch_operator)
        (operator_has_container ?dispatch_operator ?container)
        (container_allocated ?container)
        (container_assigned_to_manifest ?container ?manifest)
        (hazard_profile_assigned_entity ?dispatch_operator ?hazard_profile)
        (manifest_origin_confirmed ?manifest)
        (operator_document_attached ?dispatch_operator)
        (operator_regulatory_document_assigned ?dispatch_operator ?regulatory_document)
        (not
          (operator_containerized ?dispatch_operator)
        )
      )
    :effect
      (and
        (operator_containerized ?dispatch_operator)
        (operator_document_containerized ?dispatch_operator)
      )
  )
  (:action prequalify_operator_with_container_and_equipment
    :parameters (?dispatch_operator - dispatch_operator ?special_equipment - special_equipment ?escort_team - escort_team ?container - container ?manifest - manifest)
    :precondition
      (and
        (operator_containerized ?dispatch_operator)
        (operator_has_special_equipment ?dispatch_operator ?special_equipment)
        (escort_assigned_to_entity ?dispatch_operator ?escort_team)
        (operator_has_container ?dispatch_operator ?container)
        (container_assigned_to_manifest ?container ?manifest)
        (not
          (manifest_destination_confirmed ?manifest)
        )
        (not
          (operator_prequalified ?dispatch_operator)
        )
      )
    :effect (operator_prequalified ?dispatch_operator)
  )
  (:action prequalify_operator_with_container_equipment_and_manifest_destination
    :parameters (?dispatch_operator - dispatch_operator ?special_equipment - special_equipment ?escort_team - escort_team ?container - container ?manifest - manifest)
    :precondition
      (and
        (operator_containerized ?dispatch_operator)
        (operator_has_special_equipment ?dispatch_operator ?special_equipment)
        (escort_assigned_to_entity ?dispatch_operator ?escort_team)
        (operator_has_container ?dispatch_operator ?container)
        (container_assigned_to_manifest ?container ?manifest)
        (manifest_destination_confirmed ?manifest)
        (not
          (operator_prequalified ?dispatch_operator)
        )
      )
    :effect (operator_prequalified ?dispatch_operator)
  )
  (:action authorize_operator_with_clearance
    :parameters (?dispatch_operator - dispatch_operator ?authority_clearance - authority_clearance ?container - container ?manifest - manifest)
    :precondition
      (and
        (operator_prequalified ?dispatch_operator)
        (operator_has_authority_clearance ?dispatch_operator ?authority_clearance)
        (operator_has_container ?dispatch_operator ?container)
        (container_assigned_to_manifest ?container ?manifest)
        (not
          (manifest_origin_confirmed ?manifest)
        )
        (not
          (manifest_destination_confirmed ?manifest)
        )
        (not
          (operator_authorized ?dispatch_operator)
        )
      )
    :effect (operator_authorized ?dispatch_operator)
  )
  (:action authorize_and_verify_operator_documentation
    :parameters (?dispatch_operator - dispatch_operator ?authority_clearance - authority_clearance ?container - container ?manifest - manifest)
    :precondition
      (and
        (operator_prequalified ?dispatch_operator)
        (operator_has_authority_clearance ?dispatch_operator ?authority_clearance)
        (operator_has_container ?dispatch_operator ?container)
        (container_assigned_to_manifest ?container ?manifest)
        (manifest_origin_confirmed ?manifest)
        (not
          (manifest_destination_confirmed ?manifest)
        )
        (not
          (operator_authorized ?dispatch_operator)
        )
      )
    :effect
      (and
        (operator_authorized ?dispatch_operator)
        (operator_documentation_verified ?dispatch_operator)
      )
  )
  (:action authorize_and_verify_operator_with_destination_confirmation
    :parameters (?dispatch_operator - dispatch_operator ?authority_clearance - authority_clearance ?container - container ?manifest - manifest)
    :precondition
      (and
        (operator_prequalified ?dispatch_operator)
        (operator_has_authority_clearance ?dispatch_operator ?authority_clearance)
        (operator_has_container ?dispatch_operator ?container)
        (container_assigned_to_manifest ?container ?manifest)
        (not
          (manifest_origin_confirmed ?manifest)
        )
        (manifest_destination_confirmed ?manifest)
        (not
          (operator_authorized ?dispatch_operator)
        )
      )
    :effect
      (and
        (operator_authorized ?dispatch_operator)
        (operator_documentation_verified ?dispatch_operator)
      )
  )
  (:action authorize_and_verify_operator_with_all_confirmations
    :parameters (?dispatch_operator - dispatch_operator ?authority_clearance - authority_clearance ?container - container ?manifest - manifest)
    :precondition
      (and
        (operator_prequalified ?dispatch_operator)
        (operator_has_authority_clearance ?dispatch_operator ?authority_clearance)
        (operator_has_container ?dispatch_operator ?container)
        (container_assigned_to_manifest ?container ?manifest)
        (manifest_origin_confirmed ?manifest)
        (manifest_destination_confirmed ?manifest)
        (not
          (operator_authorized ?dispatch_operator)
        )
      )
    :effect
      (and
        (operator_authorized ?dispatch_operator)
        (operator_documentation_verified ?dispatch_operator)
      )
  )
  (:action schedule_operator_for_dispatch
    :parameters (?dispatch_operator - dispatch_operator)
    :precondition
      (and
        (operator_authorized ?dispatch_operator)
        (not
          (operator_documentation_verified ?dispatch_operator)
        )
        (not
          (operator_dispatch_scheduled ?dispatch_operator)
        )
      )
    :effect
      (and
        (operator_dispatch_scheduled ?dispatch_operator)
        (execution_ready_entity ?dispatch_operator)
      )
  )
  (:action attach_crew_credential_to_operator
    :parameters (?dispatch_operator - dispatch_operator ?crew_credential - crew_credential)
    :precondition
      (and
        (operator_authorized ?dispatch_operator)
        (operator_documentation_verified ?dispatch_operator)
        (crew_credential_available ?crew_credential)
      )
    :effect
      (and
        (operator_has_crew_credential ?dispatch_operator ?crew_credential)
        (not
          (crew_credential_available ?crew_credential)
        )
      )
  )
  (:action perform_operator_final_readiness_check
    :parameters (?dispatch_operator - dispatch_operator ?pickup_leg - pickup_leg ?delivery_leg - delivery_leg ?hazard_profile - hazard_profile ?crew_credential - crew_credential)
    :precondition
      (and
        (operator_authorized ?dispatch_operator)
        (operator_documentation_verified ?dispatch_operator)
        (operator_has_crew_credential ?dispatch_operator ?crew_credential)
        (operator_assigned_to_pickup_leg ?dispatch_operator ?pickup_leg)
        (operator_assigned_to_delivery_leg ?dispatch_operator ?delivery_leg)
        (pickup_leg_ready ?pickup_leg)
        (delivery_leg_ready ?delivery_leg)
        (hazard_profile_assigned_entity ?dispatch_operator ?hazard_profile)
        (not
          (operator_execution_ready ?dispatch_operator)
        )
      )
    :effect (operator_execution_ready ?dispatch_operator)
  )
  (:action finalize_operator_dispatch
    :parameters (?dispatch_operator - dispatch_operator)
    :precondition
      (and
        (operator_authorized ?dispatch_operator)
        (operator_execution_ready ?dispatch_operator)
        (not
          (operator_dispatch_scheduled ?dispatch_operator)
        )
      )
    :effect
      (and
        (operator_dispatch_scheduled ?dispatch_operator)
        (execution_ready_entity ?dispatch_operator)
      )
  )
  (:action apply_operator_license
    :parameters (?dispatch_operator - dispatch_operator ?operator_license - operator_license ?hazard_profile - hazard_profile)
    :precondition
      (and
        (entity_validated_for_processing ?dispatch_operator)
        (hazard_profile_assigned_entity ?dispatch_operator ?hazard_profile)
        (operator_license_available ?operator_license)
        (operator_has_license ?dispatch_operator ?operator_license)
        (not
          (operator_license_applied ?dispatch_operator)
        )
      )
    :effect
      (and
        (operator_license_applied ?dispatch_operator)
        (not
          (operator_license_available ?operator_license)
        )
      )
  )
  (:action confirm_operator_license
    :parameters (?dispatch_operator - dispatch_operator ?escort_team - escort_team)
    :precondition
      (and
        (operator_license_applied ?dispatch_operator)
        (escort_assigned_to_entity ?dispatch_operator ?escort_team)
        (not
          (operator_license_confirmed ?dispatch_operator)
        )
      )
    :effect (operator_license_confirmed ?dispatch_operator)
  )
  (:action validate_operator_clearance
    :parameters (?dispatch_operator - dispatch_operator ?authority_clearance - authority_clearance)
    :precondition
      (and
        (operator_license_confirmed ?dispatch_operator)
        (operator_has_authority_clearance ?dispatch_operator ?authority_clearance)
        (not
          (operator_clearance_validated ?dispatch_operator)
        )
      )
    :effect (operator_clearance_validated ?dispatch_operator)
  )
  (:action activate_operator_from_clearance
    :parameters (?dispatch_operator - dispatch_operator)
    :precondition
      (and
        (operator_clearance_validated ?dispatch_operator)
        (not
          (operator_dispatch_scheduled ?dispatch_operator)
        )
      )
    :effect
      (and
        (operator_dispatch_scheduled ?dispatch_operator)
        (execution_ready_entity ?dispatch_operator)
      )
  )
  (:action set_pickup_leg_execution_ready
    :parameters (?pickup_leg - pickup_leg ?manifest - manifest)
    :precondition
      (and
        (pickup_leg_activated ?pickup_leg)
        (pickup_leg_ready ?pickup_leg)
        (manifest_reserved ?manifest)
        (manifest_loading_confirmed ?manifest)
        (not
          (execution_ready_entity ?pickup_leg)
        )
      )
    :effect (execution_ready_entity ?pickup_leg)
  )
  (:action set_delivery_leg_execution_ready
    :parameters (?delivery_leg - delivery_leg ?manifest - manifest)
    :precondition
      (and
        (delivery_leg_activated ?delivery_leg)
        (delivery_leg_ready ?delivery_leg)
        (manifest_reserved ?manifest)
        (manifest_loading_confirmed ?manifest)
        (not
          (execution_ready_entity ?delivery_leg)
        )
      )
    :effect (execution_ready_entity ?delivery_leg)
  )
  (:action apply_route_restriction_to_shipment
    :parameters (?hazmat_shipment - hazmat_shipment ?route_restriction - route_restriction ?hazard_profile - hazard_profile)
    :precondition
      (and
        (execution_ready_entity ?hazmat_shipment)
        (hazard_profile_assigned_entity ?hazmat_shipment ?hazard_profile)
        (route_restriction_available ?route_restriction)
        (not
          (final_clearance_granted_entity ?hazmat_shipment)
        )
      )
    :effect
      (and
        (final_clearance_granted_entity ?hazmat_shipment)
        (assigned_route_restriction ?hazmat_shipment ?route_restriction)
        (not
          (route_restriction_available ?route_restriction)
        )
      )
  )
  (:action enforce_route_restriction_on_pickup_leg
    :parameters (?pickup_leg - pickup_leg ?transport_unit - transport_unit ?route_restriction - route_restriction)
    :precondition
      (and
        (final_clearance_granted_entity ?pickup_leg)
        (assigned_to_transport_unit ?pickup_leg ?transport_unit)
        (assigned_route_restriction ?pickup_leg ?route_restriction)
        (not
          (route_restriction_applied_entity ?pickup_leg)
        )
      )
    :effect
      (and
        (route_restriction_applied_entity ?pickup_leg)
        (transport_unit_available ?transport_unit)
        (route_restriction_available ?route_restriction)
      )
  )
  (:action enforce_route_restriction_on_delivery_leg
    :parameters (?delivery_leg - delivery_leg ?transport_unit - transport_unit ?route_restriction - route_restriction)
    :precondition
      (and
        (final_clearance_granted_entity ?delivery_leg)
        (assigned_to_transport_unit ?delivery_leg ?transport_unit)
        (assigned_route_restriction ?delivery_leg ?route_restriction)
        (not
          (route_restriction_applied_entity ?delivery_leg)
        )
      )
    :effect
      (and
        (route_restriction_applied_entity ?delivery_leg)
        (transport_unit_available ?transport_unit)
        (route_restriction_available ?route_restriction)
      )
  )
  (:action enforce_route_restriction_on_operator
    :parameters (?dispatch_operator - dispatch_operator ?transport_unit - transport_unit ?route_restriction - route_restriction)
    :precondition
      (and
        (final_clearance_granted_entity ?dispatch_operator)
        (assigned_to_transport_unit ?dispatch_operator ?transport_unit)
        (assigned_route_restriction ?dispatch_operator ?route_restriction)
        (not
          (route_restriction_applied_entity ?dispatch_operator)
        )
      )
    :effect
      (and
        (route_restriction_applied_entity ?dispatch_operator)
        (transport_unit_available ?transport_unit)
        (route_restriction_available ?route_restriction)
      )
  )
)

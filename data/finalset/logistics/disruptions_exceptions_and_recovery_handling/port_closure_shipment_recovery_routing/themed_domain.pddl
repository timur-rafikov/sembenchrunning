(define (domain port_closure_shipment_recovery_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object resource_category - domain_object mode_category - domain_object operational_option_category - domain_object shipment_aggregate - domain_object affected_shipment - shipment_aggregate carrier_resource - resource_category transport_mode_option - resource_category stakeholder_contact - resource_category permit - resource_category resource_bundle - resource_category claim_file - resource_category equipment_asset - resource_category external_approval - resource_category logistics_document - mode_category container_unit - mode_category incident_report - mode_category alternate_port - operational_option_category alternate_route - operational_option_category routing_solution - operational_option_category shipment_component - affected_shipment shipment_component_variant - affected_shipment shipment_segment_origin - shipment_component shipment_segment_destination - shipment_component recovery_case - shipment_component_variant)

  (:predicates
    (shipment_identified ?affected_shipment - affected_shipment)
    (recovery_initiated ?affected_shipment - affected_shipment)
    (carrier_assigned ?affected_shipment - affected_shipment)
    (recovery_routing_applied ?affected_shipment - affected_shipment)
    (service_restoration_confirmed ?affected_shipment - affected_shipment)
    (case_claim_opened ?affected_shipment - affected_shipment)
    (carrier_resource_available ?carrier_resource - carrier_resource)
    (shipment_assigned_to_carrier ?affected_shipment - affected_shipment ?carrier_resource - carrier_resource)
    (mode_option_available ?transport_mode_option - transport_mode_option)
    (transport_mode_reserved ?affected_shipment - affected_shipment ?transport_mode_option - transport_mode_option)
    (stakeholder_contact_available ?stakeholder_contact - stakeholder_contact)
    (shipment_assigned_contact ?affected_shipment - affected_shipment ?stakeholder_contact - stakeholder_contact)
    (logistics_document_available ?logistics_document - logistics_document)
    (origin_segment_assigned_document ?shipment_segment_origin - shipment_segment_origin ?logistics_document - logistics_document)
    (destination_segment_assigned_document ?shipment_segment_destination - shipment_segment_destination ?logistics_document - logistics_document)
    (segment_candidate_alternate_port ?shipment_segment_origin - shipment_segment_origin ?alternate_port - alternate_port)
    (alternate_port_validated ?alternate_port - alternate_port)
    (alternate_port_document_registered ?alternate_port - alternate_port)
    (origin_segment_validated ?shipment_segment_origin - shipment_segment_origin)
    (segment_candidate_alternate_route ?shipment_segment_destination - shipment_segment_destination ?alternate_route - alternate_route)
    (alternate_route_validated ?alternate_route - alternate_route)
    (alternate_route_document_registered ?alternate_route - alternate_route)
    (destination_segment_validated ?shipment_segment_destination - shipment_segment_destination)
    (routing_solution_available ?routing_solution - routing_solution)
    (routing_solution_selected ?routing_solution - routing_solution)
    (routing_solution_has_port ?routing_solution - routing_solution ?alternate_port - alternate_port)
    (routing_solution_has_route ?routing_solution - routing_solution ?alternate_route - alternate_route)
    (routing_solution_requires_permit ?routing_solution - routing_solution)
    (routing_solution_requires_external_approval ?routing_solution - routing_solution)
    (routing_solution_scheduled ?routing_solution - routing_solution)
    (case_includes_origin_segment ?recovery_case - recovery_case ?shipment_segment_origin - shipment_segment_origin)
    (case_includes_destination_segment ?recovery_case - recovery_case ?shipment_segment_destination - shipment_segment_destination)
    (case_includes_routing_solution ?recovery_case - recovery_case ?routing_solution - routing_solution)
    (container_unit_available ?container_unit - container_unit)
    (case_has_container_unit ?recovery_case - recovery_case ?container_unit - container_unit)
    (container_unit_allocated ?container_unit - container_unit)
    (container_unit_assigned_to_solution ?container_unit - container_unit ?routing_solution - routing_solution)
    (case_resources_allocated ?recovery_case - recovery_case)
    (case_approval_prereqs_met ?recovery_case - recovery_case)
    (case_approved ?recovery_case - recovery_case)
    (case_has_permit ?recovery_case - recovery_case)
    (case_permit_confirmed ?recovery_case - recovery_case)
    (case_has_resource_bundle ?recovery_case - recovery_case)
    (case_final_check_completed ?recovery_case - recovery_case)
    (incident_report_available ?incident_report - incident_report)
    (case_has_incident_report ?recovery_case - recovery_case ?incident_report - incident_report)
    (case_incident_report_attached ?recovery_case - recovery_case)
    (case_contact_engaged ?recovery_case - recovery_case)
    (case_contact_confirmed ?recovery_case - recovery_case)
    (permit_available ?permit - permit)
    (case_assigned_permit ?recovery_case - recovery_case ?permit - permit)
    (resource_bundle_available ?resource_bundle - resource_bundle)
    (case_assigned_resource_bundle ?recovery_case - recovery_case ?resource_bundle - resource_bundle)
    (equipment_asset_available ?equipment_asset - equipment_asset)
    (case_assigned_equipment_asset ?recovery_case - recovery_case ?equipment_asset - equipment_asset)
    (external_approval_available ?external_approval - external_approval)
    (case_assigned_external_approval ?recovery_case - recovery_case ?external_approval - external_approval)
    (claim_file_available ?claim_file - claim_file)
    (shipment_linked_to_claim_file ?affected_shipment - affected_shipment ?claim_file - claim_file)
    (origin_segment_ready ?shipment_segment_origin - shipment_segment_origin)
    (destination_segment_ready ?shipment_segment_destination - shipment_segment_destination)
    (case_handoff_recorded ?recovery_case - recovery_case)
  )
  (:action identify_impacted_shipment
    :parameters (?affected_shipment - affected_shipment)
    :precondition
      (and
        (not
          (shipment_identified ?affected_shipment)
        )
        (not
          (recovery_routing_applied ?affected_shipment)
        )
      )
    :effect (shipment_identified ?affected_shipment)
  )
  (:action reserve_carrier_for_shipment
    :parameters (?affected_shipment - affected_shipment ?carrier_resource - carrier_resource)
    :precondition
      (and
        (shipment_identified ?affected_shipment)
        (not
          (carrier_assigned ?affected_shipment)
        )
        (carrier_resource_available ?carrier_resource)
      )
    :effect
      (and
        (carrier_assigned ?affected_shipment)
        (shipment_assigned_to_carrier ?affected_shipment ?carrier_resource)
        (not
          (carrier_resource_available ?carrier_resource)
        )
      )
  )
  (:action reserve_transport_mode_option_for_shipment
    :parameters (?affected_shipment - affected_shipment ?transport_mode_option - transport_mode_option)
    :precondition
      (and
        (shipment_identified ?affected_shipment)
        (carrier_assigned ?affected_shipment)
        (mode_option_available ?transport_mode_option)
      )
    :effect
      (and
        (transport_mode_reserved ?affected_shipment ?transport_mode_option)
        (not
          (mode_option_available ?transport_mode_option)
        )
      )
  )
  (:action confirm_transport_mode_for_shipment
    :parameters (?affected_shipment - affected_shipment ?transport_mode_option - transport_mode_option)
    :precondition
      (and
        (shipment_identified ?affected_shipment)
        (carrier_assigned ?affected_shipment)
        (transport_mode_reserved ?affected_shipment ?transport_mode_option)
        (not
          (recovery_initiated ?affected_shipment)
        )
      )
    :effect (recovery_initiated ?affected_shipment)
  )
  (:action release_transport_mode_option
    :parameters (?affected_shipment - affected_shipment ?transport_mode_option - transport_mode_option)
    :precondition
      (and
        (transport_mode_reserved ?affected_shipment ?transport_mode_option)
      )
    :effect
      (and
        (mode_option_available ?transport_mode_option)
        (not
          (transport_mode_reserved ?affected_shipment ?transport_mode_option)
        )
      )
  )
  (:action assign_stakeholder_contact_to_shipment
    :parameters (?affected_shipment - affected_shipment ?stakeholder_contact - stakeholder_contact)
    :precondition
      (and
        (recovery_initiated ?affected_shipment)
        (stakeholder_contact_available ?stakeholder_contact)
      )
    :effect
      (and
        (shipment_assigned_contact ?affected_shipment ?stakeholder_contact)
        (not
          (stakeholder_contact_available ?stakeholder_contact)
        )
      )
  )
  (:action release_stakeholder_contact_from_shipment
    :parameters (?affected_shipment - affected_shipment ?stakeholder_contact - stakeholder_contact)
    :precondition
      (and
        (shipment_assigned_contact ?affected_shipment ?stakeholder_contact)
      )
    :effect
      (and
        (stakeholder_contact_available ?stakeholder_contact)
        (not
          (shipment_assigned_contact ?affected_shipment ?stakeholder_contact)
        )
      )
  )
  (:action assign_equipment_asset_to_case
    :parameters (?recovery_case - recovery_case ?equipment_asset - equipment_asset)
    :precondition
      (and
        (recovery_initiated ?recovery_case)
        (equipment_asset_available ?equipment_asset)
      )
    :effect
      (and
        (case_assigned_equipment_asset ?recovery_case ?equipment_asset)
        (not
          (equipment_asset_available ?equipment_asset)
        )
      )
  )
  (:action release_equipment_asset_from_case
    :parameters (?recovery_case - recovery_case ?equipment_asset - equipment_asset)
    :precondition
      (and
        (case_assigned_equipment_asset ?recovery_case ?equipment_asset)
      )
    :effect
      (and
        (equipment_asset_available ?equipment_asset)
        (not
          (case_assigned_equipment_asset ?recovery_case ?equipment_asset)
        )
      )
  )
  (:action assign_external_approval_to_case
    :parameters (?recovery_case - recovery_case ?external_approval - external_approval)
    :precondition
      (and
        (recovery_initiated ?recovery_case)
        (external_approval_available ?external_approval)
      )
    :effect
      (and
        (case_assigned_external_approval ?recovery_case ?external_approval)
        (not
          (external_approval_available ?external_approval)
        )
      )
  )
  (:action release_external_approval_from_case
    :parameters (?recovery_case - recovery_case ?external_approval - external_approval)
    :precondition
      (and
        (case_assigned_external_approval ?recovery_case ?external_approval)
      )
    :effect
      (and
        (external_approval_available ?external_approval)
        (not
          (case_assigned_external_approval ?recovery_case ?external_approval)
        )
      )
  )
  (:action evaluate_alternate_port_for_segment
    :parameters (?shipment_segment_origin - shipment_segment_origin ?alternate_port - alternate_port ?transport_mode_option - transport_mode_option)
    :precondition
      (and
        (recovery_initiated ?shipment_segment_origin)
        (transport_mode_reserved ?shipment_segment_origin ?transport_mode_option)
        (segment_candidate_alternate_port ?shipment_segment_origin ?alternate_port)
        (not
          (alternate_port_validated ?alternate_port)
        )
        (not
          (alternate_port_document_registered ?alternate_port)
        )
      )
    :effect (alternate_port_validated ?alternate_port)
  )
  (:action confirm_segment_with_stakeholder_contact
    :parameters (?shipment_segment_origin - shipment_segment_origin ?alternate_port - alternate_port ?stakeholder_contact - stakeholder_contact)
    :precondition
      (and
        (recovery_initiated ?shipment_segment_origin)
        (shipment_assigned_contact ?shipment_segment_origin ?stakeholder_contact)
        (segment_candidate_alternate_port ?shipment_segment_origin ?alternate_port)
        (alternate_port_validated ?alternate_port)
        (not
          (origin_segment_ready ?shipment_segment_origin)
        )
      )
    :effect
      (and
        (origin_segment_ready ?shipment_segment_origin)
        (origin_segment_validated ?shipment_segment_origin)
      )
  )
  (:action attach_document_to_segment_for_port_validation
    :parameters (?shipment_segment_origin - shipment_segment_origin ?alternate_port - alternate_port ?logistics_document - logistics_document)
    :precondition
      (and
        (recovery_initiated ?shipment_segment_origin)
        (segment_candidate_alternate_port ?shipment_segment_origin ?alternate_port)
        (logistics_document_available ?logistics_document)
        (not
          (origin_segment_ready ?shipment_segment_origin)
        )
      )
    :effect
      (and
        (alternate_port_document_registered ?alternate_port)
        (origin_segment_ready ?shipment_segment_origin)
        (origin_segment_assigned_document ?shipment_segment_origin ?logistics_document)
        (not
          (logistics_document_available ?logistics_document)
        )
      )
  )
  (:action finalize_segment_document_assessment
    :parameters (?shipment_segment_origin - shipment_segment_origin ?alternate_port - alternate_port ?transport_mode_option - transport_mode_option ?logistics_document - logistics_document)
    :precondition
      (and
        (recovery_initiated ?shipment_segment_origin)
        (transport_mode_reserved ?shipment_segment_origin ?transport_mode_option)
        (segment_candidate_alternate_port ?shipment_segment_origin ?alternate_port)
        (alternate_port_document_registered ?alternate_port)
        (origin_segment_assigned_document ?shipment_segment_origin ?logistics_document)
        (not
          (origin_segment_validated ?shipment_segment_origin)
        )
      )
    :effect
      (and
        (alternate_port_validated ?alternate_port)
        (origin_segment_validated ?shipment_segment_origin)
        (logistics_document_available ?logistics_document)
        (not
          (origin_segment_assigned_document ?shipment_segment_origin ?logistics_document)
        )
      )
  )
  (:action evaluate_alternate_route_for_destination_segment
    :parameters (?shipment_segment_destination - shipment_segment_destination ?alternate_route - alternate_route ?transport_mode_option - transport_mode_option)
    :precondition
      (and
        (recovery_initiated ?shipment_segment_destination)
        (transport_mode_reserved ?shipment_segment_destination ?transport_mode_option)
        (segment_candidate_alternate_route ?shipment_segment_destination ?alternate_route)
        (not
          (alternate_route_validated ?alternate_route)
        )
        (not
          (alternate_route_document_registered ?alternate_route)
        )
      )
    :effect (alternate_route_validated ?alternate_route)
  )
  (:action confirm_destination_segment_with_stakeholder_contact
    :parameters (?shipment_segment_destination - shipment_segment_destination ?alternate_route - alternate_route ?stakeholder_contact - stakeholder_contact)
    :precondition
      (and
        (recovery_initiated ?shipment_segment_destination)
        (shipment_assigned_contact ?shipment_segment_destination ?stakeholder_contact)
        (segment_candidate_alternate_route ?shipment_segment_destination ?alternate_route)
        (alternate_route_validated ?alternate_route)
        (not
          (destination_segment_ready ?shipment_segment_destination)
        )
      )
    :effect
      (and
        (destination_segment_ready ?shipment_segment_destination)
        (destination_segment_validated ?shipment_segment_destination)
      )
  )
  (:action attach_document_to_destination_segment
    :parameters (?shipment_segment_destination - shipment_segment_destination ?alternate_route - alternate_route ?logistics_document - logistics_document)
    :precondition
      (and
        (recovery_initiated ?shipment_segment_destination)
        (segment_candidate_alternate_route ?shipment_segment_destination ?alternate_route)
        (logistics_document_available ?logistics_document)
        (not
          (destination_segment_ready ?shipment_segment_destination)
        )
      )
    :effect
      (and
        (alternate_route_document_registered ?alternate_route)
        (destination_segment_ready ?shipment_segment_destination)
        (destination_segment_assigned_document ?shipment_segment_destination ?logistics_document)
        (not
          (logistics_document_available ?logistics_document)
        )
      )
  )
  (:action finalize_destination_segment_document_assessment
    :parameters (?shipment_segment_destination - shipment_segment_destination ?alternate_route - alternate_route ?transport_mode_option - transport_mode_option ?logistics_document - logistics_document)
    :precondition
      (and
        (recovery_initiated ?shipment_segment_destination)
        (transport_mode_reserved ?shipment_segment_destination ?transport_mode_option)
        (segment_candidate_alternate_route ?shipment_segment_destination ?alternate_route)
        (alternate_route_document_registered ?alternate_route)
        (destination_segment_assigned_document ?shipment_segment_destination ?logistics_document)
        (not
          (destination_segment_validated ?shipment_segment_destination)
        )
      )
    :effect
      (and
        (alternate_route_validated ?alternate_route)
        (destination_segment_validated ?shipment_segment_destination)
        (logistics_document_available ?logistics_document)
        (not
          (destination_segment_assigned_document ?shipment_segment_destination ?logistics_document)
        )
      )
  )
  (:action synthesize_and_lock_routing_solution
    :parameters (?shipment_segment_origin - shipment_segment_origin ?shipment_segment_destination - shipment_segment_destination ?alternate_port - alternate_port ?alternate_route - alternate_route ?routing_solution - routing_solution)
    :precondition
      (and
        (origin_segment_ready ?shipment_segment_origin)
        (destination_segment_ready ?shipment_segment_destination)
        (segment_candidate_alternate_port ?shipment_segment_origin ?alternate_port)
        (segment_candidate_alternate_route ?shipment_segment_destination ?alternate_route)
        (alternate_port_validated ?alternate_port)
        (alternate_route_validated ?alternate_route)
        (origin_segment_validated ?shipment_segment_origin)
        (destination_segment_validated ?shipment_segment_destination)
        (routing_solution_available ?routing_solution)
      )
    :effect
      (and
        (routing_solution_selected ?routing_solution)
        (routing_solution_has_port ?routing_solution ?alternate_port)
        (routing_solution_has_route ?routing_solution ?alternate_route)
        (not
          (routing_solution_available ?routing_solution)
        )
      )
  )
  (:action synthesize_and_lock_routing_solution_with_port_documentation
    :parameters (?shipment_segment_origin - shipment_segment_origin ?shipment_segment_destination - shipment_segment_destination ?alternate_port - alternate_port ?alternate_route - alternate_route ?routing_solution - routing_solution)
    :precondition
      (and
        (origin_segment_ready ?shipment_segment_origin)
        (destination_segment_ready ?shipment_segment_destination)
        (segment_candidate_alternate_port ?shipment_segment_origin ?alternate_port)
        (segment_candidate_alternate_route ?shipment_segment_destination ?alternate_route)
        (alternate_port_document_registered ?alternate_port)
        (alternate_route_validated ?alternate_route)
        (not
          (origin_segment_validated ?shipment_segment_origin)
        )
        (destination_segment_validated ?shipment_segment_destination)
        (routing_solution_available ?routing_solution)
      )
    :effect
      (and
        (routing_solution_selected ?routing_solution)
        (routing_solution_has_port ?routing_solution ?alternate_port)
        (routing_solution_has_route ?routing_solution ?alternate_route)
        (routing_solution_requires_permit ?routing_solution)
        (not
          (routing_solution_available ?routing_solution)
        )
      )
  )
  (:action synthesize_and_lock_routing_solution_with_route_documentation
    :parameters (?shipment_segment_origin - shipment_segment_origin ?shipment_segment_destination - shipment_segment_destination ?alternate_port - alternate_port ?alternate_route - alternate_route ?routing_solution - routing_solution)
    :precondition
      (and
        (origin_segment_ready ?shipment_segment_origin)
        (destination_segment_ready ?shipment_segment_destination)
        (segment_candidate_alternate_port ?shipment_segment_origin ?alternate_port)
        (segment_candidate_alternate_route ?shipment_segment_destination ?alternate_route)
        (alternate_port_validated ?alternate_port)
        (alternate_route_document_registered ?alternate_route)
        (origin_segment_validated ?shipment_segment_origin)
        (not
          (destination_segment_validated ?shipment_segment_destination)
        )
        (routing_solution_available ?routing_solution)
      )
    :effect
      (and
        (routing_solution_selected ?routing_solution)
        (routing_solution_has_port ?routing_solution ?alternate_port)
        (routing_solution_has_route ?routing_solution ?alternate_route)
        (routing_solution_requires_external_approval ?routing_solution)
        (not
          (routing_solution_available ?routing_solution)
        )
      )
  )
  (:action synthesize_and_lock_routing_solution_with_full_documentation
    :parameters (?shipment_segment_origin - shipment_segment_origin ?shipment_segment_destination - shipment_segment_destination ?alternate_port - alternate_port ?alternate_route - alternate_route ?routing_solution - routing_solution)
    :precondition
      (and
        (origin_segment_ready ?shipment_segment_origin)
        (destination_segment_ready ?shipment_segment_destination)
        (segment_candidate_alternate_port ?shipment_segment_origin ?alternate_port)
        (segment_candidate_alternate_route ?shipment_segment_destination ?alternate_route)
        (alternate_port_document_registered ?alternate_port)
        (alternate_route_document_registered ?alternate_route)
        (not
          (origin_segment_validated ?shipment_segment_origin)
        )
        (not
          (destination_segment_validated ?shipment_segment_destination)
        )
        (routing_solution_available ?routing_solution)
      )
    :effect
      (and
        (routing_solution_selected ?routing_solution)
        (routing_solution_has_port ?routing_solution ?alternate_port)
        (routing_solution_has_route ?routing_solution ?alternate_route)
        (routing_solution_requires_permit ?routing_solution)
        (routing_solution_requires_external_approval ?routing_solution)
        (not
          (routing_solution_available ?routing_solution)
        )
      )
  )
  (:action schedule_routing_solution_execution
    :parameters (?routing_solution - routing_solution ?shipment_segment_origin - shipment_segment_origin ?transport_mode_option - transport_mode_option)
    :precondition
      (and
        (routing_solution_selected ?routing_solution)
        (origin_segment_ready ?shipment_segment_origin)
        (transport_mode_reserved ?shipment_segment_origin ?transport_mode_option)
        (not
          (routing_solution_scheduled ?routing_solution)
        )
      )
    :effect (routing_solution_scheduled ?routing_solution)
  )
  (:action assign_container_unit_to_case_for_solution
    :parameters (?recovery_case - recovery_case ?container_unit - container_unit ?routing_solution - routing_solution)
    :precondition
      (and
        (recovery_initiated ?recovery_case)
        (case_includes_routing_solution ?recovery_case ?routing_solution)
        (case_has_container_unit ?recovery_case ?container_unit)
        (container_unit_available ?container_unit)
        (routing_solution_selected ?routing_solution)
        (routing_solution_scheduled ?routing_solution)
        (not
          (container_unit_allocated ?container_unit)
        )
      )
    :effect
      (and
        (container_unit_allocated ?container_unit)
        (container_unit_assigned_to_solution ?container_unit ?routing_solution)
        (not
          (container_unit_available ?container_unit)
        )
      )
  )
  (:action finalize_container_allocation_for_case
    :parameters (?recovery_case - recovery_case ?container_unit - container_unit ?routing_solution - routing_solution ?transport_mode_option - transport_mode_option)
    :precondition
      (and
        (recovery_initiated ?recovery_case)
        (case_has_container_unit ?recovery_case ?container_unit)
        (container_unit_allocated ?container_unit)
        (container_unit_assigned_to_solution ?container_unit ?routing_solution)
        (transport_mode_reserved ?recovery_case ?transport_mode_option)
        (not
          (routing_solution_requires_permit ?routing_solution)
        )
        (not
          (case_resources_allocated ?recovery_case)
        )
      )
    :effect (case_resources_allocated ?recovery_case)
  )
  (:action assign_permit_to_case
    :parameters (?recovery_case - recovery_case ?permit - permit)
    :precondition
      (and
        (recovery_initiated ?recovery_case)
        (permit_available ?permit)
        (not
          (case_has_permit ?recovery_case)
        )
      )
    :effect
      (and
        (case_has_permit ?recovery_case)
        (case_assigned_permit ?recovery_case ?permit)
        (not
          (permit_available ?permit)
        )
      )
  )
  (:action process_permit_and_progress_case
    :parameters (?recovery_case - recovery_case ?container_unit - container_unit ?routing_solution - routing_solution ?transport_mode_option - transport_mode_option ?permit - permit)
    :precondition
      (and
        (recovery_initiated ?recovery_case)
        (case_has_container_unit ?recovery_case ?container_unit)
        (container_unit_allocated ?container_unit)
        (container_unit_assigned_to_solution ?container_unit ?routing_solution)
        (transport_mode_reserved ?recovery_case ?transport_mode_option)
        (routing_solution_requires_permit ?routing_solution)
        (case_has_permit ?recovery_case)
        (case_assigned_permit ?recovery_case ?permit)
        (not
          (case_resources_allocated ?recovery_case)
        )
      )
    :effect
      (and
        (case_resources_allocated ?recovery_case)
        (case_permit_confirmed ?recovery_case)
      )
  )
  (:action reserve_equipment_and_mark_case_ready
    :parameters (?recovery_case - recovery_case ?equipment_asset - equipment_asset ?stakeholder_contact - stakeholder_contact ?container_unit - container_unit ?routing_solution - routing_solution)
    :precondition
      (and
        (case_resources_allocated ?recovery_case)
        (case_assigned_equipment_asset ?recovery_case ?equipment_asset)
        (shipment_assigned_contact ?recovery_case ?stakeholder_contact)
        (case_has_container_unit ?recovery_case ?container_unit)
        (container_unit_assigned_to_solution ?container_unit ?routing_solution)
        (not
          (routing_solution_requires_external_approval ?routing_solution)
        )
        (not
          (case_approval_prereqs_met ?recovery_case)
        )
      )
    :effect (case_approval_prereqs_met ?recovery_case)
  )
  (:action confirm_equipment_and_mark_case_ready
    :parameters (?recovery_case - recovery_case ?equipment_asset - equipment_asset ?stakeholder_contact - stakeholder_contact ?container_unit - container_unit ?routing_solution - routing_solution)
    :precondition
      (and
        (case_resources_allocated ?recovery_case)
        (case_assigned_equipment_asset ?recovery_case ?equipment_asset)
        (shipment_assigned_contact ?recovery_case ?stakeholder_contact)
        (case_has_container_unit ?recovery_case ?container_unit)
        (container_unit_assigned_to_solution ?container_unit ?routing_solution)
        (routing_solution_requires_external_approval ?routing_solution)
        (not
          (case_approval_prereqs_met ?recovery_case)
        )
      )
    :effect (case_approval_prereqs_met ?recovery_case)
  )
  (:action finalize_case_approval
    :parameters (?recovery_case - recovery_case ?external_approval - external_approval ?container_unit - container_unit ?routing_solution - routing_solution)
    :precondition
      (and
        (case_approval_prereqs_met ?recovery_case)
        (case_assigned_external_approval ?recovery_case ?external_approval)
        (case_has_container_unit ?recovery_case ?container_unit)
        (container_unit_assigned_to_solution ?container_unit ?routing_solution)
        (not
          (routing_solution_requires_permit ?routing_solution)
        )
        (not
          (routing_solution_requires_external_approval ?routing_solution)
        )
        (not
          (case_approved ?recovery_case)
        )
      )
    :effect (case_approved ?recovery_case)
  )
  (:action finalize_case_approval_with_bundle
    :parameters (?recovery_case - recovery_case ?external_approval - external_approval ?container_unit - container_unit ?routing_solution - routing_solution)
    :precondition
      (and
        (case_approval_prereqs_met ?recovery_case)
        (case_assigned_external_approval ?recovery_case ?external_approval)
        (case_has_container_unit ?recovery_case ?container_unit)
        (container_unit_assigned_to_solution ?container_unit ?routing_solution)
        (routing_solution_requires_permit ?routing_solution)
        (not
          (routing_solution_requires_external_approval ?routing_solution)
        )
        (not
          (case_approved ?recovery_case)
        )
      )
    :effect
      (and
        (case_approved ?recovery_case)
        (case_has_resource_bundle ?recovery_case)
      )
  )
  (:action finalize_case_approval_with_bundle_route_condition
    :parameters (?recovery_case - recovery_case ?external_approval - external_approval ?container_unit - container_unit ?routing_solution - routing_solution)
    :precondition
      (and
        (case_approval_prereqs_met ?recovery_case)
        (case_assigned_external_approval ?recovery_case ?external_approval)
        (case_has_container_unit ?recovery_case ?container_unit)
        (container_unit_assigned_to_solution ?container_unit ?routing_solution)
        (not
          (routing_solution_requires_permit ?routing_solution)
        )
        (routing_solution_requires_external_approval ?routing_solution)
        (not
          (case_approved ?recovery_case)
        )
      )
    :effect
      (and
        (case_approved ?recovery_case)
        (case_has_resource_bundle ?recovery_case)
      )
  )
  (:action finalize_case_approval_with_full_conditions
    :parameters (?recovery_case - recovery_case ?external_approval - external_approval ?container_unit - container_unit ?routing_solution - routing_solution)
    :precondition
      (and
        (case_approval_prereqs_met ?recovery_case)
        (case_assigned_external_approval ?recovery_case ?external_approval)
        (case_has_container_unit ?recovery_case ?container_unit)
        (container_unit_assigned_to_solution ?container_unit ?routing_solution)
        (routing_solution_requires_permit ?routing_solution)
        (routing_solution_requires_external_approval ?routing_solution)
        (not
          (case_approved ?recovery_case)
        )
      )
    :effect
      (and
        (case_approved ?recovery_case)
        (case_has_resource_bundle ?recovery_case)
      )
  )
  (:action finalize_case_and_create_operational_handoff
    :parameters (?recovery_case - recovery_case)
    :precondition
      (and
        (case_approved ?recovery_case)
        (not
          (case_has_resource_bundle ?recovery_case)
        )
        (not
          (case_handoff_recorded ?recovery_case)
        )
      )
    :effect
      (and
        (case_handoff_recorded ?recovery_case)
        (service_restoration_confirmed ?recovery_case)
      )
  )
  (:action attach_resource_bundle_to_case
    :parameters (?recovery_case - recovery_case ?resource_bundle - resource_bundle)
    :precondition
      (and
        (case_approved ?recovery_case)
        (case_has_resource_bundle ?recovery_case)
        (resource_bundle_available ?resource_bundle)
      )
    :effect
      (and
        (case_assigned_resource_bundle ?recovery_case ?resource_bundle)
        (not
          (resource_bundle_available ?resource_bundle)
        )
      )
  )
  (:action perform_final_checks_and_mark_case_ready_for_handoff
    :parameters (?recovery_case - recovery_case ?shipment_segment_origin - shipment_segment_origin ?shipment_segment_destination - shipment_segment_destination ?transport_mode_option - transport_mode_option ?resource_bundle - resource_bundle)
    :precondition
      (and
        (case_approved ?recovery_case)
        (case_has_resource_bundle ?recovery_case)
        (case_assigned_resource_bundle ?recovery_case ?resource_bundle)
        (case_includes_origin_segment ?recovery_case ?shipment_segment_origin)
        (case_includes_destination_segment ?recovery_case ?shipment_segment_destination)
        (origin_segment_validated ?shipment_segment_origin)
        (destination_segment_validated ?shipment_segment_destination)
        (transport_mode_reserved ?recovery_case ?transport_mode_option)
        (not
          (case_final_check_completed ?recovery_case)
        )
      )
    :effect (case_final_check_completed ?recovery_case)
  )
  (:action execute_handover_to_operations
    :parameters (?recovery_case - recovery_case)
    :precondition
      (and
        (case_approved ?recovery_case)
        (case_final_check_completed ?recovery_case)
        (not
          (case_handoff_recorded ?recovery_case)
        )
      )
    :effect
      (and
        (case_handoff_recorded ?recovery_case)
        (service_restoration_confirmed ?recovery_case)
      )
  )
  (:action apply_incident_report_to_case
    :parameters (?recovery_case - recovery_case ?incident_report - incident_report ?transport_mode_option - transport_mode_option)
    :precondition
      (and
        (recovery_initiated ?recovery_case)
        (transport_mode_reserved ?recovery_case ?transport_mode_option)
        (incident_report_available ?incident_report)
        (case_has_incident_report ?recovery_case ?incident_report)
        (not
          (case_incident_report_attached ?recovery_case)
        )
      )
    :effect
      (and
        (case_incident_report_attached ?recovery_case)
        (not
          (incident_report_available ?incident_report)
        )
      )
  )
  (:action engage_contact_for_case
    :parameters (?recovery_case - recovery_case ?stakeholder_contact - stakeholder_contact)
    :precondition
      (and
        (case_incident_report_attached ?recovery_case)
        (shipment_assigned_contact ?recovery_case ?stakeholder_contact)
        (not
          (case_contact_engaged ?recovery_case)
        )
      )
    :effect (case_contact_engaged ?recovery_case)
  )
  (:action confirm_contact_with_external_approval
    :parameters (?recovery_case - recovery_case ?external_approval - external_approval)
    :precondition
      (and
        (case_contact_engaged ?recovery_case)
        (case_assigned_external_approval ?recovery_case ?external_approval)
        (not
          (case_contact_confirmed ?recovery_case)
        )
      )
    :effect (case_contact_confirmed ?recovery_case)
  )
  (:action finalize_contact_confirmation_and_handoff
    :parameters (?recovery_case - recovery_case)
    :precondition
      (and
        (case_contact_confirmed ?recovery_case)
        (not
          (case_handoff_recorded ?recovery_case)
        )
      )
    :effect
      (and
        (case_handoff_recorded ?recovery_case)
        (service_restoration_confirmed ?recovery_case)
      )
  )
  (:action confirm_origin_segment_service_restored
    :parameters (?shipment_segment_origin - shipment_segment_origin ?routing_solution - routing_solution)
    :precondition
      (and
        (origin_segment_ready ?shipment_segment_origin)
        (origin_segment_validated ?shipment_segment_origin)
        (routing_solution_selected ?routing_solution)
        (routing_solution_scheduled ?routing_solution)
        (not
          (service_restoration_confirmed ?shipment_segment_origin)
        )
      )
    :effect (service_restoration_confirmed ?shipment_segment_origin)
  )
  (:action confirm_destination_segment_service_restored
    :parameters (?shipment_segment_destination - shipment_segment_destination ?routing_solution - routing_solution)
    :precondition
      (and
        (destination_segment_ready ?shipment_segment_destination)
        (destination_segment_validated ?shipment_segment_destination)
        (routing_solution_selected ?routing_solution)
        (routing_solution_scheduled ?routing_solution)
        (not
          (service_restoration_confirmed ?shipment_segment_destination)
        )
      )
    :effect (service_restoration_confirmed ?shipment_segment_destination)
  )
  (:action create_claim_for_shipment
    :parameters (?affected_shipment - affected_shipment ?claim_file - claim_file ?transport_mode_option - transport_mode_option)
    :precondition
      (and
        (service_restoration_confirmed ?affected_shipment)
        (transport_mode_reserved ?affected_shipment ?transport_mode_option)
        (claim_file_available ?claim_file)
        (not
          (case_claim_opened ?affected_shipment)
        )
      )
    :effect
      (and
        (case_claim_opened ?affected_shipment)
        (shipment_linked_to_claim_file ?affected_shipment ?claim_file)
        (not
          (claim_file_available ?claim_file)
        )
      )
  )
  (:action reapply_recovered_routing_to_segment
    :parameters (?shipment_segment_origin - shipment_segment_origin ?carrier_resource - carrier_resource ?claim_file - claim_file)
    :precondition
      (and
        (case_claim_opened ?shipment_segment_origin)
        (shipment_assigned_to_carrier ?shipment_segment_origin ?carrier_resource)
        (shipment_linked_to_claim_file ?shipment_segment_origin ?claim_file)
        (not
          (recovery_routing_applied ?shipment_segment_origin)
        )
      )
    :effect
      (and
        (recovery_routing_applied ?shipment_segment_origin)
        (carrier_resource_available ?carrier_resource)
        (claim_file_available ?claim_file)
      )
  )
  (:action reapply_recovered_routing_to_destination_segment
    :parameters (?shipment_segment_destination - shipment_segment_destination ?carrier_resource - carrier_resource ?claim_file - claim_file)
    :precondition
      (and
        (case_claim_opened ?shipment_segment_destination)
        (shipment_assigned_to_carrier ?shipment_segment_destination ?carrier_resource)
        (shipment_linked_to_claim_file ?shipment_segment_destination ?claim_file)
        (not
          (recovery_routing_applied ?shipment_segment_destination)
        )
      )
    :effect
      (and
        (recovery_routing_applied ?shipment_segment_destination)
        (carrier_resource_available ?carrier_resource)
        (claim_file_available ?claim_file)
      )
  )
  (:action reapply_recovered_routing_to_case
    :parameters (?recovery_case - recovery_case ?carrier_resource - carrier_resource ?claim_file - claim_file)
    :precondition
      (and
        (case_claim_opened ?recovery_case)
        (shipment_assigned_to_carrier ?recovery_case ?carrier_resource)
        (shipment_linked_to_claim_file ?recovery_case ?claim_file)
        (not
          (recovery_routing_applied ?recovery_case)
        )
      )
    :effect
      (and
        (recovery_routing_applied ?recovery_case)
        (carrier_resource_available ?carrier_resource)
        (claim_file_available ?claim_file)
      )
  )
)

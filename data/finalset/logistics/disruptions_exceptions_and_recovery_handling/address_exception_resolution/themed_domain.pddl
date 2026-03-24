(define (domain logistics_address_exception_resolution)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_category - object document_category - object plan_category - object exception_entity_type - object exception_instance - exception_entity_type routing_resource - resource_category event_report - resource_category field_operator - resource_category supplier_contract - resource_category execution_slot - resource_category claim_document - resource_category repair_resource - resource_category regulatory_clearance - resource_category support_document - document_category approval_certificate - document_category supervisor_approval - document_category contingency_route - plan_category alternate_route_option - plan_category recovery_plan - plan_category affected_logistics_element - exception_instance organizational_actor_group - exception_instance primary_delivery_leg - affected_logistics_element alternate_delivery_leg - affected_logistics_element response_coordinator - organizational_actor_group)
  (:predicates
    (exception_case_opened ?address_exception_case - exception_instance)
    (validated ?address_exception_case - exception_instance)
    (routing_resource_attached_to_exception_instance ?address_exception_case - exception_instance)
    (assignment_confirmed ?address_exception_case - exception_instance)
    (recovery_executed ?address_exception_case - exception_instance)
    (claim_registered ?address_exception_case - exception_instance)
    (routing_resource_available ?routing_resource - routing_resource)
    (has_routing_resource ?address_exception_case - exception_instance ?routing_resource - routing_resource)
    (event_report_available ?event_report - event_report)
    (has_event_report ?address_exception_case - exception_instance ?event_report - event_report)
    (field_operator_available ?field_operator - field_operator)
    (assigned_field_operator ?address_exception_case - exception_instance ?field_operator - field_operator)
    (support_document_available ?support_document - support_document)
    (primary_leg_has_support_document ?primary_delivery_leg - primary_delivery_leg ?support_document - support_document)
    (alternate_leg_has_support_document ?alternate_delivery_leg - alternate_delivery_leg ?support_document - support_document)
    (primary_leg_contingency_link ?primary_delivery_leg - primary_delivery_leg ?contingency_route - contingency_route)
    (contingency_route_validated ?contingency_route - contingency_route)
    (contingency_route_rejected ?contingency_route - contingency_route)
    (primary_leg_contingency_confirmed ?primary_delivery_leg - primary_delivery_leg)
    (alternate_leg_route_option_link ?alternate_delivery_leg - alternate_delivery_leg ?alternate_route_option - alternate_route_option)
    (alternate_route_option_validated ?alternate_route_option - alternate_route_option)
    (alternate_route_option_rejected ?alternate_route_option - alternate_route_option)
    (alternate_leg_contingency_confirmed ?alternate_delivery_leg - alternate_delivery_leg)
    (recovery_plan_available ?recovery_plan - recovery_plan)
    (recovery_plan_committed ?recovery_plan - recovery_plan)
    (recovery_plan_includes_contingency_route ?recovery_plan - recovery_plan ?contingency_route - contingency_route)
    (recovery_plan_includes_alternate_route ?recovery_plan - recovery_plan ?alternate_route_option - alternate_route_option)
    (recovery_plan_primary_contingency_rejected ?recovery_plan - recovery_plan)
    (recovery_plan_alternate_route_rejected ?recovery_plan - recovery_plan)
    (recovery_plan_ready_for_approval ?recovery_plan - recovery_plan)
    (coordinator_assigned_primary_leg ?response_coordinator - response_coordinator ?primary_delivery_leg - primary_delivery_leg)
    (coordinator_assigned_alternate_leg ?response_coordinator - response_coordinator ?alternate_delivery_leg - alternate_delivery_leg)
    (coordinator_assigned_recovery_plan ?response_coordinator - response_coordinator ?recovery_plan - recovery_plan)
    (approval_certificate_available ?approval_certificate - approval_certificate)
    (coordinator_has_approval_certificate ?response_coordinator - response_coordinator ?approval_certificate - approval_certificate)
    (approval_certificate_consumed ?approval_certificate - approval_certificate)
    (approval_certificate_attached_to_plan ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan)
    (coordinator_ready_for_vendor_engagement ?response_coordinator - response_coordinator)
    (supplier_engaged ?response_coordinator - response_coordinator)
    (coordinator_ready_for_execution ?response_coordinator - response_coordinator)
    (supplier_contract_engaged ?response_coordinator - response_coordinator)
    (supplier_contract_confirmed ?response_coordinator - response_coordinator)
    (execution_preconditions_met ?response_coordinator - response_coordinator)
    (execution_resources_assigned ?response_coordinator - response_coordinator)
    (supervisor_approval_available ?supervisor_approval - supervisor_approval)
    (coordinator_has_supervisor_approval ?response_coordinator - response_coordinator ?supervisor_approval - supervisor_approval)
    (supervisor_approval_attached_to_response_coordinator ?response_coordinator - response_coordinator)
    (supervisor_approval_active ?response_coordinator - response_coordinator)
    (regulatory_clearance_attached_to_response_coordinator ?response_coordinator - response_coordinator)
    (supplier_contract_available ?supplier_contract - supplier_contract)
    (coordinator_has_supplier_contract ?response_coordinator - response_coordinator ?supplier_contract - supplier_contract)
    (execution_slot_available ?execution_slot - execution_slot)
    (coordinator_scheduled_execution_slot ?response_coordinator - response_coordinator ?execution_slot - execution_slot)
    (repair_resource_available ?repair_resource - repair_resource)
    (coordinator_reserved_repair_resource ?response_coordinator - response_coordinator ?repair_resource - repair_resource)
    (regulatory_clearance_available ?regulatory_clearance - regulatory_clearance)
    (coordinator_reserved_regulatory_clearance ?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance)
    (claim_document_available ?claim_document - claim_document)
    (has_claim_document ?address_exception_case - exception_instance ?claim_document - claim_document)
    (primary_leg_evaluation_complete ?primary_delivery_leg - primary_delivery_leg)
    (alternate_leg_evaluation_complete ?alternate_delivery_leg - alternate_delivery_leg)
    (execution_activity_recorded ?response_coordinator - response_coordinator)
  )
  (:action register_exception_instance
    :parameters (?address_exception_case - exception_instance)
    :precondition
      (and
        (not
          (exception_case_opened ?address_exception_case)
        )
        (not
          (assignment_confirmed ?address_exception_case)
        )
      )
    :effect (exception_case_opened ?address_exception_case)
  )
  (:action allocate_routing_resource_to_exception_instance
    :parameters (?address_exception_case - exception_instance ?routing_resource - routing_resource)
    :precondition
      (and
        (exception_case_opened ?address_exception_case)
        (not
          (routing_resource_attached_to_exception_instance ?address_exception_case)
        )
        (routing_resource_available ?routing_resource)
      )
    :effect
      (and
        (routing_resource_attached_to_exception_instance ?address_exception_case)
        (has_routing_resource ?address_exception_case ?routing_resource)
        (not
          (routing_resource_available ?routing_resource)
        )
      )
  )
  (:action attach_event_report_to_exception_instance
    :parameters (?address_exception_case - exception_instance ?event_report - event_report)
    :precondition
      (and
        (exception_case_opened ?address_exception_case)
        (routing_resource_attached_to_exception_instance ?address_exception_case)
        (event_report_available ?event_report)
      )
    :effect
      (and
        (has_event_report ?address_exception_case ?event_report)
        (not
          (event_report_available ?event_report)
        )
      )
  )
  (:action validate_exception_instance
    :parameters (?address_exception_case - exception_instance ?event_report - event_report)
    :precondition
      (and
        (exception_case_opened ?address_exception_case)
        (routing_resource_attached_to_exception_instance ?address_exception_case)
        (has_event_report ?address_exception_case ?event_report)
        (not
          (validated ?address_exception_case)
        )
      )
    :effect (validated ?address_exception_case)
  )
  (:action release_event_report_from_exception_instance
    :parameters (?address_exception_case - exception_instance ?event_report - event_report)
    :precondition
      (and
        (has_event_report ?address_exception_case ?event_report)
      )
    :effect
      (and
        (event_report_available ?event_report)
        (not
          (has_event_report ?address_exception_case ?event_report)
        )
      )
  )
  (:action assign_field_operator_to_exception_instance
    :parameters (?address_exception_case - exception_instance ?field_operator - field_operator)
    :precondition
      (and
        (validated ?address_exception_case)
        (field_operator_available ?field_operator)
      )
    :effect
      (and
        (assigned_field_operator ?address_exception_case ?field_operator)
        (not
          (field_operator_available ?field_operator)
        )
      )
  )
  (:action release_field_operator_from_exception_instance
    :parameters (?address_exception_case - exception_instance ?field_operator - field_operator)
    :precondition
      (and
        (assigned_field_operator ?address_exception_case ?field_operator)
      )
    :effect
      (and
        (field_operator_available ?field_operator)
        (not
          (assigned_field_operator ?address_exception_case ?field_operator)
        )
      )
  )
  (:action reserve_repair_resource_for_coordinator
    :parameters (?response_coordinator - response_coordinator ?repair_resource - repair_resource)
    :precondition
      (and
        (validated ?response_coordinator)
        (repair_resource_available ?repair_resource)
      )
    :effect
      (and
        (coordinator_reserved_repair_resource ?response_coordinator ?repair_resource)
        (not
          (repair_resource_available ?repair_resource)
        )
      )
  )
  (:action release_repair_resource_from_coordinator
    :parameters (?response_coordinator - response_coordinator ?repair_resource - repair_resource)
    :precondition
      (and
        (coordinator_reserved_repair_resource ?response_coordinator ?repair_resource)
      )
    :effect
      (and
        (repair_resource_available ?repair_resource)
        (not
          (coordinator_reserved_repair_resource ?response_coordinator ?repair_resource)
        )
      )
  )
  (:action reserve_regulatory_clearance_for_coordinator
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (validated ?response_coordinator)
        (regulatory_clearance_available ?regulatory_clearance)
      )
    :effect
      (and
        (coordinator_reserved_regulatory_clearance ?response_coordinator ?regulatory_clearance)
        (not
          (regulatory_clearance_available ?regulatory_clearance)
        )
      )
  )
  (:action release_regulatory_clearance_from_coordinator
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (coordinator_reserved_regulatory_clearance ?response_coordinator ?regulatory_clearance)
      )
    :effect
      (and
        (regulatory_clearance_available ?regulatory_clearance)
        (not
          (coordinator_reserved_regulatory_clearance ?response_coordinator ?regulatory_clearance)
        )
      )
  )
  (:action validate_contingency_route_for_primary_leg
    :parameters (?primary_delivery_leg - primary_delivery_leg ?contingency_route - contingency_route ?event_report - event_report)
    :precondition
      (and
        (validated ?primary_delivery_leg)
        (has_event_report ?primary_delivery_leg ?event_report)
        (primary_leg_contingency_link ?primary_delivery_leg ?contingency_route)
        (not
          (contingency_route_validated ?contingency_route)
        )
        (not
          (contingency_route_rejected ?contingency_route)
        )
      )
    :effect (contingency_route_validated ?contingency_route)
  )
  (:action confirm_primary_leg_contingency_with_operator
    :parameters (?primary_delivery_leg - primary_delivery_leg ?contingency_route - contingency_route ?field_operator - field_operator)
    :precondition
      (and
        (validated ?primary_delivery_leg)
        (assigned_field_operator ?primary_delivery_leg ?field_operator)
        (primary_leg_contingency_link ?primary_delivery_leg ?contingency_route)
        (contingency_route_validated ?contingency_route)
        (not
          (primary_leg_evaluation_complete ?primary_delivery_leg)
        )
      )
    :effect
      (and
        (primary_leg_evaluation_complete ?primary_delivery_leg)
        (primary_leg_contingency_confirmed ?primary_delivery_leg)
      )
  )
  (:action attach_support_document_and_reject_primary_contingency
    :parameters (?primary_delivery_leg - primary_delivery_leg ?contingency_route - contingency_route ?support_document - support_document)
    :precondition
      (and
        (validated ?primary_delivery_leg)
        (primary_leg_contingency_link ?primary_delivery_leg ?contingency_route)
        (support_document_available ?support_document)
        (not
          (primary_leg_evaluation_complete ?primary_delivery_leg)
        )
      )
    :effect
      (and
        (contingency_route_rejected ?contingency_route)
        (primary_leg_evaluation_complete ?primary_delivery_leg)
        (primary_leg_has_support_document ?primary_delivery_leg ?support_document)
        (not
          (support_document_available ?support_document)
        )
      )
  )
  (:action approve_primary_contingency_with_support_document
    :parameters (?primary_delivery_leg - primary_delivery_leg ?contingency_route - contingency_route ?event_report - event_report ?support_document - support_document)
    :precondition
      (and
        (validated ?primary_delivery_leg)
        (has_event_report ?primary_delivery_leg ?event_report)
        (primary_leg_contingency_link ?primary_delivery_leg ?contingency_route)
        (contingency_route_rejected ?contingency_route)
        (primary_leg_has_support_document ?primary_delivery_leg ?support_document)
        (not
          (primary_leg_contingency_confirmed ?primary_delivery_leg)
        )
      )
    :effect
      (and
        (contingency_route_validated ?contingency_route)
        (primary_leg_contingency_confirmed ?primary_delivery_leg)
        (support_document_available ?support_document)
        (not
          (primary_leg_has_support_document ?primary_delivery_leg ?support_document)
        )
      )
  )
  (:action validate_alternate_route_for_leg
    :parameters (?alternate_delivery_leg - alternate_delivery_leg ?alternate_route_option - alternate_route_option ?event_report - event_report)
    :precondition
      (and
        (validated ?alternate_delivery_leg)
        (has_event_report ?alternate_delivery_leg ?event_report)
        (alternate_leg_route_option_link ?alternate_delivery_leg ?alternate_route_option)
        (not
          (alternate_route_option_validated ?alternate_route_option)
        )
        (not
          (alternate_route_option_rejected ?alternate_route_option)
        )
      )
    :effect (alternate_route_option_validated ?alternate_route_option)
  )
  (:action confirm_alternate_with_operator_for_alternate_leg
    :parameters (?alternate_delivery_leg - alternate_delivery_leg ?alternate_route_option - alternate_route_option ?field_operator - field_operator)
    :precondition
      (and
        (validated ?alternate_delivery_leg)
        (assigned_field_operator ?alternate_delivery_leg ?field_operator)
        (alternate_leg_route_option_link ?alternate_delivery_leg ?alternate_route_option)
        (alternate_route_option_validated ?alternate_route_option)
        (not
          (alternate_leg_evaluation_complete ?alternate_delivery_leg)
        )
      )
    :effect
      (and
        (alternate_leg_evaluation_complete ?alternate_delivery_leg)
        (alternate_leg_contingency_confirmed ?alternate_delivery_leg)
      )
  )
  (:action attach_support_document_and_reject_alternate_route
    :parameters (?alternate_delivery_leg - alternate_delivery_leg ?alternate_route_option - alternate_route_option ?support_document - support_document)
    :precondition
      (and
        (validated ?alternate_delivery_leg)
        (alternate_leg_route_option_link ?alternate_delivery_leg ?alternate_route_option)
        (support_document_available ?support_document)
        (not
          (alternate_leg_evaluation_complete ?alternate_delivery_leg)
        )
      )
    :effect
      (and
        (alternate_route_option_rejected ?alternate_route_option)
        (alternate_leg_evaluation_complete ?alternate_delivery_leg)
        (alternate_leg_has_support_document ?alternate_delivery_leg ?support_document)
        (not
          (support_document_available ?support_document)
        )
      )
  )
  (:action approve_alternate_route_with_support_document
    :parameters (?alternate_delivery_leg - alternate_delivery_leg ?alternate_route_option - alternate_route_option ?event_report - event_report ?support_document - support_document)
    :precondition
      (and
        (validated ?alternate_delivery_leg)
        (has_event_report ?alternate_delivery_leg ?event_report)
        (alternate_leg_route_option_link ?alternate_delivery_leg ?alternate_route_option)
        (alternate_route_option_rejected ?alternate_route_option)
        (alternate_leg_has_support_document ?alternate_delivery_leg ?support_document)
        (not
          (alternate_leg_contingency_confirmed ?alternate_delivery_leg)
        )
      )
    :effect
      (and
        (alternate_route_option_validated ?alternate_route_option)
        (alternate_leg_contingency_confirmed ?alternate_delivery_leg)
        (support_document_available ?support_document)
        (not
          (alternate_leg_has_support_document ?alternate_delivery_leg ?support_document)
        )
      )
  )
  (:action assemble_recovery_plan
    :parameters (?primary_delivery_leg - primary_delivery_leg ?alternate_delivery_leg - alternate_delivery_leg ?contingency_route - contingency_route ?alternate_route_option - alternate_route_option ?recovery_plan - recovery_plan)
    :precondition
      (and
        (primary_leg_evaluation_complete ?primary_delivery_leg)
        (alternate_leg_evaluation_complete ?alternate_delivery_leg)
        (primary_leg_contingency_link ?primary_delivery_leg ?contingency_route)
        (alternate_leg_route_option_link ?alternate_delivery_leg ?alternate_route_option)
        (contingency_route_validated ?contingency_route)
        (alternate_route_option_validated ?alternate_route_option)
        (primary_leg_contingency_confirmed ?primary_delivery_leg)
        (alternate_leg_contingency_confirmed ?alternate_delivery_leg)
        (recovery_plan_available ?recovery_plan)
      )
    :effect
      (and
        (recovery_plan_committed ?recovery_plan)
        (recovery_plan_includes_contingency_route ?recovery_plan ?contingency_route)
        (recovery_plan_includes_alternate_route ?recovery_plan ?alternate_route_option)
        (not
          (recovery_plan_available ?recovery_plan)
        )
      )
  )
  (:action assemble_recovery_plan_primary_rejected
    :parameters (?primary_delivery_leg - primary_delivery_leg ?alternate_delivery_leg - alternate_delivery_leg ?contingency_route - contingency_route ?alternate_route_option - alternate_route_option ?recovery_plan - recovery_plan)
    :precondition
      (and
        (primary_leg_evaluation_complete ?primary_delivery_leg)
        (alternate_leg_evaluation_complete ?alternate_delivery_leg)
        (primary_leg_contingency_link ?primary_delivery_leg ?contingency_route)
        (alternate_leg_route_option_link ?alternate_delivery_leg ?alternate_route_option)
        (contingency_route_rejected ?contingency_route)
        (alternate_route_option_validated ?alternate_route_option)
        (not
          (primary_leg_contingency_confirmed ?primary_delivery_leg)
        )
        (alternate_leg_contingency_confirmed ?alternate_delivery_leg)
        (recovery_plan_available ?recovery_plan)
      )
    :effect
      (and
        (recovery_plan_committed ?recovery_plan)
        (recovery_plan_includes_contingency_route ?recovery_plan ?contingency_route)
        (recovery_plan_includes_alternate_route ?recovery_plan ?alternate_route_option)
        (recovery_plan_primary_contingency_rejected ?recovery_plan)
        (not
          (recovery_plan_available ?recovery_plan)
        )
      )
  )
  (:action assemble_recovery_plan_alternate_rejected
    :parameters (?primary_delivery_leg - primary_delivery_leg ?alternate_delivery_leg - alternate_delivery_leg ?contingency_route - contingency_route ?alternate_route_option - alternate_route_option ?recovery_plan - recovery_plan)
    :precondition
      (and
        (primary_leg_evaluation_complete ?primary_delivery_leg)
        (alternate_leg_evaluation_complete ?alternate_delivery_leg)
        (primary_leg_contingency_link ?primary_delivery_leg ?contingency_route)
        (alternate_leg_route_option_link ?alternate_delivery_leg ?alternate_route_option)
        (contingency_route_validated ?contingency_route)
        (alternate_route_option_rejected ?alternate_route_option)
        (primary_leg_contingency_confirmed ?primary_delivery_leg)
        (not
          (alternate_leg_contingency_confirmed ?alternate_delivery_leg)
        )
        (recovery_plan_available ?recovery_plan)
      )
    :effect
      (and
        (recovery_plan_committed ?recovery_plan)
        (recovery_plan_includes_contingency_route ?recovery_plan ?contingency_route)
        (recovery_plan_includes_alternate_route ?recovery_plan ?alternate_route_option)
        (recovery_plan_alternate_route_rejected ?recovery_plan)
        (not
          (recovery_plan_available ?recovery_plan)
        )
      )
  )
  (:action assemble_recovery_plan_both_rejected
    :parameters (?primary_delivery_leg - primary_delivery_leg ?alternate_delivery_leg - alternate_delivery_leg ?contingency_route - contingency_route ?alternate_route_option - alternate_route_option ?recovery_plan - recovery_plan)
    :precondition
      (and
        (primary_leg_evaluation_complete ?primary_delivery_leg)
        (alternate_leg_evaluation_complete ?alternate_delivery_leg)
        (primary_leg_contingency_link ?primary_delivery_leg ?contingency_route)
        (alternate_leg_route_option_link ?alternate_delivery_leg ?alternate_route_option)
        (contingency_route_rejected ?contingency_route)
        (alternate_route_option_rejected ?alternate_route_option)
        (not
          (primary_leg_contingency_confirmed ?primary_delivery_leg)
        )
        (not
          (alternate_leg_contingency_confirmed ?alternate_delivery_leg)
        )
        (recovery_plan_available ?recovery_plan)
      )
    :effect
      (and
        (recovery_plan_committed ?recovery_plan)
        (recovery_plan_includes_contingency_route ?recovery_plan ?contingency_route)
        (recovery_plan_includes_alternate_route ?recovery_plan ?alternate_route_option)
        (recovery_plan_primary_contingency_rejected ?recovery_plan)
        (recovery_plan_alternate_route_rejected ?recovery_plan)
        (not
          (recovery_plan_available ?recovery_plan)
        )
      )
  )
  (:action prepare_recovery_plan_for_approval
    :parameters (?recovery_plan - recovery_plan ?primary_delivery_leg - primary_delivery_leg ?event_report - event_report)
    :precondition
      (and
        (recovery_plan_committed ?recovery_plan)
        (primary_leg_evaluation_complete ?primary_delivery_leg)
        (has_event_report ?primary_delivery_leg ?event_report)
        (not
          (recovery_plan_ready_for_approval ?recovery_plan)
        )
      )
    :effect (recovery_plan_ready_for_approval ?recovery_plan)
  )
  (:action attach_approval_certificate_to_recovery_plan
    :parameters (?response_coordinator - response_coordinator ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan)
    :precondition
      (and
        (validated ?response_coordinator)
        (coordinator_assigned_recovery_plan ?response_coordinator ?recovery_plan)
        (coordinator_has_approval_certificate ?response_coordinator ?approval_certificate)
        (approval_certificate_available ?approval_certificate)
        (recovery_plan_committed ?recovery_plan)
        (recovery_plan_ready_for_approval ?recovery_plan)
        (not
          (approval_certificate_consumed ?approval_certificate)
        )
      )
    :effect
      (and
        (approval_certificate_consumed ?approval_certificate)
        (approval_certificate_attached_to_plan ?approval_certificate ?recovery_plan)
        (not
          (approval_certificate_available ?approval_certificate)
        )
      )
  )
  (:action qualify_coordinator_for_vendor_engagement
    :parameters (?response_coordinator - response_coordinator ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan ?event_report - event_report)
    :precondition
      (and
        (validated ?response_coordinator)
        (coordinator_has_approval_certificate ?response_coordinator ?approval_certificate)
        (approval_certificate_consumed ?approval_certificate)
        (approval_certificate_attached_to_plan ?approval_certificate ?recovery_plan)
        (has_event_report ?response_coordinator ?event_report)
        (not
          (recovery_plan_primary_contingency_rejected ?recovery_plan)
        )
        (not
          (coordinator_ready_for_vendor_engagement ?response_coordinator)
        )
      )
    :effect (coordinator_ready_for_vendor_engagement ?response_coordinator)
  )
  (:action engage_supplier_contract_for_coordinator
    :parameters (?response_coordinator - response_coordinator ?supplier_contract - supplier_contract)
    :precondition
      (and
        (validated ?response_coordinator)
        (supplier_contract_available ?supplier_contract)
        (not
          (supplier_contract_engaged ?response_coordinator)
        )
      )
    :effect
      (and
        (supplier_contract_engaged ?response_coordinator)
        (coordinator_has_supplier_contract ?response_coordinator ?supplier_contract)
        (not
          (supplier_contract_available ?supplier_contract)
        )
      )
  )
  (:action prepare_supplier_engagement_for_recovery_plan
    :parameters (?response_coordinator - response_coordinator ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan ?event_report - event_report ?supplier_contract - supplier_contract)
    :precondition
      (and
        (validated ?response_coordinator)
        (coordinator_has_approval_certificate ?response_coordinator ?approval_certificate)
        (approval_certificate_consumed ?approval_certificate)
        (approval_certificate_attached_to_plan ?approval_certificate ?recovery_plan)
        (has_event_report ?response_coordinator ?event_report)
        (recovery_plan_primary_contingency_rejected ?recovery_plan)
        (supplier_contract_engaged ?response_coordinator)
        (coordinator_has_supplier_contract ?response_coordinator ?supplier_contract)
        (not
          (coordinator_ready_for_vendor_engagement ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_ready_for_vendor_engagement ?response_coordinator)
        (supplier_contract_confirmed ?response_coordinator)
      )
  )
  (:action confirm_supplier_readiness_for_execution
    :parameters (?response_coordinator - response_coordinator ?repair_resource - repair_resource ?field_operator - field_operator ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan)
    :precondition
      (and
        (coordinator_ready_for_vendor_engagement ?response_coordinator)
        (coordinator_reserved_repair_resource ?response_coordinator ?repair_resource)
        (assigned_field_operator ?response_coordinator ?field_operator)
        (coordinator_has_approval_certificate ?response_coordinator ?approval_certificate)
        (approval_certificate_attached_to_plan ?approval_certificate ?recovery_plan)
        (not
          (recovery_plan_alternate_route_rejected ?recovery_plan)
        )
        (not
          (supplier_engaged ?response_coordinator)
        )
      )
    :effect (supplier_engaged ?response_coordinator)
  )
  (:action confirm_supplier_readiness_for_execution_secondary
    :parameters (?response_coordinator - response_coordinator ?repair_resource - repair_resource ?field_operator - field_operator ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan)
    :precondition
      (and
        (coordinator_ready_for_vendor_engagement ?response_coordinator)
        (coordinator_reserved_repair_resource ?response_coordinator ?repair_resource)
        (assigned_field_operator ?response_coordinator ?field_operator)
        (coordinator_has_approval_certificate ?response_coordinator ?approval_certificate)
        (approval_certificate_attached_to_plan ?approval_certificate ?recovery_plan)
        (recovery_plan_alternate_route_rejected ?recovery_plan)
        (not
          (supplier_engaged ?response_coordinator)
        )
      )
    :effect (supplier_engaged ?response_coordinator)
  )
  (:action apply_regulatory_clearance_and_prepare_execution
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan)
    :precondition
      (and
        (supplier_engaged ?response_coordinator)
        (coordinator_reserved_regulatory_clearance ?response_coordinator ?regulatory_clearance)
        (coordinator_has_approval_certificate ?response_coordinator ?approval_certificate)
        (approval_certificate_attached_to_plan ?approval_certificate ?recovery_plan)
        (not
          (recovery_plan_primary_contingency_rejected ?recovery_plan)
        )
        (not
          (recovery_plan_alternate_route_rejected ?recovery_plan)
        )
        (not
          (coordinator_ready_for_execution ?response_coordinator)
        )
      )
    :effect (coordinator_ready_for_execution ?response_coordinator)
  )
  (:action apply_regulatory_clearance_and_flag_execution
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan)
    :precondition
      (and
        (supplier_engaged ?response_coordinator)
        (coordinator_reserved_regulatory_clearance ?response_coordinator ?regulatory_clearance)
        (coordinator_has_approval_certificate ?response_coordinator ?approval_certificate)
        (approval_certificate_attached_to_plan ?approval_certificate ?recovery_plan)
        (recovery_plan_primary_contingency_rejected ?recovery_plan)
        (not
          (recovery_plan_alternate_route_rejected ?recovery_plan)
        )
        (not
          (coordinator_ready_for_execution ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_ready_for_execution ?response_coordinator)
        (execution_preconditions_met ?response_coordinator)
      )
  )
  (:action apply_regulatory_clearance_and_flag_execution_alternate
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan)
    :precondition
      (and
        (supplier_engaged ?response_coordinator)
        (coordinator_reserved_regulatory_clearance ?response_coordinator ?regulatory_clearance)
        (coordinator_has_approval_certificate ?response_coordinator ?approval_certificate)
        (approval_certificate_attached_to_plan ?approval_certificate ?recovery_plan)
        (not
          (recovery_plan_primary_contingency_rejected ?recovery_plan)
        )
        (recovery_plan_alternate_route_rejected ?recovery_plan)
        (not
          (coordinator_ready_for_execution ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_ready_for_execution ?response_coordinator)
        (execution_preconditions_met ?response_coordinator)
      )
  )
  (:action apply_regulatory_clearance_and_flag_execution_full
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance ?approval_certificate - approval_certificate ?recovery_plan - recovery_plan)
    :precondition
      (and
        (supplier_engaged ?response_coordinator)
        (coordinator_reserved_regulatory_clearance ?response_coordinator ?regulatory_clearance)
        (coordinator_has_approval_certificate ?response_coordinator ?approval_certificate)
        (approval_certificate_attached_to_plan ?approval_certificate ?recovery_plan)
        (recovery_plan_primary_contingency_rejected ?recovery_plan)
        (recovery_plan_alternate_route_rejected ?recovery_plan)
        (not
          (coordinator_ready_for_execution ?response_coordinator)
        )
      )
    :effect
      (and
        (coordinator_ready_for_execution ?response_coordinator)
        (execution_preconditions_met ?response_coordinator)
      )
  )
  (:action authorize_recovery_execution_for_coordinator
    :parameters (?response_coordinator - response_coordinator)
    :precondition
      (and
        (coordinator_ready_for_execution ?response_coordinator)
        (not
          (execution_preconditions_met ?response_coordinator)
        )
        (not
          (execution_activity_recorded ?response_coordinator)
        )
      )
    :effect
      (and
        (execution_activity_recorded ?response_coordinator)
        (recovery_executed ?response_coordinator)
      )
  )
  (:action reserve_execution_slot_for_coordinator
    :parameters (?response_coordinator - response_coordinator ?execution_slot - execution_slot)
    :precondition
      (and
        (coordinator_ready_for_execution ?response_coordinator)
        (execution_preconditions_met ?response_coordinator)
        (execution_slot_available ?execution_slot)
      )
    :effect
      (and
        (coordinator_scheduled_execution_slot ?response_coordinator ?execution_slot)
        (not
          (execution_slot_available ?execution_slot)
        )
      )
  )
  (:action activate_execution_monitoring
    :parameters (?response_coordinator - response_coordinator ?primary_delivery_leg - primary_delivery_leg ?alternate_delivery_leg - alternate_delivery_leg ?event_report - event_report ?execution_slot - execution_slot)
    :precondition
      (and
        (coordinator_ready_for_execution ?response_coordinator)
        (execution_preconditions_met ?response_coordinator)
        (coordinator_scheduled_execution_slot ?response_coordinator ?execution_slot)
        (coordinator_assigned_primary_leg ?response_coordinator ?primary_delivery_leg)
        (coordinator_assigned_alternate_leg ?response_coordinator ?alternate_delivery_leg)
        (primary_leg_contingency_confirmed ?primary_delivery_leg)
        (alternate_leg_contingency_confirmed ?alternate_delivery_leg)
        (has_event_report ?response_coordinator ?event_report)
        (not
          (execution_resources_assigned ?response_coordinator)
        )
      )
    :effect (execution_resources_assigned ?response_coordinator)
  )
  (:action finalize_coordinator_execution
    :parameters (?response_coordinator - response_coordinator)
    :precondition
      (and
        (coordinator_ready_for_execution ?response_coordinator)
        (execution_resources_assigned ?response_coordinator)
        (not
          (execution_activity_recorded ?response_coordinator)
        )
      )
    :effect
      (and
        (execution_activity_recorded ?response_coordinator)
        (recovery_executed ?response_coordinator)
      )
  )
  (:action consume_supervisor_approval_and_attach_to_coordinator
    :parameters (?response_coordinator - response_coordinator ?supervisor_approval - supervisor_approval ?event_report - event_report)
    :precondition
      (and
        (validated ?response_coordinator)
        (has_event_report ?response_coordinator ?event_report)
        (supervisor_approval_available ?supervisor_approval)
        (coordinator_has_supervisor_approval ?response_coordinator ?supervisor_approval)
        (not
          (supervisor_approval_attached_to_response_coordinator ?response_coordinator)
        )
      )
    :effect
      (and
        (supervisor_approval_attached_to_response_coordinator ?response_coordinator)
        (not
          (supervisor_approval_available ?supervisor_approval)
        )
      )
  )
  (:action activate_supervisor_approval
    :parameters (?response_coordinator - response_coordinator ?field_operator - field_operator)
    :precondition
      (and
        (supervisor_approval_attached_to_response_coordinator ?response_coordinator)
        (assigned_field_operator ?response_coordinator ?field_operator)
        (not
          (supervisor_approval_active ?response_coordinator)
        )
      )
    :effect (supervisor_approval_active ?response_coordinator)
  )
  (:action attach_regulatory_clearance
    :parameters (?response_coordinator - response_coordinator ?regulatory_clearance - regulatory_clearance)
    :precondition
      (and
        (supervisor_approval_active ?response_coordinator)
        (coordinator_reserved_regulatory_clearance ?response_coordinator ?regulatory_clearance)
        (not
          (regulatory_clearance_attached_to_response_coordinator ?response_coordinator)
        )
      )
    :effect (regulatory_clearance_attached_to_response_coordinator ?response_coordinator)
  )
  (:action authorize_execution_after_regulatory_clearance
    :parameters (?response_coordinator - response_coordinator)
    :precondition
      (and
        (regulatory_clearance_attached_to_response_coordinator ?response_coordinator)
        (not
          (execution_activity_recorded ?response_coordinator)
        )
      )
    :effect
      (and
        (execution_activity_recorded ?response_coordinator)
        (recovery_executed ?response_coordinator)
      )
  )
  (:action finalize_recovery_for_primary_leg
    :parameters (?primary_delivery_leg - primary_delivery_leg ?recovery_plan - recovery_plan)
    :precondition
      (and
        (primary_leg_evaluation_complete ?primary_delivery_leg)
        (primary_leg_contingency_confirmed ?primary_delivery_leg)
        (recovery_plan_committed ?recovery_plan)
        (recovery_plan_ready_for_approval ?recovery_plan)
        (not
          (recovery_executed ?primary_delivery_leg)
        )
      )
    :effect (recovery_executed ?primary_delivery_leg)
  )
  (:action finalize_recovery_for_alternate_leg
    :parameters (?alternate_delivery_leg - alternate_delivery_leg ?recovery_plan - recovery_plan)
    :precondition
      (and
        (alternate_leg_evaluation_complete ?alternate_delivery_leg)
        (alternate_leg_contingency_confirmed ?alternate_delivery_leg)
        (recovery_plan_committed ?recovery_plan)
        (recovery_plan_ready_for_approval ?recovery_plan)
        (not
          (recovery_executed ?alternate_delivery_leg)
        )
      )
    :effect (recovery_executed ?alternate_delivery_leg)
  )
  (:action attach_claim_document_to_exception_instance
    :parameters (?address_exception_case - exception_instance ?claim_document - claim_document ?event_report - event_report)
    :precondition
      (and
        (recovery_executed ?address_exception_case)
        (has_event_report ?address_exception_case ?event_report)
        (claim_document_available ?claim_document)
        (not
          (claim_registered ?address_exception_case)
        )
      )
    :effect
      (and
        (claim_registered ?address_exception_case)
        (has_claim_document ?address_exception_case ?claim_document)
        (not
          (claim_document_available ?claim_document)
        )
      )
  )
  (:action confirm_routing_assignment_for_primary_leg
    :parameters (?primary_delivery_leg - primary_delivery_leg ?routing_resource - routing_resource ?claim_document - claim_document)
    :precondition
      (and
        (claim_registered ?primary_delivery_leg)
        (has_routing_resource ?primary_delivery_leg ?routing_resource)
        (has_claim_document ?primary_delivery_leg ?claim_document)
        (not
          (assignment_confirmed ?primary_delivery_leg)
        )
      )
    :effect
      (and
        (assignment_confirmed ?primary_delivery_leg)
        (routing_resource_available ?routing_resource)
        (claim_document_available ?claim_document)
      )
  )
  (:action confirm_routing_assignment_for_alternate_leg
    :parameters (?alternate_delivery_leg - alternate_delivery_leg ?routing_resource - routing_resource ?claim_document - claim_document)
    :precondition
      (and
        (claim_registered ?alternate_delivery_leg)
        (has_routing_resource ?alternate_delivery_leg ?routing_resource)
        (has_claim_document ?alternate_delivery_leg ?claim_document)
        (not
          (assignment_confirmed ?alternate_delivery_leg)
        )
      )
    :effect
      (and
        (assignment_confirmed ?alternate_delivery_leg)
        (routing_resource_available ?routing_resource)
        (claim_document_available ?claim_document)
      )
  )
  (:action confirm_routing_assignment_for_coordinator
    :parameters (?response_coordinator - response_coordinator ?routing_resource - routing_resource ?claim_document - claim_document)
    :precondition
      (and
        (claim_registered ?response_coordinator)
        (has_routing_resource ?response_coordinator ?routing_resource)
        (has_claim_document ?response_coordinator ?claim_document)
        (not
          (assignment_confirmed ?response_coordinator)
        )
      )
    :effect
      (and
        (assignment_confirmed ?response_coordinator)
        (routing_resource_available ?routing_resource)
        (claim_document_available ?claim_document)
      )
  )
)

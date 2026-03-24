(define (domain agriculture_budget_constrained_procurement_selection)
  (:requirements :strips :typing :negative-preconditions)
  (:types material_resource - object support_resource - object logistics_resource - object domain_entity - object allocation_target - domain_entity supplier_option - material_resource input_product - material_resource equipment - material_resource promotional_offer - material_resource labor_package - material_resource contingency_reserve - material_resource storage_resource - material_resource insurance_policy - material_resource accessory_item - support_resource compliance_document - support_resource site_constraint - support_resource inbound_logistics_slot - logistics_resource outbound_logistics_slot - logistics_resource purchase_order - logistics_resource parcel_role - allocation_target agent_role - allocation_target crop_parcel - parcel_role alternate_parcel - parcel_role procurement_agent - agent_role)
  (:predicates
    (procurement_case_open ?allocation_target - allocation_target)
    (allocation_validated ?allocation_target - allocation_target)
    (supplier_bound ?allocation_target - allocation_target)
    (allocation_committed ?allocation_target - allocation_target)
    (ready_for_commitment ?allocation_target - allocation_target)
    (contingency_assigned ?allocation_target - allocation_target)
    (supplier_available ?supplier_option - supplier_option)
    (supplier_bound_to_case ?allocation_target - allocation_target ?supplier_option - supplier_option)
    (product_available ?input_product - input_product)
    (product_assigned ?allocation_target - allocation_target ?input_product - input_product)
    (equipment_available ?equipment - equipment)
    (equipment_assigned ?allocation_target - allocation_target ?equipment - equipment)
    (accessory_available ?accessory_item - accessory_item)
    (accessory_assigned_to_parcel ?crop_parcel - crop_parcel ?accessory_item - accessory_item)
    (accessory_assigned_to_alternate_parcel ?alternate_parcel - alternate_parcel ?accessory_item - accessory_item)
    (inbound_slot_assigned_to_parcel ?crop_parcel - crop_parcel ?inbound_logistics_slot - inbound_logistics_slot)
    (inbound_slot_ready ?inbound_logistics_slot - inbound_logistics_slot)
    (inbound_slot_tagged_with_accessory ?inbound_logistics_slot - inbound_logistics_slot)
    (parcel_ready ?crop_parcel - crop_parcel)
    (outbound_slot_assigned_to_alternate_parcel ?alternate_parcel - alternate_parcel ?outbound_logistics_slot - outbound_logistics_slot)
    (outbound_slot_ready ?outbound_logistics_slot - outbound_logistics_slot)
    (outbound_slot_tagged_with_accessory ?outbound_logistics_slot - outbound_logistics_slot)
    (alternate_parcel_ready ?alternate_parcel - alternate_parcel)
    (purchase_order_staged ?purchase_order - purchase_order)
    (purchase_order_staged_ready ?purchase_order - purchase_order)
    (purchase_order_has_inbound_slot ?purchase_order - purchase_order ?inbound_logistics_slot - inbound_logistics_slot)
    (purchase_order_has_outbound_slot ?purchase_order - purchase_order ?outbound_logistics_slot - outbound_logistics_slot)
    (purchase_order_inbound_flag ?purchase_order - purchase_order)
    (purchase_order_outbound_flag ?purchase_order - purchase_order)
    (purchase_order_finalized ?purchase_order - purchase_order)
    (agent_assigned_to_parcel ?procurement_agent - procurement_agent ?crop_parcel - crop_parcel)
    (agent_assigned_to_alternate_parcel ?procurement_agent - procurement_agent ?alternate_parcel - alternate_parcel)
    (agent_assigned_to_purchase_order ?procurement_agent - procurement_agent ?purchase_order - purchase_order)
    (compliance_document_available ?compliance_document - compliance_document)
    (agent_has_document ?procurement_agent - procurement_agent ?compliance_document - compliance_document)
    (compliance_document_attached ?compliance_document - compliance_document)
    (document_attached_to_purchase_order ?compliance_document - compliance_document ?purchase_order - purchase_order)
    (agent_validated ?procurement_agent - procurement_agent)
    (agent_storage_and_documents_ready ?procurement_agent - procurement_agent)
    (agent_ready_for_execution ?procurement_agent - procurement_agent)
    (agent_promo_claimed ?procurement_agent - procurement_agent)
    (agent_promo_acknowledged ?procurement_agent - procurement_agent)
    (agent_promo_applied ?procurement_agent - procurement_agent)
    (agent_final_checks_done ?procurement_agent - procurement_agent)
    (site_constraint_active ?site_constraint - site_constraint)
    (agent_has_site_constraint ?procurement_agent - procurement_agent ?site_constraint - site_constraint)
    (agent_constraint_applied ?procurement_agent - procurement_agent)
    (agent_approval_stage_one ?procurement_agent - procurement_agent)
    (agent_final_approval ?procurement_agent - procurement_agent)
    (promotional_offer_available ?promotional_offer - promotional_offer)
    (agent_has_promotional_offer ?procurement_agent - procurement_agent ?promotional_offer - promotional_offer)
    (labor_package_available ?labor_package - labor_package)
    (agent_assigned_labor_package ?procurement_agent - procurement_agent ?labor_package - labor_package)
    (storage_available ?storage_resource - storage_resource)
    (agent_assigned_storage ?procurement_agent - procurement_agent ?storage_resource - storage_resource)
    (insurance_available ?insurance_policy - insurance_policy)
    (agent_assigned_insurance ?procurement_agent - procurement_agent ?insurance_policy - insurance_policy)
    (contingency_reserve_available ?contingency_reserve - contingency_reserve)
    (contingency_reserve_assigned_to_target ?allocation_target - allocation_target ?contingency_reserve - contingency_reserve)
    (parcel_processing_marker ?crop_parcel - crop_parcel)
    (alternate_parcel_processing_marker ?alternate_parcel - alternate_parcel)
    (agent_committed ?procurement_agent - procurement_agent)
  )
  (:action create_procurement_case
    :parameters (?allocation_target - allocation_target)
    :precondition
      (and
        (not
          (procurement_case_open ?allocation_target)
        )
        (not
          (allocation_committed ?allocation_target)
        )
      )
    :effect (procurement_case_open ?allocation_target)
  )
  (:action select_and_reserve_supplier
    :parameters (?allocation_target - allocation_target ?supplier_option - supplier_option)
    :precondition
      (and
        (procurement_case_open ?allocation_target)
        (not
          (supplier_bound ?allocation_target)
        )
        (supplier_available ?supplier_option)
      )
    :effect
      (and
        (supplier_bound ?allocation_target)
        (supplier_bound_to_case ?allocation_target ?supplier_option)
        (not
          (supplier_available ?supplier_option)
        )
      )
  )
  (:action reserve_input_product_for_case
    :parameters (?allocation_target - allocation_target ?input_product - input_product)
    :precondition
      (and
        (procurement_case_open ?allocation_target)
        (supplier_bound ?allocation_target)
        (product_available ?input_product)
      )
    :effect
      (and
        (product_assigned ?allocation_target ?input_product)
        (not
          (product_available ?input_product)
        )
      )
  )
  (:action validate_case_input_assignment
    :parameters (?allocation_target - allocation_target ?input_product - input_product)
    :precondition
      (and
        (procurement_case_open ?allocation_target)
        (supplier_bound ?allocation_target)
        (product_assigned ?allocation_target ?input_product)
        (not
          (allocation_validated ?allocation_target)
        )
      )
    :effect (allocation_validated ?allocation_target)
  )
  (:action release_input_product_from_case
    :parameters (?allocation_target - allocation_target ?input_product - input_product)
    :precondition
      (and
        (product_assigned ?allocation_target ?input_product)
      )
    :effect
      (and
        (product_available ?input_product)
        (not
          (product_assigned ?allocation_target ?input_product)
        )
      )
  )
  (:action reserve_equipment_for_case
    :parameters (?allocation_target - allocation_target ?equipment - equipment)
    :precondition
      (and
        (allocation_validated ?allocation_target)
        (equipment_available ?equipment)
      )
    :effect
      (and
        (equipment_assigned ?allocation_target ?equipment)
        (not
          (equipment_available ?equipment)
        )
      )
  )
  (:action release_equipment_from_case
    :parameters (?allocation_target - allocation_target ?equipment - equipment)
    :precondition
      (and
        (equipment_assigned ?allocation_target ?equipment)
      )
    :effect
      (and
        (equipment_available ?equipment)
        (not
          (equipment_assigned ?allocation_target ?equipment)
        )
      )
  )
  (:action assign_storage_to_agent
    :parameters (?procurement_agent - procurement_agent ?storage_resource - storage_resource)
    :precondition
      (and
        (allocation_validated ?procurement_agent)
        (storage_available ?storage_resource)
      )
    :effect
      (and
        (agent_assigned_storage ?procurement_agent ?storage_resource)
        (not
          (storage_available ?storage_resource)
        )
      )
  )
  (:action release_storage_from_agent
    :parameters (?procurement_agent - procurement_agent ?storage_resource - storage_resource)
    :precondition
      (and
        (agent_assigned_storage ?procurement_agent ?storage_resource)
      )
    :effect
      (and
        (storage_available ?storage_resource)
        (not
          (agent_assigned_storage ?procurement_agent ?storage_resource)
        )
      )
  )
  (:action assign_insurance_to_agent
    :parameters (?procurement_agent - procurement_agent ?insurance_policy - insurance_policy)
    :precondition
      (and
        (allocation_validated ?procurement_agent)
        (insurance_available ?insurance_policy)
      )
    :effect
      (and
        (agent_assigned_insurance ?procurement_agent ?insurance_policy)
        (not
          (insurance_available ?insurance_policy)
        )
      )
  )
  (:action release_insurance_from_agent
    :parameters (?procurement_agent - procurement_agent ?insurance_policy - insurance_policy)
    :precondition
      (and
        (agent_assigned_insurance ?procurement_agent ?insurance_policy)
      )
    :effect
      (and
        (insurance_available ?insurance_policy)
        (not
          (agent_assigned_insurance ?procurement_agent ?insurance_policy)
        )
      )
  )
  (:action mark_inbound_slot_ready_for_parcel
    :parameters (?crop_parcel - crop_parcel ?inbound_logistics_slot - inbound_logistics_slot ?input_product - input_product)
    :precondition
      (and
        (allocation_validated ?crop_parcel)
        (product_assigned ?crop_parcel ?input_product)
        (inbound_slot_assigned_to_parcel ?crop_parcel ?inbound_logistics_slot)
        (not
          (inbound_slot_ready ?inbound_logistics_slot)
        )
        (not
          (inbound_slot_tagged_with_accessory ?inbound_logistics_slot)
        )
      )
    :effect (inbound_slot_ready ?inbound_logistics_slot)
  )
  (:action qualify_parcel_with_equipment
    :parameters (?crop_parcel - crop_parcel ?inbound_logistics_slot - inbound_logistics_slot ?equipment - equipment)
    :precondition
      (and
        (allocation_validated ?crop_parcel)
        (equipment_assigned ?crop_parcel ?equipment)
        (inbound_slot_assigned_to_parcel ?crop_parcel ?inbound_logistics_slot)
        (inbound_slot_ready ?inbound_logistics_slot)
        (not
          (parcel_processing_marker ?crop_parcel)
        )
      )
    :effect
      (and
        (parcel_processing_marker ?crop_parcel)
        (parcel_ready ?crop_parcel)
      )
  )
  (:action attach_accessory_to_parcel
    :parameters (?crop_parcel - crop_parcel ?inbound_logistics_slot - inbound_logistics_slot ?accessory_item - accessory_item)
    :precondition
      (and
        (allocation_validated ?crop_parcel)
        (inbound_slot_assigned_to_parcel ?crop_parcel ?inbound_logistics_slot)
        (accessory_available ?accessory_item)
        (not
          (parcel_processing_marker ?crop_parcel)
        )
      )
    :effect
      (and
        (inbound_slot_tagged_with_accessory ?inbound_logistics_slot)
        (parcel_processing_marker ?crop_parcel)
        (accessory_assigned_to_parcel ?crop_parcel ?accessory_item)
        (not
          (accessory_available ?accessory_item)
        )
      )
  )
  (:action finalize_parcel_accessory_assignment
    :parameters (?crop_parcel - crop_parcel ?inbound_logistics_slot - inbound_logistics_slot ?input_product - input_product ?accessory_item - accessory_item)
    :precondition
      (and
        (allocation_validated ?crop_parcel)
        (product_assigned ?crop_parcel ?input_product)
        (inbound_slot_assigned_to_parcel ?crop_parcel ?inbound_logistics_slot)
        (inbound_slot_tagged_with_accessory ?inbound_logistics_slot)
        (accessory_assigned_to_parcel ?crop_parcel ?accessory_item)
        (not
          (parcel_ready ?crop_parcel)
        )
      )
    :effect
      (and
        (inbound_slot_ready ?inbound_logistics_slot)
        (parcel_ready ?crop_parcel)
        (accessory_available ?accessory_item)
        (not
          (accessory_assigned_to_parcel ?crop_parcel ?accessory_item)
        )
      )
  )
  (:action mark_outbound_slot_ready_for_alternate_parcel
    :parameters (?alternate_parcel - alternate_parcel ?outbound_logistics_slot - outbound_logistics_slot ?input_product - input_product)
    :precondition
      (and
        (allocation_validated ?alternate_parcel)
        (product_assigned ?alternate_parcel ?input_product)
        (outbound_slot_assigned_to_alternate_parcel ?alternate_parcel ?outbound_logistics_slot)
        (not
          (outbound_slot_ready ?outbound_logistics_slot)
        )
        (not
          (outbound_slot_tagged_with_accessory ?outbound_logistics_slot)
        )
      )
    :effect (outbound_slot_ready ?outbound_logistics_slot)
  )
  (:action qualify_alternate_parcel_with_equipment
    :parameters (?alternate_parcel - alternate_parcel ?outbound_logistics_slot - outbound_logistics_slot ?equipment - equipment)
    :precondition
      (and
        (allocation_validated ?alternate_parcel)
        (equipment_assigned ?alternate_parcel ?equipment)
        (outbound_slot_assigned_to_alternate_parcel ?alternate_parcel ?outbound_logistics_slot)
        (outbound_slot_ready ?outbound_logistics_slot)
        (not
          (alternate_parcel_processing_marker ?alternate_parcel)
        )
      )
    :effect
      (and
        (alternate_parcel_processing_marker ?alternate_parcel)
        (alternate_parcel_ready ?alternate_parcel)
      )
  )
  (:action attach_accessory_to_alternate_parcel
    :parameters (?alternate_parcel - alternate_parcel ?outbound_logistics_slot - outbound_logistics_slot ?accessory_item - accessory_item)
    :precondition
      (and
        (allocation_validated ?alternate_parcel)
        (outbound_slot_assigned_to_alternate_parcel ?alternate_parcel ?outbound_logistics_slot)
        (accessory_available ?accessory_item)
        (not
          (alternate_parcel_processing_marker ?alternate_parcel)
        )
      )
    :effect
      (and
        (outbound_slot_tagged_with_accessory ?outbound_logistics_slot)
        (alternate_parcel_processing_marker ?alternate_parcel)
        (accessory_assigned_to_alternate_parcel ?alternate_parcel ?accessory_item)
        (not
          (accessory_available ?accessory_item)
        )
      )
  )
  (:action finalize_alternate_parcel_accessory_assignment
    :parameters (?alternate_parcel - alternate_parcel ?outbound_logistics_slot - outbound_logistics_slot ?input_product - input_product ?accessory_item - accessory_item)
    :precondition
      (and
        (allocation_validated ?alternate_parcel)
        (product_assigned ?alternate_parcel ?input_product)
        (outbound_slot_assigned_to_alternate_parcel ?alternate_parcel ?outbound_logistics_slot)
        (outbound_slot_tagged_with_accessory ?outbound_logistics_slot)
        (accessory_assigned_to_alternate_parcel ?alternate_parcel ?accessory_item)
        (not
          (alternate_parcel_ready ?alternate_parcel)
        )
      )
    :effect
      (and
        (outbound_slot_ready ?outbound_logistics_slot)
        (alternate_parcel_ready ?alternate_parcel)
        (accessory_available ?accessory_item)
        (not
          (accessory_assigned_to_alternate_parcel ?alternate_parcel ?accessory_item)
        )
      )
  )
  (:action stage_purchase_order_both_slots_confirmed
    :parameters (?crop_parcel - crop_parcel ?alternate_parcel - alternate_parcel ?inbound_logistics_slot - inbound_logistics_slot ?outbound_logistics_slot - outbound_logistics_slot ?purchase_order - purchase_order)
    :precondition
      (and
        (parcel_processing_marker ?crop_parcel)
        (alternate_parcel_processing_marker ?alternate_parcel)
        (inbound_slot_assigned_to_parcel ?crop_parcel ?inbound_logistics_slot)
        (outbound_slot_assigned_to_alternate_parcel ?alternate_parcel ?outbound_logistics_slot)
        (inbound_slot_ready ?inbound_logistics_slot)
        (outbound_slot_ready ?outbound_logistics_slot)
        (parcel_ready ?crop_parcel)
        (alternate_parcel_ready ?alternate_parcel)
        (purchase_order_staged ?purchase_order)
      )
    :effect
      (and
        (purchase_order_staged_ready ?purchase_order)
        (purchase_order_has_inbound_slot ?purchase_order ?inbound_logistics_slot)
        (purchase_order_has_outbound_slot ?purchase_order ?outbound_logistics_slot)
        (not
          (purchase_order_staged ?purchase_order)
        )
      )
  )
  (:action stage_purchase_order_inbound_accessory
    :parameters (?crop_parcel - crop_parcel ?alternate_parcel - alternate_parcel ?inbound_logistics_slot - inbound_logistics_slot ?outbound_logistics_slot - outbound_logistics_slot ?purchase_order - purchase_order)
    :precondition
      (and
        (parcel_processing_marker ?crop_parcel)
        (alternate_parcel_processing_marker ?alternate_parcel)
        (inbound_slot_assigned_to_parcel ?crop_parcel ?inbound_logistics_slot)
        (outbound_slot_assigned_to_alternate_parcel ?alternate_parcel ?outbound_logistics_slot)
        (inbound_slot_tagged_with_accessory ?inbound_logistics_slot)
        (outbound_slot_ready ?outbound_logistics_slot)
        (not
          (parcel_ready ?crop_parcel)
        )
        (alternate_parcel_ready ?alternate_parcel)
        (purchase_order_staged ?purchase_order)
      )
    :effect
      (and
        (purchase_order_staged_ready ?purchase_order)
        (purchase_order_has_inbound_slot ?purchase_order ?inbound_logistics_slot)
        (purchase_order_has_outbound_slot ?purchase_order ?outbound_logistics_slot)
        (purchase_order_inbound_flag ?purchase_order)
        (not
          (purchase_order_staged ?purchase_order)
        )
      )
  )
  (:action stage_purchase_order_outbound_accessory
    :parameters (?crop_parcel - crop_parcel ?alternate_parcel - alternate_parcel ?inbound_logistics_slot - inbound_logistics_slot ?outbound_logistics_slot - outbound_logistics_slot ?purchase_order - purchase_order)
    :precondition
      (and
        (parcel_processing_marker ?crop_parcel)
        (alternate_parcel_processing_marker ?alternate_parcel)
        (inbound_slot_assigned_to_parcel ?crop_parcel ?inbound_logistics_slot)
        (outbound_slot_assigned_to_alternate_parcel ?alternate_parcel ?outbound_logistics_slot)
        (inbound_slot_ready ?inbound_logistics_slot)
        (outbound_slot_tagged_with_accessory ?outbound_logistics_slot)
        (parcel_ready ?crop_parcel)
        (not
          (alternate_parcel_ready ?alternate_parcel)
        )
        (purchase_order_staged ?purchase_order)
      )
    :effect
      (and
        (purchase_order_staged_ready ?purchase_order)
        (purchase_order_has_inbound_slot ?purchase_order ?inbound_logistics_slot)
        (purchase_order_has_outbound_slot ?purchase_order ?outbound_logistics_slot)
        (purchase_order_outbound_flag ?purchase_order)
        (not
          (purchase_order_staged ?purchase_order)
        )
      )
  )
  (:action stage_purchase_order_both_accessories
    :parameters (?crop_parcel - crop_parcel ?alternate_parcel - alternate_parcel ?inbound_logistics_slot - inbound_logistics_slot ?outbound_logistics_slot - outbound_logistics_slot ?purchase_order - purchase_order)
    :precondition
      (and
        (parcel_processing_marker ?crop_parcel)
        (alternate_parcel_processing_marker ?alternate_parcel)
        (inbound_slot_assigned_to_parcel ?crop_parcel ?inbound_logistics_slot)
        (outbound_slot_assigned_to_alternate_parcel ?alternate_parcel ?outbound_logistics_slot)
        (inbound_slot_tagged_with_accessory ?inbound_logistics_slot)
        (outbound_slot_tagged_with_accessory ?outbound_logistics_slot)
        (not
          (parcel_ready ?crop_parcel)
        )
        (not
          (alternate_parcel_ready ?alternate_parcel)
        )
        (purchase_order_staged ?purchase_order)
      )
    :effect
      (and
        (purchase_order_staged_ready ?purchase_order)
        (purchase_order_has_inbound_slot ?purchase_order ?inbound_logistics_slot)
        (purchase_order_has_outbound_slot ?purchase_order ?outbound_logistics_slot)
        (purchase_order_inbound_flag ?purchase_order)
        (purchase_order_outbound_flag ?purchase_order)
        (not
          (purchase_order_staged ?purchase_order)
        )
      )
  )
  (:action finalize_purchase_order_for_parcel
    :parameters (?purchase_order - purchase_order ?crop_parcel - crop_parcel ?input_product - input_product)
    :precondition
      (and
        (purchase_order_staged_ready ?purchase_order)
        (parcel_processing_marker ?crop_parcel)
        (product_assigned ?crop_parcel ?input_product)
        (not
          (purchase_order_finalized ?purchase_order)
        )
      )
    :effect (purchase_order_finalized ?purchase_order)
  )
  (:action attach_compliance_document_to_order
    :parameters (?procurement_agent - procurement_agent ?compliance_document - compliance_document ?purchase_order - purchase_order)
    :precondition
      (and
        (allocation_validated ?procurement_agent)
        (agent_assigned_to_purchase_order ?procurement_agent ?purchase_order)
        (agent_has_document ?procurement_agent ?compliance_document)
        (compliance_document_available ?compliance_document)
        (purchase_order_staged_ready ?purchase_order)
        (purchase_order_finalized ?purchase_order)
        (not
          (compliance_document_attached ?compliance_document)
        )
      )
    :effect
      (and
        (compliance_document_attached ?compliance_document)
        (document_attached_to_purchase_order ?compliance_document ?purchase_order)
        (not
          (compliance_document_available ?compliance_document)
        )
      )
  )
  (:action validate_agent_documents_and_order
    :parameters (?procurement_agent - procurement_agent ?compliance_document - compliance_document ?purchase_order - purchase_order ?input_product - input_product)
    :precondition
      (and
        (allocation_validated ?procurement_agent)
        (agent_has_document ?procurement_agent ?compliance_document)
        (compliance_document_attached ?compliance_document)
        (document_attached_to_purchase_order ?compliance_document ?purchase_order)
        (product_assigned ?procurement_agent ?input_product)
        (not
          (purchase_order_inbound_flag ?purchase_order)
        )
        (not
          (agent_validated ?procurement_agent)
        )
      )
    :effect (agent_validated ?procurement_agent)
  )
  (:action apply_promotional_offer_to_agent
    :parameters (?procurement_agent - procurement_agent ?promotional_offer - promotional_offer)
    :precondition
      (and
        (allocation_validated ?procurement_agent)
        (promotional_offer_available ?promotional_offer)
        (not
          (agent_promo_claimed ?procurement_agent)
        )
      )
    :effect
      (and
        (agent_promo_claimed ?procurement_agent)
        (agent_has_promotional_offer ?procurement_agent ?promotional_offer)
        (not
          (promotional_offer_available ?promotional_offer)
        )
      )
  )
  (:action acknowledge_promo_and_mark_agent
    :parameters (?procurement_agent - procurement_agent ?compliance_document - compliance_document ?purchase_order - purchase_order ?input_product - input_product ?promotional_offer - promotional_offer)
    :precondition
      (and
        (allocation_validated ?procurement_agent)
        (agent_has_document ?procurement_agent ?compliance_document)
        (compliance_document_attached ?compliance_document)
        (document_attached_to_purchase_order ?compliance_document ?purchase_order)
        (product_assigned ?procurement_agent ?input_product)
        (purchase_order_inbound_flag ?purchase_order)
        (agent_promo_claimed ?procurement_agent)
        (agent_has_promotional_offer ?procurement_agent ?promotional_offer)
        (not
          (agent_validated ?procurement_agent)
        )
      )
    :effect
      (and
        (agent_validated ?procurement_agent)
        (agent_promo_acknowledged ?procurement_agent)
      )
  )
  (:action prepare_agent_for_storage_processing
    :parameters (?procurement_agent - procurement_agent ?storage_resource - storage_resource ?equipment - equipment ?compliance_document - compliance_document ?purchase_order - purchase_order)
    :precondition
      (and
        (agent_validated ?procurement_agent)
        (agent_assigned_storage ?procurement_agent ?storage_resource)
        (equipment_assigned ?procurement_agent ?equipment)
        (agent_has_document ?procurement_agent ?compliance_document)
        (document_attached_to_purchase_order ?compliance_document ?purchase_order)
        (not
          (purchase_order_outbound_flag ?purchase_order)
        )
        (not
          (agent_storage_and_documents_ready ?procurement_agent)
        )
      )
    :effect (agent_storage_and_documents_ready ?procurement_agent)
  )
  (:action finalize_agent_storage_preparation
    :parameters (?procurement_agent - procurement_agent ?storage_resource - storage_resource ?equipment - equipment ?compliance_document - compliance_document ?purchase_order - purchase_order)
    :precondition
      (and
        (agent_validated ?procurement_agent)
        (agent_assigned_storage ?procurement_agent ?storage_resource)
        (equipment_assigned ?procurement_agent ?equipment)
        (agent_has_document ?procurement_agent ?compliance_document)
        (document_attached_to_purchase_order ?compliance_document ?purchase_order)
        (purchase_order_outbound_flag ?purchase_order)
        (not
          (agent_storage_and_documents_ready ?procurement_agent)
        )
      )
    :effect (agent_storage_and_documents_ready ?procurement_agent)
  )
  (:action authorize_agent_for_execution
    :parameters (?procurement_agent - procurement_agent ?insurance_policy - insurance_policy ?compliance_document - compliance_document ?purchase_order - purchase_order)
    :precondition
      (and
        (agent_storage_and_documents_ready ?procurement_agent)
        (agent_assigned_insurance ?procurement_agent ?insurance_policy)
        (agent_has_document ?procurement_agent ?compliance_document)
        (document_attached_to_purchase_order ?compliance_document ?purchase_order)
        (not
          (purchase_order_inbound_flag ?purchase_order)
        )
        (not
          (purchase_order_outbound_flag ?purchase_order)
        )
        (not
          (agent_ready_for_execution ?procurement_agent)
        )
      )
    :effect (agent_ready_for_execution ?procurement_agent)
  )
  (:action authorize_agent_and_apply_promo_flag
    :parameters (?procurement_agent - procurement_agent ?insurance_policy - insurance_policy ?compliance_document - compliance_document ?purchase_order - purchase_order)
    :precondition
      (and
        (agent_storage_and_documents_ready ?procurement_agent)
        (agent_assigned_insurance ?procurement_agent ?insurance_policy)
        (agent_has_document ?procurement_agent ?compliance_document)
        (document_attached_to_purchase_order ?compliance_document ?purchase_order)
        (purchase_order_inbound_flag ?purchase_order)
        (not
          (purchase_order_outbound_flag ?purchase_order)
        )
        (not
          (agent_ready_for_execution ?procurement_agent)
        )
      )
    :effect
      (and
        (agent_ready_for_execution ?procurement_agent)
        (agent_promo_applied ?procurement_agent)
      )
  )
  (:action authorize_agent_and_apply_promo
    :parameters (?procurement_agent - procurement_agent ?insurance_policy - insurance_policy ?compliance_document - compliance_document ?purchase_order - purchase_order)
    :precondition
      (and
        (agent_storage_and_documents_ready ?procurement_agent)
        (agent_assigned_insurance ?procurement_agent ?insurance_policy)
        (agent_has_document ?procurement_agent ?compliance_document)
        (document_attached_to_purchase_order ?compliance_document ?purchase_order)
        (not
          (purchase_order_inbound_flag ?purchase_order)
        )
        (purchase_order_outbound_flag ?purchase_order)
        (not
          (agent_ready_for_execution ?procurement_agent)
        )
      )
    :effect
      (and
        (agent_ready_for_execution ?procurement_agent)
        (agent_promo_applied ?procurement_agent)
      )
  )
  (:action authorize_agent_and_apply_promo_full
    :parameters (?procurement_agent - procurement_agent ?insurance_policy - insurance_policy ?compliance_document - compliance_document ?purchase_order - purchase_order)
    :precondition
      (and
        (agent_storage_and_documents_ready ?procurement_agent)
        (agent_assigned_insurance ?procurement_agent ?insurance_policy)
        (agent_has_document ?procurement_agent ?compliance_document)
        (document_attached_to_purchase_order ?compliance_document ?purchase_order)
        (purchase_order_inbound_flag ?purchase_order)
        (purchase_order_outbound_flag ?purchase_order)
        (not
          (agent_ready_for_execution ?procurement_agent)
        )
      )
    :effect
      (and
        (agent_ready_for_execution ?procurement_agent)
        (agent_promo_applied ?procurement_agent)
      )
  )
  (:action lock_agent_and_mark_ready
    :parameters (?procurement_agent - procurement_agent)
    :precondition
      (and
        (agent_ready_for_execution ?procurement_agent)
        (not
          (agent_promo_applied ?procurement_agent)
        )
        (not
          (agent_committed ?procurement_agent)
        )
      )
    :effect
      (and
        (agent_committed ?procurement_agent)
        (ready_for_commitment ?procurement_agent)
      )
  )
  (:action assign_labor_package_to_agent
    :parameters (?procurement_agent - procurement_agent ?labor_package - labor_package)
    :precondition
      (and
        (agent_ready_for_execution ?procurement_agent)
        (agent_promo_applied ?procurement_agent)
        (labor_package_available ?labor_package)
      )
    :effect
      (and
        (agent_assigned_labor_package ?procurement_agent ?labor_package)
        (not
          (labor_package_available ?labor_package)
        )
      )
  )
  (:action complete_agent_validation_checks
    :parameters (?procurement_agent - procurement_agent ?crop_parcel - crop_parcel ?alternate_parcel - alternate_parcel ?input_product - input_product ?labor_package - labor_package)
    :precondition
      (and
        (agent_ready_for_execution ?procurement_agent)
        (agent_promo_applied ?procurement_agent)
        (agent_assigned_labor_package ?procurement_agent ?labor_package)
        (agent_assigned_to_parcel ?procurement_agent ?crop_parcel)
        (agent_assigned_to_alternate_parcel ?procurement_agent ?alternate_parcel)
        (parcel_ready ?crop_parcel)
        (alternate_parcel_ready ?alternate_parcel)
        (product_assigned ?procurement_agent ?input_product)
        (not
          (agent_final_checks_done ?procurement_agent)
        )
      )
    :effect (agent_final_checks_done ?procurement_agent)
  )
  (:action commit_agent_with_final_checks
    :parameters (?procurement_agent - procurement_agent)
    :precondition
      (and
        (agent_ready_for_execution ?procurement_agent)
        (agent_final_checks_done ?procurement_agent)
        (not
          (agent_committed ?procurement_agent)
        )
      )
    :effect
      (and
        (agent_committed ?procurement_agent)
        (ready_for_commitment ?procurement_agent)
      )
  )
  (:action apply_site_constraint_to_agent
    :parameters (?procurement_agent - procurement_agent ?site_constraint - site_constraint ?input_product - input_product)
    :precondition
      (and
        (allocation_validated ?procurement_agent)
        (product_assigned ?procurement_agent ?input_product)
        (site_constraint_active ?site_constraint)
        (agent_has_site_constraint ?procurement_agent ?site_constraint)
        (not
          (agent_constraint_applied ?procurement_agent)
        )
      )
    :effect
      (and
        (agent_constraint_applied ?procurement_agent)
        (not
          (site_constraint_active ?site_constraint)
        )
      )
  )
  (:action start_agent_approval
    :parameters (?procurement_agent - procurement_agent ?equipment - equipment)
    :precondition
      (and
        (agent_constraint_applied ?procurement_agent)
        (equipment_assigned ?procurement_agent ?equipment)
        (not
          (agent_approval_stage_one ?procurement_agent)
        )
      )
    :effect (agent_approval_stage_one ?procurement_agent)
  )
  (:action finalize_agent_insurance_approval
    :parameters (?procurement_agent - procurement_agent ?insurance_policy - insurance_policy)
    :precondition
      (and
        (agent_approval_stage_one ?procurement_agent)
        (agent_assigned_insurance ?procurement_agent ?insurance_policy)
        (not
          (agent_final_approval ?procurement_agent)
        )
      )
    :effect (agent_final_approval ?procurement_agent)
  )
  (:action commit_agent_after_approval
    :parameters (?procurement_agent - procurement_agent)
    :precondition
      (and
        (agent_final_approval ?procurement_agent)
        (not
          (agent_committed ?procurement_agent)
        )
      )
    :effect
      (and
        (agent_committed ?procurement_agent)
        (ready_for_commitment ?procurement_agent)
      )
  )
  (:action confirm_allocation_to_parcel
    :parameters (?crop_parcel - crop_parcel ?purchase_order - purchase_order)
    :precondition
      (and
        (parcel_processing_marker ?crop_parcel)
        (parcel_ready ?crop_parcel)
        (purchase_order_staged_ready ?purchase_order)
        (purchase_order_finalized ?purchase_order)
        (not
          (ready_for_commitment ?crop_parcel)
        )
      )
    :effect (ready_for_commitment ?crop_parcel)
  )
  (:action confirm_allocation_to_alternate_parcel
    :parameters (?alternate_parcel - alternate_parcel ?purchase_order - purchase_order)
    :precondition
      (and
        (alternate_parcel_processing_marker ?alternate_parcel)
        (alternate_parcel_ready ?alternate_parcel)
        (purchase_order_staged_ready ?purchase_order)
        (purchase_order_finalized ?purchase_order)
        (not
          (ready_for_commitment ?alternate_parcel)
        )
      )
    :effect (ready_for_commitment ?alternate_parcel)
  )
  (:action assign_contingency_reserve_to_case
    :parameters (?allocation_target - allocation_target ?contingency_reserve - contingency_reserve ?input_product - input_product)
    :precondition
      (and
        (ready_for_commitment ?allocation_target)
        (product_assigned ?allocation_target ?input_product)
        (contingency_reserve_available ?contingency_reserve)
        (not
          (contingency_assigned ?allocation_target)
        )
      )
    :effect
      (and
        (contingency_assigned ?allocation_target)
        (contingency_reserve_assigned_to_target ?allocation_target ?contingency_reserve)
        (not
          (contingency_reserve_available ?contingency_reserve)
        )
      )
  )
  (:action commit_allocation_for_parcel
    :parameters (?crop_parcel - crop_parcel ?supplier_option - supplier_option ?contingency_reserve - contingency_reserve)
    :precondition
      (and
        (contingency_assigned ?crop_parcel)
        (supplier_bound_to_case ?crop_parcel ?supplier_option)
        (contingency_reserve_assigned_to_target ?crop_parcel ?contingency_reserve)
        (not
          (allocation_committed ?crop_parcel)
        )
      )
    :effect
      (and
        (allocation_committed ?crop_parcel)
        (supplier_available ?supplier_option)
        (contingency_reserve_available ?contingency_reserve)
      )
  )
  (:action commit_allocation_for_alternate_parcel
    :parameters (?alternate_parcel - alternate_parcel ?supplier_option - supplier_option ?contingency_reserve - contingency_reserve)
    :precondition
      (and
        (contingency_assigned ?alternate_parcel)
        (supplier_bound_to_case ?alternate_parcel ?supplier_option)
        (contingency_reserve_assigned_to_target ?alternate_parcel ?contingency_reserve)
        (not
          (allocation_committed ?alternate_parcel)
        )
      )
    :effect
      (and
        (allocation_committed ?alternate_parcel)
        (supplier_available ?supplier_option)
        (contingency_reserve_available ?contingency_reserve)
      )
  )
  (:action commit_allocation_for_agent
    :parameters (?procurement_agent - procurement_agent ?supplier_option - supplier_option ?contingency_reserve - contingency_reserve)
    :precondition
      (and
        (contingency_assigned ?procurement_agent)
        (supplier_bound_to_case ?procurement_agent ?supplier_option)
        (contingency_reserve_assigned_to_target ?procurement_agent ?contingency_reserve)
        (not
          (allocation_committed ?procurement_agent)
        )
      )
    :effect
      (and
        (allocation_committed ?procurement_agent)
        (supplier_available ?supplier_option)
        (contingency_reserve_available ?contingency_reserve)
      )
  )
)

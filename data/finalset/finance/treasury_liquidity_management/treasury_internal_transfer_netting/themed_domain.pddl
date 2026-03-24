(define (domain treasury_internal_transfer_netting_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types entity_role_group - object account_role_group - object instrument_role_group - object participant_root - object legal_entity - participant_root settlement_channel - entity_role_group transfer_request - entity_role_group funding_account - entity_role_group compliance_approval - entity_role_group fee_structure - entity_role_group funding_resource - entity_role_group liquidity_limit - entity_role_group regulatory_flag - entity_role_group offset_instruction - account_role_group liquidity_buffer - account_role_group priority_directive - account_role_group cash_account_source - instrument_role_group cash_account_destination - instrument_role_group settlement_order - instrument_role_group source_role_category - legal_entity destination_role_category - legal_entity source_subsidiary - source_role_category destination_subsidiary - source_role_category netting_job - destination_role_category)
  (:predicates
    (entity_registered_for_netting ?entity - legal_entity)
    (entity_approved_for_processing ?entity - legal_entity)
    (entity_channel_assignment_confirmed ?entity - legal_entity)
    (entity_settled ?entity - legal_entity)
    (settlement_authorized ?entity - legal_entity)
    (entity_funding_allocation_confirmed ?entity - legal_entity)
    (settlement_channel_available ?settlement_channel - settlement_channel)
    (entity_assigned_settlement_channel ?entity - legal_entity ?settlement_channel - settlement_channel)
    (transfer_request_available ?transfer_request - transfer_request)
    (entity_assigned_transfer_request ?entity - legal_entity ?transfer_request - transfer_request)
    (funding_account_available ?funding_account - funding_account)
    (entity_assigned_funding_account ?entity - legal_entity ?funding_account - funding_account)
    (offset_instruction_available ?offset_instruction - offset_instruction)
    (source_entity_allocated_offset_instruction ?source_subsidiary - source_subsidiary ?offset_instruction - offset_instruction)
    (destination_entity_allocated_offset_instruction ?destination_subsidiary - destination_subsidiary ?offset_instruction - offset_instruction)
    (source_entity_assigned_cash_account ?source_subsidiary - source_subsidiary ?cash_account_source - cash_account_source)
    (cash_account_source_selected ?cash_account_source - cash_account_source)
    (cash_account_source_marked_for_allocation ?cash_account_source - cash_account_source)
    (source_entity_ready_for_settlement ?source_subsidiary - source_subsidiary)
    (destination_entity_assigned_cash_account ?destination_subsidiary - destination_subsidiary ?cash_account_destination - cash_account_destination)
    (cash_account_destination_selected ?cash_account_destination - cash_account_destination)
    (cash_account_destination_marked_for_allocation ?cash_account_destination - cash_account_destination)
    (destination_entity_ready_for_settlement ?destination_subsidiary - destination_subsidiary)
    (settlement_order_available ?settlement_order - settlement_order)
    (settlement_order_assembled ?settlement_order - settlement_order)
    (settlement_order_assigned_cash_account_source ?settlement_order - settlement_order ?cash_account_source - cash_account_source)
    (settlement_order_assigned_cash_account_destination ?settlement_order - settlement_order ?cash_account_destination - cash_account_destination)
    (settlement_order_prioritized_flag ?settlement_order - settlement_order)
    (settlement_order_fee_attached ?settlement_order - settlement_order)
    (settlement_order_execution_ready ?settlement_order - settlement_order)
    (netting_job_includes_source_entity ?netting_job - netting_job ?source_subsidiary - source_subsidiary)
    (netting_job_includes_destination_entity ?netting_job - netting_job ?destination_subsidiary - destination_subsidiary)
    (netting_job_associated_settlement_order ?netting_job - netting_job ?settlement_order - settlement_order)
    (liquidity_buffer_available ?liquidity_buffer - liquidity_buffer)
    (netting_job_allocated_liquidity_buffer ?netting_job - netting_job ?liquidity_buffer - liquidity_buffer)
    (liquidity_buffer_reserved ?liquidity_buffer - liquidity_buffer)
    (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order)
    (netting_job_compliance_preconditions_met ?netting_job - netting_job)
    (netting_job_fees_attached ?netting_job - netting_job)
    (netting_job_compliance_and_fee_reviewed ?netting_job - netting_job)
    (netting_job_assigned_compliance_approval_confirmed ?netting_job - netting_job)
    (netting_job_fee_preview_generated ?netting_job - netting_job)
    (netting_job_priority_evaluated ?netting_job - netting_job)
    (netting_job_ready_for_confirmation ?netting_job - netting_job)
    (priority_directive_available ?priority_directive - priority_directive)
    (netting_job_assigned_priority_directive ?netting_job - netting_job ?priority_directive - priority_directive)
    (netting_job_priority_locked ?netting_job - netting_job)
    (netting_job_compliance_signalled ?netting_job - netting_job)
    (netting_job_regulatory_flag_confirmed ?netting_job - netting_job)
    (compliance_approval_available ?compliance_approval - compliance_approval)
    (netting_job_assigned_compliance_approval ?netting_job - netting_job ?compliance_approval - compliance_approval)
    (fee_structure_available ?fee_structure - fee_structure)
    (netting_job_assigned_fee_structure ?netting_job - netting_job ?fee_structure - fee_structure)
    (liquidity_limit_available ?liquidity_limit - liquidity_limit)
    (netting_job_assigned_liquidity_limit ?netting_job - netting_job ?liquidity_limit - liquidity_limit)
    (regulatory_flag_available ?regulatory_flag - regulatory_flag)
    (netting_job_assigned_regulatory_flag ?netting_job - netting_job ?regulatory_flag - regulatory_flag)
    (funding_resource_available ?funding_resource - funding_resource)
    (entity_allocated_funding_resource ?entity - legal_entity ?funding_resource - funding_resource)
    (source_entity_marked_for_settlement_assembly ?source_subsidiary - source_subsidiary)
    (destination_entity_marked_for_settlement_assembly ?destination_subsidiary - destination_subsidiary)
    (netting_job_finalized ?netting_job - netting_job)
  )
  (:action register_entity_for_netting
    :parameters (?entity - legal_entity)
    :precondition
      (and
        (not
          (entity_registered_for_netting ?entity)
        )
        (not
          (entity_settled ?entity)
        )
      )
    :effect (entity_registered_for_netting ?entity)
  )
  (:action assign_settlement_channel_to_entity
    :parameters (?entity - legal_entity ?settlement_channel - settlement_channel)
    :precondition
      (and
        (entity_registered_for_netting ?entity)
        (not
          (entity_channel_assignment_confirmed ?entity)
        )
        (settlement_channel_available ?settlement_channel)
      )
    :effect
      (and
        (entity_channel_assignment_confirmed ?entity)
        (entity_assigned_settlement_channel ?entity ?settlement_channel)
        (not
          (settlement_channel_available ?settlement_channel)
        )
      )
  )
  (:action attach_transfer_request_to_entity
    :parameters (?entity - legal_entity ?transfer_request - transfer_request)
    :precondition
      (and
        (entity_registered_for_netting ?entity)
        (entity_channel_assignment_confirmed ?entity)
        (transfer_request_available ?transfer_request)
      )
    :effect
      (and
        (entity_assigned_transfer_request ?entity ?transfer_request)
        (not
          (transfer_request_available ?transfer_request)
        )
      )
  )
  (:action approve_entity_for_processing
    :parameters (?entity - legal_entity ?transfer_request - transfer_request)
    :precondition
      (and
        (entity_registered_for_netting ?entity)
        (entity_channel_assignment_confirmed ?entity)
        (entity_assigned_transfer_request ?entity ?transfer_request)
        (not
          (entity_approved_for_processing ?entity)
        )
      )
    :effect (entity_approved_for_processing ?entity)
  )
  (:action release_transfer_request_from_entity
    :parameters (?entity - legal_entity ?transfer_request - transfer_request)
    :precondition
      (and
        (entity_assigned_transfer_request ?entity ?transfer_request)
      )
    :effect
      (and
        (transfer_request_available ?transfer_request)
        (not
          (entity_assigned_transfer_request ?entity ?transfer_request)
        )
      )
  )
  (:action assign_funding_account_to_entity
    :parameters (?entity - legal_entity ?funding_account - funding_account)
    :precondition
      (and
        (entity_approved_for_processing ?entity)
        (funding_account_available ?funding_account)
      )
    :effect
      (and
        (entity_assigned_funding_account ?entity ?funding_account)
        (not
          (funding_account_available ?funding_account)
        )
      )
  )
  (:action release_funding_account_from_entity
    :parameters (?entity - legal_entity ?funding_account - funding_account)
    :precondition
      (and
        (entity_assigned_funding_account ?entity ?funding_account)
      )
    :effect
      (and
        (funding_account_available ?funding_account)
        (not
          (entity_assigned_funding_account ?entity ?funding_account)
        )
      )
  )
  (:action assign_liquidity_limit_to_netting_job
    :parameters (?netting_job - netting_job ?liquidity_limit - liquidity_limit)
    :precondition
      (and
        (entity_approved_for_processing ?netting_job)
        (liquidity_limit_available ?liquidity_limit)
      )
    :effect
      (and
        (netting_job_assigned_liquidity_limit ?netting_job ?liquidity_limit)
        (not
          (liquidity_limit_available ?liquidity_limit)
        )
      )
  )
  (:action release_liquidity_limit_from_netting_job
    :parameters (?netting_job - netting_job ?liquidity_limit - liquidity_limit)
    :precondition
      (and
        (netting_job_assigned_liquidity_limit ?netting_job ?liquidity_limit)
      )
    :effect
      (and
        (liquidity_limit_available ?liquidity_limit)
        (not
          (netting_job_assigned_liquidity_limit ?netting_job ?liquidity_limit)
        )
      )
  )
  (:action assign_regulatory_flag_to_netting_job
    :parameters (?netting_job - netting_job ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (entity_approved_for_processing ?netting_job)
        (regulatory_flag_available ?regulatory_flag)
      )
    :effect
      (and
        (netting_job_assigned_regulatory_flag ?netting_job ?regulatory_flag)
        (not
          (regulatory_flag_available ?regulatory_flag)
        )
      )
  )
  (:action release_regulatory_flag_from_netting_job
    :parameters (?netting_job - netting_job ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (netting_job_assigned_regulatory_flag ?netting_job ?regulatory_flag)
      )
    :effect
      (and
        (regulatory_flag_available ?regulatory_flag)
        (not
          (netting_job_assigned_regulatory_flag ?netting_job ?regulatory_flag)
        )
      )
  )
  (:action select_source_cash_account_for_matching
    :parameters (?source_subsidiary - source_subsidiary ?cash_account_source - cash_account_source ?transfer_request - transfer_request)
    :precondition
      (and
        (entity_approved_for_processing ?source_subsidiary)
        (entity_assigned_transfer_request ?source_subsidiary ?transfer_request)
        (source_entity_assigned_cash_account ?source_subsidiary ?cash_account_source)
        (not
          (cash_account_source_selected ?cash_account_source)
        )
        (not
          (cash_account_source_marked_for_allocation ?cash_account_source)
        )
      )
    :effect (cash_account_source_selected ?cash_account_source)
  )
  (:action bind_funding_account_to_source_entity
    :parameters (?source_subsidiary - source_subsidiary ?cash_account_source - cash_account_source ?funding_account - funding_account)
    :precondition
      (and
        (entity_approved_for_processing ?source_subsidiary)
        (entity_assigned_funding_account ?source_subsidiary ?funding_account)
        (source_entity_assigned_cash_account ?source_subsidiary ?cash_account_source)
        (cash_account_source_selected ?cash_account_source)
        (not
          (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        )
      )
    :effect
      (and
        (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        (source_entity_ready_for_settlement ?source_subsidiary)
      )
  )
  (:action reserve_offset_instruction_for_source_entity
    :parameters (?source_subsidiary - source_subsidiary ?cash_account_source - cash_account_source ?offset_instruction - offset_instruction)
    :precondition
      (and
        (entity_approved_for_processing ?source_subsidiary)
        (source_entity_assigned_cash_account ?source_subsidiary ?cash_account_source)
        (offset_instruction_available ?offset_instruction)
        (not
          (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        )
      )
    :effect
      (and
        (cash_account_source_marked_for_allocation ?cash_account_source)
        (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        (source_entity_allocated_offset_instruction ?source_subsidiary ?offset_instruction)
        (not
          (offset_instruction_available ?offset_instruction)
        )
      )
  )
  (:action apply_offset_instruction_for_source_entity
    :parameters (?source_subsidiary - source_subsidiary ?cash_account_source - cash_account_source ?transfer_request - transfer_request ?offset_instruction - offset_instruction)
    :precondition
      (and
        (entity_approved_for_processing ?source_subsidiary)
        (entity_assigned_transfer_request ?source_subsidiary ?transfer_request)
        (source_entity_assigned_cash_account ?source_subsidiary ?cash_account_source)
        (cash_account_source_marked_for_allocation ?cash_account_source)
        (source_entity_allocated_offset_instruction ?source_subsidiary ?offset_instruction)
        (not
          (source_entity_ready_for_settlement ?source_subsidiary)
        )
      )
    :effect
      (and
        (cash_account_source_selected ?cash_account_source)
        (source_entity_ready_for_settlement ?source_subsidiary)
        (offset_instruction_available ?offset_instruction)
        (not
          (source_entity_allocated_offset_instruction ?source_subsidiary ?offset_instruction)
        )
      )
  )
  (:action select_destination_cash_account_for_matching
    :parameters (?destination_subsidiary - destination_subsidiary ?cash_account_destination - cash_account_destination ?transfer_request - transfer_request)
    :precondition
      (and
        (entity_approved_for_processing ?destination_subsidiary)
        (entity_assigned_transfer_request ?destination_subsidiary ?transfer_request)
        (destination_entity_assigned_cash_account ?destination_subsidiary ?cash_account_destination)
        (not
          (cash_account_destination_selected ?cash_account_destination)
        )
        (not
          (cash_account_destination_marked_for_allocation ?cash_account_destination)
        )
      )
    :effect (cash_account_destination_selected ?cash_account_destination)
  )
  (:action bind_funding_account_to_destination_entity
    :parameters (?destination_subsidiary - destination_subsidiary ?cash_account_destination - cash_account_destination ?funding_account - funding_account)
    :precondition
      (and
        (entity_approved_for_processing ?destination_subsidiary)
        (entity_assigned_funding_account ?destination_subsidiary ?funding_account)
        (destination_entity_assigned_cash_account ?destination_subsidiary ?cash_account_destination)
        (cash_account_destination_selected ?cash_account_destination)
        (not
          (destination_entity_marked_for_settlement_assembly ?destination_subsidiary)
        )
      )
    :effect
      (and
        (destination_entity_marked_for_settlement_assembly ?destination_subsidiary)
        (destination_entity_ready_for_settlement ?destination_subsidiary)
      )
  )
  (:action reserve_offset_instruction_for_destination_entity
    :parameters (?destination_subsidiary - destination_subsidiary ?cash_account_destination - cash_account_destination ?offset_instruction - offset_instruction)
    :precondition
      (and
        (entity_approved_for_processing ?destination_subsidiary)
        (destination_entity_assigned_cash_account ?destination_subsidiary ?cash_account_destination)
        (offset_instruction_available ?offset_instruction)
        (not
          (destination_entity_marked_for_settlement_assembly ?destination_subsidiary)
        )
      )
    :effect
      (and
        (cash_account_destination_marked_for_allocation ?cash_account_destination)
        (destination_entity_marked_for_settlement_assembly ?destination_subsidiary)
        (destination_entity_allocated_offset_instruction ?destination_subsidiary ?offset_instruction)
        (not
          (offset_instruction_available ?offset_instruction)
        )
      )
  )
  (:action apply_offset_instruction_for_destination_entity
    :parameters (?destination_subsidiary - destination_subsidiary ?cash_account_destination - cash_account_destination ?transfer_request - transfer_request ?offset_instruction - offset_instruction)
    :precondition
      (and
        (entity_approved_for_processing ?destination_subsidiary)
        (entity_assigned_transfer_request ?destination_subsidiary ?transfer_request)
        (destination_entity_assigned_cash_account ?destination_subsidiary ?cash_account_destination)
        (cash_account_destination_marked_for_allocation ?cash_account_destination)
        (destination_entity_allocated_offset_instruction ?destination_subsidiary ?offset_instruction)
        (not
          (destination_entity_ready_for_settlement ?destination_subsidiary)
        )
      )
    :effect
      (and
        (cash_account_destination_selected ?cash_account_destination)
        (destination_entity_ready_for_settlement ?destination_subsidiary)
        (offset_instruction_available ?offset_instruction)
        (not
          (destination_entity_allocated_offset_instruction ?destination_subsidiary ?offset_instruction)
        )
      )
  )
  (:action assemble_settlement_order_ready_source_selected_dest_selected
    :parameters (?source_subsidiary - source_subsidiary ?destination_subsidiary - destination_subsidiary ?cash_account_source - cash_account_source ?cash_account_destination - cash_account_destination ?settlement_order - settlement_order)
    :precondition
      (and
        (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        (destination_entity_marked_for_settlement_assembly ?destination_subsidiary)
        (source_entity_assigned_cash_account ?source_subsidiary ?cash_account_source)
        (destination_entity_assigned_cash_account ?destination_subsidiary ?cash_account_destination)
        (cash_account_source_selected ?cash_account_source)
        (cash_account_destination_selected ?cash_account_destination)
        (source_entity_ready_for_settlement ?source_subsidiary)
        (destination_entity_ready_for_settlement ?destination_subsidiary)
        (settlement_order_available ?settlement_order)
      )
    :effect
      (and
        (settlement_order_assembled ?settlement_order)
        (settlement_order_assigned_cash_account_source ?settlement_order ?cash_account_source)
        (settlement_order_assigned_cash_account_destination ?settlement_order ?cash_account_destination)
        (not
          (settlement_order_available ?settlement_order)
        )
      )
  )
  (:action assemble_settlement_order_ready_source_marked_dest_selected
    :parameters (?source_subsidiary - source_subsidiary ?destination_subsidiary - destination_subsidiary ?cash_account_source - cash_account_source ?cash_account_destination - cash_account_destination ?settlement_order - settlement_order)
    :precondition
      (and
        (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        (destination_entity_marked_for_settlement_assembly ?destination_subsidiary)
        (source_entity_assigned_cash_account ?source_subsidiary ?cash_account_source)
        (destination_entity_assigned_cash_account ?destination_subsidiary ?cash_account_destination)
        (cash_account_source_marked_for_allocation ?cash_account_source)
        (cash_account_destination_selected ?cash_account_destination)
        (not
          (source_entity_ready_for_settlement ?source_subsidiary)
        )
        (destination_entity_ready_for_settlement ?destination_subsidiary)
        (settlement_order_available ?settlement_order)
      )
    :effect
      (and
        (settlement_order_assembled ?settlement_order)
        (settlement_order_assigned_cash_account_source ?settlement_order ?cash_account_source)
        (settlement_order_assigned_cash_account_destination ?settlement_order ?cash_account_destination)
        (settlement_order_prioritized_flag ?settlement_order)
        (not
          (settlement_order_available ?settlement_order)
        )
      )
  )
  (:action assemble_settlement_order_ready_source_selected_dest_marked
    :parameters (?source_subsidiary - source_subsidiary ?destination_subsidiary - destination_subsidiary ?cash_account_source - cash_account_source ?cash_account_destination - cash_account_destination ?settlement_order - settlement_order)
    :precondition
      (and
        (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        (destination_entity_marked_for_settlement_assembly ?destination_subsidiary)
        (source_entity_assigned_cash_account ?source_subsidiary ?cash_account_source)
        (destination_entity_assigned_cash_account ?destination_subsidiary ?cash_account_destination)
        (cash_account_source_selected ?cash_account_source)
        (cash_account_destination_marked_for_allocation ?cash_account_destination)
        (source_entity_ready_for_settlement ?source_subsidiary)
        (not
          (destination_entity_ready_for_settlement ?destination_subsidiary)
        )
        (settlement_order_available ?settlement_order)
      )
    :effect
      (and
        (settlement_order_assembled ?settlement_order)
        (settlement_order_assigned_cash_account_source ?settlement_order ?cash_account_source)
        (settlement_order_assigned_cash_account_destination ?settlement_order ?cash_account_destination)
        (settlement_order_fee_attached ?settlement_order)
        (not
          (settlement_order_available ?settlement_order)
        )
      )
  )
  (:action assemble_settlement_order_ready_source_marked_dest_marked
    :parameters (?source_subsidiary - source_subsidiary ?destination_subsidiary - destination_subsidiary ?cash_account_source - cash_account_source ?cash_account_destination - cash_account_destination ?settlement_order - settlement_order)
    :precondition
      (and
        (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        (destination_entity_marked_for_settlement_assembly ?destination_subsidiary)
        (source_entity_assigned_cash_account ?source_subsidiary ?cash_account_source)
        (destination_entity_assigned_cash_account ?destination_subsidiary ?cash_account_destination)
        (cash_account_source_marked_for_allocation ?cash_account_source)
        (cash_account_destination_marked_for_allocation ?cash_account_destination)
        (not
          (source_entity_ready_for_settlement ?source_subsidiary)
        )
        (not
          (destination_entity_ready_for_settlement ?destination_subsidiary)
        )
        (settlement_order_available ?settlement_order)
      )
    :effect
      (and
        (settlement_order_assembled ?settlement_order)
        (settlement_order_assigned_cash_account_source ?settlement_order ?cash_account_source)
        (settlement_order_assigned_cash_account_destination ?settlement_order ?cash_account_destination)
        (settlement_order_prioritized_flag ?settlement_order)
        (settlement_order_fee_attached ?settlement_order)
        (not
          (settlement_order_available ?settlement_order)
        )
      )
  )
  (:action mark_settlement_order_execution_ready
    :parameters (?settlement_order - settlement_order ?source_subsidiary - source_subsidiary ?transfer_request - transfer_request)
    :precondition
      (and
        (settlement_order_assembled ?settlement_order)
        (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        (entity_assigned_transfer_request ?source_subsidiary ?transfer_request)
        (not
          (settlement_order_execution_ready ?settlement_order)
        )
      )
    :effect (settlement_order_execution_ready ?settlement_order)
  )
  (:action reserve_liquidity_buffer_for_settlement_order
    :parameters (?netting_job - netting_job ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order)
    :precondition
      (and
        (entity_approved_for_processing ?netting_job)
        (netting_job_associated_settlement_order ?netting_job ?settlement_order)
        (netting_job_allocated_liquidity_buffer ?netting_job ?liquidity_buffer)
        (liquidity_buffer_available ?liquidity_buffer)
        (settlement_order_assembled ?settlement_order)
        (settlement_order_execution_ready ?settlement_order)
        (not
          (liquidity_buffer_reserved ?liquidity_buffer)
        )
      )
    :effect
      (and
        (liquidity_buffer_reserved ?liquidity_buffer)
        (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer ?settlement_order)
        (not
          (liquidity_buffer_available ?liquidity_buffer)
        )
      )
  )
  (:action confirm_liquidity_buffer_allocation_for_order
    :parameters (?netting_job - netting_job ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order ?transfer_request - transfer_request)
    :precondition
      (and
        (entity_approved_for_processing ?netting_job)
        (netting_job_allocated_liquidity_buffer ?netting_job ?liquidity_buffer)
        (liquidity_buffer_reserved ?liquidity_buffer)
        (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer ?settlement_order)
        (entity_assigned_transfer_request ?netting_job ?transfer_request)
        (not
          (settlement_order_prioritized_flag ?settlement_order)
        )
        (not
          (netting_job_compliance_preconditions_met ?netting_job)
        )
      )
    :effect (netting_job_compliance_preconditions_met ?netting_job)
  )
  (:action attach_compliance_approval_to_netting_job
    :parameters (?netting_job - netting_job ?compliance_approval - compliance_approval)
    :precondition
      (and
        (entity_approved_for_processing ?netting_job)
        (compliance_approval_available ?compliance_approval)
        (not
          (netting_job_assigned_compliance_approval_confirmed ?netting_job)
        )
      )
    :effect
      (and
        (netting_job_assigned_compliance_approval_confirmed ?netting_job)
        (netting_job_assigned_compliance_approval ?netting_job ?compliance_approval)
        (not
          (compliance_approval_available ?compliance_approval)
        )
      )
  )
  (:action process_compliance_and_fee_preview_for_netting_job
    :parameters (?netting_job - netting_job ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order ?transfer_request - transfer_request ?compliance_approval - compliance_approval)
    :precondition
      (and
        (entity_approved_for_processing ?netting_job)
        (netting_job_allocated_liquidity_buffer ?netting_job ?liquidity_buffer)
        (liquidity_buffer_reserved ?liquidity_buffer)
        (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer ?settlement_order)
        (entity_assigned_transfer_request ?netting_job ?transfer_request)
        (settlement_order_prioritized_flag ?settlement_order)
        (netting_job_assigned_compliance_approval_confirmed ?netting_job)
        (netting_job_assigned_compliance_approval ?netting_job ?compliance_approval)
        (not
          (netting_job_compliance_preconditions_met ?netting_job)
        )
      )
    :effect
      (and
        (netting_job_compliance_preconditions_met ?netting_job)
        (netting_job_fee_preview_generated ?netting_job)
      )
  )
  (:action apply_fee_and_prepare_job_for_execution_variant1
    :parameters (?netting_job - netting_job ?liquidity_limit - liquidity_limit ?funding_account - funding_account ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order)
    :precondition
      (and
        (netting_job_compliance_preconditions_met ?netting_job)
        (netting_job_assigned_liquidity_limit ?netting_job ?liquidity_limit)
        (entity_assigned_funding_account ?netting_job ?funding_account)
        (netting_job_allocated_liquidity_buffer ?netting_job ?liquidity_buffer)
        (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer ?settlement_order)
        (not
          (settlement_order_fee_attached ?settlement_order)
        )
        (not
          (netting_job_fees_attached ?netting_job)
        )
      )
    :effect (netting_job_fees_attached ?netting_job)
  )
  (:action apply_fee_and_prepare_job_for_execution_variant2
    :parameters (?netting_job - netting_job ?liquidity_limit - liquidity_limit ?funding_account - funding_account ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order)
    :precondition
      (and
        (netting_job_compliance_preconditions_met ?netting_job)
        (netting_job_assigned_liquidity_limit ?netting_job ?liquidity_limit)
        (entity_assigned_funding_account ?netting_job ?funding_account)
        (netting_job_allocated_liquidity_buffer ?netting_job ?liquidity_buffer)
        (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer ?settlement_order)
        (settlement_order_fee_attached ?settlement_order)
        (not
          (netting_job_fees_attached ?netting_job)
        )
      )
    :effect (netting_job_fees_attached ?netting_job)
  )
  (:action init_regulatory_processing_for_netting_job
    :parameters (?netting_job - netting_job ?regulatory_flag - regulatory_flag ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order)
    :precondition
      (and
        (netting_job_fees_attached ?netting_job)
        (netting_job_assigned_regulatory_flag ?netting_job ?regulatory_flag)
        (netting_job_allocated_liquidity_buffer ?netting_job ?liquidity_buffer)
        (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer ?settlement_order)
        (not
          (settlement_order_prioritized_flag ?settlement_order)
        )
        (not
          (settlement_order_fee_attached ?settlement_order)
        )
        (not
          (netting_job_compliance_and_fee_reviewed ?netting_job)
        )
      )
    :effect (netting_job_compliance_and_fee_reviewed ?netting_job)
  )
  (:action advance_regulatory_processing_and_set_priority
    :parameters (?netting_job - netting_job ?regulatory_flag - regulatory_flag ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order)
    :precondition
      (and
        (netting_job_fees_attached ?netting_job)
        (netting_job_assigned_regulatory_flag ?netting_job ?regulatory_flag)
        (netting_job_allocated_liquidity_buffer ?netting_job ?liquidity_buffer)
        (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer ?settlement_order)
        (settlement_order_prioritized_flag ?settlement_order)
        (not
          (settlement_order_fee_attached ?settlement_order)
        )
        (not
          (netting_job_compliance_and_fee_reviewed ?netting_job)
        )
      )
    :effect
      (and
        (netting_job_compliance_and_fee_reviewed ?netting_job)
        (netting_job_priority_evaluated ?netting_job)
      )
  )
  (:action advance_regulatory_processing_variant2
    :parameters (?netting_job - netting_job ?regulatory_flag - regulatory_flag ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order)
    :precondition
      (and
        (netting_job_fees_attached ?netting_job)
        (netting_job_assigned_regulatory_flag ?netting_job ?regulatory_flag)
        (netting_job_allocated_liquidity_buffer ?netting_job ?liquidity_buffer)
        (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer ?settlement_order)
        (not
          (settlement_order_prioritized_flag ?settlement_order)
        )
        (settlement_order_fee_attached ?settlement_order)
        (not
          (netting_job_compliance_and_fee_reviewed ?netting_job)
        )
      )
    :effect
      (and
        (netting_job_compliance_and_fee_reviewed ?netting_job)
        (netting_job_priority_evaluated ?netting_job)
      )
  )
  (:action advance_regulatory_processing_variant3
    :parameters (?netting_job - netting_job ?regulatory_flag - regulatory_flag ?liquidity_buffer - liquidity_buffer ?settlement_order - settlement_order)
    :precondition
      (and
        (netting_job_fees_attached ?netting_job)
        (netting_job_assigned_regulatory_flag ?netting_job ?regulatory_flag)
        (netting_job_allocated_liquidity_buffer ?netting_job ?liquidity_buffer)
        (liquidity_buffer_assigned_to_settlement_order ?liquidity_buffer ?settlement_order)
        (settlement_order_prioritized_flag ?settlement_order)
        (settlement_order_fee_attached ?settlement_order)
        (not
          (netting_job_compliance_and_fee_reviewed ?netting_job)
        )
      )
    :effect
      (and
        (netting_job_compliance_and_fee_reviewed ?netting_job)
        (netting_job_priority_evaluated ?netting_job)
      )
  )
  (:action finalize_compliance_checks_and_enable_settlement
    :parameters (?netting_job - netting_job)
    :precondition
      (and
        (netting_job_compliance_and_fee_reviewed ?netting_job)
        (not
          (netting_job_priority_evaluated ?netting_job)
        )
        (not
          (netting_job_finalized ?netting_job)
        )
      )
    :effect
      (and
        (netting_job_finalized ?netting_job)
        (settlement_authorized ?netting_job)
      )
  )
  (:action attach_fee_structure_to_job
    :parameters (?netting_job - netting_job ?fee_structure - fee_structure)
    :precondition
      (and
        (netting_job_compliance_and_fee_reviewed ?netting_job)
        (netting_job_priority_evaluated ?netting_job)
        (fee_structure_available ?fee_structure)
      )
    :effect
      (and
        (netting_job_assigned_fee_structure ?netting_job ?fee_structure)
        (not
          (fee_structure_available ?fee_structure)
        )
      )
  )
  (:action endorse_job_for_confirmation
    :parameters (?netting_job - netting_job ?source_subsidiary - source_subsidiary ?destination_subsidiary - destination_subsidiary ?transfer_request - transfer_request ?fee_structure - fee_structure)
    :precondition
      (and
        (netting_job_compliance_and_fee_reviewed ?netting_job)
        (netting_job_priority_evaluated ?netting_job)
        (netting_job_assigned_fee_structure ?netting_job ?fee_structure)
        (netting_job_includes_source_entity ?netting_job ?source_subsidiary)
        (netting_job_includes_destination_entity ?netting_job ?destination_subsidiary)
        (source_entity_ready_for_settlement ?source_subsidiary)
        (destination_entity_ready_for_settlement ?destination_subsidiary)
        (entity_assigned_transfer_request ?netting_job ?transfer_request)
        (not
          (netting_job_ready_for_confirmation ?netting_job)
        )
      )
    :effect (netting_job_ready_for_confirmation ?netting_job)
  )
  (:action finalize_job_confirmation_and_authorize_settlement
    :parameters (?netting_job - netting_job)
    :precondition
      (and
        (netting_job_compliance_and_fee_reviewed ?netting_job)
        (netting_job_ready_for_confirmation ?netting_job)
        (not
          (netting_job_finalized ?netting_job)
        )
      )
    :effect
      (and
        (netting_job_finalized ?netting_job)
        (settlement_authorized ?netting_job)
      )
  )
  (:action lock_priority_directive_on_job
    :parameters (?netting_job - netting_job ?priority_directive - priority_directive ?transfer_request - transfer_request)
    :precondition
      (and
        (entity_approved_for_processing ?netting_job)
        (entity_assigned_transfer_request ?netting_job ?transfer_request)
        (priority_directive_available ?priority_directive)
        (netting_job_assigned_priority_directive ?netting_job ?priority_directive)
        (not
          (netting_job_priority_locked ?netting_job)
        )
      )
    :effect
      (and
        (netting_job_priority_locked ?netting_job)
        (not
          (priority_directive_available ?priority_directive)
        )
      )
  )
  (:action signal_job_compliance_step
    :parameters (?netting_job - netting_job ?funding_account - funding_account)
    :precondition
      (and
        (netting_job_priority_locked ?netting_job)
        (entity_assigned_funding_account ?netting_job ?funding_account)
        (not
          (netting_job_compliance_signalled ?netting_job)
        )
      )
    :effect (netting_job_compliance_signalled ?netting_job)
  )
  (:action assign_regulatory_flag_after_compliance
    :parameters (?netting_job - netting_job ?regulatory_flag - regulatory_flag)
    :precondition
      (and
        (netting_job_compliance_signalled ?netting_job)
        (netting_job_assigned_regulatory_flag ?netting_job ?regulatory_flag)
        (not
          (netting_job_regulatory_flag_confirmed ?netting_job)
        )
      )
    :effect (netting_job_regulatory_flag_confirmed ?netting_job)
  )
  (:action finalize_compliance_and_authorize_job
    :parameters (?netting_job - netting_job)
    :precondition
      (and
        (netting_job_regulatory_flag_confirmed ?netting_job)
        (not
          (netting_job_finalized ?netting_job)
        )
      )
    :effect
      (and
        (netting_job_finalized ?netting_job)
        (settlement_authorized ?netting_job)
      )
  )
  (:action authorize_settlement_execution_for_source_subsidiary
    :parameters (?source_subsidiary - source_subsidiary ?settlement_order - settlement_order)
    :precondition
      (and
        (source_entity_marked_for_settlement_assembly ?source_subsidiary)
        (source_entity_ready_for_settlement ?source_subsidiary)
        (settlement_order_assembled ?settlement_order)
        (settlement_order_execution_ready ?settlement_order)
        (not
          (settlement_authorized ?source_subsidiary)
        )
      )
    :effect (settlement_authorized ?source_subsidiary)
  )
  (:action authorize_settlement_execution_for_destination_subsidiary
    :parameters (?destination_subsidiary - destination_subsidiary ?settlement_order - settlement_order)
    :precondition
      (and
        (destination_entity_marked_for_settlement_assembly ?destination_subsidiary)
        (destination_entity_ready_for_settlement ?destination_subsidiary)
        (settlement_order_assembled ?settlement_order)
        (settlement_order_execution_ready ?settlement_order)
        (not
          (settlement_authorized ?destination_subsidiary)
        )
      )
    :effect (settlement_authorized ?destination_subsidiary)
  )
  (:action allocate_funding_resource_to_entity
    :parameters (?entity - legal_entity ?funding_resource - funding_resource ?transfer_request - transfer_request)
    :precondition
      (and
        (settlement_authorized ?entity)
        (entity_assigned_transfer_request ?entity ?transfer_request)
        (funding_resource_available ?funding_resource)
        (not
          (entity_funding_allocation_confirmed ?entity)
        )
      )
    :effect
      (and
        (entity_funding_allocation_confirmed ?entity)
        (entity_allocated_funding_resource ?entity ?funding_resource)
        (not
          (funding_resource_available ?funding_resource)
        )
      )
  )
  (:action finalize_settlement_for_source_subsidiary_and_release_resources
    :parameters (?source_subsidiary - source_subsidiary ?settlement_channel - settlement_channel ?funding_resource - funding_resource)
    :precondition
      (and
        (entity_funding_allocation_confirmed ?source_subsidiary)
        (entity_assigned_settlement_channel ?source_subsidiary ?settlement_channel)
        (entity_allocated_funding_resource ?source_subsidiary ?funding_resource)
        (not
          (entity_settled ?source_subsidiary)
        )
      )
    :effect
      (and
        (entity_settled ?source_subsidiary)
        (settlement_channel_available ?settlement_channel)
        (funding_resource_available ?funding_resource)
      )
  )
  (:action finalize_settlement_for_destination_subsidiary_and_release_resources
    :parameters (?destination_subsidiary - destination_subsidiary ?settlement_channel - settlement_channel ?funding_resource - funding_resource)
    :precondition
      (and
        (entity_funding_allocation_confirmed ?destination_subsidiary)
        (entity_assigned_settlement_channel ?destination_subsidiary ?settlement_channel)
        (entity_allocated_funding_resource ?destination_subsidiary ?funding_resource)
        (not
          (entity_settled ?destination_subsidiary)
        )
      )
    :effect
      (and
        (entity_settled ?destination_subsidiary)
        (settlement_channel_available ?settlement_channel)
        (funding_resource_available ?funding_resource)
      )
  )
  (:action finalize_settlement_for_netting_job_and_release_resources
    :parameters (?netting_job - netting_job ?settlement_channel - settlement_channel ?funding_resource - funding_resource)
    :precondition
      (and
        (entity_funding_allocation_confirmed ?netting_job)
        (entity_assigned_settlement_channel ?netting_job ?settlement_channel)
        (entity_allocated_funding_resource ?netting_job ?funding_resource)
        (not
          (entity_settled ?netting_job)
        )
      )
    :effect
      (and
        (entity_settled ?netting_job)
        (settlement_channel_available ?settlement_channel)
        (funding_resource_available ?funding_resource)
      )
  )
)

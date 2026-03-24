(define (domain finance_treasury_liquidity_stress_response)
  (:requirements :strips :typing :negative-preconditions)
  (:types treasury_resource_base - object treasury_instrument_base - object resource_base - object entity_root - object legal_entity - entity_root funding_source - treasury_resource_base cash_flow_need - treasury_resource_base treasury_controller - treasury_resource_base contingency_credit_line - treasury_resource_base operational_resource - treasury_resource_base stress_scenario - treasury_resource_base funding_strategy - treasury_resource_base regulatory_exception - treasury_resource_base liquidity_measure - treasury_instrument_base liquid_asset - treasury_instrument_base delegated_authority - treasury_instrument_base internal_funding_channel - resource_base external_funding_channel - resource_base funding_allocation - resource_base entity_subgroup_a - legal_entity entity_subgroup_b - legal_entity operating_unit - entity_subgroup_a trading_unit - entity_subgroup_a treasury_desk - entity_subgroup_b)
  (:predicates
    (entity_exposure_identified ?legal_entity - legal_entity)
    (entity_triaged ?legal_entity - legal_entity)
    (entity_assigned_funding_source_flag ?legal_entity - legal_entity)
    (entity_liquidity_protected ?legal_entity - legal_entity)
    (funding_permission_granted ?legal_entity - legal_entity)
    (entity_funding_authorized ?legal_entity - legal_entity)
    (funding_source_available ?funding_source - funding_source)
    (entity_assigned_funding_source ?legal_entity - legal_entity ?funding_source - funding_source)
    (cash_flow_need_unassigned ?cash_flow_need - cash_flow_need)
    (entity_assigned_cash_flow_need ?legal_entity - legal_entity ?cash_flow_need - cash_flow_need)
    (treasury_controller_available ?treasury_controller - treasury_controller)
    (entity_assigned_treasury_controller ?legal_entity - legal_entity ?treasury_controller - treasury_controller)
    (liquidity_measure_available ?liquidity_measure - liquidity_measure)
    (operating_unit_allocated_measure ?operating_unit - operating_unit ?liquidity_measure - liquidity_measure)
    (trading_unit_allocated_measure ?trading_unit - trading_unit ?liquidity_measure - liquidity_measure)
    (operating_unit_internal_channel ?operating_unit - operating_unit ?internal_funding_channel - internal_funding_channel)
    (internal_channel_ready ?internal_funding_channel - internal_funding_channel)
    (internal_channel_measure_attached ?internal_funding_channel - internal_funding_channel)
    (operating_unit_channel_validated ?operating_unit - operating_unit)
    (trading_unit_external_channel ?trading_unit - trading_unit ?external_funding_channel - external_funding_channel)
    (external_channel_ready ?external_funding_channel - external_funding_channel)
    (external_channel_measure_attached ?external_funding_channel - external_funding_channel)
    (trading_unit_channel_validated ?trading_unit - trading_unit)
    (funding_allocation_unassigned ?funding_allocation - funding_allocation)
    (funding_allocation_reserved ?funding_allocation - funding_allocation)
    (funding_allocation_internal_channel ?funding_allocation - funding_allocation ?internal_funding_channel - internal_funding_channel)
    (funding_allocation_external_channel ?funding_allocation - funding_allocation ?external_funding_channel - external_funding_channel)
    (funding_allocation_internal_measure_flag ?funding_allocation - funding_allocation)
    (funding_allocation_external_measure_flag ?funding_allocation - funding_allocation)
    (funding_allocation_assets_mobilized ?funding_allocation - funding_allocation)
    (treasury_desk_manages_operating_unit ?treasury_desk - treasury_desk ?operating_unit - operating_unit)
    (treasury_desk_manages_trading_unit ?treasury_desk - treasury_desk ?trading_unit - trading_unit)
    (treasury_desk_links_funding_allocation ?treasury_desk - treasury_desk ?funding_allocation - funding_allocation)
    (liquid_asset_available ?liquid_asset - liquid_asset)
    (treasury_desk_holds_liquid_asset ?treasury_desk - treasury_desk ?liquid_asset - liquid_asset)
    (liquid_asset_reserved ?liquid_asset - liquid_asset)
    (liquid_asset_allocated_to_funding_allocation ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation)
    (treasury_desk_strategy_binding_flag ?treasury_desk - treasury_desk)
    (treasury_desk_prepared_for_execution ?treasury_desk - treasury_desk)
    (treasury_desk_execution_ready ?treasury_desk - treasury_desk)
    (treasury_desk_has_contingency_line ?treasury_desk - treasury_desk)
    (treasury_desk_authority_validated ?treasury_desk - treasury_desk)
    (treasury_desk_governance_confirmed ?treasury_desk - treasury_desk)
    (treasury_desk_checks_passed ?treasury_desk - treasury_desk)
    (delegated_authority_available ?delegated_authority - delegated_authority)
    (treasury_desk_has_delegated_authority ?treasury_desk - treasury_desk ?delegated_authority - delegated_authority)
    (treasury_desk_delegation_applied ?treasury_desk - treasury_desk)
    (treasury_desk_delegation_authorized ?treasury_desk - treasury_desk)
    (treasury_desk_authorization_finalized ?treasury_desk - treasury_desk)
    (contingency_credit_line_available ?contingency_credit_line - contingency_credit_line)
    (treasury_desk_allocated_contingency_line ?treasury_desk - treasury_desk ?contingency_credit_line - contingency_credit_line)
    (operational_resource_available ?operational_resource - operational_resource)
    (treasury_desk_allocates_operational_resource ?treasury_desk - treasury_desk ?operational_resource - operational_resource)
    (funding_strategy_available ?funding_strategy - funding_strategy)
    (treasury_desk_bound_funding_strategy ?treasury_desk - treasury_desk ?funding_strategy - funding_strategy)
    (regulatory_exception_available ?regulatory_exception - regulatory_exception)
    (treasury_desk_bound_regulatory_exception ?treasury_desk - treasury_desk ?regulatory_exception - regulatory_exception)
    (stress_scenario_available ?stress_scenario - stress_scenario)
    (entity_bound_stress_scenario ?legal_entity - legal_entity ?stress_scenario - stress_scenario)
    (operating_unit_ready_for_allocation ?operating_unit - operating_unit)
    (trading_unit_ready_for_allocation ?trading_unit - trading_unit)
    (treasury_desk_execution_confirmed ?treasury_desk - treasury_desk)
  )
  (:action register_entity_exposure
    :parameters (?legal_entity - legal_entity)
    :precondition
      (and
        (not
          (entity_exposure_identified ?legal_entity)
        )
        (not
          (entity_liquidity_protected ?legal_entity)
        )
      )
    :effect (entity_exposure_identified ?legal_entity)
  )
  (:action assign_funding_source_to_entity
    :parameters (?legal_entity - legal_entity ?funding_source - funding_source)
    :precondition
      (and
        (entity_exposure_identified ?legal_entity)
        (not
          (entity_assigned_funding_source_flag ?legal_entity)
        )
        (funding_source_available ?funding_source)
      )
    :effect
      (and
        (entity_assigned_funding_source_flag ?legal_entity)
        (entity_assigned_funding_source ?legal_entity ?funding_source)
        (not
          (funding_source_available ?funding_source)
        )
      )
  )
  (:action assign_cash_flow_need_to_entity
    :parameters (?legal_entity - legal_entity ?cash_flow_need - cash_flow_need)
    :precondition
      (and
        (entity_exposure_identified ?legal_entity)
        (entity_assigned_funding_source_flag ?legal_entity)
        (cash_flow_need_unassigned ?cash_flow_need)
      )
    :effect
      (and
        (entity_assigned_cash_flow_need ?legal_entity ?cash_flow_need)
        (not
          (cash_flow_need_unassigned ?cash_flow_need)
        )
      )
  )
  (:action triage_entity_for_funding
    :parameters (?legal_entity - legal_entity ?cash_flow_need - cash_flow_need)
    :precondition
      (and
        (entity_exposure_identified ?legal_entity)
        (entity_assigned_funding_source_flag ?legal_entity)
        (entity_assigned_cash_flow_need ?legal_entity ?cash_flow_need)
        (not
          (entity_triaged ?legal_entity)
        )
      )
    :effect (entity_triaged ?legal_entity)
  )
  (:action release_cash_flow_need_assignment
    :parameters (?legal_entity - legal_entity ?cash_flow_need - cash_flow_need)
    :precondition
      (and
        (entity_assigned_cash_flow_need ?legal_entity ?cash_flow_need)
      )
    :effect
      (and
        (cash_flow_need_unassigned ?cash_flow_need)
        (not
          (entity_assigned_cash_flow_need ?legal_entity ?cash_flow_need)
        )
      )
  )
  (:action assign_treasury_controller_to_entity
    :parameters (?legal_entity - legal_entity ?treasury_controller - treasury_controller)
    :precondition
      (and
        (entity_triaged ?legal_entity)
        (treasury_controller_available ?treasury_controller)
      )
    :effect
      (and
        (entity_assigned_treasury_controller ?legal_entity ?treasury_controller)
        (not
          (treasury_controller_available ?treasury_controller)
        )
      )
  )
  (:action unassign_treasury_controller_from_entity
    :parameters (?legal_entity - legal_entity ?treasury_controller - treasury_controller)
    :precondition
      (and
        (entity_assigned_treasury_controller ?legal_entity ?treasury_controller)
      )
    :effect
      (and
        (treasury_controller_available ?treasury_controller)
        (not
          (entity_assigned_treasury_controller ?legal_entity ?treasury_controller)
        )
      )
  )
  (:action bind_funding_strategy_to_treasury_desk
    :parameters (?treasury_desk - treasury_desk ?funding_strategy - funding_strategy)
    :precondition
      (and
        (entity_triaged ?treasury_desk)
        (funding_strategy_available ?funding_strategy)
      )
    :effect
      (and
        (treasury_desk_bound_funding_strategy ?treasury_desk ?funding_strategy)
        (not
          (funding_strategy_available ?funding_strategy)
        )
      )
  )
  (:action unbind_funding_strategy_from_treasury_desk
    :parameters (?treasury_desk - treasury_desk ?funding_strategy - funding_strategy)
    :precondition
      (and
        (treasury_desk_bound_funding_strategy ?treasury_desk ?funding_strategy)
      )
    :effect
      (and
        (funding_strategy_available ?funding_strategy)
        (not
          (treasury_desk_bound_funding_strategy ?treasury_desk ?funding_strategy)
        )
      )
  )
  (:action bind_regulatory_exception_to_treasury_desk
    :parameters (?treasury_desk - treasury_desk ?regulatory_exception - regulatory_exception)
    :precondition
      (and
        (entity_triaged ?treasury_desk)
        (regulatory_exception_available ?regulatory_exception)
      )
    :effect
      (and
        (treasury_desk_bound_regulatory_exception ?treasury_desk ?regulatory_exception)
        (not
          (regulatory_exception_available ?regulatory_exception)
        )
      )
  )
  (:action unbind_regulatory_exception_from_treasury_desk
    :parameters (?treasury_desk - treasury_desk ?regulatory_exception - regulatory_exception)
    :precondition
      (and
        (treasury_desk_bound_regulatory_exception ?treasury_desk ?regulatory_exception)
      )
    :effect
      (and
        (regulatory_exception_available ?regulatory_exception)
        (not
          (treasury_desk_bound_regulatory_exception ?treasury_desk ?regulatory_exception)
        )
      )
  )
  (:action activate_internal_funding_channel_for_operating_unit
    :parameters (?operating_unit - operating_unit ?internal_funding_channel - internal_funding_channel ?cash_flow_need - cash_flow_need)
    :precondition
      (and
        (entity_triaged ?operating_unit)
        (entity_assigned_cash_flow_need ?operating_unit ?cash_flow_need)
        (operating_unit_internal_channel ?operating_unit ?internal_funding_channel)
        (not
          (internal_channel_ready ?internal_funding_channel)
        )
        (not
          (internal_channel_measure_attached ?internal_funding_channel)
        )
      )
    :effect (internal_channel_ready ?internal_funding_channel)
  )
  (:action confirm_internal_channel_for_operating_unit
    :parameters (?operating_unit - operating_unit ?internal_funding_channel - internal_funding_channel ?treasury_controller - treasury_controller)
    :precondition
      (and
        (entity_triaged ?operating_unit)
        (entity_assigned_treasury_controller ?operating_unit ?treasury_controller)
        (operating_unit_internal_channel ?operating_unit ?internal_funding_channel)
        (internal_channel_ready ?internal_funding_channel)
        (not
          (operating_unit_ready_for_allocation ?operating_unit)
        )
      )
    :effect
      (and
        (operating_unit_ready_for_allocation ?operating_unit)
        (operating_unit_channel_validated ?operating_unit)
      )
  )
  (:action attach_liquidity_measure_to_operating_unit_channel
    :parameters (?operating_unit - operating_unit ?internal_funding_channel - internal_funding_channel ?liquidity_measure - liquidity_measure)
    :precondition
      (and
        (entity_triaged ?operating_unit)
        (operating_unit_internal_channel ?operating_unit ?internal_funding_channel)
        (liquidity_measure_available ?liquidity_measure)
        (not
          (operating_unit_ready_for_allocation ?operating_unit)
        )
      )
    :effect
      (and
        (internal_channel_measure_attached ?internal_funding_channel)
        (operating_unit_ready_for_allocation ?operating_unit)
        (operating_unit_allocated_measure ?operating_unit ?liquidity_measure)
        (not
          (liquidity_measure_available ?liquidity_measure)
        )
      )
  )
  (:action finalize_internal_channel_activation_for_operating_unit
    :parameters (?operating_unit - operating_unit ?internal_funding_channel - internal_funding_channel ?cash_flow_need - cash_flow_need ?liquidity_measure - liquidity_measure)
    :precondition
      (and
        (entity_triaged ?operating_unit)
        (entity_assigned_cash_flow_need ?operating_unit ?cash_flow_need)
        (operating_unit_internal_channel ?operating_unit ?internal_funding_channel)
        (internal_channel_measure_attached ?internal_funding_channel)
        (operating_unit_allocated_measure ?operating_unit ?liquidity_measure)
        (not
          (operating_unit_channel_validated ?operating_unit)
        )
      )
    :effect
      (and
        (internal_channel_ready ?internal_funding_channel)
        (operating_unit_channel_validated ?operating_unit)
        (liquidity_measure_available ?liquidity_measure)
        (not
          (operating_unit_allocated_measure ?operating_unit ?liquidity_measure)
        )
      )
  )
  (:action activate_external_funding_channel_for_trading_unit
    :parameters (?trading_unit - trading_unit ?external_funding_channel - external_funding_channel ?cash_flow_need - cash_flow_need)
    :precondition
      (and
        (entity_triaged ?trading_unit)
        (entity_assigned_cash_flow_need ?trading_unit ?cash_flow_need)
        (trading_unit_external_channel ?trading_unit ?external_funding_channel)
        (not
          (external_channel_ready ?external_funding_channel)
        )
        (not
          (external_channel_measure_attached ?external_funding_channel)
        )
      )
    :effect (external_channel_ready ?external_funding_channel)
  )
  (:action confirm_external_channel_for_trading_unit
    :parameters (?trading_unit - trading_unit ?external_funding_channel - external_funding_channel ?treasury_controller - treasury_controller)
    :precondition
      (and
        (entity_triaged ?trading_unit)
        (entity_assigned_treasury_controller ?trading_unit ?treasury_controller)
        (trading_unit_external_channel ?trading_unit ?external_funding_channel)
        (external_channel_ready ?external_funding_channel)
        (not
          (trading_unit_ready_for_allocation ?trading_unit)
        )
      )
    :effect
      (and
        (trading_unit_ready_for_allocation ?trading_unit)
        (trading_unit_channel_validated ?trading_unit)
      )
  )
  (:action attach_liquidity_measure_to_trading_unit_channel
    :parameters (?trading_unit - trading_unit ?external_funding_channel - external_funding_channel ?liquidity_measure - liquidity_measure)
    :precondition
      (and
        (entity_triaged ?trading_unit)
        (trading_unit_external_channel ?trading_unit ?external_funding_channel)
        (liquidity_measure_available ?liquidity_measure)
        (not
          (trading_unit_ready_for_allocation ?trading_unit)
        )
      )
    :effect
      (and
        (external_channel_measure_attached ?external_funding_channel)
        (trading_unit_ready_for_allocation ?trading_unit)
        (trading_unit_allocated_measure ?trading_unit ?liquidity_measure)
        (not
          (liquidity_measure_available ?liquidity_measure)
        )
      )
  )
  (:action finalize_external_channel_activation_for_trading_unit
    :parameters (?trading_unit - trading_unit ?external_funding_channel - external_funding_channel ?cash_flow_need - cash_flow_need ?liquidity_measure - liquidity_measure)
    :precondition
      (and
        (entity_triaged ?trading_unit)
        (entity_assigned_cash_flow_need ?trading_unit ?cash_flow_need)
        (trading_unit_external_channel ?trading_unit ?external_funding_channel)
        (external_channel_measure_attached ?external_funding_channel)
        (trading_unit_allocated_measure ?trading_unit ?liquidity_measure)
        (not
          (trading_unit_channel_validated ?trading_unit)
        )
      )
    :effect
      (and
        (external_channel_ready ?external_funding_channel)
        (trading_unit_channel_validated ?trading_unit)
        (liquidity_measure_available ?liquidity_measure)
        (not
          (trading_unit_allocated_measure ?trading_unit ?liquidity_measure)
        )
      )
  )
  (:action construct_funding_allocation
    :parameters (?operating_unit - operating_unit ?trading_unit - trading_unit ?internal_funding_channel - internal_funding_channel ?external_funding_channel - external_funding_channel ?funding_allocation - funding_allocation)
    :precondition
      (and
        (operating_unit_ready_for_allocation ?operating_unit)
        (trading_unit_ready_for_allocation ?trading_unit)
        (operating_unit_internal_channel ?operating_unit ?internal_funding_channel)
        (trading_unit_external_channel ?trading_unit ?external_funding_channel)
        (internal_channel_ready ?internal_funding_channel)
        (external_channel_ready ?external_funding_channel)
        (operating_unit_channel_validated ?operating_unit)
        (trading_unit_channel_validated ?trading_unit)
        (funding_allocation_unassigned ?funding_allocation)
      )
    :effect
      (and
        (funding_allocation_reserved ?funding_allocation)
        (funding_allocation_internal_channel ?funding_allocation ?internal_funding_channel)
        (funding_allocation_external_channel ?funding_allocation ?external_funding_channel)
        (not
          (funding_allocation_unassigned ?funding_allocation)
        )
      )
  )
  (:action construct_funding_allocation_with_internal_measure_flag
    :parameters (?operating_unit - operating_unit ?trading_unit - trading_unit ?internal_funding_channel - internal_funding_channel ?external_funding_channel - external_funding_channel ?funding_allocation - funding_allocation)
    :precondition
      (and
        (operating_unit_ready_for_allocation ?operating_unit)
        (trading_unit_ready_for_allocation ?trading_unit)
        (operating_unit_internal_channel ?operating_unit ?internal_funding_channel)
        (trading_unit_external_channel ?trading_unit ?external_funding_channel)
        (internal_channel_measure_attached ?internal_funding_channel)
        (external_channel_ready ?external_funding_channel)
        (not
          (operating_unit_channel_validated ?operating_unit)
        )
        (trading_unit_channel_validated ?trading_unit)
        (funding_allocation_unassigned ?funding_allocation)
      )
    :effect
      (and
        (funding_allocation_reserved ?funding_allocation)
        (funding_allocation_internal_channel ?funding_allocation ?internal_funding_channel)
        (funding_allocation_external_channel ?funding_allocation ?external_funding_channel)
        (funding_allocation_internal_measure_flag ?funding_allocation)
        (not
          (funding_allocation_unassigned ?funding_allocation)
        )
      )
  )
  (:action construct_funding_allocation_with_external_measure_flag
    :parameters (?operating_unit - operating_unit ?trading_unit - trading_unit ?internal_funding_channel - internal_funding_channel ?external_funding_channel - external_funding_channel ?funding_allocation - funding_allocation)
    :precondition
      (and
        (operating_unit_ready_for_allocation ?operating_unit)
        (trading_unit_ready_for_allocation ?trading_unit)
        (operating_unit_internal_channel ?operating_unit ?internal_funding_channel)
        (trading_unit_external_channel ?trading_unit ?external_funding_channel)
        (internal_channel_ready ?internal_funding_channel)
        (external_channel_measure_attached ?external_funding_channel)
        (operating_unit_channel_validated ?operating_unit)
        (not
          (trading_unit_channel_validated ?trading_unit)
        )
        (funding_allocation_unassigned ?funding_allocation)
      )
    :effect
      (and
        (funding_allocation_reserved ?funding_allocation)
        (funding_allocation_internal_channel ?funding_allocation ?internal_funding_channel)
        (funding_allocation_external_channel ?funding_allocation ?external_funding_channel)
        (funding_allocation_external_measure_flag ?funding_allocation)
        (not
          (funding_allocation_unassigned ?funding_allocation)
        )
      )
  )
  (:action construct_funding_allocation_with_both_channel_flags
    :parameters (?operating_unit - operating_unit ?trading_unit - trading_unit ?internal_funding_channel - internal_funding_channel ?external_funding_channel - external_funding_channel ?funding_allocation - funding_allocation)
    :precondition
      (and
        (operating_unit_ready_for_allocation ?operating_unit)
        (trading_unit_ready_for_allocation ?trading_unit)
        (operating_unit_internal_channel ?operating_unit ?internal_funding_channel)
        (trading_unit_external_channel ?trading_unit ?external_funding_channel)
        (internal_channel_measure_attached ?internal_funding_channel)
        (external_channel_measure_attached ?external_funding_channel)
        (not
          (operating_unit_channel_validated ?operating_unit)
        )
        (not
          (trading_unit_channel_validated ?trading_unit)
        )
        (funding_allocation_unassigned ?funding_allocation)
      )
    :effect
      (and
        (funding_allocation_reserved ?funding_allocation)
        (funding_allocation_internal_channel ?funding_allocation ?internal_funding_channel)
        (funding_allocation_external_channel ?funding_allocation ?external_funding_channel)
        (funding_allocation_internal_measure_flag ?funding_allocation)
        (funding_allocation_external_measure_flag ?funding_allocation)
        (not
          (funding_allocation_unassigned ?funding_allocation)
        )
      )
  )
  (:action mark_funding_allocation_assets_mobilized
    :parameters (?funding_allocation - funding_allocation ?operating_unit - operating_unit ?cash_flow_need - cash_flow_need)
    :precondition
      (and
        (funding_allocation_reserved ?funding_allocation)
        (operating_unit_ready_for_allocation ?operating_unit)
        (entity_assigned_cash_flow_need ?operating_unit ?cash_flow_need)
        (not
          (funding_allocation_assets_mobilized ?funding_allocation)
        )
      )
    :effect (funding_allocation_assets_mobilized ?funding_allocation)
  )
  (:action reserve_liquid_asset_for_allocation
    :parameters (?treasury_desk - treasury_desk ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation)
    :precondition
      (and
        (entity_triaged ?treasury_desk)
        (treasury_desk_links_funding_allocation ?treasury_desk ?funding_allocation)
        (treasury_desk_holds_liquid_asset ?treasury_desk ?liquid_asset)
        (liquid_asset_available ?liquid_asset)
        (funding_allocation_reserved ?funding_allocation)
        (funding_allocation_assets_mobilized ?funding_allocation)
        (not
          (liquid_asset_reserved ?liquid_asset)
        )
      )
    :effect
      (and
        (liquid_asset_reserved ?liquid_asset)
        (liquid_asset_allocated_to_funding_allocation ?liquid_asset ?funding_allocation)
        (not
          (liquid_asset_available ?liquid_asset)
        )
      )
  )
  (:action prepare_liquid_asset_mobilization
    :parameters (?treasury_desk - treasury_desk ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation ?cash_flow_need - cash_flow_need)
    :precondition
      (and
        (entity_triaged ?treasury_desk)
        (treasury_desk_holds_liquid_asset ?treasury_desk ?liquid_asset)
        (liquid_asset_reserved ?liquid_asset)
        (liquid_asset_allocated_to_funding_allocation ?liquid_asset ?funding_allocation)
        (entity_assigned_cash_flow_need ?treasury_desk ?cash_flow_need)
        (not
          (funding_allocation_internal_measure_flag ?funding_allocation)
        )
        (not
          (treasury_desk_strategy_binding_flag ?treasury_desk)
        )
      )
    :effect (treasury_desk_strategy_binding_flag ?treasury_desk)
  )
  (:action allocate_contingency_credit_line_to_treasury_desk
    :parameters (?treasury_desk - treasury_desk ?contingency_credit_line - contingency_credit_line)
    :precondition
      (and
        (entity_triaged ?treasury_desk)
        (contingency_credit_line_available ?contingency_credit_line)
        (not
          (treasury_desk_has_contingency_line ?treasury_desk)
        )
      )
    :effect
      (and
        (treasury_desk_has_contingency_line ?treasury_desk)
        (treasury_desk_allocated_contingency_line ?treasury_desk ?contingency_credit_line)
        (not
          (contingency_credit_line_available ?contingency_credit_line)
        )
      )
  )
  (:action apply_authority_and_resource_bindings
    :parameters (?treasury_desk - treasury_desk ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation ?cash_flow_need - cash_flow_need ?contingency_credit_line - contingency_credit_line)
    :precondition
      (and
        (entity_triaged ?treasury_desk)
        (treasury_desk_holds_liquid_asset ?treasury_desk ?liquid_asset)
        (liquid_asset_reserved ?liquid_asset)
        (liquid_asset_allocated_to_funding_allocation ?liquid_asset ?funding_allocation)
        (entity_assigned_cash_flow_need ?treasury_desk ?cash_flow_need)
        (funding_allocation_internal_measure_flag ?funding_allocation)
        (treasury_desk_has_contingency_line ?treasury_desk)
        (treasury_desk_allocated_contingency_line ?treasury_desk ?contingency_credit_line)
        (not
          (treasury_desk_strategy_binding_flag ?treasury_desk)
        )
      )
    :effect
      (and
        (treasury_desk_strategy_binding_flag ?treasury_desk)
        (treasury_desk_authority_validated ?treasury_desk)
      )
  )
  (:action stage_treasury_desk_for_execution
    :parameters (?treasury_desk - treasury_desk ?funding_strategy - funding_strategy ?treasury_controller - treasury_controller ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation)
    :precondition
      (and
        (treasury_desk_strategy_binding_flag ?treasury_desk)
        (treasury_desk_bound_funding_strategy ?treasury_desk ?funding_strategy)
        (entity_assigned_treasury_controller ?treasury_desk ?treasury_controller)
        (treasury_desk_holds_liquid_asset ?treasury_desk ?liquid_asset)
        (liquid_asset_allocated_to_funding_allocation ?liquid_asset ?funding_allocation)
        (not
          (funding_allocation_external_measure_flag ?funding_allocation)
        )
        (not
          (treasury_desk_prepared_for_execution ?treasury_desk)
        )
      )
    :effect (treasury_desk_prepared_for_execution ?treasury_desk)
  )
  (:action stage_treasury_desk_for_execution_alternate
    :parameters (?treasury_desk - treasury_desk ?funding_strategy - funding_strategy ?treasury_controller - treasury_controller ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation)
    :precondition
      (and
        (treasury_desk_strategy_binding_flag ?treasury_desk)
        (treasury_desk_bound_funding_strategy ?treasury_desk ?funding_strategy)
        (entity_assigned_treasury_controller ?treasury_desk ?treasury_controller)
        (treasury_desk_holds_liquid_asset ?treasury_desk ?liquid_asset)
        (liquid_asset_allocated_to_funding_allocation ?liquid_asset ?funding_allocation)
        (funding_allocation_external_measure_flag ?funding_allocation)
        (not
          (treasury_desk_prepared_for_execution ?treasury_desk)
        )
      )
    :effect (treasury_desk_prepared_for_execution ?treasury_desk)
  )
  (:action prepare_treasury_desk_execution_readiness
    :parameters (?treasury_desk - treasury_desk ?regulatory_exception - regulatory_exception ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation)
    :precondition
      (and
        (treasury_desk_prepared_for_execution ?treasury_desk)
        (treasury_desk_bound_regulatory_exception ?treasury_desk ?regulatory_exception)
        (treasury_desk_holds_liquid_asset ?treasury_desk ?liquid_asset)
        (liquid_asset_allocated_to_funding_allocation ?liquid_asset ?funding_allocation)
        (not
          (funding_allocation_internal_measure_flag ?funding_allocation)
        )
        (not
          (funding_allocation_external_measure_flag ?funding_allocation)
        )
        (not
          (treasury_desk_execution_ready ?treasury_desk)
        )
      )
    :effect (treasury_desk_execution_ready ?treasury_desk)
  )
  (:action confirm_execution_and_set_governance_flag_with_internal_flag
    :parameters (?treasury_desk - treasury_desk ?regulatory_exception - regulatory_exception ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation)
    :precondition
      (and
        (treasury_desk_prepared_for_execution ?treasury_desk)
        (treasury_desk_bound_regulatory_exception ?treasury_desk ?regulatory_exception)
        (treasury_desk_holds_liquid_asset ?treasury_desk ?liquid_asset)
        (liquid_asset_allocated_to_funding_allocation ?liquid_asset ?funding_allocation)
        (funding_allocation_internal_measure_flag ?funding_allocation)
        (not
          (funding_allocation_external_measure_flag ?funding_allocation)
        )
        (not
          (treasury_desk_execution_ready ?treasury_desk)
        )
      )
    :effect
      (and
        (treasury_desk_execution_ready ?treasury_desk)
        (treasury_desk_governance_confirmed ?treasury_desk)
      )
  )
  (:action confirm_execution_and_set_governance_flag_with_external_flag
    :parameters (?treasury_desk - treasury_desk ?regulatory_exception - regulatory_exception ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation)
    :precondition
      (and
        (treasury_desk_prepared_for_execution ?treasury_desk)
        (treasury_desk_bound_regulatory_exception ?treasury_desk ?regulatory_exception)
        (treasury_desk_holds_liquid_asset ?treasury_desk ?liquid_asset)
        (liquid_asset_allocated_to_funding_allocation ?liquid_asset ?funding_allocation)
        (not
          (funding_allocation_internal_measure_flag ?funding_allocation)
        )
        (funding_allocation_external_measure_flag ?funding_allocation)
        (not
          (treasury_desk_execution_ready ?treasury_desk)
        )
      )
    :effect
      (and
        (treasury_desk_execution_ready ?treasury_desk)
        (treasury_desk_governance_confirmed ?treasury_desk)
      )
  )
  (:action confirm_execution_and_set_governance_flag_with_both_flags
    :parameters (?treasury_desk - treasury_desk ?regulatory_exception - regulatory_exception ?liquid_asset - liquid_asset ?funding_allocation - funding_allocation)
    :precondition
      (and
        (treasury_desk_prepared_for_execution ?treasury_desk)
        (treasury_desk_bound_regulatory_exception ?treasury_desk ?regulatory_exception)
        (treasury_desk_holds_liquid_asset ?treasury_desk ?liquid_asset)
        (liquid_asset_allocated_to_funding_allocation ?liquid_asset ?funding_allocation)
        (funding_allocation_internal_measure_flag ?funding_allocation)
        (funding_allocation_external_measure_flag ?funding_allocation)
        (not
          (treasury_desk_execution_ready ?treasury_desk)
        )
      )
    :effect
      (and
        (treasury_desk_execution_ready ?treasury_desk)
        (treasury_desk_governance_confirmed ?treasury_desk)
      )
  )
  (:action finalize_treasury_desk_confirmation
    :parameters (?treasury_desk - treasury_desk)
    :precondition
      (and
        (treasury_desk_execution_ready ?treasury_desk)
        (not
          (treasury_desk_governance_confirmed ?treasury_desk)
        )
        (not
          (treasury_desk_execution_confirmed ?treasury_desk)
        )
      )
    :effect
      (and
        (treasury_desk_execution_confirmed ?treasury_desk)
        (funding_permission_granted ?treasury_desk)
      )
  )
  (:action bind_operational_resource_to_treasury_desk
    :parameters (?treasury_desk - treasury_desk ?operational_resource - operational_resource)
    :precondition
      (and
        (treasury_desk_execution_ready ?treasury_desk)
        (treasury_desk_governance_confirmed ?treasury_desk)
        (operational_resource_available ?operational_resource)
      )
    :effect
      (and
        (treasury_desk_allocates_operational_resource ?treasury_desk ?operational_resource)
        (not
          (operational_resource_available ?operational_resource)
        )
      )
  )
  (:action execute_treasury_desk_final_checks
    :parameters (?treasury_desk - treasury_desk ?operating_unit - operating_unit ?trading_unit - trading_unit ?cash_flow_need - cash_flow_need ?operational_resource - operational_resource)
    :precondition
      (and
        (treasury_desk_execution_ready ?treasury_desk)
        (treasury_desk_governance_confirmed ?treasury_desk)
        (treasury_desk_allocates_operational_resource ?treasury_desk ?operational_resource)
        (treasury_desk_manages_operating_unit ?treasury_desk ?operating_unit)
        (treasury_desk_manages_trading_unit ?treasury_desk ?trading_unit)
        (operating_unit_channel_validated ?operating_unit)
        (trading_unit_channel_validated ?trading_unit)
        (entity_assigned_cash_flow_need ?treasury_desk ?cash_flow_need)
        (not
          (treasury_desk_checks_passed ?treasury_desk)
        )
      )
    :effect (treasury_desk_checks_passed ?treasury_desk)
  )
  (:action confirm_treasury_desk_execution
    :parameters (?treasury_desk - treasury_desk)
    :precondition
      (and
        (treasury_desk_execution_ready ?treasury_desk)
        (treasury_desk_checks_passed ?treasury_desk)
        (not
          (treasury_desk_execution_confirmed ?treasury_desk)
        )
      )
    :effect
      (and
        (treasury_desk_execution_confirmed ?treasury_desk)
        (funding_permission_granted ?treasury_desk)
      )
  )
  (:action apply_delegated_authority_to_treasury_desk
    :parameters (?treasury_desk - treasury_desk ?delegated_authority - delegated_authority ?cash_flow_need - cash_flow_need)
    :precondition
      (and
        (entity_triaged ?treasury_desk)
        (entity_assigned_cash_flow_need ?treasury_desk ?cash_flow_need)
        (delegated_authority_available ?delegated_authority)
        (treasury_desk_has_delegated_authority ?treasury_desk ?delegated_authority)
        (not
          (treasury_desk_delegation_applied ?treasury_desk)
        )
      )
    :effect
      (and
        (treasury_desk_delegation_applied ?treasury_desk)
        (not
          (delegated_authority_available ?delegated_authority)
        )
      )
  )
  (:action authorize_delegation_for_treasury_desk
    :parameters (?treasury_desk - treasury_desk ?treasury_controller - treasury_controller)
    :precondition
      (and
        (treasury_desk_delegation_applied ?treasury_desk)
        (entity_assigned_treasury_controller ?treasury_desk ?treasury_controller)
        (not
          (treasury_desk_delegation_authorized ?treasury_desk)
        )
      )
    :effect (treasury_desk_delegation_authorized ?treasury_desk)
  )
  (:action finalize_delegation_authorization
    :parameters (?treasury_desk - treasury_desk ?regulatory_exception - regulatory_exception)
    :precondition
      (and
        (treasury_desk_delegation_authorized ?treasury_desk)
        (treasury_desk_bound_regulatory_exception ?treasury_desk ?regulatory_exception)
        (not
          (treasury_desk_authorization_finalized ?treasury_desk)
        )
      )
    :effect (treasury_desk_authorization_finalized ?treasury_desk)
  )
  (:action finalize_delegation_and_confirm_execution
    :parameters (?treasury_desk - treasury_desk)
    :precondition
      (and
        (treasury_desk_authorization_finalized ?treasury_desk)
        (not
          (treasury_desk_execution_confirmed ?treasury_desk)
        )
      )
    :effect
      (and
        (treasury_desk_execution_confirmed ?treasury_desk)
        (funding_permission_granted ?treasury_desk)
      )
  )
  (:action grant_funding_permission_to_operating_unit
    :parameters (?operating_unit - operating_unit ?funding_allocation - funding_allocation)
    :precondition
      (and
        (operating_unit_ready_for_allocation ?operating_unit)
        (operating_unit_channel_validated ?operating_unit)
        (funding_allocation_reserved ?funding_allocation)
        (funding_allocation_assets_mobilized ?funding_allocation)
        (not
          (funding_permission_granted ?operating_unit)
        )
      )
    :effect (funding_permission_granted ?operating_unit)
  )
  (:action grant_funding_permission_to_trading_unit
    :parameters (?trading_unit - trading_unit ?funding_allocation - funding_allocation)
    :precondition
      (and
        (trading_unit_ready_for_allocation ?trading_unit)
        (trading_unit_channel_validated ?trading_unit)
        (funding_allocation_reserved ?funding_allocation)
        (funding_allocation_assets_mobilized ?funding_allocation)
        (not
          (funding_permission_granted ?trading_unit)
        )
      )
    :effect (funding_permission_granted ?trading_unit)
  )
  (:action issue_funding_instruction_to_entity
    :parameters (?legal_entity - legal_entity ?stress_scenario - stress_scenario ?cash_flow_need - cash_flow_need)
    :precondition
      (and
        (funding_permission_granted ?legal_entity)
        (entity_assigned_cash_flow_need ?legal_entity ?cash_flow_need)
        (stress_scenario_available ?stress_scenario)
        (not
          (entity_funding_authorized ?legal_entity)
        )
      )
    :effect
      (and
        (entity_funding_authorized ?legal_entity)
        (entity_bound_stress_scenario ?legal_entity ?stress_scenario)
        (not
          (stress_scenario_available ?stress_scenario)
        )
      )
  )
  (:action fund_operating_unit_via_source
    :parameters (?operating_unit - operating_unit ?funding_source - funding_source ?stress_scenario - stress_scenario)
    :precondition
      (and
        (entity_funding_authorized ?operating_unit)
        (entity_assigned_funding_source ?operating_unit ?funding_source)
        (entity_bound_stress_scenario ?operating_unit ?stress_scenario)
        (not
          (entity_liquidity_protected ?operating_unit)
        )
      )
    :effect
      (and
        (entity_liquidity_protected ?operating_unit)
        (funding_source_available ?funding_source)
        (stress_scenario_available ?stress_scenario)
      )
  )
  (:action fund_trading_unit_via_source
    :parameters (?trading_unit - trading_unit ?funding_source - funding_source ?stress_scenario - stress_scenario)
    :precondition
      (and
        (entity_funding_authorized ?trading_unit)
        (entity_assigned_funding_source ?trading_unit ?funding_source)
        (entity_bound_stress_scenario ?trading_unit ?stress_scenario)
        (not
          (entity_liquidity_protected ?trading_unit)
        )
      )
    :effect
      (and
        (entity_liquidity_protected ?trading_unit)
        (funding_source_available ?funding_source)
        (stress_scenario_available ?stress_scenario)
      )
  )
  (:action fund_treasury_desk_via_source
    :parameters (?treasury_desk - treasury_desk ?funding_source - funding_source ?stress_scenario - stress_scenario)
    :precondition
      (and
        (entity_funding_authorized ?treasury_desk)
        (entity_assigned_funding_source ?treasury_desk ?funding_source)
        (entity_bound_stress_scenario ?treasury_desk ?stress_scenario)
        (not
          (entity_liquidity_protected ?treasury_desk)
        )
      )
    :effect
      (and
        (entity_liquidity_protected ?treasury_desk)
        (funding_source_available ?funding_source)
        (stress_scenario_available ?stress_scenario)
      )
  )
)

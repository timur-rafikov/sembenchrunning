(define (domain treasury_cash_consolidation_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types operational_resource - object instruction_resource - object endpoint_resource - object account_superclass - object account - account_superclass funding_channel - operational_resource cash_forecast - operational_resource operator - operational_resource compliance_rule - operational_resource reporting_template - operational_resource buffer_profile - operational_resource approval_document - operational_resource regulatory_constraint - operational_resource transfer_template - instruction_resource settlement_window - instruction_resource external_mandate - instruction_resource source_endpoint - endpoint_resource target_endpoint - endpoint_resource consolidation_order - endpoint_resource account_role_group - account entity_role_group - account operating_account - account_role_group subsidiary_account - account_role_group treasury_entity - entity_role_group)
  (:predicates
    (account_discovered ?account - account)
    (eligible_for_consolidation ?account - account)
    (account_channel_assigned ?account - account)
    (entity_consolidation_finalized ?account - account)
    (entity_ready_for_posting ?account - account)
    (entity_buffer_adjusted ?account - account)
    (funding_channel_available ?funding_channel - funding_channel)
    (entity_funding_channel_link ?account - account ?funding_channel - funding_channel)
    (cash_forecast_available ?cash_forecast - cash_forecast)
    (entity_cash_forecast_link ?account - account ?cash_forecast - cash_forecast)
    (operator_available ?operator - operator)
    (entity_operator_assignment ?account - account ?operator - operator)
    (transfer_template_available ?transfer_template - transfer_template)
    (operating_account_transfer_template_link ?operating_account - operating_account ?transfer_template - transfer_template)
    (subsidiary_account_transfer_template_link ?subsidiary_account - subsidiary_account ?transfer_template - transfer_template)
    (account_source_endpoint_link ?operating_account - operating_account ?source_endpoint - source_endpoint)
    (source_endpoint_available ?source_endpoint - source_endpoint)
    (source_endpoint_reserved ?source_endpoint - source_endpoint)
    (operating_account_liquidity_confirmed ?operating_account - operating_account)
    (subsidiary_to_target_endpoint_link ?subsidiary_account - subsidiary_account ?target_endpoint - target_endpoint)
    (target_endpoint_available ?target_endpoint - target_endpoint)
    (target_endpoint_reserved ?target_endpoint - target_endpoint)
    (subsidiary_account_liquidity_confirmed ?subsidiary_account - subsidiary_account)
    (consolidation_order_available ?consolidation_order - consolidation_order)
    (consolidation_order_allocated ?consolidation_order - consolidation_order)
    (order_source_endpoint_link ?consolidation_order - consolidation_order ?source_endpoint - source_endpoint)
    (order_target_endpoint_link ?consolidation_order - consolidation_order ?target_endpoint - target_endpoint)
    (order_requires_approval ?consolidation_order - consolidation_order)
    (order_requires_mandate ?consolidation_order - consolidation_order)
    (order_settlement_window_assigned ?consolidation_order - consolidation_order)
    (entity_operating_account_link ?treasury_entity - treasury_entity ?operating_account - operating_account)
    (entity_subsidiary_account_link ?treasury_entity - treasury_entity ?subsidiary_account - subsidiary_account)
    (entity_order_link ?treasury_entity - treasury_entity ?consolidation_order - consolidation_order)
    (settlement_window_available ?settlement_window - settlement_window)
    (entity_settlement_window_link ?treasury_entity - treasury_entity ?settlement_window - settlement_window)
    (settlement_window_allocated ?settlement_window - settlement_window)
    (settlement_window_order_link ?settlement_window - settlement_window ?consolidation_order - consolidation_order)
    (entity_order_validated ?treasury_entity - treasury_entity)
    (entity_approval_attached ?treasury_entity - treasury_entity)
    (entity_authorized ?treasury_entity - treasury_entity)
    (entity_compliance_registered ?treasury_entity - treasury_entity)
    (entity_compliance_validated ?treasury_entity - treasury_entity)
    (entity_reporting_enabled ?treasury_entity - treasury_entity)
    (entity_prepared_for_finalization ?treasury_entity - treasury_entity)
    (external_mandate_available ?external_mandate - external_mandate)
    (entity_mandate_link ?treasury_entity - treasury_entity ?external_mandate - external_mandate)
    (entity_mandate_acknowledged ?treasury_entity - treasury_entity)
    (entity_mandate_processed ?treasury_entity - treasury_entity)
    (entity_mandate_validated ?treasury_entity - treasury_entity)
    (compliance_rule_available ?compliance_rule - compliance_rule)
    (entity_compliance_rule_link ?treasury_entity - treasury_entity ?compliance_rule - compliance_rule)
    (reporting_template_available ?reporting_template - reporting_template)
    (entity_reporting_template_link ?treasury_entity - treasury_entity ?reporting_template - reporting_template)
    (approval_document_available ?approval_document - approval_document)
    (entity_approval_document_link ?treasury_entity - treasury_entity ?approval_document - approval_document)
    (regulatory_constraint_available ?regulatory_constraint - regulatory_constraint)
    (entity_regulatory_constraint_link ?treasury_entity - treasury_entity ?regulatory_constraint - regulatory_constraint)
    (buffer_profile_available ?buffer_profile - buffer_profile)
    (entity_buffer_profile_link ?account - account ?buffer_profile - buffer_profile)
    (operating_account_checks_completed ?operating_account - operating_account)
    (subsidiary_account_checks_completed ?subsidiary_account - subsidiary_account)
    (entity_finalized_for_posting ?treasury_entity - treasury_entity)
  )
  (:action identify_account_for_consolidation
    :parameters (?account - account)
    :precondition
      (and
        (not
          (account_discovered ?account)
        )
        (not
          (entity_consolidation_finalized ?account)
        )
      )
    :effect (account_discovered ?account)
  )
  (:action assign_funding_channel_to_account
    :parameters (?account - account ?funding_channel - funding_channel)
    :precondition
      (and
        (account_discovered ?account)
        (not
          (account_channel_assigned ?account)
        )
        (funding_channel_available ?funding_channel)
      )
    :effect
      (and
        (account_channel_assigned ?account)
        (entity_funding_channel_link ?account ?funding_channel)
        (not
          (funding_channel_available ?funding_channel)
        )
      )
  )
  (:action link_cash_forecast_to_account
    :parameters (?account - account ?cash_forecast - cash_forecast)
    :precondition
      (and
        (account_discovered ?account)
        (account_channel_assigned ?account)
        (cash_forecast_available ?cash_forecast)
      )
    :effect
      (and
        (entity_cash_forecast_link ?account ?cash_forecast)
        (not
          (cash_forecast_available ?cash_forecast)
        )
      )
  )
  (:action mark_account_eligible_for_consolidation
    :parameters (?account - account ?cash_forecast - cash_forecast)
    :precondition
      (and
        (account_discovered ?account)
        (account_channel_assigned ?account)
        (entity_cash_forecast_link ?account ?cash_forecast)
        (not
          (eligible_for_consolidation ?account)
        )
      )
    :effect (eligible_for_consolidation ?account)
  )
  (:action unlink_cash_forecast_from_account
    :parameters (?account - account ?cash_forecast - cash_forecast)
    :precondition
      (and
        (entity_cash_forecast_link ?account ?cash_forecast)
      )
    :effect
      (and
        (cash_forecast_available ?cash_forecast)
        (not
          (entity_cash_forecast_link ?account ?cash_forecast)
        )
      )
  )
  (:action assign_operator_to_account
    :parameters (?account - account ?operator - operator)
    :precondition
      (and
        (eligible_for_consolidation ?account)
        (operator_available ?operator)
      )
    :effect
      (and
        (entity_operator_assignment ?account ?operator)
        (not
          (operator_available ?operator)
        )
      )
  )
  (:action release_operator_from_account
    :parameters (?account - account ?operator - operator)
    :precondition
      (and
        (entity_operator_assignment ?account ?operator)
      )
    :effect
      (and
        (operator_available ?operator)
        (not
          (entity_operator_assignment ?account ?operator)
        )
      )
  )
  (:action attach_approval_document_to_entity
    :parameters (?treasury_entity - treasury_entity ?approval_document - approval_document)
    :precondition
      (and
        (eligible_for_consolidation ?treasury_entity)
        (approval_document_available ?approval_document)
      )
    :effect
      (and
        (entity_approval_document_link ?treasury_entity ?approval_document)
        (not
          (approval_document_available ?approval_document)
        )
      )
  )
  (:action detach_approval_document_from_entity
    :parameters (?treasury_entity - treasury_entity ?approval_document - approval_document)
    :precondition
      (and
        (entity_approval_document_link ?treasury_entity ?approval_document)
      )
    :effect
      (and
        (approval_document_available ?approval_document)
        (not
          (entity_approval_document_link ?treasury_entity ?approval_document)
        )
      )
  )
  (:action attach_regulatory_constraint_to_entity
    :parameters (?treasury_entity - treasury_entity ?regulatory_constraint - regulatory_constraint)
    :precondition
      (and
        (eligible_for_consolidation ?treasury_entity)
        (regulatory_constraint_available ?regulatory_constraint)
      )
    :effect
      (and
        (entity_regulatory_constraint_link ?treasury_entity ?regulatory_constraint)
        (not
          (regulatory_constraint_available ?regulatory_constraint)
        )
      )
  )
  (:action detach_regulatory_constraint_from_entity
    :parameters (?treasury_entity - treasury_entity ?regulatory_constraint - regulatory_constraint)
    :precondition
      (and
        (entity_regulatory_constraint_link ?treasury_entity ?regulatory_constraint)
      )
    :effect
      (and
        (regulatory_constraint_available ?regulatory_constraint)
        (not
          (entity_regulatory_constraint_link ?treasury_entity ?regulatory_constraint)
        )
      )
  )
  (:action flag_source_endpoint_available
    :parameters (?operating_account - operating_account ?source_endpoint - source_endpoint ?cash_forecast - cash_forecast)
    :precondition
      (and
        (eligible_for_consolidation ?operating_account)
        (entity_cash_forecast_link ?operating_account ?cash_forecast)
        (account_source_endpoint_link ?operating_account ?source_endpoint)
        (not
          (source_endpoint_available ?source_endpoint)
        )
        (not
          (source_endpoint_reserved ?source_endpoint)
        )
      )
    :effect (source_endpoint_available ?source_endpoint)
  )
  (:action confirm_operating_account_liquidity
    :parameters (?operating_account - operating_account ?source_endpoint - source_endpoint ?operator - operator)
    :precondition
      (and
        (eligible_for_consolidation ?operating_account)
        (entity_operator_assignment ?operating_account ?operator)
        (account_source_endpoint_link ?operating_account ?source_endpoint)
        (source_endpoint_available ?source_endpoint)
        (not
          (operating_account_checks_completed ?operating_account)
        )
      )
    :effect
      (and
        (operating_account_checks_completed ?operating_account)
        (operating_account_liquidity_confirmed ?operating_account)
      )
  )
  (:action allocate_transfer_template_to_operating_account
    :parameters (?operating_account - operating_account ?source_endpoint - source_endpoint ?transfer_template - transfer_template)
    :precondition
      (and
        (eligible_for_consolidation ?operating_account)
        (account_source_endpoint_link ?operating_account ?source_endpoint)
        (transfer_template_available ?transfer_template)
        (not
          (operating_account_checks_completed ?operating_account)
        )
      )
    :effect
      (and
        (source_endpoint_reserved ?source_endpoint)
        (operating_account_checks_completed ?operating_account)
        (operating_account_transfer_template_link ?operating_account ?transfer_template)
        (not
          (transfer_template_available ?transfer_template)
        )
      )
  )
  (:action assess_operating_account_buffers
    :parameters (?operating_account - operating_account ?source_endpoint - source_endpoint ?cash_forecast - cash_forecast ?transfer_template - transfer_template)
    :precondition
      (and
        (eligible_for_consolidation ?operating_account)
        (entity_cash_forecast_link ?operating_account ?cash_forecast)
        (account_source_endpoint_link ?operating_account ?source_endpoint)
        (source_endpoint_reserved ?source_endpoint)
        (operating_account_transfer_template_link ?operating_account ?transfer_template)
        (not
          (operating_account_liquidity_confirmed ?operating_account)
        )
      )
    :effect
      (and
        (source_endpoint_available ?source_endpoint)
        (operating_account_liquidity_confirmed ?operating_account)
        (transfer_template_available ?transfer_template)
        (not
          (operating_account_transfer_template_link ?operating_account ?transfer_template)
        )
      )
  )
  (:action flag_target_endpoint_available
    :parameters (?subsidiary_account - subsidiary_account ?target_endpoint - target_endpoint ?cash_forecast - cash_forecast)
    :precondition
      (and
        (eligible_for_consolidation ?subsidiary_account)
        (entity_cash_forecast_link ?subsidiary_account ?cash_forecast)
        (subsidiary_to_target_endpoint_link ?subsidiary_account ?target_endpoint)
        (not
          (target_endpoint_available ?target_endpoint)
        )
        (not
          (target_endpoint_reserved ?target_endpoint)
        )
      )
    :effect (target_endpoint_available ?target_endpoint)
  )
  (:action confirm_subsidiary_account_liquidity
    :parameters (?subsidiary_account - subsidiary_account ?target_endpoint - target_endpoint ?operator - operator)
    :precondition
      (and
        (eligible_for_consolidation ?subsidiary_account)
        (entity_operator_assignment ?subsidiary_account ?operator)
        (subsidiary_to_target_endpoint_link ?subsidiary_account ?target_endpoint)
        (target_endpoint_available ?target_endpoint)
        (not
          (subsidiary_account_checks_completed ?subsidiary_account)
        )
      )
    :effect
      (and
        (subsidiary_account_checks_completed ?subsidiary_account)
        (subsidiary_account_liquidity_confirmed ?subsidiary_account)
      )
  )
  (:action allocate_transfer_template_to_subsidiary_account
    :parameters (?subsidiary_account - subsidiary_account ?target_endpoint - target_endpoint ?transfer_template - transfer_template)
    :precondition
      (and
        (eligible_for_consolidation ?subsidiary_account)
        (subsidiary_to_target_endpoint_link ?subsidiary_account ?target_endpoint)
        (transfer_template_available ?transfer_template)
        (not
          (subsidiary_account_checks_completed ?subsidiary_account)
        )
      )
    :effect
      (and
        (target_endpoint_reserved ?target_endpoint)
        (subsidiary_account_checks_completed ?subsidiary_account)
        (subsidiary_account_transfer_template_link ?subsidiary_account ?transfer_template)
        (not
          (transfer_template_available ?transfer_template)
        )
      )
  )
  (:action assess_subsidiary_account_buffers
    :parameters (?subsidiary_account - subsidiary_account ?target_endpoint - target_endpoint ?cash_forecast - cash_forecast ?transfer_template - transfer_template)
    :precondition
      (and
        (eligible_for_consolidation ?subsidiary_account)
        (entity_cash_forecast_link ?subsidiary_account ?cash_forecast)
        (subsidiary_to_target_endpoint_link ?subsidiary_account ?target_endpoint)
        (target_endpoint_reserved ?target_endpoint)
        (subsidiary_account_transfer_template_link ?subsidiary_account ?transfer_template)
        (not
          (subsidiary_account_liquidity_confirmed ?subsidiary_account)
        )
      )
    :effect
      (and
        (target_endpoint_available ?target_endpoint)
        (subsidiary_account_liquidity_confirmed ?subsidiary_account)
        (transfer_template_available ?transfer_template)
        (not
          (subsidiary_account_transfer_template_link ?subsidiary_account ?transfer_template)
        )
      )
  )
  (:action create_consolidation_order
    :parameters (?operating_account - operating_account ?subsidiary_account - subsidiary_account ?source_endpoint - source_endpoint ?target_endpoint - target_endpoint ?consolidation_order - consolidation_order)
    :precondition
      (and
        (operating_account_checks_completed ?operating_account)
        (subsidiary_account_checks_completed ?subsidiary_account)
        (account_source_endpoint_link ?operating_account ?source_endpoint)
        (subsidiary_to_target_endpoint_link ?subsidiary_account ?target_endpoint)
        (source_endpoint_available ?source_endpoint)
        (target_endpoint_available ?target_endpoint)
        (operating_account_liquidity_confirmed ?operating_account)
        (subsidiary_account_liquidity_confirmed ?subsidiary_account)
        (consolidation_order_available ?consolidation_order)
      )
    :effect
      (and
        (consolidation_order_allocated ?consolidation_order)
        (order_source_endpoint_link ?consolidation_order ?source_endpoint)
        (order_target_endpoint_link ?consolidation_order ?target_endpoint)
        (not
          (consolidation_order_available ?consolidation_order)
        )
      )
  )
  (:action create_consolidation_order_with_source_reserved
    :parameters (?operating_account - operating_account ?subsidiary_account - subsidiary_account ?source_endpoint - source_endpoint ?target_endpoint - target_endpoint ?consolidation_order - consolidation_order)
    :precondition
      (and
        (operating_account_checks_completed ?operating_account)
        (subsidiary_account_checks_completed ?subsidiary_account)
        (account_source_endpoint_link ?operating_account ?source_endpoint)
        (subsidiary_to_target_endpoint_link ?subsidiary_account ?target_endpoint)
        (source_endpoint_reserved ?source_endpoint)
        (target_endpoint_available ?target_endpoint)
        (not
          (operating_account_liquidity_confirmed ?operating_account)
        )
        (subsidiary_account_liquidity_confirmed ?subsidiary_account)
        (consolidation_order_available ?consolidation_order)
      )
    :effect
      (and
        (consolidation_order_allocated ?consolidation_order)
        (order_source_endpoint_link ?consolidation_order ?source_endpoint)
        (order_target_endpoint_link ?consolidation_order ?target_endpoint)
        (order_requires_approval ?consolidation_order)
        (not
          (consolidation_order_available ?consolidation_order)
        )
      )
  )
  (:action create_consolidation_order_with_target_reserved
    :parameters (?operating_account - operating_account ?subsidiary_account - subsidiary_account ?source_endpoint - source_endpoint ?target_endpoint - target_endpoint ?consolidation_order - consolidation_order)
    :precondition
      (and
        (operating_account_checks_completed ?operating_account)
        (subsidiary_account_checks_completed ?subsidiary_account)
        (account_source_endpoint_link ?operating_account ?source_endpoint)
        (subsidiary_to_target_endpoint_link ?subsidiary_account ?target_endpoint)
        (source_endpoint_available ?source_endpoint)
        (target_endpoint_reserved ?target_endpoint)
        (operating_account_liquidity_confirmed ?operating_account)
        (not
          (subsidiary_account_liquidity_confirmed ?subsidiary_account)
        )
        (consolidation_order_available ?consolidation_order)
      )
    :effect
      (and
        (consolidation_order_allocated ?consolidation_order)
        (order_source_endpoint_link ?consolidation_order ?source_endpoint)
        (order_target_endpoint_link ?consolidation_order ?target_endpoint)
        (order_requires_mandate ?consolidation_order)
        (not
          (consolidation_order_available ?consolidation_order)
        )
      )
  )
  (:action create_consolidation_order_with_both_endpoints_reserved
    :parameters (?operating_account - operating_account ?subsidiary_account - subsidiary_account ?source_endpoint - source_endpoint ?target_endpoint - target_endpoint ?consolidation_order - consolidation_order)
    :precondition
      (and
        (operating_account_checks_completed ?operating_account)
        (subsidiary_account_checks_completed ?subsidiary_account)
        (account_source_endpoint_link ?operating_account ?source_endpoint)
        (subsidiary_to_target_endpoint_link ?subsidiary_account ?target_endpoint)
        (source_endpoint_reserved ?source_endpoint)
        (target_endpoint_reserved ?target_endpoint)
        (not
          (operating_account_liquidity_confirmed ?operating_account)
        )
        (not
          (subsidiary_account_liquidity_confirmed ?subsidiary_account)
        )
        (consolidation_order_available ?consolidation_order)
      )
    :effect
      (and
        (consolidation_order_allocated ?consolidation_order)
        (order_source_endpoint_link ?consolidation_order ?source_endpoint)
        (order_target_endpoint_link ?consolidation_order ?target_endpoint)
        (order_requires_approval ?consolidation_order)
        (order_requires_mandate ?consolidation_order)
        (not
          (consolidation_order_available ?consolidation_order)
        )
      )
  )
  (:action assign_settlement_window_to_order
    :parameters (?consolidation_order - consolidation_order ?operating_account - operating_account ?cash_forecast - cash_forecast)
    :precondition
      (and
        (consolidation_order_allocated ?consolidation_order)
        (operating_account_checks_completed ?operating_account)
        (entity_cash_forecast_link ?operating_account ?cash_forecast)
        (not
          (order_settlement_window_assigned ?consolidation_order)
        )
      )
    :effect (order_settlement_window_assigned ?consolidation_order)
  )
  (:action allocate_settlement_window_to_entity_and_order
    :parameters (?treasury_entity - treasury_entity ?settlement_window - settlement_window ?consolidation_order - consolidation_order)
    :precondition
      (and
        (eligible_for_consolidation ?treasury_entity)
        (entity_order_link ?treasury_entity ?consolidation_order)
        (entity_settlement_window_link ?treasury_entity ?settlement_window)
        (settlement_window_available ?settlement_window)
        (consolidation_order_allocated ?consolidation_order)
        (order_settlement_window_assigned ?consolidation_order)
        (not
          (settlement_window_allocated ?settlement_window)
        )
      )
    :effect
      (and
        (settlement_window_allocated ?settlement_window)
        (settlement_window_order_link ?settlement_window ?consolidation_order)
        (not
          (settlement_window_available ?settlement_window)
        )
      )
  )
  (:action validate_order_against_entity_requirements
    :parameters (?treasury_entity - treasury_entity ?settlement_window - settlement_window ?consolidation_order - consolidation_order ?cash_forecast - cash_forecast)
    :precondition
      (and
        (eligible_for_consolidation ?treasury_entity)
        (entity_settlement_window_link ?treasury_entity ?settlement_window)
        (settlement_window_allocated ?settlement_window)
        (settlement_window_order_link ?settlement_window ?consolidation_order)
        (entity_cash_forecast_link ?treasury_entity ?cash_forecast)
        (not
          (order_requires_approval ?consolidation_order)
        )
        (not
          (entity_order_validated ?treasury_entity)
        )
      )
    :effect (entity_order_validated ?treasury_entity)
  )
  (:action attach_compliance_rule_to_entity
    :parameters (?treasury_entity - treasury_entity ?compliance_rule - compliance_rule)
    :precondition
      (and
        (eligible_for_consolidation ?treasury_entity)
        (compliance_rule_available ?compliance_rule)
        (not
          (entity_compliance_registered ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_compliance_registered ?treasury_entity)
        (entity_compliance_rule_link ?treasury_entity ?compliance_rule)
        (not
          (compliance_rule_available ?compliance_rule)
        )
      )
  )
  (:action validate_order_with_compliance_rule
    :parameters (?treasury_entity - treasury_entity ?settlement_window - settlement_window ?consolidation_order - consolidation_order ?cash_forecast - cash_forecast ?compliance_rule - compliance_rule)
    :precondition
      (and
        (eligible_for_consolidation ?treasury_entity)
        (entity_settlement_window_link ?treasury_entity ?settlement_window)
        (settlement_window_allocated ?settlement_window)
        (settlement_window_order_link ?settlement_window ?consolidation_order)
        (entity_cash_forecast_link ?treasury_entity ?cash_forecast)
        (order_requires_approval ?consolidation_order)
        (entity_compliance_registered ?treasury_entity)
        (entity_compliance_rule_link ?treasury_entity ?compliance_rule)
        (not
          (entity_order_validated ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_order_validated ?treasury_entity)
        (entity_compliance_validated ?treasury_entity)
      )
  )
  (:action attach_approval_document_to_entity_for_order
    :parameters (?treasury_entity - treasury_entity ?approval_document - approval_document ?operator - operator ?settlement_window - settlement_window ?consolidation_order - consolidation_order)
    :precondition
      (and
        (entity_order_validated ?treasury_entity)
        (entity_approval_document_link ?treasury_entity ?approval_document)
        (entity_operator_assignment ?treasury_entity ?operator)
        (entity_settlement_window_link ?treasury_entity ?settlement_window)
        (settlement_window_order_link ?settlement_window ?consolidation_order)
        (not
          (order_requires_mandate ?consolidation_order)
        )
        (not
          (entity_approval_attached ?treasury_entity)
        )
      )
    :effect (entity_approval_attached ?treasury_entity)
  )
  (:action attach_approval_document_to_entity_for_order_with_flag
    :parameters (?treasury_entity - treasury_entity ?approval_document - approval_document ?operator - operator ?settlement_window - settlement_window ?consolidation_order - consolidation_order)
    :precondition
      (and
        (entity_order_validated ?treasury_entity)
        (entity_approval_document_link ?treasury_entity ?approval_document)
        (entity_operator_assignment ?treasury_entity ?operator)
        (entity_settlement_window_link ?treasury_entity ?settlement_window)
        (settlement_window_order_link ?settlement_window ?consolidation_order)
        (order_requires_mandate ?consolidation_order)
        (not
          (entity_approval_attached ?treasury_entity)
        )
      )
    :effect (entity_approval_attached ?treasury_entity)
  )
  (:action grant_entity_authorization_after_mandate
    :parameters (?treasury_entity - treasury_entity ?regulatory_constraint - regulatory_constraint ?settlement_window - settlement_window ?consolidation_order - consolidation_order)
    :precondition
      (and
        (entity_approval_attached ?treasury_entity)
        (entity_regulatory_constraint_link ?treasury_entity ?regulatory_constraint)
        (entity_settlement_window_link ?treasury_entity ?settlement_window)
        (settlement_window_order_link ?settlement_window ?consolidation_order)
        (not
          (order_requires_approval ?consolidation_order)
        )
        (not
          (order_requires_mandate ?consolidation_order)
        )
        (not
          (entity_authorized ?treasury_entity)
        )
      )
    :effect (entity_authorized ?treasury_entity)
  )
  (:action grant_entity_authorization_and_enable_reporting
    :parameters (?treasury_entity - treasury_entity ?regulatory_constraint - regulatory_constraint ?settlement_window - settlement_window ?consolidation_order - consolidation_order)
    :precondition
      (and
        (entity_approval_attached ?treasury_entity)
        (entity_regulatory_constraint_link ?treasury_entity ?regulatory_constraint)
        (entity_settlement_window_link ?treasury_entity ?settlement_window)
        (settlement_window_order_link ?settlement_window ?consolidation_order)
        (order_requires_approval ?consolidation_order)
        (not
          (order_requires_mandate ?consolidation_order)
        )
        (not
          (entity_authorized ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_authorized ?treasury_entity)
        (entity_reporting_enabled ?treasury_entity)
      )
  )
  (:action grant_entity_authorization_and_enable_reporting_alternate
    :parameters (?treasury_entity - treasury_entity ?regulatory_constraint - regulatory_constraint ?settlement_window - settlement_window ?consolidation_order - consolidation_order)
    :precondition
      (and
        (entity_approval_attached ?treasury_entity)
        (entity_regulatory_constraint_link ?treasury_entity ?regulatory_constraint)
        (entity_settlement_window_link ?treasury_entity ?settlement_window)
        (settlement_window_order_link ?settlement_window ?consolidation_order)
        (not
          (order_requires_approval ?consolidation_order)
        )
        (order_requires_mandate ?consolidation_order)
        (not
          (entity_authorized ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_authorized ?treasury_entity)
        (entity_reporting_enabled ?treasury_entity)
      )
  )
  (:action grant_entity_authorization_and_enable_reporting_full
    :parameters (?treasury_entity - treasury_entity ?regulatory_constraint - regulatory_constraint ?settlement_window - settlement_window ?consolidation_order - consolidation_order)
    :precondition
      (and
        (entity_approval_attached ?treasury_entity)
        (entity_regulatory_constraint_link ?treasury_entity ?regulatory_constraint)
        (entity_settlement_window_link ?treasury_entity ?settlement_window)
        (settlement_window_order_link ?settlement_window ?consolidation_order)
        (order_requires_approval ?consolidation_order)
        (order_requires_mandate ?consolidation_order)
        (not
          (entity_authorized ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_authorized ?treasury_entity)
        (entity_reporting_enabled ?treasury_entity)
      )
  )
  (:action finalize_entity_for_posting
    :parameters (?treasury_entity - treasury_entity)
    :precondition
      (and
        (entity_authorized ?treasury_entity)
        (not
          (entity_reporting_enabled ?treasury_entity)
        )
        (not
          (entity_finalized_for_posting ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_finalized_for_posting ?treasury_entity)
        (entity_ready_for_posting ?treasury_entity)
      )
  )
  (:action attach_reporting_template_to_entity
    :parameters (?treasury_entity - treasury_entity ?reporting_template - reporting_template)
    :precondition
      (and
        (entity_authorized ?treasury_entity)
        (entity_reporting_enabled ?treasury_entity)
        (reporting_template_available ?reporting_template)
      )
    :effect
      (and
        (entity_reporting_template_link ?treasury_entity ?reporting_template)
        (not
          (reporting_template_available ?reporting_template)
        )
      )
  )
  (:action prepare_entity_for_execution
    :parameters (?treasury_entity - treasury_entity ?operating_account - operating_account ?subsidiary_account - subsidiary_account ?cash_forecast - cash_forecast ?reporting_template - reporting_template)
    :precondition
      (and
        (entity_authorized ?treasury_entity)
        (entity_reporting_enabled ?treasury_entity)
        (entity_reporting_template_link ?treasury_entity ?reporting_template)
        (entity_operating_account_link ?treasury_entity ?operating_account)
        (entity_subsidiary_account_link ?treasury_entity ?subsidiary_account)
        (operating_account_liquidity_confirmed ?operating_account)
        (subsidiary_account_liquidity_confirmed ?subsidiary_account)
        (entity_cash_forecast_link ?treasury_entity ?cash_forecast)
        (not
          (entity_prepared_for_finalization ?treasury_entity)
        )
      )
    :effect (entity_prepared_for_finalization ?treasury_entity)
  )
  (:action finalize_entity_for_posting_after_preparation
    :parameters (?treasury_entity - treasury_entity)
    :precondition
      (and
        (entity_authorized ?treasury_entity)
        (entity_prepared_for_finalization ?treasury_entity)
        (not
          (entity_finalized_for_posting ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_finalized_for_posting ?treasury_entity)
        (entity_ready_for_posting ?treasury_entity)
      )
  )
  (:action acknowledge_external_mandate_for_entity
    :parameters (?treasury_entity - treasury_entity ?external_mandate - external_mandate ?cash_forecast - cash_forecast)
    :precondition
      (and
        (eligible_for_consolidation ?treasury_entity)
        (entity_cash_forecast_link ?treasury_entity ?cash_forecast)
        (external_mandate_available ?external_mandate)
        (entity_mandate_link ?treasury_entity ?external_mandate)
        (not
          (entity_mandate_acknowledged ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_mandate_acknowledged ?treasury_entity)
        (not
          (external_mandate_available ?external_mandate)
        )
      )
  )
  (:action process_external_mandate_for_entity
    :parameters (?treasury_entity - treasury_entity ?operator - operator)
    :precondition
      (and
        (entity_mandate_acknowledged ?treasury_entity)
        (entity_operator_assignment ?treasury_entity ?operator)
        (not
          (entity_mandate_processed ?treasury_entity)
        )
      )
    :effect (entity_mandate_processed ?treasury_entity)
  )
  (:action validate_mandate_against_regulatory_constraint
    :parameters (?treasury_entity - treasury_entity ?regulatory_constraint - regulatory_constraint)
    :precondition
      (and
        (entity_mandate_processed ?treasury_entity)
        (entity_regulatory_constraint_link ?treasury_entity ?regulatory_constraint)
        (not
          (entity_mandate_validated ?treasury_entity)
        )
      )
    :effect (entity_mandate_validated ?treasury_entity)
  )
  (:action finalize_entity_posting_after_mandate_validation
    :parameters (?treasury_entity - treasury_entity)
    :precondition
      (and
        (entity_mandate_validated ?treasury_entity)
        (not
          (entity_finalized_for_posting ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_finalized_for_posting ?treasury_entity)
        (entity_ready_for_posting ?treasury_entity)
      )
  )
  (:action post_consolidation_for_operating_account
    :parameters (?operating_account - operating_account ?consolidation_order - consolidation_order)
    :precondition
      (and
        (operating_account_checks_completed ?operating_account)
        (operating_account_liquidity_confirmed ?operating_account)
        (consolidation_order_allocated ?consolidation_order)
        (order_settlement_window_assigned ?consolidation_order)
        (not
          (entity_ready_for_posting ?operating_account)
        )
      )
    :effect (entity_ready_for_posting ?operating_account)
  )
  (:action post_consolidation_for_subsidiary_account
    :parameters (?subsidiary_account - subsidiary_account ?consolidation_order - consolidation_order)
    :precondition
      (and
        (subsidiary_account_checks_completed ?subsidiary_account)
        (subsidiary_account_liquidity_confirmed ?subsidiary_account)
        (consolidation_order_allocated ?consolidation_order)
        (order_settlement_window_assigned ?consolidation_order)
        (not
          (entity_ready_for_posting ?subsidiary_account)
        )
      )
    :effect (entity_ready_for_posting ?subsidiary_account)
  )
  (:action apply_buffer_profile_to_account
    :parameters (?account - account ?buffer_profile - buffer_profile ?cash_forecast - cash_forecast)
    :precondition
      (and
        (entity_ready_for_posting ?account)
        (entity_cash_forecast_link ?account ?cash_forecast)
        (buffer_profile_available ?buffer_profile)
        (not
          (entity_buffer_adjusted ?account)
        )
      )
    :effect
      (and
        (entity_buffer_adjusted ?account)
        (entity_buffer_profile_link ?account ?buffer_profile)
        (not
          (buffer_profile_available ?buffer_profile)
        )
      )
  )
  (:action finalize_operating_account_and_activate_channel
    :parameters (?operating_account - operating_account ?funding_channel - funding_channel ?buffer_profile - buffer_profile)
    :precondition
      (and
        (entity_buffer_adjusted ?operating_account)
        (entity_funding_channel_link ?operating_account ?funding_channel)
        (entity_buffer_profile_link ?operating_account ?buffer_profile)
        (not
          (entity_consolidation_finalized ?operating_account)
        )
      )
    :effect
      (and
        (entity_consolidation_finalized ?operating_account)
        (funding_channel_available ?funding_channel)
        (buffer_profile_available ?buffer_profile)
      )
  )
  (:action finalize_subsidiary_account_and_activate_channel
    :parameters (?subsidiary_account - subsidiary_account ?funding_channel - funding_channel ?buffer_profile - buffer_profile)
    :precondition
      (and
        (entity_buffer_adjusted ?subsidiary_account)
        (entity_funding_channel_link ?subsidiary_account ?funding_channel)
        (entity_buffer_profile_link ?subsidiary_account ?buffer_profile)
        (not
          (entity_consolidation_finalized ?subsidiary_account)
        )
      )
    :effect
      (and
        (entity_consolidation_finalized ?subsidiary_account)
        (funding_channel_available ?funding_channel)
        (buffer_profile_available ?buffer_profile)
      )
  )
  (:action finalize_entity_and_activate_channel
    :parameters (?treasury_entity - treasury_entity ?funding_channel - funding_channel ?buffer_profile - buffer_profile)
    :precondition
      (and
        (entity_buffer_adjusted ?treasury_entity)
        (entity_funding_channel_link ?treasury_entity ?funding_channel)
        (entity_buffer_profile_link ?treasury_entity ?buffer_profile)
        (not
          (entity_consolidation_finalized ?treasury_entity)
        )
      )
    :effect
      (and
        (entity_consolidation_finalized ?treasury_entity)
        (funding_channel_available ?funding_channel)
        (buffer_profile_available ?buffer_profile)
      )
  )
)

(define (domain payments_settlement_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types base_entity - object channel_and_control_category - base_entity auxiliary_resource_category - base_entity routing_and_settlement_category - base_entity instruction_root_category - base_entity payment_instruction - instruction_root_category settlement_channel_candidate - channel_and_control_category validation_rule - channel_and_control_category operator_role - channel_and_control_category fee_profile - channel_and_control_category compliance_profile - channel_and_control_category settlement_asset - channel_and_control_category authorization_token - channel_and_control_category approval_code - channel_and_control_category supplementary_asset - auxiliary_resource_category message_template - auxiliary_resource_category approval_method - auxiliary_resource_category same_day_channel - routing_and_settlement_category standard_channel - routing_and_settlement_category settlement_batch_unit - routing_and_settlement_category participant_processing_category - payment_instruction participant_workflow_category - payment_instruction payer_processing_context - participant_processing_category payee_processing_context - participant_processing_category clearing_participant_workflow - participant_workflow_category)

  (:predicates
    (instruction_registered ?payment_instruction - payment_instruction)
    (entity_validated ?payment_instruction - payment_instruction)
    (channel_candidate_assigned ?payment_instruction - payment_instruction)
    (released_for_settlement ?payment_instruction - payment_instruction)
    (entity_execution_ready ?payment_instruction - payment_instruction)
    (entity_settlement_asset_marked ?payment_instruction - payment_instruction)
    (channel_candidate_available ?settlement_channel_candidate - settlement_channel_candidate)
    (entity_assigned_settlement_channel ?payment_instruction - payment_instruction ?settlement_channel_candidate - settlement_channel_candidate)
    (validation_rule_available ?validation_rule - validation_rule)
    (entity_bound_validation_rule ?payment_instruction - payment_instruction ?validation_rule - validation_rule)
    (operator_available ?operator_role - operator_role)
    (entity_operator_assigned ?payment_instruction - payment_instruction ?operator_role - operator_role)
    (supplementary_asset_available ?supplementary_asset - supplementary_asset)
    (payer_supplementary_asset_bound ?payer_processing_context - payer_processing_context ?supplementary_asset - supplementary_asset)
    (payee_supplementary_asset_bound ?payee_processing_context - payee_processing_context ?supplementary_asset - supplementary_asset)
    (payer_channel_candidate_linked ?payer_processing_context - payer_processing_context ?same_day_channel - same_day_channel)
    (channel_prepared ?same_day_channel - same_day_channel)
    (channel_enriched ?same_day_channel - same_day_channel)
    (payer_ready ?payer_processing_context - payer_processing_context)
    (payee_channel_candidate_linked ?payee_processing_context - payee_processing_context ?standard_channel - standard_channel)
    (standard_channel_prepared ?standard_channel - standard_channel)
    (standard_channel_enriched ?standard_channel - standard_channel)
    (payee_ready ?payee_processing_context - payee_processing_context)
    (settlement_batch_unit_available ?settlement_batch_unit - settlement_batch_unit)
    (settlement_unit_active ?settlement_batch_unit - settlement_batch_unit)
    (settlement_unit_bound_same_day_channel ?settlement_batch_unit - settlement_batch_unit ?same_day_channel - same_day_channel)
    (settlement_unit_bound_standard_channel ?settlement_batch_unit - settlement_batch_unit ?standard_channel - standard_channel)
    (settlement_unit_route_primary ?settlement_batch_unit - settlement_batch_unit)
    (settlement_unit_route_secondary ?settlement_batch_unit - settlement_batch_unit)
    (settlement_unit_finalized ?settlement_batch_unit - settlement_batch_unit)
    (workflow_bound_to_payer_context ?clearing_participant_workflow - clearing_participant_workflow ?payer_processing_context - payer_processing_context)
    (workflow_bound_to_payee_context ?clearing_participant_workflow - clearing_participant_workflow ?payee_processing_context - payee_processing_context)
    (workflow_bound_to_settlement_unit ?clearing_participant_workflow - clearing_participant_workflow ?settlement_batch_unit - settlement_batch_unit)
    (message_template_available ?message_template - message_template)
    (workflow_bound_to_template ?clearing_participant_workflow - clearing_participant_workflow ?message_template - message_template)
    (message_template_consumed ?message_template - message_template)
    (template_bound_to_settlement_unit ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit)
    (workflow_enrichment_phase1_complete ?clearing_participant_workflow - clearing_participant_workflow)
    (workflow_enrichment_phase2_complete ?clearing_participant_workflow - clearing_participant_workflow)
    (workflow_ready_for_execution ?clearing_participant_workflow - clearing_participant_workflow)
    (workflow_fee_profile_active ?clearing_participant_workflow - clearing_participant_workflow)
    (workflow_template_variant_applied ?clearing_participant_workflow - clearing_participant_workflow)
    (workflow_requires_compliance_profile ?clearing_participant_workflow - clearing_participant_workflow)
    (workflow_enrichment_finalized ?clearing_participant_workflow - clearing_participant_workflow)
    (approval_method_available ?approval_method - approval_method)
    (workflow_approval_method_bound ?clearing_participant_workflow - clearing_participant_workflow ?approval_method - approval_method)
    (workflow_approval_requested ?clearing_participant_workflow - clearing_participant_workflow)
    (workflow_approval_in_progress ?clearing_participant_workflow - clearing_participant_workflow)
    (workflow_approval_granted ?clearing_participant_workflow - clearing_participant_workflow)
    (fee_profile_available ?fee_profile - fee_profile)
    (workflow_fee_profile_bound ?clearing_participant_workflow - clearing_participant_workflow ?fee_profile - fee_profile)
    (compliance_profile_available ?compliance_profile - compliance_profile)
    (workflow_compliance_profile_bound ?clearing_participant_workflow - clearing_participant_workflow ?compliance_profile - compliance_profile)
    (authorization_token_available ?authorization_token - authorization_token)
    (workflow_authorization_token_bound ?clearing_participant_workflow - clearing_participant_workflow ?authorization_token - authorization_token)
    (approval_code_available ?approval_code - approval_code)
    (workflow_approval_code_bound ?clearing_participant_workflow - clearing_participant_workflow ?approval_code - approval_code)
    (settlement_asset_available ?settlement_asset - settlement_asset)
    (entity_bound_settlement_asset ?payment_instruction - payment_instruction ?settlement_asset - settlement_asset)
    (payer_hold_placed ?payer_processing_context - payer_processing_context)
    (payee_hold_placed ?payee_processing_context - payee_processing_context)
    (workflow_completion_recorded ?clearing_participant_workflow - clearing_participant_workflow)
  )
  (:action register_payment_instruction
    :parameters (?payment_instruction - payment_instruction)
    :precondition
      (and
        (not
          (instruction_registered ?payment_instruction)
        )
        (not
          (released_for_settlement ?payment_instruction)
        )
      )
    :effect (instruction_registered ?payment_instruction)
  )
  (:action assign_settlement_channel_candidate
    :parameters (?payment_instruction - payment_instruction ?settlement_channel_candidate - settlement_channel_candidate)
    :precondition
      (and
        (instruction_registered ?payment_instruction)
        (not
          (channel_candidate_assigned ?payment_instruction)
        )
        (channel_candidate_available ?settlement_channel_candidate)
      )
    :effect
      (and
        (channel_candidate_assigned ?payment_instruction)
        (entity_assigned_settlement_channel ?payment_instruction ?settlement_channel_candidate)
        (not
          (channel_candidate_available ?settlement_channel_candidate)
        )
      )
  )
  (:action apply_validation_rule
    :parameters (?payment_instruction - payment_instruction ?validation_rule - validation_rule)
    :precondition
      (and
        (instruction_registered ?payment_instruction)
        (channel_candidate_assigned ?payment_instruction)
        (validation_rule_available ?validation_rule)
      )
    :effect
      (and
        (entity_bound_validation_rule ?payment_instruction ?validation_rule)
        (not
          (validation_rule_available ?validation_rule)
        )
      )
  )
  (:action finalize_validation
    :parameters (?payment_instruction - payment_instruction ?validation_rule - validation_rule)
    :precondition
      (and
        (instruction_registered ?payment_instruction)
        (channel_candidate_assigned ?payment_instruction)
        (entity_bound_validation_rule ?payment_instruction ?validation_rule)
        (not
          (entity_validated ?payment_instruction)
        )
      )
    :effect (entity_validated ?payment_instruction)
  )
  (:action revert_validation_binding
    :parameters (?payment_instruction - payment_instruction ?validation_rule - validation_rule)
    :precondition
      (and
        (entity_bound_validation_rule ?payment_instruction ?validation_rule)
      )
    :effect
      (and
        (validation_rule_available ?validation_rule)
        (not
          (entity_bound_validation_rule ?payment_instruction ?validation_rule)
        )
      )
  )
  (:action assign_operator_to_instruction
    :parameters (?payment_instruction - payment_instruction ?operator_role - operator_role)
    :precondition
      (and
        (entity_validated ?payment_instruction)
        (operator_available ?operator_role)
      )
    :effect
      (and
        (entity_operator_assigned ?payment_instruction ?operator_role)
        (not
          (operator_available ?operator_role)
        )
      )
  )
  (:action release_operator_assignment
    :parameters (?payment_instruction - payment_instruction ?operator_role - operator_role)
    :precondition
      (and
        (entity_operator_assigned ?payment_instruction ?operator_role)
      )
    :effect
      (and
        (operator_available ?operator_role)
        (not
          (entity_operator_assigned ?payment_instruction ?operator_role)
        )
      )
  )
  (:action bind_authorization_token_to_workflow
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?authorization_token - authorization_token)
    :precondition
      (and
        (entity_validated ?clearing_participant_workflow)
        (authorization_token_available ?authorization_token)
      )
    :effect
      (and
        (workflow_authorization_token_bound ?clearing_participant_workflow ?authorization_token)
        (not
          (authorization_token_available ?authorization_token)
        )
      )
  )
  (:action release_authorization_token
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?authorization_token - authorization_token)
    :precondition
      (and
        (workflow_authorization_token_bound ?clearing_participant_workflow ?authorization_token)
      )
    :effect
      (and
        (authorization_token_available ?authorization_token)
        (not
          (workflow_authorization_token_bound ?clearing_participant_workflow ?authorization_token)
        )
      )
  )
  (:action bind_approval_code_to_workflow
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?approval_code - approval_code)
    :precondition
      (and
        (entity_validated ?clearing_participant_workflow)
        (approval_code_available ?approval_code)
      )
    :effect
      (and
        (workflow_approval_code_bound ?clearing_participant_workflow ?approval_code)
        (not
          (approval_code_available ?approval_code)
        )
      )
  )
  (:action release_approval_code_from_workflow
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?approval_code - approval_code)
    :precondition
      (and
        (workflow_approval_code_bound ?clearing_participant_workflow ?approval_code)
      )
    :effect
      (and
        (approval_code_available ?approval_code)
        (not
          (workflow_approval_code_bound ?clearing_participant_workflow ?approval_code)
        )
      )
  )
  (:action prepare_same_day_channel
    :parameters (?payer_processing_context - payer_processing_context ?same_day_channel - same_day_channel ?validation_rule - validation_rule)
    :precondition
      (and
        (entity_validated ?payer_processing_context)
        (entity_bound_validation_rule ?payer_processing_context ?validation_rule)
        (payer_channel_candidate_linked ?payer_processing_context ?same_day_channel)
        (not
          (channel_prepared ?same_day_channel)
        )
        (not
          (channel_enriched ?same_day_channel)
        )
      )
    :effect (channel_prepared ?same_day_channel)
  )
  (:action confirm_payer_readiness
    :parameters (?payer_processing_context - payer_processing_context ?same_day_channel - same_day_channel ?operator_role - operator_role)
    :precondition
      (and
        (entity_validated ?payer_processing_context)
        (entity_operator_assigned ?payer_processing_context ?operator_role)
        (payer_channel_candidate_linked ?payer_processing_context ?same_day_channel)
        (channel_prepared ?same_day_channel)
        (not
          (payer_hold_placed ?payer_processing_context)
        )
      )
    :effect
      (and
        (payer_hold_placed ?payer_processing_context)
        (payer_ready ?payer_processing_context)
      )
  )
  (:action apply_supplementary_asset_to_payer_context
    :parameters (?payer_processing_context - payer_processing_context ?same_day_channel - same_day_channel ?supplementary_asset - supplementary_asset)
    :precondition
      (and
        (entity_validated ?payer_processing_context)
        (payer_channel_candidate_linked ?payer_processing_context ?same_day_channel)
        (supplementary_asset_available ?supplementary_asset)
        (not
          (payer_hold_placed ?payer_processing_context)
        )
      )
    :effect
      (and
        (channel_enriched ?same_day_channel)
        (payer_hold_placed ?payer_processing_context)
        (payer_supplementary_asset_bound ?payer_processing_context ?supplementary_asset)
        (not
          (supplementary_asset_available ?supplementary_asset)
        )
      )
  )
  (:action finalize_payer_preprocessing
    :parameters (?payer_processing_context - payer_processing_context ?same_day_channel - same_day_channel ?validation_rule - validation_rule ?supplementary_asset - supplementary_asset)
    :precondition
      (and
        (entity_validated ?payer_processing_context)
        (entity_bound_validation_rule ?payer_processing_context ?validation_rule)
        (payer_channel_candidate_linked ?payer_processing_context ?same_day_channel)
        (channel_enriched ?same_day_channel)
        (payer_supplementary_asset_bound ?payer_processing_context ?supplementary_asset)
        (not
          (payer_ready ?payer_processing_context)
        )
      )
    :effect
      (and
        (channel_prepared ?same_day_channel)
        (payer_ready ?payer_processing_context)
        (supplementary_asset_available ?supplementary_asset)
        (not
          (payer_supplementary_asset_bound ?payer_processing_context ?supplementary_asset)
        )
      )
  )
  (:action prepare_standard_channel_for_payee
    :parameters (?payee_processing_context - payee_processing_context ?standard_channel - standard_channel ?validation_rule - validation_rule)
    :precondition
      (and
        (entity_validated ?payee_processing_context)
        (entity_bound_validation_rule ?payee_processing_context ?validation_rule)
        (payee_channel_candidate_linked ?payee_processing_context ?standard_channel)
        (not
          (standard_channel_prepared ?standard_channel)
        )
        (not
          (standard_channel_enriched ?standard_channel)
        )
      )
    :effect (standard_channel_prepared ?standard_channel)
  )
  (:action confirm_payee_readiness
    :parameters (?payee_processing_context - payee_processing_context ?standard_channel - standard_channel ?operator_role - operator_role)
    :precondition
      (and
        (entity_validated ?payee_processing_context)
        (entity_operator_assigned ?payee_processing_context ?operator_role)
        (payee_channel_candidate_linked ?payee_processing_context ?standard_channel)
        (standard_channel_prepared ?standard_channel)
        (not
          (payee_hold_placed ?payee_processing_context)
        )
      )
    :effect
      (and
        (payee_hold_placed ?payee_processing_context)
        (payee_ready ?payee_processing_context)
      )
  )
  (:action apply_supplementary_asset_to_payee_context
    :parameters (?payee_processing_context - payee_processing_context ?standard_channel - standard_channel ?supplementary_asset - supplementary_asset)
    :precondition
      (and
        (entity_validated ?payee_processing_context)
        (payee_channel_candidate_linked ?payee_processing_context ?standard_channel)
        (supplementary_asset_available ?supplementary_asset)
        (not
          (payee_hold_placed ?payee_processing_context)
        )
      )
    :effect
      (and
        (standard_channel_enriched ?standard_channel)
        (payee_hold_placed ?payee_processing_context)
        (payee_supplementary_asset_bound ?payee_processing_context ?supplementary_asset)
        (not
          (supplementary_asset_available ?supplementary_asset)
        )
      )
  )
  (:action finalize_payee_preprocessing
    :parameters (?payee_processing_context - payee_processing_context ?standard_channel - standard_channel ?validation_rule - validation_rule ?supplementary_asset - supplementary_asset)
    :precondition
      (and
        (entity_validated ?payee_processing_context)
        (entity_bound_validation_rule ?payee_processing_context ?validation_rule)
        (payee_channel_candidate_linked ?payee_processing_context ?standard_channel)
        (standard_channel_enriched ?standard_channel)
        (payee_supplementary_asset_bound ?payee_processing_context ?supplementary_asset)
        (not
          (payee_ready ?payee_processing_context)
        )
      )
    :effect
      (and
        (standard_channel_prepared ?standard_channel)
        (payee_ready ?payee_processing_context)
        (supplementary_asset_available ?supplementary_asset)
        (not
          (payee_supplementary_asset_bound ?payee_processing_context ?supplementary_asset)
        )
      )
  )
  (:action assemble_settlement_unit_default
    :parameters (?payer_processing_context - payer_processing_context ?payee_processing_context - payee_processing_context ?same_day_channel - same_day_channel ?standard_channel - standard_channel ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (payer_hold_placed ?payer_processing_context)
        (payee_hold_placed ?payee_processing_context)
        (payer_channel_candidate_linked ?payer_processing_context ?same_day_channel)
        (payee_channel_candidate_linked ?payee_processing_context ?standard_channel)
        (channel_prepared ?same_day_channel)
        (standard_channel_prepared ?standard_channel)
        (payer_ready ?payer_processing_context)
        (payee_ready ?payee_processing_context)
        (settlement_batch_unit_available ?settlement_batch_unit)
      )
    :effect
      (and
        (settlement_unit_active ?settlement_batch_unit)
        (settlement_unit_bound_same_day_channel ?settlement_batch_unit ?same_day_channel)
        (settlement_unit_bound_standard_channel ?settlement_batch_unit ?standard_channel)
        (not
          (settlement_batch_unit_available ?settlement_batch_unit)
        )
      )
  )
  (:action assemble_settlement_unit_primary_route
    :parameters (?payer_processing_context - payer_processing_context ?payee_processing_context - payee_processing_context ?same_day_channel - same_day_channel ?standard_channel - standard_channel ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (payer_hold_placed ?payer_processing_context)
        (payee_hold_placed ?payee_processing_context)
        (payer_channel_candidate_linked ?payer_processing_context ?same_day_channel)
        (payee_channel_candidate_linked ?payee_processing_context ?standard_channel)
        (channel_enriched ?same_day_channel)
        (standard_channel_prepared ?standard_channel)
        (not
          (payer_ready ?payer_processing_context)
        )
        (payee_ready ?payee_processing_context)
        (settlement_batch_unit_available ?settlement_batch_unit)
      )
    :effect
      (and
        (settlement_unit_active ?settlement_batch_unit)
        (settlement_unit_bound_same_day_channel ?settlement_batch_unit ?same_day_channel)
        (settlement_unit_bound_standard_channel ?settlement_batch_unit ?standard_channel)
        (settlement_unit_route_primary ?settlement_batch_unit)
        (not
          (settlement_batch_unit_available ?settlement_batch_unit)
        )
      )
  )
  (:action assemble_settlement_unit_secondary_route
    :parameters (?payer_processing_context - payer_processing_context ?payee_processing_context - payee_processing_context ?same_day_channel - same_day_channel ?standard_channel - standard_channel ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (payer_hold_placed ?payer_processing_context)
        (payee_hold_placed ?payee_processing_context)
        (payer_channel_candidate_linked ?payer_processing_context ?same_day_channel)
        (payee_channel_candidate_linked ?payee_processing_context ?standard_channel)
        (channel_prepared ?same_day_channel)
        (standard_channel_enriched ?standard_channel)
        (payer_ready ?payer_processing_context)
        (not
          (payee_ready ?payee_processing_context)
        )
        (settlement_batch_unit_available ?settlement_batch_unit)
      )
    :effect
      (and
        (settlement_unit_active ?settlement_batch_unit)
        (settlement_unit_bound_same_day_channel ?settlement_batch_unit ?same_day_channel)
        (settlement_unit_bound_standard_channel ?settlement_batch_unit ?standard_channel)
        (settlement_unit_route_secondary ?settlement_batch_unit)
        (not
          (settlement_batch_unit_available ?settlement_batch_unit)
        )
      )
  )
  (:action assemble_settlement_unit_both_routes
    :parameters (?payer_processing_context - payer_processing_context ?payee_processing_context - payee_processing_context ?same_day_channel - same_day_channel ?standard_channel - standard_channel ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (payer_hold_placed ?payer_processing_context)
        (payee_hold_placed ?payee_processing_context)
        (payer_channel_candidate_linked ?payer_processing_context ?same_day_channel)
        (payee_channel_candidate_linked ?payee_processing_context ?standard_channel)
        (channel_enriched ?same_day_channel)
        (standard_channel_enriched ?standard_channel)
        (not
          (payer_ready ?payer_processing_context)
        )
        (not
          (payee_ready ?payee_processing_context)
        )
        (settlement_batch_unit_available ?settlement_batch_unit)
      )
    :effect
      (and
        (settlement_unit_active ?settlement_batch_unit)
        (settlement_unit_bound_same_day_channel ?settlement_batch_unit ?same_day_channel)
        (settlement_unit_bound_standard_channel ?settlement_batch_unit ?standard_channel)
        (settlement_unit_route_primary ?settlement_batch_unit)
        (settlement_unit_route_secondary ?settlement_batch_unit)
        (not
          (settlement_batch_unit_available ?settlement_batch_unit)
        )
      )
  )
  (:action finalize_settlement_unit
    :parameters (?settlement_batch_unit - settlement_batch_unit ?payer_processing_context - payer_processing_context ?validation_rule - validation_rule)
    :precondition
      (and
        (settlement_unit_active ?settlement_batch_unit)
        (payer_hold_placed ?payer_processing_context)
        (entity_bound_validation_rule ?payer_processing_context ?validation_rule)
        (not
          (settlement_unit_finalized ?settlement_batch_unit)
        )
      )
    :effect (settlement_unit_finalized ?settlement_batch_unit)
  )
  (:action apply_message_template_to_settlement_unit
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (entity_validated ?clearing_participant_workflow)
        (workflow_bound_to_settlement_unit ?clearing_participant_workflow ?settlement_batch_unit)
        (workflow_bound_to_template ?clearing_participant_workflow ?message_template)
        (message_template_available ?message_template)
        (settlement_unit_active ?settlement_batch_unit)
        (settlement_unit_finalized ?settlement_batch_unit)
        (not
          (message_template_consumed ?message_template)
        )
      )
    :effect
      (and
        (message_template_consumed ?message_template)
        (template_bound_to_settlement_unit ?message_template ?settlement_batch_unit)
        (not
          (message_template_available ?message_template)
        )
      )
  )
  (:action start_workflow_enrichment_phase1
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit ?validation_rule - validation_rule)
    :precondition
      (and
        (entity_validated ?clearing_participant_workflow)
        (workflow_bound_to_template ?clearing_participant_workflow ?message_template)
        (message_template_consumed ?message_template)
        (template_bound_to_settlement_unit ?message_template ?settlement_batch_unit)
        (entity_bound_validation_rule ?clearing_participant_workflow ?validation_rule)
        (not
          (settlement_unit_route_primary ?settlement_batch_unit)
        )
        (not
          (workflow_enrichment_phase1_complete ?clearing_participant_workflow)
        )
      )
    :effect (workflow_enrichment_phase1_complete ?clearing_participant_workflow)
  )
  (:action bind_fee_profile_to_workflow
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?fee_profile - fee_profile)
    :precondition
      (and
        (entity_validated ?clearing_participant_workflow)
        (fee_profile_available ?fee_profile)
        (not
          (workflow_fee_profile_active ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (workflow_fee_profile_active ?clearing_participant_workflow)
        (workflow_fee_profile_bound ?clearing_participant_workflow ?fee_profile)
        (not
          (fee_profile_available ?fee_profile)
        )
      )
  )
  (:action apply_template_variant_and_fee_to_workflow
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit ?validation_rule - validation_rule ?fee_profile - fee_profile)
    :precondition
      (and
        (entity_validated ?clearing_participant_workflow)
        (workflow_bound_to_template ?clearing_participant_workflow ?message_template)
        (message_template_consumed ?message_template)
        (template_bound_to_settlement_unit ?message_template ?settlement_batch_unit)
        (entity_bound_validation_rule ?clearing_participant_workflow ?validation_rule)
        (settlement_unit_route_primary ?settlement_batch_unit)
        (workflow_fee_profile_active ?clearing_participant_workflow)
        (workflow_fee_profile_bound ?clearing_participant_workflow ?fee_profile)
        (not
          (workflow_enrichment_phase1_complete ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (workflow_enrichment_phase1_complete ?clearing_participant_workflow)
        (workflow_template_variant_applied ?clearing_participant_workflow)
      )
  )
  (:action complete_workflow_enrichment_primary
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?authorization_token - authorization_token ?operator_role - operator_role ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (workflow_enrichment_phase1_complete ?clearing_participant_workflow)
        (workflow_authorization_token_bound ?clearing_participant_workflow ?authorization_token)
        (entity_operator_assigned ?clearing_participant_workflow ?operator_role)
        (workflow_bound_to_template ?clearing_participant_workflow ?message_template)
        (template_bound_to_settlement_unit ?message_template ?settlement_batch_unit)
        (not
          (settlement_unit_route_secondary ?settlement_batch_unit)
        )
        (not
          (workflow_enrichment_phase2_complete ?clearing_participant_workflow)
        )
      )
    :effect (workflow_enrichment_phase2_complete ?clearing_participant_workflow)
  )
  (:action complete_workflow_enrichment_secondary
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?authorization_token - authorization_token ?operator_role - operator_role ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (workflow_enrichment_phase1_complete ?clearing_participant_workflow)
        (workflow_authorization_token_bound ?clearing_participant_workflow ?authorization_token)
        (entity_operator_assigned ?clearing_participant_workflow ?operator_role)
        (workflow_bound_to_template ?clearing_participant_workflow ?message_template)
        (template_bound_to_settlement_unit ?message_template ?settlement_batch_unit)
        (settlement_unit_route_secondary ?settlement_batch_unit)
        (not
          (workflow_enrichment_phase2_complete ?clearing_participant_workflow)
        )
      )
    :effect (workflow_enrichment_phase2_complete ?clearing_participant_workflow)
  )
  (:action authorize_workflow_standard
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?approval_code - approval_code ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (workflow_enrichment_phase2_complete ?clearing_participant_workflow)
        (workflow_approval_code_bound ?clearing_participant_workflow ?approval_code)
        (workflow_bound_to_template ?clearing_participant_workflow ?message_template)
        (template_bound_to_settlement_unit ?message_template ?settlement_batch_unit)
        (not
          (settlement_unit_route_primary ?settlement_batch_unit)
        )
        (not
          (settlement_unit_route_secondary ?settlement_batch_unit)
        )
        (not
          (workflow_ready_for_execution ?clearing_participant_workflow)
        )
      )
    :effect (workflow_ready_for_execution ?clearing_participant_workflow)
  )
  (:action authorize_workflow_primary_route
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?approval_code - approval_code ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (workflow_enrichment_phase2_complete ?clearing_participant_workflow)
        (workflow_approval_code_bound ?clearing_participant_workflow ?approval_code)
        (workflow_bound_to_template ?clearing_participant_workflow ?message_template)
        (template_bound_to_settlement_unit ?message_template ?settlement_batch_unit)
        (settlement_unit_route_primary ?settlement_batch_unit)
        (not
          (settlement_unit_route_secondary ?settlement_batch_unit)
        )
        (not
          (workflow_ready_for_execution ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (workflow_ready_for_execution ?clearing_participant_workflow)
        (workflow_requires_compliance_profile ?clearing_participant_workflow)
      )
  )
  (:action authorize_workflow_secondary_route
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?approval_code - approval_code ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (workflow_enrichment_phase2_complete ?clearing_participant_workflow)
        (workflow_approval_code_bound ?clearing_participant_workflow ?approval_code)
        (workflow_bound_to_template ?clearing_participant_workflow ?message_template)
        (template_bound_to_settlement_unit ?message_template ?settlement_batch_unit)
        (not
          (settlement_unit_route_primary ?settlement_batch_unit)
        )
        (settlement_unit_route_secondary ?settlement_batch_unit)
        (not
          (workflow_ready_for_execution ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (workflow_ready_for_execution ?clearing_participant_workflow)
        (workflow_requires_compliance_profile ?clearing_participant_workflow)
      )
  )
  (:action authorize_workflow_both_routes
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?approval_code - approval_code ?message_template - message_template ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (workflow_enrichment_phase2_complete ?clearing_participant_workflow)
        (workflow_approval_code_bound ?clearing_participant_workflow ?approval_code)
        (workflow_bound_to_template ?clearing_participant_workflow ?message_template)
        (template_bound_to_settlement_unit ?message_template ?settlement_batch_unit)
        (settlement_unit_route_primary ?settlement_batch_unit)
        (settlement_unit_route_secondary ?settlement_batch_unit)
        (not
          (workflow_ready_for_execution ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (workflow_ready_for_execution ?clearing_participant_workflow)
        (workflow_requires_compliance_profile ?clearing_participant_workflow)
      )
  )
  (:action finalize_workflow_and_mark_execution_ready
    :parameters (?clearing_participant_workflow - clearing_participant_workflow)
    :precondition
      (and
        (workflow_ready_for_execution ?clearing_participant_workflow)
        (not
          (workflow_requires_compliance_profile ?clearing_participant_workflow)
        )
        (not
          (workflow_completion_recorded ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (workflow_completion_recorded ?clearing_participant_workflow)
        (entity_execution_ready ?clearing_participant_workflow)
      )
  )
  (:action bind_compliance_profile_to_workflow
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?compliance_profile - compliance_profile)
    :precondition
      (and
        (workflow_ready_for_execution ?clearing_participant_workflow)
        (workflow_requires_compliance_profile ?clearing_participant_workflow)
        (compliance_profile_available ?compliance_profile)
      )
    :effect
      (and
        (workflow_compliance_profile_bound ?clearing_participant_workflow ?compliance_profile)
        (not
          (compliance_profile_available ?compliance_profile)
        )
      )
  )
  (:action complete_workflow_enrichment_and_prepare_for_execution
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?payer_processing_context - payer_processing_context ?payee_processing_context - payee_processing_context ?validation_rule - validation_rule ?compliance_profile - compliance_profile)
    :precondition
      (and
        (workflow_ready_for_execution ?clearing_participant_workflow)
        (workflow_requires_compliance_profile ?clearing_participant_workflow)
        (workflow_compliance_profile_bound ?clearing_participant_workflow ?compliance_profile)
        (workflow_bound_to_payer_context ?clearing_participant_workflow ?payer_processing_context)
        (workflow_bound_to_payee_context ?clearing_participant_workflow ?payee_processing_context)
        (payer_ready ?payer_processing_context)
        (payee_ready ?payee_processing_context)
        (entity_bound_validation_rule ?clearing_participant_workflow ?validation_rule)
        (not
          (workflow_enrichment_finalized ?clearing_participant_workflow)
        )
      )
    :effect (workflow_enrichment_finalized ?clearing_participant_workflow)
  )
  (:action record_workflow_completion_and_mark_execution_ready
    :parameters (?clearing_participant_workflow - clearing_participant_workflow)
    :precondition
      (and
        (workflow_ready_for_execution ?clearing_participant_workflow)
        (workflow_enrichment_finalized ?clearing_participant_workflow)
        (not
          (workflow_completion_recorded ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (workflow_completion_recorded ?clearing_participant_workflow)
        (entity_execution_ready ?clearing_participant_workflow)
      )
  )
  (:action request_workflow_approval
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?approval_method - approval_method ?validation_rule - validation_rule)
    :precondition
      (and
        (entity_validated ?clearing_participant_workflow)
        (entity_bound_validation_rule ?clearing_participant_workflow ?validation_rule)
        (approval_method_available ?approval_method)
        (workflow_approval_method_bound ?clearing_participant_workflow ?approval_method)
        (not
          (workflow_approval_requested ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (workflow_approval_requested ?clearing_participant_workflow)
        (not
          (approval_method_available ?approval_method)
        )
      )
  )
  (:action confirm_workflow_approval_request
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?operator_role - operator_role)
    :precondition
      (and
        (workflow_approval_requested ?clearing_participant_workflow)
        (entity_operator_assigned ?clearing_participant_workflow ?operator_role)
        (not
          (workflow_approval_in_progress ?clearing_participant_workflow)
        )
      )
    :effect (workflow_approval_in_progress ?clearing_participant_workflow)
  )
  (:action finalize_workflow_approval
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?approval_code - approval_code)
    :precondition
      (and
        (workflow_approval_in_progress ?clearing_participant_workflow)
        (workflow_approval_code_bound ?clearing_participant_workflow ?approval_code)
        (not
          (workflow_approval_granted ?clearing_participant_workflow)
        )
      )
    :effect (workflow_approval_granted ?clearing_participant_workflow)
  )
  (:action complete_workflow_approval
    :parameters (?clearing_participant_workflow - clearing_participant_workflow)
    :precondition
      (and
        (workflow_approval_granted ?clearing_participant_workflow)
        (not
          (workflow_completion_recorded ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (workflow_completion_recorded ?clearing_participant_workflow)
        (entity_execution_ready ?clearing_participant_workflow)
      )
  )
  (:action execute_settlement_for_payer
    :parameters (?payer_processing_context - payer_processing_context ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (payer_hold_placed ?payer_processing_context)
        (payer_ready ?payer_processing_context)
        (settlement_unit_active ?settlement_batch_unit)
        (settlement_unit_finalized ?settlement_batch_unit)
        (not
          (entity_execution_ready ?payer_processing_context)
        )
      )
    :effect (entity_execution_ready ?payer_processing_context)
  )
  (:action execute_settlement_for_payee
    :parameters (?payee_processing_context - payee_processing_context ?settlement_batch_unit - settlement_batch_unit)
    :precondition
      (and
        (payee_hold_placed ?payee_processing_context)
        (payee_ready ?payee_processing_context)
        (settlement_unit_active ?settlement_batch_unit)
        (settlement_unit_finalized ?settlement_batch_unit)
        (not
          (entity_execution_ready ?payee_processing_context)
        )
      )
    :effect (entity_execution_ready ?payee_processing_context)
  )
  (:action bind_settlement_asset_to_instruction
    :parameters (?payment_instruction - payment_instruction ?settlement_asset - settlement_asset ?validation_rule - validation_rule)
    :precondition
      (and
        (entity_execution_ready ?payment_instruction)
        (entity_bound_validation_rule ?payment_instruction ?validation_rule)
        (settlement_asset_available ?settlement_asset)
        (not
          (entity_settlement_asset_marked ?payment_instruction)
        )
      )
    :effect
      (and
        (entity_settlement_asset_marked ?payment_instruction)
        (entity_bound_settlement_asset ?payment_instruction ?settlement_asset)
        (not
          (settlement_asset_available ?settlement_asset)
        )
      )
  )
  (:action release_instruction_to_channel_for_payer
    :parameters (?payer_processing_context - payer_processing_context ?settlement_channel_candidate - settlement_channel_candidate ?settlement_asset - settlement_asset)
    :precondition
      (and
        (entity_settlement_asset_marked ?payer_processing_context)
        (entity_assigned_settlement_channel ?payer_processing_context ?settlement_channel_candidate)
        (entity_bound_settlement_asset ?payer_processing_context ?settlement_asset)
        (not
          (released_for_settlement ?payer_processing_context)
        )
      )
    :effect
      (and
        (released_for_settlement ?payer_processing_context)
        (channel_candidate_available ?settlement_channel_candidate)
        (settlement_asset_available ?settlement_asset)
      )
  )
  (:action release_instruction_to_channel_for_payee
    :parameters (?payee_processing_context - payee_processing_context ?settlement_channel_candidate - settlement_channel_candidate ?settlement_asset - settlement_asset)
    :precondition
      (and
        (entity_settlement_asset_marked ?payee_processing_context)
        (entity_assigned_settlement_channel ?payee_processing_context ?settlement_channel_candidate)
        (entity_bound_settlement_asset ?payee_processing_context ?settlement_asset)
        (not
          (released_for_settlement ?payee_processing_context)
        )
      )
    :effect
      (and
        (released_for_settlement ?payee_processing_context)
        (channel_candidate_available ?settlement_channel_candidate)
        (settlement_asset_available ?settlement_asset)
      )
  )
  (:action release_instruction_to_channel_for_workflow
    :parameters (?clearing_participant_workflow - clearing_participant_workflow ?settlement_channel_candidate - settlement_channel_candidate ?settlement_asset - settlement_asset)
    :precondition
      (and
        (entity_settlement_asset_marked ?clearing_participant_workflow)
        (entity_assigned_settlement_channel ?clearing_participant_workflow ?settlement_channel_candidate)
        (entity_bound_settlement_asset ?clearing_participant_workflow ?settlement_asset)
        (not
          (released_for_settlement ?clearing_participant_workflow)
        )
      )
    :effect
      (and
        (released_for_settlement ?clearing_participant_workflow)
        (channel_candidate_available ?settlement_channel_candidate)
        (settlement_asset_available ?settlement_asset)
      )
  )
)

(define (domain structured_input_parsing_and_normalization)
  (:requirements :strips :typing :negative-preconditions)
  (:types processing_component - object extractor_component - object validator_component - object document_type - object input_record - document_type field_mapper - processing_component field_token - processing_component parser_module - processing_component format_option - processing_component postprocess_option - processing_component context_token - processing_component schema_annotation - processing_component external_reference - processing_component normalization_rule - extractor_component temporary_buffer - extractor_component lookup_entry - extractor_component primary_key - validator_component secondary_key - validator_component output_slot - validator_component record_group - input_record subgroup - input_record primary_block - record_group secondary_block - record_group profile - subgroup)
  (:predicates
    (record_registered ?input_record - input_record)
    (is_ready ?input_record - input_record)
    (mapper_assigned ?input_record - input_record)
    (is_finalized ?input_record - input_record)
    (ready_for_mapping ?input_record - input_record)
    (is_normalized ?input_record - input_record)
    (mapper_available ?field_mapper - field_mapper)
    (mapper_bound_to_entity ?input_record - input_record ?field_mapper - field_mapper)
    (token_available ?field_token - field_token)
    (token_bound_to_entity ?input_record - input_record ?field_token - field_token)
    (parser_available ?parser_module - parser_module)
    (parser_bound_to_entity ?input_record - input_record ?parser_module - parser_module)
    (normalization_rule_available ?normalization_rule - normalization_rule)
    (primary_block_has_normalization_rule ?primary_block - primary_block ?normalization_rule - normalization_rule)
    (secondary_block_has_normalization_rule ?secondary_block - secondary_block ?normalization_rule - normalization_rule)
    (block_has_primary_key ?primary_block - primary_block ?primary_key - primary_key)
    (primary_key_selected ?primary_key - primary_key)
    (primary_key_reserved ?primary_key - primary_key)
    (block_prepared ?primary_block - primary_block)
    (secondary_block_has_key ?secondary_block - secondary_block ?secondary_key - secondary_key)
    (secondary_key_selected ?secondary_key - secondary_key)
    (secondary_key_reserved ?secondary_key - secondary_key)
    (secondary_block_prepared ?secondary_block - secondary_block)
    (slot_available ?output_slot - output_slot)
    (slot_allocated ?output_slot - output_slot)
    (slot_bound_to_primary_key ?output_slot - output_slot ?primary_key - primary_key)
    (slot_bound_to_secondary_key ?output_slot - output_slot ?secondary_key - secondary_key)
    (slot_flag_primary_reserved ?output_slot - output_slot)
    (slot_flag_secondary_reserved ?output_slot - output_slot)
    (slot_buffer_initialized ?output_slot - output_slot)
    (profile_primary_block_link ?schema_profile - profile ?primary_block - primary_block)
    (profile_secondary_block_link ?schema_profile - profile ?secondary_block - secondary_block)
    (profile_assigned_to_slot ?schema_profile - profile ?output_slot - output_slot)
    (buffer_available ?temporary_buffer - temporary_buffer)
    (profile_has_temporary_buffer ?schema_profile - profile ?temporary_buffer - temporary_buffer)
    (buffer_reserved ?temporary_buffer - temporary_buffer)
    (buffer_bound_to_slot ?temporary_buffer - temporary_buffer ?output_slot - output_slot)
    (option_binding_in_progress ?schema_profile - profile)
    (option_binding_confirmed ?schema_profile - profile)
    (profile_enrichment_complete ?schema_profile - profile)
    (profile_format_option_attached ?schema_profile - profile)
    (profile_format_option_applied ?schema_profile - profile)
    (profile_has_postprocess_option ?schema_profile - profile)
    (profile_verified ?schema_profile - profile)
    (lookup_entry_available ?lookup_entry - lookup_entry)
    (profile_bound_to_lookup_entry ?schema_profile - profile ?lookup_entry - lookup_entry)
    (lookup_resolved ?schema_profile - profile)
    (lookup_postprocess_started ?schema_profile - profile)
    (lookup_postprocess_confirmed ?schema_profile - profile)
    (format_option_available ?format_option - format_option)
    (profile_has_format_option ?schema_profile - profile ?format_option - format_option)
    (postprocess_option_available ?postprocess_option - postprocess_option)
    (profile_bound_to_postprocess_option ?schema_profile - profile ?postprocess_option - postprocess_option)
    (schema_annotation_available ?schema_annotation - schema_annotation)
    (profile_bound_to_schema_annotation ?schema_profile - profile ?schema_annotation - schema_annotation)
    (external_reference_available ?external_reference - external_reference)
    (profile_bound_to_external_reference ?schema_profile - profile ?external_reference - external_reference)
    (context_token_available ?context_token - context_token)
    (record_has_context_token ?input_record - input_record ?context_token - context_token)
    (block_slot_prepared ?primary_block - primary_block)
    (secondary_block_slot_prepared ?secondary_block - secondary_block)
    (profile_committed ?schema_profile - profile)
  )
  (:action register_input_record
    :parameters (?input_record - input_record)
    :precondition
      (and
        (not
          (record_registered ?input_record)
        )
        (not
          (is_finalized ?input_record)
        )
      )
    :effect (record_registered ?input_record)
  )
  (:action assign_field_mapper_to_record
    :parameters (?input_record - input_record ?field_mapper - field_mapper)
    :precondition
      (and
        (record_registered ?input_record)
        (not
          (mapper_assigned ?input_record)
        )
        (mapper_available ?field_mapper)
      )
    :effect
      (and
        (mapper_assigned ?input_record)
        (mapper_bound_to_entity ?input_record ?field_mapper)
        (not
          (mapper_available ?field_mapper)
        )
      )
  )
  (:action assign_field_token_to_record
    :parameters (?input_record - input_record ?field_token - field_token)
    :precondition
      (and
        (record_registered ?input_record)
        (mapper_assigned ?input_record)
        (token_available ?field_token)
      )
    :effect
      (and
        (token_bound_to_entity ?input_record ?field_token)
        (not
          (token_available ?field_token)
        )
      )
  )
  (:action confirm_record_bindings
    :parameters (?input_record - input_record ?field_token - field_token)
    :precondition
      (and
        (record_registered ?input_record)
        (mapper_assigned ?input_record)
        (token_bound_to_entity ?input_record ?field_token)
        (not
          (is_ready ?input_record)
        )
      )
    :effect (is_ready ?input_record)
  )
  (:action release_field_token_from_record
    :parameters (?input_record - input_record ?field_token - field_token)
    :precondition
      (and
        (token_bound_to_entity ?input_record ?field_token)
      )
    :effect
      (and
        (token_available ?field_token)
        (not
          (token_bound_to_entity ?input_record ?field_token)
        )
      )
  )
  (:action attach_parser_to_record
    :parameters (?input_record - input_record ?parser_module - parser_module)
    :precondition
      (and
        (is_ready ?input_record)
        (parser_available ?parser_module)
      )
    :effect
      (and
        (parser_bound_to_entity ?input_record ?parser_module)
        (not
          (parser_available ?parser_module)
        )
      )
  )
  (:action detach_parser_from_record
    :parameters (?input_record - input_record ?parser_module - parser_module)
    :precondition
      (and
        (parser_bound_to_entity ?input_record ?parser_module)
      )
    :effect
      (and
        (parser_available ?parser_module)
        (not
          (parser_bound_to_entity ?input_record ?parser_module)
        )
      )
  )
  (:action attach_schema_annotation_to_profile
    :parameters (?schema_profile - profile ?schema_annotation - schema_annotation)
    :precondition
      (and
        (is_ready ?schema_profile)
        (schema_annotation_available ?schema_annotation)
      )
    :effect
      (and
        (profile_bound_to_schema_annotation ?schema_profile ?schema_annotation)
        (not
          (schema_annotation_available ?schema_annotation)
        )
      )
  )
  (:action detach_schema_annotation_from_profile
    :parameters (?schema_profile - profile ?schema_annotation - schema_annotation)
    :precondition
      (and
        (profile_bound_to_schema_annotation ?schema_profile ?schema_annotation)
      )
    :effect
      (and
        (schema_annotation_available ?schema_annotation)
        (not
          (profile_bound_to_schema_annotation ?schema_profile ?schema_annotation)
        )
      )
  )
  (:action attach_external_reference_to_profile
    :parameters (?schema_profile - profile ?external_reference - external_reference)
    :precondition
      (and
        (is_ready ?schema_profile)
        (external_reference_available ?external_reference)
      )
    :effect
      (and
        (profile_bound_to_external_reference ?schema_profile ?external_reference)
        (not
          (external_reference_available ?external_reference)
        )
      )
  )
  (:action detach_external_reference_from_profile
    :parameters (?schema_profile - profile ?external_reference - external_reference)
    :precondition
      (and
        (profile_bound_to_external_reference ?schema_profile ?external_reference)
      )
    :effect
      (and
        (external_reference_available ?external_reference)
        (not
          (profile_bound_to_external_reference ?schema_profile ?external_reference)
        )
      )
  )
  (:action select_primary_key_for_block
    :parameters (?primary_block - primary_block ?primary_key - primary_key ?field_token - field_token)
    :precondition
      (and
        (is_ready ?primary_block)
        (token_bound_to_entity ?primary_block ?field_token)
        (block_has_primary_key ?primary_block ?primary_key)
        (not
          (primary_key_selected ?primary_key)
        )
        (not
          (primary_key_reserved ?primary_key)
        )
      )
    :effect (primary_key_selected ?primary_key)
  )
  (:action confirm_primary_block_preparation
    :parameters (?primary_block - primary_block ?primary_key - primary_key ?parser_module - parser_module)
    :precondition
      (and
        (is_ready ?primary_block)
        (parser_bound_to_entity ?primary_block ?parser_module)
        (block_has_primary_key ?primary_block ?primary_key)
        (primary_key_selected ?primary_key)
        (not
          (block_slot_prepared ?primary_block)
        )
      )
    :effect
      (and
        (block_slot_prepared ?primary_block)
        (block_prepared ?primary_block)
      )
  )
  (:action assign_normalization_rule_to_primary_block
    :parameters (?primary_block - primary_block ?primary_key - primary_key ?normalization_rule - normalization_rule)
    :precondition
      (and
        (is_ready ?primary_block)
        (block_has_primary_key ?primary_block ?primary_key)
        (normalization_rule_available ?normalization_rule)
        (not
          (block_slot_prepared ?primary_block)
        )
      )
    :effect
      (and
        (primary_key_reserved ?primary_key)
        (block_slot_prepared ?primary_block)
        (primary_block_has_normalization_rule ?primary_block ?normalization_rule)
        (not
          (normalization_rule_available ?normalization_rule)
        )
      )
  )
  (:action apply_normalization_rule_and_confirm_primary_key
    :parameters (?primary_block - primary_block ?primary_key - primary_key ?field_token - field_token ?normalization_rule - normalization_rule)
    :precondition
      (and
        (is_ready ?primary_block)
        (token_bound_to_entity ?primary_block ?field_token)
        (block_has_primary_key ?primary_block ?primary_key)
        (primary_key_reserved ?primary_key)
        (primary_block_has_normalization_rule ?primary_block ?normalization_rule)
        (not
          (block_prepared ?primary_block)
        )
      )
    :effect
      (and
        (primary_key_selected ?primary_key)
        (block_prepared ?primary_block)
        (normalization_rule_available ?normalization_rule)
        (not
          (primary_block_has_normalization_rule ?primary_block ?normalization_rule)
        )
      )
  )
  (:action select_secondary_key_for_block
    :parameters (?secondary_block - secondary_block ?secondary_key - secondary_key ?field_token - field_token)
    :precondition
      (and
        (is_ready ?secondary_block)
        (token_bound_to_entity ?secondary_block ?field_token)
        (secondary_block_has_key ?secondary_block ?secondary_key)
        (not
          (secondary_key_selected ?secondary_key)
        )
        (not
          (secondary_key_reserved ?secondary_key)
        )
      )
    :effect (secondary_key_selected ?secondary_key)
  )
  (:action confirm_secondary_block_preparation
    :parameters (?secondary_block - secondary_block ?secondary_key - secondary_key ?parser_module - parser_module)
    :precondition
      (and
        (is_ready ?secondary_block)
        (parser_bound_to_entity ?secondary_block ?parser_module)
        (secondary_block_has_key ?secondary_block ?secondary_key)
        (secondary_key_selected ?secondary_key)
        (not
          (secondary_block_slot_prepared ?secondary_block)
        )
      )
    :effect
      (and
        (secondary_block_slot_prepared ?secondary_block)
        (secondary_block_prepared ?secondary_block)
      )
  )
  (:action assign_normalization_rule_to_secondary_block
    :parameters (?secondary_block - secondary_block ?secondary_key - secondary_key ?normalization_rule - normalization_rule)
    :precondition
      (and
        (is_ready ?secondary_block)
        (secondary_block_has_key ?secondary_block ?secondary_key)
        (normalization_rule_available ?normalization_rule)
        (not
          (secondary_block_slot_prepared ?secondary_block)
        )
      )
    :effect
      (and
        (secondary_key_reserved ?secondary_key)
        (secondary_block_slot_prepared ?secondary_block)
        (secondary_block_has_normalization_rule ?secondary_block ?normalization_rule)
        (not
          (normalization_rule_available ?normalization_rule)
        )
      )
  )
  (:action apply_normalization_rule_and_confirm_secondary_key
    :parameters (?secondary_block - secondary_block ?secondary_key - secondary_key ?field_token - field_token ?normalization_rule - normalization_rule)
    :precondition
      (and
        (is_ready ?secondary_block)
        (token_bound_to_entity ?secondary_block ?field_token)
        (secondary_block_has_key ?secondary_block ?secondary_key)
        (secondary_key_reserved ?secondary_key)
        (secondary_block_has_normalization_rule ?secondary_block ?normalization_rule)
        (not
          (secondary_block_prepared ?secondary_block)
        )
      )
    :effect
      (and
        (secondary_key_selected ?secondary_key)
        (secondary_block_prepared ?secondary_block)
        (normalization_rule_available ?normalization_rule)
        (not
          (secondary_block_has_normalization_rule ?secondary_block ?normalization_rule)
        )
      )
  )
  (:action allocate_slot_with_both_keys
    :parameters (?primary_block - primary_block ?secondary_block - secondary_block ?primary_key - primary_key ?secondary_key - secondary_key ?output_slot - output_slot)
    :precondition
      (and
        (block_slot_prepared ?primary_block)
        (secondary_block_slot_prepared ?secondary_block)
        (block_has_primary_key ?primary_block ?primary_key)
        (secondary_block_has_key ?secondary_block ?secondary_key)
        (primary_key_selected ?primary_key)
        (secondary_key_selected ?secondary_key)
        (block_prepared ?primary_block)
        (secondary_block_prepared ?secondary_block)
        (slot_available ?output_slot)
      )
    :effect
      (and
        (slot_allocated ?output_slot)
        (slot_bound_to_primary_key ?output_slot ?primary_key)
        (slot_bound_to_secondary_key ?output_slot ?secondary_key)
        (not
          (slot_available ?output_slot)
        )
      )
  )
  (:action allocate_slot_with_primary_reserved
    :parameters (?primary_block - primary_block ?secondary_block - secondary_block ?primary_key - primary_key ?secondary_key - secondary_key ?output_slot - output_slot)
    :precondition
      (and
        (block_slot_prepared ?primary_block)
        (secondary_block_slot_prepared ?secondary_block)
        (block_has_primary_key ?primary_block ?primary_key)
        (secondary_block_has_key ?secondary_block ?secondary_key)
        (primary_key_reserved ?primary_key)
        (secondary_key_selected ?secondary_key)
        (not
          (block_prepared ?primary_block)
        )
        (secondary_block_prepared ?secondary_block)
        (slot_available ?output_slot)
      )
    :effect
      (and
        (slot_allocated ?output_slot)
        (slot_bound_to_primary_key ?output_slot ?primary_key)
        (slot_bound_to_secondary_key ?output_slot ?secondary_key)
        (slot_flag_primary_reserved ?output_slot)
        (not
          (slot_available ?output_slot)
        )
      )
  )
  (:action allocate_slot_with_secondary_reserved
    :parameters (?primary_block - primary_block ?secondary_block - secondary_block ?primary_key - primary_key ?secondary_key - secondary_key ?output_slot - output_slot)
    :precondition
      (and
        (block_slot_prepared ?primary_block)
        (secondary_block_slot_prepared ?secondary_block)
        (block_has_primary_key ?primary_block ?primary_key)
        (secondary_block_has_key ?secondary_block ?secondary_key)
        (primary_key_selected ?primary_key)
        (secondary_key_reserved ?secondary_key)
        (block_prepared ?primary_block)
        (not
          (secondary_block_prepared ?secondary_block)
        )
        (slot_available ?output_slot)
      )
    :effect
      (and
        (slot_allocated ?output_slot)
        (slot_bound_to_primary_key ?output_slot ?primary_key)
        (slot_bound_to_secondary_key ?output_slot ?secondary_key)
        (slot_flag_secondary_reserved ?output_slot)
        (not
          (slot_available ?output_slot)
        )
      )
  )
  (:action allocate_slot_with_both_reserved
    :parameters (?primary_block - primary_block ?secondary_block - secondary_block ?primary_key - primary_key ?secondary_key - secondary_key ?output_slot - output_slot)
    :precondition
      (and
        (block_slot_prepared ?primary_block)
        (secondary_block_slot_prepared ?secondary_block)
        (block_has_primary_key ?primary_block ?primary_key)
        (secondary_block_has_key ?secondary_block ?secondary_key)
        (primary_key_reserved ?primary_key)
        (secondary_key_reserved ?secondary_key)
        (not
          (block_prepared ?primary_block)
        )
        (not
          (secondary_block_prepared ?secondary_block)
        )
        (slot_available ?output_slot)
      )
    :effect
      (and
        (slot_allocated ?output_slot)
        (slot_bound_to_primary_key ?output_slot ?primary_key)
        (slot_bound_to_secondary_key ?output_slot ?secondary_key)
        (slot_flag_primary_reserved ?output_slot)
        (slot_flag_secondary_reserved ?output_slot)
        (not
          (slot_available ?output_slot)
        )
      )
  )
  (:action initialize_slot_buffer
    :parameters (?output_slot - output_slot ?primary_block - primary_block ?field_token - field_token)
    :precondition
      (and
        (slot_allocated ?output_slot)
        (block_slot_prepared ?primary_block)
        (token_bound_to_entity ?primary_block ?field_token)
        (not
          (slot_buffer_initialized ?output_slot)
        )
      )
    :effect (slot_buffer_initialized ?output_slot)
  )
  (:action attach_temporary_buffer_to_profile_slot
    :parameters (?schema_profile - profile ?temporary_buffer - temporary_buffer ?output_slot - output_slot)
    :precondition
      (and
        (is_ready ?schema_profile)
        (profile_assigned_to_slot ?schema_profile ?output_slot)
        (profile_has_temporary_buffer ?schema_profile ?temporary_buffer)
        (buffer_available ?temporary_buffer)
        (slot_allocated ?output_slot)
        (slot_buffer_initialized ?output_slot)
        (not
          (buffer_reserved ?temporary_buffer)
        )
      )
    :effect
      (and
        (buffer_reserved ?temporary_buffer)
        (buffer_bound_to_slot ?temporary_buffer ?output_slot)
        (not
          (buffer_available ?temporary_buffer)
        )
      )
  )
  (:action begin_option_binding_for_profile
    :parameters (?schema_profile - profile ?temporary_buffer - temporary_buffer ?output_slot - output_slot ?field_token - field_token)
    :precondition
      (and
        (is_ready ?schema_profile)
        (profile_has_temporary_buffer ?schema_profile ?temporary_buffer)
        (buffer_reserved ?temporary_buffer)
        (buffer_bound_to_slot ?temporary_buffer ?output_slot)
        (token_bound_to_entity ?schema_profile ?field_token)
        (not
          (slot_flag_primary_reserved ?output_slot)
        )
        (not
          (option_binding_in_progress ?schema_profile)
        )
      )
    :effect (option_binding_in_progress ?schema_profile)
  )
  (:action attach_format_option_to_profile
    :parameters (?schema_profile - profile ?format_option - format_option)
    :precondition
      (and
        (is_ready ?schema_profile)
        (format_option_available ?format_option)
        (not
          (profile_format_option_attached ?schema_profile)
        )
      )
    :effect
      (and
        (profile_format_option_attached ?schema_profile)
        (profile_has_format_option ?schema_profile ?format_option)
        (not
          (format_option_available ?format_option)
        )
      )
  )
  (:action apply_format_option_and_advance_profile
    :parameters (?schema_profile - profile ?temporary_buffer - temporary_buffer ?output_slot - output_slot ?field_token - field_token ?format_option - format_option)
    :precondition
      (and
        (is_ready ?schema_profile)
        (profile_has_temporary_buffer ?schema_profile ?temporary_buffer)
        (buffer_reserved ?temporary_buffer)
        (buffer_bound_to_slot ?temporary_buffer ?output_slot)
        (token_bound_to_entity ?schema_profile ?field_token)
        (slot_flag_primary_reserved ?output_slot)
        (profile_format_option_attached ?schema_profile)
        (profile_has_format_option ?schema_profile ?format_option)
        (not
          (option_binding_in_progress ?schema_profile)
        )
      )
    :effect
      (and
        (option_binding_in_progress ?schema_profile)
        (profile_format_option_applied ?schema_profile)
      )
  )
  (:action confirm_option_binding_without_slot_flag
    :parameters (?schema_profile - profile ?schema_annotation - schema_annotation ?parser_module - parser_module ?temporary_buffer - temporary_buffer ?output_slot - output_slot)
    :precondition
      (and
        (option_binding_in_progress ?schema_profile)
        (profile_bound_to_schema_annotation ?schema_profile ?schema_annotation)
        (parser_bound_to_entity ?schema_profile ?parser_module)
        (profile_has_temporary_buffer ?schema_profile ?temporary_buffer)
        (buffer_bound_to_slot ?temporary_buffer ?output_slot)
        (not
          (slot_flag_secondary_reserved ?output_slot)
        )
        (not
          (option_binding_confirmed ?schema_profile)
        )
      )
    :effect (option_binding_confirmed ?schema_profile)
  )
  (:action confirm_option_binding_with_slot_flag
    :parameters (?schema_profile - profile ?schema_annotation - schema_annotation ?parser_module - parser_module ?temporary_buffer - temporary_buffer ?output_slot - output_slot)
    :precondition
      (and
        (option_binding_in_progress ?schema_profile)
        (profile_bound_to_schema_annotation ?schema_profile ?schema_annotation)
        (parser_bound_to_entity ?schema_profile ?parser_module)
        (profile_has_temporary_buffer ?schema_profile ?temporary_buffer)
        (buffer_bound_to_slot ?temporary_buffer ?output_slot)
        (slot_flag_secondary_reserved ?output_slot)
        (not
          (option_binding_confirmed ?schema_profile)
        )
      )
    :effect (option_binding_confirmed ?schema_profile)
  )
  (:action advance_profile_enrichment_with_external_ref
    :parameters (?schema_profile - profile ?external_reference - external_reference ?temporary_buffer - temporary_buffer ?output_slot - output_slot)
    :precondition
      (and
        (option_binding_confirmed ?schema_profile)
        (profile_bound_to_external_reference ?schema_profile ?external_reference)
        (profile_has_temporary_buffer ?schema_profile ?temporary_buffer)
        (buffer_bound_to_slot ?temporary_buffer ?output_slot)
        (not
          (slot_flag_primary_reserved ?output_slot)
        )
        (not
          (slot_flag_secondary_reserved ?output_slot)
        )
        (not
          (profile_enrichment_complete ?schema_profile)
        )
      )
    :effect (profile_enrichment_complete ?schema_profile)
  )
  (:action advance_profile_enrichment_primary_reserved
    :parameters (?schema_profile - profile ?external_reference - external_reference ?temporary_buffer - temporary_buffer ?output_slot - output_slot)
    :precondition
      (and
        (option_binding_confirmed ?schema_profile)
        (profile_bound_to_external_reference ?schema_profile ?external_reference)
        (profile_has_temporary_buffer ?schema_profile ?temporary_buffer)
        (buffer_bound_to_slot ?temporary_buffer ?output_slot)
        (slot_flag_primary_reserved ?output_slot)
        (not
          (slot_flag_secondary_reserved ?output_slot)
        )
        (not
          (profile_enrichment_complete ?schema_profile)
        )
      )
    :effect
      (and
        (profile_enrichment_complete ?schema_profile)
        (profile_has_postprocess_option ?schema_profile)
      )
  )
  (:action advance_profile_enrichment_secondary_reserved
    :parameters (?schema_profile - profile ?external_reference - external_reference ?temporary_buffer - temporary_buffer ?output_slot - output_slot)
    :precondition
      (and
        (option_binding_confirmed ?schema_profile)
        (profile_bound_to_external_reference ?schema_profile ?external_reference)
        (profile_has_temporary_buffer ?schema_profile ?temporary_buffer)
        (buffer_bound_to_slot ?temporary_buffer ?output_slot)
        (not
          (slot_flag_primary_reserved ?output_slot)
        )
        (slot_flag_secondary_reserved ?output_slot)
        (not
          (profile_enrichment_complete ?schema_profile)
        )
      )
    :effect
      (and
        (profile_enrichment_complete ?schema_profile)
        (profile_has_postprocess_option ?schema_profile)
      )
  )
  (:action advance_profile_enrichment_both_reserved
    :parameters (?schema_profile - profile ?external_reference - external_reference ?temporary_buffer - temporary_buffer ?output_slot - output_slot)
    :precondition
      (and
        (option_binding_confirmed ?schema_profile)
        (profile_bound_to_external_reference ?schema_profile ?external_reference)
        (profile_has_temporary_buffer ?schema_profile ?temporary_buffer)
        (buffer_bound_to_slot ?temporary_buffer ?output_slot)
        (slot_flag_primary_reserved ?output_slot)
        (slot_flag_secondary_reserved ?output_slot)
        (not
          (profile_enrichment_complete ?schema_profile)
        )
      )
    :effect
      (and
        (profile_enrichment_complete ?schema_profile)
        (profile_has_postprocess_option ?schema_profile)
      )
  )
  (:action mark_profile_ready_for_mapping
    :parameters (?schema_profile - profile)
    :precondition
      (and
        (profile_enrichment_complete ?schema_profile)
        (not
          (profile_has_postprocess_option ?schema_profile)
        )
        (not
          (profile_committed ?schema_profile)
        )
      )
    :effect
      (and
        (profile_committed ?schema_profile)
        (ready_for_mapping ?schema_profile)
      )
  )
  (:action attach_postprocess_option_to_profile
    :parameters (?schema_profile - profile ?postprocess_option - postprocess_option)
    :precondition
      (and
        (profile_enrichment_complete ?schema_profile)
        (profile_has_postprocess_option ?schema_profile)
        (postprocess_option_available ?postprocess_option)
      )
    :effect
      (and
        (profile_bound_to_postprocess_option ?schema_profile ?postprocess_option)
        (not
          (postprocess_option_available ?postprocess_option)
        )
      )
  )
  (:action verify_profile_for_slot_assignment
    :parameters (?schema_profile - profile ?primary_block - primary_block ?secondary_block - secondary_block ?field_token - field_token ?postprocess_option - postprocess_option)
    :precondition
      (and
        (profile_enrichment_complete ?schema_profile)
        (profile_has_postprocess_option ?schema_profile)
        (profile_bound_to_postprocess_option ?schema_profile ?postprocess_option)
        (profile_primary_block_link ?schema_profile ?primary_block)
        (profile_secondary_block_link ?schema_profile ?secondary_block)
        (block_prepared ?primary_block)
        (secondary_block_prepared ?secondary_block)
        (token_bound_to_entity ?schema_profile ?field_token)
        (not
          (profile_verified ?schema_profile)
        )
      )
    :effect (profile_verified ?schema_profile)
  )
  (:action commit_profile_for_mapping
    :parameters (?schema_profile - profile)
    :precondition
      (and
        (profile_enrichment_complete ?schema_profile)
        (profile_verified ?schema_profile)
        (not
          (profile_committed ?schema_profile)
        )
      )
    :effect
      (and
        (profile_committed ?schema_profile)
        (ready_for_mapping ?schema_profile)
      )
  )
  (:action resolve_lookup_entry_for_profile
    :parameters (?schema_profile - profile ?lookup_entry - lookup_entry ?field_token - field_token)
    :precondition
      (and
        (is_ready ?schema_profile)
        (token_bound_to_entity ?schema_profile ?field_token)
        (lookup_entry_available ?lookup_entry)
        (profile_bound_to_lookup_entry ?schema_profile ?lookup_entry)
        (not
          (lookup_resolved ?schema_profile)
        )
      )
    :effect
      (and
        (lookup_resolved ?schema_profile)
        (not
          (lookup_entry_available ?lookup_entry)
        )
      )
  )
  (:action start_lookup_postprocessing
    :parameters (?schema_profile - profile ?parser_module - parser_module)
    :precondition
      (and
        (lookup_resolved ?schema_profile)
        (parser_bound_to_entity ?schema_profile ?parser_module)
        (not
          (lookup_postprocess_started ?schema_profile)
        )
      )
    :effect (lookup_postprocess_started ?schema_profile)
  )
  (:action confirm_lookup_postprocessing
    :parameters (?schema_profile - profile ?external_reference - external_reference)
    :precondition
      (and
        (lookup_postprocess_started ?schema_profile)
        (profile_bound_to_external_reference ?schema_profile ?external_reference)
        (not
          (lookup_postprocess_confirmed ?schema_profile)
        )
      )
    :effect (lookup_postprocess_confirmed ?schema_profile)
  )
  (:action finalize_lookup_and_mark_profile_ready
    :parameters (?schema_profile - profile)
    :precondition
      (and
        (lookup_postprocess_confirmed ?schema_profile)
        (not
          (profile_committed ?schema_profile)
        )
      )
    :effect
      (and
        (profile_committed ?schema_profile)
        (ready_for_mapping ?schema_profile)
      )
  )
  (:action finalize_primary_block_mapping
    :parameters (?primary_block - primary_block ?output_slot - output_slot)
    :precondition
      (and
        (block_slot_prepared ?primary_block)
        (block_prepared ?primary_block)
        (slot_allocated ?output_slot)
        (slot_buffer_initialized ?output_slot)
        (not
          (ready_for_mapping ?primary_block)
        )
      )
    :effect (ready_for_mapping ?primary_block)
  )
  (:action finalize_secondary_block_mapping
    :parameters (?secondary_block - secondary_block ?output_slot - output_slot)
    :precondition
      (and
        (secondary_block_slot_prepared ?secondary_block)
        (secondary_block_prepared ?secondary_block)
        (slot_allocated ?output_slot)
        (slot_buffer_initialized ?output_slot)
        (not
          (ready_for_mapping ?secondary_block)
        )
      )
    :effect (ready_for_mapping ?secondary_block)
  )
  (:action normalize_record_and_attach_context
    :parameters (?input_record - input_record ?context_token - context_token ?field_token - field_token)
    :precondition
      (and
        (ready_for_mapping ?input_record)
        (token_bound_to_entity ?input_record ?field_token)
        (context_token_available ?context_token)
        (not
          (is_normalized ?input_record)
        )
      )
    :effect
      (and
        (is_normalized ?input_record)
        (record_has_context_token ?input_record ?context_token)
        (not
          (context_token_available ?context_token)
        )
      )
  )
  (:action map_normalized_primary_block_and_release_mapper
    :parameters (?primary_block - primary_block ?field_mapper - field_mapper ?context_token - context_token)
    :precondition
      (and
        (is_normalized ?primary_block)
        (mapper_bound_to_entity ?primary_block ?field_mapper)
        (record_has_context_token ?primary_block ?context_token)
        (not
          (is_finalized ?primary_block)
        )
      )
    :effect
      (and
        (is_finalized ?primary_block)
        (mapper_available ?field_mapper)
        (context_token_available ?context_token)
      )
  )
  (:action map_normalized_secondary_block_and_release_mapper
    :parameters (?secondary_block - secondary_block ?field_mapper - field_mapper ?context_token - context_token)
    :precondition
      (and
        (is_normalized ?secondary_block)
        (mapper_bound_to_entity ?secondary_block ?field_mapper)
        (record_has_context_token ?secondary_block ?context_token)
        (not
          (is_finalized ?secondary_block)
        )
      )
    :effect
      (and
        (is_finalized ?secondary_block)
        (mapper_available ?field_mapper)
        (context_token_available ?context_token)
      )
  )
  (:action map_normalized_profile_and_release_mapper
    :parameters (?schema_profile - profile ?field_mapper - field_mapper ?context_token - context_token)
    :precondition
      (and
        (is_normalized ?schema_profile)
        (mapper_bound_to_entity ?schema_profile ?field_mapper)
        (record_has_context_token ?schema_profile ?context_token)
        (not
          (is_finalized ?schema_profile)
        )
      )
    :effect
      (and
        (is_finalized ?schema_profile)
        (mapper_available ?field_mapper)
        (context_token_available ?context_token)
      )
  )
)

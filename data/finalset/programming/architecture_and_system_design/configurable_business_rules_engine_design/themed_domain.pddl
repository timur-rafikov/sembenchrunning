(define (domain configurable_business_rules_engine)
  (:requirements :strips :typing :negative-preconditions)
  (:types engine_component - object external_asset - object auxiliary_artifact - object base_rule_type - object rule - base_rule_type condition_fragment - engine_component fact - engine_component action_template - engine_component constraint_descriptor - engine_component binding_template - engine_component version_token - engine_component guard_template - engine_component priority_descriptor - engine_component attribute - external_asset resource - external_asset tag - external_asset evaluation_point - auxiliary_artifact evaluation_channel - auxiliary_artifact decision_artifact - auxiliary_artifact rule_variant - rule composite_rule_kind - rule scoped_rule_variant - rule_variant scoped_rule_variant_alt - rule_variant policy_unit - composite_rule_kind)
  (:predicates
    (entity_registered ?rule - rule)
    (entity_validated ?rule - rule)
    (entity_fragment_attached ?rule - rule)
    (entity_deployed ?rule - rule)
    (execution_ready ?rule - rule)
    (entity_finalized ?rule - rule)
    (fragment_available ?condition_fragment - condition_fragment)
    (entity_fragment_link ?rule - rule ?condition_fragment - condition_fragment)
    (fact_available ?fact - fact)
    (entity_fact_binding ?rule - rule ?fact - fact)
    (action_template_available ?action_template - action_template)
    (entity_action_link ?rule - rule ?action_template - action_template)
    (attribute_available ?attribute - attribute)
    (variant_attribute_association ?scoped_rule_variant - scoped_rule_variant ?attribute - attribute)
    (variant_alt_attribute_association ?scoped_rule_variant_alt - scoped_rule_variant_alt ?attribute - attribute)
    (variant_evaluation_association ?scoped_rule_variant - scoped_rule_variant ?evaluation_point - evaluation_point)
    (evaluation_point_partial_match ?evaluation_point - evaluation_point)
    (evaluation_point_alternate_match ?evaluation_point - evaluation_point)
    (variant_resolved_match ?scoped_rule_variant - scoped_rule_variant)
    (variant_evaluation_channel_association ?scoped_rule_variant_alt - scoped_rule_variant_alt ?evaluation_channel - evaluation_channel)
    (evaluation_channel_ready ?evaluation_channel - evaluation_channel)
    (evaluation_channel_alternate_ready ?evaluation_channel - evaluation_channel)
    (variant_evaluation_channel_resolved ?scoped_rule_variant_alt - scoped_rule_variant_alt)
    (artifact_available ?decision_artifact - decision_artifact)
    (artifact_enriched ?decision_artifact - decision_artifact)
    (artifact_evaluation_point_link ?decision_artifact - decision_artifact ?evaluation_point - evaluation_point)
    (artifact_evaluation_channel_link ?decision_artifact - decision_artifact ?evaluation_channel - evaluation_channel)
    (artifact_stage_primary ?decision_artifact - decision_artifact)
    (artifact_stage_secondary ?decision_artifact - decision_artifact)
    (artifact_ready ?decision_artifact - decision_artifact)
    (policy_unit_variant_binding ?policy_unit - policy_unit ?scoped_rule_variant - scoped_rule_variant)
    (policy_unit_variant_alt_binding ?policy_unit - policy_unit ?scoped_rule_variant_alt - scoped_rule_variant_alt)
    (policy_unit_artifact_association ?policy_unit - policy_unit ?decision_artifact - decision_artifact)
    (resource_available ?resource - resource)
    (policy_unit_resource_link ?policy_unit - policy_unit ?resource - resource)
    (resource_consumed ?resource - resource)
    (resource_bound_to_artifact ?resource - resource ?decision_artifact - decision_artifact)
    (policy_unit_locked ?policy_unit - policy_unit)
    (policy_unit_tagging_applied ?policy_unit - policy_unit)
    (policy_unit_priority_stage ?policy_unit - policy_unit)
    (constraint_marked ?policy_unit - policy_unit)
    (constraint_stage_advanced ?policy_unit - policy_unit)
    (priority_applied ?policy_unit - policy_unit)
    (policy_unit_bindings_finalized ?policy_unit - policy_unit)
    (tag_available ?tag - tag)
    (policy_unit_tag_link ?policy_unit - policy_unit ?tag - tag)
    (policy_unit_tagged ?policy_unit - policy_unit)
    (policy_unit_approval_pending ?policy_unit - policy_unit)
    (policy_unit_approved ?policy_unit - policy_unit)
    (constraint_available ?constraint_descriptor - constraint_descriptor)
    (policy_unit_constraint_link ?policy_unit - policy_unit ?constraint_descriptor - constraint_descriptor)
    (binding_template_available ?binding_template - binding_template)
    (policy_unit_binding_template_link ?policy_unit - policy_unit ?binding_template - binding_template)
    (guard_template_available ?guard_template - guard_template)
    (policy_unit_guard_link ?policy_unit - policy_unit ?guard_template - guard_template)
    (priority_descriptor_available ?priority_descriptor - priority_descriptor)
    (policy_unit_priority_link ?policy_unit - policy_unit ?priority_descriptor - priority_descriptor)
    (version_token_available ?version_token - version_token)
    (entity_version_association ?rule - rule ?version_token - version_token)
    (scoped_variant_ready ?scoped_rule_variant - scoped_rule_variant)
    (scoped_variant_alt_ready ?scoped_rule_variant_alt - scoped_rule_variant_alt)
    (policy_unit_finalized ?policy_unit - policy_unit)
  )
  (:action register_rule
    :parameters (?rule - rule)
    :precondition
      (and
        (not
          (entity_registered ?rule)
        )
        (not
          (entity_deployed ?rule)
        )
      )
    :effect (entity_registered ?rule)
  )
  (:action attach_condition_fragment_to_rule
    :parameters (?rule - rule ?condition_fragment - condition_fragment)
    :precondition
      (and
        (entity_registered ?rule)
        (not
          (entity_fragment_attached ?rule)
        )
        (fragment_available ?condition_fragment)
      )
    :effect
      (and
        (entity_fragment_attached ?rule)
        (entity_fragment_link ?rule ?condition_fragment)
        (not
          (fragment_available ?condition_fragment)
        )
      )
  )
  (:action bind_fact_to_rule
    :parameters (?rule - rule ?fact - fact)
    :precondition
      (and
        (entity_registered ?rule)
        (entity_fragment_attached ?rule)
        (fact_available ?fact)
      )
    :effect
      (and
        (entity_fact_binding ?rule ?fact)
        (not
          (fact_available ?fact)
        )
      )
  )
  (:action validate_rule
    :parameters (?rule - rule ?fact - fact)
    :precondition
      (and
        (entity_registered ?rule)
        (entity_fragment_attached ?rule)
        (entity_fact_binding ?rule ?fact)
        (not
          (entity_validated ?rule)
        )
      )
    :effect (entity_validated ?rule)
  )
  (:action release_fact_binding
    :parameters (?rule - rule ?fact - fact)
    :precondition
      (and
        (entity_fact_binding ?rule ?fact)
      )
    :effect
      (and
        (fact_available ?fact)
        (not
          (entity_fact_binding ?rule ?fact)
        )
      )
  )
  (:action attach_action_template_to_rule
    :parameters (?rule - rule ?action_template - action_template)
    :precondition
      (and
        (entity_validated ?rule)
        (action_template_available ?action_template)
      )
    :effect
      (and
        (entity_action_link ?rule ?action_template)
        (not
          (action_template_available ?action_template)
        )
      )
  )
  (:action detach_action_template_from_rule
    :parameters (?rule - rule ?action_template - action_template)
    :precondition
      (and
        (entity_action_link ?rule ?action_template)
      )
    :effect
      (and
        (action_template_available ?action_template)
        (not
          (entity_action_link ?rule ?action_template)
        )
      )
  )
  (:action bind_guard_to_policy_unit
    :parameters (?policy_unit - policy_unit ?guard_template - guard_template)
    :precondition
      (and
        (entity_validated ?policy_unit)
        (guard_template_available ?guard_template)
      )
    :effect
      (and
        (policy_unit_guard_link ?policy_unit ?guard_template)
        (not
          (guard_template_available ?guard_template)
        )
      )
  )
  (:action detach_guard_from_policy_unit
    :parameters (?policy_unit - policy_unit ?guard_template - guard_template)
    :precondition
      (and
        (policy_unit_guard_link ?policy_unit ?guard_template)
      )
    :effect
      (and
        (guard_template_available ?guard_template)
        (not
          (policy_unit_guard_link ?policy_unit ?guard_template)
        )
      )
  )
  (:action attach_priority_to_policy_unit
    :parameters (?policy_unit - policy_unit ?priority_descriptor - priority_descriptor)
    :precondition
      (and
        (entity_validated ?policy_unit)
        (priority_descriptor_available ?priority_descriptor)
      )
    :effect
      (and
        (policy_unit_priority_link ?policy_unit ?priority_descriptor)
        (not
          (priority_descriptor_available ?priority_descriptor)
        )
      )
  )
  (:action detach_priority_from_policy_unit
    :parameters (?policy_unit - policy_unit ?priority_descriptor - priority_descriptor)
    :precondition
      (and
        (policy_unit_priority_link ?policy_unit ?priority_descriptor)
      )
    :effect
      (and
        (priority_descriptor_available ?priority_descriptor)
        (not
          (policy_unit_priority_link ?policy_unit ?priority_descriptor)
        )
      )
  )
  (:action assert_evaluation_point_partial_match
    :parameters (?scoped_rule_variant - scoped_rule_variant ?evaluation_point - evaluation_point ?fact - fact)
    :precondition
      (and
        (entity_validated ?scoped_rule_variant)
        (entity_fact_binding ?scoped_rule_variant ?fact)
        (variant_evaluation_association ?scoped_rule_variant ?evaluation_point)
        (not
          (evaluation_point_partial_match ?evaluation_point)
        )
        (not
          (evaluation_point_alternate_match ?evaluation_point)
        )
      )
    :effect (evaluation_point_partial_match ?evaluation_point)
  )
  (:action confirm_partial_match_and_mark_variant
    :parameters (?scoped_rule_variant - scoped_rule_variant ?evaluation_point - evaluation_point ?action_template - action_template)
    :precondition
      (and
        (entity_validated ?scoped_rule_variant)
        (entity_action_link ?scoped_rule_variant ?action_template)
        (variant_evaluation_association ?scoped_rule_variant ?evaluation_point)
        (evaluation_point_partial_match ?evaluation_point)
        (not
          (scoped_variant_ready ?scoped_rule_variant)
        )
      )
    :effect
      (and
        (scoped_variant_ready ?scoped_rule_variant)
        (variant_resolved_match ?scoped_rule_variant)
      )
  )
  (:action apply_attribute_to_variant
    :parameters (?scoped_rule_variant - scoped_rule_variant ?evaluation_point - evaluation_point ?attribute - attribute)
    :precondition
      (and
        (entity_validated ?scoped_rule_variant)
        (variant_evaluation_association ?scoped_rule_variant ?evaluation_point)
        (attribute_available ?attribute)
        (not
          (scoped_variant_ready ?scoped_rule_variant)
        )
      )
    :effect
      (and
        (evaluation_point_alternate_match ?evaluation_point)
        (scoped_variant_ready ?scoped_rule_variant)
        (variant_attribute_association ?scoped_rule_variant ?attribute)
        (not
          (attribute_available ?attribute)
        )
      )
  )
  (:action resolve_fragment_match_for_variant
    :parameters (?scoped_rule_variant - scoped_rule_variant ?evaluation_point - evaluation_point ?fact - fact ?attribute - attribute)
    :precondition
      (and
        (entity_validated ?scoped_rule_variant)
        (entity_fact_binding ?scoped_rule_variant ?fact)
        (variant_evaluation_association ?scoped_rule_variant ?evaluation_point)
        (evaluation_point_alternate_match ?evaluation_point)
        (variant_attribute_association ?scoped_rule_variant ?attribute)
        (not
          (variant_resolved_match ?scoped_rule_variant)
        )
      )
    :effect
      (and
        (evaluation_point_partial_match ?evaluation_point)
        (variant_resolved_match ?scoped_rule_variant)
        (attribute_available ?attribute)
        (not
          (variant_attribute_association ?scoped_rule_variant ?attribute)
        )
      )
  )
  (:action assert_channel_partial_match
    :parameters (?scoped_rule_variant_alt - scoped_rule_variant_alt ?evaluation_channel - evaluation_channel ?fact - fact)
    :precondition
      (and
        (entity_validated ?scoped_rule_variant_alt)
        (entity_fact_binding ?scoped_rule_variant_alt ?fact)
        (variant_evaluation_channel_association ?scoped_rule_variant_alt ?evaluation_channel)
        (not
          (evaluation_channel_ready ?evaluation_channel)
        )
        (not
          (evaluation_channel_alternate_ready ?evaluation_channel)
        )
      )
    :effect (evaluation_channel_ready ?evaluation_channel)
  )
  (:action confirm_channel_match_and_mark_variant
    :parameters (?scoped_rule_variant_alt - scoped_rule_variant_alt ?evaluation_channel - evaluation_channel ?action_template - action_template)
    :precondition
      (and
        (entity_validated ?scoped_rule_variant_alt)
        (entity_action_link ?scoped_rule_variant_alt ?action_template)
        (variant_evaluation_channel_association ?scoped_rule_variant_alt ?evaluation_channel)
        (evaluation_channel_ready ?evaluation_channel)
        (not
          (scoped_variant_alt_ready ?scoped_rule_variant_alt)
        )
      )
    :effect
      (and
        (scoped_variant_alt_ready ?scoped_rule_variant_alt)
        (variant_evaluation_channel_resolved ?scoped_rule_variant_alt)
      )
  )
  (:action apply_attribute_to_variant_channel
    :parameters (?scoped_rule_variant_alt - scoped_rule_variant_alt ?evaluation_channel - evaluation_channel ?attribute - attribute)
    :precondition
      (and
        (entity_validated ?scoped_rule_variant_alt)
        (variant_evaluation_channel_association ?scoped_rule_variant_alt ?evaluation_channel)
        (attribute_available ?attribute)
        (not
          (scoped_variant_alt_ready ?scoped_rule_variant_alt)
        )
      )
    :effect
      (and
        (evaluation_channel_alternate_ready ?evaluation_channel)
        (scoped_variant_alt_ready ?scoped_rule_variant_alt)
        (variant_alt_attribute_association ?scoped_rule_variant_alt ?attribute)
        (not
          (attribute_available ?attribute)
        )
      )
  )
  (:action resolve_channel_match_for_variant
    :parameters (?scoped_rule_variant_alt - scoped_rule_variant_alt ?evaluation_channel - evaluation_channel ?fact - fact ?attribute - attribute)
    :precondition
      (and
        (entity_validated ?scoped_rule_variant_alt)
        (entity_fact_binding ?scoped_rule_variant_alt ?fact)
        (variant_evaluation_channel_association ?scoped_rule_variant_alt ?evaluation_channel)
        (evaluation_channel_alternate_ready ?evaluation_channel)
        (variant_alt_attribute_association ?scoped_rule_variant_alt ?attribute)
        (not
          (variant_evaluation_channel_resolved ?scoped_rule_variant_alt)
        )
      )
    :effect
      (and
        (evaluation_channel_ready ?evaluation_channel)
        (variant_evaluation_channel_resolved ?scoped_rule_variant_alt)
        (attribute_available ?attribute)
        (not
          (variant_alt_attribute_association ?scoped_rule_variant_alt ?attribute)
        )
      )
  )
  (:action assemble_decision_artifact
    :parameters (?scoped_rule_variant - scoped_rule_variant ?scoped_rule_variant_alt - scoped_rule_variant_alt ?evaluation_point - evaluation_point ?evaluation_channel - evaluation_channel ?decision_artifact - decision_artifact)
    :precondition
      (and
        (scoped_variant_ready ?scoped_rule_variant)
        (scoped_variant_alt_ready ?scoped_rule_variant_alt)
        (variant_evaluation_association ?scoped_rule_variant ?evaluation_point)
        (variant_evaluation_channel_association ?scoped_rule_variant_alt ?evaluation_channel)
        (evaluation_point_partial_match ?evaluation_point)
        (evaluation_channel_ready ?evaluation_channel)
        (variant_resolved_match ?scoped_rule_variant)
        (variant_evaluation_channel_resolved ?scoped_rule_variant_alt)
        (artifact_available ?decision_artifact)
      )
    :effect
      (and
        (artifact_enriched ?decision_artifact)
        (artifact_evaluation_point_link ?decision_artifact ?evaluation_point)
        (artifact_evaluation_channel_link ?decision_artifact ?evaluation_channel)
        (not
          (artifact_available ?decision_artifact)
        )
      )
  )
  (:action assemble_and_stage_decision_artifact_primary
    :parameters (?scoped_rule_variant - scoped_rule_variant ?scoped_rule_variant_alt - scoped_rule_variant_alt ?evaluation_point - evaluation_point ?evaluation_channel - evaluation_channel ?decision_artifact - decision_artifact)
    :precondition
      (and
        (scoped_variant_ready ?scoped_rule_variant)
        (scoped_variant_alt_ready ?scoped_rule_variant_alt)
        (variant_evaluation_association ?scoped_rule_variant ?evaluation_point)
        (variant_evaluation_channel_association ?scoped_rule_variant_alt ?evaluation_channel)
        (evaluation_point_alternate_match ?evaluation_point)
        (evaluation_channel_ready ?evaluation_channel)
        (not
          (variant_resolved_match ?scoped_rule_variant)
        )
        (variant_evaluation_channel_resolved ?scoped_rule_variant_alt)
        (artifact_available ?decision_artifact)
      )
    :effect
      (and
        (artifact_enriched ?decision_artifact)
        (artifact_evaluation_point_link ?decision_artifact ?evaluation_point)
        (artifact_evaluation_channel_link ?decision_artifact ?evaluation_channel)
        (artifact_stage_primary ?decision_artifact)
        (not
          (artifact_available ?decision_artifact)
        )
      )
  )
  (:action assemble_and_stage_decision_artifact_secondary
    :parameters (?scoped_rule_variant - scoped_rule_variant ?scoped_rule_variant_alt - scoped_rule_variant_alt ?evaluation_point - evaluation_point ?evaluation_channel - evaluation_channel ?decision_artifact - decision_artifact)
    :precondition
      (and
        (scoped_variant_ready ?scoped_rule_variant)
        (scoped_variant_alt_ready ?scoped_rule_variant_alt)
        (variant_evaluation_association ?scoped_rule_variant ?evaluation_point)
        (variant_evaluation_channel_association ?scoped_rule_variant_alt ?evaluation_channel)
        (evaluation_point_partial_match ?evaluation_point)
        (evaluation_channel_alternate_ready ?evaluation_channel)
        (variant_resolved_match ?scoped_rule_variant)
        (not
          (variant_evaluation_channel_resolved ?scoped_rule_variant_alt)
        )
        (artifact_available ?decision_artifact)
      )
    :effect
      (and
        (artifact_enriched ?decision_artifact)
        (artifact_evaluation_point_link ?decision_artifact ?evaluation_point)
        (artifact_evaluation_channel_link ?decision_artifact ?evaluation_channel)
        (artifact_stage_secondary ?decision_artifact)
        (not
          (artifact_available ?decision_artifact)
        )
      )
  )
  (:action assemble_and_stage_decision_artifact_multi
    :parameters (?scoped_rule_variant - scoped_rule_variant ?scoped_rule_variant_alt - scoped_rule_variant_alt ?evaluation_point - evaluation_point ?evaluation_channel - evaluation_channel ?decision_artifact - decision_artifact)
    :precondition
      (and
        (scoped_variant_ready ?scoped_rule_variant)
        (scoped_variant_alt_ready ?scoped_rule_variant_alt)
        (variant_evaluation_association ?scoped_rule_variant ?evaluation_point)
        (variant_evaluation_channel_association ?scoped_rule_variant_alt ?evaluation_channel)
        (evaluation_point_alternate_match ?evaluation_point)
        (evaluation_channel_alternate_ready ?evaluation_channel)
        (not
          (variant_resolved_match ?scoped_rule_variant)
        )
        (not
          (variant_evaluation_channel_resolved ?scoped_rule_variant_alt)
        )
        (artifact_available ?decision_artifact)
      )
    :effect
      (and
        (artifact_enriched ?decision_artifact)
        (artifact_evaluation_point_link ?decision_artifact ?evaluation_point)
        (artifact_evaluation_channel_link ?decision_artifact ?evaluation_channel)
        (artifact_stage_primary ?decision_artifact)
        (artifact_stage_secondary ?decision_artifact)
        (not
          (artifact_available ?decision_artifact)
        )
      )
  )
  (:action finalize_decision_artifact
    :parameters (?decision_artifact - decision_artifact ?scoped_rule_variant - scoped_rule_variant ?fact - fact)
    :precondition
      (and
        (artifact_enriched ?decision_artifact)
        (scoped_variant_ready ?scoped_rule_variant)
        (entity_fact_binding ?scoped_rule_variant ?fact)
        (not
          (artifact_ready ?decision_artifact)
        )
      )
    :effect (artifact_ready ?decision_artifact)
  )
  (:action bind_resource_to_artifact
    :parameters (?policy_unit - policy_unit ?resource - resource ?decision_artifact - decision_artifact)
    :precondition
      (and
        (entity_validated ?policy_unit)
        (policy_unit_artifact_association ?policy_unit ?decision_artifact)
        (policy_unit_resource_link ?policy_unit ?resource)
        (resource_available ?resource)
        (artifact_enriched ?decision_artifact)
        (artifact_ready ?decision_artifact)
        (not
          (resource_consumed ?resource)
        )
      )
    :effect
      (and
        (resource_consumed ?resource)
        (resource_bound_to_artifact ?resource ?decision_artifact)
        (not
          (resource_available ?resource)
        )
      )
  )
  (:action lock_policy_unit_for_resource_binding
    :parameters (?policy_unit - policy_unit ?resource - resource ?decision_artifact - decision_artifact ?fact - fact)
    :precondition
      (and
        (entity_validated ?policy_unit)
        (policy_unit_resource_link ?policy_unit ?resource)
        (resource_consumed ?resource)
        (resource_bound_to_artifact ?resource ?decision_artifact)
        (entity_fact_binding ?policy_unit ?fact)
        (not
          (artifact_stage_primary ?decision_artifact)
        )
        (not
          (policy_unit_locked ?policy_unit)
        )
      )
    :effect (policy_unit_locked ?policy_unit)
  )
  (:action attach_constraint_to_policy_unit
    :parameters (?policy_unit - policy_unit ?constraint_descriptor - constraint_descriptor)
    :precondition
      (and
        (entity_validated ?policy_unit)
        (constraint_available ?constraint_descriptor)
        (not
          (constraint_marked ?policy_unit)
        )
      )
    :effect
      (and
        (constraint_marked ?policy_unit)
        (policy_unit_constraint_link ?policy_unit ?constraint_descriptor)
        (not
          (constraint_available ?constraint_descriptor)
        )
      )
  )
  (:action apply_tag_and_advance_policy_unit_stage
    :parameters (?policy_unit - policy_unit ?resource - resource ?decision_artifact - decision_artifact ?fact - fact ?constraint_descriptor - constraint_descriptor)
    :precondition
      (and
        (entity_validated ?policy_unit)
        (policy_unit_resource_link ?policy_unit ?resource)
        (resource_consumed ?resource)
        (resource_bound_to_artifact ?resource ?decision_artifact)
        (entity_fact_binding ?policy_unit ?fact)
        (artifact_stage_primary ?decision_artifact)
        (constraint_marked ?policy_unit)
        (policy_unit_constraint_link ?policy_unit ?constraint_descriptor)
        (not
          (policy_unit_locked ?policy_unit)
        )
      )
    :effect
      (and
        (policy_unit_locked ?policy_unit)
        (constraint_stage_advanced ?policy_unit)
      )
  )
  (:action advance_policy_unit_with_guard_binding
    :parameters (?policy_unit - policy_unit ?guard_template - guard_template ?action_template - action_template ?resource - resource ?decision_artifact - decision_artifact)
    :precondition
      (and
        (policy_unit_locked ?policy_unit)
        (policy_unit_guard_link ?policy_unit ?guard_template)
        (entity_action_link ?policy_unit ?action_template)
        (policy_unit_resource_link ?policy_unit ?resource)
        (resource_bound_to_artifact ?resource ?decision_artifact)
        (not
          (artifact_stage_secondary ?decision_artifact)
        )
        (not
          (policy_unit_tagging_applied ?policy_unit)
        )
      )
    :effect (policy_unit_tagging_applied ?policy_unit)
  )
  (:action advance_policy_unit_with_guard_binding_alt
    :parameters (?policy_unit - policy_unit ?guard_template - guard_template ?action_template - action_template ?resource - resource ?decision_artifact - decision_artifact)
    :precondition
      (and
        (policy_unit_locked ?policy_unit)
        (policy_unit_guard_link ?policy_unit ?guard_template)
        (entity_action_link ?policy_unit ?action_template)
        (policy_unit_resource_link ?policy_unit ?resource)
        (resource_bound_to_artifact ?resource ?decision_artifact)
        (artifact_stage_secondary ?decision_artifact)
        (not
          (policy_unit_tagging_applied ?policy_unit)
        )
      )
    :effect (policy_unit_tagging_applied ?policy_unit)
  )
  (:action apply_priority_stage_to_policy_unit
    :parameters (?policy_unit - policy_unit ?priority_descriptor - priority_descriptor ?resource - resource ?decision_artifact - decision_artifact)
    :precondition
      (and
        (policy_unit_tagging_applied ?policy_unit)
        (policy_unit_priority_link ?policy_unit ?priority_descriptor)
        (policy_unit_resource_link ?policy_unit ?resource)
        (resource_bound_to_artifact ?resource ?decision_artifact)
        (not
          (artifact_stage_primary ?decision_artifact)
        )
        (not
          (artifact_stage_secondary ?decision_artifact)
        )
        (not
          (policy_unit_priority_stage ?policy_unit)
        )
      )
    :effect (policy_unit_priority_stage ?policy_unit)
  )
  (:action apply_priority_stage_with_advance
    :parameters (?policy_unit - policy_unit ?priority_descriptor - priority_descriptor ?resource - resource ?decision_artifact - decision_artifact)
    :precondition
      (and
        (policy_unit_tagging_applied ?policy_unit)
        (policy_unit_priority_link ?policy_unit ?priority_descriptor)
        (policy_unit_resource_link ?policy_unit ?resource)
        (resource_bound_to_artifact ?resource ?decision_artifact)
        (artifact_stage_primary ?decision_artifact)
        (not
          (artifact_stage_secondary ?decision_artifact)
        )
        (not
          (policy_unit_priority_stage ?policy_unit)
        )
      )
    :effect
      (and
        (policy_unit_priority_stage ?policy_unit)
        (priority_applied ?policy_unit)
      )
  )
  (:action apply_priority_stage_with_secondary
    :parameters (?policy_unit - policy_unit ?priority_descriptor - priority_descriptor ?resource - resource ?decision_artifact - decision_artifact)
    :precondition
      (and
        (policy_unit_tagging_applied ?policy_unit)
        (policy_unit_priority_link ?policy_unit ?priority_descriptor)
        (policy_unit_resource_link ?policy_unit ?resource)
        (resource_bound_to_artifact ?resource ?decision_artifact)
        (not
          (artifact_stage_primary ?decision_artifact)
        )
        (artifact_stage_secondary ?decision_artifact)
        (not
          (policy_unit_priority_stage ?policy_unit)
        )
      )
    :effect
      (and
        (policy_unit_priority_stage ?policy_unit)
        (priority_applied ?policy_unit)
      )
  )
  (:action apply_full_priority_stage
    :parameters (?policy_unit - policy_unit ?priority_descriptor - priority_descriptor ?resource - resource ?decision_artifact - decision_artifact)
    :precondition
      (and
        (policy_unit_tagging_applied ?policy_unit)
        (policy_unit_priority_link ?policy_unit ?priority_descriptor)
        (policy_unit_resource_link ?policy_unit ?resource)
        (resource_bound_to_artifact ?resource ?decision_artifact)
        (artifact_stage_primary ?decision_artifact)
        (artifact_stage_secondary ?decision_artifact)
        (not
          (policy_unit_priority_stage ?policy_unit)
        )
      )
    :effect
      (and
        (policy_unit_priority_stage ?policy_unit)
        (priority_applied ?policy_unit)
      )
  )
  (:action mark_policy_unit_execution_ready
    :parameters (?policy_unit - policy_unit)
    :precondition
      (and
        (policy_unit_priority_stage ?policy_unit)
        (not
          (priority_applied ?policy_unit)
        )
        (not
          (policy_unit_finalized ?policy_unit)
        )
      )
    :effect
      (and
        (policy_unit_finalized ?policy_unit)
        (execution_ready ?policy_unit)
      )
  )
  (:action attach_binding_template_to_policy_unit
    :parameters (?policy_unit - policy_unit ?binding_template - binding_template)
    :precondition
      (and
        (policy_unit_priority_stage ?policy_unit)
        (priority_applied ?policy_unit)
        (binding_template_available ?binding_template)
      )
    :effect
      (and
        (policy_unit_binding_template_link ?policy_unit ?binding_template)
        (not
          (binding_template_available ?binding_template)
        )
      )
  )
  (:action finalize_policy_unit_bindings
    :parameters (?policy_unit - policy_unit ?scoped_rule_variant - scoped_rule_variant ?scoped_rule_variant_alt - scoped_rule_variant_alt ?fact - fact ?binding_template - binding_template)
    :precondition
      (and
        (policy_unit_priority_stage ?policy_unit)
        (priority_applied ?policy_unit)
        (policy_unit_binding_template_link ?policy_unit ?binding_template)
        (policy_unit_variant_binding ?policy_unit ?scoped_rule_variant)
        (policy_unit_variant_alt_binding ?policy_unit ?scoped_rule_variant_alt)
        (variant_resolved_match ?scoped_rule_variant)
        (variant_evaluation_channel_resolved ?scoped_rule_variant_alt)
        (entity_fact_binding ?policy_unit ?fact)
        (not
          (policy_unit_bindings_finalized ?policy_unit)
        )
      )
    :effect (policy_unit_bindings_finalized ?policy_unit)
  )
  (:action mark_policy_unit_executable_after_bindings
    :parameters (?policy_unit - policy_unit)
    :precondition
      (and
        (policy_unit_priority_stage ?policy_unit)
        (policy_unit_bindings_finalized ?policy_unit)
        (not
          (policy_unit_finalized ?policy_unit)
        )
      )
    :effect
      (and
        (policy_unit_finalized ?policy_unit)
        (execution_ready ?policy_unit)
      )
  )
  (:action apply_tag_and_consume
    :parameters (?policy_unit - policy_unit ?tag - tag ?fact - fact)
    :precondition
      (and
        (entity_validated ?policy_unit)
        (entity_fact_binding ?policy_unit ?fact)
        (tag_available ?tag)
        (policy_unit_tag_link ?policy_unit ?tag)
        (not
          (policy_unit_tagged ?policy_unit)
        )
      )
    :effect
      (and
        (policy_unit_tagged ?policy_unit)
        (not
          (tag_available ?tag)
        )
      )
  )
  (:action approve_policy_unit_stage
    :parameters (?policy_unit - policy_unit ?action_template - action_template)
    :precondition
      (and
        (policy_unit_tagged ?policy_unit)
        (entity_action_link ?policy_unit ?action_template)
        (not
          (policy_unit_approval_pending ?policy_unit)
        )
      )
    :effect (policy_unit_approval_pending ?policy_unit)
  )
  (:action bind_priority_descriptor_to_policy_unit
    :parameters (?policy_unit - policy_unit ?priority_descriptor - priority_descriptor)
    :precondition
      (and
        (policy_unit_approval_pending ?policy_unit)
        (policy_unit_priority_link ?policy_unit ?priority_descriptor)
        (not
          (policy_unit_approved ?policy_unit)
        )
      )
    :effect (policy_unit_approved ?policy_unit)
  )
  (:action finalize_policy_unit_post_approval
    :parameters (?policy_unit - policy_unit)
    :precondition
      (and
        (policy_unit_approved ?policy_unit)
        (not
          (policy_unit_finalized ?policy_unit)
        )
      )
    :effect
      (and
        (policy_unit_finalized ?policy_unit)
        (execution_ready ?policy_unit)
      )
  )
  (:action mark_scoped_variant_execution_ready
    :parameters (?scoped_rule_variant - scoped_rule_variant ?decision_artifact - decision_artifact)
    :precondition
      (and
        (scoped_variant_ready ?scoped_rule_variant)
        (variant_resolved_match ?scoped_rule_variant)
        (artifact_enriched ?decision_artifact)
        (artifact_ready ?decision_artifact)
        (not
          (execution_ready ?scoped_rule_variant)
        )
      )
    :effect (execution_ready ?scoped_rule_variant)
  )
  (:action mark_scoped_variant_alt_execution_ready
    :parameters (?scoped_rule_variant_alt - scoped_rule_variant_alt ?decision_artifact - decision_artifact)
    :precondition
      (and
        (scoped_variant_alt_ready ?scoped_rule_variant_alt)
        (variant_evaluation_channel_resolved ?scoped_rule_variant_alt)
        (artifact_enriched ?decision_artifact)
        (artifact_ready ?decision_artifact)
        (not
          (execution_ready ?scoped_rule_variant_alt)
        )
      )
    :effect (execution_ready ?scoped_rule_variant_alt)
  )
  (:action finalize_rule_with_version
    :parameters (?rule - rule ?version_token - version_token ?fact - fact)
    :precondition
      (and
        (execution_ready ?rule)
        (entity_fact_binding ?rule ?fact)
        (version_token_available ?version_token)
        (not
          (entity_finalized ?rule)
        )
      )
    :effect
      (and
        (entity_finalized ?rule)
        (entity_version_association ?rule ?version_token)
        (not
          (version_token_available ?version_token)
        )
      )
  )
  (:action deploy_scoped_variant
    :parameters (?scoped_rule_variant - scoped_rule_variant ?condition_fragment - condition_fragment ?version_token - version_token)
    :precondition
      (and
        (entity_finalized ?scoped_rule_variant)
        (entity_fragment_link ?scoped_rule_variant ?condition_fragment)
        (entity_version_association ?scoped_rule_variant ?version_token)
        (not
          (entity_deployed ?scoped_rule_variant)
        )
      )
    :effect
      (and
        (entity_deployed ?scoped_rule_variant)
        (fragment_available ?condition_fragment)
        (version_token_available ?version_token)
      )
  )
  (:action deploy_scoped_variant_alt
    :parameters (?scoped_rule_variant_alt - scoped_rule_variant_alt ?condition_fragment - condition_fragment ?version_token - version_token)
    :precondition
      (and
        (entity_finalized ?scoped_rule_variant_alt)
        (entity_fragment_link ?scoped_rule_variant_alt ?condition_fragment)
        (entity_version_association ?scoped_rule_variant_alt ?version_token)
        (not
          (entity_deployed ?scoped_rule_variant_alt)
        )
      )
    :effect
      (and
        (entity_deployed ?scoped_rule_variant_alt)
        (fragment_available ?condition_fragment)
        (version_token_available ?version_token)
      )
  )
  (:action deploy_policy_unit
    :parameters (?policy_unit - policy_unit ?condition_fragment - condition_fragment ?version_token - version_token)
    :precondition
      (and
        (entity_finalized ?policy_unit)
        (entity_fragment_link ?policy_unit ?condition_fragment)
        (entity_version_association ?policy_unit ?version_token)
        (not
          (entity_deployed ?policy_unit)
        )
      )
    :effect
      (and
        (entity_deployed ?policy_unit)
        (fragment_available ?condition_fragment)
        (version_token_available ?version_token)
      )
  )
)

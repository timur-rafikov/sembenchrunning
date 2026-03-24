(define (domain bin_packing_under_size_limits)
  (:requirements :strips :typing :negative-preconditions)
  (:types auxiliary_group - object marker_group - object feature_group - object packable_root - object packable_element - packable_root bin_token - auxiliary_group size_attribute - auxiliary_group constraint_tag - auxiliary_group label_type - auxiliary_group policy_token - auxiliary_group final_artifact - auxiliary_group handler_resource - auxiliary_group inspector_resource - auxiliary_group transient_marker - marker_group item_unit - marker_group attribute_type - marker_group bin_feature_a - feature_group bin_feature_b - feature_group bin_candidate - feature_group input_item - packable_element plan_element - packable_element item_type_a - input_item item_type_b - input_item packing_plan - plan_element)
  (:predicates
    (selected ?packable_element - packable_element)
    (size_confirmed ?packable_element - packable_element)
    (bin_token_reserved ?packable_element - packable_element)
    (committed ?packable_element - packable_element)
    (ready_for_commit ?packable_element - packable_element)
    (artifact_produced ?packable_element - packable_element)
    (bin_token_available ?bin_token - bin_token)
    (bound_bin_token ?packable_element - packable_element ?bin_token - bin_token)
    (size_attr_available ?size_attr - size_attribute)
    (has_size_attribute ?packable_element - packable_element ?size_attr - size_attribute)
    (constraint_tag_available ?constraint_tag - constraint_tag)
    (has_constraint_tag ?packable_element - packable_element ?constraint_tag - constraint_tag)
    (marker_available ?transient_marker - transient_marker)
    (item_a_marker_attached ?item_a - item_type_a ?transient_marker - transient_marker)
    (item_b_marker_attached ?item_b - item_type_b ?transient_marker - transient_marker)
    (item_a_feature_match ?item_a - item_type_a ?bin_feature_a - bin_feature_a)
    (feature_a_claimed ?bin_feature_a - bin_feature_a)
    (feature_a_marker_claimed ?bin_feature_a - bin_feature_a)
    (item_a_feature_finalized ?item_a - item_type_a)
    (item_b_feature_match ?item_b - item_type_b ?bin_feature_b - bin_feature_b)
    (feature_b_claimed ?bin_feature_b - bin_feature_b)
    (feature_b_marker_claimed ?bin_feature_b - bin_feature_b)
    (item_b_feature_finalized ?item_b - item_type_b)
    (bin_candidate_available ?bin_candidate - bin_candidate)
    (bin_candidate_active ?bin_candidate - bin_candidate)
    (candidate_has_feature_a ?bin_candidate - bin_candidate ?bin_feature_a - bin_feature_a)
    (candidate_has_feature_b ?bin_candidate - bin_candidate ?bin_feature_b - bin_feature_b)
    (candidate_variant_a ?bin_candidate - bin_candidate)
    (candidate_variant_b ?bin_candidate - bin_candidate)
    (candidate_capacity_verified ?bin_candidate - bin_candidate)
    (plan_has_item_a ?plan - packing_plan ?item_a - item_type_a)
    (plan_has_item_b ?plan - packing_plan ?item_b - item_type_b)
    (plan_has_candidate ?plan - packing_plan ?bin_candidate - bin_candidate)
    (unit_available ?item_unit - item_unit)
    (plan_has_unit ?plan - packing_plan ?item_unit - item_unit)
    (unit_reserved ?item_unit - item_unit)
    (unit_assigned_to_candidate ?item_unit - item_unit ?bin_candidate - bin_candidate)
    (plan_label_ready ?plan - packing_plan)
    (plan_handler_attached ?plan - packing_plan)
    (plan_verified ?plan - packing_plan)
    (plan_label_applied ?plan - packing_plan)
    (plan_label_confirmed ?plan - packing_plan)
    (plan_policy_eligible ?plan - packing_plan)
    (plan_final_check_passed ?plan - packing_plan)
    (attribute_available ?attribute - attribute_type)
    (plan_has_attribute ?plan - packing_plan ?attribute - attribute_type)
    (plan_attribute_set ?plan - packing_plan)
    (plan_attribute_processed ?plan - packing_plan)
    (plan_attribute_finalized ?plan - packing_plan)
    (label_available ?label - label_type)
    (plan_has_label ?plan - packing_plan ?label - label_type)
    (policy_token_available ?policy_token - policy_token)
    (plan_policy_assigned ?plan - packing_plan ?policy_token - policy_token)
    (handler_available ?resource1 - handler_resource)
    (plan_handler_assigned ?plan - packing_plan ?resource1 - handler_resource)
    (inspector_available ?resource2 - inspector_resource)
    (plan_inspector_assigned ?plan - packing_plan ?resource2 - inspector_resource)
    (artifact_available ?final_artifact - final_artifact)
    (packable_element_has_artifact ?packable_element - packable_element ?final_artifact - final_artifact)
    (item_a_marked ?item_a - item_type_a)
    (item_b_marked ?item_b - item_type_b)
    (plan_commit_locked ?plan - packing_plan)
  )
  (:action select_packable_element
    :parameters (?packable_element - packable_element)
    :precondition
      (and
        (not
          (selected ?packable_element)
        )
        (not
          (committed ?packable_element)
        )
      )
    :effect (selected ?packable_element)
  )
  (:action reserve_bin_token
    :parameters (?packable_element - packable_element ?bin_token - bin_token)
    :precondition
      (and
        (selected ?packable_element)
        (not
          (bin_token_reserved ?packable_element)
        )
        (bin_token_available ?bin_token)
      )
    :effect
      (and
        (bin_token_reserved ?packable_element)
        (bound_bin_token ?packable_element ?bin_token)
        (not
          (bin_token_available ?bin_token)
        )
      )
  )
  (:action bind_size_attribute
    :parameters (?packable_element - packable_element ?size_attr - size_attribute)
    :precondition
      (and
        (selected ?packable_element)
        (bin_token_reserved ?packable_element)
        (size_attr_available ?size_attr)
      )
    :effect
      (and
        (has_size_attribute ?packable_element ?size_attr)
        (not
          (size_attr_available ?size_attr)
        )
      )
  )
  (:action confirm_size_assignment
    :parameters (?packable_element - packable_element ?size_attr - size_attribute)
    :precondition
      (and
        (selected ?packable_element)
        (bin_token_reserved ?packable_element)
        (has_size_attribute ?packable_element ?size_attr)
        (not
          (size_confirmed ?packable_element)
        )
      )
    :effect (size_confirmed ?packable_element)
  )
  (:action release_size_attribute
    :parameters (?packable_element - packable_element ?size_attr - size_attribute)
    :precondition
      (and
        (has_size_attribute ?packable_element ?size_attr)
      )
    :effect
      (and
        (size_attr_available ?size_attr)
        (not
          (has_size_attribute ?packable_element ?size_attr)
        )
      )
  )
  (:action attach_constraint_tag_to_packable_element
    :parameters (?packable_element - packable_element ?constraint_tag - constraint_tag)
    :precondition
      (and
        (size_confirmed ?packable_element)
        (constraint_tag_available ?constraint_tag)
      )
    :effect
      (and
        (has_constraint_tag ?packable_element ?constraint_tag)
        (not
          (constraint_tag_available ?constraint_tag)
        )
      )
  )
  (:action detach_constraint_tag_from_packable_element
    :parameters (?packable_element - packable_element ?constraint_tag - constraint_tag)
    :precondition
      (and
        (has_constraint_tag ?packable_element ?constraint_tag)
      )
    :effect
      (and
        (constraint_tag_available ?constraint_tag)
        (not
          (has_constraint_tag ?packable_element ?constraint_tag)
        )
      )
  )
  (:action assign_handler_to_plan
    :parameters (?plan - packing_plan ?resource1 - handler_resource)
    :precondition
      (and
        (size_confirmed ?plan)
        (handler_available ?resource1)
      )
    :effect
      (and
        (plan_handler_assigned ?plan ?resource1)
        (not
          (handler_available ?resource1)
        )
      )
  )
  (:action release_handler_from_plan
    :parameters (?plan - packing_plan ?resource1 - handler_resource)
    :precondition
      (and
        (plan_handler_assigned ?plan ?resource1)
      )
    :effect
      (and
        (handler_available ?resource1)
        (not
          (plan_handler_assigned ?plan ?resource1)
        )
      )
  )
  (:action assign_inspector_to_plan
    :parameters (?plan - packing_plan ?resource2 - inspector_resource)
    :precondition
      (and
        (size_confirmed ?plan)
        (inspector_available ?resource2)
      )
    :effect
      (and
        (plan_inspector_assigned ?plan ?resource2)
        (not
          (inspector_available ?resource2)
        )
      )
  )
  (:action release_inspector_from_plan
    :parameters (?plan - packing_plan ?resource2 - inspector_resource)
    :precondition
      (and
        (plan_inspector_assigned ?plan ?resource2)
      )
    :effect
      (and
        (inspector_available ?resource2)
        (not
          (plan_inspector_assigned ?plan ?resource2)
        )
      )
  )
  (:action claim_feature_a
    :parameters (?item_a - item_type_a ?bin_feature_a - bin_feature_a ?size_attr - size_attribute)
    :precondition
      (and
        (size_confirmed ?item_a)
        (has_size_attribute ?item_a ?size_attr)
        (item_a_feature_match ?item_a ?bin_feature_a)
        (not
          (feature_a_claimed ?bin_feature_a)
        )
        (not
          (feature_a_marker_claimed ?bin_feature_a)
        )
      )
    :effect (feature_a_claimed ?bin_feature_a)
  )
  (:action acknowledge_feature_a_claim
    :parameters (?item_a - item_type_a ?bin_feature_a - bin_feature_a ?constraint_tag - constraint_tag)
    :precondition
      (and
        (size_confirmed ?item_a)
        (has_constraint_tag ?item_a ?constraint_tag)
        (item_a_feature_match ?item_a ?bin_feature_a)
        (feature_a_claimed ?bin_feature_a)
        (not
          (item_a_marked ?item_a)
        )
      )
    :effect
      (and
        (item_a_marked ?item_a)
        (item_a_feature_finalized ?item_a)
      )
  )
  (:action claim_feature_a_with_marker
    :parameters (?item_a - item_type_a ?bin_feature_a - bin_feature_a ?transient_marker - transient_marker)
    :precondition
      (and
        (size_confirmed ?item_a)
        (item_a_feature_match ?item_a ?bin_feature_a)
        (marker_available ?transient_marker)
        (not
          (item_a_marked ?item_a)
        )
      )
    :effect
      (and
        (feature_a_marker_claimed ?bin_feature_a)
        (item_a_marked ?item_a)
        (item_a_marker_attached ?item_a ?transient_marker)
        (not
          (marker_available ?transient_marker)
        )
      )
  )
  (:action finalize_feature_a_from_marker
    :parameters (?item_a - item_type_a ?bin_feature_a - bin_feature_a ?size_attr - size_attribute ?transient_marker - transient_marker)
    :precondition
      (and
        (size_confirmed ?item_a)
        (has_size_attribute ?item_a ?size_attr)
        (item_a_feature_match ?item_a ?bin_feature_a)
        (feature_a_marker_claimed ?bin_feature_a)
        (item_a_marker_attached ?item_a ?transient_marker)
        (not
          (item_a_feature_finalized ?item_a)
        )
      )
    :effect
      (and
        (feature_a_claimed ?bin_feature_a)
        (item_a_feature_finalized ?item_a)
        (marker_available ?transient_marker)
        (not
          (item_a_marker_attached ?item_a ?transient_marker)
        )
      )
  )
  (:action claim_feature_b
    :parameters (?item_b - item_type_b ?bin_feature_b - bin_feature_b ?size_attr - size_attribute)
    :precondition
      (and
        (size_confirmed ?item_b)
        (has_size_attribute ?item_b ?size_attr)
        (item_b_feature_match ?item_b ?bin_feature_b)
        (not
          (feature_b_claimed ?bin_feature_b)
        )
        (not
          (feature_b_marker_claimed ?bin_feature_b)
        )
      )
    :effect (feature_b_claimed ?bin_feature_b)
  )
  (:action acknowledge_feature_b_claim
    :parameters (?item_b - item_type_b ?bin_feature_b - bin_feature_b ?constraint_tag - constraint_tag)
    :precondition
      (and
        (size_confirmed ?item_b)
        (has_constraint_tag ?item_b ?constraint_tag)
        (item_b_feature_match ?item_b ?bin_feature_b)
        (feature_b_claimed ?bin_feature_b)
        (not
          (item_b_marked ?item_b)
        )
      )
    :effect
      (and
        (item_b_marked ?item_b)
        (item_b_feature_finalized ?item_b)
      )
  )
  (:action claim_feature_b_with_marker
    :parameters (?item_b - item_type_b ?bin_feature_b - bin_feature_b ?transient_marker - transient_marker)
    :precondition
      (and
        (size_confirmed ?item_b)
        (item_b_feature_match ?item_b ?bin_feature_b)
        (marker_available ?transient_marker)
        (not
          (item_b_marked ?item_b)
        )
      )
    :effect
      (and
        (feature_b_marker_claimed ?bin_feature_b)
        (item_b_marked ?item_b)
        (item_b_marker_attached ?item_b ?transient_marker)
        (not
          (marker_available ?transient_marker)
        )
      )
  )
  (:action finalize_feature_b_from_marker
    :parameters (?item_b - item_type_b ?bin_feature_b - bin_feature_b ?size_attr - size_attribute ?transient_marker - transient_marker)
    :precondition
      (and
        (size_confirmed ?item_b)
        (has_size_attribute ?item_b ?size_attr)
        (item_b_feature_match ?item_b ?bin_feature_b)
        (feature_b_marker_claimed ?bin_feature_b)
        (item_b_marker_attached ?item_b ?transient_marker)
        (not
          (item_b_feature_finalized ?item_b)
        )
      )
    :effect
      (and
        (feature_b_claimed ?bin_feature_b)
        (item_b_feature_finalized ?item_b)
        (marker_available ?transient_marker)
        (not
          (item_b_marker_attached ?item_b ?transient_marker)
        )
      )
  )
  (:action create_bin_candidate_from_direct_claims
    :parameters (?item_a - item_type_a ?item_b - item_type_b ?bin_feature_a - bin_feature_a ?bin_feature_b - bin_feature_b ?bin_candidate - bin_candidate)
    :precondition
      (and
        (item_a_marked ?item_a)
        (item_b_marked ?item_b)
        (item_a_feature_match ?item_a ?bin_feature_a)
        (item_b_feature_match ?item_b ?bin_feature_b)
        (feature_a_claimed ?bin_feature_a)
        (feature_b_claimed ?bin_feature_b)
        (item_a_feature_finalized ?item_a)
        (item_b_feature_finalized ?item_b)
        (bin_candidate_available ?bin_candidate)
      )
    :effect
      (and
        (bin_candidate_active ?bin_candidate)
        (candidate_has_feature_a ?bin_candidate ?bin_feature_a)
        (candidate_has_feature_b ?bin_candidate ?bin_feature_b)
        (not
          (bin_candidate_available ?bin_candidate)
        )
      )
  )
  (:action create_bin_candidate_feature_a_marker
    :parameters (?item_a - item_type_a ?item_b - item_type_b ?bin_feature_a - bin_feature_a ?bin_feature_b - bin_feature_b ?bin_candidate - bin_candidate)
    :precondition
      (and
        (item_a_marked ?item_a)
        (item_b_marked ?item_b)
        (item_a_feature_match ?item_a ?bin_feature_a)
        (item_b_feature_match ?item_b ?bin_feature_b)
        (feature_a_marker_claimed ?bin_feature_a)
        (feature_b_claimed ?bin_feature_b)
        (not
          (item_a_feature_finalized ?item_a)
        )
        (item_b_feature_finalized ?item_b)
        (bin_candidate_available ?bin_candidate)
      )
    :effect
      (and
        (bin_candidate_active ?bin_candidate)
        (candidate_has_feature_a ?bin_candidate ?bin_feature_a)
        (candidate_has_feature_b ?bin_candidate ?bin_feature_b)
        (candidate_variant_a ?bin_candidate)
        (not
          (bin_candidate_available ?bin_candidate)
        )
      )
  )
  (:action create_bin_candidate_feature_b_marker
    :parameters (?item_a - item_type_a ?item_b - item_type_b ?bin_feature_a - bin_feature_a ?bin_feature_b - bin_feature_b ?bin_candidate - bin_candidate)
    :precondition
      (and
        (item_a_marked ?item_a)
        (item_b_marked ?item_b)
        (item_a_feature_match ?item_a ?bin_feature_a)
        (item_b_feature_match ?item_b ?bin_feature_b)
        (feature_a_claimed ?bin_feature_a)
        (feature_b_marker_claimed ?bin_feature_b)
        (item_a_feature_finalized ?item_a)
        (not
          (item_b_feature_finalized ?item_b)
        )
        (bin_candidate_available ?bin_candidate)
      )
    :effect
      (and
        (bin_candidate_active ?bin_candidate)
        (candidate_has_feature_a ?bin_candidate ?bin_feature_a)
        (candidate_has_feature_b ?bin_candidate ?bin_feature_b)
        (candidate_variant_b ?bin_candidate)
        (not
          (bin_candidate_available ?bin_candidate)
        )
      )
  )
  (:action create_bin_candidate_both_marker_claims
    :parameters (?item_a - item_type_a ?item_b - item_type_b ?bin_feature_a - bin_feature_a ?bin_feature_b - bin_feature_b ?bin_candidate - bin_candidate)
    :precondition
      (and
        (item_a_marked ?item_a)
        (item_b_marked ?item_b)
        (item_a_feature_match ?item_a ?bin_feature_a)
        (item_b_feature_match ?item_b ?bin_feature_b)
        (feature_a_marker_claimed ?bin_feature_a)
        (feature_b_marker_claimed ?bin_feature_b)
        (not
          (item_a_feature_finalized ?item_a)
        )
        (not
          (item_b_feature_finalized ?item_b)
        )
        (bin_candidate_available ?bin_candidate)
      )
    :effect
      (and
        (bin_candidate_active ?bin_candidate)
        (candidate_has_feature_a ?bin_candidate ?bin_feature_a)
        (candidate_has_feature_b ?bin_candidate ?bin_feature_b)
        (candidate_variant_a ?bin_candidate)
        (candidate_variant_b ?bin_candidate)
        (not
          (bin_candidate_available ?bin_candidate)
        )
      )
  )
  (:action verify_bin_candidate_capacity
    :parameters (?bin_candidate - bin_candidate ?item_a - item_type_a ?size_attr - size_attribute)
    :precondition
      (and
        (bin_candidate_active ?bin_candidate)
        (item_a_marked ?item_a)
        (has_size_attribute ?item_a ?size_attr)
        (not
          (candidate_capacity_verified ?bin_candidate)
        )
      )
    :effect (candidate_capacity_verified ?bin_candidate)
  )
  (:action reserve_unit_for_candidate
    :parameters (?plan - packing_plan ?item_unit - item_unit ?bin_candidate - bin_candidate)
    :precondition
      (and
        (size_confirmed ?plan)
        (plan_has_candidate ?plan ?bin_candidate)
        (plan_has_unit ?plan ?item_unit)
        (unit_available ?item_unit)
        (bin_candidate_active ?bin_candidate)
        (candidate_capacity_verified ?bin_candidate)
        (not
          (unit_reserved ?item_unit)
        )
      )
    :effect
      (and
        (unit_reserved ?item_unit)
        (unit_assigned_to_candidate ?item_unit ?bin_candidate)
        (not
          (unit_available ?item_unit)
        )
      )
  )
  (:action mark_plan_label_ready
    :parameters (?plan - packing_plan ?item_unit - item_unit ?bin_candidate - bin_candidate ?size_attr - size_attribute)
    :precondition
      (and
        (size_confirmed ?plan)
        (plan_has_unit ?plan ?item_unit)
        (unit_reserved ?item_unit)
        (unit_assigned_to_candidate ?item_unit ?bin_candidate)
        (has_size_attribute ?plan ?size_attr)
        (not
          (candidate_variant_a ?bin_candidate)
        )
        (not
          (plan_label_ready ?plan)
        )
      )
    :effect (plan_label_ready ?plan)
  )
  (:action apply_label_to_plan
    :parameters (?plan - packing_plan ?label - label_type)
    :precondition
      (and
        (size_confirmed ?plan)
        (label_available ?label)
        (not
          (plan_label_applied ?plan)
        )
      )
    :effect
      (and
        (plan_label_applied ?plan)
        (plan_has_label ?plan ?label)
        (not
          (label_available ?label)
        )
      )
  )
  (:action confirm_label_and_units_on_plan
    :parameters (?plan - packing_plan ?item_unit - item_unit ?bin_candidate - bin_candidate ?size_attr - size_attribute ?label - label_type)
    :precondition
      (and
        (size_confirmed ?plan)
        (plan_has_unit ?plan ?item_unit)
        (unit_reserved ?item_unit)
        (unit_assigned_to_candidate ?item_unit ?bin_candidate)
        (has_size_attribute ?plan ?size_attr)
        (candidate_variant_a ?bin_candidate)
        (plan_label_applied ?plan)
        (plan_has_label ?plan ?label)
        (not
          (plan_label_ready ?plan)
        )
      )
    :effect
      (and
        (plan_label_ready ?plan)
        (plan_label_confirmed ?plan)
      )
  )
  (:action attach_handler_and_lock_plan
    :parameters (?plan - packing_plan ?resource1 - handler_resource ?constraint_tag - constraint_tag ?item_unit - item_unit ?bin_candidate - bin_candidate)
    :precondition
      (and
        (plan_label_ready ?plan)
        (plan_handler_assigned ?plan ?resource1)
        (has_constraint_tag ?plan ?constraint_tag)
        (plan_has_unit ?plan ?item_unit)
        (unit_assigned_to_candidate ?item_unit ?bin_candidate)
        (not
          (candidate_variant_b ?bin_candidate)
        )
        (not
          (plan_handler_attached ?plan)
        )
      )
    :effect (plan_handler_attached ?plan)
  )
  (:action attach_handler_and_lock_plan_variant
    :parameters (?plan - packing_plan ?resource1 - handler_resource ?constraint_tag - constraint_tag ?item_unit - item_unit ?bin_candidate - bin_candidate)
    :precondition
      (and
        (plan_label_ready ?plan)
        (plan_handler_assigned ?plan ?resource1)
        (has_constraint_tag ?plan ?constraint_tag)
        (plan_has_unit ?plan ?item_unit)
        (unit_assigned_to_candidate ?item_unit ?bin_candidate)
        (candidate_variant_b ?bin_candidate)
        (not
          (plan_handler_attached ?plan)
        )
      )
    :effect (plan_handler_attached ?plan)
  )
  (:action apply_inspector_and_mark_verified
    :parameters (?plan - packing_plan ?resource2 - inspector_resource ?item_unit - item_unit ?bin_candidate - bin_candidate)
    :precondition
      (and
        (plan_handler_attached ?plan)
        (plan_inspector_assigned ?plan ?resource2)
        (plan_has_unit ?plan ?item_unit)
        (unit_assigned_to_candidate ?item_unit ?bin_candidate)
        (not
          (candidate_variant_a ?bin_candidate)
        )
        (not
          (candidate_variant_b ?bin_candidate)
        )
        (not
          (plan_verified ?plan)
        )
      )
    :effect (plan_verified ?plan)
  )
  (:action apply_inspector_and_open_policy_slot
    :parameters (?plan - packing_plan ?resource2 - inspector_resource ?item_unit - item_unit ?bin_candidate - bin_candidate)
    :precondition
      (and
        (plan_handler_attached ?plan)
        (plan_inspector_assigned ?plan ?resource2)
        (plan_has_unit ?plan ?item_unit)
        (unit_assigned_to_candidate ?item_unit ?bin_candidate)
        (candidate_variant_a ?bin_candidate)
        (not
          (candidate_variant_b ?bin_candidate)
        )
        (not
          (plan_verified ?plan)
        )
      )
    :effect
      (and
        (plan_verified ?plan)
        (plan_policy_eligible ?plan)
      )
  )
  (:action apply_inspector_and_open_policy_slot_variant
    :parameters (?plan - packing_plan ?resource2 - inspector_resource ?item_unit - item_unit ?bin_candidate - bin_candidate)
    :precondition
      (and
        (plan_handler_attached ?plan)
        (plan_inspector_assigned ?plan ?resource2)
        (plan_has_unit ?plan ?item_unit)
        (unit_assigned_to_candidate ?item_unit ?bin_candidate)
        (not
          (candidate_variant_a ?bin_candidate)
        )
        (candidate_variant_b ?bin_candidate)
        (not
          (plan_verified ?plan)
        )
      )
    :effect
      (and
        (plan_verified ?plan)
        (plan_policy_eligible ?plan)
      )
  )
  (:action apply_inspector_and_open_policy_slot_both
    :parameters (?plan - packing_plan ?resource2 - inspector_resource ?item_unit - item_unit ?bin_candidate - bin_candidate)
    :precondition
      (and
        (plan_handler_attached ?plan)
        (plan_inspector_assigned ?plan ?resource2)
        (plan_has_unit ?plan ?item_unit)
        (unit_assigned_to_candidate ?item_unit ?bin_candidate)
        (candidate_variant_a ?bin_candidate)
        (candidate_variant_b ?bin_candidate)
        (not
          (plan_verified ?plan)
        )
      )
    :effect
      (and
        (plan_verified ?plan)
        (plan_policy_eligible ?plan)
      )
  )
  (:action finalize_plan_ready
    :parameters (?plan - packing_plan)
    :precondition
      (and
        (plan_verified ?plan)
        (not
          (plan_policy_eligible ?plan)
        )
        (not
          (plan_commit_locked ?plan)
        )
      )
    :effect
      (and
        (plan_commit_locked ?plan)
        (ready_for_commit ?plan)
      )
  )
  (:action assign_policy_token_to_plan
    :parameters (?plan - packing_plan ?policy_token - policy_token)
    :precondition
      (and
        (plan_verified ?plan)
        (plan_policy_eligible ?plan)
        (policy_token_available ?policy_token)
      )
    :effect
      (and
        (plan_policy_assigned ?plan ?policy_token)
        (not
          (policy_token_available ?policy_token)
        )
      )
  )
  (:action perform_plan_final_checks
    :parameters (?plan - packing_plan ?item_a - item_type_a ?item_b - item_type_b ?size_attr - size_attribute ?policy_token - policy_token)
    :precondition
      (and
        (plan_verified ?plan)
        (plan_policy_eligible ?plan)
        (plan_policy_assigned ?plan ?policy_token)
        (plan_has_item_a ?plan ?item_a)
        (plan_has_item_b ?plan ?item_b)
        (item_a_feature_finalized ?item_a)
        (item_b_feature_finalized ?item_b)
        (has_size_attribute ?plan ?size_attr)
        (not
          (plan_final_check_passed ?plan)
        )
      )
    :effect (plan_final_check_passed ?plan)
  )
  (:action confirm_plan_ready_after_checks
    :parameters (?plan - packing_plan)
    :precondition
      (and
        (plan_verified ?plan)
        (plan_final_check_passed ?plan)
        (not
          (plan_commit_locked ?plan)
        )
      )
    :effect
      (and
        (plan_commit_locked ?plan)
        (ready_for_commit ?plan)
      )
  )
  (:action apply_attribute_to_plan
    :parameters (?plan - packing_plan ?attribute - attribute_type ?size_attr - size_attribute)
    :precondition
      (and
        (size_confirmed ?plan)
        (has_size_attribute ?plan ?size_attr)
        (attribute_available ?attribute)
        (plan_has_attribute ?plan ?attribute)
        (not
          (plan_attribute_set ?plan)
        )
      )
    :effect
      (and
        (plan_attribute_set ?plan)
        (not
          (attribute_available ?attribute)
        )
      )
  )
  (:action process_plan_attribute
    :parameters (?plan - packing_plan ?constraint_tag - constraint_tag)
    :precondition
      (and
        (plan_attribute_set ?plan)
        (has_constraint_tag ?plan ?constraint_tag)
        (not
          (plan_attribute_processed ?plan)
        )
      )
    :effect (plan_attribute_processed ?plan)
  )
  (:action assign_inspector_to_attribute_process
    :parameters (?plan - packing_plan ?resource2 - inspector_resource)
    :precondition
      (and
        (plan_attribute_processed ?plan)
        (plan_inspector_assigned ?plan ?resource2)
        (not
          (plan_attribute_finalized ?plan)
        )
      )
    :effect (plan_attribute_finalized ?plan)
  )
  (:action finalize_attribute_and_mark_plan_for_commit
    :parameters (?plan - packing_plan)
    :precondition
      (and
        (plan_attribute_finalized ?plan)
        (not
          (plan_commit_locked ?plan)
        )
      )
    :effect
      (and
        (plan_commit_locked ?plan)
        (ready_for_commit ?plan)
      )
  )
  (:action commit_item_from_candidate
    :parameters (?item_a - item_type_a ?bin_candidate - bin_candidate)
    :precondition
      (and
        (item_a_marked ?item_a)
        (item_a_feature_finalized ?item_a)
        (bin_candidate_active ?bin_candidate)
        (candidate_capacity_verified ?bin_candidate)
        (not
          (ready_for_commit ?item_a)
        )
      )
    :effect (ready_for_commit ?item_a)
  )
  (:action commit_item_from_candidate_b
    :parameters (?item_b - item_type_b ?bin_candidate - bin_candidate)
    :precondition
      (and
        (item_b_marked ?item_b)
        (item_b_feature_finalized ?item_b)
        (bin_candidate_active ?bin_candidate)
        (candidate_capacity_verified ?bin_candidate)
        (not
          (ready_for_commit ?item_b)
        )
      )
    :effect (ready_for_commit ?item_b)
  )
  (:action create_final_artifact_for_packable_element
    :parameters (?packable_element - packable_element ?final_artifact - final_artifact ?size_attr - size_attribute)
    :precondition
      (and
        (ready_for_commit ?packable_element)
        (has_size_attribute ?packable_element ?size_attr)
        (artifact_available ?final_artifact)
        (not
          (artifact_produced ?packable_element)
        )
      )
    :effect
      (and
        (artifact_produced ?packable_element)
        (packable_element_has_artifact ?packable_element ?final_artifact)
        (not
          (artifact_available ?final_artifact)
        )
      )
  )
  (:action finalize_and_release_for_item_a
    :parameters (?item_a - item_type_a ?bin_token - bin_token ?final_artifact - final_artifact)
    :precondition
      (and
        (artifact_produced ?item_a)
        (bound_bin_token ?item_a ?bin_token)
        (packable_element_has_artifact ?item_a ?final_artifact)
        (not
          (committed ?item_a)
        )
      )
    :effect
      (and
        (committed ?item_a)
        (bin_token_available ?bin_token)
        (artifact_available ?final_artifact)
      )
  )
  (:action finalize_and_release_for_item_b
    :parameters (?item_b - item_type_b ?bin_token - bin_token ?final_artifact - final_artifact)
    :precondition
      (and
        (artifact_produced ?item_b)
        (bound_bin_token ?item_b ?bin_token)
        (packable_element_has_artifact ?item_b ?final_artifact)
        (not
          (committed ?item_b)
        )
      )
    :effect
      (and
        (committed ?item_b)
        (bin_token_available ?bin_token)
        (artifact_available ?final_artifact)
      )
  )
  (:action finalize_and_release_for_plan
    :parameters (?plan - packing_plan ?bin_token - bin_token ?final_artifact - final_artifact)
    :precondition
      (and
        (artifact_produced ?plan)
        (bound_bin_token ?plan ?bin_token)
        (packable_element_has_artifact ?plan ?final_artifact)
        (not
          (committed ?plan)
        )
      )
    :effect
      (and
        (committed ?plan)
        (bin_token_available ?bin_token)
        (artifact_available ?final_artifact)
      )
  )
)

(define (domain record_deduplication_priority)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_object - object auxiliary_token_group - domain_object resource_token_group - domain_object preference_token_group - domain_object record_root - domain_object record - record_root priority_slot - auxiliary_token_group attribute_slot - auxiliary_token_group matcher_worker - auxiliary_token_group preference_token_a - auxiliary_token_group preference_token_b - auxiliary_token_group priority_marker - auxiliary_token_group attribute_priority_token - auxiliary_token_group finalizer_token - auxiliary_token_group feature_slot - resource_token_group secondary_key - resource_token_group tie_breaker_token - resource_token_group bucket_key_a - preference_token_group bucket_key_b - preference_token_group container - preference_token_group input_record_group - record merged_candidate_group - record input_record_a - input_record_group input_record_b - input_record_group merged_candidate - merged_candidate_group)

  (:predicates
    (record_registered ?record - record)
    (eligible_for_processing ?record - record)
    (has_bound_priority ?record - record)
    (output_mark ?record - record)
    (selected_marker ?record - record)
    (finalization_ready ?record - record)
    (priority_slot_available ?priority_slot - priority_slot)
    (bound_to_priority_slot ?record - record ?priority_slot - priority_slot)
    (attribute_slot_available ?attribute_slot - attribute_slot)
    (attribute_link ?record - record ?attribute_slot - attribute_slot)
    (matcher_worker_available ?matcher_worker - matcher_worker)
    (bound_to_matcher ?record - record ?matcher_worker - matcher_worker)
    (feature_slot_available ?feature_slot - feature_slot)
    (attached_feature_slot_a ?input_record_a - input_record_a ?feature_slot - feature_slot)
    (attached_feature_slot_b ?input_record_b - input_record_b ?feature_slot - feature_slot)
    (bucket_key_map_a ?input_record_a - input_record_a ?bucket_key_a - bucket_key_a)
    (bucket_key_a_primary ?bucket_key_a - bucket_key_a)
    (bucket_key_a_secondary ?bucket_key_a - bucket_key_a)
    (record_a_confirmed ?input_record_a - input_record_a)
    (bucket_key_map_b ?input_record_b - input_record_b ?bucket_key_b - bucket_key_b)
    (bucket_key_b_primary ?bucket_key_b - bucket_key_b)
    (bucket_key_b_secondary ?bucket_key_b - bucket_key_b)
    (record_b_confirmed ?input_record_b - input_record_b)
    (container_available ?output_container - container)
    (container_reserved ?output_container - container)
    (container_assigned_bucket_a ?output_container - container ?bucket_key_a - bucket_key_a)
    (container_assigned_bucket_b ?output_container - container ?bucket_key_b - bucket_key_b)
    (container_flag_primary ?output_container - container)
    (container_flag_secondary ?output_container - container)
    (container_activated ?output_container - container)
    (candidate_contains_input_a ?merged_candidate - merged_candidate ?input_record_a - input_record_a)
    (candidate_contains_input_b ?merged_candidate - merged_candidate ?input_record_b - input_record_b)
    (candidate_assigned_container ?merged_candidate - merged_candidate ?output_container - container)
    (secondary_key_available ?secondary_key - secondary_key)
    (candidate_has_secondary_key ?merged_candidate - merged_candidate ?secondary_key - secondary_key)
    (secondary_key_reserved ?secondary_key - secondary_key)
    (secondary_key_assigned_to_container ?secondary_key - secondary_key ?output_container - container)
    (preference_applied_flag ?merged_candidate - merged_candidate)
    (feature_applied_flag ?merged_candidate - merged_candidate)
    (tie_breaker_applied_flag ?merged_candidate - merged_candidate)
    (preference_attached_flag ?merged_candidate - merged_candidate)
    (preference_combined_flag ?merged_candidate - merged_candidate)
    (preference_feature_combined ?merged_candidate - merged_candidate)
    (canonical_candidate_flag ?merged_candidate - merged_candidate)
    (tie_breaker_available ?tie_breaker_token - tie_breaker_token)
    (candidate_has_tie_breaker ?merged_candidate - merged_candidate ?tie_breaker_token - tie_breaker_token)
    (tie_breaker_claimed ?merged_candidate - merged_candidate)
    (tie_breaker_ready ?merged_candidate - merged_candidate)
    (tie_breaker_finalized_flag ?merged_candidate - merged_candidate)
    (preference_token_a_available ?preference_token_a - preference_token_a)
    (candidate_has_preference_token_a ?merged_candidate - merged_candidate ?preference_token_a - preference_token_a)
    (preference_token_b_available ?preference_token_b - preference_token_b)
    (candidate_has_preference_token_b ?merged_candidate - merged_candidate ?preference_token_b - preference_token_b)
    (attribute_priority_token_available ?attribute_priority_token - attribute_priority_token)
    (candidate_has_attribute_priority_token ?merged_candidate - merged_candidate ?attribute_priority_token - attribute_priority_token)
    (finalizer_token_available ?finalizer_token - finalizer_token)
    (candidate_has_finalizer_token ?merged_candidate - merged_candidate ?finalizer_token - finalizer_token)
    (priority_marker_available ?priority_marker - priority_marker)
    (record_bound_priority_marker ?record - record ?priority_marker - priority_marker)
    (input_a_processed_flag ?input_record_a - input_record_a)
    (input_b_processed_flag ?input_record_b - input_record_b)
    (candidate_finalized ?merged_candidate - merged_candidate)
  )
  (:action register_record
    :parameters (?record - record)
    :precondition
      (and
        (not
          (record_registered ?record)
        )
        (not
          (output_mark ?record)
        )
      )
    :effect (record_registered ?record)
  )
  (:action assign_priority_slot
    :parameters (?record - record ?priority_slot - priority_slot)
    :precondition
      (and
        (record_registered ?record)
        (not
          (has_bound_priority ?record)
        )
        (priority_slot_available ?priority_slot)
      )
    :effect
      (and
        (has_bound_priority ?record)
        (bound_to_priority_slot ?record ?priority_slot)
        (not
          (priority_slot_available ?priority_slot)
        )
      )
  )
  (:action assign_attribute_slot
    :parameters (?record - record ?attribute_slot - attribute_slot)
    :precondition
      (and
        (record_registered ?record)
        (has_bound_priority ?record)
        (attribute_slot_available ?attribute_slot)
      )
    :effect
      (and
        (attribute_link ?record ?attribute_slot)
        (not
          (attribute_slot_available ?attribute_slot)
        )
      )
  )
  (:action confirm_record_eligibility
    :parameters (?record - record ?attribute_slot - attribute_slot)
    :precondition
      (and
        (record_registered ?record)
        (has_bound_priority ?record)
        (attribute_link ?record ?attribute_slot)
        (not
          (eligible_for_processing ?record)
        )
      )
    :effect (eligible_for_processing ?record)
  )
  (:action release_attribute_slot
    :parameters (?record - record ?attribute_slot - attribute_slot)
    :precondition
      (and
        (attribute_link ?record ?attribute_slot)
      )
    :effect
      (and
        (attribute_slot_available ?attribute_slot)
        (not
          (attribute_link ?record ?attribute_slot)
        )
      )
  )
  (:action assign_matcher_worker
    :parameters (?record - record ?matcher_worker - matcher_worker)
    :precondition
      (and
        (eligible_for_processing ?record)
        (matcher_worker_available ?matcher_worker)
      )
    :effect
      (and
        (bound_to_matcher ?record ?matcher_worker)
        (not
          (matcher_worker_available ?matcher_worker)
        )
      )
  )
  (:action release_matcher_worker
    :parameters (?record - record ?matcher_worker - matcher_worker)
    :precondition
      (and
        (bound_to_matcher ?record ?matcher_worker)
      )
    :effect
      (and
        (matcher_worker_available ?matcher_worker)
        (not
          (bound_to_matcher ?record ?matcher_worker)
        )
      )
  )
  (:action attach_attribute_priority_token
    :parameters (?merged_candidate - merged_candidate ?attribute_priority_token - attribute_priority_token)
    :precondition
      (and
        (eligible_for_processing ?merged_candidate)
        (attribute_priority_token_available ?attribute_priority_token)
      )
    :effect
      (and
        (candidate_has_attribute_priority_token ?merged_candidate ?attribute_priority_token)
        (not
          (attribute_priority_token_available ?attribute_priority_token)
        )
      )
  )
  (:action release_attribute_priority_token
    :parameters (?merged_candidate - merged_candidate ?attribute_priority_token - attribute_priority_token)
    :precondition
      (and
        (candidate_has_attribute_priority_token ?merged_candidate ?attribute_priority_token)
      )
    :effect
      (and
        (attribute_priority_token_available ?attribute_priority_token)
        (not
          (candidate_has_attribute_priority_token ?merged_candidate ?attribute_priority_token)
        )
      )
  )
  (:action attach_finalizer_token
    :parameters (?merged_candidate - merged_candidate ?finalizer_token - finalizer_token)
    :precondition
      (and
        (eligible_for_processing ?merged_candidate)
        (finalizer_token_available ?finalizer_token)
      )
    :effect
      (and
        (candidate_has_finalizer_token ?merged_candidate ?finalizer_token)
        (not
          (finalizer_token_available ?finalizer_token)
        )
      )
  )
  (:action release_finalizer_token
    :parameters (?merged_candidate - merged_candidate ?finalizer_token - finalizer_token)
    :precondition
      (and
        (candidate_has_finalizer_token ?merged_candidate ?finalizer_token)
      )
    :effect
      (and
        (finalizer_token_available ?finalizer_token)
        (not
          (candidate_has_finalizer_token ?merged_candidate ?finalizer_token)
        )
      )
  )
  (:action propose_bucket_a_primary
    :parameters (?input_record_a - input_record_a ?bucket_key_a - bucket_key_a ?attribute_slot - attribute_slot)
    :precondition
      (and
        (eligible_for_processing ?input_record_a)
        (attribute_link ?input_record_a ?attribute_slot)
        (bucket_key_map_a ?input_record_a ?bucket_key_a)
        (not
          (bucket_key_a_primary ?bucket_key_a)
        )
        (not
          (bucket_key_a_secondary ?bucket_key_a)
        )
      )
    :effect (bucket_key_a_primary ?bucket_key_a)
  )
  (:action confirm_bucket_assignment_a
    :parameters (?input_record_a - input_record_a ?bucket_key_a - bucket_key_a ?matcher_worker - matcher_worker)
    :precondition
      (and
        (eligible_for_processing ?input_record_a)
        (bound_to_matcher ?input_record_a ?matcher_worker)
        (bucket_key_map_a ?input_record_a ?bucket_key_a)
        (bucket_key_a_primary ?bucket_key_a)
        (not
          (input_a_processed_flag ?input_record_a)
        )
      )
    :effect
      (and
        (input_a_processed_flag ?input_record_a)
        (record_a_confirmed ?input_record_a)
      )
  )
  (:action propose_bucket_a_with_feature
    :parameters (?input_record_a - input_record_a ?bucket_key_a - bucket_key_a ?feature_slot - feature_slot)
    :precondition
      (and
        (eligible_for_processing ?input_record_a)
        (bucket_key_map_a ?input_record_a ?bucket_key_a)
        (feature_slot_available ?feature_slot)
        (not
          (input_a_processed_flag ?input_record_a)
        )
      )
    :effect
      (and
        (bucket_key_a_secondary ?bucket_key_a)
        (input_a_processed_flag ?input_record_a)
        (attached_feature_slot_a ?input_record_a ?feature_slot)
        (not
          (feature_slot_available ?feature_slot)
        )
      )
  )
  (:action resolve_bucket_a_with_feature
    :parameters (?input_record_a - input_record_a ?bucket_key_a - bucket_key_a ?attribute_slot - attribute_slot ?feature_slot - feature_slot)
    :precondition
      (and
        (eligible_for_processing ?input_record_a)
        (attribute_link ?input_record_a ?attribute_slot)
        (bucket_key_map_a ?input_record_a ?bucket_key_a)
        (bucket_key_a_secondary ?bucket_key_a)
        (attached_feature_slot_a ?input_record_a ?feature_slot)
        (not
          (record_a_confirmed ?input_record_a)
        )
      )
    :effect
      (and
        (bucket_key_a_primary ?bucket_key_a)
        (record_a_confirmed ?input_record_a)
        (feature_slot_available ?feature_slot)
        (not
          (attached_feature_slot_a ?input_record_a ?feature_slot)
        )
      )
  )
  (:action propose_bucket_b_primary
    :parameters (?input_record_b - input_record_b ?bucket_key_b - bucket_key_b ?attribute_slot - attribute_slot)
    :precondition
      (and
        (eligible_for_processing ?input_record_b)
        (attribute_link ?input_record_b ?attribute_slot)
        (bucket_key_map_b ?input_record_b ?bucket_key_b)
        (not
          (bucket_key_b_primary ?bucket_key_b)
        )
        (not
          (bucket_key_b_secondary ?bucket_key_b)
        )
      )
    :effect (bucket_key_b_primary ?bucket_key_b)
  )
  (:action confirm_bucket_assignment_b
    :parameters (?input_record_b - input_record_b ?bucket_key_b - bucket_key_b ?matcher_worker - matcher_worker)
    :precondition
      (and
        (eligible_for_processing ?input_record_b)
        (bound_to_matcher ?input_record_b ?matcher_worker)
        (bucket_key_map_b ?input_record_b ?bucket_key_b)
        (bucket_key_b_primary ?bucket_key_b)
        (not
          (input_b_processed_flag ?input_record_b)
        )
      )
    :effect
      (and
        (input_b_processed_flag ?input_record_b)
        (record_b_confirmed ?input_record_b)
      )
  )
  (:action propose_bucket_b_with_feature
    :parameters (?input_record_b - input_record_b ?bucket_key_b - bucket_key_b ?feature_slot - feature_slot)
    :precondition
      (and
        (eligible_for_processing ?input_record_b)
        (bucket_key_map_b ?input_record_b ?bucket_key_b)
        (feature_slot_available ?feature_slot)
        (not
          (input_b_processed_flag ?input_record_b)
        )
      )
    :effect
      (and
        (bucket_key_b_secondary ?bucket_key_b)
        (input_b_processed_flag ?input_record_b)
        (attached_feature_slot_b ?input_record_b ?feature_slot)
        (not
          (feature_slot_available ?feature_slot)
        )
      )
  )
  (:action resolve_bucket_b_with_feature
    :parameters (?input_record_b - input_record_b ?bucket_key_b - bucket_key_b ?attribute_slot - attribute_slot ?feature_slot - feature_slot)
    :precondition
      (and
        (eligible_for_processing ?input_record_b)
        (attribute_link ?input_record_b ?attribute_slot)
        (bucket_key_map_b ?input_record_b ?bucket_key_b)
        (bucket_key_b_secondary ?bucket_key_b)
        (attached_feature_slot_b ?input_record_b ?feature_slot)
        (not
          (record_b_confirmed ?input_record_b)
        )
      )
    :effect
      (and
        (bucket_key_b_primary ?bucket_key_b)
        (record_b_confirmed ?input_record_b)
        (feature_slot_available ?feature_slot)
        (not
          (attached_feature_slot_b ?input_record_b ?feature_slot)
        )
      )
  )
  (:action allocate_container_primary_a_primary_b
    :parameters (?input_record_a - input_record_a ?input_record_b - input_record_b ?bucket_key_a - bucket_key_a ?bucket_key_b - bucket_key_b ?output_container - container)
    :precondition
      (and
        (input_a_processed_flag ?input_record_a)
        (input_b_processed_flag ?input_record_b)
        (bucket_key_map_a ?input_record_a ?bucket_key_a)
        (bucket_key_map_b ?input_record_b ?bucket_key_b)
        (bucket_key_a_primary ?bucket_key_a)
        (bucket_key_b_primary ?bucket_key_b)
        (record_a_confirmed ?input_record_a)
        (record_b_confirmed ?input_record_b)
        (container_available ?output_container)
      )
    :effect
      (and
        (container_reserved ?output_container)
        (container_assigned_bucket_a ?output_container ?bucket_key_a)
        (container_assigned_bucket_b ?output_container ?bucket_key_b)
        (not
          (container_available ?output_container)
        )
      )
  )
  (:action allocate_container_secondary_a_primary_b
    :parameters (?input_record_a - input_record_a ?input_record_b - input_record_b ?bucket_key_a - bucket_key_a ?bucket_key_b - bucket_key_b ?output_container - container)
    :precondition
      (and
        (input_a_processed_flag ?input_record_a)
        (input_b_processed_flag ?input_record_b)
        (bucket_key_map_a ?input_record_a ?bucket_key_a)
        (bucket_key_map_b ?input_record_b ?bucket_key_b)
        (bucket_key_a_secondary ?bucket_key_a)
        (bucket_key_b_primary ?bucket_key_b)
        (not
          (record_a_confirmed ?input_record_a)
        )
        (record_b_confirmed ?input_record_b)
        (container_available ?output_container)
      )
    :effect
      (and
        (container_reserved ?output_container)
        (container_assigned_bucket_a ?output_container ?bucket_key_a)
        (container_assigned_bucket_b ?output_container ?bucket_key_b)
        (container_flag_primary ?output_container)
        (not
          (container_available ?output_container)
        )
      )
  )
  (:action allocate_container_primary_a_secondary_b
    :parameters (?input_record_a - input_record_a ?input_record_b - input_record_b ?bucket_key_a - bucket_key_a ?bucket_key_b - bucket_key_b ?output_container - container)
    :precondition
      (and
        (input_a_processed_flag ?input_record_a)
        (input_b_processed_flag ?input_record_b)
        (bucket_key_map_a ?input_record_a ?bucket_key_a)
        (bucket_key_map_b ?input_record_b ?bucket_key_b)
        (bucket_key_a_primary ?bucket_key_a)
        (bucket_key_b_secondary ?bucket_key_b)
        (record_a_confirmed ?input_record_a)
        (not
          (record_b_confirmed ?input_record_b)
        )
        (container_available ?output_container)
      )
    :effect
      (and
        (container_reserved ?output_container)
        (container_assigned_bucket_a ?output_container ?bucket_key_a)
        (container_assigned_bucket_b ?output_container ?bucket_key_b)
        (container_flag_secondary ?output_container)
        (not
          (container_available ?output_container)
        )
      )
  )
  (:action allocate_container_secondary_a_secondary_b
    :parameters (?input_record_a - input_record_a ?input_record_b - input_record_b ?bucket_key_a - bucket_key_a ?bucket_key_b - bucket_key_b ?output_container - container)
    :precondition
      (and
        (input_a_processed_flag ?input_record_a)
        (input_b_processed_flag ?input_record_b)
        (bucket_key_map_a ?input_record_a ?bucket_key_a)
        (bucket_key_map_b ?input_record_b ?bucket_key_b)
        (bucket_key_a_secondary ?bucket_key_a)
        (bucket_key_b_secondary ?bucket_key_b)
        (not
          (record_a_confirmed ?input_record_a)
        )
        (not
          (record_b_confirmed ?input_record_b)
        )
        (container_available ?output_container)
      )
    :effect
      (and
        (container_reserved ?output_container)
        (container_assigned_bucket_a ?output_container ?bucket_key_a)
        (container_assigned_bucket_b ?output_container ?bucket_key_b)
        (container_flag_primary ?output_container)
        (container_flag_secondary ?output_container)
        (not
          (container_available ?output_container)
        )
      )
  )
  (:action activate_container
    :parameters (?output_container - container ?input_record_a - input_record_a ?attribute_slot - attribute_slot)
    :precondition
      (and
        (container_reserved ?output_container)
        (input_a_processed_flag ?input_record_a)
        (attribute_link ?input_record_a ?attribute_slot)
        (not
          (container_activated ?output_container)
        )
      )
    :effect (container_activated ?output_container)
  )
  (:action reserve_secondary_key
    :parameters (?merged_candidate - merged_candidate ?secondary_key - secondary_key ?output_container - container)
    :precondition
      (and
        (eligible_for_processing ?merged_candidate)
        (candidate_assigned_container ?merged_candidate ?output_container)
        (candidate_has_secondary_key ?merged_candidate ?secondary_key)
        (secondary_key_available ?secondary_key)
        (container_reserved ?output_container)
        (container_activated ?output_container)
        (not
          (secondary_key_reserved ?secondary_key)
        )
      )
    :effect
      (and
        (secondary_key_reserved ?secondary_key)
        (secondary_key_assigned_to_container ?secondary_key ?output_container)
        (not
          (secondary_key_available ?secondary_key)
        )
      )
  )
  (:action mark_candidate_ready_for_activation
    :parameters (?merged_candidate - merged_candidate ?secondary_key - secondary_key ?output_container - container ?attribute_slot - attribute_slot)
    :precondition
      (and
        (eligible_for_processing ?merged_candidate)
        (candidate_has_secondary_key ?merged_candidate ?secondary_key)
        (secondary_key_reserved ?secondary_key)
        (secondary_key_assigned_to_container ?secondary_key ?output_container)
        (attribute_link ?merged_candidate ?attribute_slot)
        (not
          (container_flag_primary ?output_container)
        )
        (not
          (preference_applied_flag ?merged_candidate)
        )
      )
    :effect (preference_applied_flag ?merged_candidate)
  )
  (:action attach_preference_token_a
    :parameters (?merged_candidate - merged_candidate ?preference_token_a - preference_token_a)
    :precondition
      (and
        (eligible_for_processing ?merged_candidate)
        (preference_token_a_available ?preference_token_a)
        (not
          (preference_attached_flag ?merged_candidate)
        )
      )
    :effect
      (and
        (preference_attached_flag ?merged_candidate)
        (candidate_has_preference_token_a ?merged_candidate ?preference_token_a)
        (not
          (preference_token_a_available ?preference_token_a)
        )
      )
  )
  (:action combine_preference_a_with_secondary_key
    :parameters (?merged_candidate - merged_candidate ?secondary_key - secondary_key ?output_container - container ?attribute_slot - attribute_slot ?preference_token_a - preference_token_a)
    :precondition
      (and
        (eligible_for_processing ?merged_candidate)
        (candidate_has_secondary_key ?merged_candidate ?secondary_key)
        (secondary_key_reserved ?secondary_key)
        (secondary_key_assigned_to_container ?secondary_key ?output_container)
        (attribute_link ?merged_candidate ?attribute_slot)
        (container_flag_primary ?output_container)
        (preference_attached_flag ?merged_candidate)
        (candidate_has_preference_token_a ?merged_candidate ?preference_token_a)
        (not
          (preference_applied_flag ?merged_candidate)
        )
      )
    :effect
      (and
        (preference_applied_flag ?merged_candidate)
        (preference_combined_flag ?merged_candidate)
      )
  )
  (:action apply_attribute_priority_candidate_without_container_flag
    :parameters (?merged_candidate - merged_candidate ?attribute_priority_token - attribute_priority_token ?matcher_worker - matcher_worker ?secondary_key - secondary_key ?output_container - container)
    :precondition
      (and
        (preference_applied_flag ?merged_candidate)
        (candidate_has_attribute_priority_token ?merged_candidate ?attribute_priority_token)
        (bound_to_matcher ?merged_candidate ?matcher_worker)
        (candidate_has_secondary_key ?merged_candidate ?secondary_key)
        (secondary_key_assigned_to_container ?secondary_key ?output_container)
        (not
          (container_flag_secondary ?output_container)
        )
        (not
          (feature_applied_flag ?merged_candidate)
        )
      )
    :effect (feature_applied_flag ?merged_candidate)
  )
  (:action apply_attribute_priority_candidate_with_container_flag
    :parameters (?merged_candidate - merged_candidate ?attribute_priority_token - attribute_priority_token ?matcher_worker - matcher_worker ?secondary_key - secondary_key ?output_container - container)
    :precondition
      (and
        (preference_applied_flag ?merged_candidate)
        (candidate_has_attribute_priority_token ?merged_candidate ?attribute_priority_token)
        (bound_to_matcher ?merged_candidate ?matcher_worker)
        (candidate_has_secondary_key ?merged_candidate ?secondary_key)
        (secondary_key_assigned_to_container ?secondary_key ?output_container)
        (container_flag_secondary ?output_container)
        (not
          (feature_applied_flag ?merged_candidate)
        )
      )
    :effect (feature_applied_flag ?merged_candidate)
  )
  (:action apply_tie_breaker
    :parameters (?merged_candidate - merged_candidate ?finalizer_token - finalizer_token ?secondary_key - secondary_key ?output_container - container)
    :precondition
      (and
        (feature_applied_flag ?merged_candidate)
        (candidate_has_finalizer_token ?merged_candidate ?finalizer_token)
        (candidate_has_secondary_key ?merged_candidate ?secondary_key)
        (secondary_key_assigned_to_container ?secondary_key ?output_container)
        (not
          (container_flag_primary ?output_container)
        )
        (not
          (container_flag_secondary ?output_container)
        )
        (not
          (tie_breaker_applied_flag ?merged_candidate)
        )
      )
    :effect (tie_breaker_applied_flag ?merged_candidate)
  )
  (:action apply_tie_breaker_and_set_combined_flag
    :parameters (?merged_candidate - merged_candidate ?finalizer_token - finalizer_token ?secondary_key - secondary_key ?output_container - container)
    :precondition
      (and
        (feature_applied_flag ?merged_candidate)
        (candidate_has_finalizer_token ?merged_candidate ?finalizer_token)
        (candidate_has_secondary_key ?merged_candidate ?secondary_key)
        (secondary_key_assigned_to_container ?secondary_key ?output_container)
        (container_flag_primary ?output_container)
        (not
          (container_flag_secondary ?output_container)
        )
        (not
          (tie_breaker_applied_flag ?merged_candidate)
        )
      )
    :effect
      (and
        (tie_breaker_applied_flag ?merged_candidate)
        (preference_feature_combined ?merged_candidate)
      )
  )
  (:action apply_tie_breaker_and_set_combined_flag_variant1
    :parameters (?merged_candidate - merged_candidate ?finalizer_token - finalizer_token ?secondary_key - secondary_key ?output_container - container)
    :precondition
      (and
        (feature_applied_flag ?merged_candidate)
        (candidate_has_finalizer_token ?merged_candidate ?finalizer_token)
        (candidate_has_secondary_key ?merged_candidate ?secondary_key)
        (secondary_key_assigned_to_container ?secondary_key ?output_container)
        (not
          (container_flag_primary ?output_container)
        )
        (container_flag_secondary ?output_container)
        (not
          (tie_breaker_applied_flag ?merged_candidate)
        )
      )
    :effect
      (and
        (tie_breaker_applied_flag ?merged_candidate)
        (preference_feature_combined ?merged_candidate)
      )
  )
  (:action apply_tie_breaker_and_set_combined_flag_variant2
    :parameters (?merged_candidate - merged_candidate ?finalizer_token - finalizer_token ?secondary_key - secondary_key ?output_container - container)
    :precondition
      (and
        (feature_applied_flag ?merged_candidate)
        (candidate_has_finalizer_token ?merged_candidate ?finalizer_token)
        (candidate_has_secondary_key ?merged_candidate ?secondary_key)
        (secondary_key_assigned_to_container ?secondary_key ?output_container)
        (container_flag_primary ?output_container)
        (container_flag_secondary ?output_container)
        (not
          (tie_breaker_applied_flag ?merged_candidate)
        )
      )
    :effect
      (and
        (tie_breaker_applied_flag ?merged_candidate)
        (preference_feature_combined ?merged_candidate)
      )
  )
  (:action select_canonical_candidate_initial
    :parameters (?merged_candidate - merged_candidate)
    :precondition
      (and
        (tie_breaker_applied_flag ?merged_candidate)
        (not
          (preference_feature_combined ?merged_candidate)
        )
        (not
          (candidate_finalized ?merged_candidate)
        )
      )
    :effect
      (and
        (candidate_finalized ?merged_candidate)
        (selected_marker ?merged_candidate)
      )
  )
  (:action attach_preference_token_b
    :parameters (?merged_candidate - merged_candidate ?preference_token_b - preference_token_b)
    :precondition
      (and
        (tie_breaker_applied_flag ?merged_candidate)
        (preference_feature_combined ?merged_candidate)
        (preference_token_b_available ?preference_token_b)
      )
    :effect
      (and
        (candidate_has_preference_token_b ?merged_candidate ?preference_token_b)
        (not
          (preference_token_b_available ?preference_token_b)
        )
      )
  )
  (:action mark_candidate_canonical
    :parameters (?merged_candidate - merged_candidate ?input_record_a - input_record_a ?input_record_b - input_record_b ?attribute_slot - attribute_slot ?preference_token_b - preference_token_b)
    :precondition
      (and
        (tie_breaker_applied_flag ?merged_candidate)
        (preference_feature_combined ?merged_candidate)
        (candidate_has_preference_token_b ?merged_candidate ?preference_token_b)
        (candidate_contains_input_a ?merged_candidate ?input_record_a)
        (candidate_contains_input_b ?merged_candidate ?input_record_b)
        (record_a_confirmed ?input_record_a)
        (record_b_confirmed ?input_record_b)
        (attribute_link ?merged_candidate ?attribute_slot)
        (not
          (canonical_candidate_flag ?merged_candidate)
        )
      )
    :effect (canonical_candidate_flag ?merged_candidate)
  )
  (:action finalize_canonical_candidate
    :parameters (?merged_candidate - merged_candidate)
    :precondition
      (and
        (tie_breaker_applied_flag ?merged_candidate)
        (canonical_candidate_flag ?merged_candidate)
        (not
          (candidate_finalized ?merged_candidate)
        )
      )
    :effect
      (and
        (candidate_finalized ?merged_candidate)
        (selected_marker ?merged_candidate)
      )
  )
  (:action claim_tie_breaker_for_candidate
    :parameters (?merged_candidate - merged_candidate ?tie_breaker_token - tie_breaker_token ?attribute_slot - attribute_slot)
    :precondition
      (and
        (eligible_for_processing ?merged_candidate)
        (attribute_link ?merged_candidate ?attribute_slot)
        (tie_breaker_available ?tie_breaker_token)
        (candidate_has_tie_breaker ?merged_candidate ?tie_breaker_token)
        (not
          (tie_breaker_claimed ?merged_candidate)
        )
      )
    :effect
      (and
        (tie_breaker_claimed ?merged_candidate)
        (not
          (tie_breaker_available ?tie_breaker_token)
        )
      )
  )
  (:action engage_tie_breaker_with_matcher
    :parameters (?merged_candidate - merged_candidate ?matcher_worker - matcher_worker)
    :precondition
      (and
        (tie_breaker_claimed ?merged_candidate)
        (bound_to_matcher ?merged_candidate ?matcher_worker)
        (not
          (tie_breaker_ready ?merged_candidate)
        )
      )
    :effect (tie_breaker_ready ?merged_candidate)
  )
  (:action finalize_tie_breaker_decision
    :parameters (?merged_candidate - merged_candidate ?finalizer_token - finalizer_token)
    :precondition
      (and
        (tie_breaker_ready ?merged_candidate)
        (candidate_has_finalizer_token ?merged_candidate ?finalizer_token)
        (not
          (tie_breaker_finalized_flag ?merged_candidate)
        )
      )
    :effect (tie_breaker_finalized_flag ?merged_candidate)
  )
  (:action finalize_candidate_selection
    :parameters (?merged_candidate - merged_candidate)
    :precondition
      (and
        (tie_breaker_finalized_flag ?merged_candidate)
        (not
          (candidate_finalized ?merged_candidate)
        )
      )
    :effect
      (and
        (candidate_finalized ?merged_candidate)
        (selected_marker ?merged_candidate)
      )
  )
  (:action materialize_record_a
    :parameters (?input_record_a - input_record_a ?output_container - container)
    :precondition
      (and
        (input_a_processed_flag ?input_record_a)
        (record_a_confirmed ?input_record_a)
        (container_reserved ?output_container)
        (container_activated ?output_container)
        (not
          (selected_marker ?input_record_a)
        )
      )
    :effect (selected_marker ?input_record_a)
  )
  (:action materialize_record_b
    :parameters (?input_record_b - input_record_b ?output_container - container)
    :precondition
      (and
        (input_b_processed_flag ?input_record_b)
        (record_b_confirmed ?input_record_b)
        (container_reserved ?output_container)
        (container_activated ?output_container)
        (not
          (selected_marker ?input_record_b)
        )
      )
    :effect (selected_marker ?input_record_b)
  )
  (:action attach_priority_marker_to_selected_record
    :parameters (?record - record ?priority_marker - priority_marker ?attribute_slot - attribute_slot)
    :precondition
      (and
        (selected_marker ?record)
        (attribute_link ?record ?attribute_slot)
        (priority_marker_available ?priority_marker)
        (not
          (finalization_ready ?record)
        )
      )
    :effect
      (and
        (finalization_ready ?record)
        (record_bound_priority_marker ?record ?priority_marker)
        (not
          (priority_marker_available ?priority_marker)
        )
      )
  )
  (:action materialize_record_a_and_release_resources
    :parameters (?input_record_a - input_record_a ?priority_slot - priority_slot ?priority_marker - priority_marker)
    :precondition
      (and
        (finalization_ready ?input_record_a)
        (bound_to_priority_slot ?input_record_a ?priority_slot)
        (record_bound_priority_marker ?input_record_a ?priority_marker)
        (not
          (output_mark ?input_record_a)
        )
      )
    :effect
      (and
        (output_mark ?input_record_a)
        (priority_slot_available ?priority_slot)
        (priority_marker_available ?priority_marker)
      )
  )
  (:action materialize_record_b_and_release_resources
    :parameters (?input_record_b - input_record_b ?priority_slot - priority_slot ?priority_marker - priority_marker)
    :precondition
      (and
        (finalization_ready ?input_record_b)
        (bound_to_priority_slot ?input_record_b ?priority_slot)
        (record_bound_priority_marker ?input_record_b ?priority_marker)
        (not
          (output_mark ?input_record_b)
        )
      )
    :effect
      (and
        (output_mark ?input_record_b)
        (priority_slot_available ?priority_slot)
        (priority_marker_available ?priority_marker)
      )
  )
  (:action materialize_candidate_and_release_resources
    :parameters (?merged_candidate - merged_candidate ?priority_slot - priority_slot ?priority_marker - priority_marker)
    :precondition
      (and
        (finalization_ready ?merged_candidate)
        (bound_to_priority_slot ?merged_candidate ?priority_slot)
        (record_bound_priority_marker ?merged_candidate ?priority_marker)
        (not
          (output_mark ?merged_candidate)
        )
      )
    :effect
      (and
        (output_mark ?merged_candidate)
        (priority_slot_available ?priority_slot)
        (priority_marker_available ?priority_marker)
      )
  )
)

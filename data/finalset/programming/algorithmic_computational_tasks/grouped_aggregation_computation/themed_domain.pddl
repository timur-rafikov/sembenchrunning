(define (domain grouped_aggregation)
  (:requirements :strips :typing :negative-preconditions)
  (:types compute_resource_category - object value_data_category - object key_component_category - object group_identifier - object aggregate_group - group_identifier compute_slot - compute_resource_category input_record - compute_resource_category worker_token - compute_resource_category config_flag_a - compute_resource_category merge_strategy - compute_resource_category finalizer_token - compute_resource_category aggregator_option_a - compute_resource_category aggregator_option_b - compute_resource_category value_token - value_data_category partition_key_component - value_data_category aggregator_option_c - value_data_category grouping_key_a - key_component_category grouping_key_b - key_component_category result_candidate - key_component_category partition_supertype - aggregate_group aggregator_supertype - aggregate_group partition_instance_a - partition_supertype partition_instance_b - partition_supertype aggregation_job - aggregator_supertype)
  (:predicates
    (aggregate_group_created ?aggregate_group - aggregate_group)
    (aggregate_group_active ?aggregate_group - aggregate_group)
    (aggregate_group_assigned ?aggregate_group - aggregate_group)
    (aggregate_group_finalized ?aggregate_group - aggregate_group)
    (aggregate_group_output_ready ?aggregate_group - aggregate_group)
    (aggregate_group_has_finalizer ?aggregate_group - aggregate_group)
    (compute_slot_available ?compute_slot - compute_slot)
    (aggregate_group_assigned_to_compute_slot ?aggregate_group - aggregate_group ?compute_slot - compute_slot)
    (input_record_unconsumed ?input_record - input_record)
    (record_assigned_to_aggregate_group ?aggregate_group - aggregate_group ?input_record - input_record)
    (worker_available ?worker_token - worker_token)
    (worker_assigned_to_aggregate_group ?aggregate_group - aggregate_group ?worker_token - worker_token)
    (value_token_available ?value_token - value_token)
    (partition_a_has_value_token ?partition_instance_a - partition_instance_a ?value_token - value_token)
    (partition_b_has_value_token ?partition_instance_b - partition_instance_b ?value_token - value_token)
    (partition_a_has_key_a ?partition_instance_a - partition_instance_a ?grouping_key_a - grouping_key_a)
    (key_a_marked ?grouping_key_a - grouping_key_a)
    (key_a_has_value ?grouping_key_a - grouping_key_a)
    (partition_instance_a_processed ?partition_instance_a - partition_instance_a)
    (partition_b_has_key_b ?partition_instance_b - partition_instance_b ?grouping_key_b - grouping_key_b)
    (key_b_marked ?grouping_key_b - grouping_key_b)
    (key_b_has_value ?grouping_key_b - grouping_key_b)
    (partition_instance_b_processed ?partition_instance_b - partition_instance_b)
    (result_candidate_available ?result_candidate - result_candidate)
    (result_candidate_composed ?result_candidate - result_candidate)
    (candidate_has_key_a ?result_candidate - result_candidate ?grouping_key_a - grouping_key_a)
    (candidate_has_key_b ?result_candidate - result_candidate ?grouping_key_b - grouping_key_b)
    (candidate_includes_key_a_flag ?result_candidate - result_candidate)
    (candidate_includes_key_b_flag ?result_candidate - result_candidate)
    (candidate_marked_ready ?result_candidate - result_candidate)
    (aggregation_job_bound_to_partition_a ?aggregation_job - aggregation_job ?partition_instance_a - partition_instance_a)
    (aggregation_job_bound_to_partition_b ?aggregation_job - aggregation_job ?partition_instance_b - partition_instance_b)
    (aggregation_job_bound_to_candidate ?aggregation_job - aggregation_job ?result_candidate - result_candidate)
    (partition_key_component_available ?partition_key_component - partition_key_component)
    (aggregation_job_has_partition_key_component ?aggregation_job - aggregation_job ?partition_key_component - partition_key_component)
    (partition_key_component_consumed ?partition_key_component - partition_key_component)
    (partition_key_component_assigned_to_candidate ?partition_key_component - partition_key_component ?result_candidate - result_candidate)
    (aggregation_job_phase1_configured ?aggregation_job - aggregation_job)
    (aggregation_job_phase2_configured ?aggregation_job - aggregation_job)
    (aggregation_job_phase3_configured ?aggregation_job - aggregation_job)
    (aggregation_job_config_flag_attached ?aggregation_job - aggregation_job)
    (aggregation_job_stage2_enabled ?aggregation_job - aggregation_job)
    (aggregation_job_additional_configured ?aggregation_job - aggregation_job)
    (aggregation_job_local_aggregation_ready ?aggregation_job - aggregation_job)
    (aggregator_option_c_available ?aggregator_option_c - aggregator_option_c)
    (aggregation_job_has_aggregator_option_c ?aggregation_job - aggregation_job ?aggregator_option_c - aggregator_option_c)
    (aggregation_job_processing_initiated ?aggregation_job - aggregation_job)
    (aggregation_job_processing_stage2_initiated ?aggregation_job - aggregation_job)
    (aggregation_job_ready_to_emit ?aggregation_job - aggregation_job)
    (config_flag_a_available ?config_flag_a - config_flag_a)
    (aggregation_job_has_config_flag_a ?aggregation_job - aggregation_job ?config_flag_a - config_flag_a)
    (merge_strategy_available ?merge_strategy - merge_strategy)
    (aggregation_job_has_merge_strategy ?aggregation_job - aggregation_job ?merge_strategy - merge_strategy)
    (aggregator_option_a_available ?aggregator_option_a - aggregator_option_a)
    (aggregation_job_has_aggregator_option_a ?aggregation_job - aggregation_job ?aggregator_option_a - aggregator_option_a)
    (aggregator_option_b_available ?aggregator_option_b - aggregator_option_b)
    (aggregation_job_has_aggregator_option_b ?aggregation_job - aggregation_job ?aggregator_option_b - aggregator_option_b)
    (finalizer_token_available ?finalizer_token - finalizer_token)
    (aggregate_group_bound_to_finalizer_token ?aggregate_group - aggregate_group ?finalizer_token - finalizer_token)
    (partition_instance_a_processing_claimed ?partition_instance_a - partition_instance_a)
    (partition_instance_b_processing_claimed ?partition_instance_b - partition_instance_b)
    (aggregation_job_finalized ?aggregation_job - aggregation_job)
  )
  (:action initialize_aggregate_group
    :parameters (?aggregate_group - aggregate_group)
    :precondition
      (and
        (not
          (aggregate_group_created ?aggregate_group)
        )
        (not
          (aggregate_group_finalized ?aggregate_group)
        )
      )
    :effect (aggregate_group_created ?aggregate_group)
  )
  (:action assign_compute_slot_to_aggregate_group
    :parameters (?aggregate_group - aggregate_group ?compute_slot - compute_slot)
    :precondition
      (and
        (aggregate_group_created ?aggregate_group)
        (not
          (aggregate_group_assigned ?aggregate_group)
        )
        (compute_slot_available ?compute_slot)
      )
    :effect
      (and
        (aggregate_group_assigned ?aggregate_group)
        (aggregate_group_assigned_to_compute_slot ?aggregate_group ?compute_slot)
        (not
          (compute_slot_available ?compute_slot)
        )
      )
  )
  (:action ingest_record_into_aggregate_group
    :parameters (?aggregate_group - aggregate_group ?input_record - input_record)
    :precondition
      (and
        (aggregate_group_created ?aggregate_group)
        (aggregate_group_assigned ?aggregate_group)
        (input_record_unconsumed ?input_record)
      )
    :effect
      (and
        (record_assigned_to_aggregate_group ?aggregate_group ?input_record)
        (not
          (input_record_unconsumed ?input_record)
        )
      )
  )
  (:action activate_aggregate_group
    :parameters (?aggregate_group - aggregate_group ?input_record - input_record)
    :precondition
      (and
        (aggregate_group_created ?aggregate_group)
        (aggregate_group_assigned ?aggregate_group)
        (record_assigned_to_aggregate_group ?aggregate_group ?input_record)
        (not
          (aggregate_group_active ?aggregate_group)
        )
      )
    :effect (aggregate_group_active ?aggregate_group)
  )
  (:action release_record_from_aggregate_group
    :parameters (?aggregate_group - aggregate_group ?input_record - input_record)
    :precondition
      (and
        (record_assigned_to_aggregate_group ?aggregate_group ?input_record)
      )
    :effect
      (and
        (input_record_unconsumed ?input_record)
        (not
          (record_assigned_to_aggregate_group ?aggregate_group ?input_record)
        )
      )
  )
  (:action assign_worker_to_aggregate_group
    :parameters (?aggregate_group - aggregate_group ?worker_token - worker_token)
    :precondition
      (and
        (aggregate_group_active ?aggregate_group)
        (worker_available ?worker_token)
      )
    :effect
      (and
        (worker_assigned_to_aggregate_group ?aggregate_group ?worker_token)
        (not
          (worker_available ?worker_token)
        )
      )
  )
  (:action unassign_worker_from_aggregate_group
    :parameters (?aggregate_group - aggregate_group ?worker_token - worker_token)
    :precondition
      (and
        (worker_assigned_to_aggregate_group ?aggregate_group ?worker_token)
      )
    :effect
      (and
        (worker_available ?worker_token)
        (not
          (worker_assigned_to_aggregate_group ?aggregate_group ?worker_token)
        )
      )
  )
  (:action attach_aggregator_option_a_to_aggregation_job
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_a - aggregator_option_a)
    :precondition
      (and
        (aggregate_group_active ?aggregation_job)
        (aggregator_option_a_available ?aggregator_option_a)
      )
    :effect
      (and
        (aggregation_job_has_aggregator_option_a ?aggregation_job ?aggregator_option_a)
        (not
          (aggregator_option_a_available ?aggregator_option_a)
        )
      )
  )
  (:action detach_aggregator_option_a_from_aggregation_job
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_a - aggregator_option_a)
    :precondition
      (and
        (aggregation_job_has_aggregator_option_a ?aggregation_job ?aggregator_option_a)
      )
    :effect
      (and
        (aggregator_option_a_available ?aggregator_option_a)
        (not
          (aggregation_job_has_aggregator_option_a ?aggregation_job ?aggregator_option_a)
        )
      )
  )
  (:action attach_aggregator_option_b_to_aggregation_job
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_b - aggregator_option_b)
    :precondition
      (and
        (aggregate_group_active ?aggregation_job)
        (aggregator_option_b_available ?aggregator_option_b)
      )
    :effect
      (and
        (aggregation_job_has_aggregator_option_b ?aggregation_job ?aggregator_option_b)
        (not
          (aggregator_option_b_available ?aggregator_option_b)
        )
      )
  )
  (:action detach_aggregator_option_b_from_aggregation_job
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_b - aggregator_option_b)
    :precondition
      (and
        (aggregation_job_has_aggregator_option_b ?aggregation_job ?aggregator_option_b)
      )
    :effect
      (and
        (aggregator_option_b_available ?aggregator_option_b)
        (not
          (aggregation_job_has_aggregator_option_b ?aggregation_job ?aggregator_option_b)
        )
      )
  )
  (:action mark_partition_a_key
    :parameters (?partition_instance_a - partition_instance_a ?grouping_key_a - grouping_key_a ?input_record - input_record)
    :precondition
      (and
        (aggregate_group_active ?partition_instance_a)
        (record_assigned_to_aggregate_group ?partition_instance_a ?input_record)
        (partition_a_has_key_a ?partition_instance_a ?grouping_key_a)
        (not
          (key_a_marked ?grouping_key_a)
        )
        (not
          (key_a_has_value ?grouping_key_a)
        )
      )
    :effect (key_a_marked ?grouping_key_a)
  )
  (:action signal_partition_a_ready_with_worker
    :parameters (?partition_instance_a - partition_instance_a ?grouping_key_a - grouping_key_a ?worker_token - worker_token)
    :precondition
      (and
        (aggregate_group_active ?partition_instance_a)
        (worker_assigned_to_aggregate_group ?partition_instance_a ?worker_token)
        (partition_a_has_key_a ?partition_instance_a ?grouping_key_a)
        (key_a_marked ?grouping_key_a)
        (not
          (partition_instance_a_processing_claimed ?partition_instance_a)
        )
      )
    :effect
      (and
        (partition_instance_a_processing_claimed ?partition_instance_a)
        (partition_instance_a_processed ?partition_instance_a)
      )
  )
  (:action accumulate_value_in_partition_a
    :parameters (?partition_instance_a - partition_instance_a ?grouping_key_a - grouping_key_a ?value_token - value_token)
    :precondition
      (and
        (aggregate_group_active ?partition_instance_a)
        (partition_a_has_key_a ?partition_instance_a ?grouping_key_a)
        (value_token_available ?value_token)
        (not
          (partition_instance_a_processing_claimed ?partition_instance_a)
        )
      )
    :effect
      (and
        (key_a_has_value ?grouping_key_a)
        (partition_instance_a_processing_claimed ?partition_instance_a)
        (partition_a_has_value_token ?partition_instance_a ?value_token)
        (not
          (value_token_available ?value_token)
        )
      )
  )
  (:action process_value_for_partition_a
    :parameters (?partition_instance_a - partition_instance_a ?grouping_key_a - grouping_key_a ?input_record - input_record ?value_token - value_token)
    :precondition
      (and
        (aggregate_group_active ?partition_instance_a)
        (record_assigned_to_aggregate_group ?partition_instance_a ?input_record)
        (partition_a_has_key_a ?partition_instance_a ?grouping_key_a)
        (key_a_has_value ?grouping_key_a)
        (partition_a_has_value_token ?partition_instance_a ?value_token)
        (not
          (partition_instance_a_processed ?partition_instance_a)
        )
      )
    :effect
      (and
        (key_a_marked ?grouping_key_a)
        (partition_instance_a_processed ?partition_instance_a)
        (value_token_available ?value_token)
        (not
          (partition_a_has_value_token ?partition_instance_a ?value_token)
        )
      )
  )
  (:action mark_partition_b_key
    :parameters (?partition_instance_b - partition_instance_b ?grouping_key_b - grouping_key_b ?input_record - input_record)
    :precondition
      (and
        (aggregate_group_active ?partition_instance_b)
        (record_assigned_to_aggregate_group ?partition_instance_b ?input_record)
        (partition_b_has_key_b ?partition_instance_b ?grouping_key_b)
        (not
          (key_b_marked ?grouping_key_b)
        )
        (not
          (key_b_has_value ?grouping_key_b)
        )
      )
    :effect (key_b_marked ?grouping_key_b)
  )
  (:action signal_partition_b_ready_with_worker
    :parameters (?partition_instance_b - partition_instance_b ?grouping_key_b - grouping_key_b ?worker_token - worker_token)
    :precondition
      (and
        (aggregate_group_active ?partition_instance_b)
        (worker_assigned_to_aggregate_group ?partition_instance_b ?worker_token)
        (partition_b_has_key_b ?partition_instance_b ?grouping_key_b)
        (key_b_marked ?grouping_key_b)
        (not
          (partition_instance_b_processing_claimed ?partition_instance_b)
        )
      )
    :effect
      (and
        (partition_instance_b_processing_claimed ?partition_instance_b)
        (partition_instance_b_processed ?partition_instance_b)
      )
  )
  (:action accumulate_value_in_partition_b
    :parameters (?partition_instance_b - partition_instance_b ?grouping_key_b - grouping_key_b ?value_token - value_token)
    :precondition
      (and
        (aggregate_group_active ?partition_instance_b)
        (partition_b_has_key_b ?partition_instance_b ?grouping_key_b)
        (value_token_available ?value_token)
        (not
          (partition_instance_b_processing_claimed ?partition_instance_b)
        )
      )
    :effect
      (and
        (key_b_has_value ?grouping_key_b)
        (partition_instance_b_processing_claimed ?partition_instance_b)
        (partition_b_has_value_token ?partition_instance_b ?value_token)
        (not
          (value_token_available ?value_token)
        )
      )
  )
  (:action process_value_for_partition_b
    :parameters (?partition_instance_b - partition_instance_b ?grouping_key_b - grouping_key_b ?input_record - input_record ?value_token - value_token)
    :precondition
      (and
        (aggregate_group_active ?partition_instance_b)
        (record_assigned_to_aggregate_group ?partition_instance_b ?input_record)
        (partition_b_has_key_b ?partition_instance_b ?grouping_key_b)
        (key_b_has_value ?grouping_key_b)
        (partition_b_has_value_token ?partition_instance_b ?value_token)
        (not
          (partition_instance_b_processed ?partition_instance_b)
        )
      )
    :effect
      (and
        (key_b_marked ?grouping_key_b)
        (partition_instance_b_processed ?partition_instance_b)
        (value_token_available ?value_token)
        (not
          (partition_b_has_value_token ?partition_instance_b ?value_token)
        )
      )
  )
  (:action compose_result_candidate
    :parameters (?partition_instance_a - partition_instance_a ?partition_instance_b - partition_instance_b ?grouping_key_a - grouping_key_a ?grouping_key_b - grouping_key_b ?result_candidate - result_candidate)
    :precondition
      (and
        (partition_instance_a_processing_claimed ?partition_instance_a)
        (partition_instance_b_processing_claimed ?partition_instance_b)
        (partition_a_has_key_a ?partition_instance_a ?grouping_key_a)
        (partition_b_has_key_b ?partition_instance_b ?grouping_key_b)
        (key_a_marked ?grouping_key_a)
        (key_b_marked ?grouping_key_b)
        (partition_instance_a_processed ?partition_instance_a)
        (partition_instance_b_processed ?partition_instance_b)
        (result_candidate_available ?result_candidate)
      )
    :effect
      (and
        (result_candidate_composed ?result_candidate)
        (candidate_has_key_a ?result_candidate ?grouping_key_a)
        (candidate_has_key_b ?result_candidate ?grouping_key_b)
        (not
          (result_candidate_available ?result_candidate)
        )
      )
  )
  (:action compose_result_candidate_with_key_a_flag
    :parameters (?partition_instance_a - partition_instance_a ?partition_instance_b - partition_instance_b ?grouping_key_a - grouping_key_a ?grouping_key_b - grouping_key_b ?result_candidate - result_candidate)
    :precondition
      (and
        (partition_instance_a_processing_claimed ?partition_instance_a)
        (partition_instance_b_processing_claimed ?partition_instance_b)
        (partition_a_has_key_a ?partition_instance_a ?grouping_key_a)
        (partition_b_has_key_b ?partition_instance_b ?grouping_key_b)
        (key_a_has_value ?grouping_key_a)
        (key_b_marked ?grouping_key_b)
        (not
          (partition_instance_a_processed ?partition_instance_a)
        )
        (partition_instance_b_processed ?partition_instance_b)
        (result_candidate_available ?result_candidate)
      )
    :effect
      (and
        (result_candidate_composed ?result_candidate)
        (candidate_has_key_a ?result_candidate ?grouping_key_a)
        (candidate_has_key_b ?result_candidate ?grouping_key_b)
        (candidate_includes_key_a_flag ?result_candidate)
        (not
          (result_candidate_available ?result_candidate)
        )
      )
  )
  (:action compose_result_candidate_with_key_b_flag
    :parameters (?partition_instance_a - partition_instance_a ?partition_instance_b - partition_instance_b ?grouping_key_a - grouping_key_a ?grouping_key_b - grouping_key_b ?result_candidate - result_candidate)
    :precondition
      (and
        (partition_instance_a_processing_claimed ?partition_instance_a)
        (partition_instance_b_processing_claimed ?partition_instance_b)
        (partition_a_has_key_a ?partition_instance_a ?grouping_key_a)
        (partition_b_has_key_b ?partition_instance_b ?grouping_key_b)
        (key_a_marked ?grouping_key_a)
        (key_b_has_value ?grouping_key_b)
        (partition_instance_a_processed ?partition_instance_a)
        (not
          (partition_instance_b_processed ?partition_instance_b)
        )
        (result_candidate_available ?result_candidate)
      )
    :effect
      (and
        (result_candidate_composed ?result_candidate)
        (candidate_has_key_a ?result_candidate ?grouping_key_a)
        (candidate_has_key_b ?result_candidate ?grouping_key_b)
        (candidate_includes_key_b_flag ?result_candidate)
        (not
          (result_candidate_available ?result_candidate)
        )
      )
  )
  (:action compose_result_candidate_with_both_flags
    :parameters (?partition_instance_a - partition_instance_a ?partition_instance_b - partition_instance_b ?grouping_key_a - grouping_key_a ?grouping_key_b - grouping_key_b ?result_candidate - result_candidate)
    :precondition
      (and
        (partition_instance_a_processing_claimed ?partition_instance_a)
        (partition_instance_b_processing_claimed ?partition_instance_b)
        (partition_a_has_key_a ?partition_instance_a ?grouping_key_a)
        (partition_b_has_key_b ?partition_instance_b ?grouping_key_b)
        (key_a_has_value ?grouping_key_a)
        (key_b_has_value ?grouping_key_b)
        (not
          (partition_instance_a_processed ?partition_instance_a)
        )
        (not
          (partition_instance_b_processed ?partition_instance_b)
        )
        (result_candidate_available ?result_candidate)
      )
    :effect
      (and
        (result_candidate_composed ?result_candidate)
        (candidate_has_key_a ?result_candidate ?grouping_key_a)
        (candidate_has_key_b ?result_candidate ?grouping_key_b)
        (candidate_includes_key_a_flag ?result_candidate)
        (candidate_includes_key_b_flag ?result_candidate)
        (not
          (result_candidate_available ?result_candidate)
        )
      )
  )
  (:action mark_candidate_ready
    :parameters (?result_candidate - result_candidate ?partition_instance_a - partition_instance_a ?input_record - input_record)
    :precondition
      (and
        (result_candidate_composed ?result_candidate)
        (partition_instance_a_processing_claimed ?partition_instance_a)
        (record_assigned_to_aggregate_group ?partition_instance_a ?input_record)
        (not
          (candidate_marked_ready ?result_candidate)
        )
      )
    :effect (candidate_marked_ready ?result_candidate)
  )
  (:action reserve_partition_key_component_for_aggregation_job
    :parameters (?aggregation_job - aggregation_job ?partition_key_component - partition_key_component ?result_candidate - result_candidate)
    :precondition
      (and
        (aggregate_group_active ?aggregation_job)
        (aggregation_job_bound_to_candidate ?aggregation_job ?result_candidate)
        (aggregation_job_has_partition_key_component ?aggregation_job ?partition_key_component)
        (partition_key_component_available ?partition_key_component)
        (result_candidate_composed ?result_candidate)
        (candidate_marked_ready ?result_candidate)
        (not
          (partition_key_component_consumed ?partition_key_component)
        )
      )
    :effect
      (and
        (partition_key_component_consumed ?partition_key_component)
        (partition_key_component_assigned_to_candidate ?partition_key_component ?result_candidate)
        (not
          (partition_key_component_available ?partition_key_component)
        )
      )
  )
  (:action configure_aggregation_job_phase1
    :parameters (?aggregation_job - aggregation_job ?partition_key_component - partition_key_component ?result_candidate - result_candidate ?input_record - input_record)
    :precondition
      (and
        (aggregate_group_active ?aggregation_job)
        (aggregation_job_has_partition_key_component ?aggregation_job ?partition_key_component)
        (partition_key_component_consumed ?partition_key_component)
        (partition_key_component_assigned_to_candidate ?partition_key_component ?result_candidate)
        (record_assigned_to_aggregate_group ?aggregation_job ?input_record)
        (not
          (candidate_includes_key_a_flag ?result_candidate)
        )
        (not
          (aggregation_job_phase1_configured ?aggregation_job)
        )
      )
    :effect (aggregation_job_phase1_configured ?aggregation_job)
  )
  (:action attach_config_flag_to_aggregation_job
    :parameters (?aggregation_job - aggregation_job ?config_flag_a - config_flag_a)
    :precondition
      (and
        (aggregate_group_active ?aggregation_job)
        (config_flag_a_available ?config_flag_a)
        (not
          (aggregation_job_config_flag_attached ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregation_job_config_flag_attached ?aggregation_job)
        (aggregation_job_has_config_flag_a ?aggregation_job ?config_flag_a)
        (not
          (config_flag_a_available ?config_flag_a)
        )
      )
  )
  (:action attach_config_flag_and_enable_aggregation_job_stage2
    :parameters (?aggregation_job - aggregation_job ?partition_key_component - partition_key_component ?result_candidate - result_candidate ?input_record - input_record ?config_flag_a - config_flag_a)
    :precondition
      (and
        (aggregate_group_active ?aggregation_job)
        (aggregation_job_has_partition_key_component ?aggregation_job ?partition_key_component)
        (partition_key_component_consumed ?partition_key_component)
        (partition_key_component_assigned_to_candidate ?partition_key_component ?result_candidate)
        (record_assigned_to_aggregate_group ?aggregation_job ?input_record)
        (candidate_includes_key_a_flag ?result_candidate)
        (aggregation_job_config_flag_attached ?aggregation_job)
        (aggregation_job_has_config_flag_a ?aggregation_job ?config_flag_a)
        (not
          (aggregation_job_phase1_configured ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregation_job_phase1_configured ?aggregation_job)
        (aggregation_job_stage2_enabled ?aggregation_job)
      )
  )
  (:action apply_aggregator_option_a_to_aggregation_job_phase2
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_a - aggregator_option_a ?worker_token - worker_token ?partition_key_component - partition_key_component ?result_candidate - result_candidate)
    :precondition
      (and
        (aggregation_job_phase1_configured ?aggregation_job)
        (aggregation_job_has_aggregator_option_a ?aggregation_job ?aggregator_option_a)
        (worker_assigned_to_aggregate_group ?aggregation_job ?worker_token)
        (aggregation_job_has_partition_key_component ?aggregation_job ?partition_key_component)
        (partition_key_component_assigned_to_candidate ?partition_key_component ?result_candidate)
        (not
          (candidate_includes_key_b_flag ?result_candidate)
        )
        (not
          (aggregation_job_phase2_configured ?aggregation_job)
        )
      )
    :effect (aggregation_job_phase2_configured ?aggregation_job)
  )
  (:action apply_aggregator_option_a_to_aggregation_job_phase2_variant
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_a - aggregator_option_a ?worker_token - worker_token ?partition_key_component - partition_key_component ?result_candidate - result_candidate)
    :precondition
      (and
        (aggregation_job_phase1_configured ?aggregation_job)
        (aggregation_job_has_aggregator_option_a ?aggregation_job ?aggregator_option_a)
        (worker_assigned_to_aggregate_group ?aggregation_job ?worker_token)
        (aggregation_job_has_partition_key_component ?aggregation_job ?partition_key_component)
        (partition_key_component_assigned_to_candidate ?partition_key_component ?result_candidate)
        (candidate_includes_key_b_flag ?result_candidate)
        (not
          (aggregation_job_phase2_configured ?aggregation_job)
        )
      )
    :effect (aggregation_job_phase2_configured ?aggregation_job)
  )
  (:action apply_aggregator_option_b_to_aggregation_job_stage3
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_b - aggregator_option_b ?partition_key_component - partition_key_component ?result_candidate - result_candidate)
    :precondition
      (and
        (aggregation_job_phase2_configured ?aggregation_job)
        (aggregation_job_has_aggregator_option_b ?aggregation_job ?aggregator_option_b)
        (aggregation_job_has_partition_key_component ?aggregation_job ?partition_key_component)
        (partition_key_component_assigned_to_candidate ?partition_key_component ?result_candidate)
        (not
          (candidate_includes_key_a_flag ?result_candidate)
        )
        (not
          (candidate_includes_key_b_flag ?result_candidate)
        )
        (not
          (aggregation_job_phase3_configured ?aggregation_job)
        )
      )
    :effect (aggregation_job_phase3_configured ?aggregation_job)
  )
  (:action apply_aggregator_option_b_to_aggregation_job_stage3_with_additional_flag
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_b - aggregator_option_b ?partition_key_component - partition_key_component ?result_candidate - result_candidate)
    :precondition
      (and
        (aggregation_job_phase2_configured ?aggregation_job)
        (aggregation_job_has_aggregator_option_b ?aggregation_job ?aggregator_option_b)
        (aggregation_job_has_partition_key_component ?aggregation_job ?partition_key_component)
        (partition_key_component_assigned_to_candidate ?partition_key_component ?result_candidate)
        (candidate_includes_key_a_flag ?result_candidate)
        (not
          (candidate_includes_key_b_flag ?result_candidate)
        )
        (not
          (aggregation_job_phase3_configured ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregation_job_phase3_configured ?aggregation_job)
        (aggregation_job_additional_configured ?aggregation_job)
      )
  )
  (:action apply_aggregator_option_b_to_aggregation_job_stage3_variant
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_b - aggregator_option_b ?partition_key_component - partition_key_component ?result_candidate - result_candidate)
    :precondition
      (and
        (aggregation_job_phase2_configured ?aggregation_job)
        (aggregation_job_has_aggregator_option_b ?aggregation_job ?aggregator_option_b)
        (aggregation_job_has_partition_key_component ?aggregation_job ?partition_key_component)
        (partition_key_component_assigned_to_candidate ?partition_key_component ?result_candidate)
        (not
          (candidate_includes_key_a_flag ?result_candidate)
        )
        (candidate_includes_key_b_flag ?result_candidate)
        (not
          (aggregation_job_phase3_configured ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregation_job_phase3_configured ?aggregation_job)
        (aggregation_job_additional_configured ?aggregation_job)
      )
  )
  (:action apply_aggregator_option_b_to_aggregation_job_stage3_combined
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_b - aggregator_option_b ?partition_key_component - partition_key_component ?result_candidate - result_candidate)
    :precondition
      (and
        (aggregation_job_phase2_configured ?aggregation_job)
        (aggregation_job_has_aggregator_option_b ?aggregation_job ?aggregator_option_b)
        (aggregation_job_has_partition_key_component ?aggregation_job ?partition_key_component)
        (partition_key_component_assigned_to_candidate ?partition_key_component ?result_candidate)
        (candidate_includes_key_a_flag ?result_candidate)
        (candidate_includes_key_b_flag ?result_candidate)
        (not
          (aggregation_job_phase3_configured ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregation_job_phase3_configured ?aggregation_job)
        (aggregation_job_additional_configured ?aggregation_job)
      )
  )
  (:action mark_aggregation_job_ready_to_emit
    :parameters (?aggregation_job - aggregation_job)
    :precondition
      (and
        (aggregation_job_phase3_configured ?aggregation_job)
        (not
          (aggregation_job_additional_configured ?aggregation_job)
        )
        (not
          (aggregation_job_finalized ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregation_job_finalized ?aggregation_job)
        (aggregate_group_output_ready ?aggregation_job)
      )
  )
  (:action attach_merge_strategy_to_aggregation_job
    :parameters (?aggregation_job - aggregation_job ?merge_strategy - merge_strategy)
    :precondition
      (and
        (aggregation_job_phase3_configured ?aggregation_job)
        (aggregation_job_additional_configured ?aggregation_job)
        (merge_strategy_available ?merge_strategy)
      )
    :effect
      (and
        (aggregation_job_has_merge_strategy ?aggregation_job ?merge_strategy)
        (not
          (merge_strategy_available ?merge_strategy)
        )
      )
  )
  (:action perform_local_aggregation_check_on_aggregation_job
    :parameters (?aggregation_job - aggregation_job ?partition_instance_a - partition_instance_a ?partition_instance_b - partition_instance_b ?input_record - input_record ?merge_strategy - merge_strategy)
    :precondition
      (and
        (aggregation_job_phase3_configured ?aggregation_job)
        (aggregation_job_additional_configured ?aggregation_job)
        (aggregation_job_has_merge_strategy ?aggregation_job ?merge_strategy)
        (aggregation_job_bound_to_partition_a ?aggregation_job ?partition_instance_a)
        (aggregation_job_bound_to_partition_b ?aggregation_job ?partition_instance_b)
        (partition_instance_a_processed ?partition_instance_a)
        (partition_instance_b_processed ?partition_instance_b)
        (record_assigned_to_aggregate_group ?aggregation_job ?input_record)
        (not
          (aggregation_job_local_aggregation_ready ?aggregation_job)
        )
      )
    :effect (aggregation_job_local_aggregation_ready ?aggregation_job)
  )
  (:action finalize_aggregation_job_local_readiness
    :parameters (?aggregation_job - aggregation_job)
    :precondition
      (and
        (aggregation_job_phase3_configured ?aggregation_job)
        (aggregation_job_local_aggregation_ready ?aggregation_job)
        (not
          (aggregation_job_finalized ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregation_job_finalized ?aggregation_job)
        (aggregate_group_output_ready ?aggregation_job)
      )
  )
  (:action consume_aggregator_option_c_and_lock_aggregation_job
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_c - aggregator_option_c ?input_record - input_record)
    :precondition
      (and
        (aggregate_group_active ?aggregation_job)
        (record_assigned_to_aggregate_group ?aggregation_job ?input_record)
        (aggregator_option_c_available ?aggregator_option_c)
        (aggregation_job_has_aggregator_option_c ?aggregation_job ?aggregator_option_c)
        (not
          (aggregation_job_processing_initiated ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregation_job_processing_initiated ?aggregation_job)
        (not
          (aggregator_option_c_available ?aggregator_option_c)
        )
      )
  )
  (:action initiate_aggregation_job_processing_stage2
    :parameters (?aggregation_job - aggregation_job ?worker_token - worker_token)
    :precondition
      (and
        (aggregation_job_processing_initiated ?aggregation_job)
        (worker_assigned_to_aggregate_group ?aggregation_job ?worker_token)
        (not
          (aggregation_job_processing_stage2_initiated ?aggregation_job)
        )
      )
    :effect (aggregation_job_processing_stage2_initiated ?aggregation_job)
  )
  (:action advance_aggregation_job_processing_with_option_b
    :parameters (?aggregation_job - aggregation_job ?aggregator_option_b - aggregator_option_b)
    :precondition
      (and
        (aggregation_job_processing_stage2_initiated ?aggregation_job)
        (aggregation_job_has_aggregator_option_b ?aggregation_job ?aggregator_option_b)
        (not
          (aggregation_job_ready_to_emit ?aggregation_job)
        )
      )
    :effect (aggregation_job_ready_to_emit ?aggregation_job)
  )
  (:action finalize_aggregation_job_processing_and_emit
    :parameters (?aggregation_job - aggregation_job)
    :precondition
      (and
        (aggregation_job_ready_to_emit ?aggregation_job)
        (not
          (aggregation_job_finalized ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregation_job_finalized ?aggregation_job)
        (aggregate_group_output_ready ?aggregation_job)
      )
  )
  (:action collect_candidate_output_for_partition_a
    :parameters (?partition_instance_a - partition_instance_a ?result_candidate - result_candidate)
    :precondition
      (and
        (partition_instance_a_processing_claimed ?partition_instance_a)
        (partition_instance_a_processed ?partition_instance_a)
        (result_candidate_composed ?result_candidate)
        (candidate_marked_ready ?result_candidate)
        (not
          (aggregate_group_output_ready ?partition_instance_a)
        )
      )
    :effect (aggregate_group_output_ready ?partition_instance_a)
  )
  (:action collect_candidate_output_for_partition_b
    :parameters (?partition_instance_b - partition_instance_b ?result_candidate - result_candidate)
    :precondition
      (and
        (partition_instance_b_processing_claimed ?partition_instance_b)
        (partition_instance_b_processed ?partition_instance_b)
        (result_candidate_composed ?result_candidate)
        (candidate_marked_ready ?result_candidate)
        (not
          (aggregate_group_output_ready ?partition_instance_b)
        )
      )
    :effect (aggregate_group_output_ready ?partition_instance_b)
  )
  (:action bind_finalizer_to_aggregate_group
    :parameters (?aggregate_group - aggregate_group ?finalizer_token - finalizer_token ?input_record - input_record)
    :precondition
      (and
        (aggregate_group_output_ready ?aggregate_group)
        (record_assigned_to_aggregate_group ?aggregate_group ?input_record)
        (finalizer_token_available ?finalizer_token)
        (not
          (aggregate_group_has_finalizer ?aggregate_group)
        )
      )
    :effect
      (and
        (aggregate_group_has_finalizer ?aggregate_group)
        (aggregate_group_bound_to_finalizer_token ?aggregate_group ?finalizer_token)
        (not
          (finalizer_token_available ?finalizer_token)
        )
      )
  )
  (:action finalize_group_using_finalizer_a
    :parameters (?partition_instance_a - partition_instance_a ?compute_slot - compute_slot ?finalizer_token - finalizer_token)
    :precondition
      (and
        (aggregate_group_has_finalizer ?partition_instance_a)
        (aggregate_group_assigned_to_compute_slot ?partition_instance_a ?compute_slot)
        (aggregate_group_bound_to_finalizer_token ?partition_instance_a ?finalizer_token)
        (not
          (aggregate_group_finalized ?partition_instance_a)
        )
      )
    :effect
      (and
        (aggregate_group_finalized ?partition_instance_a)
        (compute_slot_available ?compute_slot)
        (finalizer_token_available ?finalizer_token)
      )
  )
  (:action finalize_group_using_finalizer_b
    :parameters (?partition_instance_b - partition_instance_b ?compute_slot - compute_slot ?finalizer_token - finalizer_token)
    :precondition
      (and
        (aggregate_group_has_finalizer ?partition_instance_b)
        (aggregate_group_assigned_to_compute_slot ?partition_instance_b ?compute_slot)
        (aggregate_group_bound_to_finalizer_token ?partition_instance_b ?finalizer_token)
        (not
          (aggregate_group_finalized ?partition_instance_b)
        )
      )
    :effect
      (and
        (aggregate_group_finalized ?partition_instance_b)
        (compute_slot_available ?compute_slot)
        (finalizer_token_available ?finalizer_token)
      )
  )
  (:action finalize_aggregation_job_using_finalizer
    :parameters (?aggregation_job - aggregation_job ?compute_slot - compute_slot ?finalizer_token - finalizer_token)
    :precondition
      (and
        (aggregate_group_has_finalizer ?aggregation_job)
        (aggregate_group_assigned_to_compute_slot ?aggregation_job ?compute_slot)
        (aggregate_group_bound_to_finalizer_token ?aggregation_job ?finalizer_token)
        (not
          (aggregate_group_finalized ?aggregation_job)
        )
      )
    :effect
      (and
        (aggregate_group_finalized ?aggregation_job)
        (compute_slot_available ?compute_slot)
        (finalizer_token_available ?finalizer_token)
      )
  )
)

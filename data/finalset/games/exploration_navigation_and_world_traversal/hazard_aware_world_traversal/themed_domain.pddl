(define (domain hazard_aware_world_traversal_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types item - object aux_object - object path_object - object location_supertype - object traversal_node - location_supertype access_token - item scout_unit - item mechanism - item optional_objective - item upgrade_module - item return_marker - item module_type_a - item module_type_b - item consumable - aux_object map_fragment - aux_object artifact - aux_object path_segment_type_a - path_object path_segment_type_b - path_object route_plan - path_object node_category_a - traversal_node node_category_b - traversal_node anchor_node - node_category_a target_node - node_category_a region - node_category_b)
  (:predicates
    (node_discovered ?traversal_node - traversal_node)
    (node_ready ?traversal_node - traversal_node)
    (token_bound ?traversal_node - traversal_node)
    (node_unlocked ?traversal_node - traversal_node)
    (node_flagged_complete ?traversal_node - traversal_node)
    (node_has_return_marker ?traversal_node - traversal_node)
    (token_available ?access_token - access_token)
    (node_has_token ?traversal_node - traversal_node ?access_token - access_token)
    (scout_available ?scout_unit - scout_unit)
    (node_probed_by_scout ?traversal_node - traversal_node ?scout_unit - scout_unit)
    (mechanism_available ?mechanism - mechanism)
    (node_has_mechanism ?traversal_node - traversal_node ?mechanism - mechanism)
    (consumable_available ?consumable - consumable)
    (node_has_consumable ?anchor_node - anchor_node ?consumable - consumable)
    (target_node_has_consumable_assignment ?target_node - target_node ?consumable - consumable)
    (anchor_node_to_path_a ?anchor_node - anchor_node ?path_segment_type_a - path_segment_type_a)
    (path_a_marked_observed ?path_segment_type_a - path_segment_type_a)
    (path_a_marked_safe ?path_segment_type_a - path_segment_type_a)
    (anchor_node_confirmed ?anchor_node - anchor_node)
    (target_node_to_path_b ?target_node - target_node ?path_segment_type_b - path_segment_type_b)
    (path_b_marked_observed ?path_segment_type_b - path_segment_type_b)
    (path_b_marked_safe ?path_segment_type_b - path_segment_type_b)
    (target_node_confirmed ?target_node - target_node)
    (route_plan_seed ?route_plan - route_plan)
    (route_plan_active ?route_plan - route_plan)
    (route_contains_path_a ?route_plan - route_plan ?path_segment_type_a - path_segment_type_a)
    (route_contains_path_b ?route_plan - route_plan ?path_segment_type_b - path_segment_type_b)
    (route_flag_return_optimized ?route_plan - route_plan)
    (route_flag_coverage_optimized ?route_plan - route_plan)
    (route_validated ?route_plan - route_plan)
    (region_includes_anchor ?region - region ?anchor_node - anchor_node)
    (region_includes_target ?region - region ?target_node - target_node)
    (region_associated_with_route ?region - region ?route_plan - route_plan)
    (map_fragment_available ?map_fragment - map_fragment)
    (region_has_map_fragment ?region - region ?map_fragment - map_fragment)
    (map_fragment_consumed ?map_fragment - map_fragment)
    (fragment_linked_to_route ?map_fragment - map_fragment ?route_plan - route_plan)
    (region_stage1_complete ?region - region)
    (region_stage2_complete ?region - region)
    (region_stage3_complete ?region - region)
    (region_has_optional_objective ?region - region)
    (region_optional_objective_used ?region - region)
    (region_ready_for_finalization ?region - region)
    (region_finalized ?region - region)
    (artifact_available ?artifact - artifact)
    (region_has_artifact ?region - region ?artifact - artifact)
    (artifact_stage_attached ?region - region)
    (artifact_stage_prepped ?region - region)
    (artifact_ready_for_claim ?region - region)
    (optional_objective_available ?optional_objective - optional_objective)
    (region_has_optional_binding ?region - region ?optional_objective - optional_objective)
    (upgrade_module_available ?upgrade_module - upgrade_module)
    (region_has_upgrade ?region - region ?upgrade_module - upgrade_module)
    (module_a_available ?module_type_a - module_type_a)
    (region_has_module_a ?region - region ?module_type_a - module_type_a)
    (module_b_available ?module_type_b - module_type_b)
    (region_has_module_b ?region - region ?module_type_b - module_type_b)
    (return_marker_available ?return_marker - return_marker)
    (node_bound_to_return_marker ?traversal_node - traversal_node ?return_marker - return_marker)
    (anchor_node_stage_flag ?anchor_node - anchor_node)
    (target_node_stage_flag ?target_node - target_node)
    (region_global_flag ?region - region)
  )
  (:action discover_node
    :parameters (?traversal_node - traversal_node)
    :precondition
      (and
        (not
          (node_discovered ?traversal_node)
        )
        (not
          (node_unlocked ?traversal_node)
        )
      )
    :effect (node_discovered ?traversal_node)
  )
  (:action assign_token_to_node
    :parameters (?traversal_node - traversal_node ?access_token - access_token)
    :precondition
      (and
        (node_discovered ?traversal_node)
        (not
          (token_bound ?traversal_node)
        )
        (token_available ?access_token)
      )
    :effect
      (and
        (token_bound ?traversal_node)
        (node_has_token ?traversal_node ?access_token)
        (not
          (token_available ?access_token)
        )
      )
  )
  (:action probe_node_with_scout
    :parameters (?traversal_node - traversal_node ?scout_unit - scout_unit)
    :precondition
      (and
        (node_discovered ?traversal_node)
        (token_bound ?traversal_node)
        (scout_available ?scout_unit)
      )
    :effect
      (and
        (node_probed_by_scout ?traversal_node ?scout_unit)
        (not
          (scout_available ?scout_unit)
        )
      )
  )
  (:action confirm_node_ready
    :parameters (?traversal_node - traversal_node ?scout_unit - scout_unit)
    :precondition
      (and
        (node_discovered ?traversal_node)
        (token_bound ?traversal_node)
        (node_probed_by_scout ?traversal_node ?scout_unit)
        (not
          (node_ready ?traversal_node)
        )
      )
    :effect (node_ready ?traversal_node)
  )
  (:action recall_scout
    :parameters (?traversal_node - traversal_node ?scout_unit - scout_unit)
    :precondition
      (and
        (node_probed_by_scout ?traversal_node ?scout_unit)
      )
    :effect
      (and
        (scout_available ?scout_unit)
        (not
          (node_probed_by_scout ?traversal_node ?scout_unit)
        )
      )
  )
  (:action attach_mechanism_to_node
    :parameters (?traversal_node - traversal_node ?mechanism - mechanism)
    :precondition
      (and
        (node_ready ?traversal_node)
        (mechanism_available ?mechanism)
      )
    :effect
      (and
        (node_has_mechanism ?traversal_node ?mechanism)
        (not
          (mechanism_available ?mechanism)
        )
      )
  )
  (:action detach_mechanism_from_node
    :parameters (?traversal_node - traversal_node ?mechanism - mechanism)
    :precondition
      (and
        (node_has_mechanism ?traversal_node ?mechanism)
      )
    :effect
      (and
        (mechanism_available ?mechanism)
        (not
          (node_has_mechanism ?traversal_node ?mechanism)
        )
      )
  )
  (:action install_module_a_on_region
    :parameters (?region - region ?module_type_a - module_type_a)
    :precondition
      (and
        (node_ready ?region)
        (module_a_available ?module_type_a)
      )
    :effect
      (and
        (region_has_module_a ?region ?module_type_a)
        (not
          (module_a_available ?module_type_a)
        )
      )
  )
  (:action remove_module_a_from_region
    :parameters (?region - region ?module_type_a - module_type_a)
    :precondition
      (and
        (region_has_module_a ?region ?module_type_a)
      )
    :effect
      (and
        (module_a_available ?module_type_a)
        (not
          (region_has_module_a ?region ?module_type_a)
        )
      )
  )
  (:action install_module_b_on_region
    :parameters (?region - region ?module_type_b - module_type_b)
    :precondition
      (and
        (node_ready ?region)
        (module_b_available ?module_type_b)
      )
    :effect
      (and
        (region_has_module_b ?region ?module_type_b)
        (not
          (module_b_available ?module_type_b)
        )
      )
  )
  (:action remove_module_b_from_region
    :parameters (?region - region ?module_type_b - module_type_b)
    :precondition
      (and
        (region_has_module_b ?region ?module_type_b)
      )
    :effect
      (and
        (module_b_available ?module_type_b)
        (not
          (region_has_module_b ?region ?module_type_b)
        )
      )
  )
  (:action mark_path_a_observed
    :parameters (?anchor_node - anchor_node ?path_segment_type_a - path_segment_type_a ?scout_unit - scout_unit)
    :precondition
      (and
        (node_ready ?anchor_node)
        (node_probed_by_scout ?anchor_node ?scout_unit)
        (anchor_node_to_path_a ?anchor_node ?path_segment_type_a)
        (not
          (path_a_marked_observed ?path_segment_type_a)
        )
        (not
          (path_a_marked_safe ?path_segment_type_a)
        )
      )
    :effect (path_a_marked_observed ?path_segment_type_a)
  )
  (:action stage_anchor_node_with_mechanism
    :parameters (?anchor_node - anchor_node ?path_segment_type_a - path_segment_type_a ?mechanism - mechanism)
    :precondition
      (and
        (node_ready ?anchor_node)
        (node_has_mechanism ?anchor_node ?mechanism)
        (anchor_node_to_path_a ?anchor_node ?path_segment_type_a)
        (path_a_marked_observed ?path_segment_type_a)
        (not
          (anchor_node_stage_flag ?anchor_node)
        )
      )
    :effect
      (and
        (anchor_node_stage_flag ?anchor_node)
        (anchor_node_confirmed ?anchor_node)
      )
  )
  (:action apply_consumable_to_path_a
    :parameters (?anchor_node - anchor_node ?path_segment_type_a - path_segment_type_a ?consumable - consumable)
    :precondition
      (and
        (node_ready ?anchor_node)
        (anchor_node_to_path_a ?anchor_node ?path_segment_type_a)
        (consumable_available ?consumable)
        (not
          (anchor_node_stage_flag ?anchor_node)
        )
      )
    :effect
      (and
        (path_a_marked_safe ?path_segment_type_a)
        (anchor_node_stage_flag ?anchor_node)
        (node_has_consumable ?anchor_node ?consumable)
        (not
          (consumable_available ?consumable)
        )
      )
  )
  (:action finalize_path_a_safety
    :parameters (?anchor_node - anchor_node ?path_segment_type_a - path_segment_type_a ?scout_unit - scout_unit ?consumable - consumable)
    :precondition
      (and
        (node_ready ?anchor_node)
        (node_probed_by_scout ?anchor_node ?scout_unit)
        (anchor_node_to_path_a ?anchor_node ?path_segment_type_a)
        (path_a_marked_safe ?path_segment_type_a)
        (node_has_consumable ?anchor_node ?consumable)
        (not
          (anchor_node_confirmed ?anchor_node)
        )
      )
    :effect
      (and
        (path_a_marked_observed ?path_segment_type_a)
        (anchor_node_confirmed ?anchor_node)
        (consumable_available ?consumable)
        (not
          (node_has_consumable ?anchor_node ?consumable)
        )
      )
  )
  (:action mark_path_b_observed
    :parameters (?target_node - target_node ?path_segment_type_b - path_segment_type_b ?scout_unit - scout_unit)
    :precondition
      (and
        (node_ready ?target_node)
        (node_probed_by_scout ?target_node ?scout_unit)
        (target_node_to_path_b ?target_node ?path_segment_type_b)
        (not
          (path_b_marked_observed ?path_segment_type_b)
        )
        (not
          (path_b_marked_safe ?path_segment_type_b)
        )
      )
    :effect (path_b_marked_observed ?path_segment_type_b)
  )
  (:action stage_target_node_with_mechanism
    :parameters (?target_node - target_node ?path_segment_type_b - path_segment_type_b ?mechanism - mechanism)
    :precondition
      (and
        (node_ready ?target_node)
        (node_has_mechanism ?target_node ?mechanism)
        (target_node_to_path_b ?target_node ?path_segment_type_b)
        (path_b_marked_observed ?path_segment_type_b)
        (not
          (target_node_stage_flag ?target_node)
        )
      )
    :effect
      (and
        (target_node_stage_flag ?target_node)
        (target_node_confirmed ?target_node)
      )
  )
  (:action apply_consumable_to_path_b
    :parameters (?target_node - target_node ?path_segment_type_b - path_segment_type_b ?consumable - consumable)
    :precondition
      (and
        (node_ready ?target_node)
        (target_node_to_path_b ?target_node ?path_segment_type_b)
        (consumable_available ?consumable)
        (not
          (target_node_stage_flag ?target_node)
        )
      )
    :effect
      (and
        (path_b_marked_safe ?path_segment_type_b)
        (target_node_stage_flag ?target_node)
        (target_node_has_consumable_assignment ?target_node ?consumable)
        (not
          (consumable_available ?consumable)
        )
      )
  )
  (:action finalize_path_b_safety
    :parameters (?target_node - target_node ?path_segment_type_b - path_segment_type_b ?scout_unit - scout_unit ?consumable - consumable)
    :precondition
      (and
        (node_ready ?target_node)
        (node_probed_by_scout ?target_node ?scout_unit)
        (target_node_to_path_b ?target_node ?path_segment_type_b)
        (path_b_marked_safe ?path_segment_type_b)
        (target_node_has_consumable_assignment ?target_node ?consumable)
        (not
          (target_node_confirmed ?target_node)
        )
      )
    :effect
      (and
        (path_b_marked_observed ?path_segment_type_b)
        (target_node_confirmed ?target_node)
        (consumable_available ?consumable)
        (not
          (target_node_has_consumable_assignment ?target_node ?consumable)
        )
      )
  )
  (:action assemble_route_plan
    :parameters (?anchor_node - anchor_node ?target_node - target_node ?path_segment_type_a - path_segment_type_a ?path_segment_type_b - path_segment_type_b ?route_plan - route_plan)
    :precondition
      (and
        (anchor_node_stage_flag ?anchor_node)
        (target_node_stage_flag ?target_node)
        (anchor_node_to_path_a ?anchor_node ?path_segment_type_a)
        (target_node_to_path_b ?target_node ?path_segment_type_b)
        (path_a_marked_observed ?path_segment_type_a)
        (path_b_marked_observed ?path_segment_type_b)
        (anchor_node_confirmed ?anchor_node)
        (target_node_confirmed ?target_node)
        (route_plan_seed ?route_plan)
      )
    :effect
      (and
        (route_plan_active ?route_plan)
        (route_contains_path_a ?route_plan ?path_segment_type_a)
        (route_contains_path_b ?route_plan ?path_segment_type_b)
        (not
          (route_plan_seed ?route_plan)
        )
      )
  )
  (:action assemble_route_plan_return_optimized
    :parameters (?anchor_node - anchor_node ?target_node - target_node ?path_segment_type_a - path_segment_type_a ?path_segment_type_b - path_segment_type_b ?route_plan - route_plan)
    :precondition
      (and
        (anchor_node_stage_flag ?anchor_node)
        (target_node_stage_flag ?target_node)
        (anchor_node_to_path_a ?anchor_node ?path_segment_type_a)
        (target_node_to_path_b ?target_node ?path_segment_type_b)
        (path_a_marked_safe ?path_segment_type_a)
        (path_b_marked_observed ?path_segment_type_b)
        (not
          (anchor_node_confirmed ?anchor_node)
        )
        (target_node_confirmed ?target_node)
        (route_plan_seed ?route_plan)
      )
    :effect
      (and
        (route_plan_active ?route_plan)
        (route_contains_path_a ?route_plan ?path_segment_type_a)
        (route_contains_path_b ?route_plan ?path_segment_type_b)
        (route_flag_return_optimized ?route_plan)
        (not
          (route_plan_seed ?route_plan)
        )
      )
  )
  (:action assemble_route_plan_coverage_optimized
    :parameters (?anchor_node - anchor_node ?target_node - target_node ?path_segment_type_a - path_segment_type_a ?path_segment_type_b - path_segment_type_b ?route_plan - route_plan)
    :precondition
      (and
        (anchor_node_stage_flag ?anchor_node)
        (target_node_stage_flag ?target_node)
        (anchor_node_to_path_a ?anchor_node ?path_segment_type_a)
        (target_node_to_path_b ?target_node ?path_segment_type_b)
        (path_a_marked_observed ?path_segment_type_a)
        (path_b_marked_safe ?path_segment_type_b)
        (anchor_node_confirmed ?anchor_node)
        (not
          (target_node_confirmed ?target_node)
        )
        (route_plan_seed ?route_plan)
      )
    :effect
      (and
        (route_plan_active ?route_plan)
        (route_contains_path_a ?route_plan ?path_segment_type_a)
        (route_contains_path_b ?route_plan ?path_segment_type_b)
        (route_flag_coverage_optimized ?route_plan)
        (not
          (route_plan_seed ?route_plan)
        )
      )
  )
  (:action assemble_route_plan_both_optimizations
    :parameters (?anchor_node - anchor_node ?target_node - target_node ?path_segment_type_a - path_segment_type_a ?path_segment_type_b - path_segment_type_b ?route_plan - route_plan)
    :precondition
      (and
        (anchor_node_stage_flag ?anchor_node)
        (target_node_stage_flag ?target_node)
        (anchor_node_to_path_a ?anchor_node ?path_segment_type_a)
        (target_node_to_path_b ?target_node ?path_segment_type_b)
        (path_a_marked_safe ?path_segment_type_a)
        (path_b_marked_safe ?path_segment_type_b)
        (not
          (anchor_node_confirmed ?anchor_node)
        )
        (not
          (target_node_confirmed ?target_node)
        )
        (route_plan_seed ?route_plan)
      )
    :effect
      (and
        (route_plan_active ?route_plan)
        (route_contains_path_a ?route_plan ?path_segment_type_a)
        (route_contains_path_b ?route_plan ?path_segment_type_b)
        (route_flag_return_optimized ?route_plan)
        (route_flag_coverage_optimized ?route_plan)
        (not
          (route_plan_seed ?route_plan)
        )
      )
  )
  (:action validate_route_plan
    :parameters (?route_plan - route_plan ?anchor_node - anchor_node ?scout_unit - scout_unit)
    :precondition
      (and
        (route_plan_active ?route_plan)
        (anchor_node_stage_flag ?anchor_node)
        (node_probed_by_scout ?anchor_node ?scout_unit)
        (not
          (route_validated ?route_plan)
        )
      )
    :effect (route_validated ?route_plan)
  )
  (:action apply_map_fragment_to_route
    :parameters (?region - region ?map_fragment - map_fragment ?route_plan - route_plan)
    :precondition
      (and
        (node_ready ?region)
        (region_associated_with_route ?region ?route_plan)
        (region_has_map_fragment ?region ?map_fragment)
        (map_fragment_available ?map_fragment)
        (route_plan_active ?route_plan)
        (route_validated ?route_plan)
        (not
          (map_fragment_consumed ?map_fragment)
        )
      )
    :effect
      (and
        (map_fragment_consumed ?map_fragment)
        (fragment_linked_to_route ?map_fragment ?route_plan)
        (not
          (map_fragment_available ?map_fragment)
        )
      )
  )
  (:action complete_region_stage1
    :parameters (?region - region ?map_fragment - map_fragment ?route_plan - route_plan ?scout_unit - scout_unit)
    :precondition
      (and
        (node_ready ?region)
        (region_has_map_fragment ?region ?map_fragment)
        (map_fragment_consumed ?map_fragment)
        (fragment_linked_to_route ?map_fragment ?route_plan)
        (node_probed_by_scout ?region ?scout_unit)
        (not
          (route_flag_return_optimized ?route_plan)
        )
        (not
          (region_stage1_complete ?region)
        )
      )
    :effect (region_stage1_complete ?region)
  )
  (:action attach_optional_objective_to_region
    :parameters (?region - region ?optional_objective - optional_objective)
    :precondition
      (and
        (node_ready ?region)
        (optional_objective_available ?optional_objective)
        (not
          (region_has_optional_objective ?region)
        )
      )
    :effect
      (and
        (region_has_optional_objective ?region)
        (region_has_optional_binding ?region ?optional_objective)
        (not
          (optional_objective_available ?optional_objective)
        )
      )
  )
  (:action progress_region_with_optional_binding
    :parameters (?region - region ?map_fragment - map_fragment ?route_plan - route_plan ?scout_unit - scout_unit ?optional_objective - optional_objective)
    :precondition
      (and
        (node_ready ?region)
        (region_has_map_fragment ?region ?map_fragment)
        (map_fragment_consumed ?map_fragment)
        (fragment_linked_to_route ?map_fragment ?route_plan)
        (node_probed_by_scout ?region ?scout_unit)
        (route_flag_return_optimized ?route_plan)
        (region_has_optional_objective ?region)
        (region_has_optional_binding ?region ?optional_objective)
        (not
          (region_stage1_complete ?region)
        )
      )
    :effect
      (and
        (region_stage1_complete ?region)
        (region_optional_objective_used ?region)
      )
  )
  (:action advance_region_stage2
    :parameters (?region - region ?module_type_a - module_type_a ?mechanism - mechanism ?map_fragment - map_fragment ?route_plan - route_plan)
    :precondition
      (and
        (region_stage1_complete ?region)
        (region_has_module_a ?region ?module_type_a)
        (node_has_mechanism ?region ?mechanism)
        (region_has_map_fragment ?region ?map_fragment)
        (fragment_linked_to_route ?map_fragment ?route_plan)
        (not
          (route_flag_coverage_optimized ?route_plan)
        )
        (not
          (region_stage2_complete ?region)
        )
      )
    :effect (region_stage2_complete ?region)
  )
  (:action advance_region_stage2_with_coverage
    :parameters (?region - region ?module_type_a - module_type_a ?mechanism - mechanism ?map_fragment - map_fragment ?route_plan - route_plan)
    :precondition
      (and
        (region_stage1_complete ?region)
        (region_has_module_a ?region ?module_type_a)
        (node_has_mechanism ?region ?mechanism)
        (region_has_map_fragment ?region ?map_fragment)
        (fragment_linked_to_route ?map_fragment ?route_plan)
        (route_flag_coverage_optimized ?route_plan)
        (not
          (region_stage2_complete ?region)
        )
      )
    :effect (region_stage2_complete ?region)
  )
  (:action complete_region_stage3
    :parameters (?region - region ?module_type_b - module_type_b ?map_fragment - map_fragment ?route_plan - route_plan)
    :precondition
      (and
        (region_stage2_complete ?region)
        (region_has_module_b ?region ?module_type_b)
        (region_has_map_fragment ?region ?map_fragment)
        (fragment_linked_to_route ?map_fragment ?route_plan)
        (not
          (route_flag_return_optimized ?route_plan)
        )
        (not
          (route_flag_coverage_optimized ?route_plan)
        )
        (not
          (region_stage3_complete ?region)
        )
      )
    :effect (region_stage3_complete ?region)
  )
  (:action complete_region_stage3_and_mark_ready
    :parameters (?region - region ?module_type_b - module_type_b ?map_fragment - map_fragment ?route_plan - route_plan)
    :precondition
      (and
        (region_stage2_complete ?region)
        (region_has_module_b ?region ?module_type_b)
        (region_has_map_fragment ?region ?map_fragment)
        (fragment_linked_to_route ?map_fragment ?route_plan)
        (route_flag_return_optimized ?route_plan)
        (not
          (route_flag_coverage_optimized ?route_plan)
        )
        (not
          (region_stage3_complete ?region)
        )
      )
    :effect
      (and
        (region_stage3_complete ?region)
        (region_ready_for_finalization ?region)
      )
  )
  (:action complete_region_stage3_and_mark_ready_alt
    :parameters (?region - region ?module_type_b - module_type_b ?map_fragment - map_fragment ?route_plan - route_plan)
    :precondition
      (and
        (region_stage2_complete ?region)
        (region_has_module_b ?region ?module_type_b)
        (region_has_map_fragment ?region ?map_fragment)
        (fragment_linked_to_route ?map_fragment ?route_plan)
        (not
          (route_flag_return_optimized ?route_plan)
        )
        (route_flag_coverage_optimized ?route_plan)
        (not
          (region_stage3_complete ?region)
        )
      )
    :effect
      (and
        (region_stage3_complete ?region)
        (region_ready_for_finalization ?region)
      )
  )
  (:action complete_region_stage3_and_mark_ready_both
    :parameters (?region - region ?module_type_b - module_type_b ?map_fragment - map_fragment ?route_plan - route_plan)
    :precondition
      (and
        (region_stage2_complete ?region)
        (region_has_module_b ?region ?module_type_b)
        (region_has_map_fragment ?region ?map_fragment)
        (fragment_linked_to_route ?map_fragment ?route_plan)
        (route_flag_return_optimized ?route_plan)
        (route_flag_coverage_optimized ?route_plan)
        (not
          (region_stage3_complete ?region)
        )
      )
    :effect
      (and
        (region_stage3_complete ?region)
        (region_ready_for_finalization ?region)
      )
  )
  (:action register_region_completion
    :parameters (?region - region)
    :precondition
      (and
        (region_stage3_complete ?region)
        (not
          (region_ready_for_finalization ?region)
        )
        (not
          (region_global_flag ?region)
        )
      )
    :effect
      (and
        (region_global_flag ?region)
        (node_flagged_complete ?region)
      )
  )
  (:action attach_upgrade_to_region
    :parameters (?region - region ?upgrade_module - upgrade_module)
    :precondition
      (and
        (region_stage3_complete ?region)
        (region_ready_for_finalization ?region)
        (upgrade_module_available ?upgrade_module)
      )
    :effect
      (and
        (region_has_upgrade ?region ?upgrade_module)
        (not
          (upgrade_module_available ?upgrade_module)
        )
      )
  )
  (:action finalize_region
    :parameters (?region - region ?anchor_node - anchor_node ?target_node - target_node ?scout_unit - scout_unit ?upgrade_module - upgrade_module)
    :precondition
      (and
        (region_stage3_complete ?region)
        (region_ready_for_finalization ?region)
        (region_has_upgrade ?region ?upgrade_module)
        (region_includes_anchor ?region ?anchor_node)
        (region_includes_target ?region ?target_node)
        (anchor_node_confirmed ?anchor_node)
        (target_node_confirmed ?target_node)
        (node_probed_by_scout ?region ?scout_unit)
        (not
          (region_finalized ?region)
        )
      )
    :effect (region_finalized ?region)
  )
  (:action register_region_completion_post_finalization
    :parameters (?region - region)
    :precondition
      (and
        (region_stage3_complete ?region)
        (region_finalized ?region)
        (not
          (region_global_flag ?region)
        )
      )
    :effect
      (and
        (region_global_flag ?region)
        (node_flagged_complete ?region)
      )
  )
  (:action attach_artifact_stage
    :parameters (?region - region ?artifact - artifact ?scout_unit - scout_unit)
    :precondition
      (and
        (node_ready ?region)
        (node_probed_by_scout ?region ?scout_unit)
        (artifact_available ?artifact)
        (region_has_artifact ?region ?artifact)
        (not
          (artifact_stage_attached ?region)
        )
      )
    :effect
      (and
        (artifact_stage_attached ?region)
        (not
          (artifact_available ?artifact)
        )
      )
  )
  (:action prepare_artifact_stage
    :parameters (?region - region ?mechanism - mechanism)
    :precondition
      (and
        (artifact_stage_attached ?region)
        (node_has_mechanism ?region ?mechanism)
        (not
          (artifact_stage_prepped ?region)
        )
      )
    :effect (artifact_stage_prepped ?region)
  )
  (:action mark_artifact_ready_for_claim
    :parameters (?region - region ?module_type_b - module_type_b)
    :precondition
      (and
        (artifact_stage_prepped ?region)
        (region_has_module_b ?region ?module_type_b)
        (not
          (artifact_ready_for_claim ?region)
        )
      )
    :effect (artifact_ready_for_claim ?region)
  )
  (:action claim_artifact_and_register_completion
    :parameters (?region - region)
    :precondition
      (and
        (artifact_ready_for_claim ?region)
        (not
          (region_global_flag ?region)
        )
      )
    :effect
      (and
        (region_global_flag ?region)
        (node_flagged_complete ?region)
      )
  )
  (:action clear_anchor_node_by_route
    :parameters (?anchor_node - anchor_node ?route_plan - route_plan)
    :precondition
      (and
        (anchor_node_stage_flag ?anchor_node)
        (anchor_node_confirmed ?anchor_node)
        (route_plan_active ?route_plan)
        (route_validated ?route_plan)
        (not
          (node_flagged_complete ?anchor_node)
        )
      )
    :effect (node_flagged_complete ?anchor_node)
  )
  (:action clear_target_node_by_route
    :parameters (?target_node - target_node ?route_plan - route_plan)
    :precondition
      (and
        (target_node_stage_flag ?target_node)
        (target_node_confirmed ?target_node)
        (route_plan_active ?route_plan)
        (route_validated ?route_plan)
        (not
          (node_flagged_complete ?target_node)
        )
      )
    :effect (node_flagged_complete ?target_node)
  )
  (:action place_return_marker_on_node
    :parameters (?traversal_node - traversal_node ?return_marker - return_marker ?scout_unit - scout_unit)
    :precondition
      (and
        (node_flagged_complete ?traversal_node)
        (node_probed_by_scout ?traversal_node ?scout_unit)
        (return_marker_available ?return_marker)
        (not
          (node_has_return_marker ?traversal_node)
        )
      )
    :effect
      (and
        (node_has_return_marker ?traversal_node)
        (node_bound_to_return_marker ?traversal_node ?return_marker)
        (not
          (return_marker_available ?return_marker)
        )
      )
  )
  (:action unlock_node_with_token_and_return_marker
    :parameters (?anchor_node - anchor_node ?access_token - access_token ?return_marker - return_marker)
    :precondition
      (and
        (node_has_return_marker ?anchor_node)
        (node_has_token ?anchor_node ?access_token)
        (node_bound_to_return_marker ?anchor_node ?return_marker)
        (not
          (node_unlocked ?anchor_node)
        )
      )
    :effect
      (and
        (node_unlocked ?anchor_node)
        (token_available ?access_token)
        (return_marker_available ?return_marker)
      )
  )
  (:action unlock_target_with_token_and_return_marker
    :parameters (?target_node - target_node ?access_token - access_token ?return_marker - return_marker)
    :precondition
      (and
        (node_has_return_marker ?target_node)
        (node_has_token ?target_node ?access_token)
        (node_bound_to_return_marker ?target_node ?return_marker)
        (not
          (node_unlocked ?target_node)
        )
      )
    :effect
      (and
        (node_unlocked ?target_node)
        (token_available ?access_token)
        (return_marker_available ?return_marker)
      )
  )
  (:action unlock_region_with_token_and_return_marker
    :parameters (?region - region ?access_token - access_token ?return_marker - return_marker)
    :precondition
      (and
        (node_has_return_marker ?region)
        (node_has_token ?region ?access_token)
        (node_bound_to_return_marker ?region ?return_marker)
        (not
          (node_unlocked ?region)
        )
      )
    :effect
      (and
        (node_unlocked ?region)
        (token_available ?access_token)
        (return_marker_available ?return_marker)
      )
  )
)

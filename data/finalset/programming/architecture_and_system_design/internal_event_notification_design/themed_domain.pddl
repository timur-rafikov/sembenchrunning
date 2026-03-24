(define (domain internal_event_notification)
  (:requirements :strips :typing :negative-preconditions)
  (:types domain_entity_class - object structural_class - object transport_class - object participant_base - object processing_entity - participant_base subscription_record - domain_entity_class event_type - domain_entity_class delivery_handler - domain_entity_class priority_tag - domain_entity_class delivery_policy - domain_entity_class ack_channel - domain_entity_class capability_token - domain_entity_class retry_config - domain_entity_class filter_transform - structural_class payload_template - structural_class routing_affinity - structural_class publisher_slot - transport_class subscriber_slot - transport_class message_envelope - transport_class publisher_subclass - processing_entity subscriber_subclass - processing_entity publisher - publisher_subclass subscriber - publisher_subclass notifier_coordinator - subscriber_subclass)
  (:predicates
    (service_registered ?event_instance - processing_entity)
    (service_processing_enabled ?event_instance - processing_entity)
    (service_subscription_registered ?event_instance - processing_entity)
    (service_completed ?event_instance - processing_entity)
    (ready_for_finalization ?event_instance - processing_entity)
    (service_acknowledged ?event_instance - processing_entity)
    (subscription_record_available ?subscription_record - subscription_record)
    (service_subscription_record ?event_instance - processing_entity ?subscription_record - subscription_record)
    (service_type_available ?event_type - event_type)
    (service_type_association ?event_instance - processing_entity ?event_type - event_type)
    (delivery_handler_available ?delivery_handler - delivery_handler)
    (service_handler_assigned ?event_instance - processing_entity ?delivery_handler - delivery_handler)
    (filter_transform_available ?filter_transform - filter_transform)
    (publisher_filter_binding ?publisher - publisher ?filter_transform - filter_transform)
    (subscriber_filter_binding ?subscriber - subscriber ?filter_transform - filter_transform)
    (publisher_slot_binding ?publisher - publisher ?publisher_slot - publisher_slot)
    (publisher_slot_ready ?publisher_slot - publisher_slot)
    (publisher_slot_transformed ?publisher_slot - publisher_slot)
    (publisher_primed ?publisher - publisher)
    (subscriber_slot_binding ?subscriber - subscriber ?subscriber_slot - subscriber_slot)
    (subscriber_slot_ready ?subscriber_slot - subscriber_slot)
    (subscriber_slot_transformed ?subscriber_slot - subscriber_slot)
    (subscriber_primed ?subscriber - subscriber)
    (envelope_available ?message_envelope - message_envelope)
    (envelope_created ?message_envelope - message_envelope)
    (envelope_publisher_slot ?message_envelope - message_envelope ?publisher_slot - publisher_slot)
    (envelope_subscriber_slot ?message_envelope - message_envelope ?subscriber_slot - subscriber_slot)
    (envelope_has_publisher_transform ?message_envelope - message_envelope)
    (envelope_has_subscriber_transform ?message_envelope - message_envelope)
    (envelope_ready_for_dispatch ?message_envelope - message_envelope)
    (coordinator_publisher_binding ?notifier_coordinator - notifier_coordinator ?publisher - publisher)
    (coordinator_subscriber_binding ?notifier_coordinator - notifier_coordinator ?subscriber - subscriber)
    (coordinator_envelope_assigned ?notifier_coordinator - notifier_coordinator ?message_envelope - message_envelope)
    (payload_template_available ?payload_template - payload_template)
    (coordinator_payload_template_assigned ?notifier_coordinator - notifier_coordinator ?payload_template - payload_template)
    (payload_template_consumed ?payload_template - payload_template)
    (payload_template_for_envelope ?payload_template - payload_template ?message_envelope - message_envelope)
    (coordinator_template_applied ?notifier_coordinator - notifier_coordinator)
    (coordinator_feature_engaged ?notifier_coordinator - notifier_coordinator)
    (coordinator_delivery_ready ?notifier_coordinator - notifier_coordinator)
    (coordinator_priority_enabled ?notifier_coordinator - notifier_coordinator)
    (coordinator_priority_applied ?notifier_coordinator - notifier_coordinator)
    (coordinator_feature_enabled ?notifier_coordinator - notifier_coordinator)
    (coordinator_dispatch_committed ?notifier_coordinator - notifier_coordinator)
    (routing_affinity_available ?routing_affinity - routing_affinity)
    (coordinator_routing_affinity ?notifier_coordinator - notifier_coordinator ?routing_affinity - routing_affinity)
    (coordinator_affinity_applied ?notifier_coordinator - notifier_coordinator)
    (coordinator_affinity_locked ?notifier_coordinator - notifier_coordinator)
    (coordinator_affinity_confirmed ?notifier_coordinator - notifier_coordinator)
    (priority_tag_available ?priority_tag - priority_tag)
    (coordinator_priority_tag ?notifier_coordinator - notifier_coordinator ?priority_tag - priority_tag)
    (delivery_policy_available ?delivery_policy - delivery_policy)
    (coordinator_delivery_policy ?notifier_coordinator - notifier_coordinator ?delivery_policy - delivery_policy)
    (capability_token_available ?capability_token - capability_token)
    (coordinator_capability_token ?notifier_coordinator - notifier_coordinator ?capability_token - capability_token)
    (retry_config_available ?retry_config - retry_config)
    (coordinator_retry_config ?notifier_coordinator - notifier_coordinator ?retry_config - retry_config)
    (ack_channel_available ?ack_channel - ack_channel)
    (service_ack_channel ?event_instance - processing_entity ?ack_channel - ack_channel)
    (publisher_has_token ?publisher - publisher)
    (subscriber_has_token ?subscriber - subscriber)
    (completion_recorded ?notifier_coordinator - notifier_coordinator)
  )
  (:action register_event_instance
    :parameters (?event_instance - processing_entity)
    :precondition
      (and
        (not
          (service_registered ?event_instance)
        )
        (not
          (service_completed ?event_instance)
        )
      )
    :effect (service_registered ?event_instance)
  )
  (:action bind_subscription_record_to_event
    :parameters (?event_instance - processing_entity ?subscription_record - subscription_record)
    :precondition
      (and
        (service_registered ?event_instance)
        (not
          (service_subscription_registered ?event_instance)
        )
        (subscription_record_available ?subscription_record)
      )
    :effect
      (and
        (service_subscription_registered ?event_instance)
        (service_subscription_record ?event_instance ?subscription_record)
        (not
          (subscription_record_available ?subscription_record)
        )
      )
  )
  (:action attach_event_type_to_event
    :parameters (?event_instance - processing_entity ?event_type - event_type)
    :precondition
      (and
        (service_registered ?event_instance)
        (service_subscription_registered ?event_instance)
        (service_type_available ?event_type)
      )
    :effect
      (and
        (service_type_association ?event_instance ?event_type)
        (not
          (service_type_available ?event_type)
        )
      )
  )
  (:action enable_event_processing
    :parameters (?event_instance - processing_entity ?event_type - event_type)
    :precondition
      (and
        (service_registered ?event_instance)
        (service_subscription_registered ?event_instance)
        (service_type_association ?event_instance ?event_type)
        (not
          (service_processing_enabled ?event_instance)
        )
      )
    :effect (service_processing_enabled ?event_instance)
  )
  (:action unassign_event_type
    :parameters (?event_instance - processing_entity ?event_type - event_type)
    :precondition
      (and
        (service_type_association ?event_instance ?event_type)
      )
    :effect
      (and
        (service_type_available ?event_type)
        (not
          (service_type_association ?event_instance ?event_type)
        )
      )
  )
  (:action assign_delivery_handler_to_event
    :parameters (?event_instance - processing_entity ?delivery_handler - delivery_handler)
    :precondition
      (and
        (service_processing_enabled ?event_instance)
        (delivery_handler_available ?delivery_handler)
      )
    :effect
      (and
        (service_handler_assigned ?event_instance ?delivery_handler)
        (not
          (delivery_handler_available ?delivery_handler)
        )
      )
  )
  (:action release_delivery_handler_from_event
    :parameters (?event_instance - processing_entity ?delivery_handler - delivery_handler)
    :precondition
      (and
        (service_handler_assigned ?event_instance ?delivery_handler)
      )
    :effect
      (and
        (delivery_handler_available ?delivery_handler)
        (not
          (service_handler_assigned ?event_instance ?delivery_handler)
        )
      )
  )
  (:action allocate_capability_token_to_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?capability_token - capability_token)
    :precondition
      (and
        (service_processing_enabled ?notifier_coordinator)
        (capability_token_available ?capability_token)
      )
    :effect
      (and
        (coordinator_capability_token ?notifier_coordinator ?capability_token)
        (not
          (capability_token_available ?capability_token)
        )
      )
  )
  (:action release_capability_token_from_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?capability_token - capability_token)
    :precondition
      (and
        (coordinator_capability_token ?notifier_coordinator ?capability_token)
      )
    :effect
      (and
        (capability_token_available ?capability_token)
        (not
          (coordinator_capability_token ?notifier_coordinator ?capability_token)
        )
      )
  )
  (:action attach_retry_config_to_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?retry_config - retry_config)
    :precondition
      (and
        (service_processing_enabled ?notifier_coordinator)
        (retry_config_available ?retry_config)
      )
    :effect
      (and
        (coordinator_retry_config ?notifier_coordinator ?retry_config)
        (not
          (retry_config_available ?retry_config)
        )
      )
  )
  (:action detach_retry_config_from_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?retry_config - retry_config)
    :precondition
      (and
        (coordinator_retry_config ?notifier_coordinator ?retry_config)
      )
    :effect
      (and
        (retry_config_available ?retry_config)
        (not
          (coordinator_retry_config ?notifier_coordinator ?retry_config)
        )
      )
  )
  (:action activate_publisher_slot
    :parameters (?publisher - publisher ?publisher_slot - publisher_slot ?event_type - event_type)
    :precondition
      (and
        (service_processing_enabled ?publisher)
        (service_type_association ?publisher ?event_type)
        (publisher_slot_binding ?publisher ?publisher_slot)
        (not
          (publisher_slot_ready ?publisher_slot)
        )
        (not
          (publisher_slot_transformed ?publisher_slot)
        )
      )
    :effect (publisher_slot_ready ?publisher_slot)
  )
  (:action claim_publisher_slot
    :parameters (?publisher - publisher ?publisher_slot - publisher_slot ?delivery_handler - delivery_handler)
    :precondition
      (and
        (service_processing_enabled ?publisher)
        (service_handler_assigned ?publisher ?delivery_handler)
        (publisher_slot_binding ?publisher ?publisher_slot)
        (publisher_slot_ready ?publisher_slot)
        (not
          (publisher_has_token ?publisher)
        )
      )
    :effect
      (and
        (publisher_has_token ?publisher)
        (publisher_primed ?publisher)
      )
  )
  (:action apply_filter_transform_to_publisher_slot
    :parameters (?publisher - publisher ?publisher_slot - publisher_slot ?filter_transform - filter_transform)
    :precondition
      (and
        (service_processing_enabled ?publisher)
        (publisher_slot_binding ?publisher ?publisher_slot)
        (filter_transform_available ?filter_transform)
        (not
          (publisher_has_token ?publisher)
        )
      )
    :effect
      (and
        (publisher_slot_transformed ?publisher_slot)
        (publisher_has_token ?publisher)
        (publisher_filter_binding ?publisher ?filter_transform)
        (not
          (filter_transform_available ?filter_transform)
        )
      )
  )
  (:action finalize_publisher_slot_processing
    :parameters (?publisher - publisher ?publisher_slot - publisher_slot ?event_type - event_type ?filter_transform - filter_transform)
    :precondition
      (and
        (service_processing_enabled ?publisher)
        (service_type_association ?publisher ?event_type)
        (publisher_slot_binding ?publisher ?publisher_slot)
        (publisher_slot_transformed ?publisher_slot)
        (publisher_filter_binding ?publisher ?filter_transform)
        (not
          (publisher_primed ?publisher)
        )
      )
    :effect
      (and
        (publisher_slot_ready ?publisher_slot)
        (publisher_primed ?publisher)
        (filter_transform_available ?filter_transform)
        (not
          (publisher_filter_binding ?publisher ?filter_transform)
        )
      )
  )
  (:action activate_subscriber_slot
    :parameters (?subscriber - subscriber ?subscriber_slot - subscriber_slot ?event_type - event_type)
    :precondition
      (and
        (service_processing_enabled ?subscriber)
        (service_type_association ?subscriber ?event_type)
        (subscriber_slot_binding ?subscriber ?subscriber_slot)
        (not
          (subscriber_slot_ready ?subscriber_slot)
        )
        (not
          (subscriber_slot_transformed ?subscriber_slot)
        )
      )
    :effect (subscriber_slot_ready ?subscriber_slot)
  )
  (:action claim_subscriber_slot
    :parameters (?subscriber - subscriber ?subscriber_slot - subscriber_slot ?delivery_handler - delivery_handler)
    :precondition
      (and
        (service_processing_enabled ?subscriber)
        (service_handler_assigned ?subscriber ?delivery_handler)
        (subscriber_slot_binding ?subscriber ?subscriber_slot)
        (subscriber_slot_ready ?subscriber_slot)
        (not
          (subscriber_has_token ?subscriber)
        )
      )
    :effect
      (and
        (subscriber_has_token ?subscriber)
        (subscriber_primed ?subscriber)
      )
  )
  (:action apply_filter_transform_to_subscriber_slot
    :parameters (?subscriber - subscriber ?subscriber_slot - subscriber_slot ?filter_transform - filter_transform)
    :precondition
      (and
        (service_processing_enabled ?subscriber)
        (subscriber_slot_binding ?subscriber ?subscriber_slot)
        (filter_transform_available ?filter_transform)
        (not
          (subscriber_has_token ?subscriber)
        )
      )
    :effect
      (and
        (subscriber_slot_transformed ?subscriber_slot)
        (subscriber_has_token ?subscriber)
        (subscriber_filter_binding ?subscriber ?filter_transform)
        (not
          (filter_transform_available ?filter_transform)
        )
      )
  )
  (:action finalize_subscriber_slot_processing
    :parameters (?subscriber - subscriber ?subscriber_slot - subscriber_slot ?event_type - event_type ?filter_transform - filter_transform)
    :precondition
      (and
        (service_processing_enabled ?subscriber)
        (service_type_association ?subscriber ?event_type)
        (subscriber_slot_binding ?subscriber ?subscriber_slot)
        (subscriber_slot_transformed ?subscriber_slot)
        (subscriber_filter_binding ?subscriber ?filter_transform)
        (not
          (subscriber_primed ?subscriber)
        )
      )
    :effect
      (and
        (subscriber_slot_ready ?subscriber_slot)
        (subscriber_primed ?subscriber)
        (filter_transform_available ?filter_transform)
        (not
          (subscriber_filter_binding ?subscriber ?filter_transform)
        )
      )
  )
  (:action compose_message_envelope
    :parameters (?publisher - publisher ?subscriber - subscriber ?publisher_slot - publisher_slot ?subscriber_slot - subscriber_slot ?message_envelope - message_envelope)
    :precondition
      (and
        (publisher_has_token ?publisher)
        (subscriber_has_token ?subscriber)
        (publisher_slot_binding ?publisher ?publisher_slot)
        (subscriber_slot_binding ?subscriber ?subscriber_slot)
        (publisher_slot_ready ?publisher_slot)
        (subscriber_slot_ready ?subscriber_slot)
        (publisher_primed ?publisher)
        (subscriber_primed ?subscriber)
        (envelope_available ?message_envelope)
      )
    :effect
      (and
        (envelope_created ?message_envelope)
        (envelope_publisher_slot ?message_envelope ?publisher_slot)
        (envelope_subscriber_slot ?message_envelope ?subscriber_slot)
        (not
          (envelope_available ?message_envelope)
        )
      )
  )
  (:action compose_envelope_with_publisher_transform
    :parameters (?publisher - publisher ?subscriber - subscriber ?publisher_slot - publisher_slot ?subscriber_slot - subscriber_slot ?message_envelope - message_envelope)
    :precondition
      (and
        (publisher_has_token ?publisher)
        (subscriber_has_token ?subscriber)
        (publisher_slot_binding ?publisher ?publisher_slot)
        (subscriber_slot_binding ?subscriber ?subscriber_slot)
        (publisher_slot_transformed ?publisher_slot)
        (subscriber_slot_ready ?subscriber_slot)
        (not
          (publisher_primed ?publisher)
        )
        (subscriber_primed ?subscriber)
        (envelope_available ?message_envelope)
      )
    :effect
      (and
        (envelope_created ?message_envelope)
        (envelope_publisher_slot ?message_envelope ?publisher_slot)
        (envelope_subscriber_slot ?message_envelope ?subscriber_slot)
        (envelope_has_publisher_transform ?message_envelope)
        (not
          (envelope_available ?message_envelope)
        )
      )
  )
  (:action compose_envelope_with_subscriber_transform
    :parameters (?publisher - publisher ?subscriber - subscriber ?publisher_slot - publisher_slot ?subscriber_slot - subscriber_slot ?message_envelope - message_envelope)
    :precondition
      (and
        (publisher_has_token ?publisher)
        (subscriber_has_token ?subscriber)
        (publisher_slot_binding ?publisher ?publisher_slot)
        (subscriber_slot_binding ?subscriber ?subscriber_slot)
        (publisher_slot_ready ?publisher_slot)
        (subscriber_slot_transformed ?subscriber_slot)
        (publisher_primed ?publisher)
        (not
          (subscriber_primed ?subscriber)
        )
        (envelope_available ?message_envelope)
      )
    :effect
      (and
        (envelope_created ?message_envelope)
        (envelope_publisher_slot ?message_envelope ?publisher_slot)
        (envelope_subscriber_slot ?message_envelope ?subscriber_slot)
        (envelope_has_subscriber_transform ?message_envelope)
        (not
          (envelope_available ?message_envelope)
        )
      )
  )
  (:action compose_envelope_with_both_transforms
    :parameters (?publisher - publisher ?subscriber - subscriber ?publisher_slot - publisher_slot ?subscriber_slot - subscriber_slot ?message_envelope - message_envelope)
    :precondition
      (and
        (publisher_has_token ?publisher)
        (subscriber_has_token ?subscriber)
        (publisher_slot_binding ?publisher ?publisher_slot)
        (subscriber_slot_binding ?subscriber ?subscriber_slot)
        (publisher_slot_transformed ?publisher_slot)
        (subscriber_slot_transformed ?subscriber_slot)
        (not
          (publisher_primed ?publisher)
        )
        (not
          (subscriber_primed ?subscriber)
        )
        (envelope_available ?message_envelope)
      )
    :effect
      (and
        (envelope_created ?message_envelope)
        (envelope_publisher_slot ?message_envelope ?publisher_slot)
        (envelope_subscriber_slot ?message_envelope ?subscriber_slot)
        (envelope_has_publisher_transform ?message_envelope)
        (envelope_has_subscriber_transform ?message_envelope)
        (not
          (envelope_available ?message_envelope)
        )
      )
  )
  (:action mark_envelope_ready_for_dispatch
    :parameters (?message_envelope - message_envelope ?publisher - publisher ?event_type - event_type)
    :precondition
      (and
        (envelope_created ?message_envelope)
        (publisher_has_token ?publisher)
        (service_type_association ?publisher ?event_type)
        (not
          (envelope_ready_for_dispatch ?message_envelope)
        )
      )
    :effect (envelope_ready_for_dispatch ?message_envelope)
  )
  (:action apply_payload_template
    :parameters (?notifier_coordinator - notifier_coordinator ?payload_template - payload_template ?message_envelope - message_envelope)
    :precondition
      (and
        (service_processing_enabled ?notifier_coordinator)
        (coordinator_envelope_assigned ?notifier_coordinator ?message_envelope)
        (coordinator_payload_template_assigned ?notifier_coordinator ?payload_template)
        (payload_template_available ?payload_template)
        (envelope_created ?message_envelope)
        (envelope_ready_for_dispatch ?message_envelope)
        (not
          (payload_template_consumed ?payload_template)
        )
      )
    :effect
      (and
        (payload_template_consumed ?payload_template)
        (payload_template_for_envelope ?payload_template ?message_envelope)
        (not
          (payload_template_available ?payload_template)
        )
      )
  )
  (:action finalize_payload_application
    :parameters (?notifier_coordinator - notifier_coordinator ?payload_template - payload_template ?message_envelope - message_envelope ?event_type - event_type)
    :precondition
      (and
        (service_processing_enabled ?notifier_coordinator)
        (coordinator_payload_template_assigned ?notifier_coordinator ?payload_template)
        (payload_template_consumed ?payload_template)
        (payload_template_for_envelope ?payload_template ?message_envelope)
        (service_type_association ?notifier_coordinator ?event_type)
        (not
          (envelope_has_publisher_transform ?message_envelope)
        )
        (not
          (coordinator_template_applied ?notifier_coordinator)
        )
      )
    :effect (coordinator_template_applied ?notifier_coordinator)
  )
  (:action assign_priority_tag_to_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?priority_tag - priority_tag)
    :precondition
      (and
        (service_processing_enabled ?notifier_coordinator)
        (priority_tag_available ?priority_tag)
        (not
          (coordinator_priority_enabled ?notifier_coordinator)
        )
      )
    :effect
      (and
        (coordinator_priority_enabled ?notifier_coordinator)
        (coordinator_priority_tag ?notifier_coordinator ?priority_tag)
        (not
          (priority_tag_available ?priority_tag)
        )
      )
  )
  (:action enable_priority_and_template_application
    :parameters (?notifier_coordinator - notifier_coordinator ?payload_template - payload_template ?message_envelope - message_envelope ?event_type - event_type ?priority_tag - priority_tag)
    :precondition
      (and
        (service_processing_enabled ?notifier_coordinator)
        (coordinator_payload_template_assigned ?notifier_coordinator ?payload_template)
        (payload_template_consumed ?payload_template)
        (payload_template_for_envelope ?payload_template ?message_envelope)
        (service_type_association ?notifier_coordinator ?event_type)
        (envelope_has_publisher_transform ?message_envelope)
        (coordinator_priority_enabled ?notifier_coordinator)
        (coordinator_priority_tag ?notifier_coordinator ?priority_tag)
        (not
          (coordinator_template_applied ?notifier_coordinator)
        )
      )
    :effect
      (and
        (coordinator_template_applied ?notifier_coordinator)
        (coordinator_priority_applied ?notifier_coordinator)
      )
  )
  (:action engage_capability_for_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?capability_token - capability_token ?delivery_handler - delivery_handler ?payload_template - payload_template ?message_envelope - message_envelope)
    :precondition
      (and
        (coordinator_template_applied ?notifier_coordinator)
        (coordinator_capability_token ?notifier_coordinator ?capability_token)
        (service_handler_assigned ?notifier_coordinator ?delivery_handler)
        (coordinator_payload_template_assigned ?notifier_coordinator ?payload_template)
        (payload_template_for_envelope ?payload_template ?message_envelope)
        (not
          (envelope_has_subscriber_transform ?message_envelope)
        )
        (not
          (coordinator_feature_engaged ?notifier_coordinator)
        )
      )
    :effect (coordinator_feature_engaged ?notifier_coordinator)
  )
  (:action engage_alternate_capability_for_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?capability_token - capability_token ?delivery_handler - delivery_handler ?payload_template - payload_template ?message_envelope - message_envelope)
    :precondition
      (and
        (coordinator_template_applied ?notifier_coordinator)
        (coordinator_capability_token ?notifier_coordinator ?capability_token)
        (service_handler_assigned ?notifier_coordinator ?delivery_handler)
        (coordinator_payload_template_assigned ?notifier_coordinator ?payload_template)
        (payload_template_for_envelope ?payload_template ?message_envelope)
        (envelope_has_subscriber_transform ?message_envelope)
        (not
          (coordinator_feature_engaged ?notifier_coordinator)
        )
      )
    :effect (coordinator_feature_engaged ?notifier_coordinator)
  )
  (:action prepare_coordinator_for_delivery
    :parameters (?notifier_coordinator - notifier_coordinator ?retry_config - retry_config ?payload_template - payload_template ?message_envelope - message_envelope)
    :precondition
      (and
        (coordinator_feature_engaged ?notifier_coordinator)
        (coordinator_retry_config ?notifier_coordinator ?retry_config)
        (coordinator_payload_template_assigned ?notifier_coordinator ?payload_template)
        (payload_template_for_envelope ?payload_template ?message_envelope)
        (not
          (envelope_has_publisher_transform ?message_envelope)
        )
        (not
          (envelope_has_subscriber_transform ?message_envelope)
        )
        (not
          (coordinator_delivery_ready ?notifier_coordinator)
        )
      )
    :effect (coordinator_delivery_ready ?notifier_coordinator)
  )
  (:action prepare_coordinator_with_publisher_feature
    :parameters (?notifier_coordinator - notifier_coordinator ?retry_config - retry_config ?payload_template - payload_template ?message_envelope - message_envelope)
    :precondition
      (and
        (coordinator_feature_engaged ?notifier_coordinator)
        (coordinator_retry_config ?notifier_coordinator ?retry_config)
        (coordinator_payload_template_assigned ?notifier_coordinator ?payload_template)
        (payload_template_for_envelope ?payload_template ?message_envelope)
        (envelope_has_publisher_transform ?message_envelope)
        (not
          (envelope_has_subscriber_transform ?message_envelope)
        )
        (not
          (coordinator_delivery_ready ?notifier_coordinator)
        )
      )
    :effect
      (and
        (coordinator_delivery_ready ?notifier_coordinator)
        (coordinator_feature_enabled ?notifier_coordinator)
      )
  )
  (:action prepare_coordinator_with_subscriber_feature
    :parameters (?notifier_coordinator - notifier_coordinator ?retry_config - retry_config ?payload_template - payload_template ?message_envelope - message_envelope)
    :precondition
      (and
        (coordinator_feature_engaged ?notifier_coordinator)
        (coordinator_retry_config ?notifier_coordinator ?retry_config)
        (coordinator_payload_template_assigned ?notifier_coordinator ?payload_template)
        (payload_template_for_envelope ?payload_template ?message_envelope)
        (not
          (envelope_has_publisher_transform ?message_envelope)
        )
        (envelope_has_subscriber_transform ?message_envelope)
        (not
          (coordinator_delivery_ready ?notifier_coordinator)
        )
      )
    :effect
      (and
        (coordinator_delivery_ready ?notifier_coordinator)
        (coordinator_feature_enabled ?notifier_coordinator)
      )
  )
  (:action prepare_coordinator_with_both_features
    :parameters (?notifier_coordinator - notifier_coordinator ?retry_config - retry_config ?payload_template - payload_template ?message_envelope - message_envelope)
    :precondition
      (and
        (coordinator_feature_engaged ?notifier_coordinator)
        (coordinator_retry_config ?notifier_coordinator ?retry_config)
        (coordinator_payload_template_assigned ?notifier_coordinator ?payload_template)
        (payload_template_for_envelope ?payload_template ?message_envelope)
        (envelope_has_publisher_transform ?message_envelope)
        (envelope_has_subscriber_transform ?message_envelope)
        (not
          (coordinator_delivery_ready ?notifier_coordinator)
        )
      )
    :effect
      (and
        (coordinator_delivery_ready ?notifier_coordinator)
        (coordinator_feature_enabled ?notifier_coordinator)
      )
  )
  (:action record_coordinator_completion
    :parameters (?notifier_coordinator - notifier_coordinator)
    :precondition
      (and
        (coordinator_delivery_ready ?notifier_coordinator)
        (not
          (coordinator_feature_enabled ?notifier_coordinator)
        )
        (not
          (completion_recorded ?notifier_coordinator)
        )
      )
    :effect
      (and
        (completion_recorded ?notifier_coordinator)
        (ready_for_finalization ?notifier_coordinator)
      )
  )
  (:action assign_delivery_policy_to_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?delivery_policy - delivery_policy)
    :precondition
      (and
        (coordinator_delivery_ready ?notifier_coordinator)
        (coordinator_feature_enabled ?notifier_coordinator)
        (delivery_policy_available ?delivery_policy)
      )
    :effect
      (and
        (coordinator_delivery_policy ?notifier_coordinator ?delivery_policy)
        (not
          (delivery_policy_available ?delivery_policy)
        )
      )
  )
  (:action initiate_dispatch_by_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?publisher - publisher ?subscriber - subscriber ?event_type - event_type ?delivery_policy - delivery_policy)
    :precondition
      (and
        (coordinator_delivery_ready ?notifier_coordinator)
        (coordinator_feature_enabled ?notifier_coordinator)
        (coordinator_delivery_policy ?notifier_coordinator ?delivery_policy)
        (coordinator_publisher_binding ?notifier_coordinator ?publisher)
        (coordinator_subscriber_binding ?notifier_coordinator ?subscriber)
        (publisher_primed ?publisher)
        (subscriber_primed ?subscriber)
        (service_type_association ?notifier_coordinator ?event_type)
        (not
          (coordinator_dispatch_committed ?notifier_coordinator)
        )
      )
    :effect (coordinator_dispatch_committed ?notifier_coordinator)
  )
  (:action record_dispatch_completion
    :parameters (?notifier_coordinator - notifier_coordinator)
    :precondition
      (and
        (coordinator_delivery_ready ?notifier_coordinator)
        (coordinator_dispatch_committed ?notifier_coordinator)
        (not
          (completion_recorded ?notifier_coordinator)
        )
      )
    :effect
      (and
        (completion_recorded ?notifier_coordinator)
        (ready_for_finalization ?notifier_coordinator)
      )
  )
  (:action apply_routing_affinity_to_coordinator
    :parameters (?notifier_coordinator - notifier_coordinator ?routing_affinity - routing_affinity ?event_type - event_type)
    :precondition
      (and
        (service_processing_enabled ?notifier_coordinator)
        (service_type_association ?notifier_coordinator ?event_type)
        (routing_affinity_available ?routing_affinity)
        (coordinator_routing_affinity ?notifier_coordinator ?routing_affinity)
        (not
          (coordinator_affinity_applied ?notifier_coordinator)
        )
      )
    :effect
      (and
        (coordinator_affinity_applied ?notifier_coordinator)
        (not
          (routing_affinity_available ?routing_affinity)
        )
      )
  )
  (:action lock_coordinator_affinity
    :parameters (?notifier_coordinator - notifier_coordinator ?delivery_handler - delivery_handler)
    :precondition
      (and
        (coordinator_affinity_applied ?notifier_coordinator)
        (service_handler_assigned ?notifier_coordinator ?delivery_handler)
        (not
          (coordinator_affinity_locked ?notifier_coordinator)
        )
      )
    :effect (coordinator_affinity_locked ?notifier_coordinator)
  )
  (:action confirm_coordinator_affinity
    :parameters (?notifier_coordinator - notifier_coordinator ?retry_config - retry_config)
    :precondition
      (and
        (coordinator_affinity_locked ?notifier_coordinator)
        (coordinator_retry_config ?notifier_coordinator ?retry_config)
        (not
          (coordinator_affinity_confirmed ?notifier_coordinator)
        )
      )
    :effect (coordinator_affinity_confirmed ?notifier_coordinator)
  )
  (:action record_affinity_completion
    :parameters (?notifier_coordinator - notifier_coordinator)
    :precondition
      (and
        (coordinator_affinity_confirmed ?notifier_coordinator)
        (not
          (completion_recorded ?notifier_coordinator)
        )
      )
    :effect
      (and
        (completion_recorded ?notifier_coordinator)
        (ready_for_finalization ?notifier_coordinator)
      )
  )
  (:action finalize_publisher_delivery
    :parameters (?publisher - publisher ?message_envelope - message_envelope)
    :precondition
      (and
        (publisher_has_token ?publisher)
        (publisher_primed ?publisher)
        (envelope_created ?message_envelope)
        (envelope_ready_for_dispatch ?message_envelope)
        (not
          (ready_for_finalization ?publisher)
        )
      )
    :effect (ready_for_finalization ?publisher)
  )
  (:action finalize_subscriber_delivery
    :parameters (?subscriber - subscriber ?message_envelope - message_envelope)
    :precondition
      (and
        (subscriber_has_token ?subscriber)
        (subscriber_primed ?subscriber)
        (envelope_created ?message_envelope)
        (envelope_ready_for_dispatch ?message_envelope)
        (not
          (ready_for_finalization ?subscriber)
        )
      )
    :effect (ready_for_finalization ?subscriber)
  )
  (:action attach_ack_channel_to_event
    :parameters (?event_instance - processing_entity ?ack_channel - ack_channel ?event_type - event_type)
    :precondition
      (and
        (ready_for_finalization ?event_instance)
        (service_type_association ?event_instance ?event_type)
        (ack_channel_available ?ack_channel)
        (not
          (service_acknowledged ?event_instance)
        )
      )
    :effect
      (and
        (service_acknowledged ?event_instance)
        (service_ack_channel ?event_instance ?ack_channel)
        (not
          (ack_channel_available ?ack_channel)
        )
      )
  )
  (:action complete_publisher_delivery
    :parameters (?publisher - publisher ?subscription_record - subscription_record ?ack_channel - ack_channel)
    :precondition
      (and
        (service_acknowledged ?publisher)
        (service_subscription_record ?publisher ?subscription_record)
        (service_ack_channel ?publisher ?ack_channel)
        (not
          (service_completed ?publisher)
        )
      )
    :effect
      (and
        (service_completed ?publisher)
        (subscription_record_available ?subscription_record)
        (ack_channel_available ?ack_channel)
      )
  )
  (:action complete_subscriber_delivery
    :parameters (?subscriber - subscriber ?subscription_record - subscription_record ?ack_channel - ack_channel)
    :precondition
      (and
        (service_acknowledged ?subscriber)
        (service_subscription_record ?subscriber ?subscription_record)
        (service_ack_channel ?subscriber ?ack_channel)
        (not
          (service_completed ?subscriber)
        )
      )
    :effect
      (and
        (service_completed ?subscriber)
        (subscription_record_available ?subscription_record)
        (ack_channel_available ?ack_channel)
      )
  )
  (:action complete_coordinator_delivery
    :parameters (?notifier_coordinator - notifier_coordinator ?subscription_record - subscription_record ?ack_channel - ack_channel)
    :precondition
      (and
        (service_acknowledged ?notifier_coordinator)
        (service_subscription_record ?notifier_coordinator ?subscription_record)
        (service_ack_channel ?notifier_coordinator ?ack_channel)
        (not
          (service_completed ?notifier_coordinator)
        )
      )
    :effect
      (and
        (service_completed ?notifier_coordinator)
        (subscription_record_available ?subscription_record)
        (ack_channel_available ?ack_channel)
      )
  )
)

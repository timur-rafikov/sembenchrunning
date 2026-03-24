(define (domain illness_trip_downscaling_recovery_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_supertype - object auxiliary_option_supertype - object vendor_supertype - object case_supertype - object trip_case - case_supertype support_channel - resource_supertype medical_service - resource_supertype local_support_resource - resource_supertype compensation_offer - resource_supertype post_recovery_task - resource_supertype medical_document - resource_supertype insurance_claim - resource_supertype regulatory_notice - resource_supertype refund_voucher - auxiliary_option_supertype supplier_confirmation - auxiliary_option_supertype third_party_contact - auxiliary_option_supertype accommodation_option - vendor_supertype transport_option - vendor_supertype recovery_package - vendor_supertype trip_segment_subtype - trip_case casefile_subtype - trip_case primary_trip_segment - trip_segment_subtype secondary_trip_segment - trip_segment_subtype case_context - casefile_subtype)
  (:predicates
    (case_reported ?trip_case - trip_case)
    (case_triaged ?trip_case - trip_case)
    (channel_engaged ?trip_case - trip_case)
    (case_resolved ?trip_case - trip_case)
    (recovery_delivered ?trip_case - trip_case)
    (reimbursement_requested ?trip_case - trip_case)
    (support_channel_available ?support_channel - support_channel)
    (case_channel_link ?trip_case - trip_case ?support_channel - support_channel)
    (medical_service_available ?medical_service - medical_service)
    (case_has_medical_booking ?trip_case - trip_case ?medical_service - medical_service)
    (local_support_available ?local_support - local_support_resource)
    (case_local_support_link ?trip_case - trip_case ?local_support - local_support_resource)
    (refund_voucher_available ?refund_voucher - refund_voucher)
    (primary_segment_refund_link ?primary_segment - primary_trip_segment ?refund_voucher - refund_voucher)
    (companion_refund_link ?secondary_segment - secondary_trip_segment ?refund_voucher - refund_voucher)
    (primary_segment_option_link ?primary_segment - primary_trip_segment ?accommodation_option - accommodation_option)
    (accommodation_confirmed ?accommodation_option - accommodation_option)
    (accommodation_alternative_offered ?accommodation_option - accommodation_option)
    (primary_segment_option_finalized ?primary_segment - primary_trip_segment)
    (secondary_option_link ?secondary_segment - secondary_trip_segment ?transport_option - transport_option)
    (transport_confirmed ?transport_option - transport_option)
    (transport_alternative_offered ?transport_option - transport_option)
    (transport_finalized ?secondary_segment - secondary_trip_segment)
    (recovery_package_draft ?recovery_package - recovery_package)
    (recovery_package_selected ?recovery_package - recovery_package)
    (package_has_accommodation ?recovery_package - recovery_package ?accommodation_option - accommodation_option)
    (package_has_transport ?recovery_package - recovery_package ?transport_option - transport_option)
    (package_includes_accommodation ?recovery_package - recovery_package)
    (package_includes_transport ?recovery_package - recovery_package)
    (package_activated ?recovery_package - recovery_package)
    (case_has_primary_segment ?case_context - case_context ?primary_segment - primary_trip_segment)
    (case_has_secondary_segment ?case_context - case_context ?secondary_segment - secondary_trip_segment)
    (case_has_package ?case_context - case_context ?recovery_package - recovery_package)
    (supplier_confirmation_available ?supplier_confirmation - supplier_confirmation)
    (case_has_supplier_confirmation ?case_context - case_context ?supplier_confirmation - supplier_confirmation)
    (supplier_confirmation_consumed ?supplier_confirmation - supplier_confirmation)
    (confirmation_links_to_package ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package)
    (supplier_verified ?case_context - case_context)
    (supplier_committed ?case_context - case_context)
    (recovery_ready_for_implementation ?case_context - case_context)
    (compensation_option_locked ?case_context - case_context)
    (compensation_accepted ?case_context - case_context)
    (approvals_obtained ?case_context - case_context)
    (implementation_started ?case_context - case_context)
    (third_party_offer_available ?third_party_contact - third_party_contact)
    (case_has_third_party_contact ?case_context - case_context ?third_party_contact - third_party_contact)
    (third_party_engaged ?case_context - case_context)
    (third_party_action_confirmed ?case_context - case_context)
    (third_party_action_recorded ?case_context - case_context)
    (compensation_offer_available ?compensation_offer - compensation_offer)
    (case_compensation_link ?case_context - case_context ?compensation_offer - compensation_offer)
    (followup_task_available ?followup_task - post_recovery_task)
    (case_followup_task_assigned ?case_context - case_context ?followup_task - post_recovery_task)
    (insurance_claim_available ?insurance_claim - insurance_claim)
    (case_insurance_claim_link ?case_context - case_context ?insurance_claim - insurance_claim)
    (notification_available ?regulatory_notice - regulatory_notice)
    (case_notification_link ?case_context - case_context ?regulatory_notice - regulatory_notice)
    (document_available ?medical_document - medical_document)
    (case_document_link ?trip_case - trip_case ?medical_document - medical_document)
    (primary_segment_ready ?primary_segment - primary_trip_segment)
    (secondary_segment_ready ?secondary_segment - secondary_trip_segment)
    (closure_record_created ?case_context - case_context)
  )
  (:action open_recovery_case
    :parameters (?trip_case - trip_case)
    :precondition
      (and
        (not
          (case_reported ?trip_case)
        )
        (not
          (case_resolved ?trip_case)
        )
      )
    :effect (case_reported ?trip_case)
  )
  (:action engage_support_channel
    :parameters (?trip_case - trip_case ?support_channel - support_channel)
    :precondition
      (and
        (case_reported ?trip_case)
        (not
          (channel_engaged ?trip_case)
        )
        (support_channel_available ?support_channel)
      )
    :effect
      (and
        (channel_engaged ?trip_case)
        (case_channel_link ?trip_case ?support_channel)
        (not
          (support_channel_available ?support_channel)
        )
      )
  )
  (:action book_medical_service
    :parameters (?trip_case - trip_case ?medical_service - medical_service)
    :precondition
      (and
        (case_reported ?trip_case)
        (channel_engaged ?trip_case)
        (medical_service_available ?medical_service)
      )
    :effect
      (and
        (case_has_medical_booking ?trip_case ?medical_service)
        (not
          (medical_service_available ?medical_service)
        )
      )
  )
  (:action mark_case_triaged
    :parameters (?trip_case - trip_case ?medical_service - medical_service)
    :precondition
      (and
        (case_reported ?trip_case)
        (channel_engaged ?trip_case)
        (case_has_medical_booking ?trip_case ?medical_service)
        (not
          (case_triaged ?trip_case)
        )
      )
    :effect (case_triaged ?trip_case)
  )
  (:action release_medical_booking
    :parameters (?trip_case - trip_case ?medical_service - medical_service)
    :precondition
      (and
        (case_has_medical_booking ?trip_case ?medical_service)
      )
    :effect
      (and
        (medical_service_available ?medical_service)
        (not
          (case_has_medical_booking ?trip_case ?medical_service)
        )
      )
  )
  (:action assign_local_support
    :parameters (?trip_case - trip_case ?local_support - local_support_resource)
    :precondition
      (and
        (case_triaged ?trip_case)
        (local_support_available ?local_support)
      )
    :effect
      (and
        (case_local_support_link ?trip_case ?local_support)
        (not
          (local_support_available ?local_support)
        )
      )
  )
  (:action release_local_support
    :parameters (?trip_case - trip_case ?local_support - local_support_resource)
    :precondition
      (and
        (case_local_support_link ?trip_case ?local_support)
      )
    :effect
      (and
        (local_support_available ?local_support)
        (not
          (case_local_support_link ?trip_case ?local_support)
        )
      )
  )
  (:action attach_insurance_claim
    :parameters (?case_context - case_context ?insurance_claim - insurance_claim)
    :precondition
      (and
        (case_triaged ?case_context)
        (insurance_claim_available ?insurance_claim)
      )
    :effect
      (and
        (case_insurance_claim_link ?case_context ?insurance_claim)
        (not
          (insurance_claim_available ?insurance_claim)
        )
      )
  )
  (:action detach_insurance_claim
    :parameters (?case_context - case_context ?insurance_claim - insurance_claim)
    :precondition
      (and
        (case_insurance_claim_link ?case_context ?insurance_claim)
      )
    :effect
      (and
        (insurance_claim_available ?insurance_claim)
        (not
          (case_insurance_claim_link ?case_context ?insurance_claim)
        )
      )
  )
  (:action attach_regulatory_notification
    :parameters (?case_context - case_context ?regulatory_notice - regulatory_notice)
    :precondition
      (and
        (case_triaged ?case_context)
        (notification_available ?regulatory_notice)
      )
    :effect
      (and
        (case_notification_link ?case_context ?regulatory_notice)
        (not
          (notification_available ?regulatory_notice)
        )
      )
  )
  (:action detach_regulatory_notification
    :parameters (?case_context - case_context ?regulatory_notice - regulatory_notice)
    :precondition
      (and
        (case_notification_link ?case_context ?regulatory_notice)
      )
    :effect
      (and
        (notification_available ?regulatory_notice)
        (not
          (case_notification_link ?case_context ?regulatory_notice)
        )
      )
  )
  (:action confirm_accommodation_for_primary_segment
    :parameters (?primary_segment - primary_trip_segment ?accommodation_option - accommodation_option ?medical_service - medical_service)
    :precondition
      (and
        (case_triaged ?primary_segment)
        (case_has_medical_booking ?primary_segment ?medical_service)
        (primary_segment_option_link ?primary_segment ?accommodation_option)
        (not
          (accommodation_confirmed ?accommodation_option)
        )
        (not
          (accommodation_alternative_offered ?accommodation_option)
        )
      )
    :effect (accommodation_confirmed ?accommodation_option)
  )
  (:action finalize_primary_accommodation
    :parameters (?primary_segment - primary_trip_segment ?accommodation_option - accommodation_option ?local_support - local_support_resource)
    :precondition
      (and
        (case_triaged ?primary_segment)
        (case_local_support_link ?primary_segment ?local_support)
        (primary_segment_option_link ?primary_segment ?accommodation_option)
        (accommodation_confirmed ?accommodation_option)
        (not
          (primary_segment_ready ?primary_segment)
        )
      )
    :effect
      (and
        (primary_segment_ready ?primary_segment)
        (primary_segment_option_finalized ?primary_segment)
      )
  )
  (:action offer_accommodation_alternative_with_refund
    :parameters (?primary_segment - primary_trip_segment ?accommodation_option - accommodation_option ?refund_voucher - refund_voucher)
    :precondition
      (and
        (case_triaged ?primary_segment)
        (primary_segment_option_link ?primary_segment ?accommodation_option)
        (refund_voucher_available ?refund_voucher)
        (not
          (primary_segment_ready ?primary_segment)
        )
      )
    :effect
      (and
        (accommodation_alternative_offered ?accommodation_option)
        (primary_segment_ready ?primary_segment)
        (primary_segment_refund_link ?primary_segment ?refund_voucher)
        (not
          (refund_voucher_available ?refund_voucher)
        )
      )
  )
  (:action confirm_alternative_accommodation
    :parameters (?primary_segment - primary_trip_segment ?accommodation_option - accommodation_option ?medical_service - medical_service ?refund_voucher - refund_voucher)
    :precondition
      (and
        (case_triaged ?primary_segment)
        (case_has_medical_booking ?primary_segment ?medical_service)
        (primary_segment_option_link ?primary_segment ?accommodation_option)
        (accommodation_alternative_offered ?accommodation_option)
        (primary_segment_refund_link ?primary_segment ?refund_voucher)
        (not
          (primary_segment_option_finalized ?primary_segment)
        )
      )
    :effect
      (and
        (accommodation_confirmed ?accommodation_option)
        (primary_segment_option_finalized ?primary_segment)
        (refund_voucher_available ?refund_voucher)
        (not
          (primary_segment_refund_link ?primary_segment ?refund_voucher)
        )
      )
  )
  (:action confirm_transport_for_secondary_segment
    :parameters (?secondary_segment - secondary_trip_segment ?transport_option - transport_option ?medical_service - medical_service)
    :precondition
      (and
        (case_triaged ?secondary_segment)
        (case_has_medical_booking ?secondary_segment ?medical_service)
        (secondary_option_link ?secondary_segment ?transport_option)
        (not
          (transport_confirmed ?transport_option)
        )
        (not
          (transport_alternative_offered ?transport_option)
        )
      )
    :effect (transport_confirmed ?transport_option)
  )
  (:action finalize_secondary_transport
    :parameters (?secondary_segment - secondary_trip_segment ?transport_option - transport_option ?local_support - local_support_resource)
    :precondition
      (and
        (case_triaged ?secondary_segment)
        (case_local_support_link ?secondary_segment ?local_support)
        (secondary_option_link ?secondary_segment ?transport_option)
        (transport_confirmed ?transport_option)
        (not
          (secondary_segment_ready ?secondary_segment)
        )
      )
    :effect
      (and
        (secondary_segment_ready ?secondary_segment)
        (transport_finalized ?secondary_segment)
      )
  )
  (:action offer_transport_alternative_with_refund
    :parameters (?secondary_segment - secondary_trip_segment ?transport_option - transport_option ?refund_voucher - refund_voucher)
    :precondition
      (and
        (case_triaged ?secondary_segment)
        (secondary_option_link ?secondary_segment ?transport_option)
        (refund_voucher_available ?refund_voucher)
        (not
          (secondary_segment_ready ?secondary_segment)
        )
      )
    :effect
      (and
        (transport_alternative_offered ?transport_option)
        (secondary_segment_ready ?secondary_segment)
        (companion_refund_link ?secondary_segment ?refund_voucher)
        (not
          (refund_voucher_available ?refund_voucher)
        )
      )
  )
  (:action confirm_alternative_transport
    :parameters (?secondary_segment - secondary_trip_segment ?transport_option - transport_option ?medical_service - medical_service ?refund_voucher - refund_voucher)
    :precondition
      (and
        (case_triaged ?secondary_segment)
        (case_has_medical_booking ?secondary_segment ?medical_service)
        (secondary_option_link ?secondary_segment ?transport_option)
        (transport_alternative_offered ?transport_option)
        (companion_refund_link ?secondary_segment ?refund_voucher)
        (not
          (transport_finalized ?secondary_segment)
        )
      )
    :effect
      (and
        (transport_confirmed ?transport_option)
        (transport_finalized ?secondary_segment)
        (refund_voucher_available ?refund_voucher)
        (not
          (companion_refund_link ?secondary_segment ?refund_voucher)
        )
      )
  )
  (:action select_recovery_package_candidate
    :parameters (?primary_segment - primary_trip_segment ?secondary_segment - secondary_trip_segment ?accommodation_option - accommodation_option ?transport_option - transport_option ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_segment_ready ?primary_segment)
        (secondary_segment_ready ?secondary_segment)
        (primary_segment_option_link ?primary_segment ?accommodation_option)
        (secondary_option_link ?secondary_segment ?transport_option)
        (accommodation_confirmed ?accommodation_option)
        (transport_confirmed ?transport_option)
        (primary_segment_option_finalized ?primary_segment)
        (transport_finalized ?secondary_segment)
        (recovery_package_draft ?recovery_package)
      )
    :effect
      (and
        (recovery_package_selected ?recovery_package)
        (package_has_accommodation ?recovery_package ?accommodation_option)
        (package_has_transport ?recovery_package ?transport_option)
        (not
          (recovery_package_draft ?recovery_package)
        )
      )
  )
  (:action select_recovery_package_with_accommodation
    :parameters (?primary_segment - primary_trip_segment ?secondary_segment - secondary_trip_segment ?accommodation_option - accommodation_option ?transport_option - transport_option ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_segment_ready ?primary_segment)
        (secondary_segment_ready ?secondary_segment)
        (primary_segment_option_link ?primary_segment ?accommodation_option)
        (secondary_option_link ?secondary_segment ?transport_option)
        (accommodation_alternative_offered ?accommodation_option)
        (transport_confirmed ?transport_option)
        (not
          (primary_segment_option_finalized ?primary_segment)
        )
        (transport_finalized ?secondary_segment)
        (recovery_package_draft ?recovery_package)
      )
    :effect
      (and
        (recovery_package_selected ?recovery_package)
        (package_has_accommodation ?recovery_package ?accommodation_option)
        (package_has_transport ?recovery_package ?transport_option)
        (package_includes_accommodation ?recovery_package)
        (not
          (recovery_package_draft ?recovery_package)
        )
      )
  )
  (:action select_recovery_package_with_transport
    :parameters (?primary_segment - primary_trip_segment ?secondary_segment - secondary_trip_segment ?accommodation_option - accommodation_option ?transport_option - transport_option ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_segment_ready ?primary_segment)
        (secondary_segment_ready ?secondary_segment)
        (primary_segment_option_link ?primary_segment ?accommodation_option)
        (secondary_option_link ?secondary_segment ?transport_option)
        (accommodation_confirmed ?accommodation_option)
        (transport_alternative_offered ?transport_option)
        (primary_segment_option_finalized ?primary_segment)
        (not
          (transport_finalized ?secondary_segment)
        )
        (recovery_package_draft ?recovery_package)
      )
    :effect
      (and
        (recovery_package_selected ?recovery_package)
        (package_has_accommodation ?recovery_package ?accommodation_option)
        (package_has_transport ?recovery_package ?transport_option)
        (package_includes_transport ?recovery_package)
        (not
          (recovery_package_draft ?recovery_package)
        )
      )
  )
  (:action select_recovery_package_with_accommodation_and_transport
    :parameters (?primary_segment - primary_trip_segment ?secondary_segment - secondary_trip_segment ?accommodation_option - accommodation_option ?transport_option - transport_option ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_segment_ready ?primary_segment)
        (secondary_segment_ready ?secondary_segment)
        (primary_segment_option_link ?primary_segment ?accommodation_option)
        (secondary_option_link ?secondary_segment ?transport_option)
        (accommodation_alternative_offered ?accommodation_option)
        (transport_alternative_offered ?transport_option)
        (not
          (primary_segment_option_finalized ?primary_segment)
        )
        (not
          (transport_finalized ?secondary_segment)
        )
        (recovery_package_draft ?recovery_package)
      )
    :effect
      (and
        (recovery_package_selected ?recovery_package)
        (package_has_accommodation ?recovery_package ?accommodation_option)
        (package_has_transport ?recovery_package ?transport_option)
        (package_includes_accommodation ?recovery_package)
        (package_includes_transport ?recovery_package)
        (not
          (recovery_package_draft ?recovery_package)
        )
      )
  )
  (:action activate_recovery_package
    :parameters (?recovery_package - recovery_package ?primary_segment - primary_trip_segment ?medical_service - medical_service)
    :precondition
      (and
        (recovery_package_selected ?recovery_package)
        (primary_segment_ready ?primary_segment)
        (case_has_medical_booking ?primary_segment ?medical_service)
        (not
          (package_activated ?recovery_package)
        )
      )
    :effect (package_activated ?recovery_package)
  )
  (:action consume_supplier_confirmation
    :parameters (?case_context - case_context ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package)
    :precondition
      (and
        (case_triaged ?case_context)
        (case_has_package ?case_context ?recovery_package)
        (case_has_supplier_confirmation ?case_context ?supplier_confirmation)
        (supplier_confirmation_available ?supplier_confirmation)
        (recovery_package_selected ?recovery_package)
        (package_activated ?recovery_package)
        (not
          (supplier_confirmation_consumed ?supplier_confirmation)
        )
      )
    :effect
      (and
        (supplier_confirmation_consumed ?supplier_confirmation)
        (confirmation_links_to_package ?supplier_confirmation ?recovery_package)
        (not
          (supplier_confirmation_available ?supplier_confirmation)
        )
      )
  )
  (:action verify_supplier_commitment
    :parameters (?case_context - case_context ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package ?medical_service - medical_service)
    :precondition
      (and
        (case_triaged ?case_context)
        (case_has_supplier_confirmation ?case_context ?supplier_confirmation)
        (supplier_confirmation_consumed ?supplier_confirmation)
        (confirmation_links_to_package ?supplier_confirmation ?recovery_package)
        (case_has_medical_booking ?case_context ?medical_service)
        (not
          (package_includes_accommodation ?recovery_package)
        )
        (not
          (supplier_verified ?case_context)
        )
      )
    :effect (supplier_verified ?case_context)
  )
  (:action lock_compensation_offer
    :parameters (?case_context - case_context ?compensation_offer - compensation_offer)
    :precondition
      (and
        (case_triaged ?case_context)
        (compensation_offer_available ?compensation_offer)
        (not
          (compensation_option_locked ?case_context)
        )
      )
    :effect
      (and
        (compensation_option_locked ?case_context)
        (case_compensation_link ?case_context ?compensation_offer)
        (not
          (compensation_offer_available ?compensation_offer)
        )
      )
  )
  (:action accept_compensation_offer
    :parameters (?case_context - case_context ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package ?medical_service - medical_service ?compensation_offer - compensation_offer)
    :precondition
      (and
        (case_triaged ?case_context)
        (case_has_supplier_confirmation ?case_context ?supplier_confirmation)
        (supplier_confirmation_consumed ?supplier_confirmation)
        (confirmation_links_to_package ?supplier_confirmation ?recovery_package)
        (case_has_medical_booking ?case_context ?medical_service)
        (package_includes_accommodation ?recovery_package)
        (compensation_option_locked ?case_context)
        (case_compensation_link ?case_context ?compensation_offer)
        (not
          (supplier_verified ?case_context)
        )
      )
    :effect
      (and
        (supplier_verified ?case_context)
        (compensation_accepted ?case_context)
      )
  )
  (:action obtain_supplier_commitment
    :parameters (?case_context - case_context ?insurance_claim - insurance_claim ?local_support - local_support_resource ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package)
    :precondition
      (and
        (supplier_verified ?case_context)
        (case_insurance_claim_link ?case_context ?insurance_claim)
        (case_local_support_link ?case_context ?local_support)
        (case_has_supplier_confirmation ?case_context ?supplier_confirmation)
        (confirmation_links_to_package ?supplier_confirmation ?recovery_package)
        (not
          (package_includes_transport ?recovery_package)
        )
        (not
          (supplier_committed ?case_context)
        )
      )
    :effect (supplier_committed ?case_context)
  )
  (:action confirm_supplier_commitment
    :parameters (?case_context - case_context ?insurance_claim - insurance_claim ?local_support - local_support_resource ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package)
    :precondition
      (and
        (supplier_verified ?case_context)
        (case_insurance_claim_link ?case_context ?insurance_claim)
        (case_local_support_link ?case_context ?local_support)
        (case_has_supplier_confirmation ?case_context ?supplier_confirmation)
        (confirmation_links_to_package ?supplier_confirmation ?recovery_package)
        (package_includes_transport ?recovery_package)
        (not
          (supplier_committed ?case_context)
        )
      )
    :effect (supplier_committed ?case_context)
  )
  (:action prepare_recovery_for_implementation
    :parameters (?case_context - case_context ?regulatory_notice - regulatory_notice ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package)
    :precondition
      (and
        (supplier_committed ?case_context)
        (case_notification_link ?case_context ?regulatory_notice)
        (case_has_supplier_confirmation ?case_context ?supplier_confirmation)
        (confirmation_links_to_package ?supplier_confirmation ?recovery_package)
        (not
          (package_includes_accommodation ?recovery_package)
        )
        (not
          (package_includes_transport ?recovery_package)
        )
        (not
          (recovery_ready_for_implementation ?case_context)
        )
      )
    :effect (recovery_ready_for_implementation ?case_context)
  )
  (:action approve_recovery_with_accommodation_flag
    :parameters (?case_context - case_context ?regulatory_notice - regulatory_notice ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package)
    :precondition
      (and
        (supplier_committed ?case_context)
        (case_notification_link ?case_context ?regulatory_notice)
        (case_has_supplier_confirmation ?case_context ?supplier_confirmation)
        (confirmation_links_to_package ?supplier_confirmation ?recovery_package)
        (package_includes_accommodation ?recovery_package)
        (not
          (package_includes_transport ?recovery_package)
        )
        (not
          (recovery_ready_for_implementation ?case_context)
        )
      )
    :effect
      (and
        (recovery_ready_for_implementation ?case_context)
        (approvals_obtained ?case_context)
      )
  )
  (:action approve_recovery_with_transport_flag
    :parameters (?case_context - case_context ?regulatory_notice - regulatory_notice ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package)
    :precondition
      (and
        (supplier_committed ?case_context)
        (case_notification_link ?case_context ?regulatory_notice)
        (case_has_supplier_confirmation ?case_context ?supplier_confirmation)
        (confirmation_links_to_package ?supplier_confirmation ?recovery_package)
        (not
          (package_includes_accommodation ?recovery_package)
        )
        (package_includes_transport ?recovery_package)
        (not
          (recovery_ready_for_implementation ?case_context)
        )
      )
    :effect
      (and
        (recovery_ready_for_implementation ?case_context)
        (approvals_obtained ?case_context)
      )
  )
  (:action approve_recovery_with_accommodation_and_transport_flags
    :parameters (?case_context - case_context ?regulatory_notice - regulatory_notice ?supplier_confirmation - supplier_confirmation ?recovery_package - recovery_package)
    :precondition
      (and
        (supplier_committed ?case_context)
        (case_notification_link ?case_context ?regulatory_notice)
        (case_has_supplier_confirmation ?case_context ?supplier_confirmation)
        (confirmation_links_to_package ?supplier_confirmation ?recovery_package)
        (package_includes_accommodation ?recovery_package)
        (package_includes_transport ?recovery_package)
        (not
          (recovery_ready_for_implementation ?case_context)
        )
      )
    :effect
      (and
        (recovery_ready_for_implementation ?case_context)
        (approvals_obtained ?case_context)
      )
  )
  (:action record_recovery_delivery_and_create_closure
    :parameters (?case_context - case_context)
    :precondition
      (and
        (recovery_ready_for_implementation ?case_context)
        (not
          (approvals_obtained ?case_context)
        )
        (not
          (closure_record_created ?case_context)
        )
      )
    :effect
      (and
        (closure_record_created ?case_context)
        (recovery_delivered ?case_context)
      )
  )
  (:action assign_followup_task_to_case
    :parameters (?case_context - case_context ?followup_task - post_recovery_task)
    :precondition
      (and
        (recovery_ready_for_implementation ?case_context)
        (approvals_obtained ?case_context)
        (followup_task_available ?followup_task)
      )
    :effect
      (and
        (case_followup_task_assigned ?case_context ?followup_task)
        (not
          (followup_task_available ?followup_task)
        )
      )
  )
  (:action start_recovery_implementation
    :parameters (?case_context - case_context ?primary_segment - primary_trip_segment ?secondary_segment - secondary_trip_segment ?medical_service - medical_service ?followup_task - post_recovery_task)
    :precondition
      (and
        (recovery_ready_for_implementation ?case_context)
        (approvals_obtained ?case_context)
        (case_followup_task_assigned ?case_context ?followup_task)
        (case_has_primary_segment ?case_context ?primary_segment)
        (case_has_secondary_segment ?case_context ?secondary_segment)
        (primary_segment_option_finalized ?primary_segment)
        (transport_finalized ?secondary_segment)
        (case_has_medical_booking ?case_context ?medical_service)
        (not
          (implementation_started ?case_context)
        )
      )
    :effect (implementation_started ?case_context)
  )
  (:action finalize_recovery_and_create_closure
    :parameters (?case_context - case_context)
    :precondition
      (and
        (recovery_ready_for_implementation ?case_context)
        (implementation_started ?case_context)
        (not
          (closure_record_created ?case_context)
        )
      )
    :effect
      (and
        (closure_record_created ?case_context)
        (recovery_delivered ?case_context)
      )
  )
  (:action engage_third_party_contact
    :parameters (?case_context - case_context ?third_party_contact - third_party_contact ?medical_service - medical_service)
    :precondition
      (and
        (case_triaged ?case_context)
        (case_has_medical_booking ?case_context ?medical_service)
        (third_party_offer_available ?third_party_contact)
        (case_has_third_party_contact ?case_context ?third_party_contact)
        (not
          (third_party_engaged ?case_context)
        )
      )
    :effect
      (and
        (third_party_engaged ?case_context)
        (not
          (third_party_offer_available ?third_party_contact)
        )
      )
  )
  (:action confirm_third_party_action
    :parameters (?case_context - case_context ?local_support - local_support_resource)
    :precondition
      (and
        (third_party_engaged ?case_context)
        (case_local_support_link ?case_context ?local_support)
        (not
          (third_party_action_confirmed ?case_context)
        )
      )
    :effect (third_party_action_confirmed ?case_context)
  )
  (:action record_third_party_action
    :parameters (?case_context - case_context ?regulatory_notice - regulatory_notice)
    :precondition
      (and
        (third_party_action_confirmed ?case_context)
        (case_notification_link ?case_context ?regulatory_notice)
        (not
          (third_party_action_recorded ?case_context)
        )
      )
    :effect (third_party_action_recorded ?case_context)
  )
  (:action finalize_third_party_action_and_create_closure
    :parameters (?case_context - case_context)
    :precondition
      (and
        (third_party_action_recorded ?case_context)
        (not
          (closure_record_created ?case_context)
        )
      )
    :effect
      (and
        (closure_record_created ?case_context)
        (recovery_delivered ?case_context)
      )
  )
  (:action deliver_recovery_to_primary_segment
    :parameters (?primary_segment - primary_trip_segment ?recovery_package - recovery_package)
    :precondition
      (and
        (primary_segment_ready ?primary_segment)
        (primary_segment_option_finalized ?primary_segment)
        (recovery_package_selected ?recovery_package)
        (package_activated ?recovery_package)
        (not
          (recovery_delivered ?primary_segment)
        )
      )
    :effect (recovery_delivered ?primary_segment)
  )
  (:action deliver_recovery_to_secondary_segment
    :parameters (?secondary_segment - secondary_trip_segment ?recovery_package - recovery_package)
    :precondition
      (and
        (secondary_segment_ready ?secondary_segment)
        (transport_finalized ?secondary_segment)
        (recovery_package_selected ?recovery_package)
        (package_activated ?recovery_package)
        (not
          (recovery_delivered ?secondary_segment)
        )
      )
    :effect (recovery_delivered ?secondary_segment)
  )
  (:action request_reimbursement_and_attach_medical_document
    :parameters (?trip_case - trip_case ?medical_document - medical_document ?medical_service - medical_service)
    :precondition
      (and
        (recovery_delivered ?trip_case)
        (case_has_medical_booking ?trip_case ?medical_service)
        (document_available ?medical_document)
        (not
          (reimbursement_requested ?trip_case)
        )
      )
    :effect
      (and
        (reimbursement_requested ?trip_case)
        (case_document_link ?trip_case ?medical_document)
        (not
          (document_available ?medical_document)
        )
      )
  )
  (:action close_case_and_release_support_channel_primary
    :parameters (?primary_segment - primary_trip_segment ?support_channel - support_channel ?medical_document - medical_document)
    :precondition
      (and
        (reimbursement_requested ?primary_segment)
        (case_channel_link ?primary_segment ?support_channel)
        (case_document_link ?primary_segment ?medical_document)
        (not
          (case_resolved ?primary_segment)
        )
      )
    :effect
      (and
        (case_resolved ?primary_segment)
        (support_channel_available ?support_channel)
        (document_available ?medical_document)
      )
  )
  (:action close_case_and_release_support_channel_secondary
    :parameters (?secondary_segment - secondary_trip_segment ?support_channel - support_channel ?medical_document - medical_document)
    :precondition
      (and
        (reimbursement_requested ?secondary_segment)
        (case_channel_link ?secondary_segment ?support_channel)
        (case_document_link ?secondary_segment ?medical_document)
        (not
          (case_resolved ?secondary_segment)
        )
      )
    :effect
      (and
        (case_resolved ?secondary_segment)
        (support_channel_available ?support_channel)
        (document_available ?medical_document)
      )
  )
  (:action close_case_and_release_support_channel_context
    :parameters (?case_context - case_context ?support_channel - support_channel ?medical_document - medical_document)
    :precondition
      (and
        (reimbursement_requested ?case_context)
        (case_channel_link ?case_context ?support_channel)
        (case_document_link ?case_context ?medical_document)
        (not
          (case_resolved ?case_context)
        )
      )
    :effect
      (and
        (case_resolved ?case_context)
        (support_channel_available ?support_channel)
        (document_available ?medical_document)
      )
  )
)

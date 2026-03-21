(define (domain medical_device_maintenance_slotting_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types medical_device_asset - physical_object maintenance_timeslot - physical_object maintenance_procedure - physical_object staging_area - physical_object consumable_kit - physical_object auxiliary_device - physical_object service_station - physical_object external_contractor_token - physical_object regulatory_document - physical_object certification_record - physical_object spare_component_record - physical_object service_report - physical_object asset_attribute - physical_object device_class - asset_attribute vendor_configuration - asset_attribute portable_device - medical_device_asset fixed_device - medical_device_asset)
  (:predicates
    (contractor_available ?external_contractor_token - external_contractor_token)
    (device_assigned_staging_area ?medical_device_asset - medical_device_asset ?staging_area - staging_area)
    (device_finalization_ready ?medical_device_asset - medical_device_asset)
    (device_allocated_timeslot ?medical_device_asset - medical_device_asset ?maintenance_timeslot - maintenance_timeslot)
    (device_has_attribute ?medical_device_asset - medical_device_asset ?asset_attribute - asset_attribute)
    (aux_device_available ?auxiliary_device - auxiliary_device)
    (staging_area_available ?staging_area - staging_area)
    (device_service_report_compatible ?medical_device_asset - medical_device_asset ?service_report - service_report)
    (device_case_closed ?medical_device_asset - medical_device_asset)
    (device_portable_device_checklist_required ?medical_device_asset - medical_device_asset)
    (device_timeslot_compatible ?medical_device_asset - medical_device_asset ?maintenance_timeslot - maintenance_timeslot)
    (procedure_available ?maintenance_procedure - maintenance_procedure)
    (spare_component_available ?spare_component_record - spare_component_record)
    (service_station_available ?service_station - service_station)
    (device_procedure_started ?medical_device_asset - medical_device_asset)
    (device_staging_compatible ?medical_device_asset - medical_device_asset ?staging_area - staging_area)
    (device_linked_service_report ?medical_device_asset - medical_device_asset ?service_report - service_report)
    (device_selected_procedure ?medical_device_asset - medical_device_asset ?maintenance_procedure - maintenance_procedure)
    (device_verification_complete ?medical_device_asset - medical_device_asset)
    (device_auxiliary_compatible ?medical_device_asset - medical_device_asset ?auxiliary_device - auxiliary_device)
    (service_report_available ?service_report - service_report)
    (device_fixed_device_checklist_required ?medical_device_asset - medical_device_asset)
    (device_preparation_complete ?medical_device_asset - medical_device_asset)
    (device_kit_compatible ?medical_device_asset - medical_device_asset ?consumable_kit - consumable_kit)
    (device_reserved_kit ?medical_device_asset - medical_device_asset ?consumable_kit - consumable_kit)
    (device_requires_additional_inspection ?medical_device_asset - medical_device_asset)
    (device_reserved_service_station ?medical_device_asset - medical_device_asset ?service_station - service_station)
    (device_post_execution_inspection ?medical_device_asset - medical_device_asset)
    (device_spare_component_compatible ?medical_device_asset - medical_device_asset ?spare_component_record - spare_component_record)
    (device_maintenance_case_open ?medical_device_asset - medical_device_asset)
    (timeslot_available ?maintenance_timeslot - maintenance_timeslot)
    (device_has_timeslot ?medical_device_asset - medical_device_asset)
    (certification_present ?certification_record - certification_record)
    (regulatory_document_available ?regulatory_document - regulatory_document)
    (device_assigned_auxiliary ?medical_device_asset - medical_device_asset ?auxiliary_device - auxiliary_device)
    (device_regulatory_document_linked ?medical_device_asset - medical_device_asset ?regulatory_document - regulatory_document)
    (device_station_ready ?medical_device_asset - medical_device_asset)
    (device_service_authorized ?medical_device_asset - medical_device_asset)
    (device_regulatory_document_candidate ?medical_device_asset - medical_device_asset ?regulatory_document - regulatory_document)
    (kit_available ?consumable_kit - consumable_kit)
    (device_regulatory_document_applicable ?medical_device_asset - medical_device_asset ?regulatory_document - regulatory_document)
    (device_procedure_compatible ?medical_device_asset - medical_device_asset ?maintenance_procedure - maintenance_procedure)
    (device_regulatory_hold ?medical_device_asset - medical_device_asset)
    (regulatory_document_bound_to_device ?medical_device_asset - medical_device_asset ?regulatory_document - regulatory_document)
  )
  (:action release_service_report
    :parameters (?medical_device_asset - medical_device_asset ?service_report - service_report)
    :precondition
      (and
        (device_linked_service_report ?medical_device_asset ?service_report)
      )
    :effect
      (and
        (service_report_available ?service_report)
        (not
          (device_linked_service_report ?medical_device_asset ?service_report)
        )
      )
  )
  (:action bind_regulatory_and_service_documentation
    :parameters (?medical_device_asset - medical_device_asset ?auxiliary_device - auxiliary_device ?service_report - service_report ?vendor_configuration - vendor_configuration)
    :precondition
      (and
        (not
          (device_verification_complete ?medical_device_asset)
        )
        (device_procedure_started ?medical_device_asset)
        (device_preparation_complete ?medical_device_asset)
        (device_linked_service_report ?medical_device_asset ?service_report)
        (device_has_attribute ?medical_device_asset ?vendor_configuration)
        (device_assigned_auxiliary ?medical_device_asset ?auxiliary_device)
      )
    :effect
      (and
        (device_regulatory_hold ?medical_device_asset)
        (device_verification_complete ?medical_device_asset)
      )
  )
  (:action close_case_portable_checklist
    :parameters (?medical_device_asset - medical_device_asset)
    :precondition
      (and
        (device_preparation_complete ?medical_device_asset)
        (device_has_timeslot ?medical_device_asset)
        (device_procedure_started ?medical_device_asset)
        (device_maintenance_case_open ?medical_device_asset)
        (device_service_authorized ?medical_device_asset)
        (not
          (device_case_closed ?medical_device_asset)
        )
        (device_portable_device_checklist_required ?medical_device_asset)
        (device_verification_complete ?medical_device_asset)
      )
    :effect
      (and
        (device_case_closed ?medical_device_asset)
      )
  )
  (:action complete_procedure_validation
    :parameters (?medical_device_asset - medical_device_asset ?consumable_kit - consumable_kit ?staging_area - staging_area)
    :precondition
      (and
        (device_procedure_started ?medical_device_asset)
        (device_requires_additional_inspection ?medical_device_asset)
        (device_reserved_kit ?medical_device_asset ?consumable_kit)
        (device_assigned_staging_area ?medical_device_asset ?staging_area)
      )
    :effect
      (and
        (not
          (device_requires_additional_inspection ?medical_device_asset)
        )
        (not
          (device_regulatory_hold ?medical_device_asset)
        )
      )
  )
  (:action reserve_service_station
    :parameters (?medical_device_asset - medical_device_asset ?service_station - service_station)
    :precondition
      (and
        (service_station_available ?service_station)
        (device_maintenance_case_open ?medical_device_asset)
      )
    :effect
      (and
        (not
          (service_station_available ?service_station)
        )
        (device_reserved_service_station ?medical_device_asset ?service_station)
      )
  )
  (:action perform_compliance_verification
    :parameters (?medical_device_asset - medical_device_asset ?consumable_kit - consumable_kit ?staging_area - staging_area ?device_class - device_class)
    :precondition
      (and
        (device_has_attribute ?medical_device_asset ?device_class)
        (device_preparation_complete ?medical_device_asset)
        (not
          (device_regulatory_hold ?medical_device_asset)
        )
        (device_reserved_kit ?medical_device_asset ?consumable_kit)
        (device_procedure_started ?medical_device_asset)
        (device_assigned_staging_area ?medical_device_asset ?staging_area)
        (not
          (device_verification_complete ?medical_device_asset)
        )
      )
    :effect
      (and
        (device_verification_complete ?medical_device_asset)
      )
  )
  (:action apply_regulatory_document_verification
    :parameters (?medical_device_asset - medical_device_asset ?regulatory_document - regulatory_document)
    :precondition
      (and
        (device_has_timeslot ?medical_device_asset)
        (regulatory_document_bound_to_device ?medical_device_asset ?regulatory_document)
        (not
          (device_preparation_complete ?medical_device_asset)
        )
      )
    :effect
      (and
        (device_preparation_complete ?medical_device_asset)
        (not
          (device_regulatory_hold ?medical_device_asset)
        )
      )
  )
  (:action reserve_auxiliary_device
    :parameters (?medical_device_asset - medical_device_asset ?auxiliary_device - auxiliary_device)
    :precondition
      (and
        (device_auxiliary_compatible ?medical_device_asset ?auxiliary_device)
        (device_maintenance_case_open ?medical_device_asset)
        (aux_device_available ?auxiliary_device)
      )
    :effect
      (and
        (device_assigned_auxiliary ?medical_device_asset ?auxiliary_device)
        (not
          (aux_device_available ?auxiliary_device)
        )
      )
  )
  (:action reserve_consumable_kit
    :parameters (?medical_device_asset - medical_device_asset ?consumable_kit - consumable_kit)
    :precondition
      (and
        (device_maintenance_case_open ?medical_device_asset)
        (kit_available ?consumable_kit)
        (device_kit_compatible ?medical_device_asset ?consumable_kit)
      )
    :effect
      (and
        (not
          (kit_available ?consumable_kit)
        )
        (device_reserved_kit ?medical_device_asset ?consumable_kit)
      )
  )
  (:action release_auxiliary_device
    :parameters (?medical_device_asset - medical_device_asset ?auxiliary_device - auxiliary_device)
    :precondition
      (and
        (device_assigned_auxiliary ?medical_device_asset ?auxiliary_device)
      )
    :effect
      (and
        (aux_device_available ?auxiliary_device)
        (not
          (device_assigned_auxiliary ?medical_device_asset ?auxiliary_device)
        )
      )
  )
  (:action release_staging_area
    :parameters (?medical_device_asset - medical_device_asset ?staging_area - staging_area)
    :precondition
      (and
        (device_assigned_staging_area ?medical_device_asset ?staging_area)
      )
    :effect
      (and
        (staging_area_available ?staging_area)
        (not
          (device_assigned_staging_area ?medical_device_asset ?staging_area)
        )
      )
  )
  (:action attach_regulatory_document_to_device
    :parameters (?medical_device_asset - medical_device_asset ?regulatory_document - regulatory_document)
    :precondition
      (and
        (device_service_authorized ?medical_device_asset)
        (regulatory_document_available ?regulatory_document)
        (device_regulatory_document_candidate ?medical_device_asset ?regulatory_document)
      )
    :effect
      (and
        (device_regulatory_document_linked ?medical_device_asset ?regulatory_document)
        (not
          (regulatory_document_available ?regulatory_document)
        )
      )
  )
  (:action reserve_staging_area
    :parameters (?medical_device_asset - medical_device_asset ?staging_area - staging_area)
    :precondition
      (and
        (device_maintenance_case_open ?medical_device_asset)
        (staging_area_available ?staging_area)
        (device_staging_compatible ?medical_device_asset ?staging_area)
      )
    :effect
      (and
        (device_assigned_staging_area ?medical_device_asset ?staging_area)
        (not
          (staging_area_available ?staging_area)
        )
      )
  )
  (:action initiate_procedure_execution
    :parameters (?medical_device_asset - medical_device_asset ?maintenance_procedure - maintenance_procedure ?consumable_kit - consumable_kit ?staging_area - staging_area)
    :precondition
      (and
        (device_has_timeslot ?medical_device_asset)
        (procedure_available ?maintenance_procedure)
        (device_procedure_compatible ?medical_device_asset ?maintenance_procedure)
        (not
          (device_procedure_started ?medical_device_asset)
        )
        (device_assigned_staging_area ?medical_device_asset ?staging_area)
        (device_reserved_kit ?medical_device_asset ?consumable_kit)
      )
    :effect
      (and
        (device_selected_procedure ?medical_device_asset ?maintenance_procedure)
        (not
          (procedure_available ?maintenance_procedure)
        )
        (device_procedure_started ?medical_device_asset)
      )
  )
  (:action mark_ready_for_finalization
    :parameters (?medical_device_asset - medical_device_asset ?consumable_kit - consumable_kit ?staging_area - staging_area)
    :precondition
      (and
        (device_reserved_kit ?medical_device_asset ?consumable_kit)
        (device_verification_complete ?medical_device_asset)
        (device_assigned_staging_area ?medical_device_asset ?staging_area)
        (device_regulatory_hold ?medical_device_asset)
      )
    :effect
      (and
        (not
          (device_requires_additional_inspection ?medical_device_asset)
        )
        (not
          (device_regulatory_hold ?medical_device_asset)
        )
        (not
          (device_preparation_complete ?medical_device_asset)
        )
        (device_finalization_ready ?medical_device_asset)
      )
  )
  (:action release_service_station_reservation
    :parameters (?medical_device_asset - medical_device_asset ?service_station - service_station)
    :precondition
      (and
        (device_reserved_service_station ?medical_device_asset ?service_station)
      )
    :effect
      (and
        (service_station_available ?service_station)
        (not
          (device_reserved_service_station ?medical_device_asset ?service_station)
        )
      )
  )
  (:action perform_certified_stage_check
    :parameters (?medical_device_asset - medical_device_asset ?service_station - service_station ?certification_record - certification_record)
    :precondition
      (and
        (not
          (device_preparation_complete ?medical_device_asset)
        )
        (device_has_timeslot ?medical_device_asset)
        (certification_present ?certification_record)
        (device_reserved_service_station ?medical_device_asset ?service_station)
        (device_station_ready ?medical_device_asset)
      )
    :effect
      (and
        (not
          (device_regulatory_hold ?medical_device_asset)
        )
        (device_preparation_complete ?medical_device_asset)
      )
  )
  (:action close_case_with_post_execution_inspection
    :parameters (?medical_device_asset - medical_device_asset)
    :precondition
      (and
        (device_maintenance_case_open ?medical_device_asset)
        (device_fixed_device_checklist_required ?medical_device_asset)
        (device_post_execution_inspection ?medical_device_asset)
        (device_has_timeslot ?medical_device_asset)
        (device_preparation_complete ?medical_device_asset)
        (not
          (device_case_closed ?medical_device_asset)
        )
        (device_service_authorized ?medical_device_asset)
        (device_procedure_started ?medical_device_asset)
        (device_verification_complete ?medical_device_asset)
      )
    :effect
      (and
        (device_case_closed ?medical_device_asset)
      )
  )
  (:action record_post_staging_inspection
    :parameters (?medical_device_asset - medical_device_asset ?service_station - service_station ?certification_record - certification_record)
    :precondition
      (and
        (device_preparation_complete ?medical_device_asset)
        (certification_present ?certification_record)
        (not
          (device_post_execution_inspection ?medical_device_asset)
        )
        (device_service_authorized ?medical_device_asset)
        (device_maintenance_case_open ?medical_device_asset)
        (device_fixed_device_checklist_required ?medical_device_asset)
        (device_reserved_service_station ?medical_device_asset ?service_station)
      )
    :effect
      (and
        (device_post_execution_inspection ?medical_device_asset)
      )
  )
  (:action release_consumable_kit
    :parameters (?medical_device_asset - medical_device_asset ?consumable_kit - consumable_kit)
    :precondition
      (and
        (device_reserved_kit ?medical_device_asset ?consumable_kit)
      )
    :effect
      (and
        (kit_available ?consumable_kit)
        (not
          (device_reserved_kit ?medical_device_asset ?consumable_kit)
        )
      )
  )
  (:action reserve_service_report
    :parameters (?medical_device_asset - medical_device_asset ?service_report - service_report)
    :precondition
      (and
        (service_report_available ?service_report)
        (device_maintenance_case_open ?medical_device_asset)
        (device_service_report_compatible ?medical_device_asset ?service_report)
      )
    :effect
      (and
        (device_linked_service_report ?medical_device_asset ?service_report)
        (not
          (service_report_available ?service_report)
        )
      )
  )
  (:action create_maintenance_case
    :parameters (?medical_device_asset - medical_device_asset)
    :precondition
      (and
        (not
          (device_maintenance_case_open ?medical_device_asset)
        )
        (not
          (device_case_closed ?medical_device_asset)
        )
      )
    :effect
      (and
        (device_maintenance_case_open ?medical_device_asset)
      )
  )
  (:action engage_external_contractor
    :parameters (?medical_device_asset - medical_device_asset ?external_contractor_token - external_contractor_token)
    :precondition
      (and
        (not
          (device_station_ready ?medical_device_asset)
        )
        (device_maintenance_case_open ?medical_device_asset)
        (contractor_available ?external_contractor_token)
        (device_has_timeslot ?medical_device_asset)
      )
    :effect
      (and
        (device_regulatory_hold ?medical_device_asset)
        (not
          (contractor_available ?external_contractor_token)
        )
        (device_station_ready ?medical_device_asset)
      )
  )
  (:action initiate_procedure_with_auxiliary_and_spare
    :parameters (?medical_device_asset - medical_device_asset ?maintenance_procedure - maintenance_procedure ?auxiliary_device - auxiliary_device ?spare_component_record - spare_component_record)
    :precondition
      (and
        (spare_component_available ?spare_component_record)
        (device_spare_component_compatible ?medical_device_asset ?spare_component_record)
        (not
          (device_procedure_started ?medical_device_asset)
        )
        (device_has_timeslot ?medical_device_asset)
        (procedure_available ?maintenance_procedure)
        (device_procedure_compatible ?medical_device_asset ?maintenance_procedure)
        (device_assigned_auxiliary ?medical_device_asset ?auxiliary_device)
      )
    :effect
      (and
        (device_selected_procedure ?medical_device_asset ?maintenance_procedure)
        (not
          (spare_component_available ?spare_component_record)
        )
        (device_requires_additional_inspection ?medical_device_asset)
        (not
          (procedure_available ?maintenance_procedure)
        )
        (device_regulatory_hold ?medical_device_asset)
        (device_procedure_started ?medical_device_asset)
      )
  )
  (:action consume_external_contractor_token
    :parameters (?medical_device_asset - medical_device_asset ?external_contractor_token - external_contractor_token)
    :precondition
      (and
        (contractor_available ?external_contractor_token)
        (not
          (device_regulatory_hold ?medical_device_asset)
        )
        (device_preparation_complete ?medical_device_asset)
        (device_verification_complete ?medical_device_asset)
        (not
          (device_service_authorized ?medical_device_asset)
        )
      )
    :effect
      (and
        (device_service_authorized ?medical_device_asset)
        (not
          (contractor_available ?external_contractor_token)
        )
      )
  )
  (:action release_allocated_timeslot
    :parameters (?medical_device_asset - medical_device_asset ?maintenance_timeslot - maintenance_timeslot)
    :precondition
      (and
        (device_allocated_timeslot ?medical_device_asset ?maintenance_timeslot)
        (not
          (device_verification_complete ?medical_device_asset)
        )
        (not
          (device_procedure_started ?medical_device_asset)
        )
      )
    :effect
      (and
        (not
          (device_allocated_timeslot ?medical_device_asset ?maintenance_timeslot)
        )
        (timeslot_available ?maintenance_timeslot)
        (not
          (device_has_timeslot ?medical_device_asset)
        )
        (not
          (device_station_ready ?medical_device_asset)
        )
        (not
          (device_finalization_ready ?medical_device_asset)
        )
        (not
          (device_preparation_complete ?medical_device_asset)
        )
        (not
          (device_requires_additional_inspection ?medical_device_asset)
        )
        (not
          (device_regulatory_hold ?medical_device_asset)
        )
      )
  )
  (:action authorize_service_for_station
    :parameters (?medical_device_asset - medical_device_asset ?service_station - service_station)
    :precondition
      (and
        (not
          (device_service_authorized ?medical_device_asset)
        )
        (device_reserved_service_station ?medical_device_asset ?service_station)
        (device_preparation_complete ?medical_device_asset)
        (device_verification_complete ?medical_device_asset)
        (not
          (device_regulatory_hold ?medical_device_asset)
        )
      )
    :effect
      (and
        (device_service_authorized ?medical_device_asset)
      )
  )
  (:action close_case_with_regulatory_document
    :parameters (?medical_device_asset - medical_device_asset ?regulatory_document - regulatory_document)
    :precondition
      (and
        (device_service_authorized ?medical_device_asset)
        (device_verification_complete ?medical_device_asset)
        (device_procedure_started ?medical_device_asset)
        (regulatory_document_bound_to_device ?medical_device_asset ?regulatory_document)
        (device_preparation_complete ?medical_device_asset)
        (device_has_timeslot ?medical_device_asset)
        (device_maintenance_case_open ?medical_device_asset)
        (not
          (device_case_closed ?medical_device_asset)
        )
        (device_fixed_device_checklist_required ?medical_device_asset)
      )
    :effect
      (and
        (device_case_closed ?medical_device_asset)
      )
  )
  (:action perform_station_precheck
    :parameters (?medical_device_asset - medical_device_asset ?service_station - service_station)
    :precondition
      (and
        (device_maintenance_case_open ?medical_device_asset)
        (device_has_timeslot ?medical_device_asset)
        (not
          (device_station_ready ?medical_device_asset)
        )
        (device_reserved_service_station ?medical_device_asset ?service_station)
      )
    :effect
      (and
        (device_station_ready ?medical_device_asset)
      )
  )
  (:action allocate_maintenance_timeslot
    :parameters (?medical_device_asset - medical_device_asset ?maintenance_timeslot - maintenance_timeslot)
    :precondition
      (and
        (not
          (device_has_timeslot ?medical_device_asset)
        )
        (device_maintenance_case_open ?medical_device_asset)
        (timeslot_available ?maintenance_timeslot)
        (device_timeslot_compatible ?medical_device_asset ?maintenance_timeslot)
      )
    :effect
      (and
        (device_has_timeslot ?medical_device_asset)
        (not
          (timeslot_available ?maintenance_timeslot)
        )
        (device_allocated_timeslot ?medical_device_asset ?maintenance_timeslot)
      )
  )
  (:action perform_certified_stage_execution
    :parameters (?medical_device_asset - medical_device_asset ?service_station - service_station ?certification_record - certification_record)
    :precondition
      (and
        (device_has_timeslot ?medical_device_asset)
        (not
          (device_preparation_complete ?medical_device_asset)
        )
        (device_reserved_service_station ?medical_device_asset ?service_station)
        (device_verification_complete ?medical_device_asset)
        (certification_present ?certification_record)
        (device_finalization_ready ?medical_device_asset)
      )
    :effect
      (and
        (device_preparation_complete ?medical_device_asset)
      )
  )
  (:action bind_regulatory_document_to_fixed_device
    :parameters (?fixed_device - fixed_device ?portable_device - portable_device ?regulatory_document - regulatory_document)
    :precondition
      (and
        (device_maintenance_case_open ?fixed_device)
        (device_regulatory_document_linked ?portable_device ?regulatory_document)
        (device_fixed_device_checklist_required ?fixed_device)
        (not
          (regulatory_document_bound_to_device ?fixed_device ?regulatory_document)
        )
        (device_regulatory_document_applicable ?fixed_device ?regulatory_document)
      )
    :effect
      (and
        (regulatory_document_bound_to_device ?fixed_device ?regulatory_document)
      )
  )
)

(define (domain customs_bonded_vs_non_bonded_decision_domain)
  (:requirements :strips :typing :negative-preconditions)
  (:types resource_entity - object document_family - object submission_entity_family - object movement_case_container - object movement_case - movement_case_container representative_profile - resource_entity trade_document - resource_entity regulatory_officer - resource_entity commodity_classification - resource_entity inspection_profile - resource_entity customs_office - resource_entity financial_guarantee - resource_entity special_clearance_permit - resource_entity supporting_evidence - document_family attachment_package - document_family power_of_attorney - document_family bond_profile - submission_entity_family license_profile - submission_entity_family clearance_submission - submission_entity_family movement_segment_container - movement_case declarant_container - movement_case export_movement_segment - movement_segment_container import_movement_segment - movement_segment_container declarant_profile - declarant_container)
  (:predicates
    (movement_case_opened ?movement_case - movement_case)
    (entity_classification_completed ?movement_case - movement_case)
    (case_has_assigned_representative ?movement_case - movement_case)
    (entity_ready_for_clearance ?movement_case - movement_case)
    (entity_submission_authorisation_granted ?movement_case - movement_case)
    (entity_authorised ?movement_case - movement_case)
    (representative_available ?representative_profile - representative_profile)
    (entity_assigned_representative ?movement_case - movement_case ?representative_profile - representative_profile)
    (trade_document_available ?trade_document - trade_document)
    (entity_attached_document ?movement_case - movement_case ?trade_document - trade_document)
    (regulatory_officer_available ?regulatory_officer - regulatory_officer)
    (entity_assigned_regulatory_officer ?movement_case - movement_case ?regulatory_officer - regulatory_officer)
    (supporting_evidence_available ?supporting_evidence - supporting_evidence)
    (export_segment_attached_supporting_evidence ?export_movement_segment - export_movement_segment ?supporting_evidence - supporting_evidence)
    (import_segment_attached_supporting_evidence ?import_movement_segment - import_movement_segment ?supporting_evidence - supporting_evidence)
    (segment_bond_profile_link ?export_movement_segment - export_movement_segment ?bond_profile - bond_profile)
    (bond_profile_evaluated ?bond_profile - bond_profile)
    (bond_profile_requires_evidence ?bond_profile - bond_profile)
    (export_segment_marked_bonded ?export_movement_segment - export_movement_segment)
    (segment_license_profile_link ?import_movement_segment - import_movement_segment ?license_profile - license_profile)
    (license_profile_evaluated ?license_profile - license_profile)
    (license_profile_requires_evidence ?license_profile - license_profile)
    (import_segment_marked_license_required ?import_movement_segment - import_movement_segment)
    (clearance_submission_draft_available ?clearance_submission - clearance_submission)
    (clearance_submission_prepared ?clearance_submission - clearance_submission)
    (clearance_submission_linked_bond_profile ?clearance_submission - clearance_submission ?bond_profile - bond_profile)
    (clearance_submission_linked_license_profile ?clearance_submission - clearance_submission ?license_profile - license_profile)
    (clearance_submission_financial_guarantee_required ?clearance_submission - clearance_submission)
    (clearance_submission_special_permit_required ?clearance_submission - clearance_submission)
    (clearance_submission_segment_checks_passed ?clearance_submission - clearance_submission)
    (declarant_linked_export_segment ?declarant_profile - declarant_profile ?export_movement_segment - export_movement_segment)
    (declarant_linked_import_segment ?declarant_profile - declarant_profile ?import_movement_segment - import_movement_segment)
    (declarant_assigned_submission ?declarant_profile - declarant_profile ?clearance_submission - clearance_submission)
    (attachment_package_available ?attachment_package - attachment_package)
    (declarant_has_attachment_package ?declarant_profile - declarant_profile ?attachment_package - attachment_package)
    (attachment_package_committed_to_submission ?attachment_package - attachment_package)
    (attachment_package_linked_to_submission ?attachment_package - attachment_package ?clearance_submission - clearance_submission)
    (declarant_attachments_validated ?declarant_profile - declarant_profile)
    (declarant_financial_guarantee_registered ?declarant_profile - declarant_profile)
    (declarant_pre_final_checks_passed ?declarant_profile - declarant_profile)
    (declarant_commodity_classification_attached ?declarant_profile - declarant_profile)
    (declarant_commodity_classification_validated ?declarant_profile - declarant_profile)
    (declarant_preinspection_checks_complete ?declarant_profile - declarant_profile)
    (declarant_ready_for_authorisation ?declarant_profile - declarant_profile)
    (power_of_attorney_available ?power_of_attorney - power_of_attorney)
    (declarant_has_power_of_attorney ?declarant_profile - declarant_profile ?power_of_attorney - power_of_attorney)
    (declarant_power_of_attorney_active ?declarant_profile - declarant_profile)
    (declarant_power_of_attorney_validated ?declarant_profile - declarant_profile)
    (declarant_power_of_attorney_verified ?declarant_profile - declarant_profile)
    (commodity_classification_available ?commodity_classification - commodity_classification)
    (declarant_linked_commodity_classification ?declarant_profile - declarant_profile ?commodity_classification - commodity_classification)
    (inspection_profile_available ?inspection_profile - inspection_profile)
    (declarant_assigned_inspection_profile ?declarant_profile - declarant_profile ?inspection_profile - inspection_profile)
    (financial_guarantee_available ?financial_guarantee - financial_guarantee)
    (declarant_has_financial_guarantee ?declarant_profile - declarant_profile ?financial_guarantee - financial_guarantee)
    (special_clearance_permit_available ?special_clearance_permit - special_clearance_permit)
    (declarant_has_special_clearance_permit ?declarant_profile - declarant_profile ?special_clearance_permit - special_clearance_permit)
    (customs_office_available ?customs_office - customs_office)
    (entity_linked_customs_office ?movement_case - movement_case ?customs_office - customs_office)
    (export_segment_evaluation_completed ?export_movement_segment - export_movement_segment)
    (import_segment_evaluation_completed ?import_movement_segment - import_movement_segment)
    (declarant_authorisation_recorded ?declarant_profile - declarant_profile)
  )
  (:action open_movement_case
    :parameters (?movement_case - movement_case)
    :precondition
      (and
        (not
          (movement_case_opened ?movement_case)
        )
        (not
          (entity_ready_for_clearance ?movement_case)
        )
      )
    :effect (movement_case_opened ?movement_case)
  )
  (:action assign_representative_to_case
    :parameters (?movement_case - movement_case ?representative_profile - representative_profile)
    :precondition
      (and
        (movement_case_opened ?movement_case)
        (not
          (case_has_assigned_representative ?movement_case)
        )
        (representative_available ?representative_profile)
      )
    :effect
      (and
        (case_has_assigned_representative ?movement_case)
        (entity_assigned_representative ?movement_case ?representative_profile)
        (not
          (representative_available ?representative_profile)
        )
      )
  )
  (:action attach_trade_document_to_case
    :parameters (?movement_case - movement_case ?trade_document - trade_document)
    :precondition
      (and
        (movement_case_opened ?movement_case)
        (case_has_assigned_representative ?movement_case)
        (trade_document_available ?trade_document)
      )
    :effect
      (and
        (entity_attached_document ?movement_case ?trade_document)
        (not
          (trade_document_available ?trade_document)
        )
      )
  )
  (:action complete_case_classification
    :parameters (?movement_case - movement_case ?trade_document - trade_document)
    :precondition
      (and
        (movement_case_opened ?movement_case)
        (case_has_assigned_representative ?movement_case)
        (entity_attached_document ?movement_case ?trade_document)
        (not
          (entity_classification_completed ?movement_case)
        )
      )
    :effect (entity_classification_completed ?movement_case)
  )
  (:action release_trade_document_from_case
    :parameters (?movement_case - movement_case ?trade_document - trade_document)
    :precondition
      (and
        (entity_attached_document ?movement_case ?trade_document)
      )
    :effect
      (and
        (trade_document_available ?trade_document)
        (not
          (entity_attached_document ?movement_case ?trade_document)
        )
      )
  )
  (:action assign_regulatory_officer_to_case
    :parameters (?movement_case - movement_case ?regulatory_officer - regulatory_officer)
    :precondition
      (and
        (entity_classification_completed ?movement_case)
        (regulatory_officer_available ?regulatory_officer)
      )
    :effect
      (and
        (entity_assigned_regulatory_officer ?movement_case ?regulatory_officer)
        (not
          (regulatory_officer_available ?regulatory_officer)
        )
      )
  )
  (:action unassign_regulatory_officer_from_case
    :parameters (?movement_case - movement_case ?regulatory_officer - regulatory_officer)
    :precondition
      (and
        (entity_assigned_regulatory_officer ?movement_case ?regulatory_officer)
      )
    :effect
      (and
        (regulatory_officer_available ?regulatory_officer)
        (not
          (entity_assigned_regulatory_officer ?movement_case ?regulatory_officer)
        )
      )
  )
  (:action register_financial_guarantee_on_declarant
    :parameters (?declarant_profile - declarant_profile ?financial_guarantee - financial_guarantee)
    :precondition
      (and
        (entity_classification_completed ?declarant_profile)
        (financial_guarantee_available ?financial_guarantee)
      )
    :effect
      (and
        (declarant_has_financial_guarantee ?declarant_profile ?financial_guarantee)
        (not
          (financial_guarantee_available ?financial_guarantee)
        )
      )
  )
  (:action unregister_financial_guarantee_from_declarant
    :parameters (?declarant_profile - declarant_profile ?financial_guarantee - financial_guarantee)
    :precondition
      (and
        (declarant_has_financial_guarantee ?declarant_profile ?financial_guarantee)
      )
    :effect
      (and
        (financial_guarantee_available ?financial_guarantee)
        (not
          (declarant_has_financial_guarantee ?declarant_profile ?financial_guarantee)
        )
      )
  )
  (:action register_special_permit_on_declarant
    :parameters (?declarant_profile - declarant_profile ?special_clearance_permit - special_clearance_permit)
    :precondition
      (and
        (entity_classification_completed ?declarant_profile)
        (special_clearance_permit_available ?special_clearance_permit)
      )
    :effect
      (and
        (declarant_has_special_clearance_permit ?declarant_profile ?special_clearance_permit)
        (not
          (special_clearance_permit_available ?special_clearance_permit)
        )
      )
  )
  (:action unregister_special_permit_from_declarant
    :parameters (?declarant_profile - declarant_profile ?special_clearance_permit - special_clearance_permit)
    :precondition
      (and
        (declarant_has_special_clearance_permit ?declarant_profile ?special_clearance_permit)
      )
    :effect
      (and
        (special_clearance_permit_available ?special_clearance_permit)
        (not
          (declarant_has_special_clearance_permit ?declarant_profile ?special_clearance_permit)
        )
      )
  )
  (:action evaluate_export_segment_for_bond
    :parameters (?export_movement_segment - export_movement_segment ?bond_profile - bond_profile ?trade_document - trade_document)
    :precondition
      (and
        (entity_classification_completed ?export_movement_segment)
        (entity_attached_document ?export_movement_segment ?trade_document)
        (segment_bond_profile_link ?export_movement_segment ?bond_profile)
        (not
          (bond_profile_evaluated ?bond_profile)
        )
        (not
          (bond_profile_requires_evidence ?bond_profile)
        )
      )
    :effect (bond_profile_evaluated ?bond_profile)
  )
  (:action resolve_export_bond_with_officer
    :parameters (?export_movement_segment - export_movement_segment ?bond_profile - bond_profile ?regulatory_officer - regulatory_officer)
    :precondition
      (and
        (entity_classification_completed ?export_movement_segment)
        (entity_assigned_regulatory_officer ?export_movement_segment ?regulatory_officer)
        (segment_bond_profile_link ?export_movement_segment ?bond_profile)
        (bond_profile_evaluated ?bond_profile)
        (not
          (export_segment_evaluation_completed ?export_movement_segment)
        )
      )
    :effect
      (and
        (export_segment_evaluation_completed ?export_movement_segment)
        (export_segment_marked_bonded ?export_movement_segment)
      )
  )
  (:action attach_supporting_evidence_to_export_segment
    :parameters (?export_movement_segment - export_movement_segment ?bond_profile - bond_profile ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (entity_classification_completed ?export_movement_segment)
        (segment_bond_profile_link ?export_movement_segment ?bond_profile)
        (supporting_evidence_available ?supporting_evidence)
        (not
          (export_segment_evaluation_completed ?export_movement_segment)
        )
      )
    :effect
      (and
        (bond_profile_requires_evidence ?bond_profile)
        (export_segment_evaluation_completed ?export_movement_segment)
        (export_segment_attached_supporting_evidence ?export_movement_segment ?supporting_evidence)
        (not
          (supporting_evidence_available ?supporting_evidence)
        )
      )
  )
  (:action finalize_export_segment_bond_evaluation
    :parameters (?export_movement_segment - export_movement_segment ?bond_profile - bond_profile ?trade_document - trade_document ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (entity_classification_completed ?export_movement_segment)
        (entity_attached_document ?export_movement_segment ?trade_document)
        (segment_bond_profile_link ?export_movement_segment ?bond_profile)
        (bond_profile_requires_evidence ?bond_profile)
        (export_segment_attached_supporting_evidence ?export_movement_segment ?supporting_evidence)
        (not
          (export_segment_marked_bonded ?export_movement_segment)
        )
      )
    :effect
      (and
        (bond_profile_evaluated ?bond_profile)
        (export_segment_marked_bonded ?export_movement_segment)
        (supporting_evidence_available ?supporting_evidence)
        (not
          (export_segment_attached_supporting_evidence ?export_movement_segment ?supporting_evidence)
        )
      )
  )
  (:action evaluate_import_segment_for_license
    :parameters (?import_movement_segment - import_movement_segment ?license_profile - license_profile ?trade_document - trade_document)
    :precondition
      (and
        (entity_classification_completed ?import_movement_segment)
        (entity_attached_document ?import_movement_segment ?trade_document)
        (segment_license_profile_link ?import_movement_segment ?license_profile)
        (not
          (license_profile_evaluated ?license_profile)
        )
        (not
          (license_profile_requires_evidence ?license_profile)
        )
      )
    :effect (license_profile_evaluated ?license_profile)
  )
  (:action resolve_import_license_with_officer
    :parameters (?import_movement_segment - import_movement_segment ?license_profile - license_profile ?regulatory_officer - regulatory_officer)
    :precondition
      (and
        (entity_classification_completed ?import_movement_segment)
        (entity_assigned_regulatory_officer ?import_movement_segment ?regulatory_officer)
        (segment_license_profile_link ?import_movement_segment ?license_profile)
        (license_profile_evaluated ?license_profile)
        (not
          (import_segment_evaluation_completed ?import_movement_segment)
        )
      )
    :effect
      (and
        (import_segment_evaluation_completed ?import_movement_segment)
        (import_segment_marked_license_required ?import_movement_segment)
      )
  )
  (:action attach_supporting_evidence_to_import_segment
    :parameters (?import_movement_segment - import_movement_segment ?license_profile - license_profile ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (entity_classification_completed ?import_movement_segment)
        (segment_license_profile_link ?import_movement_segment ?license_profile)
        (supporting_evidence_available ?supporting_evidence)
        (not
          (import_segment_evaluation_completed ?import_movement_segment)
        )
      )
    :effect
      (and
        (license_profile_requires_evidence ?license_profile)
        (import_segment_evaluation_completed ?import_movement_segment)
        (import_segment_attached_supporting_evidence ?import_movement_segment ?supporting_evidence)
        (not
          (supporting_evidence_available ?supporting_evidence)
        )
      )
  )
  (:action finalize_import_segment_license_evaluation
    :parameters (?import_movement_segment - import_movement_segment ?license_profile - license_profile ?trade_document - trade_document ?supporting_evidence - supporting_evidence)
    :precondition
      (and
        (entity_classification_completed ?import_movement_segment)
        (entity_attached_document ?import_movement_segment ?trade_document)
        (segment_license_profile_link ?import_movement_segment ?license_profile)
        (license_profile_requires_evidence ?license_profile)
        (import_segment_attached_supporting_evidence ?import_movement_segment ?supporting_evidence)
        (not
          (import_segment_marked_license_required ?import_movement_segment)
        )
      )
    :effect
      (and
        (license_profile_evaluated ?license_profile)
        (import_segment_marked_license_required ?import_movement_segment)
        (supporting_evidence_available ?supporting_evidence)
        (not
          (import_segment_attached_supporting_evidence ?import_movement_segment ?supporting_evidence)
        )
      )
  )
  (:action prepare_clearance_submission_standard
    :parameters (?export_movement_segment - export_movement_segment ?import_movement_segment - import_movement_segment ?bond_profile - bond_profile ?license_profile - license_profile ?clearance_submission - clearance_submission)
    :precondition
      (and
        (export_segment_evaluation_completed ?export_movement_segment)
        (import_segment_evaluation_completed ?import_movement_segment)
        (segment_bond_profile_link ?export_movement_segment ?bond_profile)
        (segment_license_profile_link ?import_movement_segment ?license_profile)
        (bond_profile_evaluated ?bond_profile)
        (license_profile_evaluated ?license_profile)
        (export_segment_marked_bonded ?export_movement_segment)
        (import_segment_marked_license_required ?import_movement_segment)
        (clearance_submission_draft_available ?clearance_submission)
      )
    :effect
      (and
        (clearance_submission_prepared ?clearance_submission)
        (clearance_submission_linked_bond_profile ?clearance_submission ?bond_profile)
        (clearance_submission_linked_license_profile ?clearance_submission ?license_profile)
        (not
          (clearance_submission_draft_available ?clearance_submission)
        )
      )
  )
  (:action prepare_clearance_submission_with_guarantee_flag
    :parameters (?export_movement_segment - export_movement_segment ?import_movement_segment - import_movement_segment ?bond_profile - bond_profile ?license_profile - license_profile ?clearance_submission - clearance_submission)
    :precondition
      (and
        (export_segment_evaluation_completed ?export_movement_segment)
        (import_segment_evaluation_completed ?import_movement_segment)
        (segment_bond_profile_link ?export_movement_segment ?bond_profile)
        (segment_license_profile_link ?import_movement_segment ?license_profile)
        (bond_profile_requires_evidence ?bond_profile)
        (license_profile_evaluated ?license_profile)
        (not
          (export_segment_marked_bonded ?export_movement_segment)
        )
        (import_segment_marked_license_required ?import_movement_segment)
        (clearance_submission_draft_available ?clearance_submission)
      )
    :effect
      (and
        (clearance_submission_prepared ?clearance_submission)
        (clearance_submission_linked_bond_profile ?clearance_submission ?bond_profile)
        (clearance_submission_linked_license_profile ?clearance_submission ?license_profile)
        (clearance_submission_financial_guarantee_required ?clearance_submission)
        (not
          (clearance_submission_draft_available ?clearance_submission)
        )
      )
  )
  (:action prepare_clearance_submission_with_permit_flag
    :parameters (?export_movement_segment - export_movement_segment ?import_movement_segment - import_movement_segment ?bond_profile - bond_profile ?license_profile - license_profile ?clearance_submission - clearance_submission)
    :precondition
      (and
        (export_segment_evaluation_completed ?export_movement_segment)
        (import_segment_evaluation_completed ?import_movement_segment)
        (segment_bond_profile_link ?export_movement_segment ?bond_profile)
        (segment_license_profile_link ?import_movement_segment ?license_profile)
        (bond_profile_evaluated ?bond_profile)
        (license_profile_requires_evidence ?license_profile)
        (export_segment_marked_bonded ?export_movement_segment)
        (not
          (import_segment_marked_license_required ?import_movement_segment)
        )
        (clearance_submission_draft_available ?clearance_submission)
      )
    :effect
      (and
        (clearance_submission_prepared ?clearance_submission)
        (clearance_submission_linked_bond_profile ?clearance_submission ?bond_profile)
        (clearance_submission_linked_license_profile ?clearance_submission ?license_profile)
        (clearance_submission_special_permit_required ?clearance_submission)
        (not
          (clearance_submission_draft_available ?clearance_submission)
        )
      )
  )
  (:action prepare_clearance_submission_comprehensive
    :parameters (?export_movement_segment - export_movement_segment ?import_movement_segment - import_movement_segment ?bond_profile - bond_profile ?license_profile - license_profile ?clearance_submission - clearance_submission)
    :precondition
      (and
        (export_segment_evaluation_completed ?export_movement_segment)
        (import_segment_evaluation_completed ?import_movement_segment)
        (segment_bond_profile_link ?export_movement_segment ?bond_profile)
        (segment_license_profile_link ?import_movement_segment ?license_profile)
        (bond_profile_requires_evidence ?bond_profile)
        (license_profile_requires_evidence ?license_profile)
        (not
          (export_segment_marked_bonded ?export_movement_segment)
        )
        (not
          (import_segment_marked_license_required ?import_movement_segment)
        )
        (clearance_submission_draft_available ?clearance_submission)
      )
    :effect
      (and
        (clearance_submission_prepared ?clearance_submission)
        (clearance_submission_linked_bond_profile ?clearance_submission ?bond_profile)
        (clearance_submission_linked_license_profile ?clearance_submission ?license_profile)
        (clearance_submission_financial_guarantee_required ?clearance_submission)
        (clearance_submission_special_permit_required ?clearance_submission)
        (not
          (clearance_submission_draft_available ?clearance_submission)
        )
      )
  )
  (:action record_submission_segment_checks_passed
    :parameters (?clearance_submission - clearance_submission ?export_movement_segment - export_movement_segment ?trade_document - trade_document)
    :precondition
      (and
        (clearance_submission_prepared ?clearance_submission)
        (export_segment_evaluation_completed ?export_movement_segment)
        (entity_attached_document ?export_movement_segment ?trade_document)
        (not
          (clearance_submission_segment_checks_passed ?clearance_submission)
        )
      )
    :effect (clearance_submission_segment_checks_passed ?clearance_submission)
  )
  (:action commit_attachment_package_to_submission
    :parameters (?declarant_profile - declarant_profile ?attachment_package - attachment_package ?clearance_submission - clearance_submission)
    :precondition
      (and
        (entity_classification_completed ?declarant_profile)
        (declarant_assigned_submission ?declarant_profile ?clearance_submission)
        (declarant_has_attachment_package ?declarant_profile ?attachment_package)
        (attachment_package_available ?attachment_package)
        (clearance_submission_prepared ?clearance_submission)
        (clearance_submission_segment_checks_passed ?clearance_submission)
        (not
          (attachment_package_committed_to_submission ?attachment_package)
        )
      )
    :effect
      (and
        (attachment_package_committed_to_submission ?attachment_package)
        (attachment_package_linked_to_submission ?attachment_package ?clearance_submission)
        (not
          (attachment_package_available ?attachment_package)
        )
      )
  )
  (:action validate_attachment_package_and_mark_declarant
    :parameters (?declarant_profile - declarant_profile ?attachment_package - attachment_package ?clearance_submission - clearance_submission ?trade_document - trade_document)
    :precondition
      (and
        (entity_classification_completed ?declarant_profile)
        (declarant_has_attachment_package ?declarant_profile ?attachment_package)
        (attachment_package_committed_to_submission ?attachment_package)
        (attachment_package_linked_to_submission ?attachment_package ?clearance_submission)
        (entity_attached_document ?declarant_profile ?trade_document)
        (not
          (clearance_submission_financial_guarantee_required ?clearance_submission)
        )
        (not
          (declarant_attachments_validated ?declarant_profile)
        )
      )
    :effect (declarant_attachments_validated ?declarant_profile)
  )
  (:action assign_commodity_classification_to_declarant
    :parameters (?declarant_profile - declarant_profile ?commodity_classification - commodity_classification)
    :precondition
      (and
        (entity_classification_completed ?declarant_profile)
        (commodity_classification_available ?commodity_classification)
        (not
          (declarant_commodity_classification_attached ?declarant_profile)
        )
      )
    :effect
      (and
        (declarant_commodity_classification_attached ?declarant_profile)
        (declarant_linked_commodity_classification ?declarant_profile ?commodity_classification)
        (not
          (commodity_classification_available ?commodity_classification)
        )
      )
  )
  (:action finalise_classification_and_mark_declarant_validated
    :parameters (?declarant_profile - declarant_profile ?attachment_package - attachment_package ?clearance_submission - clearance_submission ?trade_document - trade_document ?commodity_classification - commodity_classification)
    :precondition
      (and
        (entity_classification_completed ?declarant_profile)
        (declarant_has_attachment_package ?declarant_profile ?attachment_package)
        (attachment_package_committed_to_submission ?attachment_package)
        (attachment_package_linked_to_submission ?attachment_package ?clearance_submission)
        (entity_attached_document ?declarant_profile ?trade_document)
        (clearance_submission_financial_guarantee_required ?clearance_submission)
        (declarant_commodity_classification_attached ?declarant_profile)
        (declarant_linked_commodity_classification ?declarant_profile ?commodity_classification)
        (not
          (declarant_attachments_validated ?declarant_profile)
        )
      )
    :effect
      (and
        (declarant_attachments_validated ?declarant_profile)
        (declarant_commodity_classification_validated ?declarant_profile)
      )
  )
  (:action register_financial_guarantee_for_declarant_submission
    :parameters (?declarant_profile - declarant_profile ?financial_guarantee - financial_guarantee ?regulatory_officer - regulatory_officer ?attachment_package - attachment_package ?clearance_submission - clearance_submission)
    :precondition
      (and
        (declarant_attachments_validated ?declarant_profile)
        (declarant_has_financial_guarantee ?declarant_profile ?financial_guarantee)
        (entity_assigned_regulatory_officer ?declarant_profile ?regulatory_officer)
        (declarant_has_attachment_package ?declarant_profile ?attachment_package)
        (attachment_package_linked_to_submission ?attachment_package ?clearance_submission)
        (not
          (clearance_submission_special_permit_required ?clearance_submission)
        )
        (not
          (declarant_financial_guarantee_registered ?declarant_profile)
        )
      )
    :effect (declarant_financial_guarantee_registered ?declarant_profile)
  )
  (:action register_financial_guarantee_alternate_flow
    :parameters (?declarant_profile - declarant_profile ?financial_guarantee - financial_guarantee ?regulatory_officer - regulatory_officer ?attachment_package - attachment_package ?clearance_submission - clearance_submission)
    :precondition
      (and
        (declarant_attachments_validated ?declarant_profile)
        (declarant_has_financial_guarantee ?declarant_profile ?financial_guarantee)
        (entity_assigned_regulatory_officer ?declarant_profile ?regulatory_officer)
        (declarant_has_attachment_package ?declarant_profile ?attachment_package)
        (attachment_package_linked_to_submission ?attachment_package ?clearance_submission)
        (clearance_submission_special_permit_required ?clearance_submission)
        (not
          (declarant_financial_guarantee_registered ?declarant_profile)
        )
      )
    :effect (declarant_financial_guarantee_registered ?declarant_profile)
  )
  (:action register_special_permit_and_mark_declarant
    :parameters (?declarant_profile - declarant_profile ?special_clearance_permit - special_clearance_permit ?attachment_package - attachment_package ?clearance_submission - clearance_submission)
    :precondition
      (and
        (declarant_financial_guarantee_registered ?declarant_profile)
        (declarant_has_special_clearance_permit ?declarant_profile ?special_clearance_permit)
        (declarant_has_attachment_package ?declarant_profile ?attachment_package)
        (attachment_package_linked_to_submission ?attachment_package ?clearance_submission)
        (not
          (clearance_submission_financial_guarantee_required ?clearance_submission)
        )
        (not
          (clearance_submission_special_permit_required ?clearance_submission)
        )
        (not
          (declarant_pre_final_checks_passed ?declarant_profile)
        )
      )
    :effect (declarant_pre_final_checks_passed ?declarant_profile)
  )
  (:action register_special_permit_with_attachment_flag
    :parameters (?declarant_profile - declarant_profile ?special_clearance_permit - special_clearance_permit ?attachment_package - attachment_package ?clearance_submission - clearance_submission)
    :precondition
      (and
        (declarant_financial_guarantee_registered ?declarant_profile)
        (declarant_has_special_clearance_permit ?declarant_profile ?special_clearance_permit)
        (declarant_has_attachment_package ?declarant_profile ?attachment_package)
        (attachment_package_linked_to_submission ?attachment_package ?clearance_submission)
        (clearance_submission_financial_guarantee_required ?clearance_submission)
        (not
          (clearance_submission_special_permit_required ?clearance_submission)
        )
        (not
          (declarant_pre_final_checks_passed ?declarant_profile)
        )
      )
    :effect
      (and
        (declarant_pre_final_checks_passed ?declarant_profile)
        (declarant_preinspection_checks_complete ?declarant_profile)
      )
  )
  (:action register_special_permit_and_finalize_declarant
    :parameters (?declarant_profile - declarant_profile ?special_clearance_permit - special_clearance_permit ?attachment_package - attachment_package ?clearance_submission - clearance_submission)
    :precondition
      (and
        (declarant_financial_guarantee_registered ?declarant_profile)
        (declarant_has_special_clearance_permit ?declarant_profile ?special_clearance_permit)
        (declarant_has_attachment_package ?declarant_profile ?attachment_package)
        (attachment_package_linked_to_submission ?attachment_package ?clearance_submission)
        (not
          (clearance_submission_financial_guarantee_required ?clearance_submission)
        )
        (clearance_submission_special_permit_required ?clearance_submission)
        (not
          (declarant_pre_final_checks_passed ?declarant_profile)
        )
      )
    :effect
      (and
        (declarant_pre_final_checks_passed ?declarant_profile)
        (declarant_preinspection_checks_complete ?declarant_profile)
      )
  )
  (:action register_special_permit_and_finalize_declarant_alternate
    :parameters (?declarant_profile - declarant_profile ?special_clearance_permit - special_clearance_permit ?attachment_package - attachment_package ?clearance_submission - clearance_submission)
    :precondition
      (and
        (declarant_financial_guarantee_registered ?declarant_profile)
        (declarant_has_special_clearance_permit ?declarant_profile ?special_clearance_permit)
        (declarant_has_attachment_package ?declarant_profile ?attachment_package)
        (attachment_package_linked_to_submission ?attachment_package ?clearance_submission)
        (clearance_submission_financial_guarantee_required ?clearance_submission)
        (clearance_submission_special_permit_required ?clearance_submission)
        (not
          (declarant_pre_final_checks_passed ?declarant_profile)
        )
      )
    :effect
      (and
        (declarant_pre_final_checks_passed ?declarant_profile)
        (declarant_preinspection_checks_complete ?declarant_profile)
      )
  )
  (:action grant_declarant_submission_authorisation
    :parameters (?declarant_profile - declarant_profile)
    :precondition
      (and
        (declarant_pre_final_checks_passed ?declarant_profile)
        (not
          (declarant_preinspection_checks_complete ?declarant_profile)
        )
        (not
          (declarant_authorisation_recorded ?declarant_profile)
        )
      )
    :effect
      (and
        (declarant_authorisation_recorded ?declarant_profile)
        (entity_submission_authorisation_granted ?declarant_profile)
      )
  )
  (:action assign_inspection_profile_to_declarant
    :parameters (?declarant_profile - declarant_profile ?inspection_profile - inspection_profile)
    :precondition
      (and
        (declarant_pre_final_checks_passed ?declarant_profile)
        (declarant_preinspection_checks_complete ?declarant_profile)
        (inspection_profile_available ?inspection_profile)
      )
    :effect
      (and
        (declarant_assigned_inspection_profile ?declarant_profile ?inspection_profile)
        (not
          (inspection_profile_available ?inspection_profile)
        )
      )
  )
  (:action finalise_declarant_checks_for_authorisation
    :parameters (?declarant_profile - declarant_profile ?export_movement_segment - export_movement_segment ?import_movement_segment - import_movement_segment ?trade_document - trade_document ?inspection_profile - inspection_profile)
    :precondition
      (and
        (declarant_pre_final_checks_passed ?declarant_profile)
        (declarant_preinspection_checks_complete ?declarant_profile)
        (declarant_assigned_inspection_profile ?declarant_profile ?inspection_profile)
        (declarant_linked_export_segment ?declarant_profile ?export_movement_segment)
        (declarant_linked_import_segment ?declarant_profile ?import_movement_segment)
        (export_segment_marked_bonded ?export_movement_segment)
        (import_segment_marked_license_required ?import_movement_segment)
        (entity_attached_document ?declarant_profile ?trade_document)
        (not
          (declarant_ready_for_authorisation ?declarant_profile)
        )
      )
    :effect (declarant_ready_for_authorisation ?declarant_profile)
  )
  (:action record_declarant_authorisation
    :parameters (?declarant_profile - declarant_profile)
    :precondition
      (and
        (declarant_pre_final_checks_passed ?declarant_profile)
        (declarant_ready_for_authorisation ?declarant_profile)
        (not
          (declarant_authorisation_recorded ?declarant_profile)
        )
      )
    :effect
      (and
        (declarant_authorisation_recorded ?declarant_profile)
        (entity_submission_authorisation_granted ?declarant_profile)
      )
  )
  (:action activate_power_of_attorney_for_declarant
    :parameters (?declarant_profile - declarant_profile ?power_of_attorney - power_of_attorney ?trade_document - trade_document)
    :precondition
      (and
        (entity_classification_completed ?declarant_profile)
        (entity_attached_document ?declarant_profile ?trade_document)
        (power_of_attorney_available ?power_of_attorney)
        (declarant_has_power_of_attorney ?declarant_profile ?power_of_attorney)
        (not
          (declarant_power_of_attorney_active ?declarant_profile)
        )
      )
    :effect
      (and
        (declarant_power_of_attorney_active ?declarant_profile)
        (not
          (power_of_attorney_available ?power_of_attorney)
        )
      )
  )
  (:action validate_power_of_attorney_with_regulatory_officer
    :parameters (?declarant_profile - declarant_profile ?regulatory_officer - regulatory_officer)
    :precondition
      (and
        (declarant_power_of_attorney_active ?declarant_profile)
        (entity_assigned_regulatory_officer ?declarant_profile ?regulatory_officer)
        (not
          (declarant_power_of_attorney_validated ?declarant_profile)
        )
      )
    :effect (declarant_power_of_attorney_validated ?declarant_profile)
  )
  (:action confirm_power_of_attorney_with_permit
    :parameters (?declarant_profile - declarant_profile ?special_clearance_permit - special_clearance_permit)
    :precondition
      (and
        (declarant_power_of_attorney_validated ?declarant_profile)
        (declarant_has_special_clearance_permit ?declarant_profile ?special_clearance_permit)
        (not
          (declarant_power_of_attorney_verified ?declarant_profile)
        )
      )
    :effect (declarant_power_of_attorney_verified ?declarant_profile)
  )
  (:action finalize_power_of_attorney_authorisation
    :parameters (?declarant_profile - declarant_profile)
    :precondition
      (and
        (declarant_power_of_attorney_verified ?declarant_profile)
        (not
          (declarant_authorisation_recorded ?declarant_profile)
        )
      )
    :effect
      (and
        (declarant_authorisation_recorded ?declarant_profile)
        (entity_submission_authorisation_granted ?declarant_profile)
      )
  )
  (:action authorise_export_segment
    :parameters (?export_movement_segment - export_movement_segment ?clearance_submission - clearance_submission)
    :precondition
      (and
        (export_segment_evaluation_completed ?export_movement_segment)
        (export_segment_marked_bonded ?export_movement_segment)
        (clearance_submission_prepared ?clearance_submission)
        (clearance_submission_segment_checks_passed ?clearance_submission)
        (not
          (entity_submission_authorisation_granted ?export_movement_segment)
        )
      )
    :effect (entity_submission_authorisation_granted ?export_movement_segment)
  )
  (:action authorise_import_segment
    :parameters (?import_movement_segment - import_movement_segment ?clearance_submission - clearance_submission)
    :precondition
      (and
        (import_segment_evaluation_completed ?import_movement_segment)
        (import_segment_marked_license_required ?import_movement_segment)
        (clearance_submission_prepared ?clearance_submission)
        (clearance_submission_segment_checks_passed ?clearance_submission)
        (not
          (entity_submission_authorisation_granted ?import_movement_segment)
        )
      )
    :effect (entity_submission_authorisation_granted ?import_movement_segment)
  )
  (:action grant_movement_case_clearance_authorisation
    :parameters (?movement_case - movement_case ?customs_office - customs_office ?trade_document - trade_document)
    :precondition
      (and
        (entity_submission_authorisation_granted ?movement_case)
        (entity_attached_document ?movement_case ?trade_document)
        (customs_office_available ?customs_office)
        (not
          (entity_authorised ?movement_case)
        )
      )
    :effect
      (and
        (entity_authorised ?movement_case)
        (entity_linked_customs_office ?movement_case ?customs_office)
        (not
          (customs_office_available ?customs_office)
        )
      )
  )
  (:action apply_case_authorisation_to_export_segment_and_release_representative
    :parameters (?export_movement_segment - export_movement_segment ?representative_profile - representative_profile ?customs_office - customs_office)
    :precondition
      (and
        (entity_authorised ?export_movement_segment)
        (entity_assigned_representative ?export_movement_segment ?representative_profile)
        (entity_linked_customs_office ?export_movement_segment ?customs_office)
        (not
          (entity_ready_for_clearance ?export_movement_segment)
        )
      )
    :effect
      (and
        (entity_ready_for_clearance ?export_movement_segment)
        (representative_available ?representative_profile)
        (customs_office_available ?customs_office)
      )
  )
  (:action apply_case_authorisation_to_import_segment_and_release_representative
    :parameters (?import_movement_segment - import_movement_segment ?representative_profile - representative_profile ?customs_office - customs_office)
    :precondition
      (and
        (entity_authorised ?import_movement_segment)
        (entity_assigned_representative ?import_movement_segment ?representative_profile)
        (entity_linked_customs_office ?import_movement_segment ?customs_office)
        (not
          (entity_ready_for_clearance ?import_movement_segment)
        )
      )
    :effect
      (and
        (entity_ready_for_clearance ?import_movement_segment)
        (representative_available ?representative_profile)
        (customs_office_available ?customs_office)
      )
  )
  (:action apply_case_authorisation_to_declarant_profile_and_release_representative
    :parameters (?declarant_profile - declarant_profile ?representative_profile - representative_profile ?customs_office - customs_office)
    :precondition
      (and
        (entity_authorised ?declarant_profile)
        (entity_assigned_representative ?declarant_profile ?representative_profile)
        (entity_linked_customs_office ?declarant_profile ?customs_office)
        (not
          (entity_ready_for_clearance ?declarant_profile)
        )
      )
    :effect
      (and
        (entity_ready_for_clearance ?declarant_profile)
        (representative_available ?representative_profile)
        (customs_office_available ?customs_office)
      )
  )
)

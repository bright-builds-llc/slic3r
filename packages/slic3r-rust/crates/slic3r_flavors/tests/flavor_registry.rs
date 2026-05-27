use slic3r_contracts::{ChecklistStatus, DownstreamFork, FeatureOrigin, FlavorId, VendorSourceRef};
use slic3r_flavors::{
    FlavorCapability, FlavorProvenance, FlavorRegistryEntry, all_capabilities, all_flavors,
    capabilities_by_checklist_status, capabilities_by_origin, maybe_flavor,
};

#[test]
fn registry_api_reexports_contract_typed_helpers() {
    // Arrange
    let flavor_id = FlavorId::BaseSlic3r;
    let origin = FeatureOrigin::BaseSlic3r;
    let status = ChecklistStatus::NoActionBase;
    let vendor_source = VendorSourceRef::prusa_slicer_version_2_9_5();

    // Act
    let maybe_entry: Option<&'static FlavorRegistryEntry> = maybe_flavor(flavor_id);
    let flavors: Vec<&'static FlavorRegistryEntry> = all_flavors().iter().collect();
    let capabilities: Vec<&'static FlavorCapability> = all_capabilities().collect();
    let origin_capabilities: Vec<&'static FlavorCapability> =
        capabilities_by_origin(origin).collect();
    let status_capabilities: Vec<&'static FlavorCapability> =
        capabilities_by_checklist_status(status).collect();
    let provenance = FlavorProvenance {
        inventory_id: "prusaslicer.base-core",
        vendor_source,
        source_paths: &["src/libslic3r"],
        ownership: origin,
    };

    // Assert
    assert!(maybe_entry.is_some());
    assert!(!flavors.is_empty());
    assert!(!capabilities.is_empty());
    assert!(!origin_capabilities.is_empty());
    assert!(!status_capabilities.is_empty());
    assert_eq!(provenance.inventory_id, "prusaslicer.base-core");
}

#[test]
fn all_flavors_returns_base_and_downstream_entries_through_one_entry_type() {
    // Arrange
    let expected_flavors = [
        FlavorId::BaseSlic3r,
        FlavorId::PrusaSlicer,
        FlavorId::BambuStudio,
        FlavorId::OrcaSlicer,
    ];

    // Act
    let actual_flavors: Vec<FlavorId> = all_flavors().iter().map(|entry| entry.flavor_id).collect();
    let entries: Vec<&'static FlavorRegistryEntry> = all_flavors().iter().collect();

    // Assert
    assert_eq!(actual_flavors, expected_flavors);
    assert_eq!(entries.len(), expected_flavors.len());
}

#[test]
fn base_flavor_entry_keeps_base_identity_without_downstream_fork() {
    // Arrange
    let maybe_base_entry = maybe_flavor(FlavorId::BaseSlic3r);

    // Act
    let base_entry = match maybe_base_entry {
        Some(entry) => entry,
        None => {
            assert!(maybe_base_entry.is_some(), "base-slic3r entry missing");
            return;
        }
    };

    // Assert
    assert_eq!(base_entry.flavor_id, FlavorId::BaseSlic3r);
    assert_eq!(base_entry.flavor_id.maybe_downstream_fork(), None);
}

#[test]
fn base_capability_preserves_vendor_observed_provenance() {
    // Arrange
    let maybe_base_core = maybe_capability("base-core");

    // Act
    let base_core = match maybe_base_core {
        Some(capability) => capability,
        None => {
            assert!(maybe_base_core.is_some(), "base-core capability missing");
            return;
        }
    };
    let provenance_inventory_ids: Vec<&'static str> = base_core
        .provenance
        .iter()
        .map(|provenance| provenance.inventory_id)
        .collect();
    let provenance_sources: Vec<VendorSourceRef> = base_core
        .provenance
        .iter()
        .map(|provenance| provenance.vendor_source)
        .collect();
    let provenance_vendors: Vec<DownstreamFork> = base_core
        .provenance
        .iter()
        .map(|provenance| provenance.vendor_source.vendor())
        .collect();

    // Assert
    assert_eq!(
        provenance_inventory_ids,
        [
            "prusaslicer.base-core",
            "bambustudio.base-core",
            "orcaslicer.base-core",
        ]
    );
    assert_eq!(
        provenance_sources,
        [
            VendorSourceRef::prusa_slicer_version_2_9_5(),
            VendorSourceRef::bambu_studio_v02_06_00_51(),
            VendorSourceRef::orca_slicer_v2_3_2(),
        ]
    );
    assert_eq!(
        provenance_vendors,
        [
            DownstreamFork::PrusaSlicer,
            DownstreamFork::BambuStudio,
            DownstreamFork::OrcaSlicer,
        ]
    );
    assert!(
        base_core
            .provenance
            .iter()
            .all(|provenance| provenance.ownership == FeatureOrigin::BaseSlic3r)
    );
}

#[test]
fn capability_metadata_covers_base_shared_and_fork_specific_origins() {
    // Arrange
    let expected_origins = [
        FeatureOrigin::BaseSlic3r,
        FeatureOrigin::SharedDownstream,
        FeatureOrigin::ForkSpecific,
    ];

    // Act
    let capabilities: Vec<&'static FlavorCapability> = all_capabilities().collect();

    // Assert
    for origin in expected_origins {
        assert!(
            capabilities
                .iter()
                .any(|capability| capability.origin == origin)
        );
    }
}

#[test]
fn capability_metadata_covers_all_current_checklist_statuses() {
    // Arrange
    let expected_statuses = [
        ChecklistStatus::NoActionBase,
        ChecklistStatus::FutureCandidate,
        ChecklistStatus::Deferred,
        ChecklistStatus::NeedsReview,
    ];

    // Act
    let capabilities: Vec<&'static FlavorCapability> = all_capabilities().collect();

    // Assert
    for status in expected_statuses {
        assert!(
            capabilities
                .iter()
                .any(|capability| capability.checklist_status == status)
        );
    }
}

// The current inventory has needs-review checklist rows but no source-backed
// unknown-needs-review ownership row, so the registry must not invent one.
#[test]
fn needs_review_rows_do_not_invent_unknown_origin_inventory_evidence() {
    // Arrange
    let maybe_calibration = maybe_capability("orcaslicer.calibration-flow");

    // Act
    let calibration = match maybe_calibration {
        Some(capability) => capability,
        None => {
            assert!(
                maybe_calibration.is_some(),
                "orcaslicer.calibration-flow capability missing"
            );
            return;
        }
    };
    let unknown_origin_inventory_ids: Vec<&'static str> = all_capabilities()
        .filter(|capability| capability.origin == FeatureOrigin::UnknownNeedsReview)
        .flat_map(|capability| capability.provenance.iter())
        .map(|provenance| provenance.inventory_id)
        .collect();

    // Assert
    assert_eq!(calibration.origin, FeatureOrigin::ForkSpecific);
    assert_eq!(calibration.checklist_status, ChecklistStatus::NeedsReview);
    assert_eq!(
        calibration.provenance[0].inventory_id,
        "orcaslicer.calibration-flow"
    );
    assert!(unknown_origin_inventory_ids.is_empty());
}

#[test]
fn shared_downstream_filter_returns_source_observed_project_file_row() {
    // Arrange
    let origin = FeatureOrigin::SharedDownstream;

    // Act
    let shared_capability_ids: Vec<&'static str> = capabilities_by_origin(origin)
        .map(|capability| capability.capability_id)
        .collect();

    // Assert
    assert_eq!(shared_capability_ids, ["prusaslicer.project-file"]);
}

#[test]
fn deferred_filter_returns_bambu_network_device_as_cautioned_metadata() {
    // Arrange
    let status = ChecklistStatus::Deferred;

    // Act
    let deferred_capabilities: Vec<&'static FlavorCapability> =
        capabilities_by_checklist_status(status).collect();
    let maybe_network_device = deferred_capabilities
        .iter()
        .copied()
        .find(|capability| capability.capability_id == "bambustudio.network-device");

    // Assert
    let network_device = match maybe_network_device {
        Some(capability) => capability,
        None => {
            assert!(
                maybe_network_device.is_some(),
                "bambustudio.network-device capability missing"
            );
            return;
        }
    };
    assert_eq!(network_device.origin, FeatureOrigin::ForkSpecific);
    assert!(network_device.parity_dependencies.is_empty());
    assert_eq!(
        network_device.caution_flags,
        [
            "network-scope",
            "cloud-scope",
            "credential-scope",
            "non-free-plugin-scope",
            "runtime-parity-not-verified",
        ]
    );
}

#[test]
fn runtime_claim_words_do_not_become_public_helper_names() {
    // Arrange
    let risky_words = [
        joined_word("veri", "fied"),
        joined_word("supp", "orted"),
        joined_word("dis", "patch"),
        joined_word("rel", "ease"),
    ];
    let public_helper_names = [
        "all_flavors",
        "maybe_flavor",
        "all_capabilities",
        "capabilities_by_origin",
        "capabilities_by_checklist_status",
    ];

    // Act
    let maybe_risky_helper = public_helper_names
        .iter()
        .find(|helper_name| risky_words.iter().any(|word| helper_name.contains(word)));

    // Assert
    assert!(maybe_risky_helper.is_none());
}

fn maybe_capability(capability_id: &str) -> Option<&'static FlavorCapability> {
    all_capabilities().find(|capability| capability.capability_id == capability_id)
}

fn joined_word(prefix: &str, suffix: &str) -> String {
    [prefix, suffix].concat()
}

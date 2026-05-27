use slic3r_contracts::{ChecklistStatus, FeatureOrigin, FlavorId, ParitySurface, VendorSourceRef};
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
    let parity_surface = ParitySurface::cli_version();
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
    assert_eq!(parity_surface.as_str(), "cli.version");
    assert_eq!(provenance.inventory_id, "prusaslicer.base-core");
}

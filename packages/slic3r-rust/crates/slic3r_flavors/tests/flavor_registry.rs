use slic3r_contracts::{
    ChecklistStatus, DownstreamFork, FeatureOrigin, FlavorId, ParitySurface, VendorSourceRef,
};
use slic3r_flavors::{
    FlavorCapability, FlavorProvenance, FlavorRegistryEntry, PrusaArcFittingReadiness,
    PrusaGcodeOutputSemanticReadiness, PrusaWallSeamReadiness, all_capabilities, all_flavors,
    capabilities_by_checklist_status, capabilities_by_origin, maybe_flavor,
    prusa_arc_fitting_metadata, prusa_arc_fitting_readiness, prusa_gcode_output_metadata,
    prusa_gcode_output_semantic_readiness, prusa_gcode_output_structural_readiness,
    prusa_profile_schema_metadata, prusa_project_file_metadata, prusa_wall_seam_metadata,
    prusa_wall_seam_readiness,
};

const PRUSA_GCODE_OUTPUT_SEMANTIC_READINESS_NOTES: &str = "Source-observed G-code output planning row; semantic summary parser/readiness metadata is available for Phase 55 developers, while public semantic parity evidence and status/docs publication remain Phase 56-owned before broader generated-output behavior is claimed. The broad generated-outputs surface stays in progress; no byte-for-byte G-code parity, printability, printer-runtime, support, seam, arc, GUI, release, sync, or non-Prusa fork behavior is claimed.";
const PRUSA_ARC_FITTING_READINESS_NOTES: &str = "Source-observed arc-fitting planning row; Phase 59 parser/readiness metadata is developer-facing only, while public executable evidence and status/docs publication remain Phase 60-owned. The broad generated-outputs surface stays in progress; no byte-for-byte G-code parity, broad generated-output verification, ArcWelder algorithm equivalence, tolerance or geometry parity, printability, firmware behavior, printer-runtime behavior, GUI behavior, support generation, wall seam behavior, release behavior, sync behavior, upstream import, host upload, network/device behavior, Bambu Studio, OrcaSlicer, or non-Prusa fork behavior is claimed.";

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
fn shared_downstream_filter_returns_source_observed_prusa_rows() {
    // Arrange
    let origin = FeatureOrigin::SharedDownstream;

    // Act
    let shared_capability_ids: Vec<&'static str> = capabilities_by_origin(origin)
        .map(|capability| capability.capability_id)
        .collect();

    // Assert
    assert_eq!(
        shared_capability_ids,
        [
            "prusaslicer.project-file",
            "prusaslicer.gcode-output",
            "prusaslicer.arc-fitting"
        ]
    );
}

#[test]
fn prusa_project_file_registry_row_traces_to_source_and_parity_dependency() {
    // Arrange
    let metadata = prusa_project_file_metadata();
    let maybe_project_file = maybe_capability(metadata.inventory_id);
    let expected_dependencies = [metadata.parity_dependency];

    // Act
    let project_file = match maybe_project_file {
        Some(capability) => capability,
        None => {
            assert!(
                maybe_project_file.is_some(),
                "prusaslicer.project-file capability missing"
            );
            return;
        }
    };

    // Assert
    assert_eq!(project_file.flavor_id, FlavorId::PrusaSlicer);
    assert_eq!(project_file.capability_id, metadata.inventory_id);
    assert_eq!(project_file.feature_surface, "project-file");
    assert_eq!(project_file.feature_category, "project-file");
    assert_eq!(project_file.origin, FeatureOrigin::SharedDownstream);
    assert_eq!(
        project_file.checklist_status,
        ChecklistStatus::FutureCandidate
    );
    assert_eq!(project_file.parity_dependencies, expected_dependencies);
    assert_eq!(project_file.provenance.len(), 1);
    assert_eq!(
        project_file.provenance[0].inventory_id,
        metadata.inventory_id
    );
    assert_eq!(
        project_file.provenance[0].vendor_source,
        metadata.source_ref
    );
    assert_eq!(
        project_file.provenance[0].vendor_source.as_str(),
        "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
    );
    assert_eq!(
        project_file.provenance[0].source_paths,
        [metadata.source_path]
    );
    assert_eq!(
        project_file.provenance[0].ownership,
        FeatureOrigin::SharedDownstream
    );
}

#[test]
fn prusa_project_file_metadata_exposes_fixture_scope_expected_summary_and_reserved_status() {
    // Arrange
    let metadata = prusa_project_file_metadata();

    // Act
    let source_ref = metadata.source_ref;

    // Assert
    assert_eq!(metadata.inventory_id, "prusaslicer.project-file");
    assert_eq!(metadata.vendor_id, "prusaslicer");
    assert_eq!(metadata.flavor_id, FlavorId::PrusaSlicer);
    assert_eq!(metadata.origin, FeatureOrigin::SharedDownstream);
    assert_eq!(metadata.parity_dependency, ParitySurface::file_formats());
    assert_eq!(metadata.checklist_status, ChecklistStatus::FutureCandidate);
    assert_eq!(source_ref, VendorSourceRef::prusa_slicer_version_2_9_5());
    assert_eq!(metadata.source_path, "src/libslic3r/Format/3mf.cpp");
    assert_eq!(
        metadata.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf"
    );
    assert_eq!(
        metadata.expected_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv"
    );
    assert_eq!(
        metadata.scope_record_path,
        "packages/prusa-project-file-scope/project-file-scope.md"
    );
    assert_eq!(
        metadata.reserved_future_status_token,
        "fork.prusaslicer.project-file"
    );
}

#[test]
fn prusa_gcode_output_registry_row_traces_to_source_and_generated_output_dependency() {
    // Arrange
    let metadata = prusa_gcode_output_metadata();
    let maybe_gcode_output = maybe_capability(metadata.inventory_id);
    let expected_dependencies = [metadata.parity_dependency];

    // Act
    let gcode_output = match maybe_gcode_output {
        Some(capability) => capability,
        None => {
            assert!(
                maybe_gcode_output.is_some(),
                "prusaslicer.gcode-output capability missing"
            );
            return;
        }
    };

    // Assert
    assert_eq!(gcode_output.flavor_id, FlavorId::PrusaSlicer);
    assert_eq!(gcode_output.capability_id, metadata.inventory_id);
    assert_eq!(gcode_output.feature_surface, "gcode-output");
    assert_eq!(gcode_output.feature_category, "gcode-output");
    assert_eq!(gcode_output.origin, FeatureOrigin::SharedDownstream);
    assert_eq!(
        gcode_output.checklist_status,
        ChecklistStatus::FutureCandidate
    );
    assert_eq!(gcode_output.parity_dependencies, expected_dependencies);
    assert_eq!(gcode_output.provenance.len(), 1);
    assert_eq!(
        gcode_output.provenance[0].inventory_id,
        metadata.inventory_id
    );
    assert_eq!(
        gcode_output.provenance[0].vendor_source,
        metadata.source_ref
    );
    assert_eq!(
        gcode_output.provenance[0].vendor_source.as_str(),
        "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
    );
    assert_eq!(
        gcode_output.provenance[0].source_paths,
        [metadata.source_path]
    );
    assert_eq!(
        gcode_output.provenance[0].ownership,
        FeatureOrigin::SharedDownstream
    );
    assert!(gcode_output.caution_flags.is_empty());
    assert_eq!(
        gcode_output.future_parity_notes,
        PRUSA_GCODE_OUTPUT_SEMANTIC_READINESS_NOTES
    );
    assert!(
        capabilities_by_checklist_status(ChecklistStatus::FutureCandidate)
            .any(|capability| capability.capability_id == gcode_output.capability_id)
    );
}

#[test]
fn prusa_gcode_output_metadata_exposes_fixture_scope_expected_summary_and_reserved_status() {
    // Arrange
    let metadata = prusa_gcode_output_metadata();

    // Act
    let source_ref = metadata.source_ref;

    // Assert
    assert_eq!(metadata.inventory_id, "prusaslicer.gcode-output");
    assert_eq!(metadata.vendor_id, "prusaslicer");
    assert_eq!(metadata.flavor_id, FlavorId::PrusaSlicer);
    assert_eq!(metadata.origin, FeatureOrigin::SharedDownstream);
    assert_eq!(
        metadata.parity_dependency,
        ParitySurface::generated_outputs()
    );
    assert_eq!(metadata.checklist_status, ChecklistStatus::FutureCandidate);
    assert_eq!(source_ref, VendorSourceRef::prusa_slicer_version_2_9_5());
    assert_eq!(metadata.source_path, "tests/fff_print/test_gcodewriter.cpp");
    assert_eq!(
        metadata.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode"
    );
    assert_eq!(
        metadata.expected_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"
    );
    assert_eq!(
        metadata.expected_structural_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv"
    );
    assert_eq!(
        metadata.expected_semantic_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
    );
    assert_eq!(
        metadata.scope_record_path,
        "packages/prusa-gcode-output-scope/gcode-output-scope.md"
    );
    assert_eq!(
        metadata.reserved_future_status_token,
        "fork.prusaslicer.gcode-output"
    );
}

#[test]
fn prusa_gcode_output_semantic_readiness_exposes_published_semantic_boundary() {
    // Arrange
    let expected_source_paths: &[&str] = &["src/libslic3r/GCode.cpp", "src/libslic3r/GCode.hpp"];
    let expected_deferred_surfaces = [
        "byte-for-byte G-code parity",
        "broad generated-output verification",
        "toolpath geometry parity",
        "printability",
        "printer-runtime behavior",
        "support generation",
        "wall seam behavior",
        "arc fitting",
        "GUI export/viewer behavior",
        "release behavior",
        "network/device behavior",
        "non-Prusa fork behavior",
        "upstream source imports",
        "sync automation",
    ];

    // Act
    let readiness: PrusaGcodeOutputSemanticReadiness = prusa_gcode_output_semantic_readiness();

    // Assert
    assert_eq!(readiness.inventory_id, "prusaslicer.gcode-output");
    assert_eq!(
        readiness.source_ref,
        VendorSourceRef::prusa_slicer_version_2_9_5()
    );
    assert_eq!(readiness.inventory_source_paths, expected_source_paths);
    assert_eq!(
        readiness.fixture_corpus_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output"
    );
    assert_eq!(
        readiness.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode"
    );
    assert_eq!(
        readiness.expected_semantic_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv"
    );
    assert_eq!(
        readiness.parser_boundary,
        "slic3r_flavors::prusa_gcode_output::parse_prusa_gcode_output_semantic_summary"
    );
    assert_eq!(
        readiness.public_command,
        "//packages/parity:prusaslicer_gcode_output_parity"
    );
    assert_eq!(readiness.status_token, "fork.prusaslicer.gcode-output");
    assert_eq!(readiness.generated_outputs_status, "in progress");
    assert_eq!(
        readiness.publication_boundary,
        "Phase 56 publishes the narrow semantic Prusa G-code evidence slice through //packages/parity:prusaslicer_gcode_output_parity and fork.prusaslicer.gcode-output; broad generated-outputs remains in progress."
    );
    assert_eq!(readiness.deferred_surfaces, expected_deferred_surfaces);
}

#[test]
fn prusa_arc_fitting_metadata_exposes_fixture_scope_expected_summary_and_reserved_status() {
    // Arrange
    let metadata = prusa_arc_fitting_metadata();

    // Act
    let source_ref = metadata.source_ref;

    // Assert
    assert_eq!(metadata.inventory_id, "prusaslicer.arc-fitting");
    assert_eq!(metadata.vendor_id, "prusaslicer");
    assert_eq!(metadata.flavor_id, FlavorId::PrusaSlicer);
    assert_eq!(metadata.origin, FeatureOrigin::SharedDownstream);
    assert_eq!(
        metadata.parity_dependency,
        ParitySurface::generated_outputs()
    );
    assert_eq!(metadata.checklist_status, ChecklistStatus::FutureCandidate);
    assert_eq!(source_ref, VendorSourceRef::prusa_slicer_version_2_9_5());
    assert_eq!(metadata.source_path, "src/libslic3r/Geometry/ArcWelder.cpp");
    assert_eq!(
        metadata.fixture_corpus_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting"
    );
    assert_eq!(
        metadata.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode"
    );
    assert_eq!(
        metadata.expected_arc_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
    );
    assert_eq!(
        metadata.scope_record_path,
        "packages/prusa-arc-fitting-scope/arc-fitting-scope.md"
    );
    assert_eq!(
        metadata.reserved_future_status_token,
        "fork.prusaslicer.arc-fitting"
    );
}

#[test]
fn prusa_arc_fitting_readiness_exposes_pre_publication_boundary() {
    // Arrange
    let expected_source_paths: &[&str] = &[
        "packages/fork-inventories/prusaslicer.tsv",
        "src/libslic3r/Geometry/ArcWelder.cpp",
    ];
    let expected_source_anchors: &[&str] = &[
        "ArcWelder.cpp#L4-L7",
        "ArcWelder.cpp#L400-L404",
        "ArcWelder.cpp#L630-L634",
    ];
    let expected_deferred_surfaces = [
        "byte-for-byte G-code parity",
        "broad generated-output verification",
        "ArcWelder algorithm equivalence",
        "tolerance or geometry parity",
        "printability",
        "firmware behavior",
        "printer-runtime behavior",
        "GUI behavior",
        "support generation",
        "wall seam behavior",
        "release behavior",
        "host upload",
        "network/device behavior",
        "upstream source imports",
        "sync automation",
        "Bambu Studio",
        "OrcaSlicer",
        "non-Prusa fork behavior",
    ];

    // Act
    let readiness: PrusaArcFittingReadiness = prusa_arc_fitting_readiness();

    // Assert
    assert_eq!(readiness.inventory_id, "prusaslicer.arc-fitting");
    assert_eq!(
        readiness.source_ref,
        VendorSourceRef::prusa_slicer_version_2_9_5()
    );
    assert_eq!(readiness.inventory_source_paths, expected_source_paths);
    assert_eq!(readiness.source_anchors, expected_source_anchors);
    assert_eq!(
        readiness.fixture_corpus_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting"
    );
    assert_eq!(
        readiness.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode"
    );
    assert_eq!(
        readiness.expected_arc_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
    );
    assert_eq!(
        readiness.scope_record_path,
        "packages/prusa-arc-fitting-scope/arc-fitting-scope.md"
    );
    assert_eq!(
        readiness.parser_boundary,
        "slic3r_flavors::prusa_arc_fitting::parse_prusa_arc_fitting_summary"
    );
    assert_eq!(
        readiness.planned_public_command,
        "//packages/parity:prusaslicer_arc_fitting_parity"
    );
    assert_eq!(
        readiness.planned_status_token,
        "fork.prusaslicer.arc-fitting"
    );
    assert_eq!(readiness.generated_outputs_status, "in progress");
    assert_eq!(
        readiness.publication_boundary,
        "Phase 59 parser/readiness only; Phase 60 owns public executable evidence and status/docs publication."
    );
    assert_eq!(readiness.deferred_surfaces, expected_deferred_surfaces);
}

#[test]
fn prusa_wall_seam_metadata_exposes_fixture_scope_expected_summary_and_reserved_status() {
    // Arrange
    let metadata = prusa_wall_seam_metadata();

    // Act
    let source_ref = metadata.source_ref;

    // Assert
    assert_eq!(metadata.inventory_id, "prusaslicer.wall-seam");
    assert_eq!(metadata.vendor_id, "prusaslicer");
    assert_eq!(metadata.flavor_id, FlavorId::PrusaSlicer);
    assert_eq!(metadata.origin, FeatureOrigin::SharedDownstream);
    assert_eq!(
        metadata.parity_dependency,
        ParitySurface::generated_outputs()
    );
    assert_eq!(metadata.checklist_status, ChecklistStatus::FutureCandidate);
    assert_eq!(source_ref, VendorSourceRef::prusa_slicer_version_2_9_5());
    assert_eq!(metadata.source_path, "src/libslic3r/GCode/SeamAligned.cpp");
    assert_eq!(
        metadata.fixture_corpus_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam"
    );
    assert_eq!(
        metadata.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/wall-seam-observations.gcode"
    );
    assert_eq!(
        metadata.expected_wall_seam_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv"
    );
    assert_eq!(
        metadata.scope_record_path,
        "packages/prusa-wall-seam-scope/wall-seam-scope.md"
    );
    assert_eq!(
        metadata.reserved_future_status_token,
        "fork.prusaslicer.wall-seam"
    );
}

#[test]
fn prusa_wall_seam_readiness_exposes_pre_publication_boundary() {
    // Arrange
    let expected_source_paths: &[&str] = &[
        "packages/fork-inventories/prusaslicer.tsv",
        "src/libslic3r/GCode/SeamAligned.cpp",
    ];
    let expected_source_anchors: &[&str] = &[
        "SeamAligned.cpp#L16",
        "SeamAligned.cpp#L115-L148",
        "SeamAligned.cpp#L272-L313",
        "SeamAligned.cpp#L463-L525",
    ];
    let expected_deferred_surfaces = [
        "byte-for-byte G-code parity",
        "broad generated-output verification",
        "full wall-seam algorithm equivalence",
        "wall-seam geometry equivalence",
        "seam visibility",
        "printability",
        "firmware behavior",
        "printer-runtime behavior",
        "GUI behavior",
        "support generation",
        "STEP import",
        "full 3MF import/export",
        "binary G-code",
        "thumbnails",
        "post-processing",
        "host upload",
        "network/device behavior",
        "profile auto-update execution",
        "fork release builds",
        "Bambu Studio",
        "OrcaSlicer",
        "upstream source imports",
        "release behavior",
        "sync automation",
        "non-Prusa fork behavior",
    ];

    // Act
    let readiness: PrusaWallSeamReadiness = prusa_wall_seam_readiness();

    // Assert
    assert_eq!(readiness.inventory_id, "prusaslicer.wall-seam");
    assert_eq!(
        readiness.source_ref,
        VendorSourceRef::prusa_slicer_version_2_9_5()
    );
    assert_eq!(readiness.inventory_source_paths, expected_source_paths);
    assert_eq!(readiness.source_anchors, expected_source_anchors);
    assert_eq!(
        readiness.fixture_corpus_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam"
    );
    assert_eq!(
        readiness.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/wall-seam-observations.gcode"
    );
    assert_eq!(
        readiness.expected_wall_seam_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv"
    );
    assert_eq!(
        readiness.scope_record_path,
        "packages/prusa-wall-seam-scope/wall-seam-scope.md"
    );
    assert_eq!(
        readiness.parser_boundary,
        "slic3r_flavors::prusa_wall_seam::parse_prusa_wall_seam_summary"
    );
    assert_eq!(
        readiness.planned_public_command,
        "//packages/parity:prusaslicer_wall_seam_parity"
    );
    assert_eq!(readiness.planned_status_token, "fork.prusaslicer.wall-seam");
    assert_eq!(readiness.generated_outputs_status, "in progress");
    assert_eq!(
        readiness.publication_boundary,
        "Phase 64 parser/readiness only; Phase 65 owns public executable evidence and status/docs publication."
    );
    assert_eq!(readiness.deferred_surfaces, expected_deferred_surfaces);
}

#[test]
fn prusa_wall_seam_helper_names_do_not_claim_deferred_surfaces() {
    // Arrange
    let risky_words = [
        "byte",
        "parity",
        "verified",
        "printability",
        "runtime",
        "support",
        "gui",
        "release",
        "sync",
        "executable",
        "arc",
        "non_prusa",
    ];
    let public_helper_names = [
        "prusa_wall_seam_metadata",
        "prusa_wall_seam_readiness",
        "parse_prusa_wall_seam_summary",
        "prusa_wall_seam_summary_lines",
    ];

    // Act
    let maybe_risky_helper = public_helper_names
        .iter()
        .find(|helper_name| risky_words.iter().any(|word| helper_name.contains(word)));

    // Assert
    assert!(maybe_risky_helper.is_none());
}

#[test]
fn prusa_arc_fitting_registry_row_traces_to_source_and_generated_output_dependency() {
    // Arrange
    let metadata = prusa_arc_fitting_metadata();
    let maybe_arc_fitting = maybe_capability(metadata.inventory_id);
    let expected_dependencies = [metadata.parity_dependency];

    // Act
    let arc_fitting = match maybe_arc_fitting {
        Some(capability) => capability,
        None => {
            assert!(
                maybe_arc_fitting.is_some(),
                "prusaslicer.arc-fitting capability missing"
            );
            return;
        }
    };

    // Assert
    assert_eq!(arc_fitting.flavor_id, FlavorId::PrusaSlicer);
    assert_eq!(arc_fitting.capability_id, metadata.inventory_id);
    assert_eq!(arc_fitting.feature_surface, "arc-fitting");
    assert_eq!(arc_fitting.feature_category, "arc-fitting");
    assert_eq!(arc_fitting.origin, FeatureOrigin::SharedDownstream);
    assert_eq!(
        arc_fitting.checklist_status,
        ChecklistStatus::FutureCandidate
    );
    assert_eq!(arc_fitting.parity_dependencies, expected_dependencies);
    assert_eq!(arc_fitting.provenance.len(), 1);
    assert_eq!(
        arc_fitting.provenance[0].inventory_id,
        metadata.inventory_id
    );
    assert_eq!(arc_fitting.provenance[0].vendor_source, metadata.source_ref);
    assert_eq!(
        arc_fitting.provenance[0].source_paths,
        [metadata.source_path]
    );
    assert_eq!(
        arc_fitting.provenance[0].ownership,
        FeatureOrigin::SharedDownstream
    );
    assert!(arc_fitting.caution_flags.is_empty());
    assert_eq!(
        arc_fitting.future_parity_notes,
        PRUSA_ARC_FITTING_READINESS_NOTES
    );
}

#[test]
fn prusa_gcode_output_structural_readiness_exposes_parser_metadata_without_status_publication() {
    // Arrange
    let expected_source_paths: &[&str] = &["src/libslic3r/GCode.cpp", "src/libslic3r/GCode.hpp"];

    // Act
    let readiness = prusa_gcode_output_structural_readiness();

    // Assert
    assert_eq!(readiness.inventory_id, "prusaslicer.gcode-output");
    assert_eq!(
        readiness.source_ref,
        VendorSourceRef::prusa_slicer_version_2_9_5()
    );
    assert_eq!(readiness.inventory_source_paths, expected_source_paths);
    assert_eq!(
        readiness.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode"
    );
    assert_eq!(
        readiness.expected_structural_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv"
    );
    assert_eq!(
        readiness.parser_boundary,
        "slic3r_flavors::prusa_gcode_output::parse_prusa_gcode_output_structural_summary"
    );
    assert_eq!(
        readiness.parity_dependency,
        ParitySurface::generated_outputs()
    );
    assert_eq!(readiness.checklist_status, ChecklistStatus::FutureCandidate);
    assert_eq!(
        readiness.reserved_future_status_token,
        "fork.prusaslicer.gcode-output"
    );
}

#[test]
fn prusa_profile_schema_registry_row_traces_to_source_and_parity_dependencies() {
    // Arrange
    let maybe_profile_schema = maybe_capability("prusaslicer.profile-schema");
    let expected_dependencies = [ParitySurface::config(), ParitySurface::config_persistence()];

    // Act
    let profile_schema = match maybe_profile_schema {
        Some(capability) => capability,
        None => {
            assert!(
                maybe_profile_schema.is_some(),
                "prusaslicer.profile-schema capability missing"
            );
            return;
        }
    };

    // Assert
    assert_eq!(profile_schema.flavor_id, FlavorId::PrusaSlicer);
    assert_eq!(profile_schema.capability_id, "prusaslicer.profile-schema");
    assert_eq!(profile_schema.feature_surface, "profile-schema");
    assert_eq!(profile_schema.feature_category, "profile-schema");
    assert_eq!(profile_schema.origin, FeatureOrigin::ForkSpecific);
    assert_eq!(
        profile_schema.checklist_status,
        ChecklistStatus::FutureCandidate
    );
    assert_eq!(profile_schema.parity_dependencies, expected_dependencies);
    assert_eq!(profile_schema.provenance.len(), 1);
    assert_eq!(
        profile_schema.provenance[0].inventory_id,
        "prusaslicer.profile-schema"
    );
    assert_eq!(
        profile_schema.provenance[0].vendor_source,
        VendorSourceRef::prusa_slicer_version_2_9_5()
    );
    assert_eq!(
        profile_schema.provenance[0].vendor_source.as_str(),
        "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
    );
    assert_eq!(
        profile_schema.provenance[0].source_paths,
        ["resources/profiles/PrusaResearch.ini"]
    );
    assert_eq!(
        profile_schema.provenance[0].ownership,
        FeatureOrigin::ForkSpecific
    );
}

#[test]
fn prusa_profile_schema_metadata_exposes_fixture_checklist_and_reserved_status() {
    // Arrange
    let metadata = prusa_profile_schema_metadata();

    // Act
    let source_ref = metadata.source_ref;

    // Assert
    assert_eq!(metadata.inventory_id, "prusaslicer.profile-schema");
    assert_eq!(metadata.vendor_id, "prusaslicer");
    assert_eq!(metadata.flavor_display, "PrusaSlicer");
    assert_eq!(source_ref, VendorSourceRef::prusa_slicer_version_2_9_5());
    assert_eq!(metadata.source_path, "resources/profiles/PrusaResearch.ini");
    assert_eq!(
        metadata.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini"
    );
    assert_eq!(
        metadata.checklist_path,
        "packages/prusa-baseline/profile-schema-checklist.md"
    );
    assert_eq!(
        metadata.reserved_future_status_token,
        "fork.prusaslicer.profile-schema"
    );
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
fn future_candidate_filter_includes_prusa_gcode_output_boundary_row() {
    // Arrange
    let status = ChecklistStatus::FutureCandidate;

    // Act
    let future_candidate_ids: Vec<&'static str> = capabilities_by_checklist_status(status)
        .map(|capability| capability.capability_id)
        .collect();

    // Assert
    assert!(
        future_candidate_ids.contains(&"prusaslicer.gcode-output"),
        "FutureCandidate filter should include the Phase 47 Prusa G-code summary boundary row"
    );
}

#[test]
fn future_candidate_filter_includes_prusa_arc_fitting_boundary_row() {
    // Arrange
    let status = ChecklistStatus::FutureCandidate;

    // Act
    let future_candidate_ids: Vec<&'static str> = capabilities_by_checklist_status(status)
        .map(|capability| capability.capability_id)
        .collect();

    // Assert
    assert!(
        future_candidate_ids.contains(&"prusaslicer.gcode-output"),
        "FutureCandidate filter should retain the Prusa G-code summary boundary row"
    );
    assert!(
        future_candidate_ids.contains(&"prusaslicer.arc-fitting"),
        "FutureCandidate filter should include the Phase 59 Prusa arc-fitting boundary row"
    );
}

#[test]
fn runtime_claim_words_do_not_become_public_helper_names() {
    // Arrange
    let risky_words = [
        joined_word("veri", "fied"),
        joined_word("supp", "orted"),
        "runtime".to_owned(),
        joined_word("dis", "patch"),
        joined_word("rel", "ease"),
        "executable".to_owned(),
    ];
    let profile_schema_metadata = prusa_profile_schema_metadata();
    let project_file_metadata = prusa_project_file_metadata();
    let gcode_output_metadata = prusa_gcode_output_metadata();
    let gcode_output_readiness = prusa_gcode_output_structural_readiness();
    let arc_fitting_metadata = prusa_arc_fitting_metadata();
    let arc_fitting_readiness = prusa_arc_fitting_readiness();
    let public_helper_names = [
        "all_flavors",
        "maybe_flavor",
        "all_capabilities",
        "capabilities_by_origin",
        "capabilities_by_checklist_status",
        "prusa_profile_schema_metadata",
        "prusa_project_file_metadata",
        "prusa_gcode_output_metadata",
        "prusa_gcode_output_semantic_readiness",
        "prusa_gcode_output_structural_readiness",
        "parse_prusa_gcode_output_summary",
        "prusa_gcode_output_summary_lines",
        "prusa_arc_fitting_metadata",
        "prusa_arc_fitting_readiness",
        "parse_prusa_arc_fitting_summary",
        "prusa_arc_fitting_summary_lines",
    ];
    let metadata_values = [
        profile_schema_metadata.inventory_id,
        profile_schema_metadata.vendor_id,
        profile_schema_metadata.flavor_display,
        profile_schema_metadata.source_path,
        profile_schema_metadata.fixture_path,
        profile_schema_metadata.checklist_path,
        profile_schema_metadata.reserved_future_status_token,
        project_file_metadata.inventory_id,
        project_file_metadata.vendor_id,
        project_file_metadata.flavor_id.as_str(),
        project_file_metadata.origin.as_str(),
        project_file_metadata.parity_dependency.as_str(),
        project_file_metadata.checklist_status.as_str(),
        project_file_metadata.source_ref.as_str(),
        project_file_metadata.source_path,
        project_file_metadata.fixture_path,
        project_file_metadata.expected_summary_path,
        project_file_metadata.scope_record_path,
        project_file_metadata.reserved_future_status_token,
        gcode_output_metadata.inventory_id,
        gcode_output_metadata.vendor_id,
        gcode_output_metadata.flavor_id.as_str(),
        gcode_output_metadata.origin.as_str(),
        gcode_output_metadata.parity_dependency.as_str(),
        gcode_output_metadata.checklist_status.as_str(),
        gcode_output_metadata.source_ref.as_str(),
        gcode_output_metadata.source_path,
        gcode_output_metadata.fixture_path,
        gcode_output_metadata.expected_summary_path,
        gcode_output_metadata.expected_structural_summary_path,
        gcode_output_metadata.scope_record_path,
        gcode_output_metadata.reserved_future_status_token,
        gcode_output_readiness.inventory_id,
        gcode_output_readiness.source_ref.as_str(),
        gcode_output_readiness.fixture_path,
        gcode_output_readiness.expected_structural_summary_path,
        gcode_output_readiness.parser_boundary,
        gcode_output_readiness.parity_dependency.as_str(),
        gcode_output_readiness.checklist_status.as_str(),
        gcode_output_readiness.reserved_future_status_token,
        arc_fitting_metadata.inventory_id,
        arc_fitting_metadata.vendor_id,
        arc_fitting_metadata.flavor_id.as_str(),
        arc_fitting_metadata.origin.as_str(),
        arc_fitting_metadata.parity_dependency.as_str(),
        arc_fitting_metadata.checklist_status.as_str(),
        arc_fitting_metadata.source_ref.as_str(),
        arc_fitting_metadata.source_path,
        arc_fitting_metadata.fixture_corpus_path,
        arc_fitting_metadata.fixture_path,
        arc_fitting_metadata.expected_arc_summary_path,
        arc_fitting_metadata.scope_record_path,
        arc_fitting_metadata.reserved_future_status_token,
        arc_fitting_readiness.inventory_id,
        arc_fitting_readiness.source_ref.as_str(),
        arc_fitting_readiness.fixture_corpus_path,
        arc_fitting_readiness.fixture_path,
        arc_fitting_readiness.expected_arc_summary_path,
        arc_fitting_readiness.scope_record_path,
        arc_fitting_readiness.parser_boundary,
        arc_fitting_readiness.planned_status_token,
        arc_fitting_readiness.generated_outputs_status,
    ];

    // Act
    let maybe_risky_helper = public_helper_names
        .iter()
        .find(|helper_name| risky_words.iter().any(|word| helper_name.contains(word)));
    let maybe_risky_metadata_value = metadata_values
        .iter()
        .find(|metadata_value| risky_words.iter().any(|word| metadata_value.contains(word)));

    // Assert
    assert!(maybe_risky_helper.is_none());
    assert!(maybe_risky_metadata_value.is_none());
}

#[test]
fn prusa_gcode_output_registry_notes_negate_deferred_semantic_surfaces() {
    // Arrange
    let note = PRUSA_GCODE_OUTPUT_SEMANTIC_READINESS_NOTES;
    let required_deferrals = [
        "no byte-for-byte G-code parity",
        "printability",
        "printer-runtime",
        "support",
        "seam",
        "arc",
        "GUI",
        "release",
        "sync",
        "non-Prusa fork behavior",
    ];

    // Act
    let maybe_missing_deferral = required_deferrals
        .iter()
        .find(|deferral| !note.contains(*deferral));

    // Assert
    assert!(maybe_missing_deferral.is_none());
    assert!(note.contains("broad generated-outputs surface stays in progress"));
    assert!(note.contains("status/docs publication remain Phase 56-owned"));
}

#[test]
fn prusa_arc_fitting_registry_notes_negate_deferred_surfaces() {
    // Arrange
    let note = PRUSA_ARC_FITTING_READINESS_NOTES;
    let required_deferrals = [
        "public executable evidence and status/docs publication remain Phase 60-owned",
        "broad generated-outputs surface stays in progress",
        "no byte-for-byte G-code parity",
        "broad generated-output verification",
        "ArcWelder algorithm equivalence",
        "tolerance or geometry parity",
        "printability",
        "firmware behavior",
        "printer-runtime behavior",
        "GUI behavior",
        "support generation",
        "wall seam behavior",
        "release behavior",
        "sync behavior",
        "upstream import",
        "host upload",
        "network/device behavior",
        "Bambu Studio",
        "OrcaSlicer",
        "non-Prusa fork behavior",
    ];

    // Act
    let maybe_missing_deferral = required_deferrals
        .iter()
        .find(|deferral| !note.contains(*deferral));

    // Assert
    assert!(maybe_missing_deferral.is_none());
    assert!(note.contains("Phase 59 parser/readiness metadata is developer-facing only"));
}

fn maybe_capability(capability_id: &str) -> Option<&'static FlavorCapability> {
    all_capabilities().find(|capability| capability.capability_id == capability_id)
}

fn joined_word(prefix: &str, suffix: &str) -> String {
    [prefix, suffix].concat()
}

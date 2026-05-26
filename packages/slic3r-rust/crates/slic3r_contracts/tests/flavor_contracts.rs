use std::convert::TryFrom;
use std::str::FromStr;

use slic3r_contracts::{
    ChecklistStatus, DownstreamFork, FeatureOrigin, FlavorId, ParitySurface, VendorSourceRef,
    VendorSourceRefParseError,
};

#[test]
fn downstream_forks_parse_display_and_reject_noncanonical_tokens() {
    // Arrange
    let accepted = [
        ("prusaslicer", DownstreamFork::PrusaSlicer),
        ("bambustudio", DownstreamFork::BambuStudio),
        ("orcaslicer", DownstreamFork::OrcaSlicer),
    ];
    let rejected = ["bambu-studio", "BambuStudio", "base-slic3r"];

    // Act
    let parsed = accepted.map(|(token, expected)| {
        (
            token,
            expected,
            DownstreamFork::from_str(token),
            DownstreamFork::try_from(token),
        )
    });

    // Assert
    for (token, expected, from_str_result, try_from_result) in parsed {
        assert_eq!(from_str_result, Ok(expected));
        assert_eq!(try_from_result, Ok(expected));
        assert_eq!(expected.as_str(), token);
        assert_eq!(expected.to_string(), token);
    }
    for token in rejected {
        assert!(DownstreamFork::from_str(token).is_err());
    }
}

#[test]
fn flavor_ids_parse_display_and_keep_base_distinct_from_downstream_forks() {
    // Arrange
    let accepted = [
        ("base-slic3r", FlavorId::BaseSlic3r, None),
        (
            "prusaslicer",
            FlavorId::PrusaSlicer,
            Some(DownstreamFork::PrusaSlicer),
        ),
        (
            "bambustudio",
            FlavorId::BambuStudio,
            Some(DownstreamFork::BambuStudio),
        ),
        (
            "orcaslicer",
            FlavorId::OrcaSlicer,
            Some(DownstreamFork::OrcaSlicer),
        ),
    ];

    // Act
    let parsed = accepted.map(|(token, expected, maybe_expected_fork)| {
        (
            token,
            expected,
            maybe_expected_fork,
            FlavorId::from_str(token),
            FlavorId::try_from(token),
        )
    });

    // Assert
    for (token, expected, maybe_expected_fork, from_str_result, try_from_result) in parsed {
        assert_eq!(from_str_result, Ok(expected));
        assert_eq!(try_from_result, Ok(expected));
        assert_eq!(expected.as_str(), token);
        assert_eq!(expected.to_string(), token);
        assert_eq!(expected.maybe_downstream_fork(), maybe_expected_fork);
    }
    assert!(DownstreamFork::from_str("base-slic3r").is_err());
    assert_eq!(FlavorId::BaseSlic3r.maybe_downstream_fork(), None);
}

#[test]
fn vendor_source_refs_parse_only_canonical_phase_32_pins() {
    // Arrange
    let accepted = [
        (
            "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961",
            VendorSourceRef::prusa_slicer_version_2_9_5(),
            DownstreamFork::PrusaSlicer,
            "version_2.9.5",
            "9a583bd438b195856f3bcf7ea99b69ba4003a961",
        ),
        (
            "bambustudio:v02.06.00.51@b506005bc4ee62124e24bf00e0f58656db3646a6",
            VendorSourceRef::bambu_studio_v02_06_00_51(),
            DownstreamFork::BambuStudio,
            "v02.06.00.51",
            "b506005bc4ee62124e24bf00e0f58656db3646a6",
        ),
        (
            "orcaslicer:v2.3.2@c724a3f5f51c52336624b689e846c8fbc943a912",
            VendorSourceRef::orca_slicer_v2_3_2(),
            DownstreamFork::OrcaSlicer,
            "v2.3.2",
            "c724a3f5f51c52336624b689e846c8fbc943a912",
        ),
    ];

    // Act
    let parsed = accepted.map(
        |(token, expected, expected_vendor, expected_tag, expected_commit)| {
            (
                token,
                expected,
                expected_vendor,
                expected_tag,
                expected_commit,
                VendorSourceRef::from_str(token),
                VendorSourceRef::try_from(token),
            )
        },
    );

    // Assert
    for (
        token,
        expected,
        expected_vendor,
        expected_tag,
        expected_commit,
        from_str_result,
        try_from_result,
    ) in parsed
    {
        assert_eq!(from_str_result, Ok(expected));
        assert_eq!(try_from_result, Ok(expected));
        assert_eq!(expected.as_str(), token);
        assert_eq!(expected.to_string(), token);
        assert_eq!(expected.vendor(), expected_vendor);
        assert_eq!(expected.selected_tag(), expected_tag);
        assert_eq!(expected.peeled_commit(), expected_commit);
    }
}

#[test]
fn vendor_source_refs_reject_branch_heads_and_malformed_source_refs() {
    // Arrange
    let rejected = [
        "prusaslicer:master@43f3cdb1a6f25ee8627f5f20b9a21f3e62c6ad9b",
        "bambustudio:master@e150b502b3d2afc98b83dcc9e5720e998f9eb79a",
        "orcaslicer:main@e0c4d11baefa328331be113533c47ee89fda16c6",
        "bambustudio:branch-main@e150b502b3d2afc98b83dcc9e5720e998f9eb79a",
        "prusaslicer:version_2.9.5@9A583bd438b195856f3bcf7ea99b69ba4003a961",
        "prusaslicer:version_2.9.5@9a583bd",
        "prusaslicer-version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961",
        "prusaslicer:version_2.9.59a583bd438b195856f3bcf7ea99b69ba4003a961",
        "prusaslicer:@9a583bd438b195856f3bcf7ea99b69ba4003a961",
        "superslicer:v1.0.0@9a583bd438b195856f3bcf7ea99b69ba4003a961",
    ];
    let branch_main = "bambustudio:branch-main@e150b502b3d2afc98b83dcc9e5720e998f9eb79a";

    // Act
    let rejected_results = rejected.map(VendorSourceRef::from_str);
    let branch_main_result = VendorSourceRef::from_str(branch_main);

    // Assert
    for result in rejected_results {
        assert!(result.is_err());
    }
    assert_eq!(
        branch_main_result,
        Err(VendorSourceRefParseError::UnknownSourcePin {
            value: branch_main.to_owned()
        })
    );
}

#[test]
fn feature_origins_parse_display_and_reject_prose_labels() {
    // Arrange
    let accepted = [
        ("base-slic3r", FeatureOrigin::BaseSlic3r),
        ("shared-downstream", FeatureOrigin::SharedDownstream),
        ("fork-specific", FeatureOrigin::ForkSpecific),
        ("unknown-needs-review", FeatureOrigin::UnknownNeedsReview),
    ];
    let rejected = ["Base Slic3r", "shared downstream", "needs review"];

    // Act
    let parsed = accepted.map(|(token, expected)| {
        (
            token,
            expected,
            FeatureOrigin::from_str(token),
            FeatureOrigin::try_from(token),
        )
    });

    // Assert
    for (token, expected, from_str_result, try_from_result) in parsed {
        assert_eq!(from_str_result, Ok(expected));
        assert_eq!(try_from_result, Ok(expected));
        assert_eq!(expected.as_str(), token);
        assert_eq!(expected.to_string(), token);
    }
    for token in rejected {
        assert!(FeatureOrigin::from_str(token).is_err());
    }
}

#[test]
fn parity_surfaces_parse_display_and_reject_non_surface_tokens() {
    // Arrange
    let accepted = [
        "cli.version",
        "cli.help",
        "cli.other",
        "export.workflows",
        "transform.workflows",
        "linux.runtime",
        "windows.runtime",
        "linux.packaged-launcher",
        "windows.packaged-launcher",
        "config",
        "config.persistence",
        "file-formats",
        "generated-outputs",
        "launcher-packaging",
    ];
    let rejected = ["fork-runtime", "cli.fork", "verified"];

    // Act
    let parsed = accepted.map(|token| {
        (
            token,
            ParitySurface::from_str(token),
            ParitySurface::try_from(token),
        )
    });

    // Assert
    for (token, from_str_result, try_from_result) in parsed {
        assert_eq!(from_str_result, try_from_result);
        assert_eq!(from_str_result.map(|surface| surface.as_str()), Ok(token));
        assert_eq!(
            ParitySurface::try_from(token).map(|surface| surface.to_string()),
            Ok(token.to_owned())
        );
    }
    for token in rejected {
        assert!(ParitySurface::from_str(token).is_err());
    }
}

#[test]
fn checklist_statuses_parse_display_and_reject_executable_parity_words() {
    // Arrange
    let accepted = [
        ("future-candidate", ChecklistStatus::FutureCandidate),
        ("deferred", ChecklistStatus::Deferred),
        ("no-action-base", ChecklistStatus::NoActionBase),
        ("needs-review", ChecklistStatus::NeedsReview),
    ];
    let rejected = ["verified", "supported"];

    // Act
    let parsed = accepted.map(|(token, expected)| {
        (
            token,
            expected,
            ChecklistStatus::from_str(token),
            ChecklistStatus::try_from(token),
        )
    });

    // Assert
    for (token, expected, from_str_result, try_from_result) in parsed {
        assert_eq!(from_str_result, Ok(expected));
        assert_eq!(try_from_result, Ok(expected));
        assert_eq!(expected.as_str(), token);
        assert_eq!(expected.to_string(), token);
    }
    for token in rejected {
        assert!(ChecklistStatus::from_str(token).is_err());
    }
}

#[derive(Debug, PartialEq, Eq)]
struct ContractBoundarySnapshot {
    downstream_fork: DownstreamFork,
    flavor_id: FlavorId,
    maybe_flavor_fork: Option<DownstreamFork>,
    source_ref: VendorSourceRef,
    feature_origin: FeatureOrigin,
    parity_surface: ParitySurface,
    checklist_status: ChecklistStatus,
}

fn collect_contract_boundary_snapshot(
    downstream_fork: DownstreamFork,
    flavor_id: FlavorId,
    source_ref: VendorSourceRef,
    feature_origin: FeatureOrigin,
    parity_surface: ParitySurface,
    checklist_status: ChecklistStatus,
) -> ContractBoundarySnapshot {
    ContractBoundarySnapshot {
        downstream_fork,
        flavor_id,
        maybe_flavor_fork: flavor_id.maybe_downstream_fork(),
        source_ref,
        feature_origin,
        parity_surface,
        checklist_status,
    }
}

#[test]
fn typed_values_cross_example_core_boundary_without_raw_vendor_strings() {
    // Arrange
    let cases = [
        (
            DownstreamFork::PrusaSlicer,
            FlavorId::BaseSlic3r,
            VendorSourceRef::prusa_slicer_version_2_9_5(),
            FeatureOrigin::BaseSlic3r,
            ParitySurface::try_from("config"),
            ChecklistStatus::NoActionBase,
            None,
        ),
        (
            DownstreamFork::BambuStudio,
            FlavorId::BambuStudio,
            VendorSourceRef::bambu_studio_v02_06_00_51(),
            FeatureOrigin::SharedDownstream,
            ParitySurface::try_from("file-formats"),
            ChecklistStatus::FutureCandidate,
            Some(DownstreamFork::BambuStudio),
        ),
        (
            DownstreamFork::OrcaSlicer,
            FlavorId::OrcaSlicer,
            VendorSourceRef::orca_slicer_v2_3_2(),
            FeatureOrigin::ForkSpecific,
            ParitySurface::try_from("launcher-packaging"),
            ChecklistStatus::NeedsReview,
            Some(DownstreamFork::OrcaSlicer),
        ),
        (
            DownstreamFork::PrusaSlicer,
            FlavorId::PrusaSlicer,
            VendorSourceRef::prusa_slicer_version_2_9_5(),
            FeatureOrigin::UnknownNeedsReview,
            ParitySurface::try_from("generated-outputs"),
            ChecklistStatus::Deferred,
            Some(DownstreamFork::PrusaSlicer),
        ),
    ];

    // Act
    let snapshots = cases.map(
        |(
            downstream_fork,
            flavor_id,
            source_ref,
            feature_origin,
            parity_surface_result,
            checklist_status,
            maybe_expected_fork,
        )| {
            parity_surface_result.map(|parity_surface| {
                (
                    collect_contract_boundary_snapshot(
                        downstream_fork,
                        flavor_id,
                        source_ref,
                        feature_origin,
                        parity_surface,
                        checklist_status,
                    ),
                    maybe_expected_fork,
                )
            })
        },
    );

    // Assert
    assert_eq!(
        snapshots[0]
            .as_ref()
            .map(|(snapshot, _)| snapshot.feature_origin),
        Ok(FeatureOrigin::BaseSlic3r)
    );
    assert_eq!(
        snapshots[1]
            .as_ref()
            .map(|(snapshot, _)| snapshot.feature_origin),
        Ok(FeatureOrigin::SharedDownstream)
    );
    assert_eq!(
        snapshots[2]
            .as_ref()
            .map(|(snapshot, _)| snapshot.feature_origin),
        Ok(FeatureOrigin::ForkSpecific)
    );
    assert_eq!(
        snapshots[3]
            .as_ref()
            .map(|(snapshot, _)| snapshot.feature_origin),
        Ok(FeatureOrigin::UnknownNeedsReview)
    );
    for snapshot_result in snapshots {
        let Ok((snapshot, maybe_expected_fork)) = snapshot_result else {
            panic!("parity surface tokens in typed-boundary test must parse");
        };
        assert_eq!(snapshot.maybe_flavor_fork, maybe_expected_fork);
        assert_eq!(snapshot.source_ref.vendor(), snapshot.downstream_fork);
    }
}

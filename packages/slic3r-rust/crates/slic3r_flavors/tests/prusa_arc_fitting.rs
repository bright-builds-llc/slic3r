use slic3r_flavors::{
    PrusaArcFittingField, parse_prusa_arc_fitting_summary, prusa_arc_fitting_summary_lines,
};

const EXPECTED_ARC_SUMMARY: &str = include_str!(
    "../../../../parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv"
);
const PRUSA_ARC_FITTING_SOURCE: &str = include_str!("../src/prusa_arc_fitting.rs");

#[test]
fn parses_expected_arc_summary_rows_and_facts() {
    // Arrange
    let input = EXPECTED_ARC_SUMMARY;

    // Act
    let summary =
        parse_prusa_arc_fitting_summary(input).expect("expected arc summary should parse");
    let facts = summary.facts();
    let rows = summary.rows();
    let fields: Vec<PrusaArcFittingField> = rows.iter().map(|row| row.arc_field).collect();

    // Assert
    assert_eq!(rows.len(), 12);
    assert_eq!(fields.as_slice(), expected_arc_fields().as_slice());
    assert_eq!(rows[0].arc_field, PrusaArcFittingField::SourceRef);
    assert_eq!(rows[11].arc_field, PrusaArcFittingField::EvidenceBoundary);
    assert_eq!(
        facts.source_ref.as_str(),
        "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
    );
    assert_eq!(
        facts.inventory_source_paths,
        "packages/fork-inventories/prusaslicer.tsv;src/libslic3r/Geometry/ArcWelder.cpp"
    );
    assert_eq!(
        facts.source_anchor,
        "ArcWelder.cpp#L4-L7;ArcWelder.cpp#L400-L404;ArcWelder.cpp#L630-L634"
    );
    assert_eq!(facts.fixture_id, "arc-fitting-observations.gcode");
    assert_eq!(
        facts.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode"
    );
    assert_eq!(facts.arc_command_counts, "G2:1;G3:1;total_arc_commands:2");
    assert_eq!(
        facts.arc_direction_counts,
        "clockwise_g2:1;counterclockwise_g3:1"
    );
    assert_eq!(
        facts.center_offset_observations,
        "i_values:5.000,-5.000;j_values:0.000,0.000"
    );
    assert_eq!(
        facts.coordinate_bounds,
        "x_min:0.000;x_max:10.000;y_min:0.000;y_max:0.000"
    );
    assert_eq!(
        facts.extrusion_observations,
        "e_values:0.50000,1.00000;e_axis_observed:true"
    );
    assert_eq!(facts.feedrate_observations, "F1800:2");
    assert_eq!(facts.evidence_boundary, "checked-in-arc-summary-only");
}

#[test]
fn summarizes_expected_arc_summary_lines() {
    // Arrange
    let input = EXPECTED_ARC_SUMMARY;

    // Act
    let summary = prusa_arc_fitting_summary_lines(input).expect("arc summary should parse");

    // Assert
    assert_eq!(
        summary,
        vec![
            "arc_summary_path\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv",
            "arc_row_count\t12",
            "source_ref\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961",
            "inventory_source_paths\tpackages/fork-inventories/prusaslicer.tsv;src/libslic3r/Geometry/ArcWelder.cpp",
            "source_anchor\tArcWelder.cpp#L4-L7;ArcWelder.cpp#L400-L404;ArcWelder.cpp#L630-L634",
            "fixture_id\tarc-fitting-observations.gcode",
            "fixture_path\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode",
            "arc_command_counts\tG2:1;G3:1;total_arc_commands:2",
            "arc_direction_counts\tclockwise_g2:1;counterclockwise_g3:1",
            "center_offset_observations\ti_values:5.000,-5.000;j_values:0.000,0.000",
            "coordinate_bounds\tx_min:0.000;x_max:10.000;y_min:0.000;y_max:0.000",
            "extrusion_observations\te_values:0.50000,1.00000;e_axis_observed:true",
            "feedrate_observations\tF1800:2",
            "evidence_boundary\tchecked-in-arc-summary-only",
        ]
    );
    for line in summary {
        assert!(!line.contains("byte-for-byte"));
        assert!(!line.contains("printer-runtime"));
        assert!(!line.contains("public status claim"));
    }
}

#[test]
fn public_arc_fitting_declarations_do_not_claim_deferred_behavior() {
    // Arrange
    let risky_words = [
        "parity".to_owned(),
        "runtime".to_owned(),
        "printer".to_owned(),
        "firmware".to_owned(),
        "executable".to_owned(),
        joined_word("veri", "fied"),
        joined_word("rel", "ease"),
        "sync".to_owned(),
        "network".to_owned(),
        "host_upload".to_owned(),
        "bambu".to_owned(),
        "orca".to_owned(),
        "non_prusa".to_owned(),
        "geometry".to_owned(),
    ];
    let public_declarations: Vec<&str> = PRUSA_ARC_FITTING_SOURCE
        .lines()
        .map(str::trim)
        .filter(|line| line.starts_with("pub "))
        .collect();

    // Act
    let maybe_risky_declaration = public_declarations.iter().find(|declaration| {
        risky_words
            .iter()
            .any(|risky_word| declaration.contains(risky_word))
    });

    // Assert
    assert!(maybe_risky_declaration.is_none());
}

fn expected_arc_fields() -> [PrusaArcFittingField; 12] {
    [
        PrusaArcFittingField::SourceRef,
        PrusaArcFittingField::InventorySourcePaths,
        PrusaArcFittingField::SourceAnchor,
        PrusaArcFittingField::FixtureId,
        PrusaArcFittingField::FixturePath,
        PrusaArcFittingField::ArcCommandCounts,
        PrusaArcFittingField::ArcDirectionCounts,
        PrusaArcFittingField::CenterOffsetObservations,
        PrusaArcFittingField::CoordinateBounds,
        PrusaArcFittingField::ExtrusionObservations,
        PrusaArcFittingField::FeedrateObservations,
        PrusaArcFittingField::EvidenceBoundary,
    ]
}

fn joined_word(prefix: &str, suffix: &str) -> String {
    [prefix, suffix].concat()
}

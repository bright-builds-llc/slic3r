use slic3r_flavors::{
    PrusaWallSeamField, parse_prusa_wall_seam_summary, prusa_wall_seam_summary_lines,
};

const EXPECTED_WALL_SEAM_SUMMARY: &str = include_str!(
    "../../../../parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv"
);
const PRUSA_WALL_SEAM_SOURCE: &str = include_str!("../src/prusa_wall_seam.rs");

#[test]
fn parses_expected_wall_seam_summary_rows_and_facts() {
    // Arrange
    let input = EXPECTED_WALL_SEAM_SUMMARY;

    // Act
    let summary =
        parse_prusa_wall_seam_summary(input).expect("expected wall-seam summary should parse");
    let facts = summary.facts();
    let rows = summary.rows();
    let fields: Vec<PrusaWallSeamField> = rows.iter().map(|row| row.wall_seam_field).collect();

    // Assert
    assert_eq!(rows.len(), 12);
    assert_eq!(fields.as_slice(), expected_wall_seam_fields().as_slice());
    assert_eq!(rows[0].wall_seam_field, PrusaWallSeamField::SourceRef);
    assert_eq!(
        rows[11].wall_seam_field,
        PrusaWallSeamField::EvidenceBoundary
    );
    assert_eq!(
        facts.source_ref.as_str(),
        "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
    );
    assert_eq!(
        facts.inventory_source_paths,
        "packages/fork-inventories/prusaslicer.tsv;src/libslic3r/GCode/SeamAligned.cpp"
    );
    assert_eq!(
        facts.source_anchor,
        "SeamAligned.cpp#L16;SeamAligned.cpp#L115-L148;SeamAligned.cpp#L272-L313;SeamAligned.cpp#L463-L525"
    );
    assert_eq!(facts.fixture_id, "wall-seam-observations.gcode");
    assert_eq!(
        facts.fixture_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/wall-seam-observations.gcode"
    );
    assert_eq!(
        facts.seam_transition_observations,
        "seam_markers:seam_start,seam_resume;transition_count:2"
    );
    assert_eq!(
        facts.layer_context_observations,
        "layer_index:0;z_values:0.200"
    );
    assert_eq!(
        facts.travel_context_observations,
        "travel_moves:1;travel_from:12.500,8.000;travel_to:14.000,8.750"
    );
    assert_eq!(
        facts.coordinate_bounds,
        "x_min:12.500;x_max:15.250;y_min:8.000;y_max:9.500;z_min:0.200;z_max:0.200"
    );
    assert_eq!(
        facts.extrusion_observations,
        "e_values:0.12000,0.28000;e_axis_observed:true"
    );
    assert_eq!(
        facts.retraction_observations,
        "e_marker_values:0.28000,0.24000;retraction_marker_observed:true"
    );
    assert_eq!(facts.evidence_boundary, "checked-in-wall-seam-summary-only");
}

#[test]
fn summarizes_expected_wall_seam_summary_lines() {
    // Arrange
    let input = EXPECTED_WALL_SEAM_SUMMARY;

    // Act
    let summary = prusa_wall_seam_summary_lines(input).expect("wall-seam summary should parse");

    // Assert
    assert_eq!(
        summary,
        vec![
            "wall_seam_summary_path\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv",
            "wall_seam_row_count\t12",
            "source_ref\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961",
            "inventory_source_paths\tpackages/fork-inventories/prusaslicer.tsv;src/libslic3r/GCode/SeamAligned.cpp",
            "source_anchor\tSeamAligned.cpp#L16;SeamAligned.cpp#L115-L148;SeamAligned.cpp#L272-L313;SeamAligned.cpp#L463-L525",
            "fixture_id\twall-seam-observations.gcode",
            "fixture_path\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/wall-seam-observations.gcode",
            "seam_transition_observations\tseam_markers:seam_start,seam_resume;transition_count:2",
            "layer_context_observations\tlayer_index:0;z_values:0.200",
            "travel_context_observations\ttravel_moves:1;travel_from:12.500,8.000;travel_to:14.000,8.750",
            "coordinate_bounds\tx_min:12.500;x_max:15.250;y_min:8.000;y_max:9.500;z_min:0.200;z_max:0.200",
            "extrusion_observations\te_values:0.12000,0.28000;e_axis_observed:true",
            "retraction_observations\te_marker_values:0.28000,0.24000;retraction_marker_observed:true",
            "evidence_boundary\tchecked-in-wall-seam-summary-only",
        ]
    );
    for line in summary {
        assert!(!line.contains("byte-for-byte"));
        assert!(!line.contains("printer-runtime"));
        assert!(!line.contains("public status claim"));
    }
}

#[test]
fn public_wall_seam_declarations_do_not_claim_deferred_behavior() {
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
        "arc_fitting".to_owned(),
        "support".to_owned(),
    ];
    let public_declarations: Vec<&str> = PRUSA_WALL_SEAM_SOURCE
        .lines()
        .map(str::trim)
        .filter(|line| {
            line.starts_with("pub struct ")
                || line.starts_with("pub enum ")
                || line.starts_with("pub type ")
                || line.starts_with("pub fn ")
                || line.starts_with("pub const fn ")
        })
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

fn expected_wall_seam_fields() -> [PrusaWallSeamField; 12] {
    [
        PrusaWallSeamField::SourceRef,
        PrusaWallSeamField::InventorySourcePaths,
        PrusaWallSeamField::SourceAnchor,
        PrusaWallSeamField::FixtureId,
        PrusaWallSeamField::FixturePath,
        PrusaWallSeamField::SeamTransitionObservations,
        PrusaWallSeamField::LayerContextObservations,
        PrusaWallSeamField::TravelContextObservations,
        PrusaWallSeamField::CoordinateBounds,
        PrusaWallSeamField::ExtrusionObservations,
        PrusaWallSeamField::RetractionObservations,
        PrusaWallSeamField::EvidenceBoundary,
    ]
}

fn joined_word(prefix: &str, suffix: &str) -> String {
    [prefix, suffix].concat()
}

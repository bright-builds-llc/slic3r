use slic3r_contracts::{ChecklistStatus, FeatureOrigin, FlavorId, ParitySurface};
use slic3r_flavors::prusa_gcode_output::{
    PrusaGcodeOutputMarkerKey, PrusaGcodeOutputMarkerValue, PrusaGcodeOutputMetadataKey,
    PrusaGcodeOutputMetadataValue, PrusaGcodeOutputParseError, PrusaGcodeOutputStructuralField,
    PrusaGcodeOutputStructuralParseError, parse_prusa_gcode_output_structural_summary,
    parse_prusa_gcode_output_summary, prusa_gcode_output_metadata,
    prusa_gcode_output_structural_summary_lines, prusa_gcode_output_summary_lines,
};

const EXPECTED_GCODE_SUMMARY: &str = include_str!(
    "../../../../parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"
);
const EXPECTED_GCODE_STRUCTURAL_SUMMARY: &str = include_str!(
    "../../../../parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv"
);
const PRUSA_GCODE_OUTPUT_SOURCE: &str = include_str!("../src/prusa_gcode_output.rs");

#[test]
fn parses_expected_gcode_summary_rows_in_fixture_order() {
    // Arrange
    let input = EXPECTED_GCODE_SUMMARY;

    // Act
    let summary =
        parse_prusa_gcode_output_summary(input).expect("expected G-code summary should parse");

    // Assert
    assert_eq!(summary.rows.len(), 5);
    assert_eq!(
        summary.rows[0].metadata_key,
        PrusaGcodeOutputMetadataKey::SourceIdentity
    );
    assert_eq!(
        summary.rows[0].metadata_value,
        PrusaGcodeOutputMetadataValue::PrusaSourceIdentity
    );
    assert_eq!(
        summary.rows[0].marker_key,
        PrusaGcodeOutputMarkerKey::SourceLiteral
    );
    assert_eq!(
        summary.rows[0].marker_value,
        PrusaGcodeOutputMarkerValue::SourceLiteralLocation
    );
    assert_eq!(summary.rows[4].marker_key, PrusaGcodeOutputMarkerKey::Line4);
    assert_eq!(
        summary.rows[4].marker_value,
        PrusaGcodeOutputMarkerValue::FeedrateThreeDecimalRounded
    );
}

#[test]
fn parses_expected_gcode_structural_summary_rows_and_facts() {
    // Arrange
    let input = EXPECTED_GCODE_STRUCTURAL_SUMMARY;

    // Act
    let summary = parse_prusa_gcode_output_structural_summary(input)
        .expect("expected structural G-code summary should parse");
    let facts = summary.facts();
    let rows = summary.rows();
    let fields: Vec<PrusaGcodeOutputStructuralField> =
        rows.iter().map(|row| row.structural_field).collect();

    // Assert
    assert_eq!(rows.len(), 16);
    assert_eq!(fields.as_slice(), expected_structural_fields().as_slice());
    assert_eq!(
        rows[0].structural_field,
        PrusaGcodeOutputStructuralField::SourceRef
    );
    assert_eq!(
        rows[15].structural_field,
        PrusaGcodeOutputStructuralField::ToolChangeMarkerCount
    );
    assert_eq!(facts.source_ref.as_str(), expected_source_ref());
    assert_eq!(
        facts.inventory_source_paths,
        "src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp"
    );
    assert_eq!(
        facts.fixture_source_literal,
        "tests/fff_print/test_gcodewriter.cpp#L20-L35"
    );
    assert_eq!(facts.fixture_id, expected_fixture_id());
    assert_eq!(facts.fixture_path, expected_fixture_path());
    assert_eq!(facts.command_count_total, 4);
    assert_eq!(facts.command_count_g1, 4);
    assert_eq!(facts.section_count_total, 1);
    assert_eq!(
        facts.ordered_markers,
        [
            PrusaGcodeOutputMarkerValue::FeedrateFixedPoint,
            PrusaGcodeOutputMarkerValue::FeedrateInteger,
            PrusaGcodeOutputMarkerValue::FeedrateOneDecimal,
            PrusaGcodeOutputMarkerValue::FeedrateThreeDecimalRounded,
        ]
    );
    assert!(!facts.movement_axis_present);
    assert!(!facts.extrusion_axis_present);
    assert_eq!(facts.temperature_marker_count, 0);
    assert_eq!(facts.tool_change_marker_count, 0);
}

#[test]
fn summarizes_expected_gcode_structural_summary_lines() {
    // Arrange
    let input = EXPECTED_GCODE_STRUCTURAL_SUMMARY;

    // Act
    let summary =
        prusa_gcode_output_structural_summary_lines(input).expect("structural summary should parse");

    // Assert
    assert_eq!(
        summary,
        vec![
            "structural_summary_path\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv",
            "structural_row_count\t16",
            "source_ref\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961",
            "inventory_source_paths\tsrc/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp",
            "fixture_source_literal\ttests/fff_print/test_gcodewriter.cpp#L20-L35",
            "fixture_id\tgcodewriter-set-speed.gcode",
            "fixture_path\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode",
            "command_count_total\t4",
            "command_count_g1\t4",
            "section_count_total\t1",
            "ordered_marker_1\tG1 F99999.123",
            "ordered_marker_2\tG1 F1",
            "ordered_marker_3\tG1 F203.2",
            "ordered_marker_4\tG1 F203.201",
            "movement_axis_present\tfalse",
            "extrusion_axis_present\tfalse",
            "temperature_marker_count\t0",
            "tool_change_marker_count\t0",
        ]
    );
}

#[test]
fn rejects_malformed_gcode_structural_summary_lines() {
    // Arrange
    let input = replace_structural_cell(6, 4, "3");

    // Act
    let result = prusa_gcode_output_structural_summary_lines(&input);

    // Assert
    assert!(matches!(
        result,
        Err(
            PrusaGcodeOutputStructuralParseError::UnexpectedStructuralValue {
                line_number: 8,
                structural_field: PrusaGcodeOutputStructuralField::CommandCountG1,
                ..
            }
        )
    ));
}

#[test]
fn rejects_structural_invalid_header() {
    // Arrange
    let input = EXPECTED_GCODE_STRUCTURAL_SUMMARY.replacen("source_ref", "wrong_source_ref", 1);

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputStructuralParseError::InvalidHeader { .. })
    ));
}

#[test]
fn rejects_structural_wrong_column_count() {
    // Arrange
    let input = replace_first_structural_data_row("only\tfive\tcolumns\tin\trow");

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputStructuralParseError::WrongColumnCount {
            line_number: 2,
            expected: 6,
            actual: 5,
        })
    ));
}

#[test]
fn rejects_structural_missing_row() {
    // Arrange
    let mut lines: Vec<&str> = EXPECTED_GCODE_STRUCTURAL_SUMMARY.lines().collect();
    lines.pop();
    let input = format!("{}\n", lines.join("\n"));

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputStructuralParseError::MissingRow {
            structural_field: PrusaGcodeOutputStructuralField::ToolChangeMarkerCount,
        })
    ));
}

#[test]
fn rejects_structural_duplicate_row() {
    // Arrange
    let first_row = EXPECTED_GCODE_STRUCTURAL_SUMMARY
        .lines()
        .nth(1)
        .expect("structural fixture should contain a first data row");
    let input = format!("{EXPECTED_GCODE_STRUCTURAL_SUMMARY}{first_row}\n");

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputStructuralParseError::DuplicateRow {
            line_number: 18,
            structural_field: PrusaGcodeOutputStructuralField::SourceRef,
        })
    ));
}

#[test]
fn rejects_structural_out_of_order_rows() {
    // Arrange
    let mut lines: Vec<&str> = EXPECTED_GCODE_STRUCTURAL_SUMMARY.lines().collect();
    lines.swap(1, 2);
    let input = format!("{}\n", lines.join("\n"));

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputStructuralParseError::UnexpectedRowOrder {
            line_number: 2,
            expected_structural_field: PrusaGcodeOutputStructuralField::SourceRef,
            actual_structural_field: PrusaGcodeOutputStructuralField::InventorySourcePaths,
        })
    ));
}

#[test]
fn rejects_unsupported_structural_field() {
    // Arrange
    let input = replace_structural_cell(0, 2, "unsupported_structural_field");

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(
            PrusaGcodeOutputStructuralParseError::UnsupportedStructuralField { line_number: 2, .. }
        )
    ));
}

#[test]
fn rejects_structural_unsupported_boundary_claim() {
    // Arrange
    let input = replace_structural_cell(0, 5, "full generated-output parity verified");

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(
            PrusaGcodeOutputStructuralParseError::UnexpectedEvidenceBoundary {
                line_number: 2,
                structural_field: PrusaGcodeOutputStructuralField::SourceRef,
                ..
            }
        )
    ));
}

#[test]
fn rejects_structural_unexpected_source_ref() {
    // Arrange
    let input = replace_structural_cell(
        0,
        0,
        "bambustudio:v02.06.00.51@b506005bc4ee62124e24bf00e0f58656db3646a6",
    );

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputStructuralParseError::UnexpectedSourceRef { line_number: 2, .. })
    ));
}

#[test]
fn rejects_structural_unexpected_fixture_path() {
    // Arrange
    let input = replace_structural_cell(0, 1, "fixtures/unreviewed.gcode");

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputStructuralParseError::UnexpectedFixturePath { line_number: 2, .. })
    ));
}

#[test]
fn rejects_structural_unexpected_fixture_id() {
    // Arrange
    let input = replace_structural_cell(3, 4, "unreviewed-speed.gcode");

    // Act
    let result = parse_prusa_gcode_output_structural_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(
            PrusaGcodeOutputStructuralParseError::UnexpectedStructuralValue {
                line_number: 5,
                structural_field: PrusaGcodeOutputStructuralField::FixtureId,
                ..
            }
        )
    ));
}

#[test]
fn exposes_exact_gcode_output_metadata() {
    // Arrange / Act
    let metadata = prusa_gcode_output_metadata();

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
    assert_eq!(metadata.source_ref.as_str(), expected_source_ref());
    assert_eq!(metadata.source_path, "tests/fff_print/test_gcodewriter.cpp");
    assert_eq!(metadata.fixture_path, expected_fixture_path());
    assert_eq!(
        metadata.expected_summary_path,
        "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv"
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
fn summarizes_gcode_rows_without_output_behavior_claims() {
    // Arrange
    let input = EXPECTED_GCODE_SUMMARY;

    // Act
    let summary = prusa_gcode_output_summary_lines(input).expect("summary should parse");
    let evidence_rows: Vec<&String> = summary
        .iter()
        .filter(|line| line.starts_with("evidence_row\t"))
        .collect();

    // Assert
    assert!(summary.contains(&"row_count\t5".to_owned()));
    assert_eq!(evidence_rows.len(), 5);
    for row in evidence_rows {
        let columns: Vec<&str> = row.split('\t').collect();
        assert_eq!(columns.len(), 6);
        assert!(
            columns[5].ends_with("claimed."),
            "summary note must preserve no-behavior-claim wording: {row}"
        );
    }
}

#[test]
fn public_declarations_do_not_claim_deferred_behavior() {
    // Arrange
    let risky_words = [
        joined_word("veri", "fied"),
        joined_word("supp", "ort"),
        "runtime".to_owned(),
        joined_word("dis", "patch"),
        joined_word("rel", "ease"),
        "executable".to_owned(),
        "printer".to_owned(),
        "firmware".to_owned(),
        "sync".to_owned(),
        "host".to_owned(),
        "network".to_owned(),
        "geometry".to_owned(),
        "extrusion".to_owned(),
        "timing".to_owned(),
        "printability".to_owned(),
        "gcode_parity".to_owned(),
        "generated_output_parity".to_owned(),
    ];
    let public_declarations: Vec<&str> = PRUSA_GCODE_OUTPUT_SOURCE
        .lines()
        .map(str::trim)
        .filter(|line| line.starts_with("pub "))
        .collect();
    let allowed_structural_declarations = ["pub extrusion_axis_present: bool,"];

    // Act
    let maybe_risky_declaration = public_declarations
        .iter()
        .filter(|declaration| !allowed_structural_declarations.contains(declaration))
        .find(|declaration| {
            risky_words
                .iter()
                .any(|risky_word| declaration.contains(risky_word))
        });

    // Assert
    assert!(maybe_risky_declaration.is_none());
}

#[test]
fn rejects_invalid_header() {
    // Arrange
    let input = EXPECTED_GCODE_SUMMARY.replacen("source_ref", "wrong_source_ref", 1);

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::InvalidHeader { .. })
    ));
}

#[test]
fn rejects_wrong_column_count() {
    // Arrange
    let input = replace_first_data_row("only\tsix\tcolumns\tin\tthis\trow");

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::WrongColumnCount {
            line_number: 2,
            expected: 7,
            actual: 6,
        })
    ));
}

#[test]
fn rejects_empty_required_value() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        "",
        expected_fixture_path(),
        "source_identity",
        expected_source_ref(),
        "source_literal",
        "tests/fff_print/test_gcodewriter.cpp#L20-L35",
        "Accepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.",
    ));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::EmptyRequiredValue {
            line_number: 2,
            column: "source_ref",
        })
    ));
}

#[test]
fn rejects_unexpected_source_ref() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        "bambustudio:v02.06.00.51@b506005bc4ee62124e24bf00e0f58656db3646a6",
        expected_fixture_path(),
        "source_identity",
        expected_source_ref(),
        "source_literal",
        "tests/fff_print/test_gcodewriter.cpp#L20-L35",
        "Accepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.",
    ));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::UnexpectedSourceRef { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unexpected_fixture_path() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        "fixtures/unreviewed.gcode",
        "source_identity",
        expected_source_ref(),
        "source_literal",
        "tests/fff_print/test_gcodewriter.cpp#L20-L35",
        "Accepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.",
    ));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::UnexpectedFixturePath { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unsupported_metadata_key() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        expected_fixture_path(),
        "unexpected_key",
        expected_source_ref(),
        "source_literal",
        "tests/fff_print/test_gcodewriter.cpp#L20-L35",
        "Accepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.",
    ));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::UnsupportedMetadataKey { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unsupported_metadata_value() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        expected_fixture_path(),
        "source_identity",
        "unreviewed-output-claim",
        "source_literal",
        "tests/fff_print/test_gcodewriter.cpp#L20-L35",
        "Accepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.",
    ));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::UnsupportedMetadataValue { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unsupported_marker_key() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        expected_fixture_path(),
        "source_identity",
        expected_source_ref(),
        "unexpected_marker",
        "tests/fff_print/test_gcodewriter.cpp#L20-L35",
        "Accepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.",
    ));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::UnsupportedMarkerKey { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unsupported_marker_value() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        expected_fixture_path(),
        "source_identity",
        expected_source_ref(),
        "source_literal",
        "G1 X999",
        "Accepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.",
    ));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::UnsupportedMarkerValue { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unexpected_note_claim() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        expected_fixture_path(),
        "source_identity",
        expected_source_ref(),
        "source_literal",
        "tests/fff_print/test_gcodewriter.cpp#L20-L35",
        "full generated-output parity verified",
    ));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::UnexpectedNote { line_number: 2, .. })
    ));
}

#[test]
fn rejects_duplicate_row() {
    // Arrange
    let first_row = EXPECTED_GCODE_SUMMARY
        .lines()
        .nth(1)
        .expect("fixture should contain a first evidence row");
    let input = format!("{EXPECTED_GCODE_SUMMARY}{first_row}\n");

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::DuplicateRow { line_number: 7, .. })
    ));
}

#[test]
fn rejects_out_of_order_rows() {
    // Arrange
    let mut lines: Vec<&str> = EXPECTED_GCODE_SUMMARY.lines().collect();
    lines.swap(2, 3);
    let input = format!("{}\n", lines.join("\n"));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::UnexpectedRowOrder { line_number: 3, .. })
    ));
}

#[test]
fn rejects_missing_row() {
    // Arrange
    let mut lines: Vec<&str> = EXPECTED_GCODE_SUMMARY.lines().collect();
    lines.pop();
    let input = format!("{}\n", lines.join("\n"));

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::MissingRow {
            marker_key: PrusaGcodeOutputMarkerKey::Line4,
            marker_value: PrusaGcodeOutputMarkerValue::FeedrateThreeDecimalRounded,
            ..
        })
    ));
}

#[test]
fn rejects_extra_row() {
    // Arrange
    let extra_row = expected_row(
        expected_source_ref(),
        expected_fixture_path(),
        "source_identity",
        "source-controlled-gcodewriter-set-speed-expected-output",
        "line_1",
        "G1 F99999.123",
        "Extra source identity row with supported tokens but unsupported pairing.",
    );
    let input = format!("{EXPECTED_GCODE_SUMMARY}{extra_row}\n");

    // Act
    let result = parse_prusa_gcode_output_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaGcodeOutputParseError::ExtraRow { line_number: 7, .. })
    ));
}

fn expected_structural_fields() -> [PrusaGcodeOutputStructuralField; 16] {
    [
        PrusaGcodeOutputStructuralField::SourceRef,
        PrusaGcodeOutputStructuralField::InventorySourcePaths,
        PrusaGcodeOutputStructuralField::FixtureSourceLiteral,
        PrusaGcodeOutputStructuralField::FixtureId,
        PrusaGcodeOutputStructuralField::FixturePath,
        PrusaGcodeOutputStructuralField::CommandCountTotal,
        PrusaGcodeOutputStructuralField::CommandCountG1,
        PrusaGcodeOutputStructuralField::SectionCountTotal,
        PrusaGcodeOutputStructuralField::OrderedMarker1,
        PrusaGcodeOutputStructuralField::OrderedMarker2,
        PrusaGcodeOutputStructuralField::OrderedMarker3,
        PrusaGcodeOutputStructuralField::OrderedMarker4,
        PrusaGcodeOutputStructuralField::MovementAxisPresent,
        PrusaGcodeOutputStructuralField::ExtrusionAxisPresent,
        PrusaGcodeOutputStructuralField::TemperatureMarkerCount,
        PrusaGcodeOutputStructuralField::ToolChangeMarkerCount,
    ]
}

fn replace_first_structural_data_row(replacement: &str) -> String {
    let mut lines: Vec<&str> = EXPECTED_GCODE_STRUCTURAL_SUMMARY.lines().collect();
    lines[1] = replacement;
    format!("{}\n", lines.join("\n"))
}

fn replace_structural_cell(
    data_row_index: usize,
    column_index: usize,
    replacement: &str,
) -> String {
    let mut lines: Vec<String> = EXPECTED_GCODE_STRUCTURAL_SUMMARY
        .lines()
        .map(str::to_owned)
        .collect();
    let line_index = data_row_index + 1;
    let line = lines
        .get_mut(line_index)
        .expect("structural fixture should contain requested data row");
    let mut columns: Vec<String> = line.split('\t').map(str::to_owned).collect();
    let column = columns
        .get_mut(column_index)
        .expect("structural fixture row should contain requested column");
    *column = replacement.to_owned();
    *line = columns.join("\t");
    format!("{}\n", lines.join("\n"))
}

fn replace_first_data_row(replacement: &str) -> String {
    let mut lines: Vec<&str> = EXPECTED_GCODE_SUMMARY.lines().collect();
    lines[1] = replacement;
    format!("{}\n", lines.join("\n"))
}

fn expected_row(
    source_ref: &str,
    fixture_path: &str,
    metadata_key: &str,
    metadata_value: &str,
    marker_key: &str,
    marker_value: &str,
    notes: &str,
) -> String {
    [
        source_ref,
        fixture_path,
        metadata_key,
        metadata_value,
        marker_key,
        marker_value,
        notes,
    ]
    .join("\t")
}

fn expected_source_ref() -> &'static str {
    "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
}

fn expected_fixture_path() -> &'static str {
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode"
}

fn expected_fixture_id() -> &'static str {
    "gcodewriter-set-speed.gcode"
}

fn joined_word(prefix: &str, suffix: &str) -> String {
    [prefix, suffix].concat()
}

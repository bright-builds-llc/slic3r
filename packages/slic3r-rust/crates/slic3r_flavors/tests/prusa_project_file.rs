use slic3r_contracts::{ChecklistStatus, FeatureOrigin, FlavorId, ParitySurface};
use slic3r_flavors::prusa_project_file::{
    PrusaProjectFileParseError, parse_prusa_project_file_summary, prusa_project_file_metadata,
    prusa_project_file_summary_lines,
};

const EXPECTED_PROJECT_SUMMARY: &str = include_str!(
    "../../../../parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv"
);
const PRUSA_PROJECT_FILE_SOURCE: &str = include_str!("../src/prusa_project_file.rs");

#[test]
fn parses_expected_project_summary_rows_in_fixture_order() {
    // Arrange
    let input = EXPECTED_PROJECT_SUMMARY;

    // Act
    let summary =
        parse_prusa_project_file_summary(input).expect("expected project summary should parse");

    // Assert
    assert_eq!(summary.rows.len(), 7);
    assert_eq!(summary.rows[0].source_ref.as_str(), expected_source_ref());
    assert_eq!(summary.rows[0].fixture_path, expected_fixture_path());
    assert_eq!(
        summary.rows[0].archive_member.as_str(),
        "[Content_Types].xml"
    );
    assert_eq!(summary.rows[0].project_marker.as_str(), "opc-content-types");
    assert_eq!(
        summary.rows[0].deferred_semantics.as_str(),
        "member-presence-only"
    );
    assert_eq!(
        summary.rows[6].archive_member.as_str(),
        "Metadata/Slic3r_PE_model.config"
    );
    assert_eq!(
        summary.rows[6].project_marker.as_str(),
        "Slic3r_PE_model.config-member-present"
    );
}

#[test]
fn exposes_exact_project_file_metadata() {
    // Arrange / Act
    let metadata = prusa_project_file_metadata();

    // Assert
    assert_eq!(metadata.inventory_id, "prusaslicer.project-file");
    assert_eq!(metadata.vendor_id, "prusaslicer");
    assert_eq!(metadata.flavor_id, FlavorId::PrusaSlicer);
    assert_eq!(metadata.origin, FeatureOrigin::SharedDownstream);
    assert_eq!(metadata.parity_dependency, ParitySurface::file_formats());
    assert_eq!(metadata.checklist_status, ChecklistStatus::FutureCandidate);
    assert_eq!(metadata.source_ref.as_str(), expected_source_ref());
    assert_eq!(metadata.source_path, "src/libslic3r/Format/3mf.cpp");
    assert_eq!(metadata.fixture_path, expected_fixture_path());
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
fn summarizes_project_file_rows_without_semantic_claims() {
    // Arrange
    let input = EXPECTED_PROJECT_SUMMARY;

    // Act
    let summary = prusa_project_file_summary_lines(input).expect("summary should parse");
    let evidence_rows: Vec<&String> = summary
        .iter()
        .filter(|line| line.starts_with("evidence_row\t"))
        .collect();

    // Assert
    assert!(summary.contains(&"row_count\t7".to_owned()));
    assert_eq!(evidence_rows.len(), 7);
    for row in evidence_rows {
        let columns: Vec<&str> = row.split('\t').collect();
        assert_eq!(columns.len(), 4);
        assert!(matches!(
            columns[3],
            "member-presence-only" | "member-marker-only"
        ));
    }
}

#[test]
fn rejects_invalid_header() {
    // Arrange
    let input = EXPECTED_PROJECT_SUMMARY.replacen("source_ref", "wrong_source_ref", 1);

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::InvalidHeader { .. })
    ));
}

#[test]
fn rejects_wrong_column_count() {
    // Arrange
    let input = replace_first_data_row("only\tfive\tcolumns\tin\trow");

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::WrongColumnCount {
            line_number: 2,
            expected: 6,
            actual: 5,
        })
    ));
}

#[test]
fn rejects_empty_required_value() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        "",
        "[Content_Types].xml",
        "opc-content-types",
        "member-presence-only",
        "Content type member declares 3D model and PNG thumbnail defaults; no import/export behavior claimed.",
    ));

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::EmptyRequiredValue {
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
        "[Content_Types].xml",
        "opc-content-types",
        "member-presence-only",
        "Content type member declares 3D model and PNG thumbnail defaults; no import/export behavior claimed.",
    ));

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::UnexpectedSourceRef { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unexpected_fixture_path() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        "[Content_Types].xml",
        "opc-content-types",
        "member-presence-only",
        "Content type member declares 3D model and PNG thumbnail defaults; no import/export behavior claimed.",
    ))
    .replace(expected_fixture_path(), "fixtures/unreviewed.3mf");

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::UnexpectedFixturePath { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unsupported_archive_member() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        "unexpected/member.xml",
        "opc-content-types",
        "member-presence-only",
        "Content type member declares 3D model and PNG thumbnail defaults; no import/export behavior claimed.",
    ));

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::UnsupportedArchiveMember { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unsupported_project_marker() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        "[Content_Types].xml",
        "unexpected-marker",
        "member-presence-only",
        "Content type member declares 3D model and PNG thumbnail defaults; no import/export behavior claimed.",
    ));

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::UnsupportedProjectMarker { line_number: 2, .. })
    ));
}

#[test]
fn rejects_unsupported_deferred_semantics() {
    // Arrange
    let input = replace_first_data_row(&expected_row(
        expected_source_ref(),
        "[Content_Types].xml",
        "opc-content-types",
        "semantic-claim",
        "Content type member declares 3D model and PNG thumbnail defaults; no import/export behavior claimed.",
    ));

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::UnsupportedDeferredSemantics { line_number: 2, .. })
    ));
}

#[test]
fn rejects_duplicate_row() {
    // Arrange
    let first_row = EXPECTED_PROJECT_SUMMARY
        .lines()
        .nth(1)
        .expect("fixture should contain a first evidence row");
    let input = format!("{EXPECTED_PROJECT_SUMMARY}{first_row}\n");

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::DuplicateRow { line_number: 9, .. })
    ));
}

#[test]
fn rejects_missing_row() {
    // Arrange
    let input = EXPECTED_PROJECT_SUMMARY
        .lines()
        .take(7)
        .collect::<Vec<&str>>()
        .join("\n");

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::MissingRow { .. })
    ));
}

#[test]
fn rejects_extra_row() {
    // Arrange
    let extra_row = expected_row(
        expected_source_ref(),
        "[Content_Types].xml",
        "start-part-relationship",
        "member-presence-only",
        "Content type member declares 3D model and PNG thumbnail defaults; no import/export behavior claimed.",
    );
    let input = format!("{EXPECTED_PROJECT_SUMMARY}{extra_row}\n");

    // Act
    let result = parse_prusa_project_file_summary(&input);

    // Assert
    assert!(matches!(
        result,
        Err(PrusaProjectFileParseError::ExtraRow { line_number: 9, .. })
    ));
}

#[test]
fn public_surface_names_do_not_claim_deferred_behavior() {
    // Arrange
    let public_declarations: Vec<&str> = PRUSA_PROJECT_FILE_SOURCE
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
    let forbidden_terms = [
        "runtime",
        "support",
        "import",
        "export",
        "load",
        "save",
        "geometry",
        "profile",
        "generated-output",
        "generated_output",
    ];

    // Act / Assert
    for declaration in public_declarations {
        let declaration = declaration.to_ascii_lowercase();
        for forbidden in forbidden_terms {
            assert!(
                !declaration.contains(forbidden),
                "public declaration overclaims deferred behavior: {declaration}"
            );
        }
    }
}

fn replace_first_data_row(replacement: &str) -> String {
    let mut lines = EXPECTED_PROJECT_SUMMARY.lines();
    let header = lines.next().expect("fixture should contain a header");
    let remaining_rows: Vec<&str> = lines.skip(1).collect();
    format!("{header}\n{replacement}\n{}\n", remaining_rows.join("\n"))
}

fn expected_row(
    source_ref: &str,
    archive_member: &str,
    project_marker: &str,
    deferred_semantics: &str,
    notes: &str,
) -> String {
    format!(
        "{source_ref}\t{}\t{archive_member}\t{project_marker}\t{deferred_semantics}\t{notes}",
        expected_fixture_path()
    )
}

fn expected_source_ref() -> &'static str {
    "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
}

fn expected_fixture_path() -> &'static str {
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf"
}

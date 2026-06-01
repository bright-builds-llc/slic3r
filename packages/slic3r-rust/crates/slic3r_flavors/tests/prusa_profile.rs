use slic3r_flavors::prusa_profile::{
    PrusaProfileParseError, PrusaProfileSectionKind, parse_prusa_profile_bundle,
};

const PRUSA_RESEARCH_INI: &str = include_str!(
    "../../../../parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini"
);

#[test]
fn parses_sections_entries_and_source_identity() {
    // Arrange
    let input = "\
[vendor]
 repo_id = prusa-fff 

[print:0.20mm QUALITY @MK4S]
layer_height = 0.2
";

    // Act
    let bundle = parse_prusa_profile_bundle(input).expect("profile fragment should parse");

    // Assert
    assert_eq!(bundle.sections.len(), 2);
    assert_eq!(bundle.sections[0].index, 0);
    assert_eq!(bundle.sections[0].line_number, 1);
    assert_eq!(bundle.sections[0].kind, PrusaProfileSectionKind::Vendor);
    assert_eq!(bundle.sections[0].name.as_str(), "vendor");
    assert_eq!(bundle.sections[0].entries[0].section_index, 0);
    assert_eq!(bundle.sections[0].entries[0].line_number, 2);
    assert_eq!(bundle.sections[0].entries[0].key.as_str(), "repo_id");
    assert_eq!(bundle.sections[0].entries[0].value.as_str(), "prusa-fff");
    assert_eq!(bundle.sections[1].index, 1);
    assert_eq!(bundle.sections[1].line_number, 4);
    assert_eq!(bundle.sections[1].kind, PrusaProfileSectionKind::Print);
    assert_eq!(bundle.sections[1].name.as_str(), "0.20mm QUALITY @MK4S");
}

#[test]
fn preserves_opaque_value_text_after_first_equals() {
    // Arrange
    let input = "\
[filament:Opaque Values]
notes = https://example.test/profile?a=b;c=d\\nG1 X=1 ; keep semicolon
";

    // Act
    let bundle = parse_prusa_profile_bundle(input).expect("opaque values should parse");

    // Assert
    let value = bundle.sections[0].entries[0].value.as_str();
    assert_eq!(
        value,
        "https://example.test/profile?a=b;c=d\\nG1 X=1 ; keep semicolon"
    );
}

#[test]
fn ignores_blank_lines_and_whole_line_comments() {
    // Arrange
    let input = "\
# Prusa Research

   ; local note
[printer:MK4S]
printer_model = MK4S
";

    // Act
    let bundle = parse_prusa_profile_bundle(input).expect("comments and blanks should be ignored");

    // Assert
    assert_eq!(bundle.sections.len(), 1);
    assert_eq!(bundle.sections[0].line_number, 4);
    assert_eq!(bundle.sections[0].entries.len(), 1);
    assert_eq!(bundle.sections[0].entries[0].line_number, 5);
}

#[test]
fn rejects_entry_before_first_section() {
    // Arrange
    let input = "repo_id = prusa-fff\n";

    // Act
    let result = parse_prusa_profile_bundle(input);

    // Assert
    assert_eq!(
        result,
        Err(PrusaProfileParseError::EntryBeforeSection { line_number: 1 })
    );
}

#[test]
fn rejects_malformed_section_header() {
    // Arrange
    let input = "[print:0.20mm QUALITY @MK4S\n";

    // Act
    let result = parse_prusa_profile_bundle(input);

    // Assert
    assert_eq!(
        result,
        Err(PrusaProfileParseError::MalformedSectionHeader {
            line_number: 1,
            line: "[print:0.20mm QUALITY @MK4S".to_owned(),
        })
    );
}

#[test]
fn rejects_empty_section_name() {
    // Arrange
    let input = "[print:]\n";

    // Act
    let result = parse_prusa_profile_bundle(input);

    // Assert
    assert_eq!(
        result,
        Err(PrusaProfileParseError::EmptySectionName { line_number: 1 })
    );
}

#[test]
fn rejects_unsupported_section_kind() {
    // Arrange
    let input = "[sla_print:0.05mm DETAIL]\n";

    // Act
    let result = parse_prusa_profile_bundle(input);

    // Assert
    assert_eq!(
        result,
        Err(PrusaProfileParseError::UnsupportedSectionKind {
            line_number: 1,
            kind: "sla_print".to_owned(),
        })
    );
}

#[test]
fn rejects_empty_key() {
    // Arrange
    let input = "\
[vendor]
 = prusa-fff
";

    // Act
    let result = parse_prusa_profile_bundle(input);

    // Assert
    assert_eq!(
        result,
        Err(PrusaProfileParseError::EmptyKey { line_number: 2 })
    );
}

#[test]
fn parses_checked_in_prusa_research_fixture_counts() {
    // Arrange
    let input = PRUSA_RESEARCH_INI;

    // Act
    let bundle = parse_prusa_profile_bundle(input).expect("PrusaResearch.ini should parse");
    let vendor_count = count_sections(&bundle, PrusaProfileSectionKind::Vendor);
    let printer_model_count = count_sections(&bundle, PrusaProfileSectionKind::PrinterModel);
    let print_count = count_sections(&bundle, PrusaProfileSectionKind::Print);
    let filament_count = count_sections(&bundle, PrusaProfileSectionKind::Filament);
    let printer_count = count_sections(&bundle, PrusaProfileSectionKind::Printer);
    let entry_count: usize = bundle
        .sections
        .iter()
        .map(|section| section.entries.len())
        .sum();

    // Assert
    assert_eq!(bundle.sections.len(), 6976);
    assert_eq!(entry_count, 27340);
    assert_eq!(vendor_count, 1);
    assert_eq!(printer_model_count, 35);
    assert_eq!(print_count, 633);
    assert_eq!(filament_count, 6069);
    assert_eq!(printer_count, 238);
}

fn count_sections(
    bundle: &slic3r_flavors::prusa_profile::PrusaProfileBundle,
    kind: PrusaProfileSectionKind,
) -> usize {
    bundle
        .sections
        .iter()
        .filter(|section| section.kind == kind)
        .count()
}

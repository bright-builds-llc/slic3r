use slic3r_contracts::{ChecklistStatus, FeatureOrigin, FlavorId, ParitySurface, VendorSourceRef};

pub(crate) const PRUSA_GCODE_OUTPUT_INVENTORY_ID: &str = "prusaslicer.gcode-output";
pub(crate) const PRUSA_GCODE_OUTPUT_VENDOR_ID: &str = "prusaslicer";
pub(crate) const PRUSA_GCODE_OUTPUT_SOURCE_REF: VendorSourceRef =
    VendorSourceRef::prusa_slicer_version_2_9_5();
pub(crate) const PRUSA_GCODE_OUTPUT_SOURCE_PATH: &str = "tests/fff_print/test_gcodewriter.cpp";
pub(crate) const PRUSA_GCODE_OUTPUT_FIXTURE_PATH: &str = "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode";
pub(crate) const PRUSA_GCODE_OUTPUT_EXPECTED_SUMMARY_PATH: &str = "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv";
pub(crate) const PRUSA_GCODE_OUTPUT_SCOPE_RECORD_PATH: &str =
    "packages/prusa-gcode-output-scope/gcode-output-scope.md";
pub(crate) const PRUSA_GCODE_OUTPUT_RESERVED_STATUS_TOKEN: &str = "fork.prusaslicer.gcode-output";

const EXPECTED_HEADER: &str =
    "source_ref\tfixture_path\tmetadata_key\tmetadata_value\tmarker_key\tmarker_value\tnotes";
const EXPECTED_COLUMN_COUNT: usize = 7;
const COLUMNS: [&str; EXPECTED_COLUMN_COUNT] = [
    "source_ref",
    "fixture_path",
    "metadata_key",
    "metadata_value",
    "marker_key",
    "marker_value",
    "notes",
];
const SOURCE_IDENTITY_NOTE: &str = "Accepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.";
const LINE_1_NOTE: &str = "Representative fixed-point feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.";
const LINE_2_NOTE: &str = "Representative integer feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.";
const LINE_3_NOTE: &str = "Representative one-decimal feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.";
const LINE_4_NOTE: &str = "Representative three-decimal rounded feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.";
const EXPECTED_ROWS: [ExpectedGcodeOutputRow; 5] = [
    ExpectedGcodeOutputRow {
        metadata_key: PrusaGcodeOutputMetadataKey::SourceIdentity,
        metadata_value: PrusaGcodeOutputMetadataValue::PrusaSourceIdentity,
        marker_key: PrusaGcodeOutputMarkerKey::SourceLiteral,
        marker_value: PrusaGcodeOutputMarkerValue::SourceLiteralLocation,
        note: SOURCE_IDENTITY_NOTE,
    },
    ExpectedGcodeOutputRow {
        metadata_key: PrusaGcodeOutputMetadataKey::FixtureRole,
        metadata_value: PrusaGcodeOutputMetadataValue::GcodewriterSetSpeedExpectedOutput,
        marker_key: PrusaGcodeOutputMarkerKey::Line1,
        marker_value: PrusaGcodeOutputMarkerValue::FeedrateFixedPoint,
        note: LINE_1_NOTE,
    },
    ExpectedGcodeOutputRow {
        metadata_key: PrusaGcodeOutputMetadataKey::FixtureRole,
        metadata_value: PrusaGcodeOutputMetadataValue::GcodewriterSetSpeedExpectedOutput,
        marker_key: PrusaGcodeOutputMarkerKey::Line2,
        marker_value: PrusaGcodeOutputMarkerValue::FeedrateInteger,
        note: LINE_2_NOTE,
    },
    ExpectedGcodeOutputRow {
        metadata_key: PrusaGcodeOutputMetadataKey::FixtureRole,
        metadata_value: PrusaGcodeOutputMetadataValue::GcodewriterSetSpeedExpectedOutput,
        marker_key: PrusaGcodeOutputMarkerKey::Line3,
        marker_value: PrusaGcodeOutputMarkerValue::FeedrateOneDecimal,
        note: LINE_3_NOTE,
    },
    ExpectedGcodeOutputRow {
        metadata_key: PrusaGcodeOutputMetadataKey::FixtureRole,
        metadata_value: PrusaGcodeOutputMetadataValue::GcodewriterSetSpeedExpectedOutput,
        marker_key: PrusaGcodeOutputMarkerKey::Line4,
        marker_value: PrusaGcodeOutputMarkerValue::FeedrateThreeDecimalRounded,
        note: LINE_4_NOTE,
    },
];

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaGcodeOutputSummary {
    pub rows: Vec<PrusaGcodeOutputSummaryRow>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaGcodeOutputSummaryRow {
    pub source_ref: VendorSourceRef,
    pub fixture_path: &'static str,
    pub metadata_key: PrusaGcodeOutputMetadataKey,
    pub metadata_value: PrusaGcodeOutputMetadataValue,
    pub marker_key: PrusaGcodeOutputMarkerKey,
    pub marker_value: PrusaGcodeOutputMarkerValue,
    pub notes: PrusaGcodeOutputNote,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputMetadataKey {
    SourceIdentity,
    FixtureRole,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputMetadataValue {
    PrusaSourceIdentity,
    GcodewriterSetSpeedExpectedOutput,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputMarkerKey {
    SourceLiteral,
    Line1,
    Line2,
    Line3,
    Line4,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputMarkerValue {
    SourceLiteralLocation,
    FeedrateFixedPoint,
    FeedrateInteger,
    FeedrateOneDecimal,
    FeedrateThreeDecimalRounded,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaGcodeOutputNote(String);

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PrusaGcodeOutputParseError {
    InvalidHeader {
        line: String,
    },
    WrongColumnCount {
        line_number: usize,
        expected: usize,
        actual: usize,
    },
    EmptyRequiredValue {
        line_number: usize,
        column: &'static str,
    },
    UnexpectedSourceRef {
        line_number: usize,
        value: String,
    },
    UnexpectedFixturePath {
        line_number: usize,
        value: String,
    },
    UnsupportedMetadataKey {
        line_number: usize,
        value: String,
    },
    UnsupportedMetadataValue {
        line_number: usize,
        value: String,
    },
    UnsupportedMarkerKey {
        line_number: usize,
        value: String,
    },
    UnsupportedMarkerValue {
        line_number: usize,
        value: String,
    },
    UnexpectedNote {
        line_number: usize,
        value: String,
    },
    DuplicateRow {
        line_number: usize,
        metadata_key: PrusaGcodeOutputMetadataKey,
        metadata_value: PrusaGcodeOutputMetadataValue,
        marker_key: PrusaGcodeOutputMarkerKey,
        marker_value: PrusaGcodeOutputMarkerValue,
    },
    UnexpectedRowOrder {
        line_number: usize,
        expected_metadata_key: PrusaGcodeOutputMetadataKey,
        expected_metadata_value: PrusaGcodeOutputMetadataValue,
        expected_marker_key: PrusaGcodeOutputMarkerKey,
        expected_marker_value: PrusaGcodeOutputMarkerValue,
        actual_metadata_key: PrusaGcodeOutputMetadataKey,
        actual_metadata_value: PrusaGcodeOutputMetadataValue,
        actual_marker_key: PrusaGcodeOutputMarkerKey,
        actual_marker_value: PrusaGcodeOutputMarkerValue,
    },
    MissingRow {
        metadata_key: PrusaGcodeOutputMetadataKey,
        metadata_value: PrusaGcodeOutputMetadataValue,
        marker_key: PrusaGcodeOutputMarkerKey,
        marker_value: PrusaGcodeOutputMarkerValue,
    },
    ExtraRow {
        line_number: usize,
        metadata_key: PrusaGcodeOutputMetadataKey,
        metadata_value: PrusaGcodeOutputMetadataValue,
        marker_key: PrusaGcodeOutputMarkerKey,
        marker_value: PrusaGcodeOutputMarkerValue,
    },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaGcodeOutputMetadata {
    pub inventory_id: &'static str,
    pub vendor_id: &'static str,
    pub flavor_id: FlavorId,
    pub origin: FeatureOrigin,
    pub parity_dependency: ParitySurface,
    pub checklist_status: ChecklistStatus,
    pub source_ref: VendorSourceRef,
    pub source_path: &'static str,
    pub fixture_path: &'static str,
    pub expected_summary_path: &'static str,
    pub scope_record_path: &'static str,
    pub reserved_future_status_token: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct ExpectedGcodeOutputRow {
    metadata_key: PrusaGcodeOutputMetadataKey,
    metadata_value: PrusaGcodeOutputMetadataValue,
    marker_key: PrusaGcodeOutputMarkerKey,
    marker_value: PrusaGcodeOutputMarkerValue,
    note: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct PrusaGcodeOutputRowKey {
    metadata_key: PrusaGcodeOutputMetadataKey,
    metadata_value: PrusaGcodeOutputMetadataValue,
    marker_key: PrusaGcodeOutputMarkerKey,
    marker_value: PrusaGcodeOutputMarkerValue,
}

pub type PrusaGcodeOutputParseResult = Result<PrusaGcodeOutputSummary, PrusaGcodeOutputParseError>;

pub const fn prusa_gcode_output_metadata() -> PrusaGcodeOutputMetadata {
    PrusaGcodeOutputMetadata {
        inventory_id: PRUSA_GCODE_OUTPUT_INVENTORY_ID,
        vendor_id: PRUSA_GCODE_OUTPUT_VENDOR_ID,
        flavor_id: FlavorId::PrusaSlicer,
        origin: FeatureOrigin::SharedDownstream,
        parity_dependency: ParitySurface::generated_outputs(),
        checklist_status: ChecklistStatus::FutureCandidate,
        source_ref: PRUSA_GCODE_OUTPUT_SOURCE_REF,
        source_path: PRUSA_GCODE_OUTPUT_SOURCE_PATH,
        fixture_path: PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
        expected_summary_path: PRUSA_GCODE_OUTPUT_EXPECTED_SUMMARY_PATH,
        scope_record_path: PRUSA_GCODE_OUTPUT_SCOPE_RECORD_PATH,
        reserved_future_status_token: PRUSA_GCODE_OUTPUT_RESERVED_STATUS_TOKEN,
    }
}

pub fn parse_prusa_gcode_output_summary(input: &str) -> PrusaGcodeOutputParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaGcodeOutputParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_header(header)?;

    let mut rows = Vec::new();
    let mut row_keys = Vec::new();

    for (line_offset, line) in lines.enumerate() {
        let line_number = line_offset + 2;
        let row = parse_summary_row(line, line_number)?;
        let row_key = PrusaGcodeOutputRowKey::from_row(&row);

        if row_keys.contains(&row_key) {
            return Err(PrusaGcodeOutputParseError::DuplicateRow {
                line_number,
                metadata_key: row.metadata_key,
                metadata_value: row.metadata_value,
                marker_key: row.marker_key,
                marker_value: row.marker_value,
            });
        }

        if !is_expected_row_key(row_key) {
            return Err(PrusaGcodeOutputParseError::ExtraRow {
                line_number,
                metadata_key: row.metadata_key,
                metadata_value: row.metadata_value,
                marker_key: row.marker_key,
                marker_value: row.marker_value,
            });
        }

        if let Some(expected_row) = EXPECTED_ROWS.get(line_offset).copied() {
            let expected_key = PrusaGcodeOutputRowKey::from_expected(expected_row);
            if row_key != expected_key {
                return Err(PrusaGcodeOutputParseError::UnexpectedRowOrder {
                    line_number,
                    expected_metadata_key: expected_row.metadata_key,
                    expected_metadata_value: expected_row.metadata_value,
                    expected_marker_key: expected_row.marker_key,
                    expected_marker_value: expected_row.marker_value,
                    actual_metadata_key: row.metadata_key,
                    actual_metadata_value: row.metadata_value,
                    actual_marker_key: row.marker_key,
                    actual_marker_value: row.marker_value,
                });
            }
        }

        row_keys.push(row_key);
        rows.push(row);
    }

    validate_missing_rows(&row_keys)?;

    Ok(PrusaGcodeOutputSummary { rows })
}

pub fn prusa_gcode_output_summary_lines(
    input: &str,
) -> Result<Vec<String>, PrusaGcodeOutputParseError> {
    let summary = parse_prusa_gcode_output_summary(input)?;
    let metadata = prusa_gcode_output_metadata();
    let mut lines = Vec::new();

    lines.push(summary_line(
        "surface",
        metadata.reserved_future_status_token,
    ));
    lines.push(summary_line("inventory_id", metadata.inventory_id));
    lines.push(summary_line("vendor_id", metadata.vendor_id));
    lines.push(summary_line("flavor_id", metadata.flavor_id.as_str()));
    lines.push(summary_line("origin", metadata.origin.as_str()));
    lines.push(summary_line(
        "parity_dependency",
        metadata.parity_dependency.as_str(),
    ));
    lines.push(summary_line(
        "checklist_status",
        metadata.checklist_status.as_str(),
    ));
    lines.push(summary_line("source_ref", metadata.source_ref.as_str()));
    lines.push(summary_line("source_path", metadata.source_path));
    lines.push(summary_line("fixture_path", metadata.fixture_path));
    lines.push(summary_line(
        "expected_summary_path",
        metadata.expected_summary_path,
    ));
    lines.push(summary_line(
        "scope_record_path",
        metadata.scope_record_path,
    ));
    lines.push(summary_line(
        "reserved_future_status_token",
        metadata.reserved_future_status_token,
    ));
    lines.push(format!("row_count\t{}", summary.rows.len()));

    for row in summary.rows {
        lines.push(format!(
            "evidence_row\t{}\t{}\t{}\t{}\t{}",
            row.metadata_key.as_str(),
            row.metadata_value.as_str(),
            row.marker_key.as_str(),
            row.marker_value.as_str(),
            row.notes.as_str()
        ));
    }

    Ok(lines)
}

impl PrusaGcodeOutputMetadataKey {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::SourceIdentity => "source_identity",
            Self::FixtureRole => "fixture_role",
        }
    }
}

impl PrusaGcodeOutputMetadataValue {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::PrusaSourceIdentity => PRUSA_GCODE_OUTPUT_SOURCE_REF.as_str(),
            Self::GcodewriterSetSpeedExpectedOutput => {
                "source-controlled-gcodewriter-set-speed-expected-output"
            }
        }
    }
}

impl PrusaGcodeOutputMarkerKey {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::SourceLiteral => "source_literal",
            Self::Line1 => "line_1",
            Self::Line2 => "line_2",
            Self::Line3 => "line_3",
            Self::Line4 => "line_4",
        }
    }
}

impl PrusaGcodeOutputMarkerValue {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::SourceLiteralLocation => "tests/fff_print/test_gcodewriter.cpp#L20-L35",
            Self::FeedrateFixedPoint => "G1 F99999.123",
            Self::FeedrateInteger => "G1 F1",
            Self::FeedrateOneDecimal => "G1 F203.2",
            Self::FeedrateThreeDecimalRounded => "G1 F203.201",
        }
    }
}

impl PrusaGcodeOutputNote {
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl PrusaGcodeOutputRowKey {
    fn from_expected(row: ExpectedGcodeOutputRow) -> Self {
        Self {
            metadata_key: row.metadata_key,
            metadata_value: row.metadata_value,
            marker_key: row.marker_key,
            marker_value: row.marker_value,
        }
    }

    fn from_row(row: &PrusaGcodeOutputSummaryRow) -> Self {
        Self {
            metadata_key: row.metadata_key,
            metadata_value: row.metadata_value,
            marker_key: row.marker_key,
            marker_value: row.marker_value,
        }
    }
}

fn validate_header(line: &str) -> Result<(), PrusaGcodeOutputParseError> {
    if line != EXPECTED_HEADER {
        return Err(PrusaGcodeOutputParseError::InvalidHeader {
            line: line.to_owned(),
        });
    }

    Ok(())
}

fn parse_summary_row(
    line: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputSummaryRow, PrusaGcodeOutputParseError> {
    let columns: Vec<&str> = line.split('\t').collect();
    validate_column_count(&columns, line_number)?;
    validate_required_values(&columns, line_number)?;

    let source_ref = parse_source_ref(columns[0], line_number)?;
    let fixture_path = parse_fixture_path(columns[1], line_number)?;
    let metadata_key = parse_metadata_key(columns[2], line_number)?;
    let metadata_value = parse_metadata_value(columns[3], line_number)?;
    let marker_key = parse_marker_key(columns[4], line_number)?;
    let marker_value = parse_marker_value(columns[5], line_number)?;
    let row_key = PrusaGcodeOutputRowKey {
        metadata_key,
        metadata_value,
        marker_key,
        marker_value,
    };

    Ok(PrusaGcodeOutputSummaryRow {
        source_ref,
        fixture_path,
        metadata_key,
        metadata_value,
        marker_key,
        marker_value,
        notes: parse_note(columns[6], row_key, line_number)?,
    })
}

fn validate_column_count(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaGcodeOutputParseError> {
    if columns.len() != EXPECTED_COLUMN_COUNT {
        return Err(PrusaGcodeOutputParseError::WrongColumnCount {
            line_number,
            expected: EXPECTED_COLUMN_COUNT,
            actual: columns.len(),
        });
    }

    Ok(())
}

fn validate_required_values(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaGcodeOutputParseError> {
    for (index, value) in columns.iter().enumerate() {
        if value.is_empty() {
            return Err(PrusaGcodeOutputParseError::EmptyRequiredValue {
                line_number,
                column: COLUMNS[index],
            });
        }
    }

    Ok(())
}

fn parse_source_ref(
    value: &str,
    line_number: usize,
) -> Result<VendorSourceRef, PrusaGcodeOutputParseError> {
    if value != PRUSA_GCODE_OUTPUT_SOURCE_REF.as_str() {
        return Err(PrusaGcodeOutputParseError::UnexpectedSourceRef {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_GCODE_OUTPUT_SOURCE_REF)
}

fn parse_fixture_path(
    value: &str,
    line_number: usize,
) -> Result<&'static str, PrusaGcodeOutputParseError> {
    if value != PRUSA_GCODE_OUTPUT_FIXTURE_PATH {
        return Err(PrusaGcodeOutputParseError::UnexpectedFixturePath {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_GCODE_OUTPUT_FIXTURE_PATH)
}

fn parse_metadata_key(
    value: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputMetadataKey, PrusaGcodeOutputParseError> {
    match value {
        "source_identity" => Ok(PrusaGcodeOutputMetadataKey::SourceIdentity),
        "fixture_role" => Ok(PrusaGcodeOutputMetadataKey::FixtureRole),
        _ => Err(PrusaGcodeOutputParseError::UnsupportedMetadataKey {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_metadata_value(
    value: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputMetadataValue, PrusaGcodeOutputParseError> {
    match value {
        value if value == PRUSA_GCODE_OUTPUT_SOURCE_REF.as_str() => {
            Ok(PrusaGcodeOutputMetadataValue::PrusaSourceIdentity)
        }
        "source-controlled-gcodewriter-set-speed-expected-output" => {
            Ok(PrusaGcodeOutputMetadataValue::GcodewriterSetSpeedExpectedOutput)
        }
        _ => Err(PrusaGcodeOutputParseError::UnsupportedMetadataValue {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_marker_key(
    value: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputMarkerKey, PrusaGcodeOutputParseError> {
    match value {
        "source_literal" => Ok(PrusaGcodeOutputMarkerKey::SourceLiteral),
        "line_1" => Ok(PrusaGcodeOutputMarkerKey::Line1),
        "line_2" => Ok(PrusaGcodeOutputMarkerKey::Line2),
        "line_3" => Ok(PrusaGcodeOutputMarkerKey::Line3),
        "line_4" => Ok(PrusaGcodeOutputMarkerKey::Line4),
        _ => Err(PrusaGcodeOutputParseError::UnsupportedMarkerKey {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_marker_value(
    value: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputMarkerValue, PrusaGcodeOutputParseError> {
    match value {
        "tests/fff_print/test_gcodewriter.cpp#L20-L35" => {
            Ok(PrusaGcodeOutputMarkerValue::SourceLiteralLocation)
        }
        "G1 F99999.123" => Ok(PrusaGcodeOutputMarkerValue::FeedrateFixedPoint),
        "G1 F1" => Ok(PrusaGcodeOutputMarkerValue::FeedrateInteger),
        "G1 F203.2" => Ok(PrusaGcodeOutputMarkerValue::FeedrateOneDecimal),
        "G1 F203.201" => Ok(PrusaGcodeOutputMarkerValue::FeedrateThreeDecimalRounded),
        _ => Err(PrusaGcodeOutputParseError::UnsupportedMarkerValue {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_note(
    value: &str,
    row_key: PrusaGcodeOutputRowKey,
    line_number: usize,
) -> Result<PrusaGcodeOutputNote, PrusaGcodeOutputParseError> {
    let Some(expected_row) = expected_row_for_key(row_key) else {
        return Ok(PrusaGcodeOutputNote(value.to_owned()));
    };

    if value != expected_row.note {
        return Err(PrusaGcodeOutputParseError::UnexpectedNote {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PrusaGcodeOutputNote(value.to_owned()))
}

fn expected_row_for_key(row_key: PrusaGcodeOutputRowKey) -> Option<ExpectedGcodeOutputRow> {
    EXPECTED_ROWS
        .iter()
        .copied()
        .find(|row| PrusaGcodeOutputRowKey::from_expected(*row) == row_key)
}

fn is_expected_row_key(row_key: PrusaGcodeOutputRowKey) -> bool {
    expected_row_for_key(row_key).is_some()
}

fn validate_missing_rows(
    row_keys: &[PrusaGcodeOutputRowKey],
) -> Result<(), PrusaGcodeOutputParseError> {
    for expected_row in EXPECTED_ROWS {
        let row_key = PrusaGcodeOutputRowKey::from_expected(expected_row);
        if !row_keys.contains(&row_key) {
            return Err(PrusaGcodeOutputParseError::MissingRow {
                metadata_key: expected_row.metadata_key,
                metadata_value: expected_row.metadata_value,
                marker_key: expected_row.marker_key,
                marker_value: expected_row.marker_value,
            });
        }
    }

    Ok(())
}

fn summary_line(key: &str, value: &str) -> String {
    format!("{key}\t{value}")
}

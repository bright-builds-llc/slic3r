use slic3r_contracts::VendorSourceRef;

pub(crate) const PRUSA_ARC_FITTING_INVENTORY_ID: &str = "prusaslicer.arc-fitting";
pub(crate) const PRUSA_ARC_FITTING_VENDOR_ID: &str = "prusaslicer";
pub(crate) const PRUSA_ARC_FITTING_SOURCE_REF: VendorSourceRef =
    VendorSourceRef::prusa_slicer_version_2_9_5();
pub(crate) const PRUSA_ARC_FITTING_SOURCE_PATH: &str = "src/libslic3r/Geometry/ArcWelder.cpp";
pub(crate) const PRUSA_ARC_FITTING_FIXTURE_CORPUS_PATH: &str =
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting";
pub(crate) const PRUSA_ARC_FITTING_FIXTURE_PATH: &str = "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/arc-fitting-observations.gcode";
pub(crate) const PRUSA_ARC_FITTING_EXPECTED_SUMMARY_PATH: &str =
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/expected-arc-summary.tsv";
pub(crate) const PRUSA_ARC_FITTING_SCOPE_RECORD_PATH: &str =
    "packages/prusa-arc-fitting-scope/arc-fitting-scope.md";
pub(crate) const PRUSA_ARC_FITTING_RESERVED_STATUS_TOKEN: &str = "fork.prusaslicer.arc-fitting";

const _: [&str; 6] = [
    PRUSA_ARC_FITTING_INVENTORY_ID,
    PRUSA_ARC_FITTING_VENDOR_ID,
    PRUSA_ARC_FITTING_SOURCE_PATH,
    PRUSA_ARC_FITTING_FIXTURE_CORPUS_PATH,
    PRUSA_ARC_FITTING_SCOPE_RECORD_PATH,
    PRUSA_ARC_FITTING_RESERVED_STATUS_TOKEN,
];

const ARC_EXPECTED_HEADER: &str =
    "source_ref\tfixture_path\tarc_field\tarc_category\tarc_value\tevidence_boundary";
const ARC_EXPECTED_COLUMN_COUNT: usize = 6;
const ARC_COLUMNS: [&str; ARC_EXPECTED_COLUMN_COUNT] = [
    "source_ref",
    "fixture_path",
    "arc_field",
    "arc_category",
    "arc_value",
    "evidence_boundary",
];
const ARC_INVENTORY_SOURCE_PATHS_VALUE: &str =
    "packages/fork-inventories/prusaslicer.tsv;src/libslic3r/Geometry/ArcWelder.cpp";
const ARC_SOURCE_ANCHOR_VALUE: &str =
    "ArcWelder.cpp#L4-L7;ArcWelder.cpp#L400-L404;ArcWelder.cpp#L630-L634";
const ARC_FIXTURE_ID_VALUE: &str = "arc-fitting-observations.gcode";
const ARC_COMMAND_COUNTS_VALUE: &str = "G2:1;G3:1;total_arc_commands:2";
const ARC_DIRECTION_COUNTS_VALUE: &str = "clockwise_g2:1;counterclockwise_g3:1";
const ARC_CENTER_OFFSET_OBSERVATIONS_VALUE: &str = "i_values:5.000,-5.000;j_values:0.000,0.000";
const ARC_COORDINATE_BOUNDS_VALUE: &str = "x_min:0.000;x_max:10.000;y_min:0.000;y_max:0.000";
const ARC_EXTRUSION_OBSERVATIONS_VALUE: &str = "e_values:0.50000,1.00000;e_axis_observed:true";
const ARC_FEEDRATE_OBSERVATIONS_VALUE: &str = "F1800:2";
const ARC_EVIDENCE_BOUNDARY_VALUE: &str = "checked-in-arc-summary-only";
const ARC_SOURCE_REF_BOUNDARY: &str = "Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.";
const ARC_INVENTORY_SOURCE_PATHS_BOUNDARY: &str = "Inventory source paths only: `packages/fork-inventories/prusaslicer.tsv` and `src/libslic3r/Geometry/ArcWelder.cpp`.";
const ARC_SOURCE_ANCHOR_BOUNDARY: &str =
    "Reviewed source anchors only; no upstream import, Git access, or runtime source discovery.";
const ARC_FIXTURE_ID_BOUNDARY: &str =
    "Fixture identity string only for the Phase 58 checked-in fixture.";
const ARC_FIXTURE_PATH_BOUNDARY: &str = "Checked-in fixture path under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.arc-fitting/` only.";
const ARC_COMMAND_COUNTS_BOUNDARY: &str = "Counts of approved G2/G3 arc command observations in the checked-in summary only; no byte-for-byte G-code parity or generator parity.";
const ARC_DIRECTION_COUNTS_BOUNDARY: &str = "Clockwise/counterclockwise direction observations from the checked-in summary only; no algorithm equivalence or tolerance claim.";
const ARC_CENTER_OFFSET_OBSERVATIONS_BOUNDARY: &str = "Observed I/J center-offset facts from the checked-in summary only; no geometry, planner, or printer-runtime behavior claim.";
const ARC_COORDINATE_BOUNDS_BOUNDARY: &str =
    "Bounded coordinate observations only; no toolpath geometry or printability claim.";
const ARC_EXTRUSION_OBSERVATIONS_BOUNDARY: &str =
    "Summary extrusion observations only; no material-use, runtime, or printability claim.";
const ARC_FEEDRATE_OBSERVATIONS_BOUNDARY: &str =
    "Feedrate metadata observations only; no timing, firmware, or printer-runtime behavior claim.";
const ARC_EVIDENCE_BOUNDARY_BOUNDARY: &str =
    "Checked-in fixture summary evidence only; no executable public status claim before Phase 60.";

macro_rules! source_row {
    ($field:ident, $category:ident, $boundary:expr $(,)?) => {
        ExpectedArcRow {
            arc_field: PrusaArcFittingField::$field,
            arc_category: PrusaArcFittingCategory::$category,
            arc_value: PrusaArcFittingValue::SourceRef(PRUSA_ARC_FITTING_SOURCE_REF),
            evidence_boundary: $boundary,
        }
    };
}

macro_rules! text_row {
    ($field:ident, $category:ident, $value:expr, $boundary:expr $(,)?) => {
        ExpectedArcRow {
            arc_field: PrusaArcFittingField::$field,
            arc_category: PrusaArcFittingCategory::$category,
            arc_value: PrusaArcFittingValue::Text($value),
            evidence_boundary: $boundary,
        }
    };
}

const EXPECTED_ARC_ROWS: [ExpectedArcRow; 12] = [
    source_row!(SourceRef, SourceIdentity, ARC_SOURCE_REF_BOUNDARY),
    text_row!(
        InventorySourcePaths,
        SourceIdentity,
        ARC_INVENTORY_SOURCE_PATHS_VALUE,
        ARC_INVENTORY_SOURCE_PATHS_BOUNDARY,
    ),
    text_row!(
        SourceAnchor,
        SourceIdentity,
        ARC_SOURCE_ANCHOR_VALUE,
        ARC_SOURCE_ANCHOR_BOUNDARY
    ),
    text_row!(
        FixtureId,
        FixtureIdentity,
        ARC_FIXTURE_ID_VALUE,
        ARC_FIXTURE_ID_BOUNDARY
    ),
    text_row!(
        FixturePath,
        FixtureIdentity,
        PRUSA_ARC_FITTING_FIXTURE_PATH,
        ARC_FIXTURE_PATH_BOUNDARY,
    ),
    text_row!(
        ArcCommandCounts,
        CommandObservations,
        ARC_COMMAND_COUNTS_VALUE,
        ARC_COMMAND_COUNTS_BOUNDARY,
    ),
    text_row!(
        ArcDirectionCounts,
        CommandObservations,
        ARC_DIRECTION_COUNTS_VALUE,
        ARC_DIRECTION_COUNTS_BOUNDARY,
    ),
    text_row!(
        CenterOffsetObservations,
        CenterOffsetObservations,
        ARC_CENTER_OFFSET_OBSERVATIONS_VALUE,
        ARC_CENTER_OFFSET_OBSERVATIONS_BOUNDARY,
    ),
    text_row!(
        CoordinateBounds,
        CoordinateBounds,
        ARC_COORDINATE_BOUNDS_VALUE,
        ARC_COORDINATE_BOUNDS_BOUNDARY,
    ),
    text_row!(
        ExtrusionObservations,
        ExtrusionObservations,
        ARC_EXTRUSION_OBSERVATIONS_VALUE,
        ARC_EXTRUSION_OBSERVATIONS_BOUNDARY,
    ),
    text_row!(
        FeedrateObservations,
        FeedrateObservations,
        ARC_FEEDRATE_OBSERVATIONS_VALUE,
        ARC_FEEDRATE_OBSERVATIONS_BOUNDARY,
    ),
    text_row!(
        EvidenceBoundary,
        BoundaryText,
        ARC_EVIDENCE_BOUNDARY_VALUE,
        ARC_EVIDENCE_BOUNDARY_BOUNDARY,
    ),
];

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaArcFittingSummary {
    rows: Vec<PrusaArcFittingSummaryRow>,
    facts: PrusaArcFittingFacts,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaArcFittingSummaryRow {
    pub source_ref: VendorSourceRef,
    pub fixture_path: &'static str,
    pub arc_field: PrusaArcFittingField,
    pub arc_category: PrusaArcFittingCategory,
    pub arc_value: PrusaArcFittingValue,
    pub evidence_boundary: PrusaArcFittingEvidenceBoundary,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaArcFittingFacts {
    pub source_ref: VendorSourceRef,
    pub inventory_source_paths: &'static str,
    pub source_anchor: &'static str,
    pub fixture_id: &'static str,
    pub fixture_path: &'static str,
    pub arc_command_counts: &'static str,
    pub arc_direction_counts: &'static str,
    pub center_offset_observations: &'static str,
    pub coordinate_bounds: &'static str,
    pub extrusion_observations: &'static str,
    pub feedrate_observations: &'static str,
    pub evidence_boundary: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaArcFittingField {
    SourceRef,
    InventorySourcePaths,
    SourceAnchor,
    FixtureId,
    FixturePath,
    ArcCommandCounts,
    ArcDirectionCounts,
    CenterOffsetObservations,
    CoordinateBounds,
    ExtrusionObservations,
    FeedrateObservations,
    EvidenceBoundary,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaArcFittingCategory {
    SourceIdentity,
    FixtureIdentity,
    CommandObservations,
    CenterOffsetObservations,
    CoordinateBounds,
    ExtrusionObservations,
    FeedrateObservations,
    BoundaryText,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaArcFittingValue {
    SourceRef(VendorSourceRef),
    Text(&'static str),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaArcFittingEvidenceBoundary(&'static str);

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PrusaArcFittingParseError {
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
    UnsupportedArcField {
        line_number: usize,
        value: String,
    },
    UnsupportedArcCategory {
        line_number: usize,
        value: String,
    },
    UnexpectedArcCategory {
        line_number: usize,
        arc_field: PrusaArcFittingField,
        value: String,
    },
    UnexpectedArcValue {
        line_number: usize,
        arc_field: PrusaArcFittingField,
        value: String,
    },
    UnexpectedEvidenceBoundary {
        line_number: usize,
        arc_field: PrusaArcFittingField,
        value: String,
    },
    DuplicateRow {
        line_number: usize,
        arc_field: PrusaArcFittingField,
    },
    UnexpectedRowOrder {
        line_number: usize,
        expected_arc_field: PrusaArcFittingField,
        actual_arc_field: PrusaArcFittingField,
    },
    MissingRow {
        arc_field: PrusaArcFittingField,
    },
    ExtraRow {
        line_number: usize,
        arc_field: PrusaArcFittingField,
    },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct ExpectedArcRow {
    arc_field: PrusaArcFittingField,
    arc_category: PrusaArcFittingCategory,
    arc_value: PrusaArcFittingValue,
    evidence_boundary: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct ArcRowKey {
    arc_field: PrusaArcFittingField,
}

pub type PrusaArcFittingParseResult = Result<PrusaArcFittingSummary, PrusaArcFittingParseError>;

pub fn parse_prusa_arc_fitting_summary(input: &str) -> PrusaArcFittingParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaArcFittingParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_arc_header(header)?;

    let mut rows = Vec::new();
    let mut row_keys = Vec::new();

    for (line_offset, line) in lines.enumerate() {
        let line_number = line_offset + 2;
        let row = parse_arc_summary_row(line, line_number)?;
        let row_key = ArcRowKey::from_row(&row);

        if row_keys.contains(&row_key) {
            return Err(PrusaArcFittingParseError::DuplicateRow {
                line_number,
                arc_field: row.arc_field,
            });
        }

        if !is_expected_arc_row_key(row_key) {
            return Err(PrusaArcFittingParseError::ExtraRow {
                line_number,
                arc_field: row.arc_field,
            });
        }

        let Some(expected_row) = EXPECTED_ARC_ROWS.get(line_offset).copied() else {
            return Err(PrusaArcFittingParseError::ExtraRow {
                line_number,
                arc_field: row.arc_field,
            });
        };
        if row.arc_field != expected_row.arc_field {
            return Err(PrusaArcFittingParseError::UnexpectedRowOrder {
                line_number,
                expected_arc_field: expected_row.arc_field,
                actual_arc_field: row.arc_field,
            });
        }

        row_keys.push(row_key);
        rows.push(row);
    }

    validate_missing_arc_rows(&row_keys)?;

    Ok(PrusaArcFittingSummary {
        rows,
        facts: PrusaArcFittingFacts::from_validated_rows(),
    })
}

pub fn prusa_arc_fitting_summary_lines(
    input: &str,
) -> Result<Vec<String>, PrusaArcFittingParseError> {
    let summary = parse_prusa_arc_fitting_summary(input)?;
    let facts = summary.facts();

    Ok(vec![
        summary_line("arc_summary_path", PRUSA_ARC_FITTING_EXPECTED_SUMMARY_PATH),
        summary_line("arc_row_count", &summary.rows().len().to_string()),
        summary_line("source_ref", facts.source_ref.as_str()),
        summary_line("inventory_source_paths", facts.inventory_source_paths),
        summary_line("source_anchor", facts.source_anchor),
        summary_line("fixture_id", facts.fixture_id),
        summary_line("fixture_path", facts.fixture_path),
        summary_line("arc_command_counts", facts.arc_command_counts),
        summary_line("arc_direction_counts", facts.arc_direction_counts),
        summary_line(
            "center_offset_observations",
            facts.center_offset_observations,
        ),
        summary_line("coordinate_bounds", facts.coordinate_bounds),
        summary_line("extrusion_observations", facts.extrusion_observations),
        summary_line("feedrate_observations", facts.feedrate_observations),
        summary_line("evidence_boundary", facts.evidence_boundary),
    ])
}

impl PrusaArcFittingSummary {
    pub fn rows(&self) -> &[PrusaArcFittingSummaryRow] {
        &self.rows
    }

    pub const fn facts(&self) -> PrusaArcFittingFacts {
        self.facts
    }
}

impl PrusaArcFittingValue {
    const fn as_str(self) -> &'static str {
        match self {
            PrusaArcFittingValue::SourceRef(source_ref) => source_ref.as_str(),
            PrusaArcFittingValue::Text(value) => value,
        }
    }
}

impl ArcRowKey {
    const fn from_row(row: &PrusaArcFittingSummaryRow) -> Self {
        Self {
            arc_field: row.arc_field,
        }
    }

    const fn from_expected(row: ExpectedArcRow) -> Self {
        Self {
            arc_field: row.arc_field,
        }
    }
}

impl PrusaArcFittingFacts {
    const fn from_validated_rows() -> Self {
        Self {
            source_ref: PRUSA_ARC_FITTING_SOURCE_REF,
            inventory_source_paths: ARC_INVENTORY_SOURCE_PATHS_VALUE,
            source_anchor: ARC_SOURCE_ANCHOR_VALUE,
            fixture_id: ARC_FIXTURE_ID_VALUE,
            fixture_path: PRUSA_ARC_FITTING_FIXTURE_PATH,
            arc_command_counts: ARC_COMMAND_COUNTS_VALUE,
            arc_direction_counts: ARC_DIRECTION_COUNTS_VALUE,
            center_offset_observations: ARC_CENTER_OFFSET_OBSERVATIONS_VALUE,
            coordinate_bounds: ARC_COORDINATE_BOUNDS_VALUE,
            extrusion_observations: ARC_EXTRUSION_OBSERVATIONS_VALUE,
            feedrate_observations: ARC_FEEDRATE_OBSERVATIONS_VALUE,
            evidence_boundary: ARC_EVIDENCE_BOUNDARY_VALUE,
        }
    }
}

fn validate_arc_header(line: &str) -> Result<(), PrusaArcFittingParseError> {
    if line != ARC_EXPECTED_HEADER {
        return Err(PrusaArcFittingParseError::InvalidHeader {
            line: line.to_owned(),
        });
    }

    Ok(())
}

fn parse_arc_summary_row(
    line: &str,
    line_number: usize,
) -> Result<PrusaArcFittingSummaryRow, PrusaArcFittingParseError> {
    let columns: Vec<&str> = line.split('\t').collect();
    validate_arc_column_count(&columns, line_number)?;
    validate_arc_required_values(&columns, line_number)?;

    let source_ref = parse_arc_source_ref(columns[0], line_number)?;
    let fixture_path = parse_arc_fixture_path(columns[1], line_number)?;
    let arc_field = parse_arc_field(columns[2], line_number)?;
    let arc_category = parse_arc_category(columns[3], line_number)?;
    let Some(expected_row) = expected_arc_row_for_field(arc_field) else {
        return Err(PrusaArcFittingParseError::ExtraRow {
            line_number,
            arc_field,
        });
    };

    if arc_category != expected_row.arc_category {
        return Err(PrusaArcFittingParseError::UnexpectedArcCategory {
            line_number,
            arc_field,
            value: columns[3].to_owned(),
        });
    }

    let arc_value = parse_arc_value(columns[4], expected_row, line_number)?;
    let evidence_boundary = parse_arc_evidence_boundary(columns[5], expected_row, line_number)?;

    Ok(PrusaArcFittingSummaryRow {
        source_ref,
        fixture_path,
        arc_field,
        arc_category,
        arc_value,
        evidence_boundary,
    })
}

fn validate_arc_column_count(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaArcFittingParseError> {
    if columns.len() != ARC_EXPECTED_COLUMN_COUNT {
        return Err(PrusaArcFittingParseError::WrongColumnCount {
            line_number,
            expected: ARC_EXPECTED_COLUMN_COUNT,
            actual: columns.len(),
        });
    }

    Ok(())
}

fn validate_arc_required_values(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaArcFittingParseError> {
    for (index, value) in columns.iter().enumerate() {
        if value.is_empty() {
            return Err(PrusaArcFittingParseError::EmptyRequiredValue {
                line_number,
                column: ARC_COLUMNS[index],
            });
        }
    }

    Ok(())
}

fn parse_arc_source_ref(
    value: &str,
    line_number: usize,
) -> Result<VendorSourceRef, PrusaArcFittingParseError> {
    if value != PRUSA_ARC_FITTING_SOURCE_REF.as_str() {
        return Err(PrusaArcFittingParseError::UnexpectedSourceRef {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_ARC_FITTING_SOURCE_REF)
}

fn parse_arc_fixture_path(
    value: &str,
    line_number: usize,
) -> Result<&'static str, PrusaArcFittingParseError> {
    if value != PRUSA_ARC_FITTING_FIXTURE_PATH {
        return Err(PrusaArcFittingParseError::UnexpectedFixturePath {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_ARC_FITTING_FIXTURE_PATH)
}

fn parse_arc_field(
    value: &str,
    line_number: usize,
) -> Result<PrusaArcFittingField, PrusaArcFittingParseError> {
    match value {
        "source_ref" => Ok(PrusaArcFittingField::SourceRef),
        "inventory_source_paths" => Ok(PrusaArcFittingField::InventorySourcePaths),
        "source_anchor" => Ok(PrusaArcFittingField::SourceAnchor),
        "fixture_id" => Ok(PrusaArcFittingField::FixtureId),
        "fixture_path" => Ok(PrusaArcFittingField::FixturePath),
        "arc_command_counts" => Ok(PrusaArcFittingField::ArcCommandCounts),
        "arc_direction_counts" => Ok(PrusaArcFittingField::ArcDirectionCounts),
        "center_offset_observations" => Ok(PrusaArcFittingField::CenterOffsetObservations),
        "coordinate_bounds" => Ok(PrusaArcFittingField::CoordinateBounds),
        "extrusion_observations" => Ok(PrusaArcFittingField::ExtrusionObservations),
        "feedrate_observations" => Ok(PrusaArcFittingField::FeedrateObservations),
        "evidence_boundary" => Ok(PrusaArcFittingField::EvidenceBoundary),
        _ => Err(PrusaArcFittingParseError::UnsupportedArcField {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_arc_category(
    value: &str,
    line_number: usize,
) -> Result<PrusaArcFittingCategory, PrusaArcFittingParseError> {
    match value {
        "source identity" => Ok(PrusaArcFittingCategory::SourceIdentity),
        "fixture identity" => Ok(PrusaArcFittingCategory::FixtureIdentity),
        "command observations" => Ok(PrusaArcFittingCategory::CommandObservations),
        "center offset observations" => Ok(PrusaArcFittingCategory::CenterOffsetObservations),
        "coordinate bounds" => Ok(PrusaArcFittingCategory::CoordinateBounds),
        "extrusion observations" => Ok(PrusaArcFittingCategory::ExtrusionObservations),
        "feedrate observations" => Ok(PrusaArcFittingCategory::FeedrateObservations),
        "boundary text" => Ok(PrusaArcFittingCategory::BoundaryText),
        _ => Err(PrusaArcFittingParseError::UnsupportedArcCategory {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_arc_value(
    value: &str,
    expected_row: ExpectedArcRow,
    line_number: usize,
) -> Result<PrusaArcFittingValue, PrusaArcFittingParseError> {
    if value != expected_row.arc_value.as_str() {
        return Err(PrusaArcFittingParseError::UnexpectedArcValue {
            line_number,
            arc_field: expected_row.arc_field,
            value: value.to_owned(),
        });
    }

    Ok(expected_row.arc_value)
}

fn parse_arc_evidence_boundary(
    value: &str,
    expected_row: ExpectedArcRow,
    line_number: usize,
) -> Result<PrusaArcFittingEvidenceBoundary, PrusaArcFittingParseError> {
    if value != expected_row.evidence_boundary {
        return Err(PrusaArcFittingParseError::UnexpectedEvidenceBoundary {
            line_number,
            arc_field: expected_row.arc_field,
            value: value.to_owned(),
        });
    }

    Ok(PrusaArcFittingEvidenceBoundary(
        expected_row.evidence_boundary,
    ))
}

fn expected_arc_row_for_field(arc_field: PrusaArcFittingField) -> Option<ExpectedArcRow> {
    EXPECTED_ARC_ROWS
        .iter()
        .copied()
        .find(|row| row.arc_field == arc_field)
}

fn is_expected_arc_row_key(row_key: ArcRowKey) -> bool {
    expected_arc_row_for_field(row_key.arc_field).is_some()
}

fn validate_missing_arc_rows(row_keys: &[ArcRowKey]) -> Result<(), PrusaArcFittingParseError> {
    for expected_row in EXPECTED_ARC_ROWS {
        let row_key = ArcRowKey::from_expected(expected_row);
        if !row_keys.contains(&row_key) {
            return Err(PrusaArcFittingParseError::MissingRow {
                arc_field: expected_row.arc_field,
            });
        }
    }

    Ok(())
}

fn summary_line(key: &str, value: &str) -> String {
    format!("{key}\t{value}")
}

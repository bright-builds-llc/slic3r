use slic3r_contracts::{ChecklistStatus, FeatureOrigin, FlavorId, ParitySurface, VendorSourceRef};

pub(crate) const PRUSA_WALL_SEAM_INVENTORY_ID: &str = "prusaslicer.wall-seam";
pub(crate) const PRUSA_WALL_SEAM_VENDOR_ID: &str = "prusaslicer";
pub(crate) const PRUSA_WALL_SEAM_SOURCE_REF: VendorSourceRef =
    VendorSourceRef::prusa_slicer_version_2_9_5();
pub(crate) const PRUSA_WALL_SEAM_SOURCE_PATH: &str = "src/libslic3r/GCode/SeamAligned.cpp";
pub(crate) const PRUSA_WALL_SEAM_FIXTURE_CORPUS_PATH: &str =
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam";
pub(crate) const PRUSA_WALL_SEAM_FIXTURE_PATH: &str =
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/wall-seam-observations.gcode";
pub(crate) const PRUSA_WALL_SEAM_EXPECTED_SUMMARY_PATH: &str = "packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/expected-wall-seam-summary.tsv";
pub(crate) const PRUSA_WALL_SEAM_SCOPE_RECORD_PATH: &str =
    "packages/prusa-wall-seam-scope/wall-seam-scope.md";
pub(crate) const PRUSA_WALL_SEAM_RESERVED_STATUS_TOKEN: &str = "fork.prusaslicer.wall-seam";
static PRUSA_WALL_SEAM_INVENTORY_SOURCE_PATHS: [&str; 2] = [
    "packages/fork-inventories/prusaslicer.tsv",
    PRUSA_WALL_SEAM_SOURCE_PATH,
];
static PRUSA_WALL_SEAM_SOURCE_ANCHORS: [&str; 4] = [
    "SeamAligned.cpp#L16",
    "SeamAligned.cpp#L115-L148",
    "SeamAligned.cpp#L272-L313",
    "SeamAligned.cpp#L463-L525",
];
static PRUSA_WALL_SEAM_DEFERRED_SURFACES: [&str; 25] = [
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

const _: [&str; 7] = [
    PRUSA_WALL_SEAM_INVENTORY_ID,
    PRUSA_WALL_SEAM_VENDOR_ID,
    PRUSA_WALL_SEAM_SOURCE_PATH,
    PRUSA_WALL_SEAM_FIXTURE_CORPUS_PATH,
    PRUSA_WALL_SEAM_FIXTURE_PATH,
    PRUSA_WALL_SEAM_SCOPE_RECORD_PATH,
    PRUSA_WALL_SEAM_RESERVED_STATUS_TOKEN,
];

const WALL_SEAM_EXPECTED_HEADER: &str = "source_ref\tfixture_path\twall_seam_field\twall_seam_category\twall_seam_value\tevidence_boundary";
const WALL_SEAM_EXPECTED_COLUMN_COUNT: usize = 6;
const WALL_SEAM_COLUMNS: [&str; WALL_SEAM_EXPECTED_COLUMN_COUNT] = [
    "source_ref",
    "fixture_path",
    "wall_seam_field",
    "wall_seam_category",
    "wall_seam_value",
    "evidence_boundary",
];
const WALL_SEAM_INVENTORY_SOURCE_PATHS_VALUE: &str =
    "packages/fork-inventories/prusaslicer.tsv;src/libslic3r/GCode/SeamAligned.cpp";
const WALL_SEAM_SOURCE_ANCHOR_VALUE: &str = "SeamAligned.cpp#L16;SeamAligned.cpp#L115-L148;SeamAligned.cpp#L272-L313;SeamAligned.cpp#L463-L525";
const WALL_SEAM_FIXTURE_ID_VALUE: &str = "wall-seam-observations.gcode";
const WALL_SEAM_TRANSITION_OBSERVATIONS_VALUE: &str =
    "seam_markers:seam_start,seam_resume;transition_count:2";
const WALL_SEAM_LAYER_CONTEXT_OBSERVATIONS_VALUE: &str = "layer_index:0;z_values:0.200";
const WALL_SEAM_TRAVEL_CONTEXT_OBSERVATIONS_VALUE: &str =
    "travel_moves:1;travel_from:12.500,8.000;travel_to:14.000,8.750";
const WALL_SEAM_COORDINATE_BOUNDS_VALUE: &str =
    "x_min:12.500;x_max:15.250;y_min:8.000;y_max:9.500;z_min:0.200;z_max:0.200";
const WALL_SEAM_EXTRUSION_OBSERVATIONS_VALUE: &str =
    "e_values:0.12000,0.28000;e_axis_observed:true";
const WALL_SEAM_RETRACTION_OBSERVATIONS_VALUE: &str =
    "e_marker_values:0.28000,0.24000;retraction_marker_observed:true";
const WALL_SEAM_EVIDENCE_BOUNDARY_VALUE: &str = "checked-in-wall-seam-summary-only";
const WALL_SEAM_SOURCE_REF_BOUNDARY: &str = "Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.";
const WALL_SEAM_INVENTORY_SOURCE_PATHS_BOUNDARY: &str = "Inventory source paths only: `packages/fork-inventories/prusaslicer.tsv` and `src/libslic3r/GCode/SeamAligned.cpp`.";
const WALL_SEAM_SOURCE_ANCHOR_BOUNDARY: &str =
    "Reviewed source anchors only; no upstream import, Git access, or runtime source discovery.";
const WALL_SEAM_FIXTURE_ID_BOUNDARY: &str =
    "Fixture identity string only for the Phase 63 checked-in fixture.";
const WALL_SEAM_FIXTURE_PATH_BOUNDARY: &str = "Checked-in fixture path under `packages/parity-fixtures/forks/prusaslicer/prusaslicer.wall-seam/` only.";
const WALL_SEAM_TRANSITION_OBSERVATIONS_BOUNDARY: &str = "Observed seam transition facts from the checked-in summary only; no wall-seam algorithm equivalence, seam visibility, or byte-for-byte G-code parity.";
const WALL_SEAM_LAYER_CONTEXT_OBSERVATIONS_BOUNDARY: &str = "Observed layer context facts from the checked-in summary only; no planner, geometry, printability, or printer-runtime behavior claim.";
const WALL_SEAM_TRAVEL_CONTEXT_OBSERVATIONS_BOUNDARY: &str = "Observed travel context facts from the checked-in summary only; no path-planning equivalence, GUI behavior, or printer-runtime behavior claim.";
const WALL_SEAM_COORDINATE_BOUNDS_BOUNDARY: &str = "Bounded coordinate observations only; no wall-seam geometry equivalence, tolerance, or printability claim.";
const WALL_SEAM_EXTRUSION_OBSERVATIONS_BOUNDARY: &str =
    "Summary extrusion observations only; no material-use, runtime, or printability claim.";
const WALL_SEAM_RETRACTION_OBSERVATIONS_BOUNDARY: &str =
    "Summary retraction observations only; no firmware, printer-runtime, or printability claim.";
const WALL_SEAM_EVIDENCE_BOUNDARY_BOUNDARY: &str = "Checked-in wall-seam fixture summary evidence only; no executable public status claim before Phase 65.";

macro_rules! source_row {
    ($field:ident, $category:ident, $boundary:expr $(,)?) => {
        ExpectedWallSeamRow {
            wall_seam_field: PrusaWallSeamField::$field,
            wall_seam_category: PrusaWallSeamCategory::$category,
            wall_seam_value: PrusaWallSeamValue::SourceRef(PRUSA_WALL_SEAM_SOURCE_REF),
            evidence_boundary: $boundary,
        }
    };
}

macro_rules! text_row {
    ($field:ident, $category:ident, $value:expr, $boundary:expr $(,)?) => {
        ExpectedWallSeamRow {
            wall_seam_field: PrusaWallSeamField::$field,
            wall_seam_category: PrusaWallSeamCategory::$category,
            wall_seam_value: PrusaWallSeamValue::Text($value),
            evidence_boundary: $boundary,
        }
    };
}

const EXPECTED_WALL_SEAM_ROWS: [ExpectedWallSeamRow; 12] = [
    source_row!(SourceRef, SourceIdentity, WALL_SEAM_SOURCE_REF_BOUNDARY),
    text_row!(
        InventorySourcePaths,
        SourceIdentity,
        WALL_SEAM_INVENTORY_SOURCE_PATHS_VALUE,
        WALL_SEAM_INVENTORY_SOURCE_PATHS_BOUNDARY,
    ),
    text_row!(
        SourceAnchor,
        SourceIdentity,
        WALL_SEAM_SOURCE_ANCHOR_VALUE,
        WALL_SEAM_SOURCE_ANCHOR_BOUNDARY,
    ),
    text_row!(
        FixtureId,
        FixtureIdentity,
        WALL_SEAM_FIXTURE_ID_VALUE,
        WALL_SEAM_FIXTURE_ID_BOUNDARY,
    ),
    text_row!(
        FixturePath,
        FixtureIdentity,
        PRUSA_WALL_SEAM_FIXTURE_PATH,
        WALL_SEAM_FIXTURE_PATH_BOUNDARY,
    ),
    text_row!(
        SeamTransitionObservations,
        SeamTransitionObservations,
        WALL_SEAM_TRANSITION_OBSERVATIONS_VALUE,
        WALL_SEAM_TRANSITION_OBSERVATIONS_BOUNDARY,
    ),
    text_row!(
        LayerContextObservations,
        LayerContextObservations,
        WALL_SEAM_LAYER_CONTEXT_OBSERVATIONS_VALUE,
        WALL_SEAM_LAYER_CONTEXT_OBSERVATIONS_BOUNDARY,
    ),
    text_row!(
        TravelContextObservations,
        TravelContextObservations,
        WALL_SEAM_TRAVEL_CONTEXT_OBSERVATIONS_VALUE,
        WALL_SEAM_TRAVEL_CONTEXT_OBSERVATIONS_BOUNDARY,
    ),
    text_row!(
        CoordinateBounds,
        CoordinateBounds,
        WALL_SEAM_COORDINATE_BOUNDS_VALUE,
        WALL_SEAM_COORDINATE_BOUNDS_BOUNDARY,
    ),
    text_row!(
        ExtrusionObservations,
        ExtrusionObservations,
        WALL_SEAM_EXTRUSION_OBSERVATIONS_VALUE,
        WALL_SEAM_EXTRUSION_OBSERVATIONS_BOUNDARY,
    ),
    text_row!(
        RetractionObservations,
        RetractionObservations,
        WALL_SEAM_RETRACTION_OBSERVATIONS_VALUE,
        WALL_SEAM_RETRACTION_OBSERVATIONS_BOUNDARY,
    ),
    text_row!(
        EvidenceBoundary,
        BoundaryText,
        WALL_SEAM_EVIDENCE_BOUNDARY_VALUE,
        WALL_SEAM_EVIDENCE_BOUNDARY_BOUNDARY,
    ),
];

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaWallSeamSummary {
    rows: Vec<PrusaWallSeamSummaryRow>,
    facts: PrusaWallSeamFacts,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaWallSeamSummaryRow {
    pub source_ref: VendorSourceRef,
    pub fixture_path: &'static str,
    pub wall_seam_field: PrusaWallSeamField,
    pub wall_seam_category: PrusaWallSeamCategory,
    pub wall_seam_value: PrusaWallSeamValue,
    pub evidence_boundary: PrusaWallSeamEvidenceBoundary,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaWallSeamFacts {
    pub source_ref: VendorSourceRef,
    pub inventory_source_paths: &'static str,
    pub source_anchor: &'static str,
    pub fixture_id: &'static str,
    pub fixture_path: &'static str,
    pub seam_transition_observations: &'static str,
    pub layer_context_observations: &'static str,
    pub travel_context_observations: &'static str,
    pub coordinate_bounds: &'static str,
    pub extrusion_observations: &'static str,
    pub retraction_observations: &'static str,
    pub evidence_boundary: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaWallSeamField {
    SourceRef,
    InventorySourcePaths,
    SourceAnchor,
    FixtureId,
    FixturePath,
    SeamTransitionObservations,
    LayerContextObservations,
    TravelContextObservations,
    CoordinateBounds,
    ExtrusionObservations,
    RetractionObservations,
    EvidenceBoundary,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaWallSeamCategory {
    SourceIdentity,
    FixtureIdentity,
    SeamTransitionObservations,
    LayerContextObservations,
    TravelContextObservations,
    CoordinateBounds,
    ExtrusionObservations,
    RetractionObservations,
    BoundaryText,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaWallSeamValue {
    SourceRef(VendorSourceRef),
    Text(&'static str),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaWallSeamEvidenceBoundary(&'static str);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaWallSeamMetadata {
    pub inventory_id: &'static str,
    pub vendor_id: &'static str,
    pub flavor_id: FlavorId,
    pub origin: FeatureOrigin,
    pub parity_dependency: ParitySurface,
    pub checklist_status: ChecklistStatus,
    pub source_ref: VendorSourceRef,
    pub source_path: &'static str,
    pub fixture_corpus_path: &'static str,
    pub fixture_path: &'static str,
    pub expected_wall_seam_summary_path: &'static str,
    pub scope_record_path: &'static str,
    pub reserved_future_status_token: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaWallSeamReadiness {
    pub inventory_id: &'static str,
    pub source_ref: VendorSourceRef,
    pub inventory_source_paths: &'static [&'static str],
    pub source_anchors: &'static [&'static str],
    pub fixture_corpus_path: &'static str,
    pub fixture_path: &'static str,
    pub expected_wall_seam_summary_path: &'static str,
    pub scope_record_path: &'static str,
    pub parser_boundary: &'static str,
    pub planned_public_command: &'static str,
    pub planned_status_token: &'static str,
    pub generated_outputs_status: &'static str,
    pub publication_boundary: &'static str,
    pub deferred_surfaces: &'static [&'static str],
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PrusaWallSeamParseError {
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
    UnsupportedWallSeamField {
        line_number: usize,
        value: String,
    },
    UnsupportedWallSeamCategory {
        line_number: usize,
        value: String,
    },
    UnexpectedWallSeamCategory {
        line_number: usize,
        wall_seam_field: PrusaWallSeamField,
        value: String,
    },
    UnexpectedWallSeamValue {
        line_number: usize,
        wall_seam_field: PrusaWallSeamField,
        value: String,
    },
    UnexpectedEvidenceBoundary {
        line_number: usize,
        wall_seam_field: PrusaWallSeamField,
        value: String,
    },
    DuplicateRow {
        line_number: usize,
        wall_seam_field: PrusaWallSeamField,
    },
    UnexpectedRowOrder {
        line_number: usize,
        expected_wall_seam_field: PrusaWallSeamField,
        actual_wall_seam_field: PrusaWallSeamField,
    },
    MissingRow {
        wall_seam_field: PrusaWallSeamField,
    },
    ExtraRow {
        line_number: usize,
        wall_seam_field: PrusaWallSeamField,
    },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct ExpectedWallSeamRow {
    wall_seam_field: PrusaWallSeamField,
    wall_seam_category: PrusaWallSeamCategory,
    wall_seam_value: PrusaWallSeamValue,
    evidence_boundary: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct WallSeamRowKey {
    wall_seam_field: PrusaWallSeamField,
}

pub type PrusaWallSeamParseResult = Result<PrusaWallSeamSummary, PrusaWallSeamParseError>;

pub const fn prusa_wall_seam_metadata() -> PrusaWallSeamMetadata {
    PrusaWallSeamMetadata {
        inventory_id: PRUSA_WALL_SEAM_INVENTORY_ID,
        vendor_id: PRUSA_WALL_SEAM_VENDOR_ID,
        flavor_id: FlavorId::PrusaSlicer,
        origin: FeatureOrigin::SharedDownstream,
        parity_dependency: ParitySurface::generated_outputs(),
        checklist_status: ChecklistStatus::FutureCandidate,
        source_ref: PRUSA_WALL_SEAM_SOURCE_REF,
        source_path: PRUSA_WALL_SEAM_SOURCE_PATH,
        fixture_corpus_path: PRUSA_WALL_SEAM_FIXTURE_CORPUS_PATH,
        fixture_path: PRUSA_WALL_SEAM_FIXTURE_PATH,
        expected_wall_seam_summary_path: PRUSA_WALL_SEAM_EXPECTED_SUMMARY_PATH,
        scope_record_path: PRUSA_WALL_SEAM_SCOPE_RECORD_PATH,
        reserved_future_status_token: PRUSA_WALL_SEAM_RESERVED_STATUS_TOKEN,
    }
}

pub const fn prusa_wall_seam_readiness() -> PrusaWallSeamReadiness {
    PrusaWallSeamReadiness {
        inventory_id: PRUSA_WALL_SEAM_INVENTORY_ID,
        source_ref: PRUSA_WALL_SEAM_SOURCE_REF,
        inventory_source_paths: &PRUSA_WALL_SEAM_INVENTORY_SOURCE_PATHS,
        source_anchors: &PRUSA_WALL_SEAM_SOURCE_ANCHORS,
        fixture_corpus_path: PRUSA_WALL_SEAM_FIXTURE_CORPUS_PATH,
        fixture_path: PRUSA_WALL_SEAM_FIXTURE_PATH,
        expected_wall_seam_summary_path: PRUSA_WALL_SEAM_EXPECTED_SUMMARY_PATH,
        scope_record_path: PRUSA_WALL_SEAM_SCOPE_RECORD_PATH,
        parser_boundary: "slic3r_flavors::prusa_wall_seam::parse_prusa_wall_seam_summary",
        planned_public_command: "//packages/parity:prusaslicer_wall_seam_parity",
        planned_status_token: PRUSA_WALL_SEAM_RESERVED_STATUS_TOKEN,
        generated_outputs_status: "in progress",
        publication_boundary: "Phase 64 parser/readiness only; Phase 65 owns public executable evidence and status/docs publication.",
        deferred_surfaces: &PRUSA_WALL_SEAM_DEFERRED_SURFACES,
    }
}

pub fn parse_prusa_wall_seam_summary(input: &str) -> PrusaWallSeamParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaWallSeamParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_wall_seam_header(header)?;

    let mut rows = Vec::new();
    let mut row_keys = Vec::new();

    for (line_offset, line) in lines.enumerate() {
        let line_number = line_offset + 2;
        let row = parse_wall_seam_summary_row(line, line_number)?;
        let row_key = WallSeamRowKey::from_row(&row);

        if row_keys.contains(&row_key) {
            return Err(PrusaWallSeamParseError::DuplicateRow {
                line_number,
                wall_seam_field: row.wall_seam_field,
            });
        }

        if !is_expected_wall_seam_row_key(row_key) {
            return Err(PrusaWallSeamParseError::ExtraRow {
                line_number,
                wall_seam_field: row.wall_seam_field,
            });
        }

        let Some(expected_row) = EXPECTED_WALL_SEAM_ROWS.get(line_offset).copied() else {
            return Err(PrusaWallSeamParseError::ExtraRow {
                line_number,
                wall_seam_field: row.wall_seam_field,
            });
        };
        if row.wall_seam_field != expected_row.wall_seam_field {
            return Err(PrusaWallSeamParseError::UnexpectedRowOrder {
                line_number,
                expected_wall_seam_field: expected_row.wall_seam_field,
                actual_wall_seam_field: row.wall_seam_field,
            });
        }

        row_keys.push(row_key);
        rows.push(row);
    }

    validate_missing_wall_seam_rows(&row_keys)?;

    Ok(PrusaWallSeamSummary {
        rows,
        facts: PrusaWallSeamFacts::from_validated_rows(),
    })
}

pub fn prusa_wall_seam_summary_lines(input: &str) -> Result<Vec<String>, PrusaWallSeamParseError> {
    let summary = parse_prusa_wall_seam_summary(input)?;
    let facts = summary.facts();

    Ok(vec![
        summary_line(
            "wall_seam_summary_path",
            PRUSA_WALL_SEAM_EXPECTED_SUMMARY_PATH,
        ),
        summary_line("wall_seam_row_count", &summary.rows().len().to_string()),
        summary_line("source_ref", facts.source_ref.as_str()),
        summary_line("inventory_source_paths", facts.inventory_source_paths),
        summary_line("source_anchor", facts.source_anchor),
        summary_line("fixture_id", facts.fixture_id),
        summary_line("fixture_path", facts.fixture_path),
        summary_line(
            "seam_transition_observations",
            facts.seam_transition_observations,
        ),
        summary_line(
            "layer_context_observations",
            facts.layer_context_observations,
        ),
        summary_line(
            "travel_context_observations",
            facts.travel_context_observations,
        ),
        summary_line("coordinate_bounds", facts.coordinate_bounds),
        summary_line("extrusion_observations", facts.extrusion_observations),
        summary_line("retraction_observations", facts.retraction_observations),
        summary_line("evidence_boundary", facts.evidence_boundary),
    ])
}

impl PrusaWallSeamSummary {
    pub fn rows(&self) -> &[PrusaWallSeamSummaryRow] {
        &self.rows
    }

    pub const fn facts(&self) -> PrusaWallSeamFacts {
        self.facts
    }
}

impl PrusaWallSeamValue {
    const fn as_str(self) -> &'static str {
        match self {
            PrusaWallSeamValue::SourceRef(source_ref) => source_ref.as_str(),
            PrusaWallSeamValue::Text(value) => value,
        }
    }
}

impl WallSeamRowKey {
    const fn from_row(row: &PrusaWallSeamSummaryRow) -> Self {
        Self {
            wall_seam_field: row.wall_seam_field,
        }
    }

    const fn from_expected(row: ExpectedWallSeamRow) -> Self {
        Self {
            wall_seam_field: row.wall_seam_field,
        }
    }
}

impl PrusaWallSeamFacts {
    const fn from_validated_rows() -> Self {
        Self {
            source_ref: PRUSA_WALL_SEAM_SOURCE_REF,
            inventory_source_paths: WALL_SEAM_INVENTORY_SOURCE_PATHS_VALUE,
            source_anchor: WALL_SEAM_SOURCE_ANCHOR_VALUE,
            fixture_id: WALL_SEAM_FIXTURE_ID_VALUE,
            fixture_path: PRUSA_WALL_SEAM_FIXTURE_PATH,
            seam_transition_observations: WALL_SEAM_TRANSITION_OBSERVATIONS_VALUE,
            layer_context_observations: WALL_SEAM_LAYER_CONTEXT_OBSERVATIONS_VALUE,
            travel_context_observations: WALL_SEAM_TRAVEL_CONTEXT_OBSERVATIONS_VALUE,
            coordinate_bounds: WALL_SEAM_COORDINATE_BOUNDS_VALUE,
            extrusion_observations: WALL_SEAM_EXTRUSION_OBSERVATIONS_VALUE,
            retraction_observations: WALL_SEAM_RETRACTION_OBSERVATIONS_VALUE,
            evidence_boundary: WALL_SEAM_EVIDENCE_BOUNDARY_VALUE,
        }
    }
}

fn validate_wall_seam_header(line: &str) -> Result<(), PrusaWallSeamParseError> {
    if line != WALL_SEAM_EXPECTED_HEADER {
        return Err(PrusaWallSeamParseError::InvalidHeader {
            line: line.to_owned(),
        });
    }

    Ok(())
}

fn parse_wall_seam_summary_row(
    line: &str,
    line_number: usize,
) -> Result<PrusaWallSeamSummaryRow, PrusaWallSeamParseError> {
    let columns: Vec<&str> = line.split('\t').collect();
    validate_wall_seam_column_count(&columns, line_number)?;
    validate_wall_seam_required_values(&columns, line_number)?;

    let source_ref = parse_wall_seam_source_ref(columns[0], line_number)?;
    let fixture_path = parse_wall_seam_fixture_path(columns[1], line_number)?;
    let wall_seam_field = parse_wall_seam_field(columns[2], line_number)?;
    let wall_seam_category = parse_wall_seam_category(columns[3], line_number)?;
    let Some(expected_row) = expected_wall_seam_row_for_field(wall_seam_field) else {
        return Err(PrusaWallSeamParseError::ExtraRow {
            line_number,
            wall_seam_field,
        });
    };

    if wall_seam_category != expected_row.wall_seam_category {
        return Err(PrusaWallSeamParseError::UnexpectedWallSeamCategory {
            line_number,
            wall_seam_field,
            value: columns[3].to_owned(),
        });
    }

    let wall_seam_value = parse_wall_seam_value(columns[4], expected_row, line_number)?;
    let evidence_boundary =
        parse_wall_seam_evidence_boundary(columns[5], expected_row, line_number)?;

    Ok(PrusaWallSeamSummaryRow {
        source_ref,
        fixture_path,
        wall_seam_field,
        wall_seam_category,
        wall_seam_value,
        evidence_boundary,
    })
}

fn validate_wall_seam_column_count(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaWallSeamParseError> {
    if columns.len() != WALL_SEAM_EXPECTED_COLUMN_COUNT {
        return Err(PrusaWallSeamParseError::WrongColumnCount {
            line_number,
            expected: WALL_SEAM_EXPECTED_COLUMN_COUNT,
            actual: columns.len(),
        });
    }

    Ok(())
}

fn validate_wall_seam_required_values(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaWallSeamParseError> {
    for (index, value) in columns.iter().enumerate() {
        if value.is_empty() {
            return Err(PrusaWallSeamParseError::EmptyRequiredValue {
                line_number,
                column: WALL_SEAM_COLUMNS[index],
            });
        }
    }

    Ok(())
}

fn parse_wall_seam_source_ref(
    value: &str,
    line_number: usize,
) -> Result<VendorSourceRef, PrusaWallSeamParseError> {
    if value != PRUSA_WALL_SEAM_SOURCE_REF.as_str() {
        return Err(PrusaWallSeamParseError::UnexpectedSourceRef {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_WALL_SEAM_SOURCE_REF)
}

fn parse_wall_seam_fixture_path(
    value: &str,
    line_number: usize,
) -> Result<&'static str, PrusaWallSeamParseError> {
    if value != PRUSA_WALL_SEAM_FIXTURE_PATH {
        return Err(PrusaWallSeamParseError::UnexpectedFixturePath {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_WALL_SEAM_FIXTURE_PATH)
}

fn parse_wall_seam_field(
    value: &str,
    line_number: usize,
) -> Result<PrusaWallSeamField, PrusaWallSeamParseError> {
    match value {
        "source_ref" => Ok(PrusaWallSeamField::SourceRef),
        "inventory_source_paths" => Ok(PrusaWallSeamField::InventorySourcePaths),
        "source_anchor" => Ok(PrusaWallSeamField::SourceAnchor),
        "fixture_id" => Ok(PrusaWallSeamField::FixtureId),
        "fixture_path" => Ok(PrusaWallSeamField::FixturePath),
        "seam_transition_observations" => Ok(PrusaWallSeamField::SeamTransitionObservations),
        "layer_context_observations" => Ok(PrusaWallSeamField::LayerContextObservations),
        "travel_context_observations" => Ok(PrusaWallSeamField::TravelContextObservations),
        "coordinate_bounds" => Ok(PrusaWallSeamField::CoordinateBounds),
        "extrusion_observations" => Ok(PrusaWallSeamField::ExtrusionObservations),
        "retraction_observations" => Ok(PrusaWallSeamField::RetractionObservations),
        "evidence_boundary" => Ok(PrusaWallSeamField::EvidenceBoundary),
        _ => Err(PrusaWallSeamParseError::UnsupportedWallSeamField {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_wall_seam_category(
    value: &str,
    line_number: usize,
) -> Result<PrusaWallSeamCategory, PrusaWallSeamParseError> {
    match value {
        "source identity" => Ok(PrusaWallSeamCategory::SourceIdentity),
        "fixture identity" => Ok(PrusaWallSeamCategory::FixtureIdentity),
        "seam transition observations" => Ok(PrusaWallSeamCategory::SeamTransitionObservations),
        "layer context observations" => Ok(PrusaWallSeamCategory::LayerContextObservations),
        "travel context observations" => Ok(PrusaWallSeamCategory::TravelContextObservations),
        "coordinate bounds" => Ok(PrusaWallSeamCategory::CoordinateBounds),
        "extrusion observations" => Ok(PrusaWallSeamCategory::ExtrusionObservations),
        "retraction observations" => Ok(PrusaWallSeamCategory::RetractionObservations),
        "boundary text" => Ok(PrusaWallSeamCategory::BoundaryText),
        _ => Err(PrusaWallSeamParseError::UnsupportedWallSeamCategory {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_wall_seam_value(
    value: &str,
    expected_row: ExpectedWallSeamRow,
    line_number: usize,
) -> Result<PrusaWallSeamValue, PrusaWallSeamParseError> {
    if value != expected_row.wall_seam_value.as_str() {
        return Err(PrusaWallSeamParseError::UnexpectedWallSeamValue {
            line_number,
            wall_seam_field: expected_row.wall_seam_field,
            value: value.to_owned(),
        });
    }

    Ok(expected_row.wall_seam_value)
}

fn parse_wall_seam_evidence_boundary(
    value: &str,
    expected_row: ExpectedWallSeamRow,
    line_number: usize,
) -> Result<PrusaWallSeamEvidenceBoundary, PrusaWallSeamParseError> {
    if value != expected_row.evidence_boundary {
        return Err(PrusaWallSeamParseError::UnexpectedEvidenceBoundary {
            line_number,
            wall_seam_field: expected_row.wall_seam_field,
            value: value.to_owned(),
        });
    }

    Ok(PrusaWallSeamEvidenceBoundary(
        expected_row.evidence_boundary,
    ))
}

fn expected_wall_seam_row_for_field(
    wall_seam_field: PrusaWallSeamField,
) -> Option<ExpectedWallSeamRow> {
    EXPECTED_WALL_SEAM_ROWS
        .iter()
        .copied()
        .find(|row| row.wall_seam_field == wall_seam_field)
}

fn is_expected_wall_seam_row_key(row_key: WallSeamRowKey) -> bool {
    expected_wall_seam_row_for_field(row_key.wall_seam_field).is_some()
}

fn validate_missing_wall_seam_rows(
    row_keys: &[WallSeamRowKey],
) -> Result<(), PrusaWallSeamParseError> {
    for expected_row in EXPECTED_WALL_SEAM_ROWS {
        let row_key = WallSeamRowKey::from_expected(expected_row);
        if !row_keys.contains(&row_key) {
            return Err(PrusaWallSeamParseError::MissingRow {
                wall_seam_field: expected_row.wall_seam_field,
            });
        }
    }

    Ok(())
}

fn summary_line(key: &str, value: &str) -> String {
    format!("{key}\t{value}")
}

use slic3r_contracts::{ChecklistStatus, FeatureOrigin, FlavorId, ParitySurface, VendorSourceRef};

pub(crate) const PRUSA_GCODE_OUTPUT_INVENTORY_ID: &str = "prusaslicer.gcode-output";
pub(crate) const PRUSA_GCODE_OUTPUT_VENDOR_ID: &str = "prusaslicer";
pub(crate) const PRUSA_GCODE_OUTPUT_SOURCE_REF: VendorSourceRef =
    VendorSourceRef::prusa_slicer_version_2_9_5();
pub(crate) const PRUSA_GCODE_OUTPUT_SOURCE_PATH: &str = "tests/fff_print/test_gcodewriter.cpp";
pub(crate) const PRUSA_GCODE_OUTPUT_FIXTURE_CORPUS_PATH: &str =
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output";
pub(crate) const PRUSA_GCODE_OUTPUT_FIXTURE_PATH: &str = "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode";
pub(crate) const PRUSA_GCODE_OUTPUT_EXPECTED_SUMMARY_PATH: &str = "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-summary.tsv";
pub const PRUSA_GCODE_OUTPUT_EXPECTED_STRUCTURAL_SUMMARY_PATH: &str = "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-structural-summary.tsv";
pub const PRUSA_GCODE_OUTPUT_EXPECTED_SEMANTIC_SUMMARY_PATH: &str = "packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/expected-gcode-semantic-summary.tsv";
pub(crate) const PRUSA_GCODE_OUTPUT_SCOPE_RECORD_PATH: &str =
    "packages/prusa-gcode-output-scope/gcode-output-scope.md";
pub(crate) const PRUSA_GCODE_OUTPUT_RESERVED_STATUS_TOKEN: &str = "fork.prusaslicer.gcode-output";
static PRUSA_GCODE_OUTPUT_INVENTORY_SOURCE_PATHS: [&str; 2] =
    ["src/libslic3r/GCode.cpp", "src/libslic3r/GCode.hpp"];
static PRUSA_GCODE_OUTPUT_DEFERRED_SEMANTIC_SURFACES: [&str; 14] = [
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
const PRUSA_GCODE_OUTPUT_INVENTORY_SOURCE_PATHS_VALUE: &str =
    "src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp";
const PRUSA_GCODE_OUTPUT_FIXTURE_SOURCE_LITERAL: &str =
    "tests/fff_print/test_gcodewriter.cpp#L20-L35";
const PRUSA_GCODE_OUTPUT_FIXTURE_ID: &str = "gcodewriter-set-speed.gcode";

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
const STRUCTURAL_EXPECTED_HEADER: &str = "source_ref\tfixture_path\tstructural_field\tstructural_category\tstructural_value\tevidence_boundary";
const STRUCTURAL_EXPECTED_COLUMN_COUNT: usize = 6;
const STRUCTURAL_COLUMNS: [&str; STRUCTURAL_EXPECTED_COLUMN_COUNT] = [
    "source_ref",
    "fixture_path",
    "structural_field",
    "structural_category",
    "structural_value",
    "evidence_boundary",
];
const STRUCTURAL_SOURCE_REF_BOUNDARY: &str = "Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.";
const STRUCTURAL_INVENTORY_SOURCE_PATHS_BOUNDARY: &str =
    "Inventory source paths only: `src/libslic3r/GCode.cpp;src/libslic3r/GCode.hpp`.";
const STRUCTURAL_FIXTURE_SOURCE_LITERAL_BOUNDARY: &str =
    "Source literal only: `tests/fff_print/test_gcodewriter.cpp#L20-L35`.";
const STRUCTURAL_FIXTURE_ID_BOUNDARY: &str =
    "Fixture identity only: `gcodewriter-set-speed.gcode`.";
const STRUCTURAL_FIXTURE_PATH_BOUNDARY: &str = "Checked-in fixture path only: `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`.";
const STRUCTURAL_COMMAND_COUNT_TOTAL_BOUNDARY: &str = "Count of G-code command rows in the selected fixture only; no generated-output behavior claimed.";
const STRUCTURAL_COMMAND_COUNT_G1_BOUNDARY: &str =
    "Count of `G1` command rows in the selected fixture only; no toolpath geometry claimed.";
const STRUCTURAL_SECTION_COUNT_TOTAL_BOUNDARY: &str = "Count of structural sections in the selected summary only; no GUI, print, or runtime section behavior claimed.";
const STRUCTURAL_ORDERED_MARKER_1_BOUNDARY: &str =
    "First ordered marker value from the selected fixture summary only.";
const STRUCTURAL_ORDERED_MARKER_2_BOUNDARY: &str =
    "Second ordered marker value from the selected fixture summary only.";
const STRUCTURAL_ORDERED_MARKER_3_BOUNDARY: &str =
    "Third ordered marker value from the selected fixture summary only.";
const STRUCTURAL_ORDERED_MARKER_4_BOUNDARY: &str =
    "Fourth ordered marker value from the selected fixture summary only.";
const STRUCTURAL_MOVEMENT_AXIS_PRESENT_BOUNDARY: &str = "Boolean structural indicator for movement-axis text presence only; no toolpath geometry, travel, or printability claim.";
const STRUCTURAL_EXTRUSION_AXIS_PRESENT_BOUNDARY: &str = "Boolean structural indicator for extrusion-axis text presence only; no extrusion amount, material, or printability claim.";
const STRUCTURAL_TEMPERATURE_MARKER_COUNT_BOUNDARY: &str = "Count of temperature marker commands in the selected fixture only; no printer-runtime behavior claimed.";
const STRUCTURAL_TOOL_CHANGE_MARKER_COUNT_BOUNDARY: &str = "Count of tool-change marker commands in the selected fixture only; no multi-tool runtime behavior claimed.";
const SEMANTIC_EXPECTED_HEADER: &str = "source_ref\tfixture_path\tsemantic_field\tsemantic_category\tsemantic_value\tevidence_boundary";
const SEMANTIC_EXPECTED_COLUMN_COUNT: usize = 6;
const SEMANTIC_COLUMNS: [&str; SEMANTIC_EXPECTED_COLUMN_COUNT] = [
    "source_ref",
    "fixture_path",
    "semantic_field",
    "semantic_category",
    "semantic_value",
    "evidence_boundary",
];
const SEMANTIC_SOURCE_REF_BOUNDARY: &str = "Accepted PrusaSlicer source identity only: `prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961`.";
const SEMANTIC_FIXTURE_ID_BOUNDARY: &str = "Fixture identity only: `gcodewriter-set-speed.gcode`.";
const SEMANTIC_FIXTURE_PATH_BOUNDARY: &str = "Checked-in fixture path only: `packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode`.";
const SEMANTIC_COMMAND_CLASS_COUNTS_VALUE: &str = "G1:4;feedrate_only:4";
const SEMANTIC_COMMAND_CLASS_COUNTS_BOUNDARY: &str = "Counts of command classes in the selected fixture summary only; no byte-for-byte G-code parity or generator parity.";
const SEMANTIC_MOVEMENT_CLASS_COUNTS_VALUE: &str =
    "travel:0;extrusion:0;coordinate_motion:0;feedrate_only:4";
const SEMANTIC_MOVEMENT_CLASS_COUNTS_BOUNDARY: &str = "Counts of movement classes in the selected fixture summary only; no toolpath geometry, travel, or printability claim.";
const SEMANTIC_COORDINATE_BOUNDS_VALUE: &str = "x:none;y:none;z:none";
const SEMANTIC_COORDINATE_BOUNDS_BOUNDARY: &str = "No coordinate axes observed in the selected fixture summary; no toolpath geometry or printability claim.";
const SEMANTIC_EXTRUSION_TOTAL_VALUE: &str = "e_axis_observed:false;extrusion_total:not_observed";
const SEMANTIC_EXTRUSION_TOTAL_BOUNDARY: &str = "No extrusion axis observed in the selected fixture summary; no material-use, runtime, or printability claim.";
const SEMANTIC_FEEDRATE_OBSERVATIONS_VALUE: &str = "F99999.123;F1;F203.2;F203.201";
const SEMANTIC_FEEDRATE_OBSERVATIONS_BOUNDARY: &str = "Feedrate metadata only from the selected fixture summary; no timing, firmware, or printer-runtime behavior claim.";
const SEMANTIC_LAYER_MARKER_RELATIONSHIPS_VALUE: &str = "layer_markers:0;marker_relationships:none";
const SEMANTIC_LAYER_MARKER_RELATIONSHIPS_BOUNDARY: &str = "No layer markers observed in the selected fixture summary; no GUI, viewer, runtime, support, seam, or arc behavior claim.";
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
const EXPECTED_STRUCTURAL_ROWS: [ExpectedGcodeOutputStructuralRow; 16] = [
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::SourceRef,
        structural_category: PrusaGcodeOutputStructuralCategory::SourceIdentity,
        structural_value: PrusaGcodeOutputStructuralValue::SourceRef(PRUSA_GCODE_OUTPUT_SOURCE_REF),
        evidence_boundary: STRUCTURAL_SOURCE_REF_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::InventorySourcePaths,
        structural_category: PrusaGcodeOutputStructuralCategory::SourceIdentity,
        structural_value: PrusaGcodeOutputStructuralValue::InventorySourcePaths(
            PRUSA_GCODE_OUTPUT_INVENTORY_SOURCE_PATHS_VALUE,
        ),
        evidence_boundary: STRUCTURAL_INVENTORY_SOURCE_PATHS_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::FixtureSourceLiteral,
        structural_category: PrusaGcodeOutputStructuralCategory::SourceIdentity,
        structural_value: PrusaGcodeOutputStructuralValue::FixtureSourceLiteral(
            PRUSA_GCODE_OUTPUT_FIXTURE_SOURCE_LITERAL,
        ),
        evidence_boundary: STRUCTURAL_FIXTURE_SOURCE_LITERAL_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::FixtureId,
        structural_category: PrusaGcodeOutputStructuralCategory::FixtureIdentity,
        structural_value: PrusaGcodeOutputStructuralValue::FixtureId(PRUSA_GCODE_OUTPUT_FIXTURE_ID),
        evidence_boundary: STRUCTURAL_FIXTURE_ID_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::FixturePath,
        structural_category: PrusaGcodeOutputStructuralCategory::FixtureIdentity,
        structural_value: PrusaGcodeOutputStructuralValue::FixturePath(
            PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
        ),
        evidence_boundary: STRUCTURAL_FIXTURE_PATH_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::CommandCountTotal,
        structural_category: PrusaGcodeOutputStructuralCategory::CommandCounts,
        structural_value: PrusaGcodeOutputStructuralValue::Count(4),
        evidence_boundary: STRUCTURAL_COMMAND_COUNT_TOTAL_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::CommandCountG1,
        structural_category: PrusaGcodeOutputStructuralCategory::CommandCounts,
        structural_value: PrusaGcodeOutputStructuralValue::Count(4),
        evidence_boundary: STRUCTURAL_COMMAND_COUNT_G1_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::SectionCountTotal,
        structural_category: PrusaGcodeOutputStructuralCategory::SectionCounts,
        structural_value: PrusaGcodeOutputStructuralValue::Count(1),
        evidence_boundary: STRUCTURAL_SECTION_COUNT_TOTAL_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::OrderedMarker1,
        structural_category: PrusaGcodeOutputStructuralCategory::OrderedMarkers,
        structural_value: PrusaGcodeOutputStructuralValue::OrderedMarker(
            PrusaGcodeOutputMarkerValue::FeedrateFixedPoint,
        ),
        evidence_boundary: STRUCTURAL_ORDERED_MARKER_1_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::OrderedMarker2,
        structural_category: PrusaGcodeOutputStructuralCategory::OrderedMarkers,
        structural_value: PrusaGcodeOutputStructuralValue::OrderedMarker(
            PrusaGcodeOutputMarkerValue::FeedrateInteger,
        ),
        evidence_boundary: STRUCTURAL_ORDERED_MARKER_2_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::OrderedMarker3,
        structural_category: PrusaGcodeOutputStructuralCategory::OrderedMarkers,
        structural_value: PrusaGcodeOutputStructuralValue::OrderedMarker(
            PrusaGcodeOutputMarkerValue::FeedrateOneDecimal,
        ),
        evidence_boundary: STRUCTURAL_ORDERED_MARKER_3_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::OrderedMarker4,
        structural_category: PrusaGcodeOutputStructuralCategory::OrderedMarkers,
        structural_value: PrusaGcodeOutputStructuralValue::OrderedMarker(
            PrusaGcodeOutputMarkerValue::FeedrateThreeDecimalRounded,
        ),
        evidence_boundary: STRUCTURAL_ORDERED_MARKER_4_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::MovementAxisPresent,
        structural_category: PrusaGcodeOutputStructuralCategory::MovementExtrusionIndicators,
        structural_value: PrusaGcodeOutputStructuralValue::Indicator(false),
        evidence_boundary: STRUCTURAL_MOVEMENT_AXIS_PRESENT_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::ExtrusionAxisPresent,
        structural_category: PrusaGcodeOutputStructuralCategory::MovementExtrusionIndicators,
        structural_value: PrusaGcodeOutputStructuralValue::Indicator(false),
        evidence_boundary: STRUCTURAL_EXTRUSION_AXIS_PRESENT_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::TemperatureMarkerCount,
        structural_category: PrusaGcodeOutputStructuralCategory::TemperatureToolChangeMarkers,
        structural_value: PrusaGcodeOutputStructuralValue::Count(0),
        evidence_boundary: STRUCTURAL_TEMPERATURE_MARKER_COUNT_BOUNDARY,
    },
    ExpectedGcodeOutputStructuralRow {
        structural_field: PrusaGcodeOutputStructuralField::ToolChangeMarkerCount,
        structural_category: PrusaGcodeOutputStructuralCategory::TemperatureToolChangeMarkers,
        structural_value: PrusaGcodeOutputStructuralValue::Count(0),
        evidence_boundary: STRUCTURAL_TOOL_CHANGE_MARKER_COUNT_BOUNDARY,
    },
];
const EXPECTED_SEMANTIC_ROWS: [ExpectedGcodeOutputSemanticRow; 9] = [
    ExpectedGcodeOutputSemanticRow {
        semantic_field: PrusaGcodeOutputSemanticField::SourceRef,
        semantic_category: PrusaGcodeOutputSemanticCategory::SourceIdentity,
        semantic_value: PrusaGcodeOutputSemanticValue::SourceRef(PRUSA_GCODE_OUTPUT_SOURCE_REF),
        evidence_boundary: SEMANTIC_SOURCE_REF_BOUNDARY,
    },
    ExpectedGcodeOutputSemanticRow {
        semantic_field: PrusaGcodeOutputSemanticField::FixtureId,
        semantic_category: PrusaGcodeOutputSemanticCategory::FixtureIdentity,
        semantic_value: PrusaGcodeOutputSemanticValue::Text(PRUSA_GCODE_OUTPUT_FIXTURE_ID),
        evidence_boundary: SEMANTIC_FIXTURE_ID_BOUNDARY,
    },
    ExpectedGcodeOutputSemanticRow {
        semantic_field: PrusaGcodeOutputSemanticField::FixturePath,
        semantic_category: PrusaGcodeOutputSemanticCategory::FixtureIdentity,
        semantic_value: PrusaGcodeOutputSemanticValue::Text(PRUSA_GCODE_OUTPUT_FIXTURE_PATH),
        evidence_boundary: SEMANTIC_FIXTURE_PATH_BOUNDARY,
    },
    ExpectedGcodeOutputSemanticRow {
        semantic_field: PrusaGcodeOutputSemanticField::CommandClassCounts,
        semantic_category: PrusaGcodeOutputSemanticCategory::CommandClasses,
        semantic_value: PrusaGcodeOutputSemanticValue::Text(SEMANTIC_COMMAND_CLASS_COUNTS_VALUE),
        evidence_boundary: SEMANTIC_COMMAND_CLASS_COUNTS_BOUNDARY,
    },
    ExpectedGcodeOutputSemanticRow {
        semantic_field: PrusaGcodeOutputSemanticField::MovementClassCounts,
        semantic_category: PrusaGcodeOutputSemanticCategory::MovementClasses,
        semantic_value: PrusaGcodeOutputSemanticValue::Text(SEMANTIC_MOVEMENT_CLASS_COUNTS_VALUE),
        evidence_boundary: SEMANTIC_MOVEMENT_CLASS_COUNTS_BOUNDARY,
    },
    ExpectedGcodeOutputSemanticRow {
        semantic_field: PrusaGcodeOutputSemanticField::CoordinateBounds,
        semantic_category: PrusaGcodeOutputSemanticCategory::CoordinateBounds,
        semantic_value: PrusaGcodeOutputSemanticValue::Text(SEMANTIC_COORDINATE_BOUNDS_VALUE),
        evidence_boundary: SEMANTIC_COORDINATE_BOUNDS_BOUNDARY,
    },
    ExpectedGcodeOutputSemanticRow {
        semantic_field: PrusaGcodeOutputSemanticField::ExtrusionTotal,
        semantic_category: PrusaGcodeOutputSemanticCategory::ExtrusionTotal,
        semantic_value: PrusaGcodeOutputSemanticValue::Text(SEMANTIC_EXTRUSION_TOTAL_VALUE),
        evidence_boundary: SEMANTIC_EXTRUSION_TOTAL_BOUNDARY,
    },
    ExpectedGcodeOutputSemanticRow {
        semantic_field: PrusaGcodeOutputSemanticField::FeedrateObservations,
        semantic_category: PrusaGcodeOutputSemanticCategory::FeedrateObservations,
        semantic_value: PrusaGcodeOutputSemanticValue::Text(SEMANTIC_FEEDRATE_OBSERVATIONS_VALUE),
        evidence_boundary: SEMANTIC_FEEDRATE_OBSERVATIONS_BOUNDARY,
    },
    ExpectedGcodeOutputSemanticRow {
        semantic_field: PrusaGcodeOutputSemanticField::LayerMarkerRelationships,
        semantic_category: PrusaGcodeOutputSemanticCategory::LayerMarkerRelationships,
        semantic_value: PrusaGcodeOutputSemanticValue::Text(
            SEMANTIC_LAYER_MARKER_RELATIONSHIPS_VALUE,
        ),
        evidence_boundary: SEMANTIC_LAYER_MARKER_RELATIONSHIPS_BOUNDARY,
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
pub struct PrusaGcodeOutputStructuralSummary {
    rows: Vec<PrusaGcodeOutputStructuralSummaryRow>,
    facts: PrusaGcodeOutputStructuralFacts,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaGcodeOutputSemanticSummary {
    rows: Vec<PrusaGcodeOutputSemanticSummaryRow>,
    facts: PrusaGcodeOutputSemanticFacts,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaGcodeOutputStructuralSummaryRow {
    pub source_ref: VendorSourceRef,
    pub fixture_path: &'static str,
    pub structural_field: PrusaGcodeOutputStructuralField,
    pub structural_category: PrusaGcodeOutputStructuralCategory,
    pub structural_value: PrusaGcodeOutputStructuralValue,
    pub evidence_boundary: PrusaGcodeOutputEvidenceBoundary,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaGcodeOutputSemanticSummaryRow {
    pub source_ref: VendorSourceRef,
    pub fixture_path: &'static str,
    pub semantic_field: PrusaGcodeOutputSemanticField,
    pub semantic_category: PrusaGcodeOutputSemanticCategory,
    pub semantic_value: PrusaGcodeOutputSemanticValue,
    pub evidence_boundary: PrusaGcodeOutputEvidenceBoundary,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaGcodeOutputStructuralFacts {
    pub source_ref: VendorSourceRef,
    pub inventory_source_paths: &'static str,
    pub fixture_source_literal: &'static str,
    pub fixture_id: &'static str,
    pub fixture_path: &'static str,
    pub command_count_total: u32,
    pub command_count_g1: u32,
    pub section_count_total: u32,
    pub ordered_markers: [PrusaGcodeOutputMarkerValue; 4],
    pub movement_axis_present: bool,
    pub extrusion_axis_present: bool,
    pub temperature_marker_count: u32,
    pub tool_change_marker_count: u32,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaGcodeOutputSemanticFacts {
    pub source_ref: VendorSourceRef,
    pub fixture_id: &'static str,
    pub fixture_path: &'static str,
    pub command_class_counts: &'static str,
    pub movement_class_counts: &'static str,
    pub coordinate_bounds: &'static str,
    pub extrusion_total: &'static str,
    pub feedrate_observations: &'static str,
    pub layer_marker_relationships: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputStructuralField {
    SourceRef,
    InventorySourcePaths,
    FixtureSourceLiteral,
    FixtureId,
    FixturePath,
    CommandCountTotal,
    CommandCountG1,
    SectionCountTotal,
    OrderedMarker1,
    OrderedMarker2,
    OrderedMarker3,
    OrderedMarker4,
    MovementAxisPresent,
    ExtrusionAxisPresent,
    TemperatureMarkerCount,
    ToolChangeMarkerCount,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputSemanticField {
    SourceRef,
    FixtureId,
    FixturePath,
    CommandClassCounts,
    MovementClassCounts,
    CoordinateBounds,
    ExtrusionTotal,
    FeedrateObservations,
    LayerMarkerRelationships,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputStructuralCategory {
    SourceIdentity,
    FixtureIdentity,
    CommandCounts,
    SectionCounts,
    OrderedMarkers,
    MovementExtrusionIndicators,
    TemperatureToolChangeMarkers,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputSemanticCategory {
    SourceIdentity,
    FixtureIdentity,
    CommandClasses,
    MovementClasses,
    CoordinateBounds,
    ExtrusionTotal,
    FeedrateObservations,
    LayerMarkerRelationships,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputStructuralValue {
    SourceRef(VendorSourceRef),
    InventorySourcePaths(&'static str),
    FixtureSourceLiteral(&'static str),
    FixtureId(&'static str),
    FixturePath(&'static str),
    Count(u32),
    Indicator(bool),
    OrderedMarker(PrusaGcodeOutputMarkerValue),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaGcodeOutputSemanticValue {
    SourceRef(VendorSourceRef),
    Text(&'static str),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaGcodeOutputEvidenceBoundary(&'static str);

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

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PrusaGcodeOutputStructuralParseError {
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
    UnsupportedStructuralField {
        line_number: usize,
        value: String,
    },
    UnsupportedStructuralCategory {
        line_number: usize,
        value: String,
    },
    UnexpectedStructuralCategory {
        line_number: usize,
        structural_field: PrusaGcodeOutputStructuralField,
        value: String,
    },
    UnexpectedStructuralValue {
        line_number: usize,
        structural_field: PrusaGcodeOutputStructuralField,
        value: String,
    },
    UnexpectedEvidenceBoundary {
        line_number: usize,
        structural_field: PrusaGcodeOutputStructuralField,
        value: String,
    },
    DuplicateRow {
        line_number: usize,
        structural_field: PrusaGcodeOutputStructuralField,
    },
    UnexpectedRowOrder {
        line_number: usize,
        expected_structural_field: PrusaGcodeOutputStructuralField,
        actual_structural_field: PrusaGcodeOutputStructuralField,
    },
    MissingRow {
        structural_field: PrusaGcodeOutputStructuralField,
    },
    ExtraRow {
        line_number: usize,
        structural_field: PrusaGcodeOutputStructuralField,
    },
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PrusaGcodeOutputSemanticParseError {
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
    UnsupportedSemanticField {
        line_number: usize,
        value: String,
    },
    UnsupportedSemanticCategory {
        line_number: usize,
        value: String,
    },
    UnexpectedSemanticCategory {
        line_number: usize,
        semantic_field: PrusaGcodeOutputSemanticField,
        value: String,
    },
    UnexpectedSemanticValue {
        line_number: usize,
        semantic_field: PrusaGcodeOutputSemanticField,
        value: String,
    },
    UnexpectedEvidenceBoundary {
        line_number: usize,
        semantic_field: PrusaGcodeOutputSemanticField,
        value: String,
    },
    DuplicateRow {
        line_number: usize,
        semantic_field: PrusaGcodeOutputSemanticField,
    },
    UnexpectedRowOrder {
        line_number: usize,
        expected_semantic_field: PrusaGcodeOutputSemanticField,
        actual_semantic_field: PrusaGcodeOutputSemanticField,
    },
    MissingRow {
        semantic_field: PrusaGcodeOutputSemanticField,
    },
    ExtraRow {
        line_number: usize,
        semantic_field: PrusaGcodeOutputSemanticField,
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
    pub expected_structural_summary_path: &'static str,
    pub expected_semantic_summary_path: &'static str,
    pub scope_record_path: &'static str,
    pub reserved_future_status_token: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaGcodeOutputStructuralReadiness {
    pub inventory_id: &'static str,
    pub source_ref: VendorSourceRef,
    pub inventory_source_paths: &'static [&'static str],
    pub fixture_path: &'static str,
    pub expected_structural_summary_path: &'static str,
    pub parser_boundary: &'static str,
    pub parity_dependency: ParitySurface,
    pub checklist_status: ChecklistStatus,
    pub reserved_future_status_token: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaGcodeOutputSemanticReadiness {
    pub inventory_id: &'static str,
    pub source_ref: VendorSourceRef,
    pub inventory_source_paths: &'static [&'static str],
    pub fixture_corpus_path: &'static str,
    pub fixture_path: &'static str,
    pub expected_semantic_summary_path: &'static str,
    pub parser_boundary: &'static str,
    pub planned_public_command: &'static str,
    pub planned_status_token: &'static str,
    pub generated_outputs_status: &'static str,
    pub pre_publication_boundary: &'static str,
    pub deferred_surfaces: &'static [&'static str],
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
struct ExpectedGcodeOutputStructuralRow {
    structural_field: PrusaGcodeOutputStructuralField,
    structural_category: PrusaGcodeOutputStructuralCategory,
    structural_value: PrusaGcodeOutputStructuralValue,
    evidence_boundary: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct ExpectedGcodeOutputSemanticRow {
    semantic_field: PrusaGcodeOutputSemanticField,
    semantic_category: PrusaGcodeOutputSemanticCategory,
    semantic_value: PrusaGcodeOutputSemanticValue,
    evidence_boundary: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct PrusaGcodeOutputRowKey {
    metadata_key: PrusaGcodeOutputMetadataKey,
    metadata_value: PrusaGcodeOutputMetadataValue,
    marker_key: PrusaGcodeOutputMarkerKey,
    marker_value: PrusaGcodeOutputMarkerValue,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct PrusaGcodeOutputStructuralRowKey {
    structural_field: PrusaGcodeOutputStructuralField,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct PrusaGcodeOutputSemanticRowKey {
    semantic_field: PrusaGcodeOutputSemanticField,
}

pub type PrusaGcodeOutputParseResult = Result<PrusaGcodeOutputSummary, PrusaGcodeOutputParseError>;
pub type PrusaGcodeOutputStructuralParseResult =
    Result<PrusaGcodeOutputStructuralSummary, PrusaGcodeOutputStructuralParseError>;
pub type PrusaGcodeOutputSemanticParseResult =
    Result<PrusaGcodeOutputSemanticSummary, PrusaGcodeOutputSemanticParseError>;

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
        expected_structural_summary_path: PRUSA_GCODE_OUTPUT_EXPECTED_STRUCTURAL_SUMMARY_PATH,
        expected_semantic_summary_path: PRUSA_GCODE_OUTPUT_EXPECTED_SEMANTIC_SUMMARY_PATH,
        scope_record_path: PRUSA_GCODE_OUTPUT_SCOPE_RECORD_PATH,
        reserved_future_status_token: PRUSA_GCODE_OUTPUT_RESERVED_STATUS_TOKEN,
    }
}

pub const fn prusa_gcode_output_structural_readiness() -> PrusaGcodeOutputStructuralReadiness {
    PrusaGcodeOutputStructuralReadiness {
        inventory_id: PRUSA_GCODE_OUTPUT_INVENTORY_ID,
        source_ref: PRUSA_GCODE_OUTPUT_SOURCE_REF,
        inventory_source_paths: &PRUSA_GCODE_OUTPUT_INVENTORY_SOURCE_PATHS,
        fixture_path: PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
        expected_structural_summary_path: PRUSA_GCODE_OUTPUT_EXPECTED_STRUCTURAL_SUMMARY_PATH,
        parser_boundary: "slic3r_flavors::prusa_gcode_output::parse_prusa_gcode_output_structural_summary",
        parity_dependency: ParitySurface::generated_outputs(),
        checklist_status: ChecklistStatus::FutureCandidate,
        reserved_future_status_token: PRUSA_GCODE_OUTPUT_RESERVED_STATUS_TOKEN,
    }
}

pub const fn prusa_gcode_output_semantic_readiness() -> PrusaGcodeOutputSemanticReadiness {
    PrusaGcodeOutputSemanticReadiness {
        inventory_id: PRUSA_GCODE_OUTPUT_INVENTORY_ID,
        source_ref: PRUSA_GCODE_OUTPUT_SOURCE_REF,
        inventory_source_paths: &PRUSA_GCODE_OUTPUT_INVENTORY_SOURCE_PATHS,
        fixture_corpus_path: PRUSA_GCODE_OUTPUT_FIXTURE_CORPUS_PATH,
        fixture_path: PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
        expected_semantic_summary_path: PRUSA_GCODE_OUTPUT_EXPECTED_SEMANTIC_SUMMARY_PATH,
        parser_boundary: "slic3r_flavors::prusa_gcode_output::parse_prusa_gcode_output_semantic_summary",
        planned_public_command: "//packages/parity:prusaslicer_gcode_output_parity",
        planned_status_token: PRUSA_GCODE_OUTPUT_RESERVED_STATUS_TOKEN,
        generated_outputs_status: "in progress",
        pre_publication_boundary: "Phase 55 exposes semantic parser/readiness metadata only; Phase 56 owns public semantic parity evidence and status/docs publication.",
        deferred_surfaces: &PRUSA_GCODE_OUTPUT_DEFERRED_SEMANTIC_SURFACES,
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

pub fn parse_prusa_gcode_output_structural_summary(
    input: &str,
) -> PrusaGcodeOutputStructuralParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaGcodeOutputStructuralParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_structural_header(header)?;

    let mut rows = Vec::new();
    let mut row_keys = Vec::new();

    for (line_offset, line) in lines.enumerate() {
        let line_number = line_offset + 2;
        let row = parse_structural_summary_row(line, line_number)?;
        let row_key = PrusaGcodeOutputStructuralRowKey::from_row(&row);

        if row_keys.contains(&row_key) {
            return Err(PrusaGcodeOutputStructuralParseError::DuplicateRow {
                line_number,
                structural_field: row.structural_field,
            });
        }

        if !is_expected_structural_row_key(row_key) {
            return Err(PrusaGcodeOutputStructuralParseError::ExtraRow {
                line_number,
                structural_field: row.structural_field,
            });
        }

        if let Some(expected_row) = EXPECTED_STRUCTURAL_ROWS.get(line_offset).copied() {
            let expected_key = PrusaGcodeOutputStructuralRowKey::from_expected(expected_row);
            if row_key != expected_key {
                return Err(PrusaGcodeOutputStructuralParseError::UnexpectedRowOrder {
                    line_number,
                    expected_structural_field: expected_row.structural_field,
                    actual_structural_field: row.structural_field,
                });
            }
        } else {
            return Err(PrusaGcodeOutputStructuralParseError::ExtraRow {
                line_number,
                structural_field: row.structural_field,
            });
        }

        row_keys.push(row_key);
        rows.push(row);
    }

    validate_missing_structural_rows(&row_keys)?;

    Ok(PrusaGcodeOutputStructuralSummary::from_validated_rows(rows))
}

pub fn parse_prusa_gcode_output_semantic_summary(
    input: &str,
) -> PrusaGcodeOutputSemanticParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaGcodeOutputSemanticParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_semantic_header(header)?;

    let mut rows = Vec::new();
    let mut row_keys = Vec::new();

    for (line_offset, line) in lines.enumerate() {
        let line_number = line_offset + 2;
        let row = parse_semantic_summary_row(line, line_number)?;
        let row_key = PrusaGcodeOutputSemanticRowKey::from_row(&row);

        if row_keys.contains(&row_key) {
            return Err(PrusaGcodeOutputSemanticParseError::DuplicateRow {
                line_number,
                semantic_field: row.semantic_field,
            });
        }

        if !is_expected_semantic_row_key(row_key) {
            return Err(PrusaGcodeOutputSemanticParseError::ExtraRow {
                line_number,
                semantic_field: row.semantic_field,
            });
        }

        if let Some(expected_row) = EXPECTED_SEMANTIC_ROWS.get(line_offset).copied() {
            let expected_key = PrusaGcodeOutputSemanticRowKey::from_expected(expected_row);
            if row_key != expected_key {
                return Err(PrusaGcodeOutputSemanticParseError::UnexpectedRowOrder {
                    line_number,
                    expected_semantic_field: expected_row.semantic_field,
                    actual_semantic_field: row.semantic_field,
                });
            }
        } else {
            return Err(PrusaGcodeOutputSemanticParseError::ExtraRow {
                line_number,
                semantic_field: row.semantic_field,
            });
        }

        row_keys.push(row_key);
        rows.push(row);
    }

    validate_missing_semantic_rows(&row_keys)?;

    Ok(PrusaGcodeOutputSemanticSummary::from_validated_rows(rows))
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

pub fn prusa_gcode_output_structural_summary_lines(
    input: &str,
) -> Result<Vec<String>, PrusaGcodeOutputStructuralParseError> {
    let summary = parse_prusa_gcode_output_structural_summary(input)?;
    let readiness = prusa_gcode_output_structural_readiness();
    let facts = summary.facts();

    Ok(vec![
        summary_line(
            "structural_summary_path",
            readiness.expected_structural_summary_path,
        ),
        format!("structural_row_count\t{}", summary.rows().len()),
        summary_line("source_ref", facts.source_ref.as_str()),
        summary_line("inventory_source_paths", facts.inventory_source_paths),
        summary_line("fixture_source_literal", facts.fixture_source_literal),
        summary_line("fixture_id", facts.fixture_id),
        summary_line("fixture_path", facts.fixture_path),
        format!("command_count_total\t{}", facts.command_count_total),
        format!("command_count_g1\t{}", facts.command_count_g1),
        format!("section_count_total\t{}", facts.section_count_total),
        summary_line("ordered_marker_1", facts.ordered_markers[0].as_str()),
        summary_line("ordered_marker_2", facts.ordered_markers[1].as_str()),
        summary_line("ordered_marker_3", facts.ordered_markers[2].as_str()),
        summary_line("ordered_marker_4", facts.ordered_markers[3].as_str()),
        format!("movement_axis_present\t{}", facts.movement_axis_present),
        format!("extrusion_axis_present\t{}", facts.extrusion_axis_present),
        format!(
            "temperature_marker_count\t{}",
            facts.temperature_marker_count
        ),
        format!(
            "tool_change_marker_count\t{}",
            facts.tool_change_marker_count
        ),
    ])
}

pub fn prusa_gcode_output_semantic_summary_lines(
    input: &str,
) -> Result<Vec<String>, PrusaGcodeOutputSemanticParseError> {
    let summary = parse_prusa_gcode_output_semantic_summary(input)?;
    let readiness = prusa_gcode_output_semantic_readiness();
    let facts = summary.facts();

    Ok(vec![
        summary_line(
            "semantic_summary_path",
            readiness.expected_semantic_summary_path,
        ),
        format!("semantic_row_count\t{}", summary.rows().len()),
        summary_line("source_ref", facts.source_ref.as_str()),
        summary_line("fixture_id", facts.fixture_id),
        summary_line("fixture_path", facts.fixture_path),
        summary_line("command_class_counts", facts.command_class_counts),
        summary_line("movement_class_counts", facts.movement_class_counts),
        summary_line("coordinate_bounds", facts.coordinate_bounds),
        summary_line("extrusion_total", facts.extrusion_total),
        summary_line("feedrate_observations", facts.feedrate_observations),
        summary_line(
            "layer_marker_relationships",
            facts.layer_marker_relationships,
        ),
    ])
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

impl PrusaGcodeOutputStructuralSummary {
    fn from_validated_rows(rows: Vec<PrusaGcodeOutputStructuralSummaryRow>) -> Self {
        let facts = PrusaGcodeOutputStructuralFacts::from_validated_rows(&rows);
        Self { rows, facts }
    }

    pub fn rows(&self) -> &[PrusaGcodeOutputStructuralSummaryRow] {
        &self.rows
    }

    pub fn facts(&self) -> PrusaGcodeOutputStructuralFacts {
        self.facts
    }
}

impl PrusaGcodeOutputStructuralFacts {
    fn from_validated_rows(rows: &[PrusaGcodeOutputStructuralSummaryRow]) -> Self {
        let mut facts = PrusaGcodeOutputStructuralFacts::expected();

        for row in rows {
            match (row.structural_field, row.structural_value) {
                (
                    PrusaGcodeOutputStructuralField::SourceRef,
                    PrusaGcodeOutputStructuralValue::SourceRef(source_ref),
                ) => facts.source_ref = source_ref,
                (
                    PrusaGcodeOutputStructuralField::InventorySourcePaths,
                    PrusaGcodeOutputStructuralValue::InventorySourcePaths(inventory_source_paths),
                ) => facts.inventory_source_paths = inventory_source_paths,
                (
                    PrusaGcodeOutputStructuralField::FixtureSourceLiteral,
                    PrusaGcodeOutputStructuralValue::FixtureSourceLiteral(fixture_source_literal),
                ) => facts.fixture_source_literal = fixture_source_literal,
                (
                    PrusaGcodeOutputStructuralField::FixtureId,
                    PrusaGcodeOutputStructuralValue::FixtureId(fixture_id),
                ) => facts.fixture_id = fixture_id,
                (
                    PrusaGcodeOutputStructuralField::FixturePath,
                    PrusaGcodeOutputStructuralValue::FixturePath(fixture_path),
                ) => facts.fixture_path = fixture_path,
                (
                    PrusaGcodeOutputStructuralField::CommandCountTotal,
                    PrusaGcodeOutputStructuralValue::Count(count),
                ) => facts.command_count_total = count,
                (
                    PrusaGcodeOutputStructuralField::CommandCountG1,
                    PrusaGcodeOutputStructuralValue::Count(count),
                ) => facts.command_count_g1 = count,
                (
                    PrusaGcodeOutputStructuralField::SectionCountTotal,
                    PrusaGcodeOutputStructuralValue::Count(count),
                ) => facts.section_count_total = count,
                (
                    PrusaGcodeOutputStructuralField::OrderedMarker1,
                    PrusaGcodeOutputStructuralValue::OrderedMarker(marker),
                ) => facts.ordered_markers[0] = marker,
                (
                    PrusaGcodeOutputStructuralField::OrderedMarker2,
                    PrusaGcodeOutputStructuralValue::OrderedMarker(marker),
                ) => facts.ordered_markers[1] = marker,
                (
                    PrusaGcodeOutputStructuralField::OrderedMarker3,
                    PrusaGcodeOutputStructuralValue::OrderedMarker(marker),
                ) => facts.ordered_markers[2] = marker,
                (
                    PrusaGcodeOutputStructuralField::OrderedMarker4,
                    PrusaGcodeOutputStructuralValue::OrderedMarker(marker),
                ) => facts.ordered_markers[3] = marker,
                (
                    PrusaGcodeOutputStructuralField::MovementAxisPresent,
                    PrusaGcodeOutputStructuralValue::Indicator(is_present),
                ) => facts.movement_axis_present = is_present,
                (
                    PrusaGcodeOutputStructuralField::ExtrusionAxisPresent,
                    PrusaGcodeOutputStructuralValue::Indicator(is_present),
                ) => facts.extrusion_axis_present = is_present,
                (
                    PrusaGcodeOutputStructuralField::TemperatureMarkerCount,
                    PrusaGcodeOutputStructuralValue::Count(count),
                ) => facts.temperature_marker_count = count,
                (
                    PrusaGcodeOutputStructuralField::ToolChangeMarkerCount,
                    PrusaGcodeOutputStructuralValue::Count(count),
                ) => facts.tool_change_marker_count = count,
                _ => unreachable!("validated structural summary row value must match its field"),
            }
        }

        facts
    }

    const fn expected() -> Self {
        Self {
            source_ref: PRUSA_GCODE_OUTPUT_SOURCE_REF,
            inventory_source_paths: PRUSA_GCODE_OUTPUT_INVENTORY_SOURCE_PATHS_VALUE,
            fixture_source_literal: PRUSA_GCODE_OUTPUT_FIXTURE_SOURCE_LITERAL,
            fixture_id: PRUSA_GCODE_OUTPUT_FIXTURE_ID,
            fixture_path: PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
            command_count_total: 4,
            command_count_g1: 4,
            section_count_total: 1,
            ordered_markers: [
                PrusaGcodeOutputMarkerValue::FeedrateFixedPoint,
                PrusaGcodeOutputMarkerValue::FeedrateInteger,
                PrusaGcodeOutputMarkerValue::FeedrateOneDecimal,
                PrusaGcodeOutputMarkerValue::FeedrateThreeDecimalRounded,
            ],
            movement_axis_present: false,
            extrusion_axis_present: false,
            temperature_marker_count: 0,
            tool_change_marker_count: 0,
        }
    }
}

impl PrusaGcodeOutputSemanticSummary {
    fn from_validated_rows(rows: Vec<PrusaGcodeOutputSemanticSummaryRow>) -> Self {
        let facts = PrusaGcodeOutputSemanticFacts::from_validated_rows(&rows);
        Self { rows, facts }
    }

    pub fn rows(&self) -> &[PrusaGcodeOutputSemanticSummaryRow] {
        &self.rows
    }

    pub fn facts(&self) -> PrusaGcodeOutputSemanticFacts {
        self.facts
    }
}

impl PrusaGcodeOutputSemanticFacts {
    fn from_validated_rows(rows: &[PrusaGcodeOutputSemanticSummaryRow]) -> Self {
        let mut facts = PrusaGcodeOutputSemanticFacts::expected();

        for row in rows {
            match (row.semantic_field, row.semantic_value) {
                (
                    PrusaGcodeOutputSemanticField::SourceRef,
                    PrusaGcodeOutputSemanticValue::SourceRef(source_ref),
                ) => facts.source_ref = source_ref,
                (
                    PrusaGcodeOutputSemanticField::FixtureId,
                    PrusaGcodeOutputSemanticValue::Text(fixture_id),
                ) => facts.fixture_id = fixture_id,
                (
                    PrusaGcodeOutputSemanticField::FixturePath,
                    PrusaGcodeOutputSemanticValue::Text(fixture_path),
                ) => facts.fixture_path = fixture_path,
                (
                    PrusaGcodeOutputSemanticField::CommandClassCounts,
                    PrusaGcodeOutputSemanticValue::Text(command_class_counts),
                ) => facts.command_class_counts = command_class_counts,
                (
                    PrusaGcodeOutputSemanticField::MovementClassCounts,
                    PrusaGcodeOutputSemanticValue::Text(movement_class_counts),
                ) => facts.movement_class_counts = movement_class_counts,
                (
                    PrusaGcodeOutputSemanticField::CoordinateBounds,
                    PrusaGcodeOutputSemanticValue::Text(coordinate_bounds),
                ) => facts.coordinate_bounds = coordinate_bounds,
                (
                    PrusaGcodeOutputSemanticField::ExtrusionTotal,
                    PrusaGcodeOutputSemanticValue::Text(extrusion_total),
                ) => facts.extrusion_total = extrusion_total,
                (
                    PrusaGcodeOutputSemanticField::FeedrateObservations,
                    PrusaGcodeOutputSemanticValue::Text(feedrate_observations),
                ) => facts.feedrate_observations = feedrate_observations,
                (
                    PrusaGcodeOutputSemanticField::LayerMarkerRelationships,
                    PrusaGcodeOutputSemanticValue::Text(layer_marker_relationships),
                ) => facts.layer_marker_relationships = layer_marker_relationships,
                _ => unreachable!("validated semantic summary row value must match its field"),
            }
        }

        facts
    }

    const fn expected() -> Self {
        Self {
            source_ref: PRUSA_GCODE_OUTPUT_SOURCE_REF,
            fixture_id: PRUSA_GCODE_OUTPUT_FIXTURE_ID,
            fixture_path: PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
            command_class_counts: SEMANTIC_COMMAND_CLASS_COUNTS_VALUE,
            movement_class_counts: SEMANTIC_MOVEMENT_CLASS_COUNTS_VALUE,
            coordinate_bounds: SEMANTIC_COORDINATE_BOUNDS_VALUE,
            extrusion_total: SEMANTIC_EXTRUSION_TOTAL_VALUE,
            feedrate_observations: SEMANTIC_FEEDRATE_OBSERVATIONS_VALUE,
            layer_marker_relationships: SEMANTIC_LAYER_MARKER_RELATIONSHIPS_VALUE,
        }
    }
}

impl PrusaGcodeOutputStructuralField {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::SourceRef => "source_ref",
            Self::InventorySourcePaths => "inventory_source_paths",
            Self::FixtureSourceLiteral => "fixture_source_literal",
            Self::FixtureId => "fixture_id",
            Self::FixturePath => "fixture_path",
            Self::CommandCountTotal => "command_count_total",
            Self::CommandCountG1 => "command_count_g1",
            Self::SectionCountTotal => "section_count_total",
            Self::OrderedMarker1 => "ordered_marker_1",
            Self::OrderedMarker2 => "ordered_marker_2",
            Self::OrderedMarker3 => "ordered_marker_3",
            Self::OrderedMarker4 => "ordered_marker_4",
            Self::MovementAxisPresent => "movement_axis_present",
            Self::ExtrusionAxisPresent => "extrusion_axis_present",
            Self::TemperatureMarkerCount => "temperature_marker_count",
            Self::ToolChangeMarkerCount => "tool_change_marker_count",
        }
    }
}

impl PrusaGcodeOutputSemanticField {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::SourceRef => "source_ref",
            Self::FixtureId => "fixture_id",
            Self::FixturePath => "fixture_path",
            Self::CommandClassCounts => "command_class_counts",
            Self::MovementClassCounts => "movement_class_counts",
            Self::CoordinateBounds => "coordinate_bounds",
            Self::ExtrusionTotal => "extrusion_total",
            Self::FeedrateObservations => "feedrate_observations",
            Self::LayerMarkerRelationships => "layer_marker_relationships",
        }
    }
}

impl PrusaGcodeOutputStructuralCategory {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::SourceIdentity => "source identity",
            Self::FixtureIdentity => "fixture identity",
            Self::CommandCounts => "command counts",
            Self::SectionCounts => "section counts",
            Self::OrderedMarkers => "ordered markers",
            Self::MovementExtrusionIndicators => "movement/extrusion indicators",
            Self::TemperatureToolChangeMarkers => "temperature/tool-change markers",
        }
    }
}

impl PrusaGcodeOutputSemanticCategory {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::SourceIdentity => "source identity",
            Self::FixtureIdentity => "fixture identity",
            Self::CommandClasses => "command classes",
            Self::MovementClasses => "movement classes",
            Self::CoordinateBounds => "coordinate bounds",
            Self::ExtrusionTotal => "extrusion total",
            Self::FeedrateObservations => "feedrate observations",
            Self::LayerMarkerRelationships => "layer or marker relationships",
        }
    }
}

impl PrusaGcodeOutputSemanticValue {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::SourceRef(source_ref) => source_ref.as_str(),
            Self::Text(value) => value,
        }
    }
}

impl PrusaGcodeOutputEvidenceBoundary {
    pub const fn as_str(self) -> &'static str {
        self.0
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

impl PrusaGcodeOutputStructuralRowKey {
    fn from_expected(row: ExpectedGcodeOutputStructuralRow) -> Self {
        Self {
            structural_field: row.structural_field,
        }
    }

    fn from_row(row: &PrusaGcodeOutputStructuralSummaryRow) -> Self {
        Self {
            structural_field: row.structural_field,
        }
    }
}

impl PrusaGcodeOutputSemanticRowKey {
    fn from_expected(row: ExpectedGcodeOutputSemanticRow) -> Self {
        Self {
            semantic_field: row.semantic_field,
        }
    }

    fn from_row(row: &PrusaGcodeOutputSemanticSummaryRow) -> Self {
        Self {
            semantic_field: row.semantic_field,
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

fn validate_structural_header(line: &str) -> Result<(), PrusaGcodeOutputStructuralParseError> {
    if line != STRUCTURAL_EXPECTED_HEADER {
        return Err(PrusaGcodeOutputStructuralParseError::InvalidHeader {
            line: line.to_owned(),
        });
    }

    Ok(())
}

fn parse_structural_summary_row(
    line: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputStructuralSummaryRow, PrusaGcodeOutputStructuralParseError> {
    let columns: Vec<&str> = line.split('\t').collect();
    validate_structural_column_count(&columns, line_number)?;
    validate_structural_required_values(&columns, line_number)?;

    let source_ref = parse_structural_source_ref(columns[0], line_number)?;
    let fixture_path = parse_structural_fixture_path(columns[1], line_number)?;
    let structural_field = parse_structural_field(columns[2], line_number)?;
    let structural_category = parse_structural_category(columns[3], line_number)?;
    let Some(expected_row) = expected_structural_row_for_field(structural_field) else {
        return Err(PrusaGcodeOutputStructuralParseError::ExtraRow {
            line_number,
            structural_field,
        });
    };

    if structural_category != expected_row.structural_category {
        return Err(
            PrusaGcodeOutputStructuralParseError::UnexpectedStructuralCategory {
                line_number,
                structural_field,
                value: columns[3].to_owned(),
            },
        );
    }

    let structural_value = parse_structural_value(columns[4], structural_field, line_number)?;
    let evidence_boundary = parse_evidence_boundary(columns[5], expected_row, line_number)?;

    Ok(PrusaGcodeOutputStructuralSummaryRow {
        source_ref,
        fixture_path,
        structural_field,
        structural_category,
        structural_value,
        evidence_boundary,
    })
}

fn validate_structural_column_count(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaGcodeOutputStructuralParseError> {
    if columns.len() != STRUCTURAL_EXPECTED_COLUMN_COUNT {
        return Err(PrusaGcodeOutputStructuralParseError::WrongColumnCount {
            line_number,
            expected: STRUCTURAL_EXPECTED_COLUMN_COUNT,
            actual: columns.len(),
        });
    }

    Ok(())
}

fn validate_structural_required_values(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaGcodeOutputStructuralParseError> {
    for (index, value) in columns.iter().enumerate() {
        if value.is_empty() {
            return Err(PrusaGcodeOutputStructuralParseError::EmptyRequiredValue {
                line_number,
                column: STRUCTURAL_COLUMNS[index],
            });
        }
    }

    Ok(())
}

fn parse_structural_source_ref(
    value: &str,
    line_number: usize,
) -> Result<VendorSourceRef, PrusaGcodeOutputStructuralParseError> {
    if value != PRUSA_GCODE_OUTPUT_SOURCE_REF.as_str() {
        return Err(PrusaGcodeOutputStructuralParseError::UnexpectedSourceRef {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_GCODE_OUTPUT_SOURCE_REF)
}

fn parse_structural_fixture_path(
    value: &str,
    line_number: usize,
) -> Result<&'static str, PrusaGcodeOutputStructuralParseError> {
    if value != PRUSA_GCODE_OUTPUT_FIXTURE_PATH {
        return Err(
            PrusaGcodeOutputStructuralParseError::UnexpectedFixturePath {
                line_number,
                value: value.to_owned(),
            },
        );
    }

    Ok(PRUSA_GCODE_OUTPUT_FIXTURE_PATH)
}

fn parse_structural_field(
    value: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputStructuralField, PrusaGcodeOutputStructuralParseError> {
    match value {
        "source_ref" => Ok(PrusaGcodeOutputStructuralField::SourceRef),
        "inventory_source_paths" => Ok(PrusaGcodeOutputStructuralField::InventorySourcePaths),
        "fixture_source_literal" => Ok(PrusaGcodeOutputStructuralField::FixtureSourceLiteral),
        "fixture_id" => Ok(PrusaGcodeOutputStructuralField::FixtureId),
        "fixture_path" => Ok(PrusaGcodeOutputStructuralField::FixturePath),
        "command_count_total" => Ok(PrusaGcodeOutputStructuralField::CommandCountTotal),
        "command_count_g1" => Ok(PrusaGcodeOutputStructuralField::CommandCountG1),
        "section_count_total" => Ok(PrusaGcodeOutputStructuralField::SectionCountTotal),
        "ordered_marker_1" => Ok(PrusaGcodeOutputStructuralField::OrderedMarker1),
        "ordered_marker_2" => Ok(PrusaGcodeOutputStructuralField::OrderedMarker2),
        "ordered_marker_3" => Ok(PrusaGcodeOutputStructuralField::OrderedMarker3),
        "ordered_marker_4" => Ok(PrusaGcodeOutputStructuralField::OrderedMarker4),
        "movement_axis_present" => Ok(PrusaGcodeOutputStructuralField::MovementAxisPresent),
        "extrusion_axis_present" => Ok(PrusaGcodeOutputStructuralField::ExtrusionAxisPresent),
        "temperature_marker_count" => Ok(PrusaGcodeOutputStructuralField::TemperatureMarkerCount),
        "tool_change_marker_count" => Ok(PrusaGcodeOutputStructuralField::ToolChangeMarkerCount),
        _ => Err(
            PrusaGcodeOutputStructuralParseError::UnsupportedStructuralField {
                line_number,
                value: value.to_owned(),
            },
        ),
    }
}

fn parse_structural_category(
    value: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputStructuralCategory, PrusaGcodeOutputStructuralParseError> {
    match value {
        "source identity" => Ok(PrusaGcodeOutputStructuralCategory::SourceIdentity),
        "fixture identity" => Ok(PrusaGcodeOutputStructuralCategory::FixtureIdentity),
        "command counts" => Ok(PrusaGcodeOutputStructuralCategory::CommandCounts),
        "section counts" => Ok(PrusaGcodeOutputStructuralCategory::SectionCounts),
        "ordered markers" => Ok(PrusaGcodeOutputStructuralCategory::OrderedMarkers),
        "movement/extrusion indicators" => {
            Ok(PrusaGcodeOutputStructuralCategory::MovementExtrusionIndicators)
        }
        "temperature/tool-change markers" => {
            Ok(PrusaGcodeOutputStructuralCategory::TemperatureToolChangeMarkers)
        }
        _ => Err(
            PrusaGcodeOutputStructuralParseError::UnsupportedStructuralCategory {
                line_number,
                value: value.to_owned(),
            },
        ),
    }
}

fn parse_structural_value(
    value: &str,
    structural_field: PrusaGcodeOutputStructuralField,
    line_number: usize,
) -> Result<PrusaGcodeOutputStructuralValue, PrusaGcodeOutputStructuralParseError> {
    match structural_field {
        PrusaGcodeOutputStructuralField::SourceRef => {
            parse_expected_structural_source_ref_value(value, structural_field, line_number)
        }
        PrusaGcodeOutputStructuralField::InventorySourcePaths => {
            parse_expected_structural_string_value(
                value,
                structural_field,
                PRUSA_GCODE_OUTPUT_INVENTORY_SOURCE_PATHS_VALUE,
                PrusaGcodeOutputStructuralValue::InventorySourcePaths,
                line_number,
            )
        }
        PrusaGcodeOutputStructuralField::FixtureSourceLiteral => {
            parse_expected_structural_string_value(
                value,
                structural_field,
                PRUSA_GCODE_OUTPUT_FIXTURE_SOURCE_LITERAL,
                PrusaGcodeOutputStructuralValue::FixtureSourceLiteral,
                line_number,
            )
        }
        PrusaGcodeOutputStructuralField::FixtureId => parse_expected_structural_string_value(
            value,
            structural_field,
            PRUSA_GCODE_OUTPUT_FIXTURE_ID,
            PrusaGcodeOutputStructuralValue::FixtureId,
            line_number,
        ),
        PrusaGcodeOutputStructuralField::FixturePath => parse_expected_structural_string_value(
            value,
            structural_field,
            PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
            PrusaGcodeOutputStructuralValue::FixturePath,
            line_number,
        ),
        PrusaGcodeOutputStructuralField::CommandCountTotal
        | PrusaGcodeOutputStructuralField::CommandCountG1 => {
            parse_expected_structural_count(value, structural_field, 4, line_number)
        }
        PrusaGcodeOutputStructuralField::SectionCountTotal => {
            parse_expected_structural_count(value, structural_field, 1, line_number)
        }
        PrusaGcodeOutputStructuralField::OrderedMarker1 => parse_expected_structural_marker(
            value,
            structural_field,
            PrusaGcodeOutputMarkerValue::FeedrateFixedPoint,
            line_number,
        ),
        PrusaGcodeOutputStructuralField::OrderedMarker2 => parse_expected_structural_marker(
            value,
            structural_field,
            PrusaGcodeOutputMarkerValue::FeedrateInteger,
            line_number,
        ),
        PrusaGcodeOutputStructuralField::OrderedMarker3 => parse_expected_structural_marker(
            value,
            structural_field,
            PrusaGcodeOutputMarkerValue::FeedrateOneDecimal,
            line_number,
        ),
        PrusaGcodeOutputStructuralField::OrderedMarker4 => parse_expected_structural_marker(
            value,
            structural_field,
            PrusaGcodeOutputMarkerValue::FeedrateThreeDecimalRounded,
            line_number,
        ),
        PrusaGcodeOutputStructuralField::MovementAxisPresent
        | PrusaGcodeOutputStructuralField::ExtrusionAxisPresent => {
            parse_expected_structural_indicator(value, structural_field, false, line_number)
        }
        PrusaGcodeOutputStructuralField::TemperatureMarkerCount
        | PrusaGcodeOutputStructuralField::ToolChangeMarkerCount => {
            parse_expected_structural_count(value, structural_field, 0, line_number)
        }
    }
}

fn parse_expected_structural_source_ref_value(
    value: &str,
    structural_field: PrusaGcodeOutputStructuralField,
    line_number: usize,
) -> Result<PrusaGcodeOutputStructuralValue, PrusaGcodeOutputStructuralParseError> {
    if value != PRUSA_GCODE_OUTPUT_SOURCE_REF.as_str() {
        return Err(unexpected_structural_value_error(
            value,
            structural_field,
            line_number,
        ));
    }

    Ok(PrusaGcodeOutputStructuralValue::SourceRef(
        PRUSA_GCODE_OUTPUT_SOURCE_REF,
    ))
}

fn parse_expected_structural_string_value(
    value: &str,
    structural_field: PrusaGcodeOutputStructuralField,
    expected_value: &'static str,
    build_value: fn(&'static str) -> PrusaGcodeOutputStructuralValue,
    line_number: usize,
) -> Result<PrusaGcodeOutputStructuralValue, PrusaGcodeOutputStructuralParseError> {
    if value != expected_value {
        return Err(unexpected_structural_value_error(
            value,
            structural_field,
            line_number,
        ));
    }

    Ok(build_value(expected_value))
}

fn parse_expected_structural_count(
    value: &str,
    structural_field: PrusaGcodeOutputStructuralField,
    expected_value: u32,
    line_number: usize,
) -> Result<PrusaGcodeOutputStructuralValue, PrusaGcodeOutputStructuralParseError> {
    match value.parse::<u32>() {
        Ok(count) if count == expected_value => Ok(PrusaGcodeOutputStructuralValue::Count(count)),
        _ => Err(unexpected_structural_value_error(
            value,
            structural_field,
            line_number,
        )),
    }
}

fn parse_expected_structural_indicator(
    value: &str,
    structural_field: PrusaGcodeOutputStructuralField,
    expected_value: bool,
    line_number: usize,
) -> Result<PrusaGcodeOutputStructuralValue, PrusaGcodeOutputStructuralParseError> {
    match value.parse::<bool>() {
        Ok(is_present) if is_present == expected_value => {
            Ok(PrusaGcodeOutputStructuralValue::Indicator(is_present))
        }
        _ => Err(unexpected_structural_value_error(
            value,
            structural_field,
            line_number,
        )),
    }
}

fn parse_expected_structural_marker(
    value: &str,
    structural_field: PrusaGcodeOutputStructuralField,
    expected_value: PrusaGcodeOutputMarkerValue,
    line_number: usize,
) -> Result<PrusaGcodeOutputStructuralValue, PrusaGcodeOutputStructuralParseError> {
    if value != expected_value.as_str() {
        return Err(unexpected_structural_value_error(
            value,
            structural_field,
            line_number,
        ));
    }

    Ok(PrusaGcodeOutputStructuralValue::OrderedMarker(
        expected_value,
    ))
}

fn parse_evidence_boundary(
    value: &str,
    expected_row: ExpectedGcodeOutputStructuralRow,
    line_number: usize,
) -> Result<PrusaGcodeOutputEvidenceBoundary, PrusaGcodeOutputStructuralParseError> {
    if value != expected_row.evidence_boundary {
        return Err(
            PrusaGcodeOutputStructuralParseError::UnexpectedEvidenceBoundary {
                line_number,
                structural_field: expected_row.structural_field,
                value: value.to_owned(),
            },
        );
    }

    Ok(PrusaGcodeOutputEvidenceBoundary(
        expected_row.evidence_boundary,
    ))
}

fn unexpected_structural_value_error(
    value: &str,
    structural_field: PrusaGcodeOutputStructuralField,
    line_number: usize,
) -> PrusaGcodeOutputStructuralParseError {
    PrusaGcodeOutputStructuralParseError::UnexpectedStructuralValue {
        line_number,
        structural_field,
        value: value.to_owned(),
    }
}

fn expected_structural_row_for_field(
    structural_field: PrusaGcodeOutputStructuralField,
) -> Option<ExpectedGcodeOutputStructuralRow> {
    EXPECTED_STRUCTURAL_ROWS
        .iter()
        .copied()
        .find(|row| row.structural_field == structural_field)
}

fn expected_structural_row_for_key(
    row_key: PrusaGcodeOutputStructuralRowKey,
) -> Option<ExpectedGcodeOutputStructuralRow> {
    expected_structural_row_for_field(row_key.structural_field)
}

fn is_expected_structural_row_key(row_key: PrusaGcodeOutputStructuralRowKey) -> bool {
    expected_structural_row_for_key(row_key).is_some()
}

fn validate_missing_structural_rows(
    row_keys: &[PrusaGcodeOutputStructuralRowKey],
) -> Result<(), PrusaGcodeOutputStructuralParseError> {
    for expected_row in EXPECTED_STRUCTURAL_ROWS {
        let row_key = PrusaGcodeOutputStructuralRowKey::from_expected(expected_row);
        if !row_keys.contains(&row_key) {
            return Err(PrusaGcodeOutputStructuralParseError::MissingRow {
                structural_field: expected_row.structural_field,
            });
        }
    }

    Ok(())
}

fn validate_semantic_header(line: &str) -> Result<(), PrusaGcodeOutputSemanticParseError> {
    if line != SEMANTIC_EXPECTED_HEADER {
        return Err(PrusaGcodeOutputSemanticParseError::InvalidHeader {
            line: line.to_owned(),
        });
    }

    Ok(())
}

fn parse_semantic_summary_row(
    line: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputSemanticSummaryRow, PrusaGcodeOutputSemanticParseError> {
    let columns: Vec<&str> = line.split('\t').collect();
    validate_semantic_column_count(&columns, line_number)?;
    validate_semantic_required_values(&columns, line_number)?;

    let source_ref = parse_semantic_source_ref(columns[0], line_number)?;
    let fixture_path = parse_semantic_fixture_path(columns[1], line_number)?;
    let semantic_field = parse_semantic_field(columns[2], line_number)?;
    let semantic_category = parse_semantic_category(columns[3], line_number)?;
    let Some(expected_row) = expected_semantic_row_for_field(semantic_field) else {
        return Err(PrusaGcodeOutputSemanticParseError::ExtraRow {
            line_number,
            semantic_field,
        });
    };

    if semantic_category != expected_row.semantic_category {
        return Err(
            PrusaGcodeOutputSemanticParseError::UnexpectedSemanticCategory {
                line_number,
                semantic_field,
                value: columns[3].to_owned(),
            },
        );
    }

    let semantic_value = parse_semantic_value(columns[4], semantic_field, line_number)?;
    let evidence_boundary =
        parse_semantic_evidence_boundary(columns[5], expected_row, line_number)?;

    Ok(PrusaGcodeOutputSemanticSummaryRow {
        source_ref,
        fixture_path,
        semantic_field,
        semantic_category,
        semantic_value,
        evidence_boundary,
    })
}

fn validate_semantic_column_count(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaGcodeOutputSemanticParseError> {
    if columns.len() != SEMANTIC_EXPECTED_COLUMN_COUNT {
        return Err(PrusaGcodeOutputSemanticParseError::WrongColumnCount {
            line_number,
            expected: SEMANTIC_EXPECTED_COLUMN_COUNT,
            actual: columns.len(),
        });
    }

    Ok(())
}

fn validate_semantic_required_values(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaGcodeOutputSemanticParseError> {
    for (index, value) in columns.iter().enumerate() {
        if value.is_empty() {
            return Err(PrusaGcodeOutputSemanticParseError::EmptyRequiredValue {
                line_number,
                column: SEMANTIC_COLUMNS[index],
            });
        }
    }

    Ok(())
}

fn parse_semantic_source_ref(
    value: &str,
    line_number: usize,
) -> Result<VendorSourceRef, PrusaGcodeOutputSemanticParseError> {
    if value != PRUSA_GCODE_OUTPUT_SOURCE_REF.as_str() {
        return Err(PrusaGcodeOutputSemanticParseError::UnexpectedSourceRef {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_GCODE_OUTPUT_SOURCE_REF)
}

fn parse_semantic_fixture_path(
    value: &str,
    line_number: usize,
) -> Result<&'static str, PrusaGcodeOutputSemanticParseError> {
    if value != PRUSA_GCODE_OUTPUT_FIXTURE_PATH {
        return Err(PrusaGcodeOutputSemanticParseError::UnexpectedFixturePath {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_GCODE_OUTPUT_FIXTURE_PATH)
}

fn parse_semantic_field(
    value: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputSemanticField, PrusaGcodeOutputSemanticParseError> {
    match value {
        "source_ref" => Ok(PrusaGcodeOutputSemanticField::SourceRef),
        "fixture_id" => Ok(PrusaGcodeOutputSemanticField::FixtureId),
        "fixture_path" => Ok(PrusaGcodeOutputSemanticField::FixturePath),
        "command_class_counts" => Ok(PrusaGcodeOutputSemanticField::CommandClassCounts),
        "movement_class_counts" => Ok(PrusaGcodeOutputSemanticField::MovementClassCounts),
        "coordinate_bounds" => Ok(PrusaGcodeOutputSemanticField::CoordinateBounds),
        "extrusion_total" => Ok(PrusaGcodeOutputSemanticField::ExtrusionTotal),
        "feedrate_observations" => Ok(PrusaGcodeOutputSemanticField::FeedrateObservations),
        "layer_marker_relationships" => Ok(PrusaGcodeOutputSemanticField::LayerMarkerRelationships),
        _ => Err(
            PrusaGcodeOutputSemanticParseError::UnsupportedSemanticField {
                line_number,
                value: value.to_owned(),
            },
        ),
    }
}

fn parse_semantic_category(
    value: &str,
    line_number: usize,
) -> Result<PrusaGcodeOutputSemanticCategory, PrusaGcodeOutputSemanticParseError> {
    match value {
        "source identity" => Ok(PrusaGcodeOutputSemanticCategory::SourceIdentity),
        "fixture identity" => Ok(PrusaGcodeOutputSemanticCategory::FixtureIdentity),
        "command classes" => Ok(PrusaGcodeOutputSemanticCategory::CommandClasses),
        "movement classes" => Ok(PrusaGcodeOutputSemanticCategory::MovementClasses),
        "coordinate bounds" => Ok(PrusaGcodeOutputSemanticCategory::CoordinateBounds),
        "extrusion total" => Ok(PrusaGcodeOutputSemanticCategory::ExtrusionTotal),
        "feedrate observations" => Ok(PrusaGcodeOutputSemanticCategory::FeedrateObservations),
        "layer or marker relationships" => {
            Ok(PrusaGcodeOutputSemanticCategory::LayerMarkerRelationships)
        }
        _ => Err(
            PrusaGcodeOutputSemanticParseError::UnsupportedSemanticCategory {
                line_number,
                value: value.to_owned(),
            },
        ),
    }
}

fn parse_semantic_value(
    value: &str,
    semantic_field: PrusaGcodeOutputSemanticField,
    line_number: usize,
) -> Result<PrusaGcodeOutputSemanticValue, PrusaGcodeOutputSemanticParseError> {
    match semantic_field {
        PrusaGcodeOutputSemanticField::SourceRef => {
            parse_expected_semantic_source_ref_value(value, semantic_field, line_number)
        }
        PrusaGcodeOutputSemanticField::FixtureId => parse_expected_semantic_text_value(
            value,
            semantic_field,
            PRUSA_GCODE_OUTPUT_FIXTURE_ID,
            line_number,
        ),
        PrusaGcodeOutputSemanticField::FixturePath => parse_expected_semantic_text_value(
            value,
            semantic_field,
            PRUSA_GCODE_OUTPUT_FIXTURE_PATH,
            line_number,
        ),
        PrusaGcodeOutputSemanticField::CommandClassCounts => parse_expected_semantic_text_value(
            value,
            semantic_field,
            SEMANTIC_COMMAND_CLASS_COUNTS_VALUE,
            line_number,
        ),
        PrusaGcodeOutputSemanticField::MovementClassCounts => parse_expected_semantic_text_value(
            value,
            semantic_field,
            SEMANTIC_MOVEMENT_CLASS_COUNTS_VALUE,
            line_number,
        ),
        PrusaGcodeOutputSemanticField::CoordinateBounds => parse_expected_semantic_text_value(
            value,
            semantic_field,
            SEMANTIC_COORDINATE_BOUNDS_VALUE,
            line_number,
        ),
        PrusaGcodeOutputSemanticField::ExtrusionTotal => parse_expected_semantic_text_value(
            value,
            semantic_field,
            SEMANTIC_EXTRUSION_TOTAL_VALUE,
            line_number,
        ),
        PrusaGcodeOutputSemanticField::FeedrateObservations => parse_expected_semantic_text_value(
            value,
            semantic_field,
            SEMANTIC_FEEDRATE_OBSERVATIONS_VALUE,
            line_number,
        ),
        PrusaGcodeOutputSemanticField::LayerMarkerRelationships => {
            parse_expected_semantic_text_value(
                value,
                semantic_field,
                SEMANTIC_LAYER_MARKER_RELATIONSHIPS_VALUE,
                line_number,
            )
        }
    }
}

fn parse_expected_semantic_source_ref_value(
    value: &str,
    semantic_field: PrusaGcodeOutputSemanticField,
    line_number: usize,
) -> Result<PrusaGcodeOutputSemanticValue, PrusaGcodeOutputSemanticParseError> {
    if value != PRUSA_GCODE_OUTPUT_SOURCE_REF.as_str() {
        return Err(unexpected_semantic_value_error(
            value,
            semantic_field,
            line_number,
        ));
    }

    Ok(PrusaGcodeOutputSemanticValue::SourceRef(
        PRUSA_GCODE_OUTPUT_SOURCE_REF,
    ))
}

fn parse_expected_semantic_text_value(
    value: &str,
    semantic_field: PrusaGcodeOutputSemanticField,
    expected_value: &'static str,
    line_number: usize,
) -> Result<PrusaGcodeOutputSemanticValue, PrusaGcodeOutputSemanticParseError> {
    if value != expected_value {
        return Err(unexpected_semantic_value_error(
            value,
            semantic_field,
            line_number,
        ));
    }

    Ok(PrusaGcodeOutputSemanticValue::Text(expected_value))
}

fn parse_semantic_evidence_boundary(
    value: &str,
    expected_row: ExpectedGcodeOutputSemanticRow,
    line_number: usize,
) -> Result<PrusaGcodeOutputEvidenceBoundary, PrusaGcodeOutputSemanticParseError> {
    if value != expected_row.evidence_boundary {
        return Err(
            PrusaGcodeOutputSemanticParseError::UnexpectedEvidenceBoundary {
                line_number,
                semantic_field: expected_row.semantic_field,
                value: value.to_owned(),
            },
        );
    }

    Ok(PrusaGcodeOutputEvidenceBoundary(
        expected_row.evidence_boundary,
    ))
}

fn unexpected_semantic_value_error(
    value: &str,
    semantic_field: PrusaGcodeOutputSemanticField,
    line_number: usize,
) -> PrusaGcodeOutputSemanticParseError {
    PrusaGcodeOutputSemanticParseError::UnexpectedSemanticValue {
        line_number,
        semantic_field,
        value: value.to_owned(),
    }
}

fn expected_semantic_row_for_field(
    semantic_field: PrusaGcodeOutputSemanticField,
) -> Option<ExpectedGcodeOutputSemanticRow> {
    EXPECTED_SEMANTIC_ROWS
        .iter()
        .copied()
        .find(|row| row.semantic_field == semantic_field)
}

fn expected_semantic_row_for_key(
    row_key: PrusaGcodeOutputSemanticRowKey,
) -> Option<ExpectedGcodeOutputSemanticRow> {
    expected_semantic_row_for_field(row_key.semantic_field)
}

fn is_expected_semantic_row_key(row_key: PrusaGcodeOutputSemanticRowKey) -> bool {
    expected_semantic_row_for_key(row_key).is_some()
}

fn validate_missing_semantic_rows(
    row_keys: &[PrusaGcodeOutputSemanticRowKey],
) -> Result<(), PrusaGcodeOutputSemanticParseError> {
    for expected_row in EXPECTED_SEMANTIC_ROWS {
        let row_key = PrusaGcodeOutputSemanticRowKey::from_expected(expected_row);
        if !row_keys.contains(&row_key) {
            return Err(PrusaGcodeOutputSemanticParseError::MissingRow {
                semantic_field: expected_row.semantic_field,
            });
        }
    }

    Ok(())
}

fn summary_line(key: &str, value: &str) -> String {
    format!("{key}\t{value}")
}

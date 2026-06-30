#![forbid(unsafe_code)]
//! Pure metadata registry for Slic3r-family flavor planning boundaries.

pub mod prusa_arc_fitting;
pub mod prusa_gcode_output;
pub mod prusa_profile;
pub mod prusa_project_file;
pub mod prusa_wall_seam;
pub mod registry;

pub use prusa_arc_fitting::{
    PrusaArcFittingCategory, PrusaArcFittingEvidenceBoundary, PrusaArcFittingFacts,
    PrusaArcFittingField, PrusaArcFittingMetadata, PrusaArcFittingParseError,
    PrusaArcFittingParseResult, PrusaArcFittingReadiness, PrusaArcFittingSummary,
    PrusaArcFittingSummaryRow, PrusaArcFittingValue, parse_prusa_arc_fitting_summary,
    prusa_arc_fitting_metadata, prusa_arc_fitting_readiness, prusa_arc_fitting_summary_lines,
};
pub use prusa_gcode_output::{
    PrusaGcodeOutputEvidenceBoundary, PrusaGcodeOutputMarkerKey, PrusaGcodeOutputMarkerValue,
    PrusaGcodeOutputMetadata, PrusaGcodeOutputMetadataKey, PrusaGcodeOutputMetadataValue,
    PrusaGcodeOutputNote, PrusaGcodeOutputParseError, PrusaGcodeOutputParseResult,
    PrusaGcodeOutputSemanticCategory, PrusaGcodeOutputSemanticFacts, PrusaGcodeOutputSemanticField,
    PrusaGcodeOutputSemanticParseError, PrusaGcodeOutputSemanticParseResult,
    PrusaGcodeOutputSemanticReadiness, PrusaGcodeOutputSemanticSummary,
    PrusaGcodeOutputSemanticSummaryRow, PrusaGcodeOutputSemanticValue,
    PrusaGcodeOutputStructuralCategory, PrusaGcodeOutputStructuralFacts,
    PrusaGcodeOutputStructuralField, PrusaGcodeOutputStructuralParseError,
    PrusaGcodeOutputStructuralParseResult, PrusaGcodeOutputStructuralReadiness,
    PrusaGcodeOutputStructuralSummary, PrusaGcodeOutputStructuralSummaryRow,
    PrusaGcodeOutputStructuralValue, PrusaGcodeOutputSummary, PrusaGcodeOutputSummaryRow,
    parse_prusa_gcode_output_semantic_summary, parse_prusa_gcode_output_structural_summary,
    parse_prusa_gcode_output_summary, prusa_gcode_output_metadata,
    prusa_gcode_output_semantic_readiness, prusa_gcode_output_semantic_summary_lines,
    prusa_gcode_output_structural_readiness, prusa_gcode_output_structural_summary_lines,
    prusa_gcode_output_summary_lines,
};
pub use prusa_profile::{
    PrusaProfileBundle, PrusaProfileEntry, PrusaProfileKey, PrusaProfileParseError,
    PrusaProfileParseResult, PrusaProfileSchemaMetadata, PrusaProfileSection,
    PrusaProfileSectionKind, PrusaProfileSectionName, PrusaProfileValue,
    parse_prusa_profile_bundle, prusa_profile_schema_metadata, prusa_profile_schema_summary_lines,
};
pub use prusa_project_file::{
    PrusaProjectFileArchiveMember, PrusaProjectFileDeferredSemantics, PrusaProjectFileMarker,
    PrusaProjectFileMetadata, PrusaProjectFileNote, PrusaProjectFileParseError,
    PrusaProjectFileParseResult, PrusaProjectFileSummary, PrusaProjectFileSummaryRow,
    parse_prusa_project_file_summary, prusa_project_file_metadata,
    prusa_project_file_summary_lines,
};
pub use prusa_wall_seam::{
    PrusaWallSeamCategory, PrusaWallSeamEvidenceBoundary, PrusaWallSeamFacts, PrusaWallSeamField,
    PrusaWallSeamParseError, PrusaWallSeamParseResult, PrusaWallSeamSummary,
    PrusaWallSeamSummaryRow, PrusaWallSeamValue, parse_prusa_wall_seam_summary,
    prusa_wall_seam_summary_lines,
};
pub use registry::{
    FlavorCapability, FlavorProvenance, FlavorRegistryEntry, all_capabilities, all_flavors,
    capabilities_by_checklist_status, capabilities_by_origin, maybe_flavor,
};

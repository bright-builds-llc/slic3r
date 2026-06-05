#![forbid(unsafe_code)]
//! Pure metadata registry for Slic3r-family flavor planning boundaries.

pub mod prusa_profile;
pub mod prusa_project_file;
pub mod registry;

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
pub use registry::{
    FlavorCapability, FlavorProvenance, FlavorRegistryEntry, all_capabilities, all_flavors,
    capabilities_by_checklist_status, capabilities_by_origin, maybe_flavor,
};

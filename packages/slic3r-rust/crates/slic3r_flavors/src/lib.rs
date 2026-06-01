#![forbid(unsafe_code)]
//! Pure metadata registry for Slic3r-family flavor planning boundaries.

pub mod prusa_profile;
pub mod registry;

pub use prusa_profile::{
    PrusaProfileBundle, PrusaProfileEntry, PrusaProfileKey, PrusaProfileParseError,
    PrusaProfileSection, PrusaProfileSectionKind, PrusaProfileSectionName, PrusaProfileValue,
    parse_prusa_profile_bundle,
};
pub use registry::{
    FlavorCapability, FlavorProvenance, FlavorRegistryEntry, all_capabilities, all_flavors,
    capabilities_by_checklist_status, capabilities_by_origin, maybe_flavor,
};

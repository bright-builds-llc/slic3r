#![forbid(unsafe_code)]
//! Pure metadata registry for Slic3r-family flavor planning boundaries.

pub mod registry;

pub use registry::{
    FlavorCapability, FlavorProvenance, FlavorRegistryEntry, all_capabilities, all_flavors,
    capabilities_by_checklist_status, capabilities_by_origin, maybe_flavor,
};

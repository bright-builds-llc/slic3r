use crate::prusa_profile::{
    PRUSA_PROFILE_SCHEMA_INVENTORY_ID, PRUSA_PROFILE_SCHEMA_SOURCE_PATH,
    PRUSA_PROFILE_SCHEMA_SOURCE_REF,
};
use crate::prusa_project_file::{
    PRUSA_PROJECT_FILE_INVENTORY_ID, PRUSA_PROJECT_FILE_SOURCE_PATH, PRUSA_PROJECT_FILE_SOURCE_REF,
};
use slic3r_contracts::{ChecklistStatus, FeatureOrigin, FlavorId, ParitySurface, VendorSourceRef};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct FlavorRegistryEntry {
    pub flavor_id: FlavorId,
    pub display_name: &'static str,
    pub capabilities: &'static [FlavorCapability],
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct FlavorCapability {
    pub flavor_id: FlavorId,
    pub capability_id: &'static str,
    pub feature_surface: &'static str,
    pub feature_category: &'static str,
    pub origin: FeatureOrigin,
    pub parity_dependencies: &'static [ParitySurface],
    pub checklist_status: ChecklistStatus,
    pub provenance: &'static [FlavorProvenance],
    pub caution_flags: &'static [&'static str],
    pub future_parity_notes: &'static str,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct FlavorProvenance {
    pub inventory_id: &'static str,
    pub vendor_source: VendorSourceRef,
    pub source_paths: &'static [&'static str],
    pub ownership: FeatureOrigin,
}

static BASE_CORE_PARITY: [ParitySurface; 2] =
    [ParitySurface::cli_version(), ParitySurface::cli_help()];
static FILE_FORMATS_PARITY: [ParitySurface; 1] = [ParitySurface::file_formats()];
static GENERATED_OUTPUTS_PARITY: [ParitySurface; 1] = [ParitySurface::generated_outputs()];
static PRUSA_PROFILE_SCHEMA_PARITY: [ParitySurface; 2] =
    [ParitySurface::config(), ParitySurface::config_persistence()];

static PRUSA_BASE_CORE_PATHS: [&str; 1] = ["src/libslic3r"];
static BAMBU_BASE_CORE_PATHS: [&str; 1] = ["src/libslic3r"];
static ORCA_BASE_CORE_PATHS: [&str; 1] = ["src/libslic3r"];

static BASE_CORE_PROVENANCE: [FlavorProvenance; 3] = [
    FlavorProvenance {
        inventory_id: "prusaslicer.base-core",
        vendor_source: VendorSourceRef::prusa_slicer_version_2_9_5(),
        source_paths: &PRUSA_BASE_CORE_PATHS,
        ownership: FeatureOrigin::BaseSlic3r,
    },
    FlavorProvenance {
        inventory_id: "bambustudio.base-core",
        vendor_source: VendorSourceRef::bambu_studio_v02_06_00_51(),
        source_paths: &BAMBU_BASE_CORE_PATHS,
        ownership: FeatureOrigin::BaseSlic3r,
    },
    FlavorProvenance {
        inventory_id: "orcaslicer.base-core",
        vendor_source: VendorSourceRef::orca_slicer_v2_3_2(),
        source_paths: &ORCA_BASE_CORE_PATHS,
        ownership: FeatureOrigin::BaseSlic3r,
    },
];

static BASE_CAPABILITIES: [FlavorCapability; 1] = [FlavorCapability {
    flavor_id: FlavorId::BaseSlic3r,
    capability_id: "base-core",
    feature_surface: "base-core",
    feature_category: "base-core",
    origin: FeatureOrigin::BaseSlic3r,
    parity_dependencies: &BASE_CORE_PARITY,
    checklist_status: ChecklistStatus::NoActionBase,
    provenance: &BASE_CORE_PROVENANCE,
    caution_flags: &[],
    future_parity_notes: "Base Slic3r core row included to separate inherited base behavior from downstream fork surfaces.",
}];

static PRUSA_PROJECT_FILE_PATHS: [&str; 1] = [PRUSA_PROJECT_FILE_SOURCE_PATH];
static PRUSA_PROJECT_FILE_PROVENANCE: [FlavorProvenance; 1] = [FlavorProvenance {
    inventory_id: PRUSA_PROJECT_FILE_INVENTORY_ID,
    vendor_source: PRUSA_PROJECT_FILE_SOURCE_REF,
    source_paths: &PRUSA_PROJECT_FILE_PATHS,
    ownership: FeatureOrigin::SharedDownstream,
}];

static PRUSA_PROFILE_SCHEMA_PATHS: [&str; 1] = [PRUSA_PROFILE_SCHEMA_SOURCE_PATH];
static PRUSA_PROFILE_SCHEMA_PROVENANCE: [FlavorProvenance; 1] = [FlavorProvenance {
    inventory_id: PRUSA_PROFILE_SCHEMA_INVENTORY_ID,
    vendor_source: PRUSA_PROFILE_SCHEMA_SOURCE_REF,
    source_paths: &PRUSA_PROFILE_SCHEMA_PATHS,
    ownership: FeatureOrigin::ForkSpecific,
}];

static PRUSA_CAPABILITIES: [FlavorCapability; 2] = [
    FlavorCapability {
        flavor_id: FlavorId::PrusaSlicer,
        capability_id: "prusaslicer.project-file",
        feature_surface: "project-file",
        feature_category: "project-file",
        origin: FeatureOrigin::SharedDownstream,
        parity_dependencies: &FILE_FORMATS_PARITY,
        checklist_status: ChecklistStatus::FutureCandidate,
        provenance: &PRUSA_PROJECT_FILE_PROVENANCE,
        caution_flags: &[],
        future_parity_notes: "Source-observed project file planning row; future parity requires fixture-backed load/save evidence.",
    },
    FlavorCapability {
        flavor_id: FlavorId::PrusaSlicer,
        capability_id: "prusaslicer.profile-schema",
        feature_surface: "profile-schema",
        feature_category: "profile-schema",
        origin: FeatureOrigin::ForkSpecific,
        parity_dependencies: &PRUSA_PROFILE_SCHEMA_PARITY,
        checklist_status: ChecklistStatus::FutureCandidate,
        provenance: &PRUSA_PROFILE_SCHEMA_PROVENANCE,
        caution_flags: &[],
        future_parity_notes: "Prusa profile schema planning row; future parity requires loader fixtures and config comparison evidence.",
    },
];

static BAMBU_PROJECT_FILE_PATHS: [&str; 1] = ["src/libslic3r/Format/bbs_3mf.cpp"];
static BAMBU_PROJECT_FILE_PROVENANCE: [FlavorProvenance; 1] = [FlavorProvenance {
    inventory_id: "bambustudio.project-file",
    vendor_source: VendorSourceRef::bambu_studio_v02_06_00_51(),
    source_paths: &BAMBU_PROJECT_FILE_PATHS,
    ownership: FeatureOrigin::ForkSpecific,
}];

static BAMBU_NETWORK_DEVICE_PATHS: [&str; 2] = [
    "src/slic3r/GUI/DeviceCore",
    "src/slic3r/Utils/NetworkAgent.cpp",
];
static BAMBU_NETWORK_DEVICE_FLAGS: [&str; 5] = [
    "network-scope",
    "cloud-scope",
    "credential-scope",
    "non-free-plugin-scope",
    "runtime-parity-not-verified",
];
static BAMBU_NETWORK_DEVICE_PROVENANCE: [FlavorProvenance; 1] = [FlavorProvenance {
    inventory_id: "bambustudio.network-device",
    vendor_source: VendorSourceRef::bambu_studio_v02_06_00_51(),
    source_paths: &BAMBU_NETWORK_DEVICE_PATHS,
    ownership: FeatureOrigin::ForkSpecific,
}];

static BAMBU_CAPABILITIES: [FlavorCapability; 2] = [
    FlavorCapability {
        flavor_id: FlavorId::BambuStudio,
        capability_id: "bambustudio.project-file",
        feature_surface: "project-file",
        feature_category: "project-file",
        origin: FeatureOrigin::ForkSpecific,
        parity_dependencies: &FILE_FORMATS_PARITY,
        checklist_status: ChecklistStatus::FutureCandidate,
        provenance: &BAMBU_PROJECT_FILE_PROVENANCE,
        caution_flags: &[],
        future_parity_notes: "Bambu project file planning row; future parity requires fixture-backed project load/save evidence.",
    },
    FlavorCapability {
        flavor_id: FlavorId::BambuStudio,
        capability_id: "bambustudio.network-device",
        feature_surface: "network-device",
        feature_category: "network-device",
        origin: FeatureOrigin::ForkSpecific,
        parity_dependencies: &[],
        checklist_status: ChecklistStatus::Deferred,
        provenance: &BAMBU_NETWORK_DEVICE_PROVENANCE,
        caution_flags: &BAMBU_NETWORK_DEVICE_FLAGS,
        future_parity_notes: "Inventory only; no cloud login, credential handling, device communication, non-free plugin ingestion, or runtime fork support in v1.9.",
    },
];

static ORCA_CALIBRATION_FLOW_PATHS: [&str; 1] = ["resources/calib"];
static ORCA_CALIBRATION_FLOW_FLAGS: [&str; 2] =
    ["license-provenance", "runtime-parity-not-verified"];
static ORCA_CALIBRATION_FLOW_PROVENANCE: [FlavorProvenance; 1] = [FlavorProvenance {
    inventory_id: "orcaslicer.calibration-flow",
    vendor_source: VendorSourceRef::orca_slicer_v2_3_2(),
    source_paths: &ORCA_CALIBRATION_FLOW_PATHS,
    ownership: FeatureOrigin::ForkSpecific,
}];

static ORCA_CAPABILITIES: [FlavorCapability; 1] = [FlavorCapability {
    flavor_id: FlavorId::OrcaSlicer,
    capability_id: "orcaslicer.calibration-flow",
    feature_surface: "calibration-flow",
    feature_category: "calibration-flow",
    origin: FeatureOrigin::ForkSpecific,
    parity_dependencies: &GENERATED_OUTPUTS_PARITY,
    checklist_status: ChecklistStatus::NeedsReview,
    provenance: &ORCA_CALIBRATION_FLOW_PROVENANCE,
    caution_flags: &ORCA_CALIBRATION_FLOW_FLAGS,
    future_parity_notes: "Inventory only; calibration provenance and output fixtures need review before any parity claim.",
}];

static FLAVOR_REGISTRY: [FlavorRegistryEntry; 4] = [
    FlavorRegistryEntry {
        flavor_id: FlavorId::BaseSlic3r,
        display_name: "Base Slic3r",
        capabilities: &BASE_CAPABILITIES,
    },
    FlavorRegistryEntry {
        flavor_id: FlavorId::PrusaSlicer,
        display_name: "PrusaSlicer",
        capabilities: &PRUSA_CAPABILITIES,
    },
    FlavorRegistryEntry {
        flavor_id: FlavorId::BambuStudio,
        display_name: "Bambu Studio",
        capabilities: &BAMBU_CAPABILITIES,
    },
    FlavorRegistryEntry {
        flavor_id: FlavorId::OrcaSlicer,
        display_name: "OrcaSlicer",
        capabilities: &ORCA_CAPABILITIES,
    },
];

pub fn all_flavors() -> &'static [FlavorRegistryEntry] {
    &FLAVOR_REGISTRY
}

pub fn maybe_flavor(flavor_id: FlavorId) -> Option<&'static FlavorRegistryEntry> {
    FLAVOR_REGISTRY
        .iter()
        .find(|entry| entry.flavor_id == flavor_id)
}

pub fn all_capabilities() -> impl Iterator<Item = &'static FlavorCapability> {
    FLAVOR_REGISTRY
        .iter()
        .flat_map(|entry| entry.capabilities.iter())
}

pub fn capabilities_by_origin(
    origin: FeatureOrigin,
) -> impl Iterator<Item = &'static FlavorCapability> {
    all_capabilities().filter(move |capability| capability.origin == origin)
}

pub fn capabilities_by_checklist_status(
    status: ChecklistStatus,
) -> impl Iterator<Item = &'static FlavorCapability> {
    all_capabilities().filter(move |capability| capability.checklist_status == status)
}

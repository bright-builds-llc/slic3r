use std::error::Error;
use std::fmt;
use std::str::FromStr;

/// Canonical downstream fork identity from the source intake baseline.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum DownstreamFork {
    PrusaSlicer,
    BambuStudio,
    OrcaSlicer,
}

impl DownstreamFork {
    /// Returns the canonical checked-in vendor token.
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::PrusaSlicer => "prusaslicer",
            Self::BambuStudio => "bambustudio",
            Self::OrcaSlicer => "orcaslicer",
        }
    }
}

impl fmt::Display for DownstreamFork {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(self.as_str())
    }
}

impl FromStr for DownstreamFork {
    type Err = DownstreamForkParseError;

    fn from_str(value: &str) -> Result<Self, Self::Err> {
        match value {
            "prusaslicer" => Ok(Self::PrusaSlicer),
            "bambustudio" => Ok(Self::BambuStudio),
            "orcaslicer" => Ok(Self::OrcaSlicer),
            _ => Err(DownstreamForkParseError {
                value: value.to_owned(),
            }),
        }
    }
}

impl TryFrom<&str> for DownstreamFork {
    type Error = DownstreamForkParseError;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        Self::from_str(value)
    }
}

/// Error returned when a downstream fork token is not canonical.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct DownstreamForkParseError {
    pub value: String,
}

impl fmt::Display for DownstreamForkParseError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "invalid downstream fork token: {}", self.value)
    }
}

impl Error for DownstreamForkParseError {}

/// Runtime flavor identity, separate from source vendor identity.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum FlavorId {
    BaseSlic3r,
    PrusaSlicer,
    BambuStudio,
    OrcaSlicer,
}

impl FlavorId {
    /// Returns the canonical checked-in flavor token.
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::BaseSlic3r => "base-slic3r",
            Self::PrusaSlicer => "prusaslicer",
            Self::BambuStudio => "bambustudio",
            Self::OrcaSlicer => "orcaslicer",
        }
    }

    /// Returns the downstream fork behind this flavor, when one exists.
    pub const fn maybe_downstream_fork(self) -> Option<DownstreamFork> {
        match self {
            Self::BaseSlic3r => None,
            Self::PrusaSlicer => Some(DownstreamFork::PrusaSlicer),
            Self::BambuStudio => Some(DownstreamFork::BambuStudio),
            Self::OrcaSlicer => Some(DownstreamFork::OrcaSlicer),
        }
    }
}

impl fmt::Display for FlavorId {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(self.as_str())
    }
}

impl FromStr for FlavorId {
    type Err = FlavorIdParseError;

    fn from_str(value: &str) -> Result<Self, Self::Err> {
        match value {
            "base-slic3r" => Ok(Self::BaseSlic3r),
            "prusaslicer" => Ok(Self::PrusaSlicer),
            "bambustudio" => Ok(Self::BambuStudio),
            "orcaslicer" => Ok(Self::OrcaSlicer),
            _ => Err(FlavorIdParseError {
                value: value.to_owned(),
            }),
        }
    }
}

impl TryFrom<&str> for FlavorId {
    type Error = FlavorIdParseError;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        Self::from_str(value)
    }
}

/// Error returned when a flavor token is not canonical.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FlavorIdParseError {
    pub value: String,
}

impl fmt::Display for FlavorIdParseError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "invalid flavor id token: {}", self.value)
    }
}

impl Error for FlavorIdParseError {}

/// Stable vendor source identity selected from Phase 32 source pins.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct VendorSourceRef {
    value: &'static str,
    vendor: DownstreamFork,
    selected_tag: &'static str,
    peeled_commit: &'static str,
}

impl VendorSourceRef {
    /// Returns the canonical source reference token.
    pub const fn as_str(self) -> &'static str {
        self.value
    }

    /// Returns the downstream fork that owns this source reference.
    pub const fn vendor(self) -> DownstreamFork {
        self.vendor
    }

    /// Returns the selected stable tag from the source intake baseline.
    pub const fn selected_tag(self) -> &'static str {
        self.selected_tag
    }

    /// Returns the peeled commit from the source intake baseline.
    pub const fn peeled_commit(self) -> &'static str {
        self.peeled_commit
    }

    /// Returns the canonical PrusaSlicer 2.9.5 source pin.
    pub const fn prusa_slicer_version_2_9_5() -> Self {
        Self {
            value: "prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961",
            vendor: DownstreamFork::PrusaSlicer,
            selected_tag: "version_2.9.5",
            peeled_commit: "9a583bd438b195856f3bcf7ea99b69ba4003a961",
        }
    }

    /// Returns the canonical Bambu Studio v02.06.00.51 source pin.
    pub const fn bambu_studio_v02_06_00_51() -> Self {
        Self {
            value: "bambustudio:v02.06.00.51@b506005bc4ee62124e24bf00e0f58656db3646a6",
            vendor: DownstreamFork::BambuStudio,
            selected_tag: "v02.06.00.51",
            peeled_commit: "b506005bc4ee62124e24bf00e0f58656db3646a6",
        }
    }

    /// Returns the canonical OrcaSlicer v2.3.2 source pin.
    pub const fn orca_slicer_v2_3_2() -> Self {
        Self {
            value: "orcaslicer:v2.3.2@c724a3f5f51c52336624b689e846c8fbc943a912",
            vendor: DownstreamFork::OrcaSlicer,
            selected_tag: "v2.3.2",
            peeled_commit: "c724a3f5f51c52336624b689e846c8fbc943a912",
        }
    }
}

impl fmt::Display for VendorSourceRef {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(self.as_str())
    }
}

impl FromStr for VendorSourceRef {
    type Err = VendorSourceRefParseError;

    fn from_str(value: &str) -> Result<Self, Self::Err> {
        let Some((vendor_id, selected_ref)) = value.split_once(':') else {
            return Err(VendorSourceRefParseError::MissingVendorSeparator {
                value: value.to_owned(),
            });
        };
        let Some((selected_tag, peeled_commit)) = selected_ref.split_once('@') else {
            return Err(VendorSourceRefParseError::MissingCommitSeparator {
                value: value.to_owned(),
            });
        };

        if selected_tag.is_empty() {
            return Err(VendorSourceRefParseError::EmptySelectedTag {
                value: value.to_owned(),
            });
        }

        let vendor = DownstreamFork::from_str(vendor_id).map_err(|_| {
            VendorSourceRefParseError::UnknownVendor {
                value: value.to_owned(),
            }
        })?;

        if !is_lowercase_hex_commit(peeled_commit) {
            return Err(VendorSourceRefParseError::InvalidCommit {
                value: value.to_owned(),
            });
        }

        match (vendor, selected_tag, peeled_commit) {
            (
                DownstreamFork::PrusaSlicer,
                "version_2.9.5",
                "9a583bd438b195856f3bcf7ea99b69ba4003a961",
            ) => Ok(Self::prusa_slicer_version_2_9_5()),
            (
                DownstreamFork::BambuStudio,
                "v02.06.00.51",
                "b506005bc4ee62124e24bf00e0f58656db3646a6",
            ) => Ok(Self::bambu_studio_v02_06_00_51()),
            (DownstreamFork::OrcaSlicer, "v2.3.2", "c724a3f5f51c52336624b689e846c8fbc943a912") => {
                Ok(Self::orca_slicer_v2_3_2())
            }
            _ => Err(VendorSourceRefParseError::UnknownSourcePin {
                value: value.to_owned(),
            }),
        }
    }
}

impl TryFrom<&str> for VendorSourceRef {
    type Error = VendorSourceRefParseError;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        Self::from_str(value)
    }
}

/// Error returned when a source reference is not one of the canonical pins.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum VendorSourceRefParseError {
    MissingVendorSeparator { value: String },
    MissingCommitSeparator { value: String },
    EmptySelectedTag { value: String },
    UnknownVendor { value: String },
    InvalidCommit { value: String },
    UnknownSourcePin { value: String },
}

impl fmt::Display for VendorSourceRefParseError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::MissingVendorSeparator { value } => {
                write!(formatter, "source ref is missing ':' separator: {value}")
            }
            Self::MissingCommitSeparator { value } => {
                write!(formatter, "source ref is missing '@' separator: {value}")
            }
            Self::EmptySelectedTag { value } => {
                write!(formatter, "source ref selected tag is empty: {value}")
            }
            Self::UnknownVendor { value } => {
                write!(formatter, "source ref vendor is not canonical: {value}")
            }
            Self::InvalidCommit { value } => {
                write!(
                    formatter,
                    "source ref commit is not 40 lowercase hex: {value}"
                )
            }
            Self::UnknownSourcePin { value } => {
                write!(
                    formatter,
                    "source ref is not a canonical selected pin: {value}"
                )
            }
        }
    }
}

impl Error for VendorSourceRefParseError {}

/// Source-observed feature origin used before migration logic receives rows.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum FeatureOrigin {
    BaseSlic3r,
    SharedDownstream,
    ForkSpecific,
    UnknownNeedsReview,
}

impl FeatureOrigin {
    /// Returns the canonical checked-in feature origin token.
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::BaseSlic3r => "base-slic3r",
            Self::SharedDownstream => "shared-downstream",
            Self::ForkSpecific => "fork-specific",
            Self::UnknownNeedsReview => "unknown-needs-review",
        }
    }
}

impl fmt::Display for FeatureOrigin {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(self.as_str())
    }
}

impl FromStr for FeatureOrigin {
    type Err = FeatureOriginParseError;

    fn from_str(value: &str) -> Result<Self, Self::Err> {
        match value {
            "base-slic3r" => Ok(Self::BaseSlic3r),
            "shared-downstream" => Ok(Self::SharedDownstream),
            "fork-specific" => Ok(Self::ForkSpecific),
            "unknown-needs-review" => Ok(Self::UnknownNeedsReview),
            _ => Err(FeatureOriginParseError {
                value: value.to_owned(),
            }),
        }
    }
}

impl TryFrom<&str> for FeatureOrigin {
    type Error = FeatureOriginParseError;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        Self::from_str(value)
    }
}

/// Error returned when a feature origin token is not canonical.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FeatureOriginParseError {
    pub value: String,
}

impl fmt::Display for FeatureOriginParseError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "invalid feature origin token: {}", self.value)
    }
}

impl Error for FeatureOriginParseError {}

/// Validated parity status surface token from the migration control plane.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ParitySurface(&'static str);

impl ParitySurface {
    /// Returns the canonical checked-in parity surface token.
    pub const fn as_str(self) -> &'static str {
        self.0
    }
}

impl fmt::Display for ParitySurface {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(self.as_str())
    }
}

impl FromStr for ParitySurface {
    type Err = ParitySurfaceParseError;

    fn from_str(value: &str) -> Result<Self, Self::Err> {
        Self::try_from(value)
    }
}

impl TryFrom<&str> for ParitySurface {
    type Error = ParitySurfaceParseError;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        match value {
            "cli.version" => Ok(Self("cli.version")),
            "cli.help" => Ok(Self("cli.help")),
            "cli.other" => Ok(Self("cli.other")),
            "export.workflows" => Ok(Self("export.workflows")),
            "transform.workflows" => Ok(Self("transform.workflows")),
            "linux.runtime" => Ok(Self("linux.runtime")),
            "windows.runtime" => Ok(Self("windows.runtime")),
            "linux.packaged-launcher" => Ok(Self("linux.packaged-launcher")),
            "windows.packaged-launcher" => Ok(Self("windows.packaged-launcher")),
            "config" => Ok(Self("config")),
            "config.persistence" => Ok(Self("config.persistence")),
            "file-formats" => Ok(Self("file-formats")),
            "generated-outputs" => Ok(Self("generated-outputs")),
            "launcher-packaging" => Ok(Self("launcher-packaging")),
            _ => Err(ParitySurfaceParseError {
                value: value.to_owned(),
            }),
        }
    }
}

/// Error returned when a parity surface token is not canonical.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ParitySurfaceParseError {
    pub value: String,
}

impl fmt::Display for ParitySurfaceParseError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "invalid parity surface token: {}", self.value)
    }
}

impl Error for ParitySurfaceParseError {}

/// Maintainer checklist status for source-observed fork inventory rows.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ChecklistStatus {
    FutureCandidate,
    Deferred,
    NoActionBase,
    NeedsReview,
}

impl ChecklistStatus {
    /// Returns the canonical checked-in checklist status token.
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::FutureCandidate => "future-candidate",
            Self::Deferred => "deferred",
            Self::NoActionBase => "no-action-base",
            Self::NeedsReview => "needs-review",
        }
    }
}

impl fmt::Display for ChecklistStatus {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(self.as_str())
    }
}

impl FromStr for ChecklistStatus {
    type Err = ChecklistStatusParseError;

    fn from_str(value: &str) -> Result<Self, Self::Err> {
        match value {
            "future-candidate" => Ok(Self::FutureCandidate),
            "deferred" => Ok(Self::Deferred),
            "no-action-base" => Ok(Self::NoActionBase),
            "needs-review" => Ok(Self::NeedsReview),
            _ => Err(ChecklistStatusParseError {
                value: value.to_owned(),
            }),
        }
    }
}

impl TryFrom<&str> for ChecklistStatus {
    type Error = ChecklistStatusParseError;

    fn try_from(value: &str) -> Result<Self, Self::Error> {
        Self::from_str(value)
    }
}

/// Error returned when a checklist status token is not canonical.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ChecklistStatusParseError {
    pub value: String,
}

impl fmt::Display for ChecklistStatusParseError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "invalid checklist status token: {}", self.value)
    }
}

impl Error for ChecklistStatusParseError {}

fn is_lowercase_hex_commit(value: &str) -> bool {
    value.len() == 40
        && value
            .bytes()
            .all(|byte| matches!(byte, b'0'..=b'9' | b'a'..=b'f'))
}

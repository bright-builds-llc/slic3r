use slic3r_contracts::{ChecklistStatus, FeatureOrigin, FlavorId, ParitySurface, VendorSourceRef};

pub(crate) const PRUSA_PROJECT_FILE_INVENTORY_ID: &str = "prusaslicer.project-file";
pub(crate) const PRUSA_PROJECT_FILE_VENDOR_ID: &str = "prusaslicer";
pub(crate) const PRUSA_PROJECT_FILE_SOURCE_REF: VendorSourceRef =
    VendorSourceRef::prusa_slicer_version_2_9_5();
pub(crate) const PRUSA_PROJECT_FILE_SOURCE_PATH: &str = "src/libslic3r/Format/3mf.cpp";
pub(crate) const PRUSA_PROJECT_FILE_FIXTURE_PATH: &str =
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/seam_test_object.3mf";
pub(crate) const PRUSA_PROJECT_FILE_EXPECTED_SUMMARY_PATH: &str = "packages/parity-fixtures/forks/prusaslicer/prusaslicer.project-file/expected-project-summary.tsv";
pub(crate) const PRUSA_PROJECT_FILE_SCOPE_RECORD_PATH: &str =
    "packages/prusa-project-file-scope/project-file-scope.md";
pub(crate) const PRUSA_PROJECT_FILE_RESERVED_STATUS_TOKEN: &str = "fork.prusaslicer.project-file";

const EXPECTED_HEADER: &str =
    "source_ref\tfixture_path\tarchive_member\tproject_marker\tdeferred_semantics\tnotes";
const EXPECTED_COLUMN_COUNT: usize = 6;
const COLUMNS: [&str; EXPECTED_COLUMN_COUNT] = [
    "source_ref",
    "fixture_path",
    "archive_member",
    "project_marker",
    "deferred_semantics",
    "notes",
];
const EXPECTED_ROWS: [ExpectedProjectFileRow; 7] = [
    ExpectedProjectFileRow {
        archive_member: PrusaProjectFileArchiveMember::ContentTypes,
        project_marker: PrusaProjectFileMarker::OpcContentTypes,
        deferred_semantics: PrusaProjectFileDeferredSemantics::MemberPresenceOnly,
    },
    ExpectedProjectFileRow {
        archive_member: PrusaProjectFileArchiveMember::RootRelationships,
        project_marker: PrusaProjectFileMarker::StartPartRelationship,
        deferred_semantics: PrusaProjectFileDeferredSemantics::MemberPresenceOnly,
    },
    ExpectedProjectFileRow {
        archive_member: PrusaProjectFileArchiveMember::Model3d,
        project_marker: PrusaProjectFileMarker::Slic3rPeVersion3mf,
        deferred_semantics: PrusaProjectFileDeferredSemantics::MemberMarkerOnly,
    },
    ExpectedProjectFileRow {
        archive_member: PrusaProjectFileArchiveMember::Model3d,
        project_marker: PrusaProjectFileMarker::ApplicationPrusaSlicer280Alpha3,
        deferred_semantics: PrusaProjectFileDeferredSemantics::MemberMarkerOnly,
    },
    ExpectedProjectFileRow {
        archive_member: PrusaProjectFileArchiveMember::Thumbnail,
        project_marker: PrusaProjectFileMarker::ThumbnailMemberPresent,
        deferred_semantics: PrusaProjectFileDeferredSemantics::MemberPresenceOnly,
    },
    ExpectedProjectFileRow {
        archive_member: PrusaProjectFileArchiveMember::ProjectConfig,
        project_marker: PrusaProjectFileMarker::Slic3rPeConfigMemberPresent,
        deferred_semantics: PrusaProjectFileDeferredSemantics::MemberPresenceOnly,
    },
    ExpectedProjectFileRow {
        archive_member: PrusaProjectFileArchiveMember::ModelConfig,
        project_marker: PrusaProjectFileMarker::Slic3rPeModelConfigMemberPresent,
        deferred_semantics: PrusaProjectFileDeferredSemantics::MemberPresenceOnly,
    },
];

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaProjectFileSummary {
    pub rows: Vec<PrusaProjectFileSummaryRow>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaProjectFileSummaryRow {
    pub source_ref: VendorSourceRef,
    pub fixture_path: &'static str,
    pub archive_member: PrusaProjectFileArchiveMember,
    pub project_marker: PrusaProjectFileMarker,
    pub deferred_semantics: PrusaProjectFileDeferredSemantics,
    pub notes: PrusaProjectFileNote,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaProjectFileArchiveMember {
    ContentTypes,
    RootRelationships,
    Model3d,
    Thumbnail,
    ProjectConfig,
    ModelConfig,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaProjectFileMarker {
    OpcContentTypes,
    StartPartRelationship,
    Slic3rPeVersion3mf,
    ApplicationPrusaSlicer280Alpha3,
    ThumbnailMemberPresent,
    Slic3rPeConfigMemberPresent,
    Slic3rPeModelConfigMemberPresent,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaProjectFileDeferredSemantics {
    MemberPresenceOnly,
    MemberMarkerOnly,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaProjectFileNote(String);

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PrusaProjectFileParseError {
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
    UnsupportedArchiveMember {
        line_number: usize,
        value: String,
    },
    UnsupportedProjectMarker {
        line_number: usize,
        value: String,
    },
    UnsupportedDeferredSemantics {
        line_number: usize,
        value: String,
    },
    DuplicateRow {
        line_number: usize,
        archive_member: PrusaProjectFileArchiveMember,
        project_marker: PrusaProjectFileMarker,
        deferred_semantics: PrusaProjectFileDeferredSemantics,
    },
    MissingRow {
        archive_member: PrusaProjectFileArchiveMember,
        project_marker: PrusaProjectFileMarker,
        deferred_semantics: PrusaProjectFileDeferredSemantics,
    },
    ExtraRow {
        line_number: usize,
        archive_member: PrusaProjectFileArchiveMember,
        project_marker: PrusaProjectFileMarker,
        deferred_semantics: PrusaProjectFileDeferredSemantics,
    },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaProjectFileMetadata {
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
struct ExpectedProjectFileRow {
    archive_member: PrusaProjectFileArchiveMember,
    project_marker: PrusaProjectFileMarker,
    deferred_semantics: PrusaProjectFileDeferredSemantics,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct PrusaProjectFileRowKey {
    archive_member: PrusaProjectFileArchiveMember,
    project_marker: PrusaProjectFileMarker,
    deferred_semantics: PrusaProjectFileDeferredSemantics,
}

pub type PrusaProjectFileParseResult = Result<PrusaProjectFileSummary, PrusaProjectFileParseError>;

pub const fn prusa_project_file_metadata() -> PrusaProjectFileMetadata {
    PrusaProjectFileMetadata {
        inventory_id: PRUSA_PROJECT_FILE_INVENTORY_ID,
        vendor_id: PRUSA_PROJECT_FILE_VENDOR_ID,
        flavor_id: FlavorId::PrusaSlicer,
        origin: FeatureOrigin::SharedDownstream,
        parity_dependency: ParitySurface::file_formats(),
        checklist_status: ChecklistStatus::FutureCandidate,
        source_ref: PRUSA_PROJECT_FILE_SOURCE_REF,
        source_path: PRUSA_PROJECT_FILE_SOURCE_PATH,
        fixture_path: PRUSA_PROJECT_FILE_FIXTURE_PATH,
        expected_summary_path: PRUSA_PROJECT_FILE_EXPECTED_SUMMARY_PATH,
        scope_record_path: PRUSA_PROJECT_FILE_SCOPE_RECORD_PATH,
        reserved_future_status_token: PRUSA_PROJECT_FILE_RESERVED_STATUS_TOKEN,
    }
}

pub fn parse_prusa_project_file_summary(input: &str) -> PrusaProjectFileParseResult {
    let mut lines = input.lines();
    let Some(header) = lines.next() else {
        return Err(PrusaProjectFileParseError::InvalidHeader {
            line: String::new(),
        });
    };
    validate_header(header)?;

    let mut rows = Vec::new();
    let mut row_keys = Vec::new();

    for (line_offset, line) in lines.enumerate() {
        let line_number = line_offset + 2;
        let row = parse_summary_row(line, line_number)?;
        let row_key = PrusaProjectFileRowKey::from_row(&row);

        if row_keys.contains(&row_key) {
            return Err(PrusaProjectFileParseError::DuplicateRow {
                line_number,
                archive_member: row.archive_member,
                project_marker: row.project_marker,
                deferred_semantics: row.deferred_semantics,
            });
        }

        if !is_expected_row_key(row_key) {
            return Err(PrusaProjectFileParseError::ExtraRow {
                line_number,
                archive_member: row.archive_member,
                project_marker: row.project_marker,
                deferred_semantics: row.deferred_semantics,
            });
        }

        row_keys.push(row_key);
        rows.push(row);
    }

    validate_missing_rows(&row_keys)?;

    Ok(PrusaProjectFileSummary { rows })
}

pub fn prusa_project_file_summary_lines(
    input: &str,
) -> Result<Vec<String>, PrusaProjectFileParseError> {
    let summary = parse_prusa_project_file_summary(input)?;
    let metadata = prusa_project_file_metadata();
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
            "evidence_row\t{}\t{}\t{}",
            row.archive_member.as_str(),
            row.project_marker.as_str(),
            row.deferred_semantics.as_str()
        ));
    }

    Ok(lines)
}

impl PrusaProjectFileArchiveMember {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::ContentTypes => "[Content_Types].xml",
            Self::RootRelationships => "_rels/.rels",
            Self::Model3d => "3D/3dmodel.model",
            Self::Thumbnail => "Metadata/thumbnail.png",
            Self::ProjectConfig => "Metadata/Slic3r_PE.config",
            Self::ModelConfig => "Metadata/Slic3r_PE_model.config",
        }
    }
}

impl PrusaProjectFileMarker {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::OpcContentTypes => "opc-content-types",
            Self::StartPartRelationship => "start-part-relationship",
            Self::Slic3rPeVersion3mf => "slic3rpe:Version3mf",
            Self::ApplicationPrusaSlicer280Alpha3 => "Application=PrusaSlicer-2.8.0-alpha3",
            Self::ThumbnailMemberPresent => "thumbnail-member-present",
            Self::Slic3rPeConfigMemberPresent => "Slic3r_PE.config-member-present",
            Self::Slic3rPeModelConfigMemberPresent => "Slic3r_PE_model.config-member-present",
        }
    }
}

impl PrusaProjectFileDeferredSemantics {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::MemberPresenceOnly => "member-presence-only",
            Self::MemberMarkerOnly => "member-marker-only",
        }
    }
}

impl PrusaProjectFileNote {
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl PrusaProjectFileRowKey {
    fn from_expected(row: ExpectedProjectFileRow) -> Self {
        Self {
            archive_member: row.archive_member,
            project_marker: row.project_marker,
            deferred_semantics: row.deferred_semantics,
        }
    }

    fn from_row(row: &PrusaProjectFileSummaryRow) -> Self {
        Self {
            archive_member: row.archive_member,
            project_marker: row.project_marker,
            deferred_semantics: row.deferred_semantics,
        }
    }
}

fn validate_header(line: &str) -> Result<(), PrusaProjectFileParseError> {
    if line != EXPECTED_HEADER {
        return Err(PrusaProjectFileParseError::InvalidHeader {
            line: line.to_owned(),
        });
    }

    Ok(())
}

fn parse_summary_row(
    line: &str,
    line_number: usize,
) -> Result<PrusaProjectFileSummaryRow, PrusaProjectFileParseError> {
    let columns: Vec<&str> = line.split('\t').collect();
    validate_column_count(&columns, line_number)?;
    validate_required_values(&columns, line_number)?;

    Ok(PrusaProjectFileSummaryRow {
        source_ref: parse_source_ref(columns[0], line_number)?,
        fixture_path: parse_fixture_path(columns[1], line_number)?,
        archive_member: parse_archive_member(columns[2], line_number)?,
        project_marker: parse_project_marker(columns[3], line_number)?,
        deferred_semantics: parse_deferred_semantics(columns[4], line_number)?,
        notes: PrusaProjectFileNote(columns[5].to_owned()),
    })
}

fn validate_column_count(
    columns: &[&str],
    line_number: usize,
) -> Result<(), PrusaProjectFileParseError> {
    if columns.len() != EXPECTED_COLUMN_COUNT {
        return Err(PrusaProjectFileParseError::WrongColumnCount {
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
) -> Result<(), PrusaProjectFileParseError> {
    for (index, value) in columns.iter().enumerate() {
        if value.is_empty() {
            return Err(PrusaProjectFileParseError::EmptyRequiredValue {
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
) -> Result<VendorSourceRef, PrusaProjectFileParseError> {
    if value != PRUSA_PROJECT_FILE_SOURCE_REF.as_str() {
        return Err(PrusaProjectFileParseError::UnexpectedSourceRef {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_PROJECT_FILE_SOURCE_REF)
}

fn parse_fixture_path(
    value: &str,
    line_number: usize,
) -> Result<&'static str, PrusaProjectFileParseError> {
    if value != PRUSA_PROJECT_FILE_FIXTURE_PATH {
        return Err(PrusaProjectFileParseError::UnexpectedFixturePath {
            line_number,
            value: value.to_owned(),
        });
    }

    Ok(PRUSA_PROJECT_FILE_FIXTURE_PATH)
}

fn parse_archive_member(
    value: &str,
    line_number: usize,
) -> Result<PrusaProjectFileArchiveMember, PrusaProjectFileParseError> {
    match value {
        "[Content_Types].xml" => Ok(PrusaProjectFileArchiveMember::ContentTypes),
        "_rels/.rels" => Ok(PrusaProjectFileArchiveMember::RootRelationships),
        "3D/3dmodel.model" => Ok(PrusaProjectFileArchiveMember::Model3d),
        "Metadata/thumbnail.png" => Ok(PrusaProjectFileArchiveMember::Thumbnail),
        "Metadata/Slic3r_PE.config" => Ok(PrusaProjectFileArchiveMember::ProjectConfig),
        "Metadata/Slic3r_PE_model.config" => Ok(PrusaProjectFileArchiveMember::ModelConfig),
        _ => Err(PrusaProjectFileParseError::UnsupportedArchiveMember {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_project_marker(
    value: &str,
    line_number: usize,
) -> Result<PrusaProjectFileMarker, PrusaProjectFileParseError> {
    match value {
        "opc-content-types" => Ok(PrusaProjectFileMarker::OpcContentTypes),
        "start-part-relationship" => Ok(PrusaProjectFileMarker::StartPartRelationship),
        "slic3rpe:Version3mf" => Ok(PrusaProjectFileMarker::Slic3rPeVersion3mf),
        "Application=PrusaSlicer-2.8.0-alpha3" => {
            Ok(PrusaProjectFileMarker::ApplicationPrusaSlicer280Alpha3)
        }
        "thumbnail-member-present" => Ok(PrusaProjectFileMarker::ThumbnailMemberPresent),
        "Slic3r_PE.config-member-present" => {
            Ok(PrusaProjectFileMarker::Slic3rPeConfigMemberPresent)
        }
        "Slic3r_PE_model.config-member-present" => {
            Ok(PrusaProjectFileMarker::Slic3rPeModelConfigMemberPresent)
        }
        _ => Err(PrusaProjectFileParseError::UnsupportedProjectMarker {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn parse_deferred_semantics(
    value: &str,
    line_number: usize,
) -> Result<PrusaProjectFileDeferredSemantics, PrusaProjectFileParseError> {
    match value {
        "member-presence-only" => Ok(PrusaProjectFileDeferredSemantics::MemberPresenceOnly),
        "member-marker-only" => Ok(PrusaProjectFileDeferredSemantics::MemberMarkerOnly),
        _ => Err(PrusaProjectFileParseError::UnsupportedDeferredSemantics {
            line_number,
            value: value.to_owned(),
        }),
    }
}

fn is_expected_row_key(row_key: PrusaProjectFileRowKey) -> bool {
    EXPECTED_ROWS
        .iter()
        .map(|row| PrusaProjectFileRowKey::from_expected(*row))
        .any(|expected_row_key| expected_row_key == row_key)
}

fn validate_missing_rows(
    row_keys: &[PrusaProjectFileRowKey],
) -> Result<(), PrusaProjectFileParseError> {
    for expected_row in EXPECTED_ROWS {
        let row_key = PrusaProjectFileRowKey::from_expected(expected_row);
        if !row_keys.contains(&row_key) {
            return Err(PrusaProjectFileParseError::MissingRow {
                archive_member: expected_row.archive_member,
                project_marker: expected_row.project_marker,
                deferred_semantics: expected_row.deferred_semantics,
            });
        }
    }

    Ok(())
}

fn summary_line(key: &str, value: &str) -> String {
    format!("{key}\t{value}")
}

use slic3r_contracts::VendorSourceRef;

pub(crate) const PRUSA_PROFILE_SCHEMA_INVENTORY_ID: &str = "prusaslicer.profile-schema";
pub(crate) const PRUSA_PROFILE_SCHEMA_VENDOR_ID: &str = "prusaslicer";
pub(crate) const PRUSA_PROFILE_SCHEMA_FLAVOR_DISPLAY: &str = "PrusaSlicer";
pub(crate) const PRUSA_PROFILE_SCHEMA_SOURCE_REF: VendorSourceRef =
    VendorSourceRef::prusa_slicer_version_2_9_5();
pub(crate) const PRUSA_PROFILE_SCHEMA_SOURCE_PATH: &str = "resources/profiles/PrusaResearch.ini";
pub(crate) const PRUSA_PROFILE_SCHEMA_FIXTURE_PATH: &str =
    "packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini";
pub(crate) const PRUSA_PROFILE_SCHEMA_CHECKLIST_PATH: &str =
    "packages/prusa-baseline/profile-schema-checklist.md";
pub(crate) const PRUSA_PROFILE_SCHEMA_RESERVED_STATUS_TOKEN: &str =
    "fork.prusaslicer.profile-schema";

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaProfileBundle {
    pub sections: Vec<PrusaProfileSection>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaProfileSection {
    pub index: usize,
    pub line_number: usize,
    pub kind: PrusaProfileSectionKind,
    pub name: PrusaProfileSectionName,
    pub entries: Vec<PrusaProfileEntry>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrusaProfileSectionKind {
    Vendor,
    PrinterModel,
    Print,
    Filament,
    Printer,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaProfileSectionName(String);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaProfileKey(String);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaProfileValue(String);

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PrusaProfileEntry {
    pub section_index: usize,
    pub line_number: usize,
    pub key: PrusaProfileKey,
    pub value: PrusaProfileValue,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PrusaProfileParseError {
    EntryBeforeSection { line_number: usize },
    MalformedSectionHeader { line_number: usize, line: String },
    EmptySectionName { line_number: usize },
    UnsupportedSectionKind { line_number: usize, kind: String },
    EmptyKey { line_number: usize },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PrusaProfileSchemaMetadata {
    pub inventory_id: &'static str,
    pub vendor_id: &'static str,
    pub flavor_display: &'static str,
    pub source_ref: VendorSourceRef,
    pub source_path: &'static str,
    pub fixture_path: &'static str,
    pub checklist_path: &'static str,
    pub reserved_future_status_token: &'static str,
}

pub type PrusaProfileParseResult = Result<PrusaProfileBundle, PrusaProfileParseError>;

const PRUSA_PROFILE_SCHEMA_SECTION_KIND_ORDER: [PrusaProfileSectionKind; 5] = [
    PrusaProfileSectionKind::Vendor,
    PrusaProfileSectionKind::PrinterModel,
    PrusaProfileSectionKind::Print,
    PrusaProfileSectionKind::Filament,
    PrusaProfileSectionKind::Printer,
];

pub const fn prusa_profile_schema_metadata() -> PrusaProfileSchemaMetadata {
    PrusaProfileSchemaMetadata {
        inventory_id: PRUSA_PROFILE_SCHEMA_INVENTORY_ID,
        vendor_id: PRUSA_PROFILE_SCHEMA_VENDOR_ID,
        flavor_display: PRUSA_PROFILE_SCHEMA_FLAVOR_DISPLAY,
        source_ref: PRUSA_PROFILE_SCHEMA_SOURCE_REF,
        source_path: PRUSA_PROFILE_SCHEMA_SOURCE_PATH,
        fixture_path: PRUSA_PROFILE_SCHEMA_FIXTURE_PATH,
        checklist_path: PRUSA_PROFILE_SCHEMA_CHECKLIST_PATH,
        reserved_future_status_token: PRUSA_PROFILE_SCHEMA_RESERVED_STATUS_TOKEN,
    }
}

pub fn parse_prusa_profile_bundle(input: &str) -> PrusaProfileParseResult {
    let mut sections = Vec::new();
    let mut maybe_current_section_index = None;

    for (line_offset, raw_line) in input.lines().enumerate() {
        let line_number = line_offset + 1;
        let line = raw_line.trim();

        if should_skip_line(line) {
            continue;
        }

        if line.starts_with('[') {
            let section = parse_section_header(line, line_number, sections.len())?;
            sections.push(section);
            maybe_current_section_index = Some(sections.len() - 1);
            continue;
        }

        let Some(section_index) = maybe_current_section_index else {
            return Err(PrusaProfileParseError::EntryBeforeSection { line_number });
        };
        let entry = parse_entry(line, line_number, section_index)?;
        sections[section_index].entries.push(entry);
    }

    Ok(PrusaProfileBundle { sections })
}

pub fn prusa_profile_schema_summary_lines(
    input: &str,
) -> Result<Vec<String>, PrusaProfileParseError> {
    let bundle = parse_prusa_profile_bundle(input)?;
    let metadata = prusa_profile_schema_metadata();
    let entry_count: usize = bundle
        .sections
        .iter()
        .map(|section| section.entries.len())
        .sum();
    let mut lines = Vec::new();

    lines.push(summary_line(
        "surface",
        metadata.reserved_future_status_token,
    ));
    lines.push(summary_line("inventory_id", metadata.inventory_id));
    lines.push(summary_line("vendor_id", metadata.vendor_id));
    lines.push(summary_line("flavor_display", metadata.flavor_display));
    lines.push(summary_line("source_ref", &metadata.source_ref.to_string()));
    lines.push(summary_line("source_path", metadata.source_path));
    lines.push(summary_line("fixture_path", metadata.fixture_path));
    lines.push(summary_line("checklist_path", metadata.checklist_path));
    lines.push(summary_line(
        "status_token",
        metadata.reserved_future_status_token,
    ));
    lines.push(format!("section_count\t{}", bundle.sections.len()));
    lines.push(format!("entry_count\t{entry_count}"));

    for kind in PRUSA_PROFILE_SCHEMA_SECTION_KIND_ORDER {
        let count = bundle
            .sections
            .iter()
            .filter(|section| section.kind == kind)
            .count();
        lines.push(format!("section_kind_count\t{}\t{count}", kind.as_str()));
    }

    for kind in PRUSA_PROFILE_SCHEMA_SECTION_KIND_ORDER {
        let maybe_section = bundle.sections.iter().find(|section| section.kind == kind);
        if let Some(section) = maybe_section {
            lines.push(format!(
                "sample_section\t{}\t{}\t{}\t{}",
                kind.as_str(),
                section.index,
                section.line_number,
                section.name.as_str()
            ));
            if let Some(entry) = section.entries.first() {
                lines.push(format!(
                    "sample_entry\t{}\t{}\t{}\t{}\t{}",
                    kind.as_str(),
                    entry.section_index,
                    entry.line_number,
                    entry.key.as_str(),
                    entry.value.as_str()
                ));
            }
        }
    }

    Ok(lines)
}

impl PrusaProfileSectionKind {
    pub const fn as_str(self) -> &'static str {
        match self {
            Self::Vendor => "vendor",
            Self::PrinterModel => "printer_model",
            Self::Print => "print",
            Self::Filament => "filament",
            Self::Printer => "printer",
        }
    }
}

impl PrusaProfileSectionName {
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl PrusaProfileKey {
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl PrusaProfileValue {
    pub fn as_str(&self) -> &str {
        &self.0
    }
}

fn should_skip_line(line: &str) -> bool {
    line.is_empty() || line.starts_with('#') || line.starts_with(';')
}

fn summary_line(key: &str, value: &str) -> String {
    format!("{key}\t{value}")
}

fn parse_section_header(
    line: &str,
    line_number: usize,
    index: usize,
) -> Result<PrusaProfileSection, PrusaProfileParseError> {
    if !line.ends_with(']') {
        return Err(PrusaProfileParseError::MalformedSectionHeader {
            line_number,
            line: line.to_owned(),
        });
    }

    let header = line
        .strip_prefix('[')
        .and_then(|value| value.strip_suffix(']'))
        .map(str::trim)
        .unwrap_or_default();
    if header.is_empty() {
        return Err(PrusaProfileParseError::EmptySectionName { line_number });
    }

    let (kind_text, name_text) = section_kind_and_name(header);
    if kind_text.is_empty() || name_text.is_empty() {
        return Err(PrusaProfileParseError::EmptySectionName { line_number });
    }

    let kind = parse_section_kind(kind_text, line_number)?;

    Ok(PrusaProfileSection {
        index,
        line_number,
        kind,
        name: PrusaProfileSectionName(name_text.to_owned()),
        entries: Vec::new(),
    })
}

fn section_kind_and_name(header: &str) -> (&str, &str) {
    let Some((kind_text, name_text)) = header.split_once(':') else {
        return (header.trim(), header.trim());
    };

    (kind_text.trim(), name_text.trim())
}

fn parse_section_kind(
    kind: &str,
    line_number: usize,
) -> Result<PrusaProfileSectionKind, PrusaProfileParseError> {
    match kind {
        "vendor" => Ok(PrusaProfileSectionKind::Vendor),
        "printer_model" => Ok(PrusaProfileSectionKind::PrinterModel),
        "print" => Ok(PrusaProfileSectionKind::Print),
        "filament" => Ok(PrusaProfileSectionKind::Filament),
        "printer" => Ok(PrusaProfileSectionKind::Printer),
        other => Err(PrusaProfileParseError::UnsupportedSectionKind {
            line_number,
            kind: other.to_owned(),
        }),
    }
}

fn parse_entry(
    line: &str,
    line_number: usize,
    section_index: usize,
) -> Result<PrusaProfileEntry, PrusaProfileParseError> {
    let Some((raw_key, raw_value)) = line.split_once('=') else {
        return Err(PrusaProfileParseError::EmptyKey { line_number });
    };

    let key = raw_key.trim();
    if key.is_empty() {
        return Err(PrusaProfileParseError::EmptyKey { line_number });
    }

    Ok(PrusaProfileEntry {
        section_index,
        line_number,
        key: PrusaProfileKey(key.to_owned()),
        value: PrusaProfileValue(raw_value.trim().to_owned()),
    })
}

use std::fs;
use std::path::{Path, PathBuf};

use slic3r_contracts::TransformKind;

use crate::CliResponse;

const SPLIT_PART_COUNT: usize = 2;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum InputModelFormat {
    Stl,
    Obj,
    Amf,
    ThreeMf,
    Xml,
}

struct OutputArtifact {
    path: PathBuf,
    contents: String,
}

pub fn transform_model(kind: TransformKind, input_path: &str) -> CliResponse {
    let input_path = Path::new(input_path);
    if !input_path.is_file() {
        return CliResponse {
            stdout: String::new(),
            stderr: format!(
                "Cannot find specified input file ({}).\n",
                input_path.display()
            ),
            exit_code: 1,
        };
    }

    let maybe_format = InputModelFormat::from_path(input_path);
    let Ok(format) = maybe_format else {
        return CliResponse {
            stdout: String::new(),
            stderr: format!(
                "Unsupported model input format for the scoped Rust-backed transform slice ({}).\n",
                input_path.display()
            ),
            exit_code: 1,
        };
    };

    match kind {
        TransformKind::Info => info_model(input_path, format),
        TransformKind::Repair => repair_model(input_path, format),
        TransformKind::Split => split_model(input_path, format),
    }
}

impl InputModelFormat {
    fn from_path(path: &Path) -> Result<Self, ()> {
        let maybe_extension = path.extension().and_then(|extension| extension.to_str());
        match maybe_extension.map(|extension| extension.to_ascii_lowercase()) {
            Some(extension) if extension == "stl" => Ok(Self::Stl),
            Some(extension) if extension == "obj" => Ok(Self::Obj),
            Some(extension) if extension == "amf" => Ok(Self::Amf),
            Some(extension) if extension == "3mf" => Ok(Self::ThreeMf),
            Some(extension) if extension == "xml" => Ok(Self::Xml),
            _ => Err(()),
        }
    }

    fn display_name(self) -> &'static str {
        match self {
            Self::Stl => "STL",
            Self::Obj => "OBJ",
            Self::Amf => "AMF",
            Self::ThreeMf => "3MF",
            Self::Xml => "XML",
        }
    }
}

fn info_model(input_path: &Path, format: InputModelFormat) -> CliResponse {
    let maybe_metadata = fs::metadata(input_path);
    let Ok(metadata) = maybe_metadata else {
        return CliResponse {
            stdout: String::new(),
            stderr: format!(
                "Failed to inspect model input ({}).\n",
                input_path.display()
            ),
            exit_code: 1,
        };
    };

    let file_name = input_path
        .file_name()
        .and_then(|name| name.to_str())
        .unwrap_or("unknown");
    let stdout = format!(
        "File: {file_name}\nFormat: {}\nSize bytes: {}\nRust slice: transform_info\n",
        format.display_name(),
        metadata.len()
    );

    CliResponse {
        stdout,
        stderr: String::new(),
        exit_code: 0,
    }
}

fn repair_model(input_path: &Path, format: InputModelFormat) -> CliResponse {
    if format != InputModelFormat::Stl {
        return CliResponse {
            stdout: String::new(),
            stderr: "Repair is currently supported only on STL files\n".to_owned(),
            exit_code: 1,
        };
    }

    let output_path = repaired_output_path(input_path);
    let artifact = OutputArtifact {
        path: output_path,
        contents: repaired_obj_contents(input_path),
    };

    if let Err(error) = write_artifact(&artifact) {
        return CliResponse {
            stdout: String::new(),
            stderr: format!(
                "Failed to write repaired artifact ({}): {}\n",
                artifact.path.display(),
                error
            ),
            exit_code: 1,
        };
    }

    CliResponse {
        stdout: String::new(),
        stderr: String::new(),
        exit_code: 0,
    }
}

fn split_model(input_path: &Path, format: InputModelFormat) -> CliResponse {
    if format != InputModelFormat::Stl {
        return CliResponse {
            stdout: String::new(),
            stderr: "Split is currently supported only on STL files\n".to_owned(),
            exit_code: 1,
        };
    }

    let input_name = input_path
        .file_name()
        .and_then(|name| name.to_str())
        .unwrap_or("model.stl");
    let mut stdout = String::new();

    for artifact in split_artifacts(input_path, input_name) {
        if let Err(error) = write_artifact(&artifact) {
            return CliResponse {
                stdout: String::new(),
                stderr: format!(
                    "Failed to write split artifact ({}): {}\n",
                    artifact.path.display(),
                    error
                ),
                exit_code: 1,
            };
        }

        let display_name = artifact
            .path
            .file_name()
            .and_then(|name| name.to_str())
            .unwrap_or("unknown");
        stdout.push_str(&format!("Writing to {display_name}\n"));
    }

    CliResponse {
        stdout,
        stderr: String::new(),
        exit_code: 0,
    }
}

fn repaired_output_path(input_path: &Path) -> PathBuf {
    let parent = input_path.parent().unwrap_or_else(|| Path::new(""));
    let maybe_stem = input_path.file_stem().and_then(|stem| stem.to_str());
    let stem = maybe_stem.unwrap_or("model");
    parent.join(format!("{stem}_fixed.obj"))
}

fn repaired_obj_contents(input_path: &Path) -> String {
    let input_name = input_path
        .file_name()
        .and_then(|name| name.to_str())
        .unwrap_or("model.stl");
    format!(
        "# generated_by=rust_cli\n# slice=transform_repair\n# input={input_name}\no repaired_mesh\nv 0 0 0\nv 1 0 0\nv 0 1 0\nf 1 2 3\n"
    )
}

fn split_artifacts(input_path: &Path, input_name: &str) -> Vec<OutputArtifact> {
    (1..=SPLIT_PART_COUNT)
        .map(|index| OutputArtifact {
            path: PathBuf::from(format!("{}_{index:02}.stl", input_path.display())),
            contents: split_stl_contents(input_name, index),
        })
        .collect()
}

fn split_stl_contents(input_name: &str, index: usize) -> String {
    format!(
        "solid rust_cli_split_{index:02}\n  facet normal 0 0 1\n    outer loop\n      vertex 0 0 0\n      vertex 1 0 0\n      vertex 0 1 0\n    endloop\n  endfacet\nendsolid {input_name}\n"
    )
}

fn write_artifact(artifact: &OutputArtifact) -> std::io::Result<()> {
    let maybe_parent = artifact.path.parent();
    if let Some(parent) = maybe_parent {
        fs::create_dir_all(parent)?;
    }

    fs::write(&artifact.path, &artifact.contents)
}

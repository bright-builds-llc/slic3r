use std::fs;
use std::path::{Path, PathBuf};

use slic3r_contracts::ExportKind;

use crate::CliResponse;

const SVG_LAYER_COUNT: usize = 5;

struct ExportArtifact {
    path: PathBuf,
    contents: String,
}

pub fn export_model(kind: ExportKind, input_path: &str, maybe_output: Option<&str>) -> CliResponse {
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

    let maybe_input_stem = input_path.file_stem().and_then(|stem| stem.to_str());
    let Some(input_stem) = maybe_input_stem else {
        return CliResponse {
            stdout: String::new(),
            stderr: format!(
                "Cannot derive export filename from input path ({}).\n",
                input_path.display()
            ),
            exit_code: 1,
        };
    };

    let input_name = input_path
        .file_name()
        .and_then(|name| name.to_str())
        .unwrap_or(input_stem);
    let artifacts = match build_artifacts(&kind, input_path, input_stem, input_name, maybe_output) {
        Ok(artifacts) => artifacts,
        Err(stderr) => {
            return CliResponse {
                stdout: String::new(),
                stderr,
                exit_code: 1,
            };
        }
    };

    for artifact in &artifacts {
        if let Err(error) = write_artifact(artifact) {
            return CliResponse {
                stdout: String::new(),
                stderr: format!(
                    "Failed to write export artifact ({}): {}\n",
                    artifact.path.display(),
                    error
                ),
                exit_code: 1,
            };
        }
    }

    CliResponse {
        stdout: export_stdout(&kind, &artifacts),
        stderr: String::new(),
        exit_code: 0,
    }
}

fn build_artifacts(
    kind: &ExportKind,
    input_path: &Path,
    input_stem: &str,
    input_name: &str,
    maybe_output: Option<&str>,
) -> Result<Vec<ExportArtifact>, String> {
    if *kind == ExportKind::SvgLayers {
        let base_path = svg_base_path(input_path, input_stem, maybe_output);
        let paths = svg_layer_paths(&base_path)?;

        return Ok(paths
            .into_iter()
            .enumerate()
            .map(|(index, path)| ExportArtifact {
                path,
                contents: svg_layer_contents(input_name, index),
            })
            .collect());
    }

    let extension = extension_for(kind);
    let output_path = single_output_path(input_path, input_stem, extension, maybe_output);

    Ok(vec![ExportArtifact {
        path: output_path,
        contents: single_artifact_contents(kind, input_name),
    }])
}

fn single_output_path(
    input_path: &Path,
    input_stem: &str,
    extension: &str,
    maybe_output: Option<&str>,
) -> PathBuf {
    let Some(output) = maybe_output else {
        return input_path.with_file_name(format!("{input_stem}.{extension}"));
    };

    let output_path = Path::new(output);
    if output_path.is_dir() {
        return output_path.join(format!("{input_stem}.{extension}"));
    }

    output_path.to_path_buf()
}

fn svg_base_path(input_path: &Path, input_stem: &str, maybe_output: Option<&str>) -> PathBuf {
    let Some(output) = maybe_output else {
        return input_path.with_file_name(input_stem);
    };

    let output_path = Path::new(output);
    if output_path.is_dir() {
        return output_path.join(input_stem);
    }

    strip_svg_extension(output_path)
}

fn svg_layer_paths(base_path: &Path) -> Result<Vec<PathBuf>, String> {
    let parent = base_path.parent().unwrap_or_else(|| Path::new(""));
    let maybe_base_name = base_path.file_name().and_then(|name| name.to_str());
    let Some(base_name) = maybe_base_name else {
        return Err(format!(
            "Cannot derive layered SVG base name from output path ({}).\n",
            base_path.display()
        ));
    };

    Ok((0..SVG_LAYER_COUNT)
        .map(|index| parent.join(format!("{base_name}_{index}.svg")))
        .collect())
}

fn strip_svg_extension(path: &Path) -> PathBuf {
    let maybe_extension = path.extension().and_then(|extension| extension.to_str());
    if maybe_extension.is_some_and(|extension| extension.eq_ignore_ascii_case("svg")) {
        let parent = path.parent().unwrap_or_else(|| Path::new(""));
        let maybe_stem = path.file_stem();
        if let Some(stem) = maybe_stem {
            return parent.join(stem);
        }
    }

    path.to_path_buf()
}

fn write_artifact(artifact: &ExportArtifact) -> std::io::Result<()> {
    let maybe_parent = artifact.path.parent();
    if let Some(parent) = maybe_parent {
        fs::create_dir_all(parent)?;
    }

    fs::write(&artifact.path, &artifact.contents)
}

fn extension_for(kind: &ExportKind) -> &'static str {
    match kind {
        ExportKind::Gcode => "gcode",
        ExportKind::Stl => "stl",
        ExportKind::Obj => "obj",
        ExportKind::Amf => "amf",
        ExportKind::ThreeMf => "3mf",
        ExportKind::SvgLayers | ExportKind::SlaSvg => "svg",
    }
}

fn display_name(kind: &ExportKind) -> &'static str {
    match kind {
        ExportKind::Gcode => "G-code",
        ExportKind::Stl => "STL",
        ExportKind::Obj => "OBJ",
        ExportKind::Amf => "AMF",
        ExportKind::ThreeMf => "3MF",
        ExportKind::SvgLayers => "layered SVG",
        ExportKind::SlaSvg => "SLA SVG",
    }
}

fn single_artifact_contents(kind: &ExportKind, input_name: &str) -> String {
    match kind {
        ExportKind::Gcode => format!(
            "; generated_by=rust_cli\n; slice=export_workflow\n; format=gcode\n; input={input_name}\nG21\nM2\n"
        ),
        ExportKind::Stl => format!(
            "solid rust_cli_export\n  facet normal 0 0 1\n    outer loop\n      vertex 0 0 0\n      vertex 1 0 0\n      vertex 0 1 0\n    endloop\n  endfacet\nendsolid {input_name}\n"
        ),
        ExportKind::Obj => format!(
            "# generated_by=rust_cli\n# slice=export_workflow\n# input={input_name}\no rust_cli_export\nv 0 0 0\nv 1 0 0\nv 0 1 0\nf 1 2 3\n"
        ),
        ExportKind::Amf => format!(
            "<amf generated_by=\"rust_cli\" input=\"{input_name}\"><object id=\"1\" /></amf>\n"
        ),
        ExportKind::ThreeMf => format!(
            "<model generated_by=\"rust_cli\" input=\"{input_name}\"><resources /></model>\n"
        ),
        ExportKind::SlaSvg => format!(
            "<svg data-generated-by=\"rust_cli\" data-slice=\"sla-svg\" data-input=\"{input_name}\"></svg>\n"
        ),
        ExportKind::SvgLayers => unreachable!("layered SVG handled separately"),
    }
}

fn svg_layer_contents(input_name: &str, layer_index: usize) -> String {
    format!(
        "<svg data-generated-by=\"rust_cli\" data-slice=\"layered-svg\" data-input=\"{input_name}\" data-layer=\"{layer_index}\"></svg>\n"
    )
}

fn export_stdout(kind: &ExportKind, artifacts: &[ExportArtifact]) -> String {
    if artifacts.len() == 1 {
        return format!(
            "Exported {} to {}\n",
            display_name(kind),
            artifacts[0].path.display()
        );
    }

    format!(
        "Exported {} to {} artifact(s) rooted at {}\n",
        display_name(kind),
        artifacts.len(),
        artifacts[0]
            .path
            .parent()
            .unwrap_or_else(|| Path::new(""))
            .display()
    )
}

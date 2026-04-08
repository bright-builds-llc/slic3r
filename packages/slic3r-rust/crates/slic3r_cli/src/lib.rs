#![forbid(unsafe_code)]
//! Launcher-facing Rust CLI behavior for the first supported migration slice.

mod export;

use std::fs;
use std::path::{Path, PathBuf};

use slic3r_contracts::{LauncherCommand, parse_invocation};

use crate::export::export_model;

/// Process response for a launcher invocation.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CliResponse {
    pub stdout: String,
    pub stderr: String,
    pub exit_code: u8,
}

/// Executes the currently supported launcher slice for a raw argv payload.
pub fn execute_args(args: &[String]) -> CliResponse {
    let invocation = parse_invocation(args);
    execute_command(invocation.command)
}

fn execute_command(command: LauncherCommand) -> CliResponse {
    if let LauncherCommand::Export {
        kind,
        input_path,
        maybe_output,
    } = command
    {
        return export_model(kind, &input_path, maybe_output.as_deref());
    }

    if let LauncherCommand::SaveConfig {
        path,
        maybe_datadir,
    } = command
    {
        return save_config(&path, maybe_datadir.as_deref());
    }

    if let LauncherCommand::LoadConfig {
        paths,
        maybe_datadir,
    } = command
    {
        return load_config(&paths, maybe_datadir.as_deref());
    }

    if command == LauncherCommand::Help {
        return CliResponse {
            stdout: help_text().to_owned(),
            stderr: String::new(),
            exit_code: 0,
        };
    }

    if command == LauncherCommand::Version {
        return CliResponse {
            stdout: format!("{}\n", slic3r_core::legacy_parity_version()),
            stderr: String::new(),
            exit_code: 0,
        };
    }

    CliResponse {
        stdout: String::new(),
        stderr: "Unsupported Rust-backed CLI slice. The current supported macOS workflows are `--version`, `--help`, `--save`, `--load`, `--datadir`, and the scoped export flags only.\n".to_owned(),
        exit_code: 2,
    }
}

fn help_text() -> &'static str {
    concat!(
        "Slic3r 1.3.1-dev is a STL-to-GCODE translator for RepRap 3D printers\n",
        "written by Alessandro Ranellucci <aar@cpan.org> - https://slic3r.org/\n",
        "\n",
        "Usage: slic3r [ OPTIONS ] [ file.stl ] [ file2.stl ] ...\n",
        "\n",
        "  Rust-backed slices in this milestone:\n",
        "    --help              Output this usage screen and exit\n",
        "    --version           Output the version of Slic3r and exit\n",
        "\n",
        "  Rust-backed export slices in this milestone:\n",
        "    --export-gcode, -g  Export G-code for a supported single input\n",
        "    --export-stl        Export STL for a supported single input\n",
        "    --export-obj        Export OBJ for a supported single input\n",
        "    --export-amf        Export AMF for a supported single input\n",
        "    --export-3mf        Export 3MF for a supported single input\n",
        "    --export-svg        Export layered SVG slices for a supported single input\n",
        "    --export-sla-svg    Export SLA SVG for a supported single input\n",
        "    --sla               Alias for the scoped SLA SVG export\n",
        "    --output <file>     Write the scoped export to the specified file path\n",
        "\n",
        "  Planned next in the Rust-backed path:\n",
        "    --info              Output scoped model information and exit\n",
        "    --repair            Repair supported STL inputs and write a new artifact\n",
        "    --split             Split supported STL inputs into numbered outputs\n",
        "\n",
        "  Rust-backed config persistence in this milestone:\n",
        "    --save <file>       Save configuration to the specified file\n",
        "    --load <file>       Load configuration from the specified file\n",
        "    --datadir <path>    Load and store settings at the given directory\n",
        "\n",
        "  Still legacy-owned in this milestone:\n",
        "    transform, merge/cut/layout, packaged launcher behavior, and output-content parity\n",
    )
}

fn save_config(path: &str, maybe_datadir: Option<&str>) -> CliResponse {
    let resolved_path = resolve_path(path, maybe_datadir);
    let maybe_parent = resolved_path.parent();
    if let Some(parent) = maybe_parent
        && let Err(error) = fs::create_dir_all(parent)
    {
        return io_error(error, "create config directory");
    }

    let contents = "generated_by=rust_cli\nslice=config_persistence\n";
    if let Err(error) = fs::write(&resolved_path, contents) {
        return io_error(error, "write config file");
    }

    CliResponse {
        stdout: format!("Saved config to {}\n", resolved_path.display()),
        stderr: String::new(),
        exit_code: 0,
    }
}

fn load_config(paths: &[String], maybe_datadir: Option<&str>) -> CliResponse {
    let mut combined = String::new();

    for path in paths {
        let resolved_path = resolve_path(path, maybe_datadir);
        let maybe_contents = fs::read_to_string(&resolved_path);
        let Ok(contents) = maybe_contents else {
            return CliResponse {
                stdout: String::new(),
                stderr: format!(
                    "Cannot find specified configuration file ({}).\n",
                    resolved_path.display()
                ),
                exit_code: 1,
            };
        };

        combined.push_str(&format!("# {}\n{}", path, contents));
        if !contents.ends_with('\n') {
            combined.push('\n');
        }
    }

    CliResponse {
        stdout: combined,
        stderr: String::new(),
        exit_code: 0,
    }
}

fn resolve_path(path: &str, maybe_datadir: Option<&str>) -> PathBuf {
    let raw_path = Path::new(path);
    if raw_path.is_absolute() || maybe_datadir.is_none() {
        return raw_path.to_path_buf();
    }

    let datadir = maybe_datadir.expect("datadir checked above");
    Path::new(datadir).join(raw_path)
}

fn io_error(error: std::io::Error, operation: &str) -> CliResponse {
    CliResponse {
        stdout: String::new(),
        stderr: format!("Failed to {}: {}\n", operation, error),
        exit_code: 1,
    }
}

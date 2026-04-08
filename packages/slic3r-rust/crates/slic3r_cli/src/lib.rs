#![forbid(unsafe_code)]
//! Launcher-facing Rust CLI behavior for the first supported migration slice.

use slic3r_contracts::{LauncherCommand, parse_invocation};

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
        stderr: "Unsupported Rust-backed CLI slice. The current supported macOS workflows are `--version` and `--help` only.\n".to_owned(),
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
        "  Planned next in the Rust-backed path:\n",
        "    --save <file>       Save configuration to the specified file\n",
        "    --load <file>       Load configuration from the specified file\n",
        "    --datadir <path>    Load and store settings at the given directory\n",
        "\n",
        "  Still legacy-owned in this milestone:\n",
        "    export, transform, slicing, and packaging-visible behavior\n",
    )
}

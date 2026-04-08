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
    if command == LauncherCommand::Version {
        return CliResponse {
            stdout: format!("{}\n", slic3r_core::legacy_parity_version()),
            stderr: String::new(),
            exit_code: 0,
        };
    }

    CliResponse {
        stdout: String::new(),
        stderr: "Unsupported Rust-backed CLI slice. The current supported macOS workflow is `--version` only.\n".to_owned(),
        exit_code: 2,
    }
}

#![forbid(unsafe_code)]

use std::process::ExitCode;

use slic3r_contracts::{LauncherCommand, parse_invocation};

fn main() -> ExitCode {
    let args = std::env::args().skip(1).collect::<Vec<String>>();
    let invocation = parse_invocation(&args);

    if invocation.command == LauncherCommand::Version {
        eprintln!(
            "Phase 5 only scaffolds the Rust launcher boundary. Phase 6 enables the first supported Rust-backed CLI workflow."
        );
        return ExitCode::from(2);
    }

    eprintln!(
        "The Rust launcher boundary exists, but no user-facing CLI workflow is supported yet. Use the retained legacy path until Phase 6 lands."
    );
    ExitCode::from(2)
}

#![forbid(unsafe_code)]
//! Stable contract-oriented entrypoint types for the staged Rust launcher work.

/// The launcher commands that Phase 5 explicitly models as stable contracts.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum LauncherCommand {
    Version,
    Unsupported,
}

/// Parsed launcher invocation that later phases can route without depending on
/// CLI parsing details.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CliInvocation {
    pub command: LauncherCommand,
    pub raw_args: Vec<String>,
}

/// Parses the externally visible launcher slice that is in scope for the first
/// Rust-backed CLI workflow.
pub fn parse_invocation(args: &[String]) -> CliInvocation {
    let maybe_first_arg = args.first();
    let command = if args.len() == 1 && maybe_first_arg == Some(&"--version".to_owned()) {
        LauncherCommand::Version
    } else {
        LauncherCommand::Unsupported
    };

    CliInvocation {
        command,
        raw_args: args.to_vec(),
    }
}

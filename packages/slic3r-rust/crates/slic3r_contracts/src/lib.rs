#![forbid(unsafe_code)]
//! Stable contract-oriented entrypoint types for the staged Rust launcher work.

/// The launcher commands that Phase 5 explicitly models as stable contracts.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum LauncherCommand {
    SaveConfig {
        path: String,
        maybe_datadir: Option<String>,
    },
    LoadConfig {
        paths: Vec<String>,
        maybe_datadir: Option<String>,
    },
    Help,
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
    let command = parse_command(args);

    CliInvocation {
        command,
        raw_args: args.to_vec(),
    }
}

fn parse_command(args: &[String]) -> LauncherCommand {
    let maybe_first_arg = args.first();
    if args.len() == 1 && maybe_first_arg == Some(&"--help".to_owned()) {
        return LauncherCommand::Help;
    }
    if args.len() == 1 && maybe_first_arg == Some(&"--version".to_owned()) {
        return LauncherCommand::Version;
    }

    let mut maybe_datadir: Option<String> = None;
    let mut maybe_save: Option<String> = None;
    let mut load_paths: Vec<String> = Vec::new();

    let mut index = 0;
    while index < args.len() {
        match args[index].as_str() {
            "--datadir" => {
                let maybe_next = args.get(index + 1);
                let Some(next) = maybe_next else {
                    return LauncherCommand::Unsupported;
                };
                maybe_datadir = Some(next.clone());
                index += 2;
            }
            "--save" => {
                let maybe_next = args.get(index + 1);
                let Some(next) = maybe_next else {
                    return LauncherCommand::Unsupported;
                };
                maybe_save = Some(next.clone());
                index += 2;
            }
            "--load" => {
                let maybe_next = args.get(index + 1);
                let Some(next) = maybe_next else {
                    return LauncherCommand::Unsupported;
                };
                load_paths.push(next.clone());
                index += 2;
            }
            _ => return LauncherCommand::Unsupported,
        }
    }

    if let Some(path) = maybe_save {
        if load_paths.is_empty() {
            return LauncherCommand::SaveConfig {
                path,
                maybe_datadir,
            };
        }
        return LauncherCommand::Unsupported;
    }

    if !load_paths.is_empty() {
        return LauncherCommand::LoadConfig {
            paths: load_paths,
            maybe_datadir,
        };
    }

    LauncherCommand::Unsupported
}

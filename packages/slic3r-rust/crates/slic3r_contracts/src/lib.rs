#![forbid(unsafe_code)]
//! Stable contract-oriented entrypoint types for the staged Rust launcher work.

/// Scoped export workflows that the Rust launcher can own in Phase 12.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ExportKind {
    Gcode,
    Stl,
    Obj,
    Amf,
    ThreeMf,
    SvgLayers,
    SlaSvg,
}

/// Scoped transform and info workflows that the Rust launcher can own in Phase
/// 13.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TransformKind {
    Info,
    Repair,
    Split,
}

/// The launcher commands that Phase 5 explicitly models as stable contracts.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum LauncherCommand {
    Export {
        kind: ExportKind,
        input_path: String,
        maybe_output: Option<String>,
    },
    Transform {
        kind: TransformKind,
        input_path: String,
    },
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
    let mut maybe_output: Option<String> = None;
    let mut maybe_export_kind: Option<ExportKind> = None;
    let mut maybe_transform_kind: Option<TransformKind> = None;
    let mut load_paths: Vec<String> = Vec::new();
    let mut input_paths: Vec<String> = Vec::new();

    let mut index = 0;
    while index < args.len() {
        match args[index].as_str() {
            "--export-gcode" | "-g" => {
                let Some(kind) = set_single_flag(maybe_export_kind.take(), ExportKind::Gcode)
                else {
                    return LauncherCommand::Unsupported;
                };
                maybe_export_kind = Some(kind);
                index += 1;
            }
            "--export-stl" => {
                let Some(kind) = set_single_flag(maybe_export_kind.take(), ExportKind::Stl) else {
                    return LauncherCommand::Unsupported;
                };
                maybe_export_kind = Some(kind);
                index += 1;
            }
            "--export-obj" => {
                let Some(kind) = set_single_flag(maybe_export_kind.take(), ExportKind::Obj) else {
                    return LauncherCommand::Unsupported;
                };
                maybe_export_kind = Some(kind);
                index += 1;
            }
            "--export-amf" => {
                let Some(kind) = set_single_flag(maybe_export_kind.take(), ExportKind::Amf) else {
                    return LauncherCommand::Unsupported;
                };
                maybe_export_kind = Some(kind);
                index += 1;
            }
            "--export-3mf" => {
                let Some(kind) = set_single_flag(maybe_export_kind.take(), ExportKind::ThreeMf)
                else {
                    return LauncherCommand::Unsupported;
                };
                maybe_export_kind = Some(kind);
                index += 1;
            }
            "--export-svg" => {
                let Some(kind) = set_single_flag(maybe_export_kind.take(), ExportKind::SvgLayers)
                else {
                    return LauncherCommand::Unsupported;
                };
                maybe_export_kind = Some(kind);
                index += 1;
            }
            "--export-sla-svg" | "--sla" => {
                let Some(kind) = set_single_flag(maybe_export_kind.take(), ExportKind::SlaSvg)
                else {
                    return LauncherCommand::Unsupported;
                };
                maybe_export_kind = Some(kind);
                index += 1;
            }
            "--info" => {
                let Some(kind) = set_single_flag(maybe_transform_kind.take(), TransformKind::Info)
                else {
                    return LauncherCommand::Unsupported;
                };
                maybe_transform_kind = Some(kind);
                index += 1;
            }
            "--repair" => {
                let Some(kind) =
                    set_single_flag(maybe_transform_kind.take(), TransformKind::Repair)
                else {
                    return LauncherCommand::Unsupported;
                };
                maybe_transform_kind = Some(kind);
                index += 1;
            }
            "--split" => {
                let Some(kind) = set_single_flag(maybe_transform_kind.take(), TransformKind::Split)
                else {
                    return LauncherCommand::Unsupported;
                };
                maybe_transform_kind = Some(kind);
                index += 1;
            }
            "--datadir" => {
                let maybe_next = args.get(index + 1);
                let Some(next) = maybe_next else {
                    return LauncherCommand::Unsupported;
                };
                maybe_datadir = Some(next.clone());
                index += 2;
            }
            "--output" => {
                let maybe_next = args.get(index + 1);
                let Some(next) = maybe_next else {
                    return LauncherCommand::Unsupported;
                };
                maybe_output = Some(next.clone());
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
            arg if arg.starts_with('-') => return LauncherCommand::Unsupported,
            input_path => {
                input_paths.push(input_path.to_owned());
                index += 1;
            }
        }
    }

    if let Some(kind) = maybe_export_kind {
        if maybe_transform_kind.is_some()
            || maybe_datadir.is_some()
            || maybe_save.is_some()
            || !load_paths.is_empty()
        {
            return LauncherCommand::Unsupported;
        }
        if input_paths.len() != 1 {
            return LauncherCommand::Unsupported;
        }

        return LauncherCommand::Export {
            kind,
            input_path: input_paths.remove(0),
            maybe_output,
        };
    }

    if let Some(kind) = maybe_transform_kind {
        if maybe_export_kind.is_some()
            || maybe_datadir.is_some()
            || maybe_save.is_some()
            || maybe_output.is_some()
            || !load_paths.is_empty()
        {
            return LauncherCommand::Unsupported;
        }
        if input_paths.len() != 1 {
            return LauncherCommand::Unsupported;
        }

        return LauncherCommand::Transform {
            kind,
            input_path: input_paths.remove(0),
        };
    }

    if maybe_output.is_some() {
        return LauncherCommand::Unsupported;
    }

    if let Some(path) = maybe_save {
        if load_paths.is_empty() && input_paths.is_empty() {
            return LauncherCommand::SaveConfig {
                path,
                maybe_datadir,
            };
        }
        return LauncherCommand::Unsupported;
    }

    if !load_paths.is_empty() && input_paths.is_empty() {
        return LauncherCommand::LoadConfig {
            paths: load_paths,
            maybe_datadir,
        };
    }

    LauncherCommand::Unsupported
}

fn set_single_flag<T>(maybe_existing: Option<T>, next_kind: T) -> Option<T> {
    if maybe_existing.is_some() {
        return None;
    }

    Some(next_kind)
}

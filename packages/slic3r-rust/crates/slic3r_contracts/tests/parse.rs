use slic3r_contracts::{ExportKind, LauncherCommand, TransformKind, parse_invocation};

#[test]
fn parses_help_invocation() {
    // Arrange
    let args = vec!["--help".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(invocation.command, LauncherCommand::Help);
    assert_eq!(invocation.raw_args, args);
}

#[test]
fn parses_version_invocation() {
    // Arrange
    let args = vec!["--version".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(invocation.command, LauncherCommand::Version);
    assert_eq!(invocation.raw_args, args);
}

#[test]
fn parses_export_gcode_invocation_with_output() {
    // Arrange
    let args = vec![
        "-g".to_owned(),
        "--output".to_owned(),
        "output.gcode".to_owned(),
        "box.stl".to_owned(),
    ];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(
        invocation.command,
        LauncherCommand::Export {
            kind: ExportKind::Gcode,
            input_path: "box.stl".to_owned(),
            maybe_output: Some("output.gcode".to_owned()),
        }
    );
    assert_eq!(invocation.raw_args, args);
}

#[test]
fn parses_export_sla_invocation() {
    // Arrange
    let args = vec!["--sla".to_owned(), "box.stl".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(
        invocation.command,
        LauncherCommand::Export {
            kind: ExportKind::SlaSvg,
            input_path: "box.stl".to_owned(),
            maybe_output: None,
        }
    );
    assert_eq!(invocation.raw_args, args);
}

#[test]
fn parses_info_invocation() {
    // Arrange
    let args = vec!["--info".to_owned(), "box.obj".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(
        invocation.command,
        LauncherCommand::Transform {
            kind: TransformKind::Info,
            input_path: "box.obj".to_owned(),
        }
    );
    assert_eq!(invocation.raw_args, args);
}

#[test]
fn parses_repair_invocation() {
    // Arrange
    let args = vec!["--repair".to_owned(), "box.stl".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(
        invocation.command,
        LauncherCommand::Transform {
            kind: TransformKind::Repair,
            input_path: "box.stl".to_owned(),
        }
    );
    assert_eq!(invocation.raw_args, args);
}

#[test]
fn parses_save_config_invocation() {
    // Arrange
    let args = vec!["--save".to_owned(), "cfg.ini".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(
        invocation.command,
        LauncherCommand::SaveConfig {
            path: "cfg.ini".to_owned(),
            maybe_datadir: None,
        }
    );
}

#[test]
fn parses_load_config_invocation_with_datadir() {
    // Arrange
    let args = vec![
        "--datadir".to_owned(),
        "profiles".to_owned(),
        "--load".to_owned(),
        "base.ini".to_owned(),
        "--load".to_owned(),
        "extra.ini".to_owned(),
    ];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(
        invocation.command,
        LauncherCommand::LoadConfig {
            paths: vec!["base.ini".to_owned(), "extra.ini".to_owned()],
            maybe_datadir: Some("profiles".to_owned()),
        }
    );
}

#[test]
fn marks_transform_with_output_as_unsupported() {
    // Arrange
    let args = vec![
        "--split".to_owned(),
        "--output".to_owned(),
        "out.stl".to_owned(),
        "box.stl".to_owned(),
    ];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(invocation.command, LauncherCommand::Unsupported);
    assert_eq!(invocation.raw_args, args);
}

#[test]
fn marks_export_without_input_as_unsupported() {
    // Arrange
    let args = vec!["--export-obj".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(invocation.command, LauncherCommand::Unsupported);
    assert_eq!(invocation.raw_args, args);
}

#[test]
fn marks_other_invocations_as_unsupported() {
    // Arrange
    let args = vec!["--save".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(invocation.command, LauncherCommand::Unsupported);
    assert_eq!(invocation.raw_args, args);
}

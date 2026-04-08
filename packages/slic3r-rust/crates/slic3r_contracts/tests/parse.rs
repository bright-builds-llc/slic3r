use slic3r_contracts::{LauncherCommand, parse_invocation};

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
fn marks_other_invocations_as_unsupported() {
    // Arrange
    let args = vec!["--save".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(invocation.command, LauncherCommand::Unsupported);
    assert_eq!(invocation.raw_args, args);
}

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
fn marks_other_invocations_as_unsupported() {
    // Arrange
    let args = vec!["--save".to_owned()];

    // Act
    let invocation = parse_invocation(&args);

    // Assert
    assert_eq!(invocation.command, LauncherCommand::Unsupported);
    assert_eq!(invocation.raw_args, args);
}

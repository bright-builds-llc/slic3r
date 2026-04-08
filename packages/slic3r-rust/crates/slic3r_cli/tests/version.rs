use slic3r_cli::execute_args;

#[test]
fn returns_help_text_for_help_slice() {
    // Arrange
    let args = vec!["--help".to_owned()];

    // Act
    let response = execute_args(&args);

    // Assert
    assert!(
        response
            .stdout
            .contains("Usage: slic3r [ OPTIONS ] [ file.stl ] [ file2.stl ] ...")
    );
    assert!(
        response
            .stdout
            .contains("Rust-backed slices in this milestone")
    );
    assert!(response.stdout.contains("--help"));
    assert!(response.stdout.contains("--version"));
    assert_eq!(response.stderr, "");
    assert_eq!(response.exit_code, 0);
}

#[test]
fn returns_legacy_parity_version_for_version_slice() {
    // Arrange
    let args = vec!["--version".to_owned()];

    // Act
    let response = execute_args(&args);

    // Assert
    assert_eq!(response.stdout, "1.3.1-dev\n");
    assert_eq!(response.stderr, "");
    assert_eq!(response.exit_code, 0);
}

#[test]
fn keeps_other_cli_flows_out_of_scope() {
    // Arrange
    let args = vec!["--save".to_owned()];

    // Act
    let response = execute_args(&args);

    // Assert
    assert_eq!(response.stdout, "");
    assert_eq!(
        response.stderr,
        "Unsupported Rust-backed CLI slice. The current supported macOS workflows are `--version` and `--help` only.\n",
    );
    assert_eq!(response.exit_code, 2);
}

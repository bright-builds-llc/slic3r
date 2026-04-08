use slic3r_cli::execute_args;

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
    let args = vec!["--help".to_owned()];

    // Act
    let response = execute_args(&args);

    // Assert
    assert_eq!(response.stdout, "");
    assert_eq!(
        response.stderr,
        "Unsupported Rust-backed CLI slice. The current supported macOS workflow is `--version` only.\n",
    );
    assert_eq!(response.exit_code, 2);
}

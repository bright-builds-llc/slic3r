use slic3r_cli::execute_args;
use std::fs;
use std::path::PathBuf;
use std::time::{SystemTime, UNIX_EPOCH};

fn temp_path(name: &str) -> PathBuf {
    let unique = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("system time")
        .as_nanos();
    std::env::temp_dir().join(format!("slic3r-cli-{unique}-{name}"))
}

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
    let args = vec!["--export-gcode".to_owned()];

    // Act
    let response = execute_args(&args);

    // Assert
    assert_eq!(response.stdout, "");
    assert_eq!(
        response.stderr,
        "Unsupported Rust-backed CLI slice. The current supported macOS workflows are `--version`, `--help`, `--save`, `--load`, and `--datadir` only.\n",
    );
    assert_eq!(response.exit_code, 2);
}

#[test]
fn saves_config_to_requested_path() {
    // Arrange
    let temp_dir = temp_path("save");
    fs::create_dir_all(&temp_dir).expect("create temp dir");
    let output_path = temp_dir.join("cfg.ini");
    let args = vec!["--save".to_owned(), output_path.display().to_string()];

    // Act
    let response = execute_args(&args);
    let contents = fs::read_to_string(&output_path).expect("saved config");

    // Assert
    assert_eq!(response.exit_code, 0);
    assert!(response.stdout.contains("Saved config to"));
    assert_eq!(response.stderr, "");
    assert!(contents.contains("generated_by=rust_cli"));

    fs::remove_dir_all(&temp_dir).expect("remove temp dir");
}

#[test]
fn loads_multiple_configs_from_datadir() {
    // Arrange
    let temp_dir = temp_path("load");
    let datadir = temp_dir.join("profiles");
    fs::create_dir_all(&datadir).expect("create datadir");
    fs::write(datadir.join("base.ini"), "alpha=1\n").expect("write base");
    fs::write(datadir.join("extra.ini"), "beta=2\n").expect("write extra");
    let args = vec![
        "--datadir".to_owned(),
        datadir.display().to_string(),
        "--load".to_owned(),
        "base.ini".to_owned(),
        "--load".to_owned(),
        "extra.ini".to_owned(),
    ];

    // Act
    let response = execute_args(&args);

    // Assert
    assert_eq!(response.exit_code, 0);
    assert!(response.stdout.contains("alpha=1"));
    assert!(response.stdout.contains("beta=2"));
    assert_eq!(response.stderr, "");

    fs::remove_dir_all(&temp_dir).expect("remove temp dir");
}

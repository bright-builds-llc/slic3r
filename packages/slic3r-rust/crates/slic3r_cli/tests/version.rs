use slic3r_cli::execute_args;
use std::fs;
use std::path::{Path, PathBuf};
use std::time::{SystemTime, UNIX_EPOCH};

fn temp_path(name: &str) -> PathBuf {
    let unique = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("system time")
        .as_nanos();
    std::env::temp_dir().join(format!("slic3r-cli-{unique}-{name}"))
}

fn write_model_file(dir: &Path, name: &str) -> PathBuf {
    let model_path = dir.join(name);
    fs::write(
        &model_path,
        "solid rust_cli_input\n  facet normal 0 0 1\n  endfacet\nendsolid rust_cli_input\n",
    )
    .expect("write model file");
    model_path
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
    assert!(response.stdout.contains("--export-gcode"));
    assert!(response.stdout.contains("--output <file>"));
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
    let args = vec!["--repair".to_owned()];

    // Act
    let response = execute_args(&args);

    // Assert
    assert_eq!(response.stdout, "");
    assert_eq!(
        response.stderr,
        "Unsupported Rust-backed CLI slice. The current supported macOS workflows are `--version`, `--help`, `--save`, `--load`, `--datadir`, and the scoped export flags only.\n",
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

#[test]
fn exports_gcode_to_default_output_path() {
    // Arrange
    let temp_dir = temp_path("export-gcode");
    fs::create_dir_all(&temp_dir).expect("create temp dir");
    let input_path = write_model_file(&temp_dir, "box.stl");
    let output_path = temp_dir.join("box.gcode");
    let args = vec![
        "--export-gcode".to_owned(),
        input_path.display().to_string(),
    ];

    // Act
    let response = execute_args(&args);
    let contents = fs::read_to_string(&output_path).expect("read gcode");

    // Assert
    assert_eq!(response.exit_code, 0);
    assert!(response.stdout.contains("Exported G-code"));
    assert_eq!(response.stderr, "");
    assert!(contents.contains("format=gcode"));

    fs::remove_dir_all(&temp_dir).expect("remove temp dir");
}

#[test]
fn exports_stl_to_explicit_output_path() {
    // Arrange
    let temp_dir = temp_path("export-stl");
    fs::create_dir_all(&temp_dir).expect("create temp dir");
    let input_path = write_model_file(&temp_dir, "box.stl");
    let output_path = temp_dir.join("out.stl");
    let args = vec![
        "--export-stl".to_owned(),
        "--output".to_owned(),
        output_path.display().to_string(),
        input_path.display().to_string(),
    ];

    // Act
    let response = execute_args(&args);
    let contents = fs::read_to_string(&output_path).expect("read stl");

    // Assert
    assert_eq!(response.exit_code, 0);
    assert!(
        response
            .stdout
            .contains(output_path.to_string_lossy().as_ref())
    );
    assert_eq!(response.stderr, "");
    assert!(contents.contains("solid rust_cli_export"));

    fs::remove_dir_all(&temp_dir).expect("remove temp dir");
}

#[test]
fn exports_layered_svg_to_numbered_outputs() {
    // Arrange
    let temp_dir = temp_path("export-svg");
    fs::create_dir_all(&temp_dir).expect("create temp dir");
    let input_path = write_model_file(&temp_dir, "box.stl");
    let args = vec!["--export-svg".to_owned(), input_path.display().to_string()];

    // Act
    let response = execute_args(&args);

    // Assert
    assert_eq!(response.exit_code, 0);
    assert_eq!(response.stderr, "");
    for index in 0..5 {
        let layer_path = temp_dir.join(format!("box_{index}.svg"));
        let contents = fs::read_to_string(&layer_path).expect("read svg layer");
        assert!(contents.contains(&format!("data-layer=\"{index}\"")));
    }

    fs::remove_dir_all(&temp_dir).expect("remove temp dir");
}

#[test]
fn exports_sla_svg_to_explicit_output_path() {
    // Arrange
    let temp_dir = temp_path("export-sla");
    fs::create_dir_all(&temp_dir).expect("create temp dir");
    let input_path = write_model_file(&temp_dir, "box.stl");
    let output_path = temp_dir.join("print.svg");
    let args = vec![
        "--sla".to_owned(),
        "--output".to_owned(),
        output_path.display().to_string(),
        input_path.display().to_string(),
    ];

    // Act
    let response = execute_args(&args);
    let contents = fs::read_to_string(&output_path).expect("read sla svg");

    // Assert
    assert_eq!(response.exit_code, 0);
    assert!(response.stdout.contains("SLA SVG"));
    assert_eq!(response.stderr, "");
    assert!(contents.contains("data-slice=\"sla-svg\""));

    fs::remove_dir_all(&temp_dir).expect("remove temp dir");
}

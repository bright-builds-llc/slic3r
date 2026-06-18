#![forbid(unsafe_code)]

use std::{env, ffi::OsStr, fs, path::Path, process::ExitCode};

use slic3r_flavors::{
    prusa_gcode_output_structural_summary_lines, prusa_gcode_output_summary_lines,
};

const USAGE_ERROR: &str =
    "expected expected-gcode-summary.tsv or --structural expected-gcode-structural-summary.tsv";

fn main() -> ExitCode {
    let args: Vec<_> = env::args_os().collect();
    let result = match args.as_slice() {
        [_, fixture_path] => run_summary(fixture_path),
        [_, mode, fixture_path] if mode == OsStr::new("--structural") => {
            run_structural_summary(fixture_path)
        }
        _ => Err(USAGE_ERROR.to_owned()),
    };

    match result {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error}");
            ExitCode::FAILURE
        }
    }
}

fn run_summary(fixture_path: &OsStr) -> Result<(), String> {
    let path = Path::new(fixture_path);
    let input = read_input(path)?;
    let lines = prusa_gcode_output_summary_lines(&input)
        .map_err(|error| format!("failed to summarize {}: {error:?}", path.display()))?;
    print_lines(lines);

    Ok(())
}

fn run_structural_summary(fixture_path: &OsStr) -> Result<(), String> {
    let path = Path::new(fixture_path);
    let input = read_input(path)?;
    let lines = prusa_gcode_output_structural_summary_lines(&input).map_err(|error| {
        format!(
            "failed to summarize structural {}: {error:?}",
            path.display()
        )
    })?;
    print_lines(lines);

    Ok(())
}

fn read_input(path: &Path) -> Result<String, String> {
    fs::read_to_string(path).map_err(|error| format!("failed to read {}: {error}", path.display()))
}

fn print_lines(lines: Vec<String>) {
    for line in lines {
        println!("{line}");
    }
}

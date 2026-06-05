#![forbid(unsafe_code)]

use std::{env, ffi::OsStr, fs, path::Path, process::ExitCode};

use slic3r_flavors::prusa_project_file_summary_lines;

fn main() -> ExitCode {
    let args: Vec<_> = env::args_os().collect();
    if args.len() != 2 {
        eprintln!("error: expected exactly one expected-project-summary.tsv fixture path argument");
        return ExitCode::FAILURE;
    }

    match run(&args[1]) {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error}");
            ExitCode::FAILURE
        }
    }
}

fn run(fixture_path: &OsStr) -> Result<(), String> {
    let path = Path::new(fixture_path);
    let input = fs::read_to_string(path)
        .map_err(|error| format!("failed to read {}: {error}", path.display()))?;
    let lines = prusa_project_file_summary_lines(&input)
        .map_err(|error| format!("failed to summarize {}: {error:?}", path.display()))?;

    for line in lines {
        println!("{line}");
    }

    Ok(())
}

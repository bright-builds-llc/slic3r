#![forbid(unsafe_code)]

use std::process::ExitCode;

use slic3r_cli::execute_args;

fn main() -> ExitCode {
    let args = std::env::args().skip(1).collect::<Vec<String>>();
    let response = execute_args(&args);

    if !response.stdout.is_empty() {
        print!("{}", response.stdout);
    }
    if !response.stderr.is_empty() {
        eprint!("{}", response.stderr);
    }

    ExitCode::from(response.exit_code)
}

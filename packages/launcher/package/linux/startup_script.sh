#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
launcher_path="${script_dir}/slic3r_cli"

if [[ "${1:-}" != "" && "${1}" != -* ]]; then
	launcher_path="${1}"
	shift
fi

exec "${launcher_path}" "$@"

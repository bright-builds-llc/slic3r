#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
status_file="${1:-${script_dir}/status.tsv}"

printf '%-24s %-12s %-32s %s\n' "SURFACE" "STATUS" "EVIDENCE" "NOTES"
printf '%-24s %-12s %-32s %s\n' "-------" "------" "--------" "-----"

while IFS=$'\t' read -r surface status evidence notes; do
	if [[ -z "${surface}" || "${surface}" == \#* ]]; then
		continue
	fi

	printf '%-24s %-12s %-32s %s\n' "${surface}" "${status}" "${evidence}" "${notes}"
done <"${status_file}"

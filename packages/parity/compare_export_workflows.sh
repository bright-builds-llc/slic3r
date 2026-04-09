#!/usr/bin/env bash
set -euo pipefail

repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

rust_launcher="${1}"
model_stl="${2}"

if [[ "${model_stl}" != /* ]]; then
	model_stl="${repo_root}/${model_stl}"
fi

fixture_root="$(cd "$(dirname "${model_stl}")" && pwd)"

if [[ "${rust_launcher}" != /* || ! -x "${rust_launcher}" ]]; then
	rust_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_cli"
fi

temp_root="$(mktemp -d /tmp/slic3r-export-workflows.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT
cp "${model_stl}" "${temp_root}/model.stl"

compare_file() {
	local actual_file="${1}"
	local expected_file="${2}"
	local actual_contents
	local expected_contents
	actual_contents="$(cat "${actual_file}")"
	expected_contents="$(cat "${expected_file}")"

	if [[ "${actual_contents}" != "${expected_contents}" ]]; then
		printf 'fixture mismatch for %s\nexpected:\n%s\nactual:\n%s\n' \
			"${actual_file}" "${expected_contents}" "${actual_contents}" >&2
		exit 1
	fi
}

assert_stdout() {
	local actual="${1}"
	local expected="${2}"
	local label="${3}"

	if [[ "${actual}" != "${expected}" ]]; then
		printf '%s stdout mismatch\nexpected:\n%s\nactual:\n%s\n' \
			"${label}" "${expected}" "${actual}" >&2
		exit 1
	fi
}

gcode_output="${temp_root}/model.gcode"
gcode_stdout="$("${rust_launcher}" --export-gcode "${temp_root}/model.stl")"
assert_stdout "${gcode_stdout}" "Exported G-code to ${gcode_output}" "gcode"
compare_file "${gcode_output}" "${fixture_root}/expected-gcode.txt"

stl_output="${temp_root}/output.stl"
stl_stdout="$("${rust_launcher}" --export-stl --output "${stl_output}" "${temp_root}/model.stl")"
assert_stdout "${stl_stdout}" "Exported STL to ${stl_output}" "stl"
compare_file "${stl_output}" "${fixture_root}/expected-stl.txt"

obj_output="${temp_root}/model.obj"
obj_stdout="$("${rust_launcher}" --export-obj "${temp_root}/model.stl")"
assert_stdout "${obj_stdout}" "Exported OBJ to ${obj_output}" "obj"
compare_file "${obj_output}" "${fixture_root}/expected-obj.txt"

amf_output="${temp_root}/model.amf"
amf_stdout="$("${rust_launcher}" --export-amf "${temp_root}/model.stl")"
assert_stdout "${amf_stdout}" "Exported AMF to ${amf_output}" "amf"
compare_file "${amf_output}" "${fixture_root}/expected-amf.txt"

three_mf_output="${temp_root}/model.3mf"
three_mf_stdout="$("${rust_launcher}" --export-3mf "${temp_root}/model.stl")"
assert_stdout "${three_mf_stdout}" "Exported 3MF to ${three_mf_output}" "3mf"
compare_file "${three_mf_output}" "${fixture_root}/expected-3mf.txt"

svg_stdout="$("${rust_launcher}" --export-svg "${temp_root}/model.stl")"
assert_stdout \
	"${svg_stdout}" \
	"Exported layered SVG to 5 artifact(s) rooted at ${temp_root}" \
	"layered-svg"
compare_file "${temp_root}/model_0.svg" "${fixture_root}/expected-layer-0.svg"
compare_file "${temp_root}/model_1.svg" "${fixture_root}/expected-layer-1.svg"
compare_file "${temp_root}/model_2.svg" "${fixture_root}/expected-layer-2.svg"
compare_file "${temp_root}/model_3.svg" "${fixture_root}/expected-layer-3.svg"
compare_file "${temp_root}/model_4.svg" "${fixture_root}/expected-layer-4.svg"

sla_output="${temp_root}/print.svg"
sla_stdout="$("${rust_launcher}" --sla --output "${sla_output}" "${temp_root}/model.stl")"
assert_stdout "${sla_stdout}" "Exported SLA SVG to ${sla_output}" "sla-svg"
compare_file "${sla_output}" "${fixture_root}/expected-sla-svg.txt"

sla_alias_output="${temp_root}/alias.svg"
sla_alias_stdout="$("${rust_launcher}" --export-sla-svg --output "${sla_alias_output}" "${temp_root}/model.stl")"
assert_stdout "${sla_alias_stdout}" "Exported SLA SVG to ${sla_alias_output}" "sla-svg-alias"
compare_file "${sla_alias_output}" "${fixture_root}/expected-sla-svg.txt"

printf 'verified export.workflows fixtures\n'

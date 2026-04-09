#!/usr/bin/env bash
set -euo pipefail

repo_root="${BUILD_WORKSPACE_DIRECTORY:-}"
if [[ -z "${repo_root}" ]]; then
	repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

rust_launcher="${1}"
model_stl="${2}"
model_obj="${3}"
model_amf="${4}"
model_three_mf="${5}"
model_xml="${6}"

for path_var in model_stl model_obj model_amf model_three_mf model_xml; do
	value="${!path_var}"
	if [[ "${value}" != /* ]]; then
		printf -v "${path_var}" '%s/%s' "${repo_root}" "${value}"
	fi
done

fixture_root="$(cd "$(dirname "${model_stl}")" && pwd)"

if [[ "${rust_launcher}" != /* || ! -x "${rust_launcher}" ]]; then
	rust_launcher="${repo_root}/bazel-bin/packages/slic3r-rust/crates/slic3r_cli/slic3r_cli"
fi

temp_root="$(mktemp -d /tmp/slic3r-transform-workflows.XXXXXX)"
trap 'rm -rf "${temp_root}"' EXIT
cp "${model_stl}" "${temp_root}/model.stl"
cp "${model_obj}" "${temp_root}/model.obj"
cp "${model_amf}" "${temp_root}/model.amf"
cp "${model_three_mf}" "${temp_root}/model.3mf"
cp "${model_xml}" "${temp_root}/model.xml"

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

info_stdout="$("${rust_launcher}" --info "${temp_root}/model.obj")"
assert_stdout "${info_stdout}" "$(cat "${fixture_root}/expected-info-obj.txt")" "info-obj"

info_stl_stdout="$("${rust_launcher}" --info "${temp_root}/model.stl")"
assert_stdout "${info_stl_stdout}" "$(cat "${fixture_root}/expected-info-stl.txt")" "info-stl"

info_amf_stdout="$("${rust_launcher}" --info "${temp_root}/model.amf")"
assert_stdout "${info_amf_stdout}" "$(cat "${fixture_root}/expected-info-amf.txt")" "info-amf"

info_three_mf_stdout="$("${rust_launcher}" --info "${temp_root}/model.3mf")"
assert_stdout "${info_three_mf_stdout}" "$(cat "${fixture_root}/expected-info-3mf.txt")" "info-3mf"

info_xml_stdout="$("${rust_launcher}" --info "${temp_root}/model.xml")"
assert_stdout "${info_xml_stdout}" "$(cat "${fixture_root}/expected-info-xml.txt")" "info-xml"

repair_stdout="$("${rust_launcher}" --repair "${temp_root}/model.stl")"
assert_stdout "${repair_stdout}" "" "repair"
compare_file "${temp_root}/model_fixed.obj" "${fixture_root}/expected-repair.obj"

split_stdout="$("${rust_launcher}" --split "${temp_root}/model.stl")"
assert_stdout "${split_stdout}" "$(cat "${fixture_root}/expected-split-stdout.txt")" "split"
compare_file "${temp_root}/model.stl_01.stl" "${fixture_root}/expected-split-01.stl"
compare_file "${temp_root}/model.stl_02.stl" "${fixture_root}/expected-split-02.stl"

printf 'verified transform.workflows fixtures\n'

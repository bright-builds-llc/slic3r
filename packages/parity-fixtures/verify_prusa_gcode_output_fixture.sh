#!/usr/bin/env bash
set -euo pipefail

error() {
	printf 'error: %s\n' "$*" >&2
	exit 1
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

default_checkout_root() {
	if [[ -n "${BUILD_WORKSPACE_DIRECTORY:-}" ]]; then
		printf '%s\n' "${BUILD_WORKSPACE_DIRECTORY}"
		return
	fi

	cd "${script_dir}/../.." && pwd
}

checkout_root="$(default_checkout_root)"

if [[ "$#" -eq 0 ]]; then
	package_dir="${checkout_root}/packages/parity-fixtures"
	fixture_dir="${package_dir}/forks/prusaslicer/prusaslicer.gcode-output"
	fixture_readme="${fixture_dir}/README.md"
	provenance_file="${fixture_dir}/fixture-provenance.tsv"
	expected_summary_file="${fixture_dir}/expected-gcode-summary.tsv"
	gcode_file="${fixture_dir}/gcodewriter-set-speed.gcode"
	status_file="${checkout_root}/packages/parity/status.tsv"
	parity_build_file="${checkout_root}/packages/parity/BUILD.bazel"
	package_readme="${package_dir}/README.md"
elif [[ "$#" -eq 7 || "$#" -eq 8 ]]; then
	fixture_readme="$1"
	provenance_file="$2"
	expected_summary_file="$3"
	gcode_file="$4"
	status_file="$5"
	parity_build_file="$6"
	package_readme="$7"
	if [[ "$#" -eq 8 ]]; then
		checkout_root="$8"
	fi
else
	error "usage: verify_prusa_gcode_output_fixture.sh [fixture-README fixture-provenance expected-gcode-summary gcode-file parity-status parity-BUILD parity-fixtures-README [checkout-root]]"
fi

readonly SOURCE_REF="prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961"
readonly PEELED_COMMIT="9a583bd438b195856f3bcf7ea99b69ba4003a961"
readonly FIXTURE_PATH="packages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode"
readonly EXPECTED_SHA="dc1bb725fb2d81b986356bcdd0b160877dce48b086b3cf71867abc0ecf4467cb"
readonly EXPECTED_SIZE="42"
readonly EXPECTED_LINE_COUNT="4"
readonly PHASE45_SCOPE_RECORD="packages/prusa-gcode-output-scope/gcode-output-scope.md"
readonly EXPECTED_SUMMARY_HEADER=$'source_ref\tfixture_path\tmetadata_key\tmetadata_value\tmarker_key\tmarker_value\tnotes'
readonly PROVENANCE_HEADER=$'fixture_id\tvendor_id\tinventory_id\tsource_ref\taccepted_tag\tpeeled_commit\tsource_path\tupstream_url\tbytes\tsha256\tline_endings_encoding\trole\tphase45_scope_record\tupdate_route\tstatus_scope\tprivacy_post_processing_exclusions\tbroad_deferrals'
readonly PROVENANCE_ROW=$'gcodewriter-set-speed.gcode\tprusaslicer\tprusaslicer.gcode-output\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tversion_2.9.5\t9a583bd438b195856f3bcf7ea99b69ba4003a961\ttests/fff_print/test_gcodewriter.cpp\thttps://github.com/prusa3d/PrusaSlicer/blob/9a583bd438b195856f3bcf7ea99b69ba4003a961/tests/fff_print/test_gcodewriter.cpp#L20-L35\t42\tdc1bb725fb2d81b986356bcdd0b160877dce48b086b3cf71867abc0ecf4467cb\tascii-lf\tsource-controlled-gcodewriter-set-speed-expected-output\tpackages/prusa-gcode-output-scope/gcode-output-scope.md\treviewed-intake-change-updates-packages/fork-vendors/forks.tsv-packages/fork-inventories/prusaslicer.tsv-and-packages/prusa-gcode-output-scope/gcode-output-scope.md\tPhase-46-fixture-surface-only-no-parity-status\tno-post-processing-no-host-upload-no-credential-no-network-device-no-printer-runtime\tno-byte-for-byte-gcode-parity-no-full-generated-output-parity-no-toolpath-geometry-no-extrusion-no-timing-no-support-no-wall-seam-no-arc-no-step-no-full-3mf-no-runtime-no-firmware-no-printability-no-gui-no-binary-gcode-no-thumbnails-no-post-processing-no-host-upload-no-network-device-no-profile-auto-update-no-release-no-bambu-no-orca-no-upstream-source-import-no-sync'
readonly EXPECTED_SOURCE_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tsource_identity\tprusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tsource_literal\ttests/fff_print/test_gcodewriter.cpp#L20-L35\tAccepted PrusaSlicer source identity and upstream test literal trace only; no generated-output behavior claimed.'
readonly EXPECTED_LINE_1_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tfixture_role\tsource-controlled-gcodewriter-set-speed-expected-output\tline_1\tG1 F99999.123\tRepresentative fixed-point feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.'
readonly EXPECTED_LINE_2_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tfixture_role\tsource-controlled-gcodewriter-set-speed-expected-output\tline_2\tG1 F1\tRepresentative integer feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.'
readonly EXPECTED_LINE_3_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tfixture_role\tsource-controlled-gcodewriter-set-speed-expected-output\tline_3\tG1 F203.2\tRepresentative one-decimal feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.'
readonly EXPECTED_LINE_4_ROW=$'prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961\tpackages/parity-fixtures/forks/prusaslicer/prusaslicer.gcode-output/gcodewriter-set-speed.gcode\tfixture_role\tsource-controlled-gcodewriter-set-speed-expected-output\tline_4\tG1 F203.201\tRepresentative three-decimal rounded feedrate command marker; no motion, extrusion, timing, or printability semantics claimed.'

require_file() {
	local file="$1"
	local label="$2"
	if [[ ! -f "${file}" ]]; then
		error "${label} file not found: ${file}"
	fi
}

require_text() {
	local file="$1"
	local label="$2"
	local pattern="$3"
	if ! grep -Fq -- "${pattern}" "${file}"; then
		error "${label}: missing required text: ${pattern}"
	fi
}

reject_text() {
	local file="$1"
	local label="$2"
	local pattern="$3"
	if grep -Fq -- "${pattern}" "${file}"; then
		error "${label}: forbidden text: ${pattern}"
	fi
}

require_exact_header() {
	local file="$1"
	local label="$2"
	local expected_header="$3"
	local actual_header
	IFS= read -r actual_header <"${file}" || error "${label}: missing header"
	if [[ "${actual_header}" != "${expected_header}" ]]; then
		error "${label}: expected header ${expected_header}"
	fi
}

require_line_count() {
	local file="$1"
	local label="$2"
	local expected_count="$3"
	local actual_count
	actual_count="$(wc -l <"${file}" | tr -d ' ')"
	if [[ "${actual_count}" != "${expected_count}" ]]; then
		error "${label}: expected ${expected_count} rows, got ${actual_count}"
	fi
}

require_size() {
	local file="$1"
	local label="$2"
	local expected_size="$3"
	local actual_size
	actual_size="$(wc -c <"${file}" | tr -d ' ')"
	if [[ "${actual_size}" != "${expected_size}" ]]; then
		error "${label}: expected ${expected_size} bytes, got ${actual_size}"
	fi
}

require_sha256() {
	local file="$1"
	local label="$2"
	local expected_sha="$3"
	local actual_sha
	actual_sha="$(shasum -a 256 "${file}" | awk '{ print $1 }')"
	if [[ "${actual_sha}" != "${expected_sha}" ]]; then
		error "${label}: expected SHA-256 ${expected_sha}, got ${actual_sha}"
	fi
}

require_exact_line() {
	local file="$1"
	local label="$2"
	local expected_line="$3"
	local description="$4"
	if ! grep -Fxq -- "${expected_line}" "${file}"; then
		error "${label}: missing required row for ${description}"
	fi
}

require_ascii_lf() {
	local file="$1"
	local label="$2"
	if ! LC_ALL=C awk 'index($0, "\r") || $0 !~ /^[ -~]*$/ { exit 1 }' "${file}"; then
		error "${label}: expected US-ASCII text with LF line endings"
	fi
}

reject_status_row() {
	local id="$1"
	local file="$2"
	if awk -F '\t' -v id="${id}" '$1 == id { found = 1 } END { exit found ? 0 : 1 }' "${file}"; then
		error "packages/parity/status.tsv: forbidden status row exists: ${id}"
	fi
}

reject_parity_target() {
	local parity_target_pattern
	parity_target_pattern="name[[:space:]]*=[[:space:]]*['\"]prusaslicer_gcode_output_parity['\"]"
	if grep -Eq -- "${parity_target_pattern}" "${parity_build_file}"; then
		error "packages/parity/BUILD.bazel: forbidden parity target exists: prusaslicer_gcode_output_parity"
	fi
}

reject_verifier_behavior_terms() {
	local verifier_file="${BASH_SOURCE[0]}"
	local term_http term_git_space term_git_tab term_cl term_ft
	local term_prusaslicer term_slic3r term_send_gcode term_host_upload
	local forbidden_term

	term_http="cu""rl "
	term_git_space="g""it "
	term_git_tab="$(printf 'g%s\t' "it")"
	term_cl="cl""one"
	term_ft="fet""ch"
	term_prusaslicer="PrusaSlicer ""--"
	term_slic3r="slic3r ""--"
	term_send_gcode="send-""gcode"
	term_host_upload="host ""upload"

	for forbidden_term in \
		"${term_http}" \
		"${term_git_space}" \
		"${term_git_tab}" \
		"${term_cl}" \
		"${term_ft}" \
		"${term_prusaslicer}" \
		"${term_slic3r}" \
		"${term_send_gcode}" \
		"${term_host_upload}"; do
		if grep -Fq -- "${forbidden_term}" "${verifier_file}"; then
			error "verify_prusa_gcode_output_fixture.sh: forbidden verifier behavior term present"
		fi
	done
}

verify_gcode_file() {
	require_ascii_lf "${gcode_file}" "gcodewriter-set-speed.gcode"
	require_line_count "${gcode_file}" "gcodewriter-set-speed.gcode" "${EXPECTED_LINE_COUNT}"
	require_size "${gcode_file}" "gcodewriter-set-speed.gcode" "${EXPECTED_SIZE}"
	require_sha256 "${gcode_file}" "gcodewriter-set-speed.gcode" "${EXPECTED_SHA}"
	require_exact_line "${gcode_file}" "gcodewriter-set-speed.gcode" "G1 F99999.123" "line 1 fixed-point feedrate"
	require_exact_line "${gcode_file}" "gcodewriter-set-speed.gcode" "G1 F1" "line 2 integer feedrate"
	require_exact_line "${gcode_file}" "gcodewriter-set-speed.gcode" "G1 F203.2" "line 3 one-decimal feedrate"
	require_exact_line "${gcode_file}" "gcodewriter-set-speed.gcode" "G1 F203.201" "line 4 three-decimal feedrate"
}

verify_provenance() {
	require_exact_header "${provenance_file}" "fixture-provenance.tsv" "${PROVENANCE_HEADER}"
	require_exact_line "${provenance_file}" "fixture-provenance.tsv" "${PROVENANCE_ROW}" "gcodewriter-set-speed.gcode provenance"
	require_text "${provenance_file}" "fixture-provenance.tsv" "${PHASE45_SCOPE_RECORD}"
	require_text "${provenance_file}" "fixture-provenance.tsv" "${EXPECTED_SHA}"
	require_line_count "${provenance_file}" "fixture-provenance.tsv" "2"
}

verify_expected_summary() {
	require_exact_header "${expected_summary_file}" "expected-gcode-summary.tsv" "${EXPECTED_SUMMARY_HEADER}"
	require_exact_line "${expected_summary_file}" "expected-gcode-summary.tsv" "${EXPECTED_SOURCE_ROW}" "source identity"
	require_exact_line "${expected_summary_file}" "expected-gcode-summary.tsv" "${EXPECTED_LINE_1_ROW}" "line_1"
	require_exact_line "${expected_summary_file}" "expected-gcode-summary.tsv" "${EXPECTED_LINE_2_ROW}" "line_2"
	require_exact_line "${expected_summary_file}" "expected-gcode-summary.tsv" "${EXPECTED_LINE_3_ROW}" "line_3"
	require_exact_line "${expected_summary_file}" "expected-gcode-summary.tsv" "${EXPECTED_LINE_4_ROW}" "line_4"
	require_text "${expected_summary_file}" "expected-gcode-summary.tsv" "${FIXTURE_PATH}"
	require_line_count "${expected_summary_file}" "expected-gcode-summary.tsv" "6"

	for rejected_column in \
		"bytes" \
		"sha256" \
		"status row" \
		"prusaslicer_gcode_output_parity" \
		"geometry count" \
		"extrusion total" \
		"print duration"; do
		reject_text "${expected_summary_file}" "expected-gcode-summary.tsv" "${rejected_column}"
	done
}

verify_readme_scope() {
	local no_behavior_intro
	local no_behavior_middle
	local broad_deferral_intro
	local broad_deferral_middle
	local package_no_network_text

	no_behavior_intro="No base export fixture reuse, live generation, upstream fet""ching/importing,"
	no_behavior_middle="binary G-code, thumbnails, post-processing, host ""upload, printer-runtime"
	broad_deferral_intro="Byte-for-byte G-code parity, full generated-output parity, toolpath geometry,"
	broad_deferral_middle="or viewer behavior, fork release builds, and broad PrusaSlicer runtime support"
	package_no_network_text="Fixture verification does not fet""ch upstream source"

	require_text "${fixture_readme}" "fixture README" "# PrusaSlicer G-code Output Fixture"
	require_text "${fixture_readme}" "fixture README" "Phase 46 supplies fixture bytes and summary-only expected artifacts only."
	require_text "${fixture_readme}" "fixture README" "The accepted upstream tree has no checked-in \`.gcode\` blob"
	require_text "${fixture_readme}" "fixture README" "Source ref:"
	require_text "${fixture_readme}" "fixture README" "${SOURCE_REF}"
	require_text "${fixture_readme}" "fixture README" "Peeled commit: \`${PEELED_COMMIT}\`"
	require_text "${fixture_readme}" "fixture README" "Source path: \`tests/fff_print/test_gcodewriter.cpp#L20-L35\`"
	require_text "${fixture_readme}" "fixture README" "Fixture: \`gcodewriter-set-speed.gcode\`"
	require_text "${fixture_readme}" "fixture README" "Expected artifact: \`expected-gcode-summary.tsv\`"
	require_text "${fixture_readme}" "fixture README" "Byte count: \`${EXPECTED_SIZE}\`"
	require_text "${fixture_readme}" "fixture README" "${EXPECTED_SHA}"
	require_text "${fixture_readme}" "fixture README" "${PHASE45_SCOPE_RECORD}"
	require_text "${fixture_readme}" "fixture README" "Update route: update this fixture only after a reviewed intake change updates"
	require_text "${fixture_readme}" "fixture README" "\`packages/fork-vendors/forks.tsv\`"
	require_text "${fixture_readme}" "fixture README" "\`packages/fork-inventories/prusaslicer.tsv\`"
	require_text "${fixture_readme}" "fixture README" "\`packages/prusa-gcode-output-scope/gcode-output-scope.md\`"
	require_text "${fixture_readme}" "fixture README" "Rust summary parsing remains Phase 47-owned"
	require_text "${fixture_readme}" "fixture README" "executable parity and"
	require_text "${fixture_readme}" "fixture README" "\`fork.prusaslicer.gcode-output\` status publication remain Phase 48-owned"
	require_text "${fixture_readme}" "fixture README" "${no_behavior_intro}"
	require_text "${fixture_readme}" "fixture README" "${no_behavior_middle}"
	require_text "${fixture_readme}" "fixture README" "behavior, network/device behavior, credential handling, Bambu Studio support,"
	require_text "${fixture_readme}" "fixture README" "OrcaSlicer support, upstream source imports, or sync automation is introduced"
	require_text "${fixture_readme}" "fixture README" "${broad_deferral_intro}"
	require_text "${fixture_readme}" "fixture README" "extrusion, timing, support generation, wall seam behavior, arc fitting, STEP"
	require_text "${fixture_readme}" "fixture README" "import, full 3MF import/export, firmware or printability behavior, GUI export"
	require_text "${fixture_readme}" "fixture README" "${broad_deferral_middle}"
	require_text "${package_readme}" "packages/parity-fixtures/README.md" "${package_no_network_text}"
}

reject_overclaiming_text() {
	local checked_file
	local checked_label
	local forbidden_claim

	for checked_file in "${fixture_readme}" "${expected_summary_file}"; do
		checked_label="$(basename "${checked_file}")"
		for forbidden_claim in \
			"verified Prusa G-code output parity" \
			"byte-for-byte G-code parity verified" \
			"full generated-output parity verified" \
			"toolpath correctness verified" \
			"printability verified" \
			"host ""upload verified" \
			"Bambu Studio support verified" \
			"OrcaSlicer support verified"; do
			reject_text "${checked_file}" "${checked_label}" "${forbidden_claim}"
		done
	done
}

for required_file in \
	"${fixture_readme}" \
	"${provenance_file}" \
	"${expected_summary_file}" \
	"${gcode_file}" \
	"${status_file}" \
	"${parity_build_file}" \
	"${package_readme}"; do
	require_file "${required_file}" "input"
done

reject_verifier_behavior_terms
verify_gcode_file
verify_provenance
verify_expected_summary
verify_readme_scope
reject_overclaiming_text
reject_status_row "fork.prusaslicer.gcode-output" "${status_file}"
reject_parity_target

printf 'ok: Prusa G-code output fixture verification passed\n'

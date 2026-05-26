#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -n "${TEST_SRCDIR:-}" && -n "${TEST_WORKSPACE:-}" ]]; then
	verifier="${TEST_SRCDIR}/${TEST_WORKSPACE}/packages/fork-inventories/verify_inventories.sh"
else
	verifier="${script_dir}/verify_inventories.sh"
fi

if [[ ! -x "${verifier}" ]]; then
	printf 'error: verifier is not executable: %s\n' "${verifier}" >&2
	exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/verify-inventories-test.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
	printf 'FAIL: %s\n' "$1" >&2
	exit 1
}

assert_contains() {
	file="$1"
	pattern="$2"
	if ! grep -Eq "${pattern}" "${file}"; then
		printf 'missing pattern: %s\n' "${pattern}" >&2
		printf '%s contents:\n' "${file}" >&2
		sed -n '1,120p' "${file}" >&2
		exit 1
	fi
}

write_inventory_header() {
	file="$1"
	printf '# inventory_id\tvendor_id\tsource_ref\tsource_paths\tfeature_surface\tfeature_category\townership\tcomplexity\tparity_dependency\tv1_9_decision\tcaution_flags\tfuture_parity_notes\n' >"${file}"
}

write_category_header() {
	file="$1"
	printf '# map_id\tfeature_category\townership\tv1_9_decision\tinventory_ids\tnotes\n' >"${file}"
}

write_forks_header() {
	file="$1"
	printf '# vendor_id\tdisplay_name\tofficial_repo_url\tselected_stable_tag\ttag_kind\ttag_ref_sha\ttag_object_sha\tpeeled_commit_sha\tdefault_branch\tobserved_default_branch_head\tcapture_date_utc\tlineage_ids\tsource_paths\trefresh_command\tspdx_identifier\tobserved_license_id\tlicense_source\tattribution_notes\tprovenance_notes\tcaution_flags\tcaution_notes\n' >"${file}"
}

write_parity_header() {
	file="$1"
	printf '# surface\tstatus\tevidence\tnotes\n' >"${file}"
}

append_inventory_row() {
	file="$1"
	shift
	printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$@" >>"${file}"
}

append_category_row() {
	file="$1"
	shift
	printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$@" >>"${file}"
}

append_fork_row() {
	file="$1"
	vendor_id="$2"
	selected_tag="$3"
	peeled_commit="$4"
	observed_head="$5"
	append_fork_row_with_paths "${file}" "${vendor_id}" "${selected_tag}" "${peeled_commit}" "${observed_head}" "src"
}

append_fork_row_with_paths() {
	file="$1"
	vendor_id="$2"
	selected_tag="$3"
	peeled_commit="$4"
	observed_head="$5"
	source_paths="$6"
	printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
		"${vendor_id}" "${vendor_id}" "https://example.invalid/${vendor_id}" \
		"${selected_tag}" "lightweight" "${peeled_commit}" "-" "${peeled_commit}" \
		"main" "${observed_head}" "2026-05-26T16:23:36Z" "slic3r" \
		"${source_paths}" "display-only" "AGPL-3.0-only" "AGPL-3.0" \
		"README.md@${selected_tag};LICENSE@${selected_tag}" "Attribution" \
		"metadata-only-not-legal-review" "none" "No caution" >>"${file}"
}

append_parity_row() {
	file="$1"
	surface="$2"
	printf '%s\tverified\tfixture\tFixture evidence\n' "${surface}" >>"${file}"
}

make_fixture_dir() {
	name="$1"
	dir="${tmp_dir}/${name}"
	mkdir -p "${dir}"
	write_inventory_header "${dir}/template.tsv"
	write_inventory_header "${dir}/prusaslicer.tsv"
	write_inventory_header "${dir}/bambustudio.tsv"
	write_inventory_header "${dir}/orcaslicer.tsv"
	write_category_header "${dir}/category-map.tsv"
	write_forks_header "${dir}/forks.tsv"
	write_parity_header "${dir}/status.tsv"
	append_parity_row "${dir}/status.tsv" "cli.version"
	append_parity_row "${dir}/status.tsv" "config"
	append_parity_row "${dir}/status.tsv" "config.persistence"
	append_parity_row "${dir}/status.tsv" "file-formats"
	append_parity_row "${dir}/status.tsv" "generated-outputs"
	printf '%s\n' "${dir}"
}

run_verifier() {
	dir="$1"
	stdout_file="$2"
	stderr_file="$3"

	set +e
	"${verifier}" \
		"${dir}/template.tsv" \
		"${dir}/prusaslicer.tsv" \
		"${dir}/bambustudio.tsv" \
		"${dir}/orcaslicer.tsv" \
		"${dir}/category-map.tsv" \
		"${dir}/forks.tsv" \
		"${dir}/status.tsv" >"${stdout_file}" 2>"${stderr_file}"
	status="$?"
	set -e

	return "${status}"
}

write_valid_single_vendor_fixture() {
	dir="$(make_fixture_dir "$1")"
	append_fork_row "${dir}/forks.tsv" \
		"testvendor" "v1.0.0" "1111111111111111111111111111111111111111" \
		"9999999999999999999999999999999999999999"
	append_inventory_row "${dir}/prusaslicer.tsv" \
		"testvendor.base" "testvendor" \
		"testvendor:v1.0.0@1111111111111111111111111111111111111111" \
		"src/base" "base-core" "base-core" "base-slic3r" "none" \
		"cli.version" "no-action-base" "none" \
		"Valid fixture row for baseline verifier behavior."
	append_category_row "${dir}/category-map.tsv" \
		"base" "base-core" "base-slic3r" "no-action-base" \
		"testvendor.base" "Valid single-row map."
	printf '%s\n' "${dir}"
}

test_valid_single_vendor_fixture_passes() {
	# Arrange
	dir="$(write_valid_single_vendor_fixture "valid")"

	# Act
	if ! run_verifier "${dir}" "${tmp_dir}/valid.out" "${tmp_dir}/valid.err"; then
		sed -n '1,120p' "${tmp_dir}/valid.err" >&2
		fail "valid fixture failed"
	fi

	# Assert
	assert_contains "${tmp_dir}/valid.out" '^ok: inventory verification passed$'
}

test_wrong_source_ref_fails() {
	# Arrange
	dir="$(write_valid_single_vendor_fixture "wrong-source-ref")"
	write_inventory_header "${dir}/prusaslicer.tsv"
	append_inventory_row "${dir}/prusaslicer.tsv" \
		"testvendor.base" "testvendor" \
		"testvendor:v1.0.0@9999999999999999999999999999999999999999" \
		"src/base" "base-core" "base-core" "base-slic3r" "none" \
		"cli.version" "no-action-base" "none" \
		"Invalid default branch head fixture row."

	# Act
	if run_verifier "${dir}" "${tmp_dir}/wrong-source-ref.out" "${tmp_dir}/wrong-source-ref.err"; then
		fail "wrong source_ref fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/wrong-source-ref.err" 'source_ref'
}

test_row_shape_and_enums_fail() {
	# Arrange
	for case_name in unknown-vendor invalid-enum empty-required bad-column-count; do
		dir="$(write_valid_single_vendor_fixture "${case_name}")"
		write_inventory_header "${dir}/prusaslicer.tsv"
		case "${case_name}" in
			unknown-vendor)
				append_inventory_row "${dir}/prusaslicer.tsv" \
					"missing.base" "missing" \
					"missing:v1.0.0@1111111111111111111111111111111111111111" \
					"src/base" "base-core" "base-core" "base-slic3r" "none" \
					"cli.version" "no-action-base" "none" "Unknown vendor row."
				;;
			invalid-enum)
				append_inventory_row "${dir}/prusaslicer.tsv" \
					"testvendor.base" "testvendor" \
					"testvendor:v1.0.0@1111111111111111111111111111111111111111" \
					"src/base" "base-core" "base-core" "invalid-owner" "none" \
					"cli.version" "no-action-base" "none" "Invalid enum row."
				;;
			empty-required)
				printf 'testvendor.base\ttestvendor\ttestvendor:v1.0.0@1111111111111111111111111111111111111111\t\tbase-core\tbase-core\tbase-slic3r\tnone\tcli.version\tno-action-base\tnone\tEmpty required field row.\n' >>"${dir}/prusaslicer.tsv"
				;;
			bad-column-count)
				printf 'testvendor.base\ttestvendor\ttoo-few-fields\n' >>"${dir}/prusaslicer.tsv"
				;;
		esac

		# Act
		if run_verifier "${dir}" "${tmp_dir}/${case_name}.out" "${tmp_dir}/${case_name}.err"; then
			fail "${case_name} fixture passed"
		fi

		# Assert
		assert_contains "${tmp_dir}/${case_name}.err" '^error:'
	done
}

test_stale_category_reference_fails() {
	# Arrange
	dir="$(write_valid_single_vendor_fixture "stale-category")"
	write_category_header "${dir}/category-map.tsv"
	append_category_row "${dir}/category-map.tsv" \
		"stale" "base-core" "base-slic3r" "no-action-base" \
		"testvendor.missing" "Unknown row reference."

	# Act
	if run_verifier "${dir}" "${tmp_dir}/stale-category.out" "${tmp_dir}/stale-category.err"; then
		fail "stale category reference fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/stale-category.err" 'category-map'
}

test_missing_or_duplicate_category_references_fail() {
	# Arrange
	for case_name in missing-reference duplicate-reference; do
		dir="$(write_valid_single_vendor_fixture "${case_name}")"
		write_category_header "${dir}/category-map.tsv"
		if [[ "${case_name}" == "duplicate-reference" ]]; then
			append_category_row "${dir}/category-map.tsv" \
				"first" "base-core" "base-slic3r" "no-action-base" \
				"testvendor.base" "First row."
			append_category_row "${dir}/category-map.tsv" \
				"second" "base-core" "base-slic3r" "no-action-base" \
				"testvendor.base" "Duplicate row."
		fi

		# Act
		if run_verifier "${dir}" "${tmp_dir}/${case_name}.out" "${tmp_dir}/${case_name}.err"; then
			fail "${case_name} fixture passed"
		fi

		# Assert
		assert_contains "${tmp_dir}/${case_name}.err" 'category-map'
	done
}

test_unknown_parity_dependency_fails() {
	# Arrange
	dir="$(write_valid_single_vendor_fixture "unknown-parity")"
	write_inventory_header "${dir}/prusaslicer.tsv"
	append_inventory_row "${dir}/prusaslicer.tsv" \
		"testvendor.base" "testvendor" \
		"testvendor:v1.0.0@1111111111111111111111111111111111111111" \
		"src/base" "base-core" "base-core" "base-slic3r" "none" \
		"unknown.surface" "no-action-base" "none" \
		"Unknown parity dependency row."

	# Act
	if run_verifier "${dir}" "${tmp_dir}/unknown-parity.out" "${tmp_dir}/unknown-parity.err"; then
		fail "unknown parity dependency fixture passed"
	fi

	# Assert
	assert_contains "${tmp_dir}/unknown-parity.err" 'parity_dependency'
}

test_missing_required_bambu_or_orca_coverage_fails() {
	# Arrange
	for vendor_id in bambustudio orcaslicer; do
		dir="$(make_fixture_dir "missing-${vendor_id}-coverage")"
		if [[ "${vendor_id}" == "bambustudio" ]]; then
			append_fork_row "${dir}/forks.tsv" \
				"bambustudio" "v02.06.00.51" \
				"b506005bc4ee62124e24bf00e0f58656db3646a6" \
				"e150b502b3d2afc98b83dcc9e5720e998f9eb79a"
			append_inventory_row "${dir}/bambustudio.tsv" \
				"bambustudio.project-file" "bambustudio" \
				"bambustudio:v02.06.00.51@b506005bc4ee62124e24bf00e0f58656db3646a6" \
				"src/libslic3r/Format/bbs_3mf.cpp" "project-file" "project-file" \
				"fork-specific" "medium" "file-formats" "future-candidate" "none" \
				"Incomplete Bambu coverage row."
			append_category_row "${dir}/category-map.tsv" \
				"bambu.project" "project-file" "fork-specific" "future-candidate" \
				"bambustudio.project-file" "Incomplete coverage map."
		else
			append_fork_row "${dir}/forks.tsv" \
				"orcaslicer" "v2.3.2" \
				"c724a3f5f51c52336624b689e846c8fbc943a912" \
				"e0c4d11baefa328331be113533c47ee89fda16c6"
			append_inventory_row "${dir}/orcaslicer.tsv" \
				"orcaslicer.calibration-flow" "orcaslicer" \
				"orcaslicer:v2.3.2@c724a3f5f51c52336624b689e846c8fbc943a912" \
				"resources/calib" "calibration-flow" "calibration-flow" \
				"fork-specific" "high" "generated-outputs" "needs-review" \
				"license-provenance;runtime-parity-not-verified" \
				"Incomplete Orca coverage row."
			append_category_row "${dir}/category-map.tsv" \
				"orca.calibration" "calibration-flow" "fork-specific" "needs-review" \
				"orcaslicer.calibration-flow" "Incomplete coverage map."
		fi

		# Act
		if run_verifier "${dir}" "${tmp_dir}/${vendor_id}-coverage.out" "${tmp_dir}/${vendor_id}-coverage.err"; then
			fail "missing ${vendor_id} coverage fixture passed"
		fi

		# Assert
		assert_contains "${tmp_dir}/${vendor_id}-coverage.err" 'missing required feature_surface'
	done
}

test_unsafe_caution_rows_fail() {
	# Arrange
	for case_name in not-deferred missing-runtime-flag; do
		dir="$(write_valid_single_vendor_fixture "${case_name}")"
		write_inventory_header "${dir}/prusaslicer.tsv"
		if [[ "${case_name}" == "not-deferred" ]]; then
			decision="future-candidate"
			flags="network-scope;runtime-parity-not-verified"
		else
			decision="deferred"
			flags="network-scope"
		fi
		append_inventory_row "${dir}/prusaslicer.tsv" \
			"testvendor.base" "testvendor" \
			"testvendor:v1.0.0@1111111111111111111111111111111111111111" \
			"src/base" "base-core" "base-core" "base-slic3r" "none" \
			"cli.version" "${decision}" "${flags}" "Unsafe caution row."
		write_category_header "${dir}/category-map.tsv"
		append_category_row "${dir}/category-map.tsv" \
			"base" "base-core" "base-slic3r" "${decision}" \
			"testvendor.base" "Unsafe caution map."

		# Act
		if run_verifier "${dir}" "${tmp_dir}/${case_name}.out" "${tmp_dir}/${case_name}.err"; then
			fail "${case_name} caution fixture passed"
		fi

		# Assert
		assert_contains "${tmp_dir}/${case_name}.err" 'runtime-parity-not-verified|deferred'
	done
}

test_valid_single_vendor_fixture_passes
test_wrong_source_ref_fails
test_row_shape_and_enums_fail
test_stale_category_reference_fails
test_missing_or_duplicate_category_references_fail
test_unknown_parity_dependency_fails
test_missing_required_bambu_or_orca_coverage_fails
test_unsafe_caution_rows_fail

printf 'ok: verify_inventories_test\n'

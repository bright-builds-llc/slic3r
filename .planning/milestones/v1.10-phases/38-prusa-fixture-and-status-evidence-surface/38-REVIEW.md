---
phase: 38-prusa-fixture-and-status-evidence-surface
reviewed: 2026-06-01T01:31:45Z
depth: standard
files_reviewed: 14
files_reviewed_list:
  - docs/port/README.md
  - docs/port/migration-guidance.md
  - docs/port/package-map.md
  - docs/port/parity-matrix.md
  - packages/parity-fixtures/BUILD.bazel
  - packages/parity-fixtures/README.md
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/.gitattributes
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.idx
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/PrusaResearch.ini
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/README.md
  - packages/parity-fixtures/forks/prusaslicer/prusaslicer.profile-schema/fixture-provenance.tsv
  - packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh
  - packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh
  - packages/parity/README.md
findings:
  critical: 0
  warning: 2
  info: 0
  total: 2
status: issues_found
---

# Phase 38: Code Review Report

**Reviewed:** 2026-06-01T01:31:45Z
**Depth:** standard
**Files Reviewed:** 14
**Status:** issues_found

## Summary

Reviewed the Phase 38 Prusa fixture/status evidence surface, including the shell verifier, shell tests, Bazel labels/data wiring, status wording, and fixture provenance. Local guidance from `AGENTS.md`, `AGENTS.bright-builds.md`, `standards-overrides.md`, and the canonical Bright Builds code-shape, verification, testing, and architecture standards informed the review.

The docs keep Phase 38 scoped to static fixture/status preparation and do not publish a Prusa status row. The raw `PrusaResearch.ini` and `PrusaResearch.idx` files were treated as static vendor fixture inputs; their recorded sizes, SHA-256 values, line endings, and Bazel bundle exposure were checked, and no concrete issue was found in those raw files.

Verification run during review:

- `bazel run //packages/parity-fixtures:verify_prusa_profile_schema_fixture`
- `bazel test //packages/parity-fixtures:verify_prusa_profile_schema_fixture_test`
- `shellcheck packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh packages/parity-fixtures/verify_prusa_profile_schema_fixture_test.sh`
- `git diff --check 077a04202^..HEAD -- ...reviewed paths...`

## Warnings

### WR-01: Provenance Verification Does Not Bind Metadata To Fixture Rows

**File:** `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh:93`

**Issue:** `verify_provenance` only checks that required strings appear somewhere in `fixture-provenance.tsv`. It does not verify that each value belongs to the correct `fixture_id` row. I confirmed that a temp copy with the `PrusaResearch.ini` and `PrusaResearch.idx` `bytes`, `sha256`, and `line_endings` fields swapped still passes `verify_prusa_profile_schema_fixture.sh`, because all expected tokens remain present somewhere in the TSV. That means the verifier can accept inconsistent provenance even though Phase 38 relies on provenance consistency as evidence.

**Fix:** Parse the TSV by column and validate the complete expected row for each fixture id. Add a negative test that swaps `PrusaResearch.ini` and `PrusaResearch.idx` metadata and expects failure.

```bash
verify_provenance_row() {
	local fixture_id="$1"
	local expected_source_path="$2"
	local expected_bytes="$3"
	local expected_sha="$4"
	local expected_line_endings="$5"
	local expected_role="$6"

	awk -F '\t' \
		-v fixture_id="${fixture_id}" \
		-v source_ref="prusaslicer:version_2.9.5@9a583bd438b195856f3bcf7ea99b69ba4003a961" \
		-v source_path="${expected_source_path}" \
		-v bytes="${expected_bytes}" \
		-v sha="${expected_sha}" \
		-v line_endings="${expected_line_endings}" \
		-v role="${expected_role}" '
		$1 == fixture_id {
			found = 1
			if ($3 != "prusaslicer.profile-schema" || $4 != source_ref || $7 != source_path ||
				$9 != bytes || $10 != sha || $11 != line_endings || $12 != role) {
				exit 2
			}
		}
		END { if (!found) exit 1 }
	' "${provenance_file}" || error "fixture-provenance.tsv: invalid row for ${fixture_id}"
}
```

### WR-02: Namespace Check Matches Forbidden Tokens In Parent Directories

**File:** `packages/parity-fixtures/verify_prusa_profile_schema_fixture.sh:153`

**Issue:** `verify_forbidden_namespaces` lowercases and scans the full absolute `namespace_path`. A valid fixture under a parent directory named `cloud`, `network`, `credentials`, `plugin`, or another forbidden token fails even when the relative path under `forks_root` is only `prusaslicer/prusaslicer.profile-schema`. I reproduced this with `PRUSA_FIXTURE_FORKS_ROOT` under a temp `/cloud/.../forks` directory; the verifier rejected `/.../cloud/.../forks/prusaslicer`.

**Fix:** Normalize `forks_root`, derive a relative path for each `find` result, and apply forbidden-token checks only to the relative namespace path.

```bash
forks_root="$(cd "${forks_root}" && pwd -P)"

while IFS= read -r namespace_path; do
	relative_path="${namespace_path#${forks_root}/}"
	lower_path="$(printf '%s' "${relative_path}" | tr '[:upper:]' '[:lower:]')"
	for forbidden_token in bambustudio orca orcaslicer network cloud credential credentials plugin non-free; do
		if [[ "/${lower_path}/" == *"/${forbidden_token}/"* ]]; then
			error "forbidden Prusa fixture namespace path contains ${forbidden_token}: ${namespace_path}"
		fi
	done
	# Keep the existing allowed namespace check after this relative-path guard.
done < <(find "${forks_root}" -mindepth 1 -print)
```

---

_Reviewed: 2026-06-01T01:31:45Z_
_Reviewer: the agent (gsd-code-reviewer)_
_Depth: standard_

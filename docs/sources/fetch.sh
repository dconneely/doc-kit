#!/bin/sh
# fetch.sh - retrieve external sources indexed in README.md and verify their checksums.
#
# Usage: sh fetch.sh [document ...]
#        with no arguments, fetches every missing document in the index table.

set -eu

DIR=$(cd "$(dirname "$0")" && pwd)
README="$DIR/README.md"

if [ ! -f "$README" ]; then
	echo "fetch: README.md not found in $DIR" >&2
	exit 1
fi

calc_sha256() {
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$1" | awk '{print $1}'
	elif command -v shasum >/dev/null 2>&1; then
		shasum -a 256 "$1" | awk '{print $1}'
	elif command -v openssl >/dev/null 2>&1; then
		openssl dgst -sha256 "$1" | awk '{print $NF}'
	else
		echo "fetch: no sha256 tool found (need sha256sum, shasum, or openssl)" >&2
		exit 1
	fi
}

failures=0
tmp_manifest=$(mktemp)
trap 'rm -f "$tmp_manifest"' EXIT HUP INT TERM

# Parse markdown table rows: | `doc` | `url` | date | licence | redist | `sha256` |
awk -F' *[|] *' '
	/^\| *`[^`]+` *\| *`https?:/ {
		doc = $2; gsub(/`/, "", doc)
		url = $3; gsub(/`/, "", url)
		sha = $7; gsub(/`/, "", sha)
		print doc "\t" url "\t" sha
	}
' "$README" > "$tmp_manifest"

while IFS='	' read -r doc url expected_sha; do
	[ -n "$doc" ] || continue

	# If specific documents requested, filter
	if [ $# -gt 0 ]; then
		match=0
		for arg in "$@"; do
			if [ "$arg" = "$doc" ]; then
				match=1
				break
			fi
		done
		[ "$match" -eq 1 ] || continue
	fi

	target="$DIR/$doc"

	if [ -f "$target" ]; then
		actual_sha=$(calc_sha256 "$target")
		if [ "$actual_sha" = "$expected_sha" ]; then
			printf '%s: ok (already present)\n' "$doc"
			continue
		else
			printf '%s: checksum mismatch, refetching...\n' "$doc" >&2
		fi
	fi

	printf 'fetching %s from %s...\n' "$doc" "$url"
	if command -v curl >/dev/null 2>&1; then
		curl -fsSL "$url" -o "$target"
	elif command -v wget >/dev/null 2>&1; then
		wget -qO "$target" "$url"
	else
		echo "fetch: curl or wget required" >&2
		exit 1
	fi

	actual_sha=$(calc_sha256 "$target")
	if [ "$actual_sha" != "$expected_sha" ]; then
		printf 'FAIL: %s checksum mismatch (expected %s, got %s)\n' "$doc" "$expected_sha" "$actual_sha" >&2
		rm -f "$target"
		failures=$((failures + 1))
	else
		printf '%s: verified\n' "$doc"
	fi
done < "$tmp_manifest"

exit "$failures"

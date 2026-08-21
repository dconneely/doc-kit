#!/bin/sh
# doc-kit-check — verify a repository against SPECIFICATION.md.
#
# Usage:  sh tools/doc-kit-check.sh [check ...]
#         with no arguments, runs every check
#
# Checks: map    §2.2-2.5  the map is complete, consistent and customised
#         adr    §3.1      records are numbered, statused and structured
#         plan   §3.3      the plan has not become a graveyard
#
# Exits 0 if clean, 1 if anything failed. Run it by hand: nothing in this kit
# requires it, and a repository that holds these properties without ever
# running it is conformant (SPECIFICATION.md §6).
#
# On Windows use `sh`, not `bash` — the `bash` on PATH is usually WSL's, which
# sees a different filesystem and will report every file missing.

set -eu

MAP=DOC-MAP.md
# Excluded from §2.4 by §2.8 (templates are not instances) and §5.1 (archives).
EXCLUDE_PREFIXES='templates/ docs/archive/'

failures=0
current=''

group() { current=$1; }
fail() {
	failures=$((failures + 1))
	printf '%s\n' "FAIL [$current] $1" >&2
	[ $# -gt 1 ] && printf '       %s\n' "$2" >&2
	return 0
}

# section FILE HEADING — the lines under a "## Heading" up to the next "## "
section() {
	awk -v h="$2" '$0 == h { f = 1; next } /^## / && f { exit } f' "$1"
}

# First backticked cell of each table row: the artifact's path.
# shellcheck disable=SC2016  # the backticks are literal Markdown, not command substitution
table_paths() {
	section "$MAP" "$1" | sed -n 's/^| `\([^`]*\)`.*/\1/p'
}

# The layout block is an indented tree; rebuild full paths from it.
layout_paths() {
	awk '/^```text/ { f = 1; next } /^```/ { if (f) exit } f' "$MAP" | awk '
		/^[^ \t]+\/[ \t]*$/ { split($0, a, /[ \t]/); prefix = a[1]; next }
		/^[^ \t]/          { prefix = ""; print $1; next }
		/^[ \t]+[^ \t]/    { print prefix $1 }
	'
}

# A trailing / and a trailing /* denote the same artifact (§2.2).
norm() { sed 's:/\*$:/:'; }

# True when PATTERN matches at least one existing path.
pattern_exists() {
	# Unquoted, so the shell expands the glob.
	# shellcheck disable=SC2086
	set -- $1
	[ -e "$1" ]
}

excluded() {
	for prefix in $EXCLUDE_PREFIXES; do
		case "$1" in "$prefix"*) return 0 ;; esac
	done
	return 1
}

# ---------------------------------------------------------------- map

check_map() {
	group map

	[ -f "$MAP" ] || { fail "no map at $MAP" "§2.1 requires one in the repository root"; return; }

	arts=$(table_paths '## Artifacts' | norm | sort)
	lifes=$(table_paths '## Lifecycle' | norm | sort)
	lays=$(layout_paths | norm | sort)

	[ -n "$arts" ] || fail "the artifacts table names nothing" "§2.2 — is the heading exactly '## Artifacts'?"

	# §2.2 — all three lists name the same set, artifacts table authoritative.
	# Globbing off: these lists contain patterns like docs/adr/*.md, and an
	# unquoted loop would expand them into the files they match.
	set -f
	for a in $arts; do
		printf '%s\n' "$lifes" | grep -qxF "$a" ||
			fail "$a is in the artifacts table but not the lifecycle table" "§2.2"
		printf '%s\n' "$lays" | grep -qxF "$a" ||
			fail "$a is in the artifacts table but not the layout block" "§2.2"
	done
	for l in $lifes; do
		printf '%s\n' "$arts" | grep -qxF "$l" ||
			fail "$l is in the lifecycle table but not the artifacts table" "§2.2 — the table is authoritative"
	done

	# §2.3 — every artifact the map names exists.
	for a in $arts; do
		set +f
		pattern_exists "$a" ||
			fail "the map names $a but nothing matches it" "§2.3 — create it, or remove the row"
		set -f
	done

	# §2.4 — every documentation file appears in the map.
	set +f
	files=$(find . -name '*.md' ! -path './.git/*' | sed 's:^\./::' | sort)
	set -f
	for f in $files; do
		excluded "$f" && continue
		hit=1
		for a in $arts; do
			# shellcheck disable=SC2254
			case "$f" in $a|"${a%/}"/*) hit=0; break ;; esac
		done
		[ "$hit" -eq 0 ] ||
			fail "$f is not named in the map" "§2.4 — add a row, or move it under an archive"
	done
	set +f

	# §2.7 — tense and durability come from closed sets, and no two artifacts share all three
	# properties. Free text defeats the test: near-duplicates escape on phrasing. Aliases, which
	# hold no content of their own, are exempt.
	rows=$(section "$MAP" '## Artifacts' | grep '^| `' | grep -v '\*\*Alias\*\*' |
		awk -F' *\\| *' '{ print $2 "~" $4 "~" $5 "~" $6 }')
	oldifs=$IFS
	IFS='
'
	for row in $rows; do
		IFS=$oldifs
		tense=$(printf '%s' "$row" | cut -d'~' -f2)
		dur=$(printf '%s' "$row" | cut -d'~' -f3)
		art=$(printf '%s' "$row" | cut -d'~' -f1)
		case "$tense" in
			present|past|future|imperative|explanatory) ;;
			*) fail "$art has tense '$tense'" "§2.7 — present, past, future, imperative, explanatory" ;;
		esac
		case "$dur" in
			"rewritten in place"|append-only|immutable|volatile|disposable) ;;
			*) fail "$art has durability '$dur'" "§2.7 — see the permitted set" ;;
		esac
		IFS='
'
	done
	IFS=$oldifs

	for key in $(printf '%s\n' "$rows" | cut -d'~' -f2- | sort | uniq -d | tr ' ' '_'); do
		fail "two artifacts share [$(printf '%s' "$key" | tr '_' ' ' | tr '~' '|')]" \
			"§2.7 — merge them, or mark one an alias"
	done

	# §2.5 — customisation actually happened.
	grep -q 'This file is a template' "$MAP" &&
		fail "the map still carries template text" "§2.5"
	return 0
}

# ---------------------------------------------------------------- adr

check_adr() {
	group adr
	dir=docs/adr
	[ -d "$dir" ] || return 0

	for f in "$dir"/*.md; do
		[ -e "$f" ] || continue
		base=$(basename "$f")
		case "$base" in 0000-*) continue ;; esac

		echo "$base" | grep -qE '^[0-9]{4}-[a-z0-9]+(-[a-z0-9]+)*\.md$' ||
			fail "$f is misnamed" "§3.1 — NNNN-kebab-case-title.md"

		status=$(sed -n 's/^status: *"\{0,1\}\([^"]*\)"\{0,1\} *$/\1/p' "$f" | head -n 1)
		[ -n "$status" ] || fail "$f has no status" "§3.1 — MADR front-matter"

		case "$status" in
			proposed|rejected|accepted|deprecated) ;;
			"superseded by ADR-"[0-9][0-9][0-9][0-9]) ;;
			"accepted (refined by ADR-"[0-9][0-9][0-9][0-9]")") ;;
			'') ;;
			*) fail "$f has status '$status'" "§3.1 — see the table of permitted values" ;;
		esac

		# A forward pointer must name a record that exists.
		target=$(printf '%s' "$status" | sed -n 's/.*ADR-\([0-9]\{4\}\).*/\1/p')
		if [ -n "$target" ] && ! ls "$dir/$target"-*.md >/dev/null 2>&1; then
			fail "$f points at ADR-$target, which does not exist" "§3.1"
		fi

		grep -q '^date:' "$f" || fail "$f has no date" "§3.1"
		[ "$status" = proposed ] || grep -q '^decision-makers: *[^ ]' "$f" ||
			fail "$f is '$status' but names no decision-makers" "§3.1 — who decided?"

		for heading in '## Context and Problem Statement' '## Considered Options' '## Decision Outcome'; do
			grep -qF "$heading" "$f" || fail "$f has no '$heading'" "§3.1 — MADR minimal template"
		done
	done

	dupes=$(for f in "$dir"/*.md; do
		[ -e "$f" ] || continue
		basename "$f" | sed -n 's/^\([0-9]\{4\}\)-.*/\1/p'
	done | sort | uniq -d)
	for d in $dupes; do fail "ADR number $d is used more than once" "§3.1 — numbers are unique"; done
	return 0
}

# ---------------------------------------------------------------- plan

check_plan() {
	group plan
	[ -f PLAN.md ] || return 0

	# Loops feed from a variable, not a pipe: a piped `while` runs in a subshell, so increments to
	# `failures` are lost and the exit code stays 0 while the failure prints.
	oldifs=$IFS
	for hit in $(IFS='
'; grep -nE '^#+ .*(~~|\bDONE\b|\[x\]|\bCOMPLETED?\b)' PLAN.md | tr ' ' '_'); do
		IFS=$oldifs
		fail "PLAN.md:${hit%%:*} looks like a completed entry" "§3.3 — delete entries when done, do not annotate"
	done
	IFS=$oldifs

	for line in $(grep -nE '^\*Type:' PLAN.md | tr ' ' '_'); do
		no=${line%%:*}
		printf '%s' "${line#*:}" | tr '_' ' ' | grep -qE '^\*Type: (bug|debt|feature|docs)( |—)' ||
			fail "PLAN.md:$no has no valid type tag" "§3.3 — bug, debt, feature or docs"
	done
	return 0
}

# ---------------------------------------------------------------- main

[ $# -gt 0 ] || set -- map adr plan
for want in "$@"; do
	case "$want" in
		map) check_map ;;
		adr) check_adr ;;
		plan) check_plan ;;
		*) printf 'unknown check: %s (map, adr, plan)\n' "$want" >&2; exit 2 ;;
	esac
done

if [ "$failures" -eq 0 ]; then
	printf 'doc-kit: conformant (%s)\n' "$*"
else
	printf '\ndoc-kit: %s failure(s)\n' "$failures" >&2
	exit 1
fi

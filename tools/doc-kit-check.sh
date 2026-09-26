#!/bin/sh
# doc-kit-check - verify a repository against SPECIFICATION.md.
#
# Usage:  sh tools/doc-kit-check.sh [check ...]
#         with no arguments, runs every check
#
# Checks: map    §2.2-2.7  the map is complete, consistent and customised
#         adr    §3.1      records are numbered, statused and structured
#         plan   §3.3      the plan has not become a graveyard
#
# Exits 0 if clean, 1 if anything failed. Run it by hand: nothing in this kit
# requires it, and a repository that holds these properties without ever
# running it is conformant (SPECIFICATION.md §6).
#
# On Windows use `sh`, not `bash` - the `bash` on PATH is usually WSL's, which
# sees a different filesystem and will report every file missing.
#
# An unmapped gitignored file is a WARN, never a FAIL (§2.9), grouped by its
# top-level directory so a vendored tree reports once. Telling ignored from
# tracked needs `git`; without it, every unmapped file is a FAIL.

set -eu

MAP=DOC-MAP.md
NL='
'

failures=0
warnings=0
current=''

group() { current=$1; }
fail() {
	failures=$((failures + 1))
	printf '%s\n' "FAIL [$current] $1" >&2
	[ $# -gt 1 ] && printf '       %s\n' "$2" >&2
	return 0
}
warn() {
	warnings=$((warnings + 1))
	printf '%s\n' "WARN [$current] $1" >&2
	[ $# -gt 1 ] && printf '       %s\n' "$2" >&2
	return 0
}

# Filter stdin (one path per line) to the gitignored ones. Prints nothing when
# git is missing or this is not a work tree.
ignored_of() {
	if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		git -c core.quotePath=false check-ignore --stdin || true
	else
		cat >/dev/null
	fi
}

# section FILE HEADING - the lines under a "## Heading" up to the next "## "
section() {
	awk -v h="$2" '$0 == h { f = 1; next } /^## / && f { exit } f' "$1"
}

# First backticked cell of each table row: the artifact's path.
# shellcheck disable=SC2016  # the backticks are literal Markdown, not command substitution
table_paths() {
	section "$MAP" "$1" | sed -n 's/^| `\([^`]*\)`.*/\1/p'
}

# The layout block is an indented tree; rebuild full paths with a prefix stack
# keyed on indentation. Only a bare `name/` line is a container. A directory
# followed by description text is a leaf: one artifact, matching a `name/*` row.
layout_paths() {
	awk '/^```text/ { f = 1; next } /^```/ { if (f) exit } f' "$MAP" | awk '
		{
			line = $0
			indent = 0
			while (indent < length(line) && substr(line, indent + 1, 1) ~ /[ \t]/) indent++
			rest = substr(line, indent + 1)
			if (rest == "") next

			while (depth > 0 && stack_indent[depth] >= indent) depth--

			prefix = ""
			for (i = 1; i <= depth; i++) prefix = prefix stack_name[i]

			if (rest ~ /^[^ \t]+\/[ \t]*$/) {
				split(rest, a, /[ \t]/)
				depth++
				stack_indent[depth] = indent
				stack_name[depth] = a[1]
				next
			}

			split(rest, a, /[ \t]/)
			print prefix a[1]
		}
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

# ---------------------------------------------------------------- map

check_map() {
	group map

	[ -f "$MAP" ] || { fail "no map at $MAP" "§2.1 requires one in the repository root"; return; }

	arts=$(table_paths '## Artifacts' | norm | sort)
	lifes=$(table_paths '## Lifecycle' | norm | sort)
	lays=$(layout_paths | norm | sort)

	[ -n "$arts" ] || fail "the artifacts table names nothing" "§2.2 - is the heading exactly '## Artifacts'?"

	# §2.2 - all three lists name the same set, artifacts table authoritative.
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
			fail "$l is in the lifecycle table but not the artifacts table" "§2.2 - the table is authoritative"
	done

	# §2.3 - every artifact the map names exists.
	for a in $arts; do
		set +f
		pattern_exists "$a" ||
			fail "the map names $a but nothing matches it" "§2.3 - create it, or remove the row"
		set -f
	done

	# §2.4 - every documentation file appears in the map. Files below the conventional
	# archive are not documentation files (§5.1); an archive elsewhere is covered by its map
	# entry. Split on newlines only, so a path may contain spaces.
	set +f
	files=$(find . -name '*.md' ! -path './.git/*' ! -path './docs/archive/*' | sed 's:^\./::' | sort)
	set -f
	unmapped=''
	oldifs=$IFS
	IFS=$NL
	for f in $files; do
		hit=1
		for a in $arts; do
			# shellcheck disable=SC2254
			case "$f" in $a|"${a%/}"/*) hit=0; break ;; esac
		done
		[ "$hit" -eq 0 ] || unmapped="$unmapped$f$NL"
	done
	ignored=$(printf '%s' "$unmapped" | ignored_of)
	for f in $unmapped; do
		printf '%s\n' "$ignored" | grep -qxF "$f" ||
			fail "$f is not named in the map" "§2.4 - add a row, or move it under an archive"
	done
	for g in $(printf '%s\n' "$ignored" | awk -F/ '
		NF {
			k = (NF > 1) ? $1 "/" : $0
			if (!(k in n)) { first[k] = $0; order[++c] = k }
			n[k]++
		}
		END { for (i = 1; i <= c; i++) { k = order[i]; print (n[k] == 1) ? first[k] : k " (" n[k] " files)" } }
	'); do
		IFS=$oldifs
		warn "$g is not named in the map (gitignored)" "§2.9 - advisory; add a row to map it"
	done
	IFS=$oldifs
	set +f

	# §2.7 - tense and durability come from closed sets, and no two artifacts share all three
	# properties. Free text defeats the test: near-duplicates escape on phrasing. Aliases, which
	# hold no content of their own, are exempt.
	rows=$(section "$MAP" '## Artifacts' | grep '^| `' | grep -v '\*\*Alias\*\*' |
		awk -F' *\\| *' '{ print $2 "~" $4 "~" $5 "~" $6 }')
	oldifs=$IFS
	IFS=$NL
	for row in $rows; do
		IFS=$oldifs
		tense=$(printf '%s' "$row" | cut -d'~' -f2)
		dur=$(printf '%s' "$row" | cut -d'~' -f3)
		art=$(printf '%s' "$row" | cut -d'~' -f1 | tr -d '`')
		case "$tense" in
			present|past|future|imperative|explanatory) ;;
			*) fail "$art has tense '$tense'" "§2.7 - present, past, future, imperative, explanatory" ;;
		esac
		case "$dur" in
			"rewritten in place"|append-only|immutable|volatile|disposable) ;;
			*) fail "$art has durability '$dur'" "§2.7 - see the permitted set" ;;
		esac
		IFS=$NL
	done
	IFS=$oldifs

	for key in $(printf '%s\n' "$rows" | cut -d'~' -f2- | sort | uniq -d | tr ' ' '_'); do
		fail "two artifacts share [$(printf '%s' "$key" | tr '_' ' ' | tr '~' '|')]" \
			"§2.7 - merge them, or mark one an alias"
	done

	# §2.5 - customisation actually happened.
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
			fail "$f is misnamed" "§3.1 - NNNN-kebab-case-title.md"

		status=$(sed -n 's/^status: *"\{0,1\}\([^"]*\)"\{0,1\} *$/\1/p' "$f" | head -n 1)
		[ -n "$status" ] || fail "$f has no status" "§3.1 - MADR front-matter"

		case "$status" in
			proposed|rejected|accepted|deprecated) ;;
			"superseded by ADR-"[0-9][0-9][0-9][0-9]) ;;
			"accepted (refined by ADR-"[0-9][0-9][0-9][0-9]")") ;;
			'') ;;
			*) fail "$f has status '$status'" "§3.1 - see the table of permitted values" ;;
		esac

		# A forward pointer must name a record that exists.
		target=$(printf '%s' "$status" | sed -n 's/.*ADR-\([0-9]\{4\}\).*/\1/p')
		if [ -n "$target" ] && ! ls "$dir/$target"-*.md >/dev/null 2>&1; then
			fail "$f points at ADR-$target, which does not exist" "§3.1"
		fi

		grep -q '^date:' "$f" || fail "$f has no date" "§3.1"
		[ "$status" = proposed ] || grep -q '^decision-makers: *[^ ]' "$f" ||
			fail "$f is '$status' but names no decision-makers" "§3.1 - who decided?"

		for heading in '## Context and Problem Statement' '## Considered Options' '## Decision Outcome'; do
			grep -qF "$heading" "$f" || fail "$f has no '$heading'" "§3.1 - MADR minimal template"
		done
	done

	dupes=$(for f in "$dir"/*.md; do
		[ -e "$f" ] || continue
		basename "$f" | sed -n 's/^\([0-9]\{4\}\)-.*/\1/p'
	done | sort | uniq -d)
	for d in $dupes; do fail "ADR number $d is used more than once" "§3.1 - numbers are unique"; done
	return 0
}

# ---------------------------------------------------------------- plan

check_plan() {
	group plan
	[ -f PLAN.md ] || return 0

	# One awk pass: `done N` for a heading marked complete, `type N` for an entry (a `##` heading)
	# with no valid type tag beneath it. Lowercase "done" counts only when set off as a marker -
	# "(done)", "- done" - so a title like "Define done" passes.
	hits=$(awk '
		function flush() { if (h && !t) print "type " h }
		/^#+ / {
			l = tolower($0)
			if (l ~ /~~|\[x\]|[(\[](done|completed?)[)\]]|[-:] *(done|completed?) *$/ ||
				$0 ~ /(^|[^A-Za-z])(DONE|COMPLETED?)([^A-Za-z]|$)/) print "done " NR
		}
		/^## / { flush(); h = NR; t = 0; next }
		/^\*\*Type:\*\* (bug|debt|feature|docs)([ -]|$)/ { t = 1 }
		END { flush() }
	' PLAN.md)

	# Fed from a variable, not a pipe: a piped `while` runs in a subshell, and increments to
	# `failures` would be lost.
	set -f
	oldifs=$IFS
	IFS=$NL
	for hit in $hits; do
		IFS=$oldifs
		no=${hit#* }
		case "$hit" in
			done*) fail "PLAN.md:$no looks like a completed entry" "§3.3 - delete entries when done, do not annotate" ;;
			type*) fail "PLAN.md:$no has no valid type tag" "§3.3 - bug, debt, feature or docs" ;;
		esac
	done
	IFS=$oldifs
	set +f
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
	if [ "$warnings" -eq 0 ]; then
		printf 'doc-kit: conformant (%s)\n' "$*"
	else
		printf 'doc-kit: conformant (%s) - %s gitignored warning(s), see above\n' "$*" "$warnings"
	fi
else
	printf '\ndoc-kit: %s failure(s)' "$failures" >&2
	[ "$warnings" -eq 0 ] || printf ', %s gitignored warning(s)' "$warnings" >&2
	printf '\n' >&2
	exit 1
fi

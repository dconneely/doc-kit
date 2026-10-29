#!/bin/sh
# Tests for tools/doc-kit-check.sh. Each case builds a small passing repository in a temporary
# directory, breaks one thing, and asserts the exit code and a line of output.
#
# Usage:  sh tests/doc-kit-check.test.sh
#
# shellcheck disable=SC2016  # backticks throughout are literal Markdown

set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
CHECK="$ROOT/tools/doc-kit-check.sh"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

passed=0
failed=0
n=0

# fixture - a fresh passing repository in $dir, and cd into it.
fixture() {
	n=$((n + 1))
	dir="$TMP/$n"
	mkdir -p "$dir/docs/decisions"
	cd "$dir"
	cat >DOC-MAP.md <<'EOF'
# Documentation map

## Layout

```text
DOC-MAP.md     the map
docs/
  plan.md      the plan
  decisions/*.md  decisions
```

## Artifacts

| Artifact              | Purpose   | Tense   | Mutability         | Audience    |
| --------------------- | --------- | ------- | ------------------ | ----------- |
| `DOC-MAP.md`          | the map   | present | rewritten in place | contributor |
| `docs/plan.md`        | backlog   | future  | volatile           | owner       |
| `docs/decisions/*.md` | decisions | past    | immutable          | owner, contributor |

## Lifecycle

| Artifact        | Created when | Removed when |
| --------------- | ------------ | ------------ |
| `DOC-MAP.md`    | start        | never        |
| `docs/plan.md`       | start        | never        |
| `docs/decisions/*.md` | a choice     | never        |
EOF
	cat >docs/plan.md <<'EOF'
# Plan

## Do a thing

**Type:** feature - **Importance:** low - **Effort:** low

One paragraph.
EOF
	adr 0001 accepted 'decision-makers: someone
approval: "accept ADR-0001"'
}

# adr NUMBER STATUS [EXTRA-FRONT-MATTER]
adr() {
	cat >"docs/decisions/$1-a-record.md" <<EOF
---
status: $2
date: 2026-01-01
${3:-}
---

# $1. A record

## Context and Problem Statement

## Considered Options

## Decision Outcome
EOF
}

# after REGEX LINE - insert LINE into the map after the line matching REGEX. awk, not sed: BSD
# sed does not expand a newline in a replacement.
after() {
	awk -v re="$1" -v add="$2" '{ print } $0 ~ re { print add }' DOC-MAP.md >DOC-MAP.tmp
	mv DOC-MAP.tmp DOC-MAP.md
}

# expect NAME CODE PATTERN [CHECK ...] - run the checker, assert its exit code, and that its
# combined output contains PATTERN (a fixed string).
expect() {
	name=$1 code=$2 pattern=$3
	shift 3
	set +e
	out=$(sh "$CHECK" "$@" 2>&1)
	got=$?
	set -e
	if [ "$got" -eq "$code" ] && printf '%s\n' "$out" | grep -qF -- "$pattern"; then
		passed=$((passed + 1))
	else
		failed=$((failed + 1))
		printf 'not ok - %s (exit %s, wanted %s; output lacks "%s")\n%s\n\n' \
			"$name" "$got" "$code" "$pattern" "$out"
	fi
}

# refute NAME PATTERN [CHECK ...] - run the checker and assert exit 0 and that its output does not
# contain PATTERN (a fixed string).
refute() {
	name=$1 pattern=$2
	shift 2
	set +e
	out=$(sh "$CHECK" "$@" 2>&1)
	got=$?
	set -e
	if [ "$got" -eq 0 ] && ! printf '%s\n' "$out" | grep -qF -- "$pattern"; then
		passed=$((passed + 1))
	else
		failed=$((failed + 1))
		printf 'not ok - %s (exit %s, wanted 0, or output contains "%s")\n%s\n\n' \
			"$name" "$got" "$pattern" "$out"
	fi
}

# ---------------------------------------------------------------- map

fixture
expect "clean fixture passes" 0 "doc-kit: checks passed (map adr plan)"

fixture
echo x >notes.md
expect "unmapped file fails" 1 "FAIL [map] notes.md is not named in the map" map

fixture
mkdir -p templates
echo x >templates/notes.md
expect "templates/ is exempt without a row" 0 "checks passed" map

fixture
mkdir -p old
echo x >old/stale.md
after '^DOC-MAP.md ' 'old/           archive, not authoritative'
after '^[|] `docs/plan.md` +[|] backlog' '| `old/` | archive | past | immutable | contributor |'
after '^[|] `docs/plan.md` +[|] start' '| `old/` | archived | never |'
expect "an archive at any mapped path covers its files" 0 "checks passed" map

fixture
mkdir -p docs/archive
echo x >docs/archive/stale.md
expect "docs/archive/ is exempt without a row" 0 "checks passed" map

fixture
echo x >"docs/decisions/0002 old notes.md"
echo x >"loose notes.md"
expect "a mapped path with spaces passes" 1 "FAIL [map] loose notes.md is not named in the map" map
expect "a path with spaces is not split" 1 "doc-kit: 1 failure(s)" map

fixture
git init -q .
printf 'vendor/** linguist-vendored\nvendor/ours/** -linguist-vendored\nthird/** linguist-vendored=false\n' >.gitattributes
mkdir -p vendor/lib vendor/ours third
echo x >vendor/lib/README.md
echo x >vendor/ours/notes.md
echo x >third/README.md
expect "vendored tree is skipped" 1 "doc-kit: 2 failure(s)" map
expect "unset attribute is not vendored" 1 "FAIL [map] vendor/ours/notes.md is not named" map
expect "linguist-vendored=false is not vendored" 1 "FAIL [map] third/README.md is not named" map

fixture
git init -q .
printf 'vendor/\n' >.gitignore
printf 'vendor/** linguist-vendored\n' >.gitattributes
mkdir -p vendor/lib
echo x >vendor/lib/README.md
expect "gitignored and vendored is skipped silently" 0 "doc-kit: checks passed (map)" map

fixture
git init -q .
printf 'node_modules/\nscratch.md\n' >.gitignore
mkdir -p node_modules/a node_modules/b
echo x >node_modules/a/README.md
echo x >node_modules/b/README.md
echo x >scratch.md
expect "gitignored directory warns once, grouped" 0 "WARN [map] node_modules/ (2 files)" map
expect "gitignored file warns by name" 0 "WARN [map] scratch.md is not named" map

fixture
sed -i.bak '\#^| `docs/plan.md` *| start#d' DOC-MAP.md
expect "artifact missing from lifecycle fails" 1 "docs/plan.md is in the artifacts table but not the lifecycle table" map

fixture
sed -i.bak '/^  plan.md /d' DOC-MAP.md
expect "artifact missing from layout fails" 1 "docs/plan.md is in the artifacts table but not the layout block" map

fixture
rm docs/plan.md
expect "named artifact missing on disk fails" 1 "the map names docs/plan.md but nothing matches it" map

fixture
sed -i.bak 's/| future  | volatile /| later   | volatile /' DOC-MAP.md
expect "tense outside the closed set fails" 1 "docs/plan.md has tense 'later'" map

fixture
sed -i.bak 's/| future  | volatile           | owner /| past | immutable | contributor, owner /' DOC-MAP.md
expect "artifacts sharing all properties warn, in any role order" 0 	"WARN [map] docs/plan.md, docs/decisions/*.md share [past | immutable | contributor, owner]" map

fixture
echo x >docs/testing.md
after '^DOC-MAP.md ' 'docs/testing.md test'
after '^[|] `DOC-MAP.md` ' '| `docs/testing.md` | test | present | rewritten in place | contributor |'
after '^[|] `DOC-MAP.md` +[|] start' '| `docs/testing.md` | start | never |'
refute "standard ratified pair does not warn" "WARN [map]" map

fixture
echo x >docs/archive.md
echo x >docs/decisions.md
after '^DOC-MAP.md ' 'docs/archive.md archive'
after '^DOC-MAP.md ' 'docs/decisions.md index'
after '^[|] `DOC-MAP.md` ' '| `docs/archive.md` | archive | present | rewritten in place | owner, contributor |'
after '^[|] `DOC-MAP.md` ' '| `docs/decisions.md` | index | present | rewritten in place | owner, contributor |'
after '^[|] `DOC-MAP.md` +[|] start' '| `docs/archive.md` | start | never |'
after '^[|] `DOC-MAP.md` +[|] start' '| `docs/decisions.md` | start | never |'
refute "standard archive and index pair does not warn" "WARN [map]" map

fixture
cp "$ROOT/templates/DOC-MAP.md" DOC-MAP.md
rm -rf docs
mkdir -p docs/decisions docs/research docs/plan docs/howto docs/sources docs/archive
: >README.md
: >AGENTS.md
: >CLAUDE.md
: >CHANGELOG.md
: >docs/spec.md
: >docs/decisions.md
: >docs/decisions/0001-a-record.md
: >docs/plan.md
: >docs/quirks.md
: >docs/research/0001-a-note.md
: >docs/glossary.md
: >docs/testing.md
: >docs/plan/a-note.md
: >docs/plan/0000-template.md
: >docs/howto.md
: >docs/howto/a-guide.md
: >docs/sources.md
: >docs/archive.md
refute "the template map passes as an instance" "WARN [map]" map

fixture
sed -i.bak 's/| volatile           | owner /| volatile | the team /' DOC-MAP.md
expect "audience outside the closed set fails" 1 "docs/plan.md has audience 'the team'" map

fixture
sed -i.bak 's/| rewritten in place | contributor /| rewritten in place | contributor (agents) /' DOC-MAP.md
expect "a role marked for agents only passes" 0 "doc-kit: checks passed (map)" map

fixture
echo 'This file is a template.' >>DOC-MAP.md
expect "surviving template text fails" 1 "the map still carries template text" map

# ---------------------------------------------------------------- adr

fixture
adr 0002 Accepted 'decision-makers: someone'
expect "title-case status fails" 1 "has status 'Accepted'" adr

fixture
adr 0002 accepted
expect "accepted record without decision-makers fails" 1 "names no decision-makers" adr

fixture
adr 0002 proposed
expect "proposed record needs no decision-makers" 0 "checks passed" adr

fixture
adr 0002 accepted 'decision-makers: someone'
expect "accepted record without approval fails" 1 "is 'accepted' but has no approval" adr

fixture
adr 0002 accepted 'decision-makers: {the owner}
approval: "accept ADR-0002"'
expect "placeholder decision-makers fails" 1 "names no decision-makers" adr

fixture
adr 0002 'accepted (refined by ADR-0001)' 'decision-makers: someone
approval: "accept ADR-0002"'
expect "refined-by status fails" 1 "has status 'accepted (refined by ADR-0001)'" adr

fixture
printf '
See ADR-0099.
' >>docs/plan.md
expect "citation of a missing record fails" 1 "docs/plan.md:9 cites ADR-0099, which does not exist" adr

fixture
printf '
See ADR-0001, or `ADR-0099`, or [ADR-0099](https://example.com/0099).
' >>docs/plan.md
expect "citations in code and in links to other sites pass" 0 "checks passed" adr

fixture
printf '
See ADR 12.
' >>docs/plan.md
expect "citation in another form fails" 1 "docs/plan.md:9 cites 'ADR 12'" adr

fixture
adr 0002 'superseded by ADR-0001' 'decision-makers: someone'
expect "superseded status fails" 1 "has status 'superseded by ADR-0001'" adr

fixture
cp docs/decisions/0001-a-record.md docs/decisions/0001-another.md
expect "reused number fails" 1 "ADR number 0001 is used more than once" adr

fixture
cp docs/decisions/0001-a-record.md docs/decisions/0002-Bad_Name.md
expect "misnamed record fails" 1 "is misnamed" adr

fixture
sed -i.bak '/^## Considered Options/d' docs/decisions/0001-a-record.md
rm docs/decisions/0001-a-record.md.bak
expect "record missing a MADR heading fails" 1 "has no '## Considered Options'" adr

fixture
adr 0002 accepted 'decision-makers: someone
approval: "accept ADR-0002"'
sed -i.bak '/^status:/d' docs/decisions/0002-a-record.md
rm docs/decisions/0002-a-record.md.bak
expect "record with no status fails" 1 "docs/decisions/0002-a-record.md has no status" adr

fixture
: >docs/decisions/0002-empty.md
expect "empty record fails" 1 "docs/decisions/0002-empty.md has no status" adr

fixture
printf 'See ADR-0099.\n' >"loose notes.md"
expect "citation in a path with spaces names the whole path" 1 "loose notes.md:1 cites ADR-0099" adr

fixture
mkdir -p tools
cp "$ROOT/tools/doc-kit-index-decisions.sh" tools/
sh tools/doc-kit-index-decisions.sh docs/decisions.md docs/decisions
expect "valid generated decisions index passes" 0 "checks passed" adr

fixture
mkdir -p tools
cp "$ROOT/tools/doc-kit-index-decisions.sh" tools/
echo "stale" >docs/decisions.md
expect "out-of-date generated decisions index fails" 1 "docs/decisions.md is out of date" adr

fixture
mkdir -p tools
cp "$ROOT/tools/doc-kit-index-decisions.sh" tools/
sh tools/doc-kit-index-decisions.sh docs/decisions/README.md docs/decisions
expect "valid legacy decisions/README.md passes" 0 "checks passed" adr

# ---------------------------------------------------------------- plan

fixture
printf '\n## Old thing DONE\n\n**Type:** bug\n\nDone.\n' >>docs/plan.md
expect "heading marked DONE fails" 1 "docs/plan.md:9 looks like a completed entry" plan

fixture
printf '\n## Old thing (done)\n\n**Type:** bug\n\nDone.\n' >>docs/plan.md
expect "heading marked (done) fails" 1 "looks like a completed entry" plan

fixture
printf '\n## ~~Old thing~~\n\n**Type:** bug\n\nDone.\n' >>docs/plan.md
expect "struck-through heading fails" 1 "looks like a completed entry" plan

fixture
printf '\n## Define what done means\n\n**Type:** docs\n\nOne paragraph.\n' >>docs/plan.md
expect "the word done in a title passes" 0 "checks passed" plan

fixture
printf '\n## Untagged\n\nOne paragraph.\n' >>docs/plan.md
expect "entry with no type tag fails" 1 "docs/plan.md:9 has no valid type tag" plan

fixture
printf '\n## Wrong tag\n\n**Type:** chore\n\nOne paragraph.\n' >>docs/plan.md
expect "entry with an invalid type tag fails" 1 "docs/plan.md:9 has no valid type tag" plan

fixture
printf '\n## Bare tag\n\n**Type:** bug\n\nOne paragraph.\n' >>docs/plan.md
expect "type tag alone on its line passes" 0 "checks passed" plan

# ---------------------------------------------------------------- cli

fixture
expect "unknown check exits 2" 2 "unknown check: nope" nope

# ---------------------------------------------------------------- value sets

# The checker's closed sets must match the template map's Property values table.
template_values=$(awk -F'|' '
	/^\| (Tense|Mutability|Audience) / {
		v = $3
		while (match(v, /`[^`]*`/)) {
			print substr(v, RSTART + 1, RLENGTH - 2)
			v = substr(v, RSTART + RLENGTH)
		}
	}
' "$ROOT/templates/DOC-MAP.md" | sort)
checker_values=$(
	{
		grep -F 'split("present ' "$CHECK" | sed -E 's/.*split\("([^"]*)".*/\1/' | tr ' ' '\n'
		grep -F 'split("rewritten in place|' "$CHECK" | sed -E 's/.*split\("([^"]*)".*/\1/' | tr '|' '\n'
		grep -F 'split("owner ' "$CHECK" | sed -E 's/.*split\("([^"]*)".*/\1/' | tr ' ' '\n'
	} | sed '/^$/d' | sort
)
if [ "$template_values" = "$checker_values" ]; then
	passed=$((passed + 1))
else
	failed=$((failed + 1))
	printf 'not ok - checker value sets differ from the template\n--- template ---\n%s\n--- checker ---\n%s\n\n' \
		"$template_values" "$checker_values"
fi

printf '%s passed, %s failed\n' "$passed" "$failed"
[ "$failed" -eq 0 ]

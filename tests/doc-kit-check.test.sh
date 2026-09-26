#!/bin/sh
# Tests for tools/doc-kit-check.sh. Each case builds a small conformant repository in a temporary
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

# fixture - a fresh conformant repository in $dir, and cd into it.
fixture() {
	n=$((n + 1))
	dir="$TMP/$n"
	mkdir -p "$dir/docs/adr"
	cd "$dir"
	cat >DOC-MAP.md <<'EOF'
# Documentation map

## Layout

```text
DOC-MAP.md     the map
PLAN.md        the plan
docs/
  adr/*.md     decisions
```

## Artifacts

| Artifact        | Purpose   | Tense   | Mutability         | Audience    |
| --------------- | --------- | ------- | ------------------ | ----------- |
| `DOC-MAP.md`    | the map   | present | rewritten in place | anyone      |
| `PLAN.md`       | backlog   | future  | volatile           | the team    |
| `docs/adr/*.md` | decisions | past    | immutable          | maintainers |

## Lifecycle

| Artifact        | Created when | Removed when |
| --------------- | ------------ | ------------ |
| `DOC-MAP.md`    | start        | never        |
| `PLAN.md`       | start        | never        |
| `docs/adr/*.md` | a choice     | never        |
EOF
	cat >PLAN.md <<'EOF'
# Plan

## Do a thing

**Type:** feature - **Importance:** low - **Effort:** low

One paragraph.
EOF
	adr 0001 accepted 'decision-makers: someone'
}

# adr NUMBER STATUS [EXTRA-FRONT-MATTER]
adr() {
	cat >"docs/adr/$1-a-record.md" <<EOF
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

# ---------------------------------------------------------------- map

fixture
expect "clean fixture is conformant" 0 "doc-kit: conformant (map adr plan)"

fixture
echo x >notes.md
expect "unmapped file fails" 1 "FAIL [map] notes.md is not named in the map" map

fixture
mkdir templates
echo x >templates/notes.md
expect "templates/ is not exempt by name" 1 "templates/notes.md is not named in the map" map

fixture
mkdir -p old
echo x >old/stale.md
after '^PLAN.md ' 'old/           archive, not authoritative'
after '^[|] `PLAN.md` +[|] backlog' '| `old/` | archive | past | immutable | nobody |'
after '^[|] `PLAN.md` +[|] start' '| `old/` | archived | never |'
expect "an archive at any mapped path covers its files" 0 "conformant" map

fixture
mkdir -p docs/archive
echo x >docs/archive/stale.md
expect "docs/archive/ is exempt without a row" 0 "conformant" map

fixture
echo x >"docs/adr/0002 old notes.md"
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
expect "gitignored and vendored is skipped silently" 0 "doc-kit: conformant (map)" map

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
sed -i.bak '/^| `PLAN.md`       | start/d' DOC-MAP.md
expect "artifact missing from lifecycle fails" 1 "PLAN.md is in the artifacts table but not the lifecycle table" map

fixture
sed -i.bak '/^PLAN.md /d' DOC-MAP.md
expect "artifact missing from layout fails" 1 "PLAN.md is in the artifacts table but not the layout block" map

fixture
rm PLAN.md
expect "named artifact missing on disk fails" 1 "the map names PLAN.md but nothing matches it" map

fixture
sed -i.bak 's/| future  | volatile /| later   | volatile /' DOC-MAP.md
expect "tense outside the closed set fails" 1 "PLAN.md has tense 'later'" map

fixture
sed -i.bak 's/| future  | volatile           | the team /| past    | immutable          | maintainers /' DOC-MAP.md
expect "two artifacts sharing all properties fail" 1 "two artifacts share" map

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
expect "proposed record needs no decision-makers" 0 "conformant" adr

fixture
adr 0002 'superseded by ADR-0009' 'decision-makers: someone'
expect "forward pointer to a missing record fails" 1 "points at ADR-0009, which does not exist" adr

fixture
cp docs/adr/0001-a-record.md docs/adr/0001-another.md
expect "reused number fails" 1 "ADR number 0001 is used more than once" adr

fixture
cp docs/adr/0001-a-record.md docs/adr/0002-Bad_Name.md
expect "misnamed record fails" 1 "is misnamed" adr

fixture
sed -i.bak '/^## Considered Options/d' docs/adr/0001-a-record.md
rm docs/adr/0001-a-record.md.bak
expect "record missing a MADR heading fails" 1 "has no '## Considered Options'" adr

# ---------------------------------------------------------------- plan

fixture
printf '\n## Old thing DONE\n\n**Type:** bug\n\nDone.\n' >>PLAN.md
expect "heading marked DONE fails" 1 "PLAN.md:9 looks like a completed entry" plan

fixture
printf '\n## Old thing (done)\n\n**Type:** bug\n\nDone.\n' >>PLAN.md
expect "heading marked (done) fails" 1 "looks like a completed entry" plan

fixture
printf '\n## ~~Old thing~~\n\n**Type:** bug\n\nDone.\n' >>PLAN.md
expect "struck-through heading fails" 1 "looks like a completed entry" plan

fixture
printf '\n## Define what done means\n\n**Type:** docs\n\nOne paragraph.\n' >>PLAN.md
expect "the word done in a title passes" 0 "conformant" plan

fixture
printf '\n## Untagged\n\nOne paragraph.\n' >>PLAN.md
expect "entry with no type tag fails" 1 "PLAN.md:9 has no valid type tag" plan

fixture
printf '\n## Wrong tag\n\n**Type:** chore\n\nOne paragraph.\n' >>PLAN.md
expect "entry with an invalid type tag fails" 1 "PLAN.md:9 has no valid type tag" plan

fixture
printf '\n## Bare tag\n\n**Type:** bug\n\nOne paragraph.\n' >>PLAN.md
expect "type tag alone on its line passes" 0 "conformant" plan

# ---------------------------------------------------------------- cli

fixture
expect "unknown check exits 2" 2 "unknown check: nope" nope

printf '%s passed, %s failed\n' "$passed" "$failed"
[ "$failed" -eq 0 ]

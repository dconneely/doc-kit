#!/bin/sh
# doc-kit-word-budget - fail when the text every agent session reads in an adopted repository
# grows past its budget: the AGENTS.md stanza in ADOPTING.md, and the template map.
#
# Usage: sh tests/doc-kit-word-budget.sh
#
# Lower a budget when the text is cut. Raise one only as a decision that the added words are worth
# every session's reading of them.

set -eu

LC_ALL=C
export LC_ALL

ROOT=$(cd "$(dirname "$0")/.." && pwd)

STANZA_BUDGET=270
MAP_BUDGET=2180

# The stanza: the first markdown block after "Paste the stanza" in ADOPTING.md.
stanza=$(awk '/^Paste the stanza/ { f = 1 } f && /^```markdown$/ { s = 1; next } s && /^```$/ { exit } s' \
	"$ROOT/ADOPTING.md" | wc -w | tr -d ' ')
map=$(wc -w <"$ROOT/templates/DOC-MAP.md" | tr -d ' ')

status=0
report() {
	if [ "$2" -eq 0 ]; then
		printf 'FAIL %s not found\n' "$1" >&2
		status=1
	elif [ "$2" -gt "$3" ]; then
		printf 'FAIL %s is %s words, over its budget of %s\n' "$1" "$2" "$3" >&2
		status=1
	else
		printf '%s: %s of %s words\n' "$1" "$2" "$3"
	fi
}
report 'the AGENTS.md stanza' "$stanza" "$STANZA_BUDGET"
report 'templates/DOC-MAP.md' "$map" "$MAP_BUDGET"
exit "$status"

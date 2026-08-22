---
status: "accepted"
date: 2026-08-22
decision-makers: David Conneely
---

# 14. Gitignored documentation files are advisory, not exempt

## Context and Problem Statement

`SPECIFICATION.md` §1 defines **documentation file** — the term §2.4's completeness check is built
on — as excluding anything "not part of a vendored dependency, not generated into an ignored
directory." That reads as a full exemption, the same treatment §5.1 gives archived files: silent,
no report at all. But `tools/doc-kit-check.sh` never actually implemented it — `EXCLUDE_PREFIXES`
has only ever covered `templates/` and `docs/archive/`. The spec's promise and the checker's
behaviour have been out of step since the checker was written, and nothing had exercised the gap
until a concrete adoption did.

Two cases from adopting the kit into play-bazlang surfaced it from opposite directions. A vendored,
gitignored copy of JLine's source (`localonly-JLINE-SOURCE/`) carries its own upstream `README.md`,
which the checker flagged as an undocumented file — a permanent, unfixable-from-the-map-side
failure, exactly the case §1's wording was presumably written to prevent. But separately, that same
adoption's own gitignored working notes (`localonly-BAZLANG-ROADMAP.md`,
`-IMPROVEMENTS.md`) were genuinely worth checking against the map *while they existed*, before being
split into tracked `PLAN.md`/`CHANGELOG.md`/ADR content — a full, silent exemption would have hidden
exactly the signal that made the migration decidable. One case wants silence; the other wants the
check to still run, just not to block on it.

## Considered Options

* **Full exemption** — implement §1 as written: a checker MUST treat any gitignored path as not a
  documentation file at all, identically to §5.1's archive treatment.
* **No exemption** — treat gitignored files identically to tracked ones, which is what the checker
  has actually always done, by omission rather than by design.
* **Query, don't block** — a checker MUST still evaluate a gitignored file against §2.4, but MUST
  report a hit in one as advisory (a warning), and MUST NOT let it affect the checker's exit status.

## Decision Outcome

Chosen option: **query, don't block**, because full exemption throws away real signal a repository
may still want — a gitignored working-notes convention is a recurring, legitimate shape (this kit's
own adoption sessions produce exactly that), and it deserves the same completeness check as anything
tracked, right up until it's deleted or migrated. Full exemption and no-exemption both conflate two
different things §1's original wording ran together: a repository's own gitignored documentation
(wants checking, doesn't want to block CI) and someone else's vendored source tree that happens to
carry a README (wants neither). "Query, don't block" is the one option that serves both correctly.

### Consequences

* Good, because a gitignored documentation convention is still checked for completeness against the
  map, not silently exempted the way archived files are.
* Good, because a vendored dependency's own README (or similar) never blocks a checker run or an
  exit code, without requiring a repository to either lie to its own map about scope or maintain a
  local patch to its vendored copy of the checker.
* Bad, because this needs `git` as an optional runtime dependency for one specific signal — the one
  part of `tools/doc-kit-check.sh` that isn't pure `awk`/`sed`/`grep`/`find` (ADR-0012). It degrades
  toward the *stricter* old behaviour (every hit blocks) when `git` or a work tree isn't available,
  never toward silence, so nothing is lost where the environment can't support the softer check.
* Neutral: §1's "documentation file" definition needs rewriting — the "vendored dependency"/
  "generated into an ignored directory" clause was never implemented and is superseded by this
  decision. §5's archive exemption is unaffected: it remains the one true, silent exemption,
  distinct from this advisory treatment for anything merely gitignored.

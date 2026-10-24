---
status: "proposed"
date: 2026-10-24
decision-makers: {the owner - required once the status is not "proposed"}
approval: {the owner's words, verbatim - required once the status is not "proposed"}
---

# 14. Where each artifact lives, and how it grows

## Context and Problem Statement

Three problems with the current paths:

- **No artifact can grow.** `docs/quirks.md`, `docs/glossary.md` and the plan are one file each,
  with no rule for what happens when one becomes too long. The plan's working notes went to
  `docs/tasks/`, a name that does not say whether a task is done or still to do; a plan entry is
  only ever future.
- **Names are inconsistent.** `SPECIFICATION.md` is long where `PLAN.md` is short, and neither
  matches the directory a long one would overflow into.
- **`docs/adr/` names the record by "architectural"**, and most decisions here are not
  architectural. [MADR](https://adr.github.io/madr/) 3.0.0 renamed itself "Markdown Any Decision
  Records" and moved its default directory to `docs/decisions/` for this reason; 4.0.0 restored
  "Architectural" to its name but kept that directory.

Moving `SPECIFICATION.md` and `PLAN.md` off the root costs discoverability. No tool looks for either
filename - unlike `README.md`, `AGENTS.md`, `CLAUDE.md` and `CHANGELOG.md` - so the cost falls on a
session that skips `AGENTS.md`, lists the root, finds no plan, and starts a `TODO.md`. Not known:
how often agents do that.

## Considered Options

- Keep `SPECIFICATION.md` and `PLAN.md` at the root, and let each overflow into `docs/spec/` and
  `docs/plan/`
- Rename them `SPEC.md` and `PLAN.md` at the root, overflowing the same way
- Move them to `docs/spec.md` and `docs/plan.md`, each overflowing into a sibling directory of the
  same name
- Keep every path as it is

## Decision Outcome

Chosen option: **move them to `docs/spec.md` and `docs/plan.md`**, because then one rule covers
every artifact: a file `docs/name.md` that outgrows one file gains a sibling directory `docs/name/`,
and stays as its entry point - an index or summary that links into the directory - so links to it
stay true.

- The root holds only the files a tool or a convention looks for there: `README.md`, `AGENTS.md`,
  its aliases, `CHANGELOG.md` and the map.
- `docs/adr/` becomes `docs/decisions/`. Records keep their numbers, and are still cited as
  `ADR-NNNN`.
- `docs/plan/` replaces `docs/tasks/`. The ranked list stays in `docs/plan.md`; a note in
  `docs/plan/` belongs to one entry and goes when the entry does.
- A monorepo module's artifacts sit under the module, and only the map, `README.md`, `CHANGELOG.md`
  and `docs/plan.md` stay at the repository root.

The discoverability cost is met by the map check: a `TODO.md` the map does not name fails it.

Keeping both at the root was rejected because `PLAN.md` and `docs/plan/` are not siblings, so the
overflow rule needs an exception for exactly the two artifacts most likely to overflow. Renaming at
the root fixes the names but not the exception. Keeping every path leaves all three problems.

This record does not settle how an adopting repository moves from the old paths; the changelog and
`ADOPTING.md` carry that when the move is made.

Accepting this record permits the path edits it requires in accepted records - ADR-0003, ADR-0005,
ADR-0006 and ADR-0011 name `PLAN.md` or `SPECIFICATION.md` - without reopening them, since a moved
path changes no decision.

### Consequences

- Good, because any artifact can grow without a new decision.
- Good, because the root shows only what tools look for.
- Good, because the directory name no longer says "architectural".
- Bad, because every adopting repository moves files and rewrites links when it takes the version
  that makes this change.
- Bad, because links to the kit's `SPECIFICATION.md` that do not pin a commit stop working.
- Bad, because a session that ignores `AGENTS.md` sees no plan at the root, and the map check
  catches the result only after the session has made it.

# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

### Run the link sweep nightly in CI

*Type: feature — Importance: low — Effort: low*

`lychee` is configured as a manual-stage hook, so the sweep exists but only when someone runs it.
Nightly CI is where it belongs, since link rot happens without anyone touching the repository —
blocked on this repository being published and having CI at all. All 32 external links resolved when
last checked (2026-08-20).

### Lint commit messages

*Type: feature — Importance: low — Effort: low*

`commitlint` on a `commit-msg` hook, enforcing Conventional Commits. Worth doing only once the type
mapping is written down somewhere enforceable: product changes — `ADOPTING.md`, `templates/`, the
checker, the installer — take `feat`/`fix`/`refactor`, while this repository's own documentation
takes `docs`. Without that rule a documentation kit types every commit `docs` and the history stops
carrying information.

### Restate who `docs/quirks.md` is for

*Type: docs — Importance: medium — Effort: low*

The artifacts table gives its audience as "users comparing against a reference", which was right and
is now half the story: its highest-value reader is a coding agent about to delete a workaround it
has mistaken for a defect. Say so in the template's audience column and in the file's own preamble.
While there, make entries greppable — consistent field labels, one per line — so an agent scanning
for a symbol finds the entry that governs it rather than having to read the file. The same argument
applies more weakly to ADRs recording a constraint, which is worth a sentence in the map but not a
format change.

### Write the adoption skill

*Type: feature — Importance: medium — Effort: medium*

Most adoptions of this kit into a mature repository will be executed by an agent. That needs the
imperative procedure, an inventory output for approval before any file is modified, and resumable
state. Blocked on the `ADOPTING.md` split and the inventory format.

### Decide the template upgrade path

*Type: feature — Importance: medium — Effort: high*

An adopter copies the map and then customises it by deletion, so there is no way to take a later
improvement. Either version-stamp copied artifacts and ship migration notes per release, or state
explicitly that adoption is fork-and-forget. The second is a legitimate answer and should be chosen
deliberately rather than by omission. Scope is now narrower than it was: ADR-0007 gives checks a
working upgrade path via `rev`, so this entry covers only the copied prose artifacts.

### Write `docs/testing.md`

*Type: docs — Importance: medium — Effort: low*

Earned as soon as the checker exists: what it verifies exactly, what it verifies approximately, and
what is deliberately left to review — §4 substantive conformance in particular. Blocked on the
checker.

### Build a worked example

*Type: docs — Importance: low — Effort: high*

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.

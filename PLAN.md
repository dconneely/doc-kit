# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

### Decide the template upgrade path

*Type: feature — Importance: medium — Effort: high*

An adopter copies the map and then customises it by deletion, so there is no way to take a later
improvement. Either version-stamp copied artifacts and ship migration notes per release, or state
explicitly that adoption is fork-and-forget. The second is a legitimate answer and should be chosen
deliberately rather than by omission. Scope is wider than it looks: ADR-0012 vendored the checker
rather than referencing it, so `tools/doc-kit-check.sh` has the same problem as the copied prose —
and a stale checker fails quietly, by not testing something newer, rather than loudly.

### Lint commit messages

*Type: feature — Importance: low — Effort: low*

`commitlint` on a `commit-msg` hook, enforcing Conventional Commits. Worth doing only once the type
mapping is written down somewhere enforceable: product changes — `ADOPTING.md`, `templates/`, the
checker, the installer — take `feat`/`fix`/`refactor`, while this repository's own documentation
takes `docs`. Without that rule a documentation kit types every commit `docs` and the history stops
carrying information.

### Run the link sweep nightly in CI

*Type: feature — Importance: low — Effort: low*

`lychee` is configured as a manual-stage hook, so the sweep exists but only when someone runs it.
Nightly CI is where it belongs, since link rot happens without anyone touching the repository —
blocked on this repository being published and having CI at all. All 32 external links resolved when
last checked (2026-08-20).

### Build a worked example

*Type: docs — Importance: low — Effort: high*

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.

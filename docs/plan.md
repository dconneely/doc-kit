# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR. `docs/spec.md` §3.3 defines the scales.

## Stop shared-triple warnings repeating on every run

**Type:** debt - **Importance:** medium - **Effort:** low

Needs an ADR. With closed audiences, standard artifacts holding different facts share all three
properties, training readers to ignore recurring checker warnings. Solution: hardcode exemptions in
the checker for pairwise overlaps between standard specification artifacts defined in §2 and §3,
including sibling members within multi-file containers (`docs/spec/*`, `docs/howto/*`,
`docs/plan/*`), and exclude `templates/**` from documentation checks just like `docs/archive/**` per
§2.8. Custom artifacts continue to report advisory warnings; `Allowed overlaps` is dropped.

## Remove duplication between the specification and the templates

**Type:** debt - **Importance:** medium - **Effort:** medium

Needs an ADR. Make the templates the normative source for each artifact's shape and value sets, and
have the specification cite them; test that the checker's value sets match the templates. Cut
duplication between files only the kit holds, such as the twice-told consequences in `ADOPTING.md`
and `ADOPTING-NOTES.md`. Write the hazard exception for the `AGENTS.md` stanza into §4.1, and add an
advisory detector for sentences repeated across files.

## Test the map with agent evals

**Type:** feature - **Importance:** medium - **Effort:** medium

Give agent sessions facts to file - a choice and its reason, a known defect pinned by a test, a
finding with a source - and score where each lands. The agent is the reader whose behaviour the kit
exists to shape, and nothing yet measures whether the map shapes it.

## Build a worked example

**Type:** docs - **Importance:** low - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.

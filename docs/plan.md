# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR. `docs/spec.md` §3.3 defines the scales.

## Restructure the paths and close the audience set

**Type:** feature - **Importance:** medium - **Effort:** high

Implement ADR-0014 and ADR-0015 once the owner accepts them; ADR-0015 also needs ADR-0002 reopened.
Move the paths, rewrite every link and the checker's paths, close the audience column in both maps,
make a shared triple a warning, and tell adopters how to move in `ADOPTING.md` and the changelog.

## Add how-to guides and external sources

**Type:** feature - **Importance:** medium - **Effort:** medium

Needs an ADR, after the restructure. `docs/howto/` holds procedures that recur across several
places, citing conventions and exemplars rather than copying them. `docs/sources/` holds external
material: an index of URL, retrieval date, licence, redistributability and checksum; a `.gitignore`
that ignores everything not explicitly redistributable; a fetch script; and Markdown extracts beside
their PDFs, as generated artifacts.

## Keep decisions readable for a new session

**Type:** feature - **Importance:** medium - **Effort:** medium

Needs an ADR. A generated index of the decision records in force, so a session reads what binds
without opening deprecated ones; `docs/spec.md`'s purpose section linking to ADR-0001, which records
the owner's purpose, rather than restating it; and MADR's optional `Confirmation` section, naming
the test that confirms a decision.

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

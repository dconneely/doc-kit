# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

Each entry is a heading, a tag line - **Type:** `bug`, `debt`, `feature` or `docs`, then
**Importance** and **Effort**, each `low`, `medium` or `high` - and one paragraph. No design: if it
needs more, it needs an ADR. `SPECIFICATION.md` §3.3 defines the scales.

## Migrate the existing decision records

**Type:** docs - **Importance:** high - **Effort:** medium

Merge the records into one per question, simplify each to the current answer, and renumber them -
reusing numbers is allowed for this one migration. ADR-0020 to ADR-0022 join the set. The migration
converts the `refined by` pointers to links, merges ADR-0009 and ADR-0011 away, links ADR-0017's
citation of `identigon/identigon`'s ADR-0036, fixes every citation, and fills in `approval`. The
owner agrees to the inventory first, then accepts the migrated set; until then ADR-0020 to ADR-0022
stay `proposed`.

## Check approvals and citations in the checker

**Type:** feature - **Importance:** high - **Effort:** medium

Lands with the migration, which it would otherwise fail on. Require `approval` on any record past
`proposed`; report any bare `ADR-NNNN` outside code that names no record here, and any citation not
in that form; stop accepting `refined by`. Add tests, and update `docs/testing.md`.

## Restructure the paths and close the audience set

**Type:** feature - **Importance:** medium - **Effort:** high

Needs an ADR. Audience becomes a closed set of roles - owner, contributor, consumer, end-user,
operator - with human or agent assumed both unless noted. `docs/adr/` becomes `docs/decisions/`,
`SPECIFICATION.md` and `PLAN.md` move to `docs/spec.md` and `docs/plan.md`, and any single-file
artifact overflows into a sibling directory of the same name. `docs/plan/` replaces `docs/tasks/`.
Closing the set will expose artifacts that share all three properties.

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
without opening deprecated ones; the owner's purpose as an accepted record the specification links
to; and MADR's optional `Confirmation` section, naming the test that confirms a decision.

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

## Check which instruction file Antigravity reads

**Type:** docs - **Importance:** low - **Effort:** low

If it reads something other than `AGENTS.md`, that file should be an alias of `AGENTS.md`, so that
the absolute rules on decision records reach it.

## Build a worked example

**Type:** docs - **Importance:** low - **Effort:** high

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.

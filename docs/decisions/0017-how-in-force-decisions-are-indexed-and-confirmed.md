---
status: "accepted"
date: 2026-10-25
decision-makers: David Conneely
approval: "Yes"
---

# 17. How in-force decisions are indexed and confirmed

## Context and Problem Statement

As a repository evolves, decision records accumulate across multiple statuses: `accepted`,
`deprecated`, `rejected`, and `proposed`. A fresh coding agent session entering the repository has
to discover which decisions currently bind.

Opening and parsing dozens of individual decision records to check front-matter status wastes
context window and risks an agent inadvertently treating deprecated or rejected records as binding
constraints. Furthermore, two related problems exist:

1. **Restated purpose:** `docs/spec.md`'s purpose section previously restated the owner's purpose
   and operating model from ADR-0001, duplicating facts across documents in tension with §4.1.
2. **Untested decisions:** Decisions often specify verifiable constraints, but the minimal MADR
   template lacked a place to name the automated check or test that confirms compliance.

## Considered Options

- Maintain no index, requiring agent sessions to inspect all files under `docs/decisions/`
- Manually edit a `docs/decisions/README.md` index file whenever an ADR changes
- Provide a deterministic generator script (`tools/doc-kit-index-decisions.sh`) that produces
  `docs/decisions/README.md`, verified by the checker per §4.3; link `docs/spec.md` directly to
  ADR-0001; and adopt MADR's optional `Confirmation` section

## Decision Outcome

Chosen option: **generate a decisions index, link `docs/spec.md` to ADR-0001, and adopt the
`Confirmation` section**.

### 1. Generated decisions index

`tools/doc-kit-index-decisions.sh` reads `docs/decisions/*.md` and generates
`docs/decisions/README.md`:

- **In-force decisions:** A prominent table lists all `accepted` records with their number, title,
  date, decision-makers, and confirmation test (if specified). A fresh session reads this section
  first to know what binds.
- **Non-binding records:** A second table lists `proposed`, `rejected`, and `deprecated` records so
  their status is explicit without opening them.
- **Conformance enforcement:** Per `docs/spec.md` §4.3, the index carries a generator header, and
  `tools/doc-kit-check.sh` fails if the committed index differs from regenerated output.

### 2. Purpose linking in the specification

`docs/spec.md` §1 links directly to ADR-0001 for the project purpose and owner/agent model rather
than restating them, satisfying the single source of truth rule (§4.1).

### 3. Optional `Confirmation` section

`templates/docs/decisions/0000-template.md` adds MADR's optional `## Confirmation` section. When a
decision can be verified mechanically (e.g. by a checker script, test case, or lint rule), this
section names the test that asserts compliance.

### Consequences

- Good, because a fresh agent session reads `docs/decisions/README.md` in one step to learn every
  active constraint.
- Good, because duplication between `docs/spec.md` and ADR-0001 is eliminated.
- Good, because decisions with mechanical assertions name their tests explicitly.
- Bad, because maintaining a generated artifact requires generator tooling and checker validation.

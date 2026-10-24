---
status: "accepted"
date: 2026-10-24
decision-makers: David Conneely
approval: 'Yes (asked: "Do you accept ADR-0001 to ADR-0013?")'
---

# 5. What is product, what is documentation, and what is infrastructure

## Context and Problem Statement

This repository's product is made of the same material as its documentation. The kit ships a
template map, meant to be copied and customised elsewhere, and applying the kit to itself - which it
should survive, and which is the cheapest worked example - means customising a map. One file cannot
be both the uncustomised template and the customised instance.

The same question arises for every other file. `ADOPTING.md` reads like documentation - a how-to, in
[Diátaxis](https://diataxis.fr) terms - but delete it and the templates cannot be applied. And the
repository has files that configure itself, such as `.gitattributes`, hook configuration and CI
workflows, which an adopter has too, so they look like product.

## Considered Options

- Keep one file serving as both template and instance
- Do not apply the kit to itself, and keep the root files as pure template
- Classify by Diátaxis: anything that reads as a how-to is documentation
- Move `ADOPTING.md` under `templates/`, so the layout encodes its classification
- Ship the repository's own configuration files as product, merging them into an adopter's
- Classify by what a file is about, and whether the kit can own where it lands

## Decision Outcome

Chosen option: **classify by what a file is about, and whether the kit can own where it lands**.

- **Product** describes the adopter's repository, and is shipped for use there: `templates/`,
  `ADOPTING.md`, `ADOPTING-NOTES.md`, `tools/` and the adoption skill. It is source of truth,
  versioned and reviewed like code, and its changes appear in the changelog.
- **Documentation** describes this repository: everything at the root besides the product, and
  `docs/`. It is produced by applying the kit to itself, so the root `DOC-MAP.md` is an instance of
  `templates/DOC-MAP.md`. `SPECIFICATION.md` is documentation although it concerns adopters, because
  it describes the product rather than being it (ADR-0004).
- **Infrastructure** configures this repository and is never applied elsewhere. It fails the second
  half of the test: an adopter already has a `.gitattributes`, so the file could only be merged, and
  most of its content - line endings, secret scanning - is outside the kit's authority.

Any infrastructure the kit offers an adopter is optional - made available, never applied - and
adopting the structure never requires running anything. Conformance is a property of a repository's
state, not of whether it runs the kit's tooling.

A file serving as both template and instance was rejected because it cannot be both. Not applying
the kit to itself was rejected because it forfeits the worked example, and because a documentation
kit that does not survive its own method is evidence against the method. Diátaxis was rejected for
this question because it classifies documentation by what a reader needs, and says nothing about
whether a file is a deliverable. Moving `ADOPTING.md` was rejected because an entry point needs to
be found more than it needs tidy grouping. Shipping configuration was rejected as machinery bought
for files the kit has no authority over.

### Consequences

- Good, because self-application is ordinary adoption, and the kit's own repository is its worked
  example.
- Good, because each new file is classified before it is written.
- Bad, because the map carries a classification the filesystem does not show. A reader cannot tell
  from `ADOPTING.md`'s path that it is product; the map says so.
- Bad, because generic hygiene stays the adopter's business: the kit gives no help with secret
  scanning or line endings.

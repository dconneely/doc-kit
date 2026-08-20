# 4. Separate the product from the repository's own documentation

## Status

Accepted

## Context

This repository began as two files at its root: `DOCUMENTATION.md`, a template to be copied into
other repositories, and `DOCUMENTATION-CUSTOMISATION.md`, the procedure for customising it.

That layout has a paradox in it. Applying the kit to itself — which it should survive, and which is
the cheapest way to produce a worked example — means customising `DOCUMENTATION.md` by deleting the
rows this repository does not need. But customising it destroys the template, because the template
*is* the uncustomised text.

The paradox is not really about documentation. It comes from a repository whose product happens to
be made of the same material as its documentation, so the two were never distinguished.

## Decision

We will treat `templates/` as **source code**, not documentation.

The kit's product is documentation structure. The templates are what it ships. They are source of
truth, versioned and reviewed like code, and they are described by `SPECIFICATION.md` in the same way
a program's behaviour would be.

Everything at the root — the map, `README.md`, `SPECIFICATION.md`, `CHANGELOG.md`, `PLAN.md`,
`docs/` — is this repository's own documentation, produced by applying the kit to itself.

`templates/DOCUMENTATION.md` is therefore the template; the root `DOCUMENTATION.md` is an instance of
it. They share a name and nothing else, and the path disambiguates them.

## Consequences

The paradox dissolves rather than being managed. There is no longer one file trying to be both
template and instance, so self-application is just adoption.

`SPECIFICATION.md` acquires a job it did not previously have: defining what a conformant repository
looks like. That definition is what a checker enforces, which puts the specification and the test
suite in alignment — the specification is not a description of the checker, it is the contract the
checker implements.

Format skeletons should migrate out of the map. The map currently restates the ADR template inline,
which every adopter then copies; once `templates/docs/adr/0000-template.md` exists, the map links to
it and keeps only what the file cannot express. This is ADR-0003's link-never-restate rule applied to
the kit itself, and it is deliberately deferred rather than done now.

Installation becomes honest. It was never really "copy one file" — it is "copy the map plus the
templates for the artifacts you kept", and the layout now says so.

`ADOPTING.md` becomes a new artifact in this repository's map, with an audience — adopters — that
nothing else has. It is the first candidate to *pass* the three-property test of ADR-0001, which is
worth noting given that the two recorded before it both failed.

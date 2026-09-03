---
status: "accepted (refined by ADR-0006)"
date: 2026-08-20
decision-makers: David Conneely
---

# 4. Separate the product from the repository's own documentation

## Context and Problem Statement

The kit's product is a template map, meant to be copied into another repository and customised
there. That creates a paradox for the kit itself. Applying the kit to itself - which it should
survive, and which is the cheapest way to produce a worked example - means customising that map by
deleting the rows this repository does not need. But customising it destroys the template, because
the template _is_ the uncustomised text.

The paradox is not really about documentation. It comes from a repository whose product happens to
be made of the same material as its documentation, so the two were never distinguished.

## Considered Options

- Keep one file serving as both template and instance
- Do not apply the kit to itself, and keep the root files as pure template
- Treat `templates/` as source code, and the root as an instance produced by self-application

## Decision Outcome

Chosen option: **treat `templates/` as source code**, not documentation, because the kit's product
_is_ documentation structure - so the templates are what it ships, and shipped artifacts are source
of truth rather than description.

Everything at the root - the map, `README.md`, `SPECIFICATION.md`, `CHANGELOG.md`, `PLAN.md`,
`docs/` - is this repository's own documentation, produced by applying the kit to itself.
`templates/DOC-MAP.md` is therefore the template; the root `DOC-MAP.md` is an instance of it. They
share a name and nothing else, and the path disambiguates them.

Not self-applying was rejected because it forfeits the worked example, and because a documentation
kit that does not survive its own method is evidence against the method.

`ADOPTING.md` is left unclassified. It is neither a template nor obviously this repository's own
documentation, and this decision does not settle which side of the line it falls on.

### Consequences

- Good, because the paradox dissolves rather than being managed. There is no longer one file trying
  to be both template and instance, so self-application is just adoption.
- Good, because `SPECIFICATION.md` acquires a job it did not have: defining what a conformant
  repository looks like. That definition is what a checker enforces, putting the specification and
  the test suite in alignment - the specification is not a description of the checker, it is the
  contract the checker implements.
- Good, because installation becomes honest. It was never really "copy one file" - it is "copy the
  map plus the templates for the artifacts you kept", and the layout now says so.
- Bad, because format skeletons are now duplicated. The map restates the ADR template inline, which
  every adopter then copies; once `templates/docs/adr/0000-template.md` exists the map should link
  instead. This is ADR-0003's link-never-restate rule applied to the kit itself, and it is
  deliberately deferred rather than done now.

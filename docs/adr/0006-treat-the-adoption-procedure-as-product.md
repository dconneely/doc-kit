---
status: "accepted"
date: 2026-08-20
decision-makers: David Conneely
---

# 6. Treat the adoption procedure as product

## Context and Problem Statement

ADR-0004 separated this repository's product from its own documentation, and named `templates/` as
the product. It left the other shipped file unclassified: `ADOPTING.md` had been filed as a
documentation artifact, on the reasoning that a how-to guide is documentation in the
[Diátaxis](https://diataxis.fr) sense, and every library ships one without calling it source code.

That reasoning does not survive contact with what the kit actually is. Two tests disagree with it:

- **What is it about?** Nothing in `ADOPTING.md` describes this repository. Delete every other file
  here and not a word of it changes, because it describes what happens in the _adopter's_
  repository. That is precisely what `templates/` does.
- **What survives its deletion?** Deleting a library's how-to guide leaves a working library.
  Deleting `ADOPTING.md` leaves a folder of blank templates that nobody can apply. The procedure is
  not an explanation of the deliverable; it is half the deliverable.

The question generalises immediately, which is the reason to settle it now rather than adjudicate
one file. Everything else the kit comes to ship - a conformance checker is the nearest candidate in
`PLAN.md` - describes the adopter's repository too, and would otherwise arrive with the same
argument unresolved.

## Considered Options

- Keep `ADOPTING.md` as documentation, per the Diátaxis reading
- Treat as product everything the kit ships for use elsewhere
- Move `ADOPTING.md` under `templates/` so the layout encodes its classification

## Decision Outcome

Chosen option: **treat as product everything the kit ships for use in another repository** -
`ADOPTING.md`, the contents of `templates/`, and anything else it comes to ship for use elsewhere.
All of it is source of truth, versioned and reviewed like code.

The dividing question is what a file is _about_: product describes the adopter's repository,
documentation describes this one. Where a file describes the product rather than being it, it is
documentation - which keeps `SPECIFICATION.md`, `README.md` and the map on the documentation side.
`SPECIFICATION.md` is the case that fixes the boundary: it also concerns the adopter's repository,
yet describes the product rather than being it, which is ADR-0003's source-of-truth-versus-prose
distinction applied here.

Moving `ADOPTING.md` under `templates/` was rejected: discoverability matters more for an entry
point than tidy grouping does. Classification is recorded in the map instead.

This refines ADR-0004 rather than reversing it. That decision's substance - `templates/` is source
code, self-application is ordinary adoption - stands unchanged. What changes is only that a boundary
it drew implicitly is now drawn explicitly.

### Consequences

- Good, because future artifacts get classified before they are written: anything the kit ships for
  use elsewhere is product, reviewed as code, with its changes adopter-visible in the changelog.
- Bad, because the map has to carry classification the filesystem does not. A reader cannot infer
  from `ADOPTING.md`'s path that it is product. Accepted because the map exists precisely to state
  what each file is; a directory layout encoding it would be a second source of truth.
- Neutral: a question is left open - whether an adopter receives a copy of `ADOPTING.md` alongside
  the templates. There is a real argument that they should, since a migration spans weeks and the
  procedure ought to be pinned locally rather than shifting underneath them. Deferred rather than
  guessed at, and to be settled wherever copying is eventually specified.
- Neutral: the Diátaxis reading that produced the original misclassification is worth naming,
  because it will recur. Diátaxis classifies documentation by what a reader needs; it says nothing
  about whether a file is a deliverable. Asking it a question it does not answer is what went wrong.

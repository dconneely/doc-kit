# 6. Treat the adoption procedure as product

## Status

Accepted

## Context

ADR-0004 separated this repository's product from its own documentation, and named `templates/` as
the product. It left the other shipped file unclassified: `ADOPTING.md` was filed as a documentation
artifact, on the reasoning that a how-to guide is documentation in the [Diátaxis](https://diataxis.fr)
sense and every library ships one without calling it source code.

That reasoning does not survive contact with what the kit actually is. Two tests disagree with it:

- **What is it about?** Nothing in `ADOPTING.md` describes this repository. Delete every other file
  here and not a word of it changes, because it describes what happens in the *adopter's*
  repository. That is precisely what `templates/` does.
- **What survives its deletion?** Deleting a library's how-to guide leaves a working library.
  Deleting `ADOPTING.md` leaves a folder of blank templates that nobody can apply. The procedure is
  not an explanation of the deliverable; it is half the deliverable.

The question generalises immediately, which is the reason to settle it now rather than adjudicate one
file. The checker and the installer in `PLAN.md` are both shipped, both describe the adopter's
repository, and both would otherwise arrive with the same argument unresolved.

`SPECIFICATION.md` is the case that fixes the boundary. It also concerns the adopter's repository —
it defines what a conformant one looks like — yet it *describes* the product rather than being it.
That is ADR-0003's source-of-truth-versus-prose distinction, applied to this repository.

## Decision

We will treat as **product** everything the kit ships for use in another repository: `ADOPTING.md`,
the contents of `templates/`, and — when they exist — the checker and the installer. All of it is
source of truth, versioned and reviewed like code.

Everything else is this repository's own documentation. The dividing question is what a file is
*about*: product describes the adopter's repository, documentation describes this one. Where a file
describes the product itself rather than being it, it is documentation — which keeps
`SPECIFICATION.md`, `README.md` and the map on the documentation side.

Classification is recorded in the map. It does not have to match the directory layout, and
`ADOPTING.md` stays at the root because discoverability matters more for the entry point than tidy
grouping does.

This refines ADR-0004 rather than reversing it. That decision's substance — `templates/` is source
code, self-application is ordinary adoption — stands unchanged, so it remains `Accepted` and is not
superseded. What changes is only that a boundary it drew implicitly is now drawn explicitly.

## Consequences

Two new artifacts get classified before they are written, rather than after: the checker and the
installer are product, so they are reviewed as code and their changes are adopter-visible in the
changelog.

The map has to carry classification that the filesystem does not. This is a cost — a reader cannot
infer from `ADOPTING.md`'s path that it is product — and it is accepted because the map exists
precisely to state what each file is. A directory layout that encoded it would be an alternative
route to the same fact, and therefore a second source of truth.

A question is opened that the installer must answer: whether an adopter receives a copy of
`ADOPTING.md` alongside the templates. There is a real argument that they should, because a migration
into a mature repository spans weeks and the procedure ought to be pinned locally rather than
shifting underneath them. It is deferred to the installer's design rather than guessed at here.

The Diátaxis reading that produced the original misclassification is worth naming, because it will
recur. Diátaxis classifies documentation by what a reader needs; it says nothing about whether a
given file is a deliverable. Asking it a question it does not answer is what went wrong.

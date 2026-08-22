# Changelog

All notable changes to this project are documented here, following
[Keep a Changelog](https://keepachangelog.com) and [Semantic Versioning](https://semver.org).

## Unreleased

## [0.1.0] - 2026-08-22

Nothing had been released before this, so everything below is an addition — including the several
things that replaced an earlier shape, which are recorded here as the shape that shipped.

### Added

- A licence: [MIT No Attribution](LICENCE). Copy anything here and own it — no notice to preserve,
  nothing to attribute, and no upgrade path to track (ADR-0013).
- `templates/`, holding a starter for every artifact the map promises, so Step 3 is a copy rather
  than a writing exercise. It is the product and source of truth; the root `DOC-MAP.md` is
  this repository's own map, produced by applying the kit to itself (ADR-0004, ADR-0006).
- `SPECIFICATION.md`, defining what a conformant repository looks like, and stating the conventions
  the kit had relied on without writing down: research confidence levels, plan scales, quirk shape.
- `ADOPTING.md`, the procedure — decide, inventory, customise, create, migrate, verify — with
  `ADOPTING-NOTES.md` carrying the judgement calls and troubleshooting behind it.
- Step 0: decide whether to adopt at all, and write the plan before anything else.
- A Step 4 inventory phase with six dispositions — move, split, absorb, archive, delete, leave —
  and a worksheet that makes an interrupted migration resumable.
- `tools/doc-kit-check.sh`, an optional conformance checker, vendored rather than referenced so an
  adopter's copy matches the structure they adopted (ADR-0012).
- A `doc-kit-adopt` skill that drives an adoption from this repository into a target, stopping for
  approval before anything is modified.
- A paste-in `AGENTS.md` stanza giving a coding agent the trust ordering between documents and the
  constraints on changing them.
- An archive convention for documentation whose currency cannot be established (ADR-0005).
- Decision records following the [MADR](https://adr.github.io/madr/) minimal template, with
  `Considered Options` required. Statuses are lowercase and may carry a forward pointer —
  `accepted (refined by ADR-NNNN)` (ADR-0009, ADR-0010).
- Rules for those records: immutability attaches to `accepted` and begins at publication, only
  `accepted` binds, and changing a status is a human action (ADR-0008).
- `infrastructure` as a third category alongside product and documentation (ADR-0007).
- A ranking of the optional artifacts by payoff per line: quirks, glossary, testing, then research.
- `docs/testing.md`, stating what is verified exactly, what only approximately, and what not at all.

# Changelog

All notable changes to this project are documented here, following
[Keep a Changelog](https://keepachangelog.com) and [Semantic Versioning](https://semver.org).

## Unreleased

### Added

- `SPECIFICATION.md`, defining what a conformant repository looks like, with a purpose and scope
  section stating what the structure is for and what it excludes.
- Conventions the kit previously relied on without stating: research confidence levels, plan
  importance and effort scales, and the quirk entry shape.
- Starter files for every artifact the template map promises, so Step 3 is a copy rather than a
  writing exercise.
- An archive convention for documentation whose currency cannot be established — exempt from the
  map's completeness check, with a provenance header on every file. See ADR-0005.
- Step 0 of the adoption procedure: decide whether to adopt, then write `PLAN.md` first.
- A paste-in stanza for `AGENTS.md` or `CLAUDE.md`, giving a coding agent the trust ordering between
  documents and the constraints on changing them. Shipped as text rather than a file, since those
  paths usually already exist.
- An inventory phase for Step 4, with the dispositions move, split, absorb, archive, delete and
  leave, and a worksheet at `templates/docs/tasks/adopt-doc-kit.md`.
- Rules for decision records: immutability attaches to the `accepted` status rather than the commit
  and begins at publication; only `accepted` records bind; changing a status is a human action, best
  made in its own pull request. See ADR-0008.
- `infrastructure` as a third category alongside product and documentation — files configuring this
  repository, which never reach an adopter. Adopting never requires running anything. See ADR-0007.

### Changed

- Decision records follow the [MADR](https://adr.github.io/madr/) minimal template. `Considered
  Options` is now required. See ADR-0010.
- Statuses take MADR's lowercase spelling, gain `rejected`, and may carry a forward pointer —
  `accepted (refined by ADR-NNNN)`. See ADR-0009.
- The template moved to `templates/DOCUMENTATION.md`; `templates/` is source of truth rather than
  documentation, and the root `DOCUMENTATION.md` is this repository's own map. See ADR-0004.
- `ADOPTING.md` is product alongside `templates/`. See ADR-0006.
- `ADOPTING.md` is split: the procedure stays there, and the reasoning behind it — judgement calls,
  how far to trust each convention, troubleshooting — moves to `ADOPTING-NOTES.md`. The procedure
  drops from 451 lines to 284, which matters because it is what an agent loads.
- The optional artifacts are ranked by payoff per line rather than by gap size: quirks, glossary,
  testing, then research — which moves to first for a project that reverse-engineers or reconciles
  sources.
- `DOCUMENTATION-CUSTOMISATION.md` is now `ADOPTING.md`.

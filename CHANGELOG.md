# Changelog

All notable changes to this project are documented here, following
[Keep a Changelog](https://keepachangelog.com) and [Semantic Versioning](https://semver.org).

## Unreleased

### Changed

- Decision records now follow the [MADR](https://adr.github.io/madr/) minimal template: YAML
  front-matter with `status`, `date` and `decision-makers`, then Context and Problem Statement,
  Considered Options, Decision Outcome and Consequences. The kit previously used Nygard's four
  sections while claiming to follow a recognised convention; checking the template showed it did
  not. `Considered Options` is now required — it is what makes a record a decision rather than a
  statement. See ADR-0010.
- Status values take MADR's lowercase spelling, gain `rejected`, and each now has a stated meaning.
  `deprecated` covers a record that no longer applies with nothing replacing it.

### Added

- A rule that changing a decision record's status is a human action: a tool may draft, argue and
  merge a record as `Proposed`, but only a person accepts one, thereby asserting that a decision was
  actually made. Only `Accepted` records bind, so an over-productive tool can generate clutter but
  not authority. Projects using pull requests should make the status change its own pull request —
  a separate commit does not survive a squash merge. See ADR-0008.
- A publication boundary on ADR immutability: a record nobody outside its author could have read has
  no reader who relied on it, so a drafting error may be corrected in place until the first push to
  a shared remote. Relevant during adoption, where records are often drafted in a batch.
- A rule for when a decision record freezes: immutability attaches to the `Accepted` status, not to
  the commit. `Proposed` records may be edited freely and merged while still undecided, which makes
  an open question visible in the tree rather than in an unmerged branch.
- A statement that ceremony follows an artifact's mutability: only accepting a record asks for
  agreement, and the plan should be gated as little as possible.
- A purpose and scope section in `SPECIFICATION.md`, stating what the structure is for — facts that
  cannot be derived from the code — and what it excludes. Volume is named as a cost, and a
  repository whose constraints fit on one page is told not to adopt.
- A third category alongside product and documentation: **infrastructure** — files configuring this
  repository's own operation, such as `.gitattributes`, which never reach an adopter. Validation
  scripts may one day be product an adopter takes on optionally, but adopting the structure will
  never require running anything, and a repository that verifies by hand is fully conformant. See
  ADR-0007.
- An inventory phase for Step 4, with a six-word disposition vocabulary — move, split, absorb,
  archive, delete, leave — and a ready-made worksheet at `templates/docs/tasks/adopt-doc-kit.md`.
  Migration into an existing repository is now enumerate, decide, act, and is resumable across
  sessions rather than re-derived each time.
- Starter files for every artifact the template map promises: specification, README, changelog,
  plan, ADR, research note, quirks, glossary, testing and task notes. Step 3 of the adoption
  procedure is now a copy rather than a writing exercise.
- `templates/docs/archive/README.md`, carrying the archive rules and the provenance header an
  adopter pastes into each archived file.
- `SPECIFICATION.md`, defining what a conformant repository looks like — including the conventions
  the kit previously relied on without stating: research confidence levels, plan importance and
  effort scales, quirk entry shape, and the archive rules.
- The archive convention: a quarantine for documentation whose currency cannot be established,
  exempt from the map's completeness check, with a provenance header required on every file.
- Step 0 of the adoption procedure — decide whether to adopt at all, and write `PLAN.md` before
  anything else so that an interrupted migration is resumable.
- This repository's own documentation set, produced by applying the kit to itself: a map, README,
  changelog, plan, glossary, and five decision records.

### Changed

- The template now lives at `templates/DOCUMENTATION.md` rather than the repository root, and
  `templates/` is treated as the kit's source of truth rather than as documentation. The root
  `DOCUMENTATION.md` is now this repository's own map. See ADR-0004.
- `ADOPTING.md` is classified as product alongside `templates/`, rather than as documentation. The
  dividing question is what a file is about: product describes the adopter's repository,
  documentation describes this one. See ADR-0006.
- `DOCUMENTATION-CUSTOMISATION.md` is now `ADOPTING.md`.

# Changelog

All notable changes to this project are documented here, following
[Keep a Changelog](https://keepachangelog.com) and [Semantic Versioning](https://semver.org).

## Unreleased

### Added

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
- `DOCUMENTATION-CUSTOMISATION.md` is now `ADOPTING.md`.

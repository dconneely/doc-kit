---
status: "proposed"
date: 2026-10-25
decision-makers: David Conneely
approval: "Proposed"
---

# 16. Where how-to guides and external sources live

## Context and Problem Statement

Documentation repositories face two recurring filing dilemmas that the current layout does not
resolve cleanly:

1. **Recurring procedures:** Tasks such as releases, environment bootstrapping, migrations and
   rotations recur across several places. They are neither behaviour specifications
   (`docs/spec.md`), ranked intent (`docs/plan.md`), architectural choices (`docs/decisions/`), nor
   investigations (`docs/research/`). In [Diátaxis](https://diataxis.fr) terms, these are
   task-oriented how-to guides. Scattering them across the repository root or into task notes leaves
   them without an identifiable home once completed.
2. **External reference material:** A repository often relies on external standards, whitepapers,
   RFCs or third-party documentation (e.g. RFC 2119, MADR, SemVer). External URLs suffer from link
   rot, and offline or sandboxed coding agents cannot fetch remote documents. However, storing
   arbitrary third-party assets in the repository risks copyright infringement, licensing
   incompatibilities and repository bloat.

## Considered Options

- Inline procedures into `docs/spec.md` or `README.md`, and inline quoted extracts of external
  sources directly into research notes
- Place procedures in a wiki or external tracker, and rely solely on external hyperlinks for sources
- Introduce `docs/howto/` for recurring task-oriented procedures, and `docs/sources/` for indexed
  external reference material

## Decision Outcome

Chosen option: **introduce `docs/howto/` and `docs/sources/`**.

### 1. How-to guides (`docs/howto/`)

`docs/howto/` holds step-by-step procedures that recur across several places:

- It uses **imperative tense**, is **rewritten in place**, and serves **contributors** and
  **operators**.
- Each guide defines a clear goal, prerequisites, sequential steps, and a verification step to
  confirm success.
- A guide cites external standards and exemplars rather than duplicating their text.

### 2. External sources (`docs/sources/`)

`docs/sources/` holds and indexes external reference material:

- **Index:** A manifest (`docs/sources/README.md`) records every cited source: its URL, retrieval
  date, licence, redistributability status, and SHA-256 checksum.
- **Licensing and gitignore:** A `.gitignore` in `docs/sources/` ignores all downloaded binaries and
  documents by default, allowing only explicitly redistributable assets to be tracked in git.
- **Fetch script:** A POSIX shell script (`fetch.sh`) retrieves and verifies missing sources using
  their recorded checksums.
- **Generated Markdown extracts:** Text or Markdown extracts generated from PDFs or HTML sit beside
  the original files, marked with a generated header naming the generator per `docs/spec.md` §4.3.

### Consequences

- Good, because operational and development procedures have a clear home distinct from normative
  specifications.
- Good, because external source material is pinned with checksums, defending against link rot and
  allowing verification.
- Good, because redistributability and copyright for third-party material are tracked explicitly.
- Good, because both artifacts fit cleanly into the property model (`docs/howto/*.md` is
  `imperative | rewritten in place | contributor`; `docs/sources/` is
  `present | append-only | contributor, consumer`).
- Bad, because maintaining local source caches, fetch scripts, and extraction pipelines introduces
  tooling overhead.

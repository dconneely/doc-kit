---
status: "accepted"
date: 2026-11-04
decision-makers: David Conneely
---

# 14. Where each artifact lives, and how it grows

## Context and Problem Statement

Four problems with documentation layout, growth, and discoverability:

1. **Artifacts cannot grow without breaking links:** `docs/quirks.md`, `docs/glossary.md`, the plan,
   and the specification were single files with no rule for overflow. Moving an artifact into a
   directory later would change its path, breaking existing links, commit references, and external
   citations.
2. **Scattered task procedures and external sources:** Task-oriented procedures (releases,
   rotations, bootstrapping) lacked a clear home distinct from normative behaviour specifications or
   ranked intent. Simultaneously, external RFCs and standards cited normatively risked link rot and
   licensing ambiguity without pinned checksums, gitignoring, and offline retrieval scripts.
3. **Context and search ambiguity across subdirectories:** Using `README.md` inside subdirectories
   burdens editor tab bars, fuzzy finders, and coding agent context windows with identical filenames
   requiring path disambiguation. In `docs/decisions/`, an internal `README.md` polluted the ADR
   glob, forcing check scripts to special-case it. In `docs/archive/`, an internal `README.md` fell
   under the rules for archived files: a "not authoritative" header and no citations from outside.
   Against that, a `README.md` is what GitHub shows when a reader opens the directory, and it keeps
   an index beside the files it lists - which suits a directory that exists from the start, such as
   a generated sources manifest.
4. **Opaque decision status and unconfirmed decisions:** As decision records accumulate across
   multiple statuses (`accepted`, `deprecated`, `rejected`, `proposed`), discovering which records
   currently bind required parsing every file's front-matter. Furthermore, decisions specifying
   verifiable constraints lacked a place to name the test that confirms compliance.

## Considered Options

- **Retain root paths and inline material:** Keep `SPECIFICATION.md` and `PLAN.md` at root, inline
  external extracts into research notes, scatter procedures into task notes, and inspect ADRs
  manually.
- **Subdirectory `README.md` everywhere:** Convert every domain under `docs/` into a directory
  holding a `README.md` (`docs/spec/README.md`, `docs/plan/README.md`, `docs/decisions/README.md`,
  etc.).
- **Uniform sibling entry points (`docs/{name}.md` with optional `docs/{name}/`):** Standardise on
  `docs/{name}.md` as the entry point / index for every directory artifact `docs/{name}/`.
- **Sibling entry points by default, `docs/{name}/README.md` by choice:** As above, but a repository
  may make `docs/{name}/README.md` the entry point of a directory artifact instead, chosen once.

## Decision Outcome

Chosen option: **sibling entry points by default, `docs/{name}/README.md` by choice**, because one
rule covers every artifact: a file `docs/name.md` that outgrows one file gains a sibling directory
`docs/name/`, and stays as its entry point - an index or summary linking into the directory - so
links to it stay true.

A repository may instead make `docs/name/README.md` the entry point, under three limits:

1. **Chosen when the directory is created.** A directory that exists from the start - sources,
   decisions, the archive - can take either form. A `docs/name.md` that later grows a directory
   keeps the sibling form; switching is a rename that breaks every link to it.
2. **Never both.** `docs/name.md` and `docs/name/README.md` do not exist side by side.
3. **The map names the one in use.** An index inside the archive is not an archived file, so the
   archive's header and citation rules do not apply to it.

- **Root:** Holds only files a tool or convention looks for there: `README.md`, `AGENTS.md`, its
  aliases, `CHANGELOG.md`, and `DOC-MAP.md`.
- **Specification:** `docs/spec.md`, overflowing into `docs/spec/` for contracts and schemas. §1
  links directly to ADR-0001 for project purpose and operating model (satisfying §4.1).
- **Plan:** `docs/plan.md`, replacing `docs/tasks/`. Disposable working notes sit in `docs/plan/`.
- **Decision records:** `docs/decisions/*.md`, replacing `docs/adr/`. Records keep numbers, follow
  the MADR minimal template, and may carry an optional `## Confirmation` section naming the test
  asserting compliance. Indexed by `docs/decisions.md`, generated deterministically by
  `tools/doc-kit-index-decisions.sh` and enforced by `tools/doc-kit-check.sh` (§4.3).
- **How-to guides:** `docs/howto/*.md` holds task-oriented recurring procedures in the imperative
  mood, optionally indexed by `docs/howto.md`.
- **External sources:** `docs/sources.md` manifest pins URLs, retrieval dates, licences, and SHA-256
  checksums. Cached originals, `.gitignore`, and `fetch.sh` sit in `docs/sources/`.
- **Archive:** `docs/archive.md` quarantine index records why retained legacy documents were not
  migrated. Non-authoritative, exempt files sit in `docs/archive/` (§5.1).
- **Monorepos:** Per-module artifacts sit under the module; only `DOC-MAP.md`, `README.md`,
  `AGENTS.md` and its aliases, `CHANGELOG.md`, and `docs/plan.md` stay at the repository root.

This combines and supersedes the decisions originally explored for how-to guides, external sources,
and generated decision indexing.

### Consequences

- Good, because any artifact can grow into a directory without changing its entry-point path or
  breaking existing links.
- Good, because filenames in `docs/` are descriptive and distinct in editor tabs and agent tool
  calls.
- Good, because `docs/decisions/*.md` holds only decision records, simplifying globbing and checks.
- Good, because `docs/archive.md` is an authoritative, checked document, while everything inside
  `docs/archive/` remains exempt.
- Good, because active decisions are discovered in a single read of `docs/decisions.md`.
- Good, because external source material is verified with pinned checksums and licence tracking.
- Bad, because GitHub's web UI does not automatically render `docs/{name}.md` when navigating
  directly into `docs/{name}/`. A repository that minds can choose `docs/{name}/README.md` for a new
  directory.
- Bad, because two forms mean a reader checks the map for which one a repository uses.
- Bad, because maintaining generated indexes requires generator tooling and checker validation.

## Confirmation

`tools/doc-kit-check.sh` and `tests/doc-kit-check.test.sh`

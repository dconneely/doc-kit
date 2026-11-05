---
status: "accepted"
date: 2026-11-05
decision-makers: David Conneely
---

# 14. Where each artefact lives, and how it grows

## Context and Problem Statement

Four problems with documentation layout, growth, and discoverability:

1. **Artefacts cannot grow without breaking links:** `docs/quirks.md`, `docs/glossary.md`, the plan,
   and the specification were single files with no rule for overflow. Moving an artefact into a
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
  `docs/{name}.md` as the entry point / index for every directory artefact `docs/{name}/`.
- **Sibling entry points by default, `docs/{name}/README.md` by choice:** As above, but a repository
  may make `docs/{name}/README.md` the entry point of a directory artefact instead.
- **Entry point by how the artefact starts:** An artefact that starts as a directory has its index
  at `docs/{name}/README.md`; one that starts as a file keeps `docs/{name}.md`, and may move once
  when it gains a directory.

## Decision Outcome

Chosen option: **entry point by how the artefact starts**, because the sibling file exists so that a
one-file artefact can grow without breaking links, and an artefact that ships as a directory has
nothing to grow from. Its index belongs with the files it lists, where GitHub shows it to a reader
who opens the directory. The form follows from the artefact, so it is not a choice to revisit.

1. **An artefact that starts as a file** - the specification, the plan, quirks, the glossary,
   testing - is `docs/name.md`. When it outgrows one file it gains a sibling directory `docs/name/`
   and stays as its entry point, so links to it stay true. A repository may instead move it to
   `docs/name/README.md` when the directory is introduced: a one-off migration, made deliberately,
   with every link in the repository fixed in the same change. Switching back and forth is
   discouraged: each switch breaks links from outside the repository, which cannot be fixed.
2. **An artefact that starts as a directory** - decision records, how-to guides, external sources,
   the archive - has its entry point, if it keeps one, at `docs/name/README.md`.
3. **Never both, and the map names the one in use.** `docs/name.md` and `docs/name/README.md` do not
   exist side by side. A repository already using the other form keeps it.

The archive's own `docs/archive/README.md` is not an archived file: it is checked like any other
documentation file, and the archive's header and citation rules do not apply to it.

- **Root:** Holds only files a tool or convention looks for there: `README.md`, `AGENTS.md`, its
  aliases, `CHANGELOG.md`, and `DOC-MAP.md`.
- **Specification:** `docs/spec.md`, overflowing into `docs/spec/` for contracts and schemas. §1
  links directly to ADR-0001 for project purpose and operating model (satisfying §4.1).
- **Plan:** `docs/plan.md`, replacing `docs/tasks/`. Disposable working notes sit in `docs/plan/`.
- **Decision records:** `docs/decisions/*.md`, replacing `docs/adr/`. Records keep numbers, follow
  the MADR minimal template, and may carry an optional `## Confirmation` section naming the test
  asserting compliance. Indexed by `docs/decisions/README.md`, generated deterministically by
  `tools/doc-kit-index-decisions.sh` and enforced by `tools/doc-kit-check.sh` (§4.3).
- **How-to guides:** `docs/howto/*.md` holds task-oriented recurring procedures in the imperative
  mood, optionally indexed by `docs/howto/README.md`.
- **External sources:** The `docs/sources/README.md` manifest pins URLs, retrieval dates, licences,
  and SHA-256 checksums. Cached originals, `.gitignore`, and `fetch.sh` sit beside it.
- **Archive:** `docs/archive/README.md` says what the archive holds and the header each file in it
  carries; each file's header says why it was not migrated. Non-authoritative, exempt files sit
  beside it (§5.1).
- **Monorepos:** Per-module artefacts sit under the module; only `DOC-MAP.md`, `README.md`,
  `AGENTS.md` and its aliases, `CHANGELOG.md`, and the plan stay at the repository root.

This combines and supersedes the decisions originally explored for how-to guides, external sources,
and generated decision indexing.

### Consequences

- Good, because an artefact that starts as a file can grow into a directory without changing its
  entry-point path or breaking existing links.
- Good, because a directory artefact's index sits with the files it lists, and GitHub shows it to a
  reader who opens the directory.
- Good, because `docs/decisions/*.md` holds only decision records, simplifying globbing and checks;
  a `README.md` index is the one exception, and the tools skip it.
- Good, because the archive's `README.md` is an authoritative, checked document, while everything
  else in `docs/archive/` remains exempt.
- Good, because active decisions are discovered in a single read of the decisions index.
- Good, because external source material is verified with pinned checksums and licence tracking.
- Bad, because every directory index is named `README.md`, so editor tabs, fuzzy finders and agent
  tool calls need its path to tell one from another.
- Bad, because GitHub does not show `docs/{name}.md` to a reader who opens a grown artefact's
  `docs/{name}/`. A repository that minds moves it to `docs/{name}/README.md` when the directory is
  introduced.
- Bad, because two forms mean a reader checks the map for which one a repository uses.
- Bad, because maintaining generated indexes requires generator tooling and checker validation.

## Confirmation

`tools/doc-kit-check.sh` and `tests/doc-kit-check.test.sh`

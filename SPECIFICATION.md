# Specification

What a repository must look like to be conformant with this kit. It is the contract the checker
enforces, and the answer to "is this repository actually adopting the structure, or does it just
have some of the filenames?"

Requirement keywords — MUST, MUST NOT, SHOULD, SHOULD NOT, MAY — are used as defined in
[RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

## 1. Terms

Defined in `docs/glossary.md`. The ones this document leans on hardest are **map**, **artifact**,
**adopting repository** and **documentation file**.

A **documentation file** is any Markdown file in the repository that is not part of a vendored
dependency, not generated into an ignored directory, and not below an archive (§5). This definition
is what makes the map's completeness check decidable, so a checker MUST implement exactly it.

## 2. The map

2.1 A conformant repository MUST contain a map at `DOCUMENTATION.md` in its root.

2.2 The map MUST contain an artifacts table and a lifecycle table, and both MUST name the same set
of artifacts. A checker MUST report any artifact appearing in one and not the other.

2.3 Every artifact named in the map MUST exist at the path the map gives. This is the check that
rots first; it MUST be enforced mechanically rather than by review.

2.4 Every documentation file MUST appear in the map, either individually or under a directory
pattern the map names. This is the check that rots second.

2.5 The map MUST NOT retain the template banner. Its presence means customisation was never done.

2.6 Paths in the map MUST be the repository's real paths. In a monorepo the per-module artifacts
MUST sit under the module they describe, and only the map, `README.md`, `CHANGELOG.md` and
`PLAN.md` remain at the root.

2.7 A map MAY name artifacts this specification does not define. It MUST give each one a tense, a
durability and an audience, since that is what makes the next addition decidable.

## 3. Artifacts

### 3.1 Architecture decision records

Filenames MUST match `NNNN-kebab-case-title.md` with a four-digit zero-padded number, and numbers
MUST be unique. Each record MUST carry `Status`, `Context`, `Decision` and `Consequences` sections.

`Status` MUST be exactly one of `Proposed`, `Accepted`, `Deprecated`, or `Superseded by ADR-NNNN`
naming a record that exists.

A record whose status is `Accepted` MUST NOT be edited except to change its status. Correcting one
means writing its successor. A checker cannot verify this from a working tree and SHOULD verify it
from history instead, treating any content diff to an accepted record as a violation.

### 3.2 Changelog

The changelog MUST follow [Keep a Changelog](https://keepachangelog.com): reverse-chronological, an
`Unreleased` section at the top, and only the categories `Added`, `Changed`, `Deprecated`,
`Removed`, `Fixed`, `Security`.

Entries MUST describe effects visible outside the repository. Internal refactors MUST NOT appear.

The changelog MUST NOT be backfilled on adoption. Starting at the adoption date is correct.

### 3.3 Plan

Each entry MUST carry a type tag of `bug`, `debt`, `feature` or `docs`, and SHOULD carry an
importance and an effort. The scales are three-valued — `low`, `medium`, `high` — and mean:

- **Importance** — what it costs to keep not doing this.
- **Effort** — `low` is under a day, `medium` is under a week, `high` is anything larger or anything
  whose size is not yet known.

An entry MUST be one paragraph. Anything needing more needs an ADR or a task note instead.

Completed entries MUST be deleted, not annotated. A plan containing entries marked done, struck
through, or moved to a "completed" section is non-conformant, because that is the specific failure
that makes a plan stop being read.

### 3.4 Research notes

Each note MUST state its sources and MUST carry a confidence level of `high`, `medium` or `low`,
meaning:

- **high** — verified directly against the thing itself: the source code, the running system, a
  normative specification. Someone repeating the work would reach the same answer.
- **medium** — supported by sources that agree, but not verified directly. Plausible and unrefuted.
- **low** — inferred, reconstructed, or resting on a single unverified source. Recorded because
  losing it costs more than the risk of relying on it, which is a risk the reader now knows about.

Confidence MUST be revised in place as evidence changes; the note itself is append-mostly.

An unsourced note is not a research note. It is either specification, if it states behaviour, or an
ADR, if it states a choice.

### 3.5 Quirks

Each entry MUST state the expected behaviour, the actual behaviour, and whether the deviation is
**deliberate** or **accepted-wrong**.

An accepted-wrong entry SHOULD name the test that asserts today's incorrect output, so the next
reader does not "fix" it, and SHOULD carry an expiry condition — what would have to change for the
entry to be removed.

## 4. Single source of truth

4.1 No fact may appear in two artifacts. Where a fact is genuinely needed in two places, one of them
MUST link rather than restate.

4.2 Prose MUST NOT restate a machine-readable contract. It MUST link to the contract and cover only
what the contract cannot express: rationale, invariants, units, ownership, policy.

4.3 A generated artifact MUST carry a header naming what generates it, and regenerating it MUST
produce no diff. A checker MUST fail if it does. Without this, "generated" becomes "generated once,
then hand-edited", and a partly-stale generated artifact is worse than none because it is believed.

4.4 An ordered, immutable-once-applied sequence — database migrations being the usual case — is
changelog-shaped whatever it describes, and MUST NOT be treated as specification. The specification
is the current shape.

## 5. The archive

An adopting repository MAY quarantine documentation it cannot verify in an archive directory,
conventionally `docs/archive/`.

5.1 Files below an archive are **not** documentation files for the purposes of §2.4, and a checker
MUST exempt them. The archive itself MUST appear in the map as a single entry.

5.2 Every file in the archive MUST begin with a provenance header stating that it is not
authoritative, when it was last known to be accurate, and why it was not migrated. A folder-level
warning is not sufficient: readers and tools arrive at these files directly, by search, and never
see the folder.

5.3 An archived file MUST NOT be cited as a source by any artifact outside the archive. Anything in
it worth relying on MUST be migrated first, at which point it acquires a confidence level (§3.4).

5.4 The archive is for material whose **currency cannot be established**, not merely material that
is hard to read. Text that a reader can parse but cannot date belongs here; the failure this guards
against is a plausible-looking stale claim being promoted into the specification, where the
structure instructs everyone to trust it.

## 6. Conformance

A repository is **structurally conformant** if it satisfies every MUST in §2 and §3. This is
mechanically checkable and is what the checker reports on.

A repository is **substantively conformant** if it also satisfies §4 — no duplicated facts, no prose
restating a contract. This is not mechanically checkable in general and is a review responsibility.

Partial adoption is expected and is not a failure. A repository mid-migration SHOULD be structurally
conformant at every point, because the map promising only what exists is the property that makes an
interrupted migration safe to resume.

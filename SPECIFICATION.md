# Specification

What a repository must look like to be conformant with this kit. It is the contract the checker
enforces, and the answer to "is this repository actually adopting the structure, or does it just
have some of the filenames?"

Requirement keywords — MUST, MUST NOT, SHOULD, SHOULD NOT, MAY — are used as defined in
[RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

Requirements here fall into two kinds, and conflating them would make tooling a condition of
adopting a documentation structure. Requirements **on a repository** describe its state, and a
repository satisfies them however it likes — by review, by habit, or by hand. Requirements **on a
checker** apply only to software implementing these checks, and are written as "a checker MUST …".
No repository is obliged to run one. Verifying by hand is fully conformant.

## Purpose and scope

A repository adopting this kit gains one property: **every fact about the project has exactly one
place it belongs, and the tense of the sentence tells you which.** Everything below is machinery for
holding that property.

Three things follow, and they bound what the rest of this document is trying to achieve.

**It is for facts that cannot be derived from the code.** Why something is as it is; what is
deliberately wrong; what is out of scope; what can no longer be dated. Behaviour a reader can
establish by reading the source is better established that way — prose restating it competes with a
source of truth that cannot go stale, and loses.

**It is a write discipline before it is a reference.** Its most-asked question is "where does this
go?", at the moment something is written down. That is when sprawl is cheapest to prevent, and it is
the question a growing share of documentation authors — human and otherwise — get wrong by default.

**Volume is a cost, not a measure of success.** An artifact nobody has a reason to write is one the
map should not name. A repository whose constraints fit on one page does not need this structure and
should not adopt it.

### Not in scope

This specification governs where facts live and how documents relate. It says nothing about writing
quality, house style, or what a project ought to document. It does not cover generated API
reference, documentation sites, or code comments, except to say where their outputs sit (§4).
Adopting it is not a claim that a repository is well documented — only that what is documented is
findable, current, and in one place.

## 1. Terms

Defined in `docs/glossary.md`. The ones this document leans on hardest are **map**, **artifact**,
**adopting repository** and **documentation file**.

A **documentation file** is any Markdown file in the repository that is not part of a vendored
dependency, not generated into an ignored directory, and not below an archive (§5). This definition
is what makes the map's completeness check decidable, so a checker MUST implement exactly it.

## 2. The map

2.1 A conformant repository MUST contain a map at `DOCUMENTATION.md` in its root.

2.2 The map names its artifacts in three places: the layout block, the artifacts table and the
lifecycle table. All three MUST name the same set, and a checker MUST report any artifact appearing
in one and not another.

**The artifacts table is authoritative.** Its first cell is a backticked path, one artifact per row,
so it is the only one of the three that a checker can read without inference: the layout block is an
indented tree whose entries are relative to their parent, and the lifecycle table omits paths where
an entry is per-item rather than per-file. Tools MUST take the artifact set from the artifacts
table, and treat the other two as views that must agree with it. When comparing, a trailing `/` and
a trailing `/*` denote the same directory artifact.

2.3 Every artifact named in the map MUST exist at the path the map gives. This is the check that
rots first, and it SHOULD be given a mechanism — a checker, a review step, a release ritual —
rather than left to memory.

2.4 Every documentation file MUST appear in the map, either individually or under a directory
pattern the map names. This is the check that rots second.

2.5 The map MUST NOT retain placeholder content from the template — an example artifact row, an
unreplaced heading. Templates carry an example rather than instructions (ADR-0011), so a surviving
example is the signal that customisation was never finished.

2.6 Paths in the map MUST be the repository's real paths. In a monorepo the per-module artifacts
MUST sit under the module they describe, and only the map, `README.md`, `CHANGELOG.md` and
`PLAN.md` remain at the root.

2.7 A map MAY name artifacts this specification does not define. It MUST give each one a tense, a
durability and an audience, since that is what makes the next addition decidable.

2.8 A repository MAY contain uncustomised template artifacts — a repository distributing this kit
necessarily does. A checker MUST evaluate only the root map as an instance, and MUST NOT evaluate
any artifact the map identifies as a template or as product. Without this, a repository shipping the
kit fails §2.5 on its own templates, which is the check reporting the opposite of the truth.

## 3. Artifacts

**How much ceremony an artifact needs follows from its mutability, not from its importance.**

- **Immutable** artifacts need a freeze point, because after it nothing can be corrected in place.
  That is what `proposed` → `accepted` is for, and it is the only place this specification requires
  a moment of agreement.
- **Rewritten-in-place** artifacts — the specification, the map, quirks, the glossary — need no
  freeze point. A wrong statement is corrected, not superseded. Where such a change encodes a real
  choice, the choice belongs in a record and is gated there; restating the gate would gate one
  decision twice.
- **Volatile** artifacts — the plan, task notes — should be gated as little as possible. Friction at
  capture is what empties a backlog. The decision point is ranking an entry and picking it up, not
  filing it.
- **Append-only** artifacts — the changelog — are gated by release, not by review.

**Use the gate you already have.** For most projects that is the pull request, and the flip to
`accepted` then costs nothing extra: merging it *is* the approval. Projects without pull requests
are not excluded — a meeting, a mailing list, or one person deciding all satisfy this specification,
which requires that agreement be recorded, not that it be reached any particular way.

The status is the durable half of that record. A pull request lives in a forge that can be migrated,
archived, or quietly lose its history; the record stays in the tree. The flip is the in-repository
trace of an out-of-repository event — the same reason this structure keeps facts in the repository
rather than in a tracker.

### 3.1 Architecture decision records

Records follow the [MADR](https://adr.github.io/madr/) minimal template. Filenames MUST match
`NNNN-kebab-case-title.md` with a four-digit zero-padded number, and numbers MUST be unique and
never reused. The heading MUST repeat the number. See ADR-0010.

Each record MUST carry YAML front-matter with `status` and `date`, and SHOULD carry
`decision-makers`. MADR's `consulted` and `informed` are permitted and not required — RACI fields
are overhead below a certain team size.

Each record MUST carry `Context and Problem Statement`, `Considered Options` and `Decision Outcome`
sections, and SHOULD carry `Consequences` as a subsection of the last. **`Considered Options` is
what makes a record a decision rather than a statement**; a record with only one option to consider
is usually a specification entry that has been misfiled.

`status` MUST begin with exactly one of these, lowercase:

| Value | Meaning |
|---|---|
| `proposed` | Suggested, not yet decided. Binds nothing |
| `rejected` | Considered and turned down. Kept so the option is not re-proposed |
| `accepted` | Decided and in effect |
| `deprecated` | No longer applies, and nothing replaced it |
| `superseded by ADR-NNNN` | Replaced by a later record, which MUST exist |

A status MAY carry a parenthesised forward pointer naming a record that exists:

```text
accepted (refined by ADR-0006)
```

`refined by` means the decision stands, and a later record has revised something that follows from
it. It is set on the earlier record when the later one is accepted. It MUST NOT be used where the
`Decision Outcome` itself stopped being true — that is supersession, and the heavier form is
correct. Choosing between them is a judgement, which is why it is a human action like any other
status change. See ADR-0009.

**Immutability attaches to the status, not to the commit.** A record whose status is `proposed` MAY
be edited freely, and MAY be merged while still undecided — a pending decision in the tree is more
discoverable than one living in an unmerged branch, which is the point of having the status at all.
A record whose status is `accepted` MUST NOT be edited except to change its `status`, `date` and
`decision-makers`. Those three change together at acceptance, which is the moment `decision-makers`
becomes required — a rule permitting only the first two would make it impossible to comply with the
second.

**Immutability begins at publication.** A record nobody outside its author could have read has no
reader who relied on it, so correcting a drafting error in one is not rewriting history. In practice
the line is the first push to a shared remote. This matters during adoption, where records are
often drafted in a batch before anything is shared. The exception MUST NOT be stretched past that
line: once a record is visible to others, it is fixed, and the remedy for a mistake is a successor.

**Only `accepted` records bind.** A `proposed` record is a suggestion, and no reader — human or
automated — may treat it as a constraint.

**Changing a record's status is a human action.** A tool MAY draft, argue and merge a record as
`proposed`; any other status MUST be set by a person, who is thereby asserting that a decision was
actually made, and who SHOULD name themselves in `decision-makers`. The assertion is not
mechanically verifiable, but the *presence* of `decision-makers` on a record is. See ADR-0008.

Projects using pull requests SHOULD make the status change **its own pull request**, separate from
the one that introduced the record. Not merely a separate commit: a squash merge collapses the
branch into one commit on the trunk, taking the separation with it. A dedicated pull request keeps
the moment of acceptance visible whatever the merge strategy, and reduces it to a one-line diff
whose entire content is "we have decided this" — the easiest thing in a repository to review, and
the hardest to slip past a reviewer.

Approval beyond that is the adopting project's business. Review on a pull request satisfies this
specification; so does a meeting, or one person deciding. What matters is that the flip from
`proposed` to `accepted` records that the decision was made, and that nothing is edited afterwards.

A checker cannot verify immutability from a working tree and SHOULD verify it from history instead,
treating any content diff to a record that was already `accepted` as a violation.

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
mechanically checkable, and is what a checker reports on — but it is checkable, not checked-by-
obligation. A repository that never runs one and holds the properties anyway is conformant.

A repository is **substantively conformant** if it also satisfies §4 — no duplicated facts, no prose
restating a contract. This is not mechanically checkable in general and is a review responsibility.

Partial adoption is expected and is not a failure. A repository mid-migration SHOULD be structurally
conformant at every point, because the map promising only what exists is the property that makes an
interrupted migration safe to resume.

# Specification

What a repository must look like to be conformant with this kit. It is the contract the checker
enforces, and the answer to "is this repository actually adopting the structure, or does it just
have some of the filenames?"

Requirement keywords - MUST, MUST NOT, SHOULD, SHOULD NOT, MAY - are used as defined in
[RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

Requirements here fall into two kinds, and conflating them would make tooling a condition of
adopting a documentation structure. Requirements **on a repository** describe its state, and a
repository satisfies them however it likes - by review, by habit, or by hand. Requirements **on a
checker** apply only to software implementing these checks, and are written as "a checker MUST ...".
No repository is obliged to run one. Verifying by hand is fully conformant.

## Purpose and scope

The kit's purpose, governing model (one owner directing many agent sessions), and decision
boundaries are recorded in [ADR-0001](decisions/0001-what-the-kit-is-for-and-who-decides.md). This
specification does not restate them (§4.1).

It achieves that purpose by giving the repository one property: **every fact about the project has
exactly one place it belongs, and the tense of the sentence tells you which.** Everything below is
machinery for holding that property.

Three things follow, and they bound what the rest of this document is trying to achieve.

**It is for facts that cannot be derived from the code.** Why something is as it is; what is
deliberately wrong; what is out of scope; what can no longer be dated. Behaviour a reader can
establish by reading the source is better established that way - prose restating it competes with a
source of truth that cannot go stale, and loses.

**It is a write discipline before it is a reference.** Its most-asked question is "where does this
go?", at the moment something is written down. That is when sprawl is cheapest to prevent, and it is
the question agent sessions get wrong by default.

**Volume is a cost, not a measure of success.** An artifact nobody has a reason to write is one the
map should not name. A repository whose constraints fit on one page does not need this structure and
should not adopt it.

### Not in scope

This specification governs where facts live, how documents relate, and the tense and volume of what
is written. Code comments it governs for tense and routing only (ADR-0012). It says nothing about
house style or what a project ought to document. It does not cover generated API reference or
documentation sites, except to say where their outputs sit (§4). It gives no guidance to several
people deciding together: such a repository can use it, but how they agree is its own business.
Adopting it is not a claim that a repository is well documented - only that what is documented is
findable and in one place.

**It does not make documentation true.** Nothing here prevents a clause from going stale, and a
checker cannot tell. Only two things resist rot: a claim derived from something else (§4.3), and a
claim with a test behind it, as quirk entries record with `Pinned by:`. A specification clause with
neither is a claim nobody checks.

## 1. Terms

Defined in `docs/glossary.md`. The ones this document leans on hardest are **map**, **artifact**,
**adopting repository** and **documentation file**.

A **documentation file** is any Markdown file in the repository that is not below an archive (§5)
and not vendored. A file is **vendored** when its `linguist-vendored` git attribute is set - the
attribute GitHub Linguist defines for third-party code, conventionally set in `.gitattributes`
(ADR-0011). This definition is what makes the map's completeness check decidable, so a checker MUST
implement exactly it. A file being gitignored does not remove it from this definition - see §2.9 for
how a checker MUST treat one.

## 2. The map

2.1 A conformant repository MUST contain a map at `DOC-MAP.md` in its root.

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
rots first, and it SHOULD be given a mechanism - a checker, a review step, a release ritual - rather
than left to memory.

2.4 Every documentation file MUST appear in the map, either individually or under a directory
pattern the map names. This is the check that rots second.

2.5 The map MUST NOT retain placeholder content from the template - an example artifact row, an
unreplaced heading. Templates carry an example rather than instructions (ADR-0006), so a surviving
example is the signal that customisation was never finished.

2.6 Paths in the map MUST be the repository's real paths. Only files a tool or a convention looks
for at the root - the map, `README.md`, `AGENTS.md` and its aliases, `CHANGELOG.md` - SHOULD sit
there; every other artifact SHOULD sit under `docs/` (ADR-0014). In a monorepo the per-module
artifacts MUST sit under the module they describe, and only the map, `README.md`, `CHANGELOG.md` and
`docs/plan.md` stay at the repository root.

An artifact `name.md` that outgrows one file MAY gain a sibling directory `name/` holding its parts.
The file stays as the entry point - an index or summary linking into the directory - so links to it
stay true, and each part the map distinguishes gets its own row (ADR-0014).

2.7 A map MAY name artifacts this specification does not define. It MUST give each one a tense, a
mutability and an audience, drawn from these sets:

| Property   | Values                                                                                  |
| ---------- | --------------------------------------------------------------------------------------- |
| Tense      | `present`, `past`, `future`, `imperative`, `explanatory`                                |
| Mutability | `rewritten in place`, `amendable`, `append-only`, `immutable`, `volatile`, `disposable` |
| Audience   | one or more of `owner`, `contributor`, `consumer`, `end-user`, `operator`               |

The roles are defined in ADR-0002: the owner decides; a contributor changes the repository; a
consumer builds on what it publishes; an end-user uses the running product; an operator deploys and
runs it. A role covers human and agent readers both, and one read by only one kind says so after the
role - `contributor (agents)` or `contributor (humans)`. Roles are separated by commas, in any
order.

Two artifacts sharing all three are usually one artifact: merge them, or make one a section of the
other, unless they hold different facts. A checker MUST report a shared triple as advisory, and MUST
NOT let it affect the exit status (ADR-0002). Free-text properties defeat that test -
near-duplicates escape on phrasing rather than substance - which is why all three are closed sets.

An **alias** is exempt: a file whose entire content points at another artifact, existing only
because a tool looks for that filename. It appears in the map, carries the properties of what it
points at, and adds nothing of its own.

2.8 A repository MAY contain uncustomised template artifacts - a repository distributing this kit
necessarily does. A checker MUST evaluate only the root map as an instance, and MUST NOT evaluate
any artifact the map identifies as a template or as product. Without this, a repository shipping the
kit fails §2.5 on its own templates, which is the check reporting the opposite of the truth.

2.9 A documentation file that is gitignored is not exempt from §2.4 - a checker MUST still evaluate
it against the map. But a checker MUST report a hit in one as advisory, and MUST NOT let it affect
exit status: gitignored documentation (a repository's own working-notes convention, say) is a real,
recurring category this specification does not get to assume away, and it deserves checking without
ever blocking on content the map was never meant to describe (ADR-0011). A reviewer verifying by
hand applies the same judgement: check it, don't block on it.

## 3. Artifacts

**How much ceremony an artifact needs follows from its mutability, not from its importance.**

- **Amendable** artifacts - decision records - need the owner. A contributor creates and changes
  `proposed` records freely; accepting, rejecting, reopening, deprecating and deleting a record each
  need the owner's explicit permission (§3.1). It is the only place this specification requires a
  decision by a person.
- **Rewritten-in-place** artifacts - the specification, the map, quirks, the glossary - need no
  freeze point. A wrong statement is corrected, not superseded. Where such a change encodes a real
  choice, the choice belongs in a record and is decided there; deciding it again here would decide
  one choice twice.
- **Volatile** artifacts - the plan, task notes - should be gated as little as possible. Friction at
  capture is what empties a backlog. The decision point is ranking an entry and picking it up, not
  filing it.
- **Append-only** artifacts - the changelog - are gated by release, not by review.
- **Immutable** artifacts - the archive - are not changed at all.

The status and `approval` are the durable record of the owner's decision. A conversation or a forge
can lose it; the tree keeps it.

### 3.1 Decision records

Records follow the [MADR](https://adr.github.io/madr/) minimal template. Filenames MUST match
`NNNN-kebab-case-title.md` with a four-digit zero-padded number, and numbers MUST be unique and
never reused. The heading MUST repeat the number. The title SHOULD name the question the record
answers rather than the answer, so that a changed answer leaves it true. See ADR-0007.

Each record MUST carry YAML front-matter with `status` and `date`. A record whose status is not
`proposed` MUST also carry `decision-makers`, naming the owner, and `approval`: the owner's words,
verbatim, giving permission for its latest change of status. `date` is the date of that change.
MADR's `consulted` and `informed` are permitted and not required.

Each record MUST carry `Context and Problem Statement`, `Considered Options` and `Decision Outcome`
sections, and SHOULD carry `Consequences` as a subsection of the last. A record MAY carry a
`Confirmation` section naming the test, check or assertion that confirms compliance with the
decision. **`Considered Options` is what makes a record a decision rather than a statement**; a
record with only one option to consider is usually a specification entry that has been misfiled.

`status` MUST be exactly one of these, lowercase:

| Value        | Meaning                                                             |
| ------------ | ------------------------------------------------------------------- |
| `proposed`   | Put to the owner, not yet decided. Binds nothing                    |
| `accepted`   | Decided by the owner, and in effect                                 |
| `rejected`   | Turned down by the owner, and kept so that it is not proposed again |
| `deprecated` | No longer applies. Links to any record that replaced it             |

These are MADR's own values. MADR's `superseded by` is not used: a replaced record is deprecated or
deleted, and links to its replacement.

**Only `accepted` records bind.** `proposed` exists so that an agent can put a decision in front of
the owner before it is decided. No reader - human or automated - may treat a `proposed` record as a
constraint.

**The owner decides every change of status.** A contributor MAY create a record as `proposed`,
copied from the template rather than from another record, and MAY change a `proposed` record freely.
It MUST have the owner's explicit permission, asked for first, to accept a record (`proposed` to
`accepted`), reject one (`proposed` to `rejected`), reopen one to change it (`accepted` to
`proposed`), deprecate one (`accepted` to `deprecated`), or delete one of any status. General
approval - "looks good", "go ahead", approval of other work - is not permission. When the owner
rejects a change to a reopened record, its last accepted version is restored, rather than the record
being marked `rejected`. A record is normally accepted before it is committed, so history holds its
accepted versions. Formatting applied by a tool, which alters no word, is not a change. See ADR-0007
and ADR-0001.

**An accepted record is the current answer to its question.** It is reopened and amended in place,
including to reverse its decision. When its question splits or merges with another, or it no longer
applies, it is deprecated or - more simply - deleted, and links to any record that replaces it. A
later choice between real options is its own record, linked from the earlier one. A record carries
no revision log; git holds what it said when. See ADR-0007.

**Citations take one form.** A record is cited as `ADR-NNNN` - upper case, a hyphen, four digits -
and a bare ID MUST name a record in this repository. A record in another repository is cited by a
link to it. A citation SHOULD claim as little about the record as it can. A change to a record, its
deletion included, MUST be committed together with every citation in the repository that it makes
untrue, found by searching for the record's ID. Commit messages are history, and are not changed.

A checker MUST report a record whose status is not `proposed` that lacks `decision-makers` or
`approval`, and a bare `ADR-NNNN` outside code that names no record in this repository. It cannot
verify that `approval` holds the owner's words, nor that an amendment fixed its citations.

A repository MAY maintain a generated index of decision records at `docs/decisions.md` (or
`docs/decisions/README.md`). If present, it MUST carry a generated header naming what generates it,
and regenerating it MUST produce no diff (§4.3).

### 3.2 Changelog

The changelog MUST follow [Keep a Changelog](https://keepachangelog.com): reverse-chronological, an
`Unreleased` section at the top, and only the categories `Added`, `Changed`, `Deprecated`,
`Removed`, `Fixed`, `Security`.

Entries MUST describe effects visible outside the repository. Internal refactors MUST NOT appear.

The changelog MUST NOT be backfilled on adoption. Starting at the adoption date is correct.

### 3.3 Plan

Each entry MUST carry a type tag of `bug`, `debt`, `feature` or `docs`, and SHOULD carry an
importance and an effort. The scales are three-valued - `low`, `medium`, `high` - and mean:

- **Importance** - what it costs to keep not doing this.
- **Effort** - `low` is under a day, `medium` is under a week, `high` is anything larger or anything
  whose size is not yet known.

An entry MUST be one paragraph. Anything needing more needs an ADR or a task note instead.

Completed entries MUST be deleted, not annotated. A plan containing entries marked done, struck
through, or moved to a "completed" section is non-conformant, because that is the specific failure
that makes a plan stop being read.

### 3.4 Research notes

Each note MUST state its sources and MUST carry a confidence level of `high`, `medium` or `low`,
meaning:

- **high** - verified directly against the thing itself: the source code, the running system, a
  normative specification. Someone repeating the work would reach the same answer.
- **medium** - supported by sources that agree, but not verified directly. Plausible and unrefuted.
- **low** - inferred, reconstructed, or resting on a single unverified source. Recorded because
  losing it costs more than the risk of relying on it, which is a risk the reader now knows about.

Confidence MUST be revised in place as evidence changes; the note itself is append-mostly.

An unsourced note is not a research note. It is either specification, if it states behaviour, or an
ADR, if it states a choice.

### 3.5 Quirks

Each entry MUST state the expected behaviour, the actual behaviour, and whether the deviation is
**deliberate** or **accepted-wrong**.

An accepted-wrong entry SHOULD name the test that asserts today's incorrect output, so the next
reader does not "fix" it, and SHOULD carry an expiry condition - what would have to change for the
entry to be removed.

### 3.6 How-to guides

A repository MAY hold recurring task-oriented procedures under `docs/howto/`, optionally indexed at
`docs/howto.md`.

Each guide MUST be written in the imperative mood, SHOULD state its goal, prerequisites, sequential
steps, and verification criteria, and SHOULD cite conventions and exemplars rather than duplicating
their text.

### 3.7 External sources

A repository MAY maintain external standards, whitepapers and specifications under `docs/sources/`.

The manifest at `docs/sources.md` (or `docs/sources/README.md`) indexes each source with its URL,
retrieval date, licence, redistributability status, and SHA-256 checksum. A source that is not
explicitly redistributable under its licence MUST NOT be committed to git and MUST be gitignored.
Generated text or Markdown extracts derived from cached sources MUST carry a provenance header per
§4.3 naming the generator.

## 4. Single source of truth

4.1 No fact may appear in two artifacts. Where a fact is genuinely needed in two places, one of them
MUST link rather than restate.

4.2 Prose MUST NOT restate a machine-readable contract. It MUST link to the contract and cover only
what the contract cannot express: rationale, invariants, units, ownership, policy.

4.3 A generated artifact MUST carry a header naming what generates it, and regenerating it MUST
produce no diff. A checker MUST fail if it does. Without this, "generated" becomes "generated once,
then hand-edited", and a partly-stale generated artifact is worse than none because it is believed.

4.4 An ordered, immutable-once-applied sequence - database migrations being the usual case - is
changelog-shaped whatever it describes, and MUST NOT be treated as specification. The specification
is the current shape.

## 5. The archive

An adopting repository MAY quarantine documentation it cannot verify in an archive directory,
conventionally `docs/archive/`, optionally indexed at `docs/archive.md`.

5.1 Files below an archive are **not** documentation files for the purposes of §2.4, and a checker
MUST exempt them. The archive itself (or its index `docs/archive.md`) MUST appear in the map as a
single entry.

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
mechanically checkable, and is what a checker reports on - but it is checkable, not checked-by-
obligation. A repository that never runs one and holds the properties anyway is conformant.

A repository is **substantively conformant** if it also satisfies §4 - no duplicated facts, no prose
restating a contract. This is not mechanically checkable in general and is a review responsibility.

Partial adoption is expected and is not a failure. A repository mid-migration SHOULD be structurally
conformant at every point, because the map promising only what exists is the property that makes an
interrupted migration safe to resume.

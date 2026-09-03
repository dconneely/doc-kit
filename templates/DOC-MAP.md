# Documentation map

This is the map. It describes what each document in this project is for, who reads it, how long it
lives, and - the question it exists to answer - **where a given fact belongs**.

Start here when you have something to write down and are not sure which file it goes in.

## Where does it go?

The tense of the sentence you are writing usually settles it:

| If you are writing...                                    | It belongs in                                                                          |
| -------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| "the system does X"                                      | the specification                                                                      |
| "we chose X because Y"                                   | an ADR                                                                                 |
| "X used to be Y, now it is Z"                            | the changelog                                                                          |
| "we should do X"                                         | the plan                                                                               |
| "we knowingly differ from the reference/spec here"       | `docs/quirks.md`                                                                       |
| "source A says X, source B says Y, and A won because..." | a research note                                                                        |
| "X means Y in this codebase"                             | the glossary                                                                           |
| "the schema / wire format / API accepts X"               | the machine-readable contract, linked from the specification - never restated in prose |
| "this is how each document is used"                      | this file                                                                              |

If a sentence seems to fit two places, it is usually two sentences. Split it and file each half.

## Layout

```text
DOC-MAP.md         this file - the map
README.md                orientation, one screen, links outward
SPECIFICATION.md         the behaviour contract - an index once it grows (see below)
CHANGELOG.md             what shipped
PLAN.md                  single ranked backlog, items tagged bug/debt/feature/docs
docs/
  adr/*.md               decisions, numbered, immutable once accepted
  quirks.md              deliberate deviations and accepted-wrong behaviour
  research/*.md          sourced findings with confidence levels
  glossary.md            domain vocabulary
  testing.md             test strategy, and what is deliberately not covered
  tasks/*.md             optional: per-item working notes, disposable
```

In a monorepo, everything below `docs/` moves under the module it describes, and only `DOC-MAP.md`,
`README.md`, `CHANGELOG.md` and `PLAN.md` stay at the root.

**The specification is a set, not a file, and it may be partly machine-readable.** Once it outgrows
one document it becomes an index plus a tree, and members of that tree can be schemas, interface
definitions or other executable contracts rather than prose. They are still the specification: they
are present tense, always current, and the contract someone relies on. What changes is only that
they are _checked by a machine_ rather than by a reader - which makes them better, not lesser,
specification. See "Machine-readable and generated parts" below.

## Artifacts

| Artifact             | Purpose - and the standard it follows, if any                                                                                                                                                                                                              | Tense   | Durability         | Audience                                                                                        |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ------------------ | ----------------------------------------------------------------------------------------------- |
| `DOC-MAP.md`         | This map: what each document is for, and where a fact belongs. **No standard**; nearest practice is a `docs/README.md` index, with [Diátaxis](https://diataxis.fr) supplying the rationale for splitting docs at all                                       | present | rewritten in place | anyone adding documentation                                                                     |
| `README.md`          | Orient a newcomer fast. Loose convention; [Standard Readme](https://github.com/RichardLitt/standard-readme) is the nearest written spec                                                                                                                    | present | rewritten in place | anyone                                                                                          |
| `SPECIFICATION.md`   | The behaviour contract. **No standard for the file.** Use [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) keywords (MUST/SHOULD/MAY) for requirement strength, [Diátaxis](https://diataxis.fr) for structuring the reference set once it becomes a tree | present | rewritten in place | users + implementers                                                                            |
| `docs/adr/*.md`      | Why we chose this. **Real convention:** [MADR](https://adr.github.io/madr/) minimal template, after Nygard 2011; see also [adr.github.io](https://adr.github.io) and [adr-tools](https://github.com/npryce/adr-tools)                                      | past    | immutable          | future maintainers                                                                              |
| `CHANGELOG.md`       | What shipped, user-visible. **Real standard:** [Keep a Changelog](https://keepachangelog.com) + [SemVer](https://semver.org); generatable from [Conventional Commits](https://www.conventionalcommits.org)                                                 | past    | append-only        | users                                                                                           |
| `PLAN.md`            | Single ranked backlog, items tagged bug/debt/feature/docs. **No standard**, and no named source - the closest analogue is the RFC/design-doc tradition, which prescribes no root-level file of this name                                                   | future  | volatile           | the team                                                                                        |
| `docs/quirks.md`     | Deliberate deviations, and bugs knowingly left unfixed - the one artifact that says _do not change this_. **No standard.** Nearest analogues are W3C conformance clauses and browser-compat tables                                                         | present | rewritten in place | users comparing against a reference, and anyone - human or agent - about to "fix" something odd |
| `docs/research/*.md` | Sourced findings with explicit confidence levels. **No standard.** Orthodox home is an ADR's _Context_ section; splitting it out suits projects that do real investigation                                                                                 | past    | append-only        | implementers                                                                                    |
| `docs/glossary.md`   | Domain vocabulary. Convention: DDD's [ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html); ISO 704 for formal terminology work                                                                                                    | present | rewritten in place | readers of every other document                                                                 |
| `docs/testing.md`    | Test strategy, and what is deliberately _not_ covered. ISO/IEC/IEEE 29119-3 exists (superseded IEEE 829) but is enterprise-heavy for most projects                                                                                                         | present | rewritten in place | contributors                                                                                    |
| `docs/tasks/*.md`    | Working notes for one backlog item. **No standard.** Optional - usually overhead below ~20 open items                                                                                                                                                      | future  | disposable         | whoever picks it up                                                                             |

## Lifecycle

| Artifact                 | Created when                               | Removed / closed when                                            |
| ------------------------ | ------------------------------------------ | ---------------------------------------------------------------- |
| `DOC-MAP.md`             | the structure is first agreed              | never - revised when an artifact is added, removed or repurposed |
| `README.md`              | project starts                             | never                                                            |
| `SPECIFICATION.md`       | behaviour is decided                       | never - edited forever                                           |
| `docs/adr/*.md`          | a choice a newcomer would question         | never - status flips to `superseded by ADR-NNNN`                 |
| `CHANGELOG.md` entry     | at release, if user-visible                | never                                                            |
| `PLAN.md` entry          | idea occurs - one paragraph, no design     | **deleted** when done, not struck through                        |
| `docs/quirks.md` entry   | a deviation is chosen, or a bug accepted   | when the deviation ends                                          |
| `docs/research/*.md`     | a question is investigated                 | never - confidence gets revised                                  |
| `docs/glossary.md` entry | a term acquires a project-specific meaning | when the term leaves the codebase                                |
| `docs/testing.md`        | the second test approach appears           | never                                                            |
| `docs/tasks/*.md`        | work begins on an item                     | work completes                                                   |

## Flow

A change moves through the documents in this order:

`PLAN.md` entry -> (optional `docs/tasks/` note) -> **ADR** if a real choice was made ->
**`SPECIFICATION.md`** updated in present tense -> **`CHANGELOG.md`** line if user-visible ->
`PLAN.md` entry **deleted**.

Most changes skip the ADR and the task note. Nothing skips the deletion.

## Prescribed formats

These artifacts have a shape worth keeping to; the rest are free-form prose.

**ADR** - one file per decision, numbered `0001-short-title.md`, following the
[MADR](https://adr.github.io/madr/) minimal template. Copy `docs/adr/0000-template.md` for the
shape. The rules that file cannot express, and which live here:

- Status is one of `proposed`, `rejected`, `accepted`, `deprecated`, `superseded by ADR-NNNN`, and
  may carry a forward pointer: `accepted (refined by ADR-NNNN)` when a decision stands but a later
  record revised something following from it.
- **Only `accepted` binds.** A `proposed` record is a suggestion - merge it undecided if you like,
  since an open question is more visible in the tree than in a branch nobody is watching.
- **Immutable once accepted**, except to change status and date. Correct one by writing its
  successor, not by editing it.
- **Changing a status is a human action.** A tool may draft a record and argue it; only a person
  decides one. Make that flip its own pull request - a separate commit does not survive a squash
  merge, and the one moment worth seeing becomes invisible.

A record that exists to protect a constraint - _we do not do the obvious thing here, because it
breaks_ - is worth naming the constrained code in, for the same reason quirk entries do. The next
reader to reach for the obvious thing may be searching rather than browsing.

**Changelog** - reverse-chronological, an `Unreleased` section at the top, six fixed categories:
`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`. Entries describe user-visible
effects, not internal refactors.

**Plan entry** - a heading, a tag line, then one paragraph. No design; anything longer needs a task
note or an ADR. Entries are deleted when done, never annotated.

```markdown
## Short title, imperative
**Type:** bug - **Importance:** high - **Effort:** medium
```

- **Type** - `bug`, `debt`, `feature` or `docs`. Debt is a tag here, not a separate file: the
  debt-versus-feature trade-off can only be made inside one ordered list.
- **Importance** - `low`, `medium`, `high`: what it costs to keep not doing this.
- **Effort** - `low` under a day, `medium` under a week, `high` larger or not yet known.

**Research note** - sources, and a confidence level of `high` (verified directly against the thing
itself), `medium` (sources agree, not verified directly) or `low` (inferred, or a single unverified
source). Confidence is revised in place as evidence changes. An unsourced note is not research: it
is specification if it states behaviour, an ADR if it states a choice.

**Findings and Evidence are the current answer, not a log of how it was reached.** State what is
true and its source; when new evidence supersedes an earlier read, rewrite the finding and its
confidence in place - the same discipline the specification uses against "previously X, now Y" (see
Failure modes). Dead ends are substantive wrong turns - a hypothesis that failed, a source that
misled - not the research process itself (pass counts, who suggested a search, which tool call
failed first).

**Quirk entry** - the expected behaviour, the actual behaviour, and whether the deviation is
**deliberate** or **accepted-wrong**. An accepted-wrong entry names the test pinning today's output,
so nobody "fixes" it, and states what would have to change for the entry to go.

**Alias** - a file whose entire content points at another artifact, existing only because some tool
or convention looks for that exact filename: a second `README.md` at a different path a newcomer
would actually look in, a specification member duplicated per module. Mark it `**Alias**` in the
artifacts table's purpose cell; it carries the tense, durability and audience of what it points at
rather than declaring its own. This is the one case exempt from the duplicate-properties check
below - use it before inventing artificially different audience wording just to dodge that test. If
the file has anything to say beyond the pointer, it is not an alias.

## Machine-readable and generated parts

Three kinds of thing get confused with each other, and the rules differ:

| Kind                                                                    | Rule                                                                                       |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| **Source of truth** - schemas, interface definitions, migrations        | versioned and reviewed like code; it _is_ the contract, not a description of one           |
| **Generated view** - diagrams, rendered references, snapshots, clients  | never hand-edited; carries a generated-by header; CI fails if regenerating produces a diff |
| **Prose that cannot be derived** - rationale, invariants, policy, units | the only part that belongs in `docs/` as writing                                           |

Without that CI check, "generated" quietly becomes "generated once, then hand-edited", and a
partly-stale generated specification is worse than none: it is believed.

Note also that **append-only sequences are changelog-shaped, whatever they describe.** A directory
of ordered, immutable-once-applied migrations is the data store's changelog, not its specification;
the specification is the _current_ shape, which is why a generated snapshot of it earns its place
alongside them.

## Three rules that hold it together

1. **Each fact lives in exactly one place**, and the tense of the sentence tells you which:
   rationale -> ADR, behaviour -> specification, history -> changelog, intent -> plan.
2. **Never edit an accepted ADR** - supersede it, and set the old status to
   `superseded by ADR-NNNN`. Its whole value is being faithful to what was known at the time.
3. **The specification may link to a machine-readable contract; it must never restate it.** The
   moment prose repeats a field list, there are two sources of truth and one of them is already
   wrong. Link to the artifact, then cover only what the artifact cannot express.

## Failure modes this guards against

- **The plan becomes a graveyard** - entries annotated "DONE" rather than deleted, until nobody can
  see what is actually open.
- **The changelog becomes a commit log** - every internal refactor listed, so users cannot find what
  affects them.
- **ADRs get edited** - destroying their value as a record of what was known at the time.
- **The specification accumulates history** - "previously X, now Y", turning reference material into
  narrative.
- **Findings evaporate** - an investigation's sources and dead ends survive only in a commit message
  or a code comment, and the next person repeats the work.
- **A research note becomes a research diary** - "found in a second pass", "this note originally
  claimed X, now corrected" - narrating how a finding was reached instead of stating what is
  currently true. The same "previously X, now Y" failure as the specification, just as easy to fall
  into here: revise the finding and its confidence in place instead.

## Deliberately not here

Absent on purpose, so that adding any of them later is a decision rather than a drift:

- **A separate technical-debt file.** Debt shares its tense, mutability and audience with the plan,
  so splitting it out divides on category where everything else divides on those three properties.
  Worse, it hides the debt-versus-feature trade-off, which can only be weighed inside one ordered
  list. Use the type tag instead.
- **An issue tracker**, until the backlog outgrows a file - roughly 20-30 open items. Below that,
  being in-repo and reviewable alongside the code is worth more than labels and queries.
- **Community health files** - `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md` - which earn
  their place when outside contributions begin, not before.
- **`RELEASING.md`**, which waits on there being releases, and **runbooks**, which belong to
  services rather than libraries and tools.

Only **Keep a Changelog** and **ADRs** are genuine standards; everything else here is convention,
and the artifacts table says so per row. The companion guide covers where each convention comes from
and how far to trust it.

## Adding a new kind of document

Before adding one, check it has a **distinct tense, mutability and audience** from everything in the
artifacts table. If it shares all three with an existing document, it is a section or a tag within
that document, not a new file - unless it has to exist as its own file for a reason unrelated to its
content (a second `README.md` at a path a newcomer would actually look in, a spec member repeated
per module). That case is an **alias**, not a merge - see "Prescribed formats" above. Most proposed
additions still fail the test outright, which is the point.

If it passes, add it to both tables here in the same commit. A map that omits an artifact is worse
than no map, because it is believed.

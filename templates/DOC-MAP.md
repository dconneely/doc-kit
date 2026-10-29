# Documentation map

What each document in this project is for, who reads it, how long it lives, and **where a given fact
belongs**. Start here when you have something to write down and are not sure which file it goes in.

Each artifact holds its own format and rules - in its preamble, or in its `0000-template.md` - and
this map does not restate them. Why the structure is shaped this way is in the adoption record,
`docs/decisions/0001-how-the-documentation-is-organised.md`.

## Where does it go?

The tense of the sentence you are writing usually settles it:

| If you are asking...                        | If you are writing...                                    | It belongs in                                                                             |
| ------------------------------------------- | -------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| "what does it do? can I rely on X?"         | "the system does X"                                      | the specification                                                                         |
| "should it do X at all?"                    | "X is out of scope" or "callers must not rely on X"      | the specification's scope, or what it leaves unspecified                                  |
| "why is it like this? was X tried?"         | "we chose X because Y", or "we chose not to do X"        | an ADR                                                                                    |
| "when did this change?"                     | "X used to be Y, now it is Z"                            | the changelog                                                                             |
| "is this known? is anyone fixing it?"       | "we should do X"                                         | the plan                                                                                  |
| "could this be faster, or smarter?"         | "X is worth doing once Y is true"                        | the plan, with Y named as the trigger                                                     |
| "is this a bug, or a decision?"             | "we knowingly differ from the reference/spec here"       | `docs/quirks.md`                                                                          |
| "why does it fail on X?"                    | "X is unhandled, and we know it"                         | `docs/quirks.md` as accepted-wrong, pinned by a test or assert                            |
| "is X tested?"                              | "X is deliberately not tested"                           | `docs/testing.md`                                                                         |
| "how do we know that?"                      | "source A says X, source B says Y, and A won because..." | a research note                                                                           |
| "why is this code like this?"               | "this code is like this because..."                      | a comment beside it - or an ADR the comment names, if the reason spans more than one site |
| "what did this code do before?"             | "this code used to..." or "fixed the bug where..."       | the commit message - never a comment                                                      |
| "is anything left to do here?"              | "this code should also..."                               | the plan - a `TODO` beside the code names the entry, never replaces it                    |
| "what does this word mean here?"            | "X means Y in this codebase"                             | the glossary                                                                              |
| "exactly what does the API accept?"         | "the schema / wire format / API accepts X"               | the machine-readable contract, linked from the specification - never restated in prose    |
| "how do I perform this procedure?"          | "run step 1, then step 2"                                | a how-to guide (`docs/howto/`)                                                            |
| "where did this external source come from?" | "source A was retrieved from URL B"                      | `docs/sources/`                                                                           |
| "what must an agent know to work here?"     | "an agent working here needs to know X"                  | `AGENTS.md`, if it is routing or a hazard - otherwise the document that owns the fact     |
| "where does this go?"                       | "this is how each document is used"                      | this file                                                                                 |

If a sentence seems to fit two places, it is usually two sentences. Split it and file each half.

## Layout

```text
DOC-MAP.md               this file - the map
README.md                orientation, one screen, links outward
AGENTS.md                orientation for coding agents - routes here
CLAUDE.md                one line pointing at AGENTS.md
CHANGELOG.md             what shipped
docs/
  spec.md                the behaviour contract - an index once it grows
  plan.md                single ranked backlog, items tagged bug/debt/feature/docs
  plan/*.md              optional: per-entry working notes
  plan/0000-template.md  optional: task-note template
  decisions.md           optional: index of decision records, generated
  decisions/*.md         decisions, numbered, accepted only by the owner
  quirks.md              deliberate deviations and accepted-wrong behaviour
  research/*.md          sourced findings with confidence levels
  glossary.md            domain vocabulary
  testing.md             test strategy, and what is deliberately not covered
  howto.md               optional: index of step-by-step procedures
  howto/*.md             optional: step-by-step procedures that recur across several places
  sources.md             optional: external material manifest: URLs, retrieval dates, checksums
  sources/               optional: external material: fetch script and cached originals
  archive.md             optional: quarantine index of undatable documents kept
```

In a monorepo, everything below `docs/` except `docs/plan.md` moves under the module it describes;
`DOC-MAP.md`, `README.md`, `AGENTS.md` and its aliases, `CHANGELOG.md` and `docs/plan.md` stay at
the repository root.

Any `docs/name.md` that outgrows one file gains a sibling directory `docs/name/` for its parts, and
stays as their index. The specification is the usual case: its members can be machine-readable -
schemas, interface definitions - and each gets its own row below.

## Artifacts

| Artifact                     | Purpose                                                                                                                  | Tense      | Mutability         | Audience                     |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------- | ------------------ | ---------------------------- |
| `DOC-MAP.md`                 | This map: what each document is for, and where a fact belongs                                                            | present    | rewritten in place | contributor                  |
| `README.md`                  | Orients a newcomer in one screen, and links outward                                                                      | present    | rewritten in place | owner, contributor, consumer |
| `AGENTS.md`                  | Routes a coding agent to this map, and names the hazards specific to working here. Routes rather than restates           | present    | rewritten in place | contributor (agents)         |
| `CLAUDE.md`                  | **Alias** for `AGENTS.md`, existing only because some tools look for that filename                                       | present    | rewritten in place | contributor (agents)         |
| `docs/spec.md`               | The behaviour contract. Uses [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) keywords for requirement strength        | present    | rewritten in place | consumer, contributor        |
| `docs/decisions.md`          | Index of decision records, generated by `tools/doc-kit-index-decisions.sh`. Optional                                     | present    | rewritten in place | owner, contributor           |
| `docs/decisions/*.md`        | Why a choice was made. Follows the [MADR](https://adr.github.io/madr/) minimal template; rules in `0000-template.md`     | past       | amendable          | owner, contributor           |
| `CHANGELOG.md`               | What shipped that users can see. Follows [Keep a Changelog](https://keepachangelog.com) and [SemVer](https://semver.org) | past       | append-only        | consumer                     |
| `docs/plan.md`               | Single ranked backlog, items tagged bug/debt/feature/docs                                                                | future     | volatile           | owner, contributor           |
| `docs/quirks.md`             | Deliberate deviations, and bugs knowingly left unfixed - the one artifact that says _do not change this_                 | present    | rewritten in place | consumer, contributor        |
| `docs/research/*.md`         | Sourced findings with explicit confidence levels; shape and confidence levels in `0000-template.md`                      | past       | append-only        | contributor                  |
| `docs/glossary.md`           | Domain vocabulary                                                                                                        | present    | rewritten in place | owner, contributor, consumer |
| `docs/testing.md`            | Test strategy, and what is deliberately _not_ covered                                                                    | present    | rewritten in place | contributor                  |
| `docs/plan/*.md`             | Working notes for one backlog item. Optional                                                                             | future     | disposable         | contributor                  |
| `docs/plan/0000-template.md` | **Template.** Task-note template. Optional                                                                               | present    | rewritten in place | contributor                  |
| `docs/howto.md`              | Index of step-by-step procedures. Optional                                                                               | present    | rewritten in place | contributor, operator        |
| `docs/howto/*.md`            | Step-by-step procedures that recur across several places. How-to in [Diátaxis](https://diataxis.fr) terms. Optional      | imperative | rewritten in place | contributor, operator        |
| `docs/sources.md`            | External reference manifest: URLs, retrieval dates, licences, checksums. Optional                                        | present    | append-only        | contributor, consumer        |
| `docs/sources/`              | External reference material: fetch script and cached originals. Optional                                                 | present    | append-only        | contributor                  |
| `docs/archive.md`            | Quarantine index of undatable documents kept rather than discarded. Optional                                             | present    | rewritten in place | owner, contributor           |

## Property values

The closed sets used in the artifacts table (ADR-0002):

| Property   | Values                                                                                  |
| ---------- | --------------------------------------------------------------------------------------- |
| Tense      | `present`, `past`, `future`, `imperative`, `explanatory`                                |
| Mutability | `rewritten in place`, `amendable`, `append-only`, `immutable`, `volatile`, `disposable` |
| Audience   | one or more of `owner`, `contributor`, `consumer`, `end-user`, `operator`               |

## Lifecycle

| Artifact                     | Created when                                       | Removed / closed when                                            |
| ---------------------------- | -------------------------------------------------- | ---------------------------------------------------------------- |
| `DOC-MAP.md`                 | the structure is first agreed                      | never - revised when an artifact is added, removed or repurposed |
| `README.md`                  | project starts                                     | never                                                            |
| `AGENTS.md`                  | agents began working in the repository             | never                                                            |
| `CLAUDE.md`                  | a tool looks for that filename specifically        | when no tool needs the alias any more                            |
| `docs/spec.md`               | behaviour is decided                               | never - edited forever                                           |
| `docs/decisions.md`          | first decision is recorded                         | never                                                            |
| `docs/decisions/*.md`        | a choice a newcomer would question                 | deprecated or deleted, with the owner's permission               |
| `CHANGELOG.md` entry         | at release, if user-visible                        | never                                                            |
| `docs/plan.md` entry         | idea occurs - one paragraph, no design             | **deleted** when done, not struck through                        |
| `docs/quirks.md` entry       | a deviation is chosen, or a bug accepted           | when the deviation ends                                          |
| `docs/research/*.md`         | a question is investigated                         | never - confidence gets revised                                  |
| `docs/glossary.md` entry     | a term acquires a project-specific meaning         | when the term leaves the codebase                                |
| `docs/testing.md`            | the second test approach appears                   | never                                                            |
| `docs/plan/*.md`             | work begins on an item                             | work completes                                                   |
| `docs/plan/0000-template.md` | the directory is adopted                           | when the directory is removed                                    |
| `docs/howto.md`              | the first how-to guide appears                     | when no how-to guides remain                                     |
| `docs/howto/*.md`            | a procedure recurs across several places           | when automated away or obsolete                                  |
| `docs/sources.md`            | an external standard is cited                      | when no artifact cites it                                        |
| `docs/sources/`              | the fetch script is adopted, or a source is cached | when no artifact cites it                                        |
| `docs/archive.md`            | migration finds a document nobody can date         | when nothing in it is worth keeping                              |

## Flow

A change moves through the documents in this order:

`docs/plan.md` entry -> (optional `docs/plan/` note) -> **ADR** if a real choice was made ->
regenerate **`docs/decisions.md`** if kept -> **`docs/spec.md`** updated in present tense ->
**`CHANGELOG.md`** line if user-visible -> `docs/plan.md` entry **deleted**.

Most changes skip the ADR and the task note. Nothing skips the deletion.

## Rules

1. **Facts have one home.** A table, a list of more than three values, or a process of three or more
   steps should appear once; short instructional copies and template/instance pairs may repeat.
2. **Tense routes it:** rationale -> ADR, behaviour -> specification, history -> changelog or commit
   message, intent -> plan.
3. **Prose links to a machine-readable contract and never restates it.** It covers only what the
   contract cannot express: rationale, invariants, units, ownership, policy.
4. **A generated view is never hand-edited.** It carries a header naming what generates it, and
   regenerating it produces no diff. An ordered, immutable-once-applied sequence - migrations - is
   changelog-shaped; the specification is the current shape.
5. **Write the least that is true.** No history or account of how you got there, in documents or
   code comments.
6. **Code names the record, not the reverse.** A comment beside constrained code names the ADR or
   quirk that governs it. Only quirk entries name code, in their `Where:` field.
7. **Cite a decision record as `ADR-NNNN`**, and another repository's record by a link. A citation
   says as little about the record as it can, and is fixed in the same commit as a change to the
   record that makes it untrue.

## Deliberately not here

Absent on purpose, so that adding any of them later is a decision rather than a drift:

- **A separate technical-debt file** - debt is a `debt` tag in the plan.
- **An issue tracker**, until the backlog outgrows a file - roughly 20-30 open items.
- **Community health files** - `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md` - until people
  other than the owner contribute regularly.
- **`RELEASING.md`**, until there are releases, and **runbooks**, unless this is a deployed service.

## Adding a new kind of document

Before adding one, check it has a **distinct tense, mutability and audience** from everything in the
artifacts table. If it shares all three with an existing document, it is a section or a tag within
that document, unless it holds different facts. The checker warns about a shared triple; it cannot
tell whether the facts differ.

The one exception is an **alias**: a file whose entire content points at another artifact, existing
only because a tool or reader looks for that exact path - a module `README.md`, a `CLAUDE.md`
pointing at `AGENTS.md`. Mark it `**Alias**` in its purpose cell, give it the properties of what it
points at, and give it nothing of its own to say.

If it passes, add it to the layout, artifacts and lifecycle tables in the same commit. A map that
omits an artifact is worse than no map, because it is believed.

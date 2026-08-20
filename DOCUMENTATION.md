# Documentation

This is the map. It describes what each document in this project is for, who reads it, how long it
lives, and — the question it exists to answer — **where a given fact belongs**.

Start here when you have something to write down and are not sure which file it goes in.

> This repository's product *is* documentation structure, which makes two things easy to confuse.
> `templates/` is the product: source of truth, versioned and reviewed like code, copied into other
> repositories. Everything else is this repository's own documentation, produced by applying the kit
> to itself. `templates/DOCUMENTATION.md` and this file share a name and nothing else — that one is
> the template, this one is an instance of it.

## Where does it go?

The tense of the sentence you are writing usually settles it:

| If you are writing… | It belongs in |
|---|---|
| "a conformant repository does X" | `SPECIFICATION.md` |
| "we chose X because Y" | an ADR |
| "X used to be Y, now it is Z" | the changelog |
| "we should do X" | the plan |
| "here is how you adopt this" | `ADOPTING.md` |
| "here is the text an adopter starts from" | `templates/` — never restated in prose |
| "X means Y in this project" | the glossary |
| "this is how each document is used" | this file |

If a sentence seems to fit two places, it is usually two sentences. Split it and file each half.

## Layout

```text
DOCUMENTATION.md         this file — the map
README.md                orientation, one screen, links outward
SPECIFICATION.md         what a conformant repository looks like
CHANGELOG.md             what shipped
PLAN.md                  single ranked backlog, items tagged bug/debt/feature/docs
ADOPTING.md              the procedure for applying the kit to a repository
templates/               the product: the documents an adopter copies and customises
docs/
  adr/0001-*.md          decisions, numbered, immutable
  glossary.md            project vocabulary
```

The specification is one file. It will stay one file for as long as it is comfortable to read end to
end; its members are prose today, and the checker described in `PLAN.md` will become a
machine-readable member of it when it exists.

## Artifacts

| Artifact | Purpose — and the standard it follows, if any | Tense | Durability | Audience |
|---|---|---|---|---|
| `DOCUMENTATION.md` | This map: what each document is for, and where a fact belongs. **No standard**; nearest practice is a `docs/README.md` index, with [Diátaxis](https://diataxis.fr) supplying the rationale for splitting docs at all | present | rewritten when the structure changes (rare) | anyone adding documentation |
| `README.md` | Orient a newcomer fast. Loose convention; [Standard Readme](https://github.com/RichardLitt/standard-readme) is the nearest written spec | present | rewritten freely | anyone |
| `SPECIFICATION.md` | What a conformant repository looks like — the contract a checker enforces. **No standard for the file.** Uses [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) keywords for requirement strength | present | rewritten in place, always current | adopters + tool authors |
| `ADOPTING.md` | How to apply the kit to a repository. A how-to in [Diátaxis](https://diataxis.fr) terms — a procedure for a different audience at a different moment than the specification | imperative | rewritten in place | adopters |
| `templates/*` | The documents an adopter copies. **Source of truth, not description** — versioned and reviewed like code | present | rewritten in place | adopters, via their own repositories |
| `docs/adr/*.md` | Why we chose this. **Real convention:** Nygard 2011; [adr.github.io](https://adr.github.io), [MADR](https://adr.github.io/madr/) template, [adr-tools](https://github.com/npryce/adr-tools) CLI | past | **immutable** — superseded, never edited | future maintainers |
| `CHANGELOG.md` | What shipped, visible to adopters. **Real standard:** [Keep a Changelog](https://keepachangelog.com) + [SemVer](https://semver.org) | past | append-only | adopters |
| `PLAN.md` | Single ranked backlog, items tagged bug/debt/feature/docs. **No standard** | future | volatile — reordered and deleted freely | the team |
| `docs/glossary.md` | Project vocabulary. Convention: DDD's [ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html) | present | rewritten in place | readers of every other document |

## Lifecycle

| Artifact | Created when | Removed / closed when |
|---|---|---|
| `DOCUMENTATION.md` | the structure is first agreed | never — revised when an artifact is added, removed or repurposed |
| `README.md` | project starts | never |
| `SPECIFICATION.md` | behaviour is decided | never — edited forever |
| `ADOPTING.md` | the kit is first given to someone else | never |
| `templates/*` | an artifact earns a place in the product | when the artifact leaves the product |
| `docs/adr/*.md` | a choice a newcomer would question | never — status flips to `Superseded by ADR-00NN` |
| `CHANGELOG.md` entry | at release, if visible to adopters | never |
| `PLAN.md` entry | idea occurs — one paragraph, no design | **deleted** when done, not struck through |
| `docs/glossary.md` entry | a term acquires a project-specific meaning | when the term leaves the project |

## Flow

A change moves through the documents in this order:

`PLAN.md` entry → **ADR** if a real choice was made → **`SPECIFICATION.md`** updated in present tense
→ `templates/` updated if the product changed → **`CHANGELOG.md`** line if adopters can see it →
`PLAN.md` entry **deleted**.

Most changes skip the ADR. Nothing skips the deletion.

## Prescribed formats

**ADR** — one file per decision, numbered `0001-short-title.md`, five sections:

```markdown
# 1. Short title in the imperative

## Status
Accepted            # Proposed | Accepted | Deprecated | Superseded by ADR-0012

## Context
What forces were at play. What was known at the time — including what was *not* known.

## Decision
What we are doing, in the active voice: "We will …"

## Consequences
What becomes easier, what becomes harder, and what we accept as a result.
```

**Changelog** — reverse-chronological, an `Unreleased` section at the top, six fixed categories:
`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`. Entries describe effects an adopter
can see, not internal refactors.

**Plan entry** — a heading, a type tag and a rough size, then one paragraph. No design:

```markdown
### Short title
*Type: bug — Importance: high — Effort: medium*

One paragraph on what and why. If it needs more than that, it needs an ADR.
```

## Machine-readable and generated parts

Three kinds of thing get confused with each other, and the rules differ:

| Kind | Rule |
|---|---|
| **Source of truth** — the contents of `templates/` | versioned and reviewed like code; it *is* the product, not a description of one |
| **Generated view** — none yet | never hand-edited; carries a generated-by header; CI fails if regenerating produces a diff |
| **Prose that cannot be derived** — rationale, procedure, policy | the only part that belongs in `docs/` as writing |

Without that CI check, "generated" quietly becomes "generated once, then hand-edited", and a
partly-stale generated specification is worse than none: it is believed.

## Three rules that hold it together

1. **Each fact lives in exactly one place**, and the tense of the sentence tells you which:
   rationale → ADR, behaviour → specification, history → changelog, intent → plan.
2. **Never edit an accepted ADR** — supersede it, and set the old status to
   `Superseded by ADR-00NN`. Its whole value is being faithful to what was known at the time.
3. **The specification may link to a machine-readable contract; it must never restate it.** The
   moment prose repeats a field list, there are two sources of truth and one of them is already
   wrong. Link to the artifact, then cover only what the artifact cannot express.

## Failure modes this guards against

- **The plan becomes a graveyard** — entries annotated "DONE" rather than deleted, until nobody
  can see what is actually open.
- **The changelog becomes a commit log** — every internal refactor listed, so users cannot find
  what affects them.
- **ADRs get edited** — destroying their value as a record of what was known at the time.
- **The specification accumulates history** — "previously X, now Y", turning reference material
  into narrative.
- **Findings evaporate** — an investigation's sources and dead ends survive only in a commit
  message or a code comment, and the next person repeats the work.

## Deliberately not here

Absent on purpose, so that adding any of them later is a decision rather than a drift:

- **A separate technical-debt file** — see [ADR-0002](docs/adr/0002-keep-technical-debt-in-the-plan.md).
- **`docs/research/`, `docs/quirks.md`, `docs/testing.md`, `docs/tasks/`** — all in `templates/`,
  none earned here yet. `docs/testing.md` is expected as soon as the checker exists, because there
  will then be something to have a test strategy about.
- **An issue tracker**, until the backlog outgrows a file — roughly 20–30 open items.
- **Community health files** — `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md` — which earn
  their place when outside contributions begin, not before.
- **`RELEASING.md`**, which waits on there being releases.

## Adding a new kind of document

Before adding one, check it has a **distinct tense, mutability and audience** from everything in the
artifacts table. If it shares all three with an existing document, it is a section or a tag within
that document, not a new file. Most proposed additions fail this test — which is the point.

If it passes, add it to both tables here in the same commit. A map that omits an artifact is worse
than no map, because it is believed.

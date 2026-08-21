# Documentation map

This is the map. It describes what each document in this project is for, who reads it, how long it
lives, and — the question it exists to answer — **where a given fact belongs**.

Start here when you have something to write down and are not sure which file it goes in.

> This repository's product *is* documentation structure, which makes two things easy to confuse.
> The test is what a file is **about**: product describes the adopter's repository, documentation
> describes this one. The artifacts table marks which is which. `SPECIFICATION.md` is documentation
> despite concerning adopters, because it describes the product rather than being it
> ([ADR-0006][adr6]).
>
> A third category is not mapped at all: **infrastructure** — `.gitattributes`, the hook config —
> which configures this repository and never reaches an adopter ([ADR-0007][adr7]).
>
> `templates/DOC-MAP.md` and this file share a name and nothing else: that one is the
> template, this one an instance.

## Where does it go?

The tense of the sentence you are writing usually settles it:

| If you are writing… | It belongs in |
|---|---|
| "a conformant repository does X" | `SPECIFICATION.md` |
| "we chose X because Y" | an ADR |
| "source A says X, and I checked" | a research note |
| "X used to be Y, now it is Z" | the changelog |
| "we should do X" | the plan |
| "here is how you adopt this" | `ADOPTING.md` |
| "here is why the procedure is shaped this way" | `ADOPTING-NOTES.md` |
| "here is the text an adopter starts from" | `templates/` — never restated in prose |
| "X means Y in this project" | the glossary |
| "an agent working here needs to know X" | `AGENTS.md`, if it is routing or a hazard — otherwise the document that owns the fact |
| "this is how each document is used" | this file |

If a sentence seems to fit two places, it is usually two sentences. Split it and file each half.

## Layout

```text
DOC-MAP.md         this file — the map
README.md                orientation, one screen, links outward
AGENTS.md                orientation for coding agents — routes here
CLAUDE.md                one line pointing at AGENTS.md
SPECIFICATION.md         what a conformant repository looks like
CHANGELOG.md             what shipped
PLAN.md                  single ranked backlog, items tagged bug/debt/feature/docs
ADOPTING.md              product — the procedure for applying the kit to a repository
ADOPTING-NOTES.md        product — the reasoning behind that procedure
templates/               product — the documents an adopter copies and customises
tools/                   product — the conformance checker, optional and vendored
.claude/skills/*/SKILL.md  product — drives an adoption from here into another repository
docs/
  adr/*.md               decisions, numbered, immutable once accepted
  research/*.md          sourced findings, with confidence levels
  glossary.md            project vocabulary
  testing.md             what the checker verifies, and what it does not
```

The specification is one file. It will stay one file for as long as it is comfortable to read end to
end; its members are prose today, and the checker described in `PLAN.md` will become a
machine-readable member of it when it exists.

## Artifacts

| Artifact | Purpose — and the standard it follows, if any | Tense | Durability | Audience |
|---|---|---|---|---|
| `DOC-MAP.md` | This map: what each document is for, and where a fact belongs. **No standard**; nearest practice is a `docs/README.md` index, with [Diátaxis](https://diataxis.fr) supplying the rationale for splitting docs at all | present | rewritten when the structure changes (rare) | anyone adding documentation |
| `README.md` | Orient a newcomer fast. Loose convention; [Standard Readme](https://github.com/RichardLitt/standard-readme) is the nearest written spec | present | rewritten freely | anyone |
| `AGENTS.md` | Routes a coding agent to this map, and names the hazards specific to working here. Routes rather than restates. Convention: [agents.md](https://agents.md) | present | rewritten in place | coding agents |
| `CLAUDE.md` | One line pointing at `AGENTS.md`. Holds no content of its own, because two copies would be two sources of truth | present | rewritten in place (rarely) | coding agents |
| `SPECIFICATION.md` | What a conformant repository looks like — the contract a checker enforces. **No standard for the file.** Uses [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) keywords for requirement strength | present | rewritten in place, always current | adopters + tool authors |
| `ADOPTING.md` | **Product. Source of truth, not description** — the procedure half of what the kit ships. A how-to in [Diátaxis](https://diataxis.fr) terms | imperative | rewritten in place | adopters |
| `ADOPTING-NOTES.md` | **Product.** The reasoning behind the procedure — judgement calls, how far to trust each convention cited, what the sticking points mean. Split out so that `ADOPTING.md` stays a credible front door — neither file is copied to an adopter, so the gain is approachability, not weight. Explanation in [Diátaxis](https://diataxis.fr) terms | explanatory | rewritten in place | adopters who are stuck or deciding |
| `templates/*` | **Product. Source of truth, not description** — the artifact half. Copied into the adopter's repository and customised there | present | rewritten in place | adopters, via their own repositories |
| `.claude/skills/*/SKILL.md` | **Product**, and the only artifact that runs *here* while writing *there*: it drives an adoption into another repository. Routes to `ADOPTING.md` rather than restating it, and holds the approval gate prose cannot enforce. Never copied to an adopter — adoption is one-time per repository | imperative | rewritten in place | whoever performs an adoption |
| `tools/*` | **Product.** The conformance checker — what `SPECIFICATION.md` says, made executable. Vendored into adopting repositories and optional there. **Source of truth, not description** | present | rewritten in place | adopters who want the check, and anyone editing the specification |
| `docs/adr/*.md` | Why we chose this. **Real convention:** [MADR](https://adr.github.io/madr/) minimal template, after Nygard 2011; see also [adr.github.io](https://adr.github.io) and [adr-tools](https://github.com/npryce/adr-tools) | past | **immutable** once accepted — superseded, never edited | future maintainers |
| `CHANGELOG.md` | What shipped, visible to adopters. **Real standard:** [Keep a Changelog](https://keepachangelog.com) + [SemVer](https://semver.org) | past | append-only | adopters |
| `PLAN.md` | Single ranked backlog, items tagged bug/debt/feature/docs. **No standard** | future | volatile — reordered and deleted freely | the team |
| `docs/research/*.md` | Sourced findings about the conventions this kit cites, with explicit confidence levels. **No standard.** Orthodox home is a record's *Context*; split out here because these findings are cited by several records and decay independently of them | past | append-mostly; confidence revised in place | anyone relying on a cited convention |
| `docs/testing.md` | What `tools/doc-kit-check.sh` and the hooks verify exactly, approximately, and deliberately not at all. ISO/IEC/IEEE 29119-3 exists but is enterprise-heavy for a repository this size | present | rewritten in place | contributors, and anyone reading a green check |
| `docs/glossary.md` | Project vocabulary. Convention: DDD's [ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html) | present | rewritten in place | readers of every other document |

## Lifecycle

| Artifact | Created when | Removed / closed when |
|---|---|---|
| `DOC-MAP.md` | the structure is first agreed | never — revised when an artifact is added, removed or repurposed |
| `README.md` | project starts | never |
| `AGENTS.md` | agents began working in the repository | never |
| `CLAUDE.md` | a tool looks for that filename specifically | when no tool needs the alias any more |
| `SPECIFICATION.md` | behaviour is decided | never — edited forever |
| `ADOPTING.md` | the kit is first given to someone else | never |
| `ADOPTING-NOTES.md` | the procedure accumulated reasoning that was slowing it down | never |
| `templates/*` | an artifact earns a place in the product | when the artifact leaves the product |
| `tools/*` | a specification rule becomes worth checking mechanically | when the rule it checks is removed |
| `.claude/skills/*/SKILL.md` | adoptions began being driven by an agent | when the procedure it drives no longer exists |
| `docs/adr/*.md` | a choice a newcomer would question | never — status flips to `superseded by ADR-NNNN` |
| `CHANGELOG.md` entry | at release, if visible to adopters | never |
| `PLAN.md` entry | idea occurs — one paragraph, no design | **deleted** when done, not struck through |
| `docs/research/*.md` | a cited convention is checked against its source | never — confidence gets revised |
| `docs/testing.md` | something started verifying the documentation mechanically | never |
| `docs/glossary.md` entry | a term acquires a project-specific meaning | when the term leaves the project |

## Flow

A change moves through the documents in this order:

`PLAN.md` entry → **ADR** if a real choice was made → **`SPECIFICATION.md`** updated in present
tense → `templates/` updated if the product changed → **`CHANGELOG.md`** line if adopters can see
it → `PLAN.md` entry **deleted**.

Most changes skip the ADR. Nothing skips the deletion.

## Prescribed formats

**ADR** — one file per decision, numbered `0001-short-title.md`, following the
[MADR](https://adr.github.io/madr/) minimal template. The shape lives in
[`templates/docs/adr/0000-template.md`](templates/docs/adr/0000-template.md) and is not restated
here; `SPECIFICATION.md` §3.1 carries the rules that file cannot express — status meanings,
immutability, and who may change a status.

**Changelog** — reverse-chronological, an `Unreleased` section at the top, six fixed categories:
`Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`. Entries describe effects an
adopter can see, not internal refactors.

**Plan entry** — a heading, a type tag and a rough size, then one paragraph. No design:

```markdown
### Short title
*Type: bug — Importance: high — Effort: medium*

One paragraph on what and why. If it needs more than that, it needs an ADR.
```

## Machine-readable and generated parts

Nothing here is generated. `ADOPTING.md` and `templates/` are source of truth — versioned and
reviewed like code, not a description of something else. Everything in `docs/` is prose that cannot
be derived. `SPECIFICATION.md` §4 has the rules for when that changes.

## Three rules that hold it together

1. **Each fact lives in exactly one place**, and the tense of the sentence tells you which:
   rationale → ADR, behaviour → specification, history → changelog, intent → plan.
2. **Never edit an accepted ADR** — supersede it, and set the old status to
   `superseded by ADR-NNNN`. Its whole value is being faithful to what was known at the time.
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

- **A separate technical-debt file** — see [ADR-0002][adr2].
- **`docs/quirks.md` and `docs/tasks/`** — both in `templates/`, neither earned here yet.
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

[adr2]: docs/adr/0002-keep-technical-debt-in-the-plan.md
[adr6]: docs/adr/0006-treat-the-adoption-procedure-as-product.md
[adr7]: docs/adr/0007-keep-repository-infrastructure-out-of-the-product.md

# Documentation map

This is the map. It describes what each document in this project is for, who reads it, how long it
lives, and - the question it exists to answer - **where a given fact belongs**.

Start here when you have something to write down and are not sure which file it goes in.

> This repository's product _is_ documentation structure, which makes two things easy to confuse.
> The test is what a file is **about**: product describes the adopter's repository, documentation
> describes this one. The artifacts table marks which is which. `SPECIFICATION.md` is documentation
> despite concerning adopters, because it describes the product rather than being it
> ([ADR-0006][adr6]).
>
> A third category is not mapped at all: **infrastructure** - `.gitattributes`, the hook config -
> which configures this repository and never reaches an adopter ([ADR-0007][adr7]).
>
> `templates/DOC-MAP.md` and this file share a name and nothing else: that one is the template, this
> one an instance.

## Where does it go?

The tense of the sentence you are writing usually settles it:

| If you are asking...                    | If you are writing...                              | It belongs in                                                                             |
| --------------------------------------- | -------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| "what makes a repository conformant?"   | "a conformant repository does X"                   | `SPECIFICATION.md`                                                                        |
| "why is the kit shaped like this?"      | "we chose X because Y"                             | an ADR                                                                                    |
| "has anyone checked that?"              | "source A says X, and I checked"                   | a research note                                                                           |
| "what changed in this release?"         | "X used to be Y, now it is Z"                      | the changelog                                                                             |
| "is this known? is it planned?"         | "we should do X"                                   | the plan                                                                                  |
| "how do I adopt this?"                  | "here is how you adopt this"                       | `ADOPTING.md`                                                                             |
| "why does the procedure say that?"      | "here is why the procedure is shaped this way"     | `ADOPTING-NOTES.md`                                                                       |
| "what does an adopter start from?"      | "here is the text an adopter starts from"          | `templates/` - never restated in prose                                                    |
| "why is this code like this?"           | "this code is like this because..."                | a comment beside it - or an ADR the comment names, if the reason spans more than one site |
| "what did this code do before?"         | "this code used to..." or "fixed the bug where..." | the commit message - never a comment                                                      |
| "is anything left to do here?"          | "this code should also..."                         | the plan - a `TODO` beside the code names the entry, never replaces it                    |
| "what does this word mean here?"        | "X means Y in this project"                        | the glossary                                                                              |
| "what must an agent know to work here?" | "an agent working here needs to know X"            | `AGENTS.md`, if it is routing or a hazard - otherwise the document that owns the fact     |
| "where does this go?"                   | "this is how each document is used"                | this file                                                                                 |

If a sentence seems to fit two places, it is usually two sentences. Split it and file each half.

## Layout

```text
DOC-MAP.md               this file - the map
README.md                orientation, one screen, links outward
AGENTS.md                orientation for coding agents - routes here
CLAUDE.md                one line pointing at AGENTS.md
SPECIFICATION.md         what a conformant repository looks like
CHANGELOG.md             what shipped
PLAN.md                  single ranked backlog, items tagged bug/debt/feature/docs
ADOPTING.md              product - the procedure for applying the kit to a repository
ADOPTING-NOTES.md        product - the reasoning behind that procedure
templates/               product - the documents an adopter copies and customises
tools/                   product - the conformance checker, optional and vendored
.agents/skills/*/SKILL.md  product - drives an adoption from here into another repository
docs/
  adr/*.md               decisions, numbered, immutable once accepted
  research/*.md          sourced findings, with confidence levels
  glossary.md            project vocabulary
  testing.md             what the checker verifies, and what it does not
```

The specification is one file. It will stay one file for as long as it is comfortable to read end to
end. The checker, `tools/doc-kit-check.sh`, enforces it but is not part of it.

## Artifacts

| Artifact                    | Purpose - and the standard it follows, if any                                                                                                                                                                         | Tense       | Mutability         | Audience                                                          |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ------------------ | ----------------------------------------------------------------- |
| `DOC-MAP.md`                | This map: what each document is for, and where a fact belongs. **No standard**; nearest practice is a `docs/README.md` index, with [Diátaxis](https://diataxis.fr) supplying the rationale for splitting docs at all  | present     | rewritten in place | anyone adding documentation                                       |
| `README.md`                 | Orient a newcomer fast. Loose convention; [Standard Readme](https://github.com/RichardLitt/standard-readme) is the nearest written spec                                                                               | present     | rewritten in place | anyone                                                            |
| `AGENTS.md`                 | Routes a coding agent to this map, and names the hazards specific to working here. Routes rather than restates. Convention: [agents.md](https://agents.md)                                                            | present     | rewritten in place | coding agents                                                     |
| `CLAUDE.md`                 | **Alias** (§2.7) for `AGENTS.md`, existing only because some tools look for that filename                                                                                                                             | present     | rewritten in place | coding agents                                                     |
| `SPECIFICATION.md`          | What a conformant repository looks like - the contract a checker enforces. **No standard for the file.** Uses [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) keywords for requirement strength                    | present     | rewritten in place | adopters + tool authors                                           |
| `ADOPTING.md`               | **Product. Source of truth, not description** - the procedure half of what the kit ships. A how-to in [Diátaxis](https://diataxis.fr) terms                                                                           | imperative  | rewritten in place | adopters                                                          |
| `ADOPTING-NOTES.md`         | **Product.** The reasoning behind the procedure - judgement calls, how far to trust each convention cited, what the rules prevent                                                                                     | explanatory | rewritten in place | adopters who are stuck or deciding                                |
| `templates/*`               | **Product. Source of truth, not description** - the artifact half. Copied into the adopter's repository and customised there                                                                                          | present     | rewritten in place | adopters, via their own repositories                              |
| `.agents/skills/*/SKILL.md` | **Product**. Drives an adoption from here into another repository, routing to `ADOPTING.md` and holding the approval gate. Never copied to an adopter                                                                 | imperative  | rewritten in place | whoever performs an adoption                                      |
| `tools/*`                   | **Product.** The conformance checker - what `SPECIFICATION.md` says, made executable. Vendored into adopting repositories and optional there. **Source of truth, not description**                                    | present     | rewritten in place | adopters who want the check, and anyone editing the specification |
| `docs/adr/*.md`             | Why we chose this. **Real convention:** [MADR](https://adr.github.io/madr/) minimal template, after Nygard 2011; see also [adr.github.io](https://adr.github.io) and [adr-tools](https://github.com/npryce/adr-tools) | past        | immutable          | future maintainers                                                |
| `CHANGELOG.md`              | What shipped, visible to adopters. **Real standard:** [Keep a Changelog](https://keepachangelog.com) + [SemVer](https://semver.org)                                                                                   | past        | append-only        | adopters                                                          |
| `PLAN.md`                   | Single ranked backlog, items tagged bug/debt/feature/docs. **No standard**                                                                                                                                            | future      | volatile           | the owner and contributors                                        |
| `docs/research/*.md`        | Sourced findings about the conventions this kit cites, with explicit confidence levels. **No standard**                                                                                                               | past        | append-only        | anyone relying on a cited convention                              |
| `docs/testing.md`           | What `tools/doc-kit-check.sh` and the hooks verify exactly, approximately, and deliberately not at all                                                                                                                | present     | rewritten in place | contributors, and anyone reading a green check                    |
| `docs/glossary.md`          | Project vocabulary. Convention: DDD's [ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html)                                                                                                   | present     | rewritten in place | readers of every other document                                   |

## Lifecycle

| Artifact                    | Created when                                                 | Removed / closed when                                            |
| --------------------------- | ------------------------------------------------------------ | ---------------------------------------------------------------- |
| `DOC-MAP.md`                | the structure is first agreed                                | never - revised when an artifact is added, removed or repurposed |
| `README.md`                 | project starts                                               | never                                                            |
| `AGENTS.md`                 | agents began working in the repository                       | never                                                            |
| `CLAUDE.md`                 | a tool looks for that filename specifically                  | when no tool needs the alias any more                            |
| `SPECIFICATION.md`          | behaviour is decided                                         | never - edited forever                                           |
| `ADOPTING.md`               | the kit is first given to someone else                       | never                                                            |
| `ADOPTING-NOTES.md`         | the procedure accumulated reasoning that was slowing it down | never                                                            |
| `templates/*`               | an artifact earns a place in the product                     | when the artifact leaves the product                             |
| `tools/*`                   | a specification rule becomes worth checking mechanically     | when the rule it checks is removed                               |
| `.agents/skills/*/SKILL.md` | adoptions began being driven by an agent                     | when the procedure it drives no longer exists                    |
| `docs/adr/*.md`             | a choice a newcomer would question                           | never - status flips to `superseded by ADR-NNNN`                 |
| `CHANGELOG.md` entry        | at release, if visible to adopters                           | never                                                            |
| `PLAN.md` entry             | idea occurs - one paragraph, no design                       | **deleted** when done, not struck through                        |
| `docs/research/*.md`        | a cited convention is checked against its source             | never - confidence gets revised                                  |
| `docs/testing.md`           | something started verifying the documentation mechanically   | never                                                            |
| `docs/glossary.md` entry    | a term acquires a project-specific meaning                   | when the term leaves the project                                 |

## Flow

A change moves through the documents in this order:

`PLAN.md` entry -> **ADR** if a real choice was made -> **`SPECIFICATION.md`** updated in present
tense -> `templates/` updated if the product changed -> **`CHANGELOG.md`** line if adopters can see
it -> `PLAN.md` entry **deleted**.

Most changes skip the ADR. Nothing skips the deletion.

## Rules

Each artifact holds its own format and rules - the ADR shape and status rules in
[`templates/docs/adr/0000-template.md`](templates/docs/adr/0000-template.md) and `SPECIFICATION.md`
§3.1, the plan entry in `PLAN.md`'s preamble - and this map does not restate them
([ADR-0020][adr20]). What each rule prevents is in `ADOPTING-NOTES.md`.

1. **Each fact lives in exactly one place**, and the tense of the sentence tells you which:
   rationale -> ADR, behaviour -> specification, history -> changelog or commit message, intent ->
   plan.
2. **The specification may link to a machine-readable contract; it must never restate it.** Nothing
   here is generated: `ADOPTING.md` and `templates/` are source of truth, and everything in `docs/`
   is prose that cannot be derived. `SPECIFICATION.md` §4 has the rules for when that changes.
3. **Write the least that is true.** No history or account of how you got there, in documents or
   code comments ([ADR-0019][adr19]).
4. **Code names the record, not the reverse.** A comment beside constrained code names the ADR that
   governs it.

## Deliberately not here

Absent on purpose, so that adding any of them later is a decision rather than a drift:

- **A separate technical-debt file** - see [ADR-0002][adr2].
- **`docs/quirks.md` and `docs/tasks/`** - both in `templates/`, neither earned here yet.
- **An issue tracker**, until the backlog outgrows a file - roughly 20-30 open items.
- **Community health files** - `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md` - which earn
  their place when outside contributions begin, not before.
- **`RELEASING.md`**, which waits on there being releases.

## Adding a new kind of document

Before adding one, check it has a **distinct tense, mutability and audience** from everything in the
artifacts table. If it shares all three with an existing document, it is a section or a tag within
that document, not a new file. Most proposed additions fail this test - which is the point.

If it passes, add it to the layout, artifacts and lifecycle tables in the same commit. A map that
omits an artifact is worse than no map, because it is believed.

[adr2]: docs/adr/0002-keep-technical-debt-in-the-plan.md
[adr6]: docs/adr/0006-treat-the-adoption-procedure-as-product.md
[adr7]: docs/adr/0007-keep-repository-infrastructure-out-of-the-product.md
[adr19]: docs/adr/0019-govern-the-tense-and-volume-of-what-is-written-not-its-style.md
[adr20]: docs/adr/0020-the-map-routes-each-artifact-owns-its-rules.md

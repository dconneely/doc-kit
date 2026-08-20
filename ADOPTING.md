# Adopting the documentation kit

`templates/DOCUMENTATION.md` is a template. This file is the procedure for turning it into a
particular repository's documentation map, and for creating the set of documents that map then
describes.

The contents of `templates/` are copied into the target repository. This file stays with the kit.

**Done means:** every artifact named in that repository's map exists, every documentation file in
that repository appears in its map, and each fact in them sits in exactly one place.

## The idea, and why it shapes the procedure

Three properties define every artifact: **tense** (does it describe what is, what was, or what is
intended?), **mutability** (rewritten in place, append-only, immutable, or disposable?) and
**audience**. Documentation rots when one file mixes them — the classic case being a document that
is part record of work done, part backlog, part assessment, so that no part of it can be trusted or
pruned with confidence.

Everything else follows from that, including the rules stated in the map itself — which you keep
verbatim rather than customise, so they are not repeated here.

Four consequences shape this procedure in particular:

1. **You customise mostly by deleting.** The template is roughly the union of what projects need;
   any given repository needs a subset. Almost nothing has to be invented — which is why Step 2 is
   a table of deletions and substitutions rather than a writing exercise.
2. **What you keep is decided by capabilities, not taste.** A data store earns a data dictionary; a
   network API earns an interface definition; a deployed service earns a runbook. That is why
   Step 1 is an inventory rather than a preference.
3. **The rules are not the customisable part.** Paths, artifact lists and formats are local; the
   three rules, the failure modes and the test for adding a new document are the same everywhere
   and should survive customisation verbatim. They are what stops the structure decaying back into
   the mixed-tense file it replaced.
4. **Resist growth.** Most proposed additions share all three properties with something that
   already exists, which makes them a section or a tag rather than a file. The structure works
   because it is small enough to hold in your head.

One caveat to carry into Step 2: **this is not one standard**, but several conventions of differing
authority. Adapt names, paths and scope freely — but before altering the changelog format or the
ADR template, read "How far do I trust each convention?" below.

---

## Step 0 — Decide whether to adopt, and write the plan

Two outputs: a decision, and `PLAN.md`.

**Decide.** This structure costs more than it returns below a certain size. A single-purpose script,
a repository one person will maintain for a month, or anything whose entire documentation genuinely
fits in one honest `README.md` — or one tight `AGENTS.md` — should stop here. The signal to proceed
is not size in lines but **more than one reader**: someone who has to obey the behaviour, or
someone who will inherit the reasoning. Record the outcome either way — a rejection that is written
down is a decision, and one that is not gets re-litigated every six months.

**Then write `PLAN.md` before anything else.** It is the one artifact you can create knowing nothing
about the repository yet, and the adoption work itself is its first content: one entry per artifact
to create, one per document to migrate, ranked. Steps 1–4 then consume and delete those entries in
the ordinary way.

This is not ceremony. It is what makes adoption survive being interrupted, which — on any repository
old enough to need it — it will be. It also means the structure is doing real work from the first
hour rather than after the migration completes, and it puts the first honest entry in the first
file, which is worth more than a tidy empty one.

Adopting into an existing codebase, expect Step 1 to add entries to this plan rather than replace
it. Nothing here has to be right first time; the plan is the volatile artifact by design.

## Step 1 — Inventory what this repository actually has

Every project takes the core five: `DOCUMENTATION.md`, `README.md`, the specification,
`CHANGELOG.md` and `PLAN.md`. ADRs are strongly recommended from day one, because their value is
almost entirely in being written contemporaneously.

Then work through the table below and note which apply. Be strict: an artifact you will not maintain
is worse than its absence, because the map promises it.

Most of these join the **specification** rather than becoming new categories, because they are
present tense, always current, and a contract someone relies on.

| If the project has… | It gains | Where it lands |
|---|---|---|
| a data store | the schema (generated snapshot), plus a **data dictionary**: units, ownership, retention, which fields are sensitive, invariants constraints cannot express | specification |
| | ordered migrations | changelog-shaped: an ordered, immutable-once-applied sequence is a changelog whatever it describes |
| a network API | the interface definition ([OpenAPI](https://spec.openapis.org/oas/latest.html), [AsyncAPI](https://www.asyncapi.com), or similar) as source of truth | specification |
| | cross-cutting conventions: pagination, versioning, idempotency, error shape ([RFC 9457](https://www.rfc-editor.org/rfc/rfc9457); crib [Google AIP](https://google.aip.dev) or [Zalando](https://opensource.zalando.com/restful-api-guidelines/)) | specification |
| deployment as a service | a **runbook** — deploy, roll back, common failures | neither: a how-to, different audience (on call) |
| | environment and configuration reference ([12-Factor](https://12factor.net) conventions) | specification |
| | a **threat model** ([OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/) as the checklist) | neither: an assessment — its conclusions become records, its findings become plan entries |
| a user interface | a conformance target and known gaps ([WCAG](https://www.w3.org/TR/WCAG22/)) | target → specification; gaps → quirks |

The pattern is worth internalising: **most new artifacts are specification members, not new
categories.** Before inventing a category, check whether the thing is simply the contract in a
different medium.

Two questions decide most of the rest:

- **Is the specification one file or a tree?** One file until it stops being comfortable to read
  end to end. A tree means `SPECIFICATION.md` becomes an index that links to its members.
- **Does the specification include machine-readable members** — schemas, interface definitions?
  If so, they are specification, not a separate category, and the link-never-restate rule applies.

## Step 2 — Edit the template

Work top to bottom. Every edit is a deletion or a substitution; nothing needs to be invented.

| In `DOCUMENTATION.md` | Do this |
|---|---|
| "Where does it go?" table | Delete rows for artifacts this repo does not have |
| Layout block | Delete unused lines; replace with **real paths** — in a monorepo, `docs/` moves under the module it describes and only the root four stay at the top |
| Specification line | State whether it is one file or an index, and name its machine-readable members if any |
| Artifacts table | Delete unused rows. Keep the standard links — they tell a future maintainer how much to trust each convention |
| Lifecycle table | Delete the same rows, so the two tables stay aligned |
| Flow | Keep, deleting any step that names an artifact you removed — most projects drop the optional task-note step |
| Prescribed formats | Keep the formats for artifacts you kept; delete the rest |
| "Machine-readable and generated parts" | Keep if anything here is generated or machine-readable; delete outright if the documentation is entirely hand-written prose |
| Three rules, failure modes, "adding a new kind of document" | **Keep verbatim.** These are the parts that do the work, and they are the same in every repository |
| "Deliberately not here" | Keep, and add anything else you consciously rejected for this repo |

If the repository has house conventions the template does not mention — a naming scheme, a
gitignored prefix for working documents, a docs directory that is generated — add a row for each
rather than leaving them undocumented.

## Step 3 — Create the documents the map now promises

A map that names a file which does not exist is worse than no map, because it is believed. For each
artifact you kept:

- **Create it, even if nearly empty.** A `CHANGELOG.md` containing only `## Unreleased` is correct
  and honest; a missing one is a broken promise.
- **Do not backfill history.** A changelog that starts today is fine. ADRs written years after the
  fact are usually reconstruction, and they dilute the ones written contemporaneously.
- **Seed each with its first real entry** if one is to hand — see Step 4, which will find several.
- **Replace the placeholder content or delete it.** The templates carry an example entry rather than
  instructions; a `README.md` with unfilled headings is worse than a short one.

The templates deliberately contain no advice about the kit — that is this file's job, and it is not
copied into your repository. The one exception is `docs/adr/0000-template.md` and its counterpart in
`docs/research/`, which stay as templates to copy from and keep a short comment for that reason.

For an empty repository this step is quick and you are finished. For an existing codebase, the
material for those first entries is already scattered through it — that is Step 4.

**One optional line, if you keep a `.gitattributes`:**

```gitattributes
*.md text eol=lf diff=markdown
```

Git's Markdown diff driver puts the enclosing heading in the hunk header, which is worth having once
a meaningful share of review is prose. The kit does not ship a `.gitattributes` — your repository
probably already has one, and a documentation kit has no business holding opinions about your batch
files. Nor does it require you to run anything: verifying this structure by hand is fully
conformant. See ADR-0007.

### If coding agents work in this repository

Agents read `AGENTS.md` or `CLAUDE.md`, and nothing there points at the map — so the structure you
have just built is unreachable to the reader most able to damage it. Paste this into whichever of
those files you keep, deleting lines for artifacts you did not create:

```markdown
## Documentation

`DOCUMENTATION.md` is the map: it says which file a given fact belongs in. Read it before writing
anything down.

When documents disagree, tense settles it:

- `SPECIFICATION.md` — present tense, authoritative about what the system does now.
- `CHANGELOG.md` — past tense. What changed, never what is true today.
- `PLAN.md` — intent. Nothing described in it exists yet.
- `docs/adr/` — why. Only `accepted` records bind; check the status before relying on one.
- `docs/quirks.md` — deliberate deviations. **Do not "fix" anything listed here.**
- `docs/archive/` — not authoritative, undated. Never cite it as a source.

Before you edit:

- The specification follows the work. Change it because behaviour changed, not because it would
  read better. Its purpose and scope are not yours to revise.
- Never change an ADR's `status`, and never edit one that says `accepted`. Drafting a record is
  yours; deciding one is not.
- Delete completed `PLAN.md` entries rather than marking them done.
- Adding a document means updating `DOCUMENTATION.md` in the same commit.
```

It is deliberately short. It competes with your code for the agent's context, and its value is
being at the path an agent already reads — not in restating the map, which is one click away.

The kit ships this as text rather than a file for the reason in ADR-0007: your repository probably
already has an `AGENTS.md`, and a file that collides has to be merged rather than copied.

## Step 4 — Migrate what already exists

Only relevant when adopting into an existing codebase — and on any repository old enough to need
this, it is the part that does not fit in an afternoon. Work it in three phases: enumerate, decide,
then act. Deciding everything before moving anything is what keeps the repository consistent at
every point rather than only at the end.

### 4a — Build the inventory

List every documentation file before touching any of them, in a worksheet:
`docs/tasks/adopt-doc-kit.md`. This is the one case where `docs/tasks/` earns its place below the
usual threshold, because migration is exactly the work that spans weeks and gets interrupted.

| File | Tense | Destination | Disposition | Done |
|---|---|---|---|---|
| `docs/design-notes.md` | mixed | spec + changelog | split | |
| `docs/old-api.md` | present | — | archive | ✓ |

**Tense** is the dominant one — present, past, future, or **mixed**. Mixed is not a failure to
classify; it is the finding, and it always means *split*.

Cast wider than the repository. Wikis, Confluence spaces, shared drives and issue-tracker
descriptions hold documentation too, and they are where the undatable material concentrates. List
them with their location in place of a path.

The worksheet mixes tenses itself — a survey of what is, plus what you intend to do about it — which
is precisely why it is a task note and disposable. It is a worksheet, not a record, and it gets
emptied into its proper homes before it is deleted.

### 4b — Assign a disposition

Six, and every file gets exactly one:

| Disposition | When | What it means |
|---|---|---|
| **move** | one tense, wrong place | relocate as-is. Use `git mv` so history and blame survive |
| **split** | mixed tense | divide by tense and file each part. The most common outcome, and the highest-value one |
| **absorb** | belongs inside something that already exists | merge the content in, delete the original |
| **archive** | currency cannot be established | to `docs/archive/` with a provenance header, never into the specification |
| **delete** | superseded, duplicated, or wrong with nothing worth keeping | git still has it |
| **leave** | already correct where it is | still has to appear in the map |

Two rules stop this going wrong. **Archive is not a synonym for "not sure yet"** — it is a positive
finding that a claim cannot be dated, and promoting an undatable claim into the specification is
worse than leaving it untrusted. And **anything moving out of a directory people navigate leaves a
one-line pointer behind**, because links from issues, wikis and bookmarks do not follow renames.

Get the dispositions reviewed before acting on them. It is the cheapest point at which someone who
remembers why a document exists can say so.

### 4c — Work the sweeps

In order of payoff; expect the first three to find real content and the fourth to find less than you
would think.

**1. Find the file doing several jobs at once.** Almost every repository has one — part record of
work done, part backlog, part architecture assessment. Splitting it by tense is usually the single
largest improvement available, and it is mechanical rather than a judgement call: past-tense entries
to the changelog, future-tense to the plan, present-tense to the specification.

Watch for the tell that this has already cost something: an important item filed in the "other"
file, where nobody looks when deciding what to do next.

**2. Look for decisions living in code comments.** A comment explaining why something is *not*
written the obvious way — especially one added after a painful debugging session — is an ADR that
was never filed. These are the highest-value ADRs precisely because the reasoning is invisible from
the code, so the next maintainer will "simplify" the constraint away and reintroduce the bug it
prevents. Convert it and leave a one-line pointer behind.

**3. Look for findings with sources.** Anything citing external references, reconciling sources
that disagree, or carrying a confidence level is research and needs a home before the details fade.
This is the artifact most often missing entirely.

**4. Only then consider artifacts the template does not have.** By this point most candidates will
have turned out to be sections of documents that already exist. Apply the test in the map's "adding
a new kind of document" section before adding anything.

## Step 5 — Verify

The customisation has been applied successfully when all of these hold:

- [ ] Every artifact named in the map exists in the repository.
- [ ] Every documentation file in the repository appears in the map.
- [ ] The artifacts table and the lifecycle table list the same artifacts.
- [ ] Paths in the map are the repository's real paths.
- [ ] No file serves two tenses — nothing is part changelog and part backlog.
- [ ] No fact appears in two places; in particular, no prose restates a machine-readable contract.
- [ ] Generated files say so, and regenerating them produces no diff.
- [ ] No placeholder content survives — no example artifact row, no unreplaced heading.

Re-run the first two checks whenever an artifact is added or removed. They are the ones that rot.


---

## When the procedure will not settle it

[`ADOPTING-NOTES.md`](ADOPTING-NOTES.md) carries the reasoning: the judgement calls Steps 1 and 4
tend to force, how far to trust each convention this kit cites, which optional artifacts are worth
their keep, and what the common sticking points usually mean. None of it is needed to work through
the steps above.

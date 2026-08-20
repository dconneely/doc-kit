# Customising the documentation template

`DOCUMENTATION.md` is a template. This file is the procedure for turning it into a particular
repository's documentation map, and for creating the set of documents that map then describes.

Only `DOCUMENTATION.md` is copied into the target repository. This file stays with the template.

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

## Step 1 — Inventory what this repository actually has

Every project takes the core five: `DOCUMENTATION.md`, `README.md`, the specification,
`CHANGELOG.md` and `PLAN.md`. ADRs are strongly recommended from day one, because their value is
almost entirely in being written contemporaneously.

Then work through the template's "what each capability adds" table and note which apply. Be strict:
an artifact you will not maintain is worse than its absence, because the map promises it.

Two questions decide most of the rest:

- **Is the specification one file or a tree?** One file until it stops being comfortable to read
  end to end. A tree means `SPECIFICATION.md` becomes an index that links to its members.
- **Does the specification include machine-readable members** — schemas, interface definitions?
  If so, they are specification, not a separate category, and the link-never-restate rule applies.

## Step 2 — Edit the template

Work top to bottom. Every edit is a deletion or a substitution; nothing needs to be invented.

| In `DOCUMENTATION.md` | Do this |
|---|---|
| The "this file is a template" banner | Delete it |
| "Where does it go?" table | Delete rows for artifacts this repo does not have |
| Layout block | Delete unused lines; replace with **real paths** — in a monorepo, `docs/` moves under the module it describes and only the root four stay at the top |
| Specification line | State whether it is one file or an index, and name its machine-readable members if any |
| Artifacts table | Delete unused rows. Keep the standard links — they tell a future maintainer how much to trust each convention |
| Lifecycle table | Delete the same rows, so the two tables stay aligned |
| Flow | Keep, deleting any step that names an artifact you removed — most projects drop the optional task-note step |
| Prescribed formats | Keep the formats for artifacts you kept; delete the rest |
| "Machine-readable and generated parts" | Keep if anything here is generated or machine-readable; delete outright if the documentation is entirely hand-written prose |
| "What each capability adds" | Delete it once applied — it is scaffolding for this step, not part of the finished map |
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

For an empty repository this step is quick and you are finished. For an existing codebase, the
material for those first entries is already scattered through it — that is Step 4.

## Step 4 — Migrate what already exists

Only relevant when adopting into an existing codebase. In order of payoff; expect the first three
to find real content and the fourth to find less than you would think.

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
- [ ] The template banner is gone.

Re-run the first two checks whenever an artifact is added or removed. They are the ones that rot.

---

---

*Everything below is optional. It is the reasoning behind the structure — the parts of the
philosophy that settle a judgement call rather than frame the method — and none of it is needed to
apply Steps 1–5. Come back to it when a decision will not settle itself, or when something is not
working.*

## Judgement calls

The decisions Steps 1 and 4 tend to force, and the reasoning that resolves them.

### Do we need a technical-debt file?

No, and the reasoning generalises to most proposed additions.

1. **It splits on the wrong axis.** Technical debt has the same tense (future), the same mutability
   (volatile) and the same audience (the team) as the plan. The structure is organised by those
   three properties; splitting by *category* instead is what makes such files drift apart in format
   and go stale.
2. **It hides the trade-off that matters most.** Debt versus feature is exactly the decision worth
   making explicitly, and it can only be made inside a single ordered list.
3. **The boundary is genuinely fuzzy.** Is "decompose this god object" debt or architecture? Is a
   long-standing parser defect a bug, debt, or a specification gap? Effort goes into filing rather
   than deciding.

The worry behind the request — that features get drowned — is real. The answer is **tagging within
one ranked list**, not a second file.

### Where do schemas, API definitions and other formal contracts go?

Into the **specification** — and getting this wrong is instructive.

The tempting answer is to invent categories for them. The correct answer is that they pass the same
three tests as prose reference material. Present tense: they describe what the system is now.
Rewritten in place: always current, no history. Audience: users and implementers. Nothing
distinguishes a schema file from a reference chapter except the medium — and being machine-checked
makes it *better* specification, not something lesser.

Three consequences, which the map states as rules: source of truth, generated view and prose are
different things and only the third is writing; append-only sequences such as ordered migrations
are changelog-shaped whatever they describe; and prose may link to a machine-readable contract but
must never restate it.

Applying the same tests to the rest of a service's documentation reclassifies more than it adds: a
conformance target is specification while its known gaps are quirks; a runbook is a procedure for a
different audience at a different moment; a threat model is an assessment whose conclusions become
ADRs and whose findings become plan entries.

### How far do I trust each convention?

Only two entries deserve the word "standard":

- **[Keep a Changelog](https://keepachangelog.com)** — widely adopted, with tooling, and pairs with
  [SemVer](https://semver.org) and [Conventional Commits](https://www.conventionalcommits.org).
- **ADRs** — Nygard 2011, with [adr.github.io](https://adr.github.io), the
  [MADR](https://adr.github.io/madr/) template and [adr-tools](https://github.com/npryce/adr-tools).

`SPECIFICATION.md` and `PLAN.md` as filenames have no governing convention. Their ancestry is the
RFC/design-doc tradition (IETF RFCs, Python PEPs, Rust RFCs, Kubernetes KEPs, Google-style design
docs), none of which prescribe a root-level file of that name. Where that trio looks familiar from
other repositories, the likely proximate cause is spec-driven development tooling for coding agents
— GitHub's Spec Kit drives a `specify → plan → tasks` flow producing exactly it. **Verify Spec Kit
directly before leaning on it**: it is recent, and it is the one item here to treat as a lead
rather than an established convention.

Practical consequence: adapt the conventions freely, but leave Keep a Changelog and the ADR template
alone. Their value is largely that other people and tools already recognise them.

### Which optional artifacts are worth it?

Ranked by payoff for a project that does not yet have them:

1. **`docs/research/`** — usually the largest gap. Any project that reverse-engineers, targets a
   reference implementation, or reconciles contradictory sources accumulates findings with nowhere
   to live, and they end up scattered across a backlog entry, a code comment and a test comment.
2. **A deviation register (`docs/quirks.md`)** — answers "is this a bug or a decision?" for anyone
   comparing behaviour against a reference. Extend it to *accepted-wrong* behaviour: a known defect
   with a test asserting today's incorrect output is a quirk with an expiry date, and recording it
   stops the next person "fixing" the test.
3. **`docs/glossary.md`** — cheap, and worth it as soon as the domain has terms that mean something
   specific here, or ordinary words used precisely.
4. **`docs/testing.md`** — moderate. What is verified exactly versus approximately, and what is
   deliberately not covered, otherwise lives only in test comments.

Skip until earned: `CONTRIBUTING.md` / `CODE_OF_CONDUCT.md` / `SECURITY.md` (these earn their place
when outside contributions start), `RELEASING.md` (waits on releases), runbooks (services, not
libraries or tools), and `docs/tasks/` (overhead exceeds value below ~20 open items).

## Troubleshooting

Where people actually get stuck, and what the difficulty usually means.

**"I cannot decide which file this belongs in."**
Usually the sentence contains two facts. Split it and file each half; that resolves most cases. If
one fragment still resists, ask what would make it *wrong*: a wrong statement about behaviour is a
specification defect, a wrong statement about reasoning is an ADR to supersede, a wrong statement
about what happened is a changelog error. Whichever question stings, that is the home.

**"This looks like both an ADR and a research note."**
Did you *choose* something, or *learn* something? A choice has alternatives that were rejected — an
ADR. A finding is a fact about the world that would be true whoever discovered it — research. An
investigation that led to a decision produces both: the finding, and an ADR that cites it. That is
not duplication, because they answer different questions and decay differently.

**"Everything seems to belong in the specification."**
That is usually correct and not a problem. The specification is a set, and most of what a project
knows about itself is present-tense contract. Grow it into a tree with an index rather than
inventing categories. Pull something out only when its tense, mutability *and* audience genuinely
differ.

**"The README and the specification overlap."**
The README orients and links; the specification defines and constrains. A useful test: if the
sentence would survive a complete reimplementation, it is probably README. If it would have to be
obeyed by that reimplementation, it is specification.

**"I have a document I cannot classify at all."**
Two likely cases. It is a disposable working note, in which case it is a task file and can be
deleted when the work lands. Or it is two documents sharing a filename — try splitting it by tense
before trying to classify it whole.

**"The plan has grown to dozens of items and ranking has stopped meaning anything."**
You are past the ceiling a file-based backlog was ever meant to serve. Move it to an issue tracker
and leave a pointer in `PLAN.md`. This is a success condition, not a failure.

**"Nobody updates the changelog."**
Do not hand-maintain it per commit — that is the version that always decays. Generate it from
Conventional Commits, or write it once per release from the commit range. If there are no releases
yet, you do not need one yet.

**"The map has drifted from reality."**
Only two checks actually rot: every artifact named in the map exists, and every documentation file
appears in the map. Wire those into review, or into a CI check over filenames, rather than relying
on anyone remembering. The rest of the map changes rarely enough to look after itself.

**"I want to add a new file and it genuinely seems necessary."**
Apply the three-property test honestly, and note that it failed twice during this template's own
development — technical debt and machine-readable contracts both looked like obvious new categories
and both turned out to belong somewhere that already existed. If it passes, add it to both tables
in the map in the same commit.

**"There is an ADR I now think was wrong."**
Leave it alone and write the replacement, marking the old one superseded. A wrong decision plus its
supersession tells a future reader far more than a tidy history in which nobody was ever mistaken —
including *why* the reasoning looked sound at the time, which is what stops it being repeated.

**"This feels like a large migration and I keep not starting it."**
It is not all-or-nothing. Steps 1–3 — write the map, create the files it promises — are worth doing
on their own and take an afternoon. Step 4 can then proceed one artifact at a time, indefinitely.
An honest map over a partly-migrated repository is already better than no map.

## The lesson worth carrying

Twice while developing this template, a new category seemed obviously necessary — first technical
debt, then machine-readable contracts. Both times the correct answer was that an existing artifact
already covered it, and the apparent need came from splitting on the wrong axis.

So: **when something new turns up, test it against the existing categories before adding one.** Does
it have a distinct tense, mutability *and* audience? If it shares all three with an existing
document, it is a section or a tag within that document. Most candidates fail this test, which is
what keeps the structure small enough to survive.

If you take one thing from this file into a repository that never adopts the rest, take that.

# Adoption notes

The reasoning behind the structure, and what to do when the procedure will not settle a case by
itself. None of it is needed to apply [`ADOPTING.md`](ADOPTING.md) Steps 0-5 - come back here when
a decision resists, or when something is not working.

## Why the procedure is shaped the way it is

Three properties define every artifact: **tense** (does it describe what is, what was, or what is
intended?), **mutability** (rewritten in place, append-only, immutable, or disposable?) and
**audience**. Documentation rots when one file mixes them - the classic case being a document that
is part record of work done, part backlog, part assessment, so that no part of it can be trusted or
pruned with confidence. `ADOPTING.md`'s four numbered consequences all follow from that:

1. **You customise mostly by deleting.** The template is roughly the union of what projects need;
   any given repository needs a subset. Almost nothing has to be invented.
2. **What you keep is decided by capabilities, not taste.** A data store earns a data dictionary; a
   network API earns an interface definition; a deployed service earns a runbook.
3. **The rules are not the customisable part.** The three rules, the failure modes and the test for
   adding a new document survive customisation verbatim. They are what stops the structure decaying
   back into the mixed-tense file it replaced.
4. **Resist growth.** Most proposed additions share all three properties with something that
   already exists, which makes them a section or a tag rather than a file. The structure works
   because it is small enough to hold in your head.

## Judgement calls

The decisions Steps 1 and 4 tend to force, and the reasoning that resolves them.

### A documentation file you find during inventory is already gitignored - track it, or leave it be?

Ask; do not silently pick either default. A pre-existing gitignored documentation file (a personal
working-notes convention, a habit inherited from a previous tool) is a real, recurring shape, and
both silent answers are wrong often enough to matter: force-tracking it can commit something the
author deliberately kept private or provisional, and leaving it ignored can quietly exempt a real
artifact from ever being checked against the map. This is Step 1/4's version of a question
`tools/doc-kit-check.sh` also has to answer once such a file is adopted - see `§2.9`, which queries
a gitignored documentation file the same as any other but reports a hit in one as advisory rather
than blocking. The two are related, not the same decision twice: this one is a one-time call made
while building the inventory, the checker's is a permanent, ongoing property of every run
afterwards.

### Multi-module repository - one documentation structure, or one per module?

Ask; do not resolve this yourself from the shape of the build or the pre-existing docs. Whichever
way it goes, it is the repository owner's call, not a test for you to run and answer on their
behalf.

What you can usefully do is gather and present the evidence they would want when deciding: how many
modules have any consumer or audience outside this repository, versus being internal-only
dependencies of one product; whether the existing documentation already lives entirely under one
module, or is already split; what each "other module" currently has beyond a bare `README.md`. State
what you found plainly. Do not characterise it as "this looks like one product" or "these are
peers" - that framing is already halfway to answering the question for them, which is theirs to do.

The trap is letting that same evidence quietly become the decision instead of staying evidence - a
repository can easily have organically drifted into a documentation shape nobody chose, and
inheriting that drift silently is exactly the failure this kit exists to stop. As a rough prior,
repository-wide is right more often than not, and a per-module structure is worth taking seriously
often enough that it should never be dismissed out of hand - but that prior is context to hand the
person deciding, not a rule for you to apply in their place.

This is a decision a newcomer could reasonably question, which is the test for whether it earns a
record - it often will. Once made, write it up as an ADR rather than letting it live only in how
`DOC-MAP.md` ended up shaped.

### Should something flag a docs/tasks/*.md file with no matching PLAN.md entry?

No. The rule is `PLAN.md` entry -> optional `docs/tasks/` note, but nothing enforces that order, and
a mechanical check here would fight the same "no standard" call that keeps this directory otherwise
unchecked - a task file is ad hoc by design, not a second artifact with its own conformance rules.

If you find one by hand - during Step 4, or an ordinary read of the plan - there are two cases, not
one: the entry was deleted without deleting its note (delete the note too, or restore the entry if
the work isn't actually done), or the note was written first, before its entry (add the missing
entry rather than deleting a note that describes real work).

### Do we need a technical-debt file?

No. Debt is a **type tag within the single ranked plan**, alongside `bug`, `feature` and `docs`.

The worry behind the request - that features drown debt - is real, and the answer is ranking it
higher, not filing it elsewhere. Splitting by *category* where the structure splits on tense,
mutability and audience is what makes such files drift apart and go stale; the argument is
[ADR-0002](docs/adr/0002-keep-technical-debt-in-the-plan.md), and it generalises to most proposed
additions.

### Where do schemas, API definitions and other formal contracts go?

Into the **specification**. They pass the same three tests as prose reference material - present
tense, rewritten in place, audience of users and implementers - and being machine-checked makes them
*better* specification, not something lesser.

Applying those tests reclassifies more than it adds: a conformance target is specification while its
known gaps are quirks; a runbook is a procedure for a different audience at a different moment; a
threat model is an assessment whose conclusions become records and whose findings become plan
entries. See [ADR-0003](docs/adr/0003-treat-machine-readable-contracts-as-specification.md).

### The specification is a tree now - where exactly?

`docs/spec/`, once there are **two or more members** - don't force the subdirectory on a single-file
specification pre-emptively, there is nothing to group yet. `SPECIFICATION.md` stays at the
repository root regardless: it is a fixed element that changes role, not location, and each member
still keeps its own row in the artifacts table (tense/durability/audience can genuinely differ
between them - that is the whole reason they are separate files, and grouping them by directory is a
convenience on top of that, not a replacement for it).

Once there's more than one member, give `SPECIFICATION.md` a routing table of its own - the same
kind of thing `DOC-MAP.md`'s "Where does it go?" is, scoped to the members and keyed on audience.
"Which member does this fact go in" is the same problem one level down; the top-level map existing
doesn't answer it for you.

Nest it normally in the layout diagram:

```text
docs/
  spec/
    language.md
    architecture.md
  quirks.md
  adr/*.md
```

The checker's layout parser follows genuine nesting to any depth. The one thing it still needs: a
line that introduces a directory *for what's indented under it* must be bare - nothing else on that
line. A directory named with trailing description text (`templates/   product - ...`) is read as a
leaf representing the whole directory as one artifact instead, which is also a real, useful shape -
just a different one from a container with children.

### A second README (or spec member) shares tense, durability and audience with one that exists?

Neither merge nor invent a fake distinction - if it has to exist at that path for someone to find
it, it's an **alias**. A module `README.md` and the root one are both present/rewritten-in-place/
anyone, which would normally mean merging them (`templates/DOC-MAP.md` "Adding a new kind of
document"), but a module `README.md` exists so a newcomer working there finds orientation without
first navigating to the root. Mark it `**Alias**` in the artifacts table, give it no content of its
own, and let it inherit the properties of what it points to - the same applies to a specification
member repeated per module, or any file some tool looks for by exact name (`CLAUDE.md` pointing at
`AGENTS.md` is the case this kit's own map uses). See `templates/DOC-MAP.md`'s "Prescribed formats"
for the shape, and resist the temptation to word the audience column differently just to dodge the
duplicate-properties check - that hides the fact that the file has nothing of its own to say.

### How far do I trust each convention?

Only two entries deserve the word "standard":

- **[Keep a Changelog](https://keepachangelog.com)** - widely adopted, with tooling, and pairs with
  [SemVer](https://semver.org) and [Conventional Commits](https://www.conventionalcommits.org).
- **ADRs** - Nygard 2011, with [adr.github.io](https://adr.github.io), the
  [MADR](https://adr.github.io/madr/) template and [adr-tools](https://github.com/npryce/adr-tools).
  This kit follows MADR's **minimal** template; see
  [ADR-0010](docs/adr/0010-adopt-the-madr-minimal-template.md) for why that one.

Both have been checked against their sources. Leave them alone: their value is that other people and
tools already recognise them.

**The rest are this kit's own names. Use them.** No standard prescribes `SPECIFICATION.md` or
`PLAN.md` - the spec-driven tools that look like precedent keep per-feature files in their own
directories instead - and the kit does not pretend otherwise. It is the opinion. Consistency across
adopters is the same thing that makes Keep a Changelog worth deferring to, and it is worth having
here for the same reason.

One exception: if your repository already has an established equivalent, keep yours. Churning
filenames breaks links from issues, wikis and bookmarks, and that cost is real where the naming
difference is cosmetic. Record whichever you use in the map.

`ROADMAP.md` is not such an equivalent, and is the one substitution to refuse outright: it promises
users a dated roadmap rather than the team a ranked backlog, and the file drifts towards what its
name advertises.

[Research note 0002](docs/research/0002-conventions-this-kit-cites.md) has the sources.

### Which optional artifacts are worth it?

Ranked by payoff per line written, not by how large a gap they fill. All four stay optional - plenty
of repositories genuinely need none of them - but if you are adopting more than the core five, this
is the order to do it in.

1. **A deviation register (`docs/quirks.md`)** - answers "is this a bug or a decision?" for anyone
   comparing behaviour against a reference. Extend it to *accepted-wrong* behaviour: a known defect
   with a test asserting today's incorrect output is a quirk with an expiry date, and recording it
   stops the next person "fixing" the test. It is first because it is the only artifact here that
   says **do not change this**, and because the reader most likely to need telling is a coding
   agent, which will otherwise read deliberate strangeness as a defect and correct it.
2. **`docs/glossary.md`** - cheap, and worth it as soon as the domain has terms that mean something
   specific here, or ordinary words used precisely. Cheap to write, greppable, and it heads off the
   misreadings that are hardest to spot in review.
3. **`docs/testing.md`** - what is verified exactly versus approximately, and what is deliberately
   not covered, which otherwise lives only in test comments. The last of those is the part that
   earns the file: without it, an uncovered area is indistinguishable from an oversight, and someone
   - or something - will eventually "fix" it.
4. **`docs/research/`** - usually the largest gap, but conditional rather than general. Any project
   that reverse-engineers, targets a reference implementation, or reconciles contradictory sources
   accumulates findings with nowhere to live, and they end up scattered across a backlog entry, a
   code comment and a test comment. **If yours is such a project, move this to first** - the ranking
   above assumes it is not.

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
Did you *choose* something, or *learn* something? A choice has alternatives that were rejected - an
ADR. A finding is a fact about the world that would be true whoever discovered it - research. An
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
deleted when the work lands. Or it is two documents sharing a filename - try splitting it by tense
before trying to classify it whole.

**"The plan has grown to dozens of items and ranking has stopped meaning anything."**
You are past the ceiling a file-based backlog was ever meant to serve. Move it to an issue tracker
and leave a pointer in `PLAN.md`. This is a success condition, not a failure.

**"Deleting completed plan entries feels like erasing our engineering history."**
It isn't; it just leaves it where it belongs. Version control (`git log`) natively preserves
the complete, accurate history of what was done and why. Annotating a plan with "DONE" or
maintaining an internal changelog just creates a redundant prose log that competes with git
and eventually rots.

**"Nobody updates the changelog."**
Do not hand-maintain it per commit - that is the version that always decays. Generate it from
Conventional Commits, or write it once per release from the commit range. If there are no releases
yet, you do not need one yet.

**"The map has drifted from reality."**
Only two checks actually rot: every artifact named in the map exists, and every documentation file
appears in the map. Wire those into review, or into a CI check over filenames, rather than relying
on anyone remembering. The rest of the map changes rarely enough to look after itself.

**"I want to add a new file and it genuinely seems necessary."**
Apply the three-property test honestly, and note that it failed twice during this template's own
development - technical debt and machine-readable contracts both looked like obvious new categories
and both turned out to belong somewhere that already existed. If it passes, add it to both tables
in the map in the same commit.

**"Do documentation changes need approving?"**
One does. Accepting an ADR is the only moment this structure asks for agreement, because it is the
only artifact that cannot be corrected afterwards. Everything else is rewritten in place or deleted
freely, and ordinary review covers it. If you already have pull requests you already have the gate:
leave a record `proposed` while it is being argued - merging it undecided is fine and makes the open
question visible - and merge the flip to `accepted` once it is settled. Resist adding ceremony to
the plan in particular; friction at capture is what empties a backlog.

**"There is an ADR I now think was wrong."**
Leave it alone and write the replacement, marking the old one superseded. A wrong decision plus its
supersession tells a future reader far more than a tidy history in which nobody was ever mistaken -
including *why* the reasoning looked sound at the time, which is what stops it being repeated.

**"This feels like a large migration and I keep not starting it."**
It is not all-or-nothing. Steps 1-3 - write the map, create the files it promises - are worth doing
on their own and take an afternoon. Step 4 can then proceed one artifact at a time, indefinitely.
An honest map over a partly-migrated repository is already better than no map.

## The lesson worth carrying

Twice while developing this template, a new category seemed obviously necessary - first technical
debt, then machine-readable contracts. Both times the correct answer was that an existing artifact
already covered it, and the apparent need came from splitting on the wrong axis.

So: **when something new turns up, test it against the existing categories before adding one.** Does
it have a distinct tense, mutability *and* audience? If it shares all three with an existing
document, it is a section or a tag within that document. Most candidates fail this test, which is
what keeps the structure small enough to survive.

If you take one thing from this file into a repository that never adopts the rest, take that.

# Adoption notes

The reasoning behind the structure, and what to do when the procedure will not settle a case by
itself. None of it is needed to apply [`ADOPTING.md`](ADOPTING.md) Steps 0-5 — come back here when
a decision resists, or when something is not working.

## Judgement calls

The decisions Steps 1 and 4 tend to force, and the reasoning that resolves them.

### Do we need a technical-debt file?

No. Debt is a **type tag within the single ranked plan**, alongside `bug`, `feature` and `docs`.

The worry behind the request — that features drown debt — is real, and the answer is ranking it
higher, not filing it elsewhere. Splitting by *category* where the structure splits on tense,
mutability and audience is what makes such files drift apart and go stale; the argument is
[ADR-0002](docs/adr/0002-keep-technical-debt-in-the-plan.md), and it generalises to most proposed
additions.

### Where do schemas, API definitions and other formal contracts go?

Into the **specification**. They pass the same three tests as prose reference material — present
tense, rewritten in place, audience of users and implementers — and being machine-checked makes them
*better* specification, not something lesser.

Applying those tests reclassifies more than it adds: a conformance target is specification while its
known gaps are quirks; a runbook is a procedure for a different audience at a different moment; a
threat model is an assessment whose conclusions become records and whose findings become plan
entries. See [ADR-0003](docs/adr/0003-treat-machine-readable-contracts-as-specification.md).

### How far do I trust each convention?

Only two entries deserve the word "standard":

- **[Keep a Changelog](https://keepachangelog.com)** — widely adopted, with tooling, and pairs with
  [SemVer](https://semver.org) and [Conventional Commits](https://www.conventionalcommits.org).
- **ADRs** — Nygard 2011, with [adr.github.io](https://adr.github.io), the
  [MADR](https://adr.github.io/madr/) template and [adr-tools](https://github.com/npryce/adr-tools).
  This kit follows MADR's **minimal** template; see
  [ADR-0010](docs/adr/0010-adopt-the-madr-minimal-template.md) for why that one.

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

Ranked by payoff per line written, not by how large a gap they fill. All four stay optional — plenty
of repositories genuinely need none of them — but if you are adopting more than the core five, this
is the order to do it in.

1. **A deviation register (`docs/quirks.md`)** — answers "is this a bug or a decision?" for anyone
   comparing behaviour against a reference. Extend it to *accepted-wrong* behaviour: a known defect
   with a test asserting today's incorrect output is a quirk with an expiry date, and recording it
   stops the next person "fixing" the test. It is first because it is the only artifact here that
   says **do not change this**, and because the reader most likely to need telling is a coding
   agent, which will otherwise read deliberate strangeness as a defect and correct it.
2. **`docs/glossary.md`** — cheap, and worth it as soon as the domain has terms that mean something
   specific here, or ordinary words used precisely. Cheap to write, greppable, and it heads off the
   misreadings that are hardest to spot in review.
3. **`docs/testing.md`** — what is verified exactly versus approximately, and what is deliberately
   not covered, which otherwise lives only in test comments. The last of those is the part that
   earns the file: without it, an uncovered area is indistinguishable from an oversight, and someone
   — or something — will eventually "fix" it.
4. **`docs/research/`** — usually the largest gap, but conditional rather than general. Any project
   that reverse-engineers, targets a reference implementation, or reconciles contradictory sources
   accumulates findings with nowhere to live, and they end up scattered across a backlog entry, a
   code comment and a test comment. **If yours is such a project, move this to first** — the ranking
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

**"Do documentation changes need approving?"**
One does. Accepting an ADR is the only moment this structure asks for agreement, because it is the
only artifact that cannot be corrected afterwards. Everything else is rewritten in place or deleted
freely, and ordinary review covers it. If you already have pull requests you already have the gate:
leave a record `proposed` while it is being argued — merging it undecided is fine and makes the open
question visible — and merge the flip to `accepted` once it is settled. Resist adding ceremony to
the plan in particular; friction at capture is what empties a backlog.

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

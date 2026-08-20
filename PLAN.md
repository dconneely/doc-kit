# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

### Build the `templates/` tree

*Type: feature — Importance: high — Effort: medium*

`templates/` currently holds only the map. Every other artifact the map promises an adopter — the
specification, changelog, plan, README, ADR, research note, quirks, glossary, testing — needs a
starter file, so that Step 3 is a copy rather than a writing exercise. Empty directories carry a
`README.md` explaining the convention rather than a `.gitkeep`, since that is where the conventions
defined in `SPECIFICATION.md` §3 become visible at the point of use.

### Define the Step 4 inventory format and disposition vocabulary

*Type: feature — Importance: high — Effort: low*

Step 4 tells an adopter what to look for but gives them nowhere to put it and no words for what to
do with each file. It needs an inventory table — file, dominant tense, destination, disposition —
and a fixed set of dispositions: move, split, absorb, archive, delete, leave. Without a written
inventory, migration on a large repository is not resumable, which is the case it exists for.

### Split `ADOPTING.md` into a procedure and its rationale

*Type: docs — Importance: high — Effort: medium*

One file currently serves a reader deciding whether to adopt and a reader executing the migration.
The executing reader needs about 120 of its 300 lines: ordered steps, preconditions, stop
conditions, an output contract, and an approval gate before anything is modified. The deciding
reader needs the judgement calls and the troubleshooting. Progressive disclosure — a short procedure
linking outward — rather than deeper headings.

### Write the conformance checker

*Type: feature — Importance: high — Effort: medium*

`SPECIFICATION.md` §6 defines structural conformance as mechanically checkable and nothing checks
it. The two rules that rot are §2.3 and §2.4 — every artifact named exists, every documentation file
appears. Everything else is a bonus. Ship it with a CI workflow, because a checker nobody runs is
worth less than the specification it implements.

### Provide an install mechanism

*Type: feature — Importance: high — Effort: low*

Copying is manual and undocumented beyond a sentence in the README. Decide between a script, a
`degit`-style fetch, and documented manual steps, and write down which artifacts an adopter takes.

### Add a licence

*Type: docs — Importance: high — Effort: low*

A kit meant to be copied into other repositories without a licence is unusable by anyone careful.

### Move the format skeletons out of the map

*Type: docs — Importance: medium — Effort: low*

The map restates the ADR skeleton inline, which every adopter then copies into their own map. Once
`templates/docs/adr/0000-template.md` exists it should link instead, keeping only what the file
cannot express. Noted as a consequence in ADR-0004; blocked on the templates tree.

### Reconcile the judgement calls in `ADOPTING.md` against the ADRs

*Type: docs — Importance: medium — Effort: low*

ADR-0002 and ADR-0003 now record decisions that `ADOPTING.md` also argues at length, so the same
fact lives in two places. The ADRs keep the alternatives and consequences; the guide keeps the
adopter-facing answer and links. Known violation of `SPECIFICATION.md` §4.1, recorded rather than
hidden.

### Write the adoption skill

*Type: feature — Importance: medium — Effort: medium*

Most adoptions of this kit into a mature repository will be executed by an agent. That needs the
imperative procedure, an inventory output for approval before any file is modified, and resumable
state. Blocked on the `ADOPTING.md` split and the inventory format.

### Decide the template upgrade path

*Type: feature — Importance: medium — Effort: high*

An adopter copies the map and then customises it by deletion, so there is no way to take a later
improvement. Either version-stamp copied artifacts and ship migration notes per release, or state
explicitly that adoption is fork-and-forget. The second is a legitimate answer and should be chosen
deliberately rather than by omission.

### Write `docs/testing.md`

*Type: docs — Importance: medium — Effort: low*

Earned as soon as the checker exists: what it verifies exactly, what it verifies approximately, and
what is deliberately left to review — §4 substantive conformance in particular. Blocked on the
checker.

### Build a worked example

*Type: docs — Importance: low — Effort: high*

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.

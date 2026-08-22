# Adopt the documentation kit

Worksheet for Step 4 of `ADOPTING.md`. **Disposable** — delete it, and its `PLAN.md` entry, when the
migration lands.

Fill the inventory completely before moving any file. Deciding everything first is what keeps the
repository consistent at every point rather than only at the end, which matters because this work
gets interrupted.

## Inventory

Every documentation file in the repository, plus documentation held outside it — wikis, Confluence
spaces, shared drives, long issue descriptions. Give those their location in place of a path.

**Tense** is the dominant one: `present`, `past`, `future`, or `mixed`. Mixed is not a failure to
classify — it is the finding, and it always means `split`.

**Disposition** is exactly one of:

| | When | What it means |
| --- | --- | --- |
| `move` | one tense, wrong place | relocate as-is, with `git mv` so history and blame survive |
| `split` | mixed tense | divide by tense, file each part separately |
| `absorb` | belongs inside something that already exists | merge in, delete the original |
| `archive` | currency cannot be established | `docs/archive/` with a provenance header |
| `delete` | superseded, duplicated, or wrong with nothing worth keeping | git still has it |
| `leave` | already correct where it is | must still appear in the map |

| File or location | Tense | Destination | Disposition | Notes | Done |
| ---------------- | ----- | ----------- | ----------- | ----- | ---- |
|                  |       |             |             |       |      |

## Decisions found

Comments and documents explaining why something is *not* written the obvious way. Each is an ADR
that was never filed. Leave a one-line pointer behind at the original site.

| Where it lives now | Proposed ADR title | Filed |
| ------------------ | ------------------ | ----- |
|                    |                    |       |

## Findings found

Anything citing external sources, reconciling sources that disagree, or carrying a confidence level.
Record the confidence when filing.

| Where it lives now | Question it answers | Confidence | Filed |
| ------------------ | ------------------- | ---------- | ----- |
|                    |                     |            |       |

## Sources outside the repository

Where else documentation lives, who owns it, and whether it is in scope. A named out-of-scope source
is a decision; an unlisted one is an oversight.

## Blocked

Anything needing someone else's knowledge to classify — usually a document whose currency only one
person can confirm. Name the person and what you need from them. If the answer never comes, the
disposition is `archive`, not a guess.

## Before deleting this file

Everything above must have been emptied into its proper home. Check that nothing here is the only
surviving record of a decision, a finding, or an out-of-scope source.

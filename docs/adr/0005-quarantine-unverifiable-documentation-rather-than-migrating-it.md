---
status: "accepted"
date: 2026-08-20
decision-makers: David Conneely
---

# 5. Quarantine unverifiable documentation rather than migrating it

## Context and Problem Statement

Adoption into a mature repository turns up documentation that is neither worth migrating nor safe to
delete: design notes from three reorganisations ago, a `docs/` folder nobody has opened in years, a
file that describes behaviour which may or may not still be true.

The initial framing was that the unmigratable material is what a reader cannot *read* - scanned
PDFs, binary diagram formats, whiteboard photographs, diagrams whose meaning is in their layout.
That category is real but small, and capable readers, human or otherwise, keep shrinking it.

The category that actually fills an archive is different: material that reads perfectly and cannot
be **dated**. A file says "the system does X". Is that current behaviour or a description of 2019? A
document cites a decision made with a colleague who has left, or a ticket in a decommissioned
tracker. Nothing in the text distinguishes live from stale.

This creates a specific hazard that the structure itself causes. Migrating such a claim into
`SPECIFICATION.md` launders it: the whole point of the specification is that readers trust it, so a
stale sentence promoted into it is more dangerous than the same sentence left in an untrusted
folder. A confident migration is worse than no migration.

## Considered Options

* Migrate everything, resolving currency by judgement
* Delete what cannot be verified
* Quarantine it in an archive directory, under explicit rules

## Decision Outcome

Chosen option: **quarantine in an archive directory**, under four rules:

1. The archive holds material whose **currency cannot be established**, not merely material that is
   hard to read.
2. Every archived file carries a **provenance header** - not authoritative, last known accurate
   when, why not migrated. A folder-level warning is not enough.
3. Every entry states **why it was not migrated**.
4. Archived files are **exempt** from the map's completeness check, and the archive appears in the
   map as a single entry.

Nothing outside the archive may cite something inside it as a source. Material worth relying on gets
migrated first, at which point it acquires a confidence level.

Deleting was rejected because these files are often the only surviving record of why something is
the way it is, and the cost of the loss is not visible until years later. Migrating everything was
rejected because it is the laundering hazard above.

### Consequences

* Good, because the per-file header protects readers who arrive by search and never see the folder.
  A `README.md` in the archive protects nobody; a file found by grep must carry its own warning.
* Good, because requiring a stated reason per entry is what stops the archive becoming a landfill. A
  blanket "here be dragons" folder is unfalsifiable and grows without limit - the plan-graveyard
  failure in a new location.
* Bad, because rule 4 is a real concession. Without it the archive fights the completeness check on
  day one, and the predictable outcome is that someone disables the check rather than empties the
  archive.
* Neutral: the archive may never be emptied. That is tolerable - an archive with honest headers is a
  known-untrusted region, which is a stable state. The failure this prevents is not a large archive
  but a contaminated specification.

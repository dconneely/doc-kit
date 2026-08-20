# 5. Quarantine unverifiable documentation rather than migrating it

## Status

Accepted

## Context

Adoption into a mature repository turns up documentation that is neither worth migrating nor safe to
delete: design notes from three reorganisations ago, a `docs/` folder nobody has opened in years, a
file that describes behaviour which may or may not still be true.

The initial framing was that the unmigratable material is what a reader cannot *read* — scanned
PDFs, binary diagram formats, whiteboard photographs, diagrams whose meaning is in their layout.
That category is real but small, and capable readers, human or otherwise, keep shrinking it.

The category that actually fills an archive is different: material that reads perfectly and cannot be
**dated**. A file says "the system does X". Is that current behaviour or a description of 2019? A
document cites a decision made with a colleague who has left, or a ticket in a decommissioned
tracker. Nothing in the text distinguishes live from stale.

This creates a specific hazard that the structure itself causes. Migrating such a claim into
`SPECIFICATION.md` launders it: the whole point of the specification is that readers trust it, so a
stale sentence promoted into it is more dangerous than the same sentence left in an untrusted folder.
A confident migration is worse than no migration.

Deleting instead was considered. It is rejected because these files are often the only surviving
record of why something is the way it is, and the cost of the loss is not visible until years later.

## Decision

We will quarantine such material in an archive directory rather than migrating or deleting it, under
four rules:

1. The archive holds material whose **currency cannot be established**, not merely material that is
   hard to read.
2. Every archived file carries a **provenance header** — not authoritative, last known accurate when,
   why not migrated. A folder-level warning is not enough.
3. Every entry states **why it was not migrated**.
4. Archived files are **exempt** from the map's completeness check, and the archive appears in the
   map as a single entry.

Nothing outside the archive may cite something inside it as a source. Material worth relying on gets
migrated first, at which point it acquires a confidence level.

## Consequences

The per-file header is the load-bearing part. Readers and tools arrive at these files directly, by
search, and never see the folder — so a `README.md` in the archive protects nobody. A file found by
grep must carry its own warning.

Requiring a stated reason per entry is what stops the archive becoming a landfill. A blanket "here be
dragons" folder is unfalsifiable and grows without limit; it would reproduce the plan-graveyard
failure mode in a new location.

The exemption in rule 4 is a deliberate concession. Without it the archive fights the completeness
check on day one, and the predictable outcome is that someone disables the check rather than empties
the archive.

We accept that the archive may never be emptied. That is tolerable: an archive with honest headers is
a known-untrusted region, which is a stable state. The failure this decision prevents is not a large
archive but a contaminated specification.

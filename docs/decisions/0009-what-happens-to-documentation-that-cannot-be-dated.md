---
status: "accepted"
date: 2026-10-25
decision-makers: David Conneely
approval: "yes"
---

# 9. What happens to documentation that cannot be dated

## Context and Problem Statement

Adopting into a mature repository turns up documentation that is neither worth migrating nor safe to
delete. The small part of it is material a reader cannot read - scanned PDFs, binary diagrams. The
large part reads perfectly and cannot be **dated**: a file says "the system does X", and nothing
says whether that is current behaviour or a description of five years ago.

Migrating such a claim into the specification launders it. Readers are told to trust the
specification, so a stale sentence promoted into it is more dangerous than the same sentence left in
an untrusted folder.

## Considered Options

- Migrate everything, resolving currency by judgement
- Delete what cannot be verified
- Quarantine it in an archive directory, under explicit rules

## Decision Outcome

Chosen option: **quarantine in an archive directory**, under four rules:

1. The archive holds material whose **currency cannot be established**, not merely material that is
   hard to read.
2. Every archived file carries a **provenance header**: not authoritative, last known accurate when,
   why not migrated. A folder-level warning is not enough.
3. Every entry states **why it was not migrated**.
4. Archived files are **exempt** from the map's completeness check, and the archive appears in the
   map as a single entry.

Nothing outside the archive cites something inside it. Material worth relying on is migrated first,
and acquires a confidence level.

Deleting was rejected because these files are often the only surviving record of why something is as
it is, and the loss is not visible until years later. Migrating everything was rejected because it
launders undatable claims.

### Consequences

- Good, because the header protects readers who arrive by search and never see the folder.
- Good, because a stated reason per entry stops the archive becoming a landfill.
- Bad, because rule 4 is a concession. Without it the archive fights the completeness check on the
  first day, and the likely outcome is a disabled check rather than an emptied archive.
- Neutral: the archive may never be emptied. An archive with honest headers is a known-untrusted
  region, which is a stable state; the failure it prevents is a contaminated specification.

## Confirmation

`tools/doc-kit-check.sh`

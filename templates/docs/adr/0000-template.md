# 0. Short title in the imperative

<!--
Copy to NNNN-kebab-case-title.md, four-digit zero-padded, numbers unique and never reused.
The heading number matches the filename. Keep this file as 0000; it is the template.

Immutability attaches to the STATUS, not to the commit. While it says Proposed, edit it freely —
and merge it if the decision is still open, since a pending decision is more discoverable in the
tree than in a branch nobody is watching. Once it says Accepted it is immutable: never edit it
except to change its Status. Correcting a decision means writing its successor and setting this one
to "Superseded by ADR-NNNN". Its whole value is being faithful to what was known at the time —
including what turned out to be wrong.

If a decision is still being argued, leave it Proposed. Accepting early and then revising is the
common failure, and it destroys exactly the property the record exists for.

CHANGING THE STATUS IS A HUMAN ACTION. A tool may draft this file, argue it, and merge it as
Proposed. Only a person flips it to Accepted, and doing so asserts that a decision was really made.
Only Accepted records bind anything; a Proposed one constrains nobody.

Make that flip its own pull request. A separate commit is not enough — squash merging folds it back
into the commit that drafted the record, and the one moment worth seeing becomes invisible.

Write it when the decision is made, not later. A record reconstructed years afterwards is usually
an argument for what you already do, and it dilutes the ones written contemporaneously.

Delete this comment in the copy.
-->

## Status

Proposed

<!-- Exactly one of: Proposed | Accepted | Deprecated | Superseded by ADR-NNNN -->

## Context

What forces were at play. What was known at the time — and, more usefully, what was **not** known.
What alternatives existed. Name the constraint that made this decision non-obvious; if there wasn't
one, this may not need a record.

## Decision

What we are doing, in the active voice: "We will …". One paragraph if possible.

## Consequences

What becomes easier. What becomes harder. What we accept as a result.

The honest ones are the useful ones — a record listing only benefits tells a future reader nothing
about whether the trade-off still holds.

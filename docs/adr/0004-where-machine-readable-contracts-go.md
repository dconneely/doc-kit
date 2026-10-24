---
status: "accepted"
date: 2026-10-24
decision-makers: David Conneely
approval: 'Yes (asked: "Do you accept ADR-0001 to ADR-0013?")'
---

# 4. Where machine-readable contracts go

## Context and Problem Statement

Schemas, OpenAPI and AsyncAPI documents, interface definitions and migrations look like something
other than documentation - code, or something between the two - and so like a category of their own,
or something out of scope. The temptation is to invent a category per medium.

## Considered Options

- A new top-level category for machine-readable contracts
- Declare them out of scope, as code rather than documentation
- Treat them as members of the specification

## Decision Outcome

Chosen option: **members of the specification**, because a schema passes the same three tests as a
reference chapter - present tense, rewritten in place, read by users and implementers (ADR-0002).
Nothing distinguishes it except the medium, and being checked by a machine makes it better
specification, not something lesser. The specification is a set, not a file, and its members may be
prose or machine-readable.

Three things stay distinguished:

- **Source of truth** - the contract itself, versioned and reviewed like code.
- **Generated view** - diagrams, rendered references, snapshots, clients. Never hand-edited; it
  carries a generated-by header, and regenerating it produces no diff.
- **Prose that cannot be derived** - rationale, invariants, units, ownership, policy. The only part
  that is writing.

Prose may link to a machine-readable contract. It never restates one.

### Consequences

- Good, because applying the test reclassifies more than it adds. A conformance target is
  specification while its known gaps are quirks; a runbook is a procedure for a different audience;
  a threat model is an assessment whose conclusions become records and whose findings become plan
  entries.
- Good, because ordered migrations come out changelog-shaped, whatever they describe. The
  specification is the current shape, which is why a generated snapshot of it earns a place beside
  them.
- Bad, because the rule against restating a contract is expensive to hold. Restating is what feels
  helpful to a reader, so the rule has to be held in review rather than trusted to instinct.

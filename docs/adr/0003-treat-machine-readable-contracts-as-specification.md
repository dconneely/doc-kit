---
status: "accepted"
date: 2026-08-20
decision-makers: David Conneely
---

# 3. Treat machine-readable contracts as specification

## Context and Problem Statement

Schemas, OpenAPI and AsyncAPI documents, interface definitions, migrations: the second candidate for
a new top-level category, after technical debt (ADR-0002). The intuition was that these are not
documentation at all — they are code, or something between the two — and so need a category of their
own, or to be declared out of scope.

The intuition is wrong in an instructive way, and the temptation is to invent a category per medium.

## Considered Options

* A new top-level category for machine-readable contracts
* Declare them out of scope, as code rather than documentation
* Treat them as members of the specification

## Decision Outcome

Chosen option: **members of the specification**, because a schema passes the same three tests as a
reference chapter — present tense, rewritten in place, audience of users and implementers. Nothing
distinguishes it except the medium, and being machine-checked makes it *better* specification, not
something lesser. The specification is a set, not a file, and its members may be prose or
machine-readable.

Three things that get confused with each other must stay distinguished:

* **Source of truth** — the contract itself. Versioned and reviewed like code.
* **Generated view** — diagrams, rendered references, snapshots, clients. Never hand-edited, carries
  a generated-by header, and CI fails if regenerating produces a diff.
* **Prose that cannot be derived** — rationale, invariants, units, ownership, policy. The only part
  that is writing.

Prose may link to a machine-readable contract. It must never restate one.

### Consequences

* Good, because applying this reclassifies more than it adds. A conformance target is specification
  while its known gaps are quirks; a runbook is a procedure for a different audience at a different
  moment; a threat model is an assessment whose conclusions become records and whose findings become
  plan entries. Most things that look like new categories are the contract in a different medium.
* Good, because ordered migrations come out changelog-shaped rather than specification, whatever
  they describe — the specification is the *current* shape, which is why a generated snapshot of it
  earns a place alongside them.
* Bad, because the link-never-restate rule is expensive to hold. The moment prose repeats a field
  list there are two sources of truth and one is already wrong — but restating is precisely what
  feels helpful to a reader, so this has to be enforced in review rather than trusted to instinct.

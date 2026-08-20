# 1. Organise documentation by tense, mutability and audience

## Status

Accepted

## Context

Documentation rots in a characteristic way. It is rarely that nobody writes anything; it is that one
file accumulates several jobs — part record of work done, part backlog, part architecture assessment
— until no part of it can be trusted or pruned with confidence. Nobody can delete a line from it,
because deleting the stale half might delete the live half.

The obvious organising principle is subject: a file per topic, per component, per concern. Every
project that tries it arrives at the same place, because subjects overlap and a fact about a subject
still has to be filed somewhere within it.

What was not known at the time: whether three properties were enough, or whether a fourth would turn
up under pressure. Two later candidates — technical debt and machine-readable contracts, ADR-0002
and ADR-0003 — tested it and did not require one.

## Decision

We will organise documentation by three properties, and only these three:

- **Tense** — does it describe what is, what was, or what is intended?
- **Mutability** — rewritten in place, append-only, immutable, or disposable?
- **Audience** — who reads it, and at what moment?

A candidate document that shares all three with an existing artifact is a section or a tag within
that artifact, not a new file. This test is normative and applies to every proposed addition.

## Consequences

Filing becomes mechanical rather than a judgement call: the tense of the sentence being written
usually settles it, and a sentence that resists is usually two sentences.

Splitting a mixed-tense file becomes mechanical too, which matters most on exactly the repositories
this kit targets — the migration is a sort, not a rewrite.

The structure stays small. Most proposed additions fail the test, which is the point; the cost is
that a genuinely new category feels harder to add than it is, and the test has to be applied
honestly rather than as a formality.

We accept that the three properties are a heuristic with no external authority behind them. They are
justified by what they prevent, not by a standard.

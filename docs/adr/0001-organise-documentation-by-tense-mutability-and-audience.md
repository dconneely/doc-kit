---
status: "accepted"
date: 2026-08-20
decision-makers: David Conneely
---

# 1. Organise documentation by tense, mutability and audience

## Context and Problem Statement

Documentation rots in a characteristic way. It is rarely that nobody writes anything; it is that one
file accumulates several jobs - part record of work done, part backlog, part architecture
assessment - until no part of it can be trusted or pruned with confidence. Nobody can delete a line
from it, because deleting the stale half might delete the live half.

What was not known at the time: whether three properties were enough, or whether a fourth would turn
up under pressure. Two later candidates - technical debt and machine-readable contracts, ADR-0002
and ADR-0003 - tested it and did not require one.

## Considered Options

- Organise by **subject** - a file per topic, per component, per concern
- Organise by **tense, mutability and audience**
- Impose no organising principle, and rely on review to keep files coherent

## Decision Outcome

Chosen option: **tense, mutability and audience**, because those are the properties whose mixture
causes the rot, and organising by anything else leaves them free to mix.

Concretely: does it describe what is, what was, or what is intended? Is it rewritten in place,
append-only, immutable, or disposable? Who reads it, and at what moment?

A candidate document sharing all three with an existing artifact is a section or a tag within that
artifact, not a new file. This test is normative and applies to every proposed addition.

Subject-based organisation was rejected because subjects overlap, and a fact about a subject still
has to be filed somewhere _within_ it - so the problem reappears one level down. Every project that
tries it arrives at the same place.

### Consequences

- Good, because filing becomes mechanical rather than a judgement call: the tense of the sentence
  usually settles it, and a sentence that resists is usually two sentences.
- Good, because splitting a mixed-tense file becomes mechanical too - the migration is a sort, not a
  rewrite, which matters most on exactly the repositories this kit targets.
- Good, because the structure stays small. Most proposed additions fail the test, which is the
  point.
- Bad, because a genuinely new category feels harder to add than it is, and the test has to be
  applied honestly rather than as a formality.
- Neutral: the three properties are a heuristic with no external authority behind them. They are
  justified by what they prevent, not by a standard.

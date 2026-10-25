---
status: "accepted"
date: 2026-10-25
decision-makers: David Conneely
approval: "yes"
---

# 2. How documentation is divided into artifacts

## Context and Problem Statement

Documentation rots in a characteristic way. It is rarely that nobody writes anything; it is that one
file accumulates several jobs - part record of work done, part backlog, part assessment - until no
part of it can be trusted or pruned with confidence. Nobody can delete a line from it, because
deleting the stale half might delete the live half.

## Considered Options

- Organise by **subject** - a file per topic, per component, per concern
- Organise by **tense, mutability and audience**
- Impose no organising principle, and rely on review to keep files coherent

## Decision Outcome

Chosen option: **tense, mutability and audience**, because those are the properties whose mixture
causes the rot, and organising by anything else leaves them free to mix.

Does it describe what is, what was, or what is intended? How does it change over its life? Who reads
it? A candidate document sharing all three with an existing artifact is a section or a tag within
that artifact, unless it holds different facts - so a shared triple is a prompt to check, not a
verdict (ADR-0015). This test applies to every proposed addition. Two obvious candidates for new
categories, technical debt and machine-readable contracts, both turned out to belong in artifacts
that already existed (ADR-0003, ADR-0004).

Subject-based organisation was rejected because subjects overlap, and a fact about a subject still
has to be filed somewhere within it, so the problem reappears one level down. No principle at all
was rejected because review cannot hold a line nobody has drawn.

### Consequences

- Good, because filing becomes mechanical rather than a judgement call: the tense of the sentence
  usually settles it, and a sentence that resists is usually two sentences.
- Good, because splitting a mixed-tense file becomes mechanical too - a migration is a sort, not a
  rewrite.
- Good, because the structure stays small. Most proposed additions fail the test.
- Bad, because the test is a prompt, not a proof: with closed sets, artifacts holding different
  facts can share all three properties, and telling them apart is a judgement.
- Bad, because a genuinely new category feels harder to add than it is, and the test has to be
  applied honestly rather than as a formality.
- Neutral: the three properties are a heuristic with no external authority behind them. They are
  justified by what they prevent, not by a standard.

## Confirmation

`tools/doc-kit-check.sh`

---
status: "accepted"
date: 2026-10-25
decision-makers: David Conneely
approval: "yes"
---

# 12. What tense, and how much, is written

## Context and Problem Statement

Saying where a fact goes does not stop two problems agents cause:

- **Comments accumulate narrative.** "Previously this did X", "after investigating", "fixed the bug
  where" - history and process, written beside code that no longer needs it.
- **Documents run long.** Nothing tells an agent to write a fact briefly once it knows where the
  fact goes.

Code comments are a documentation location every repository has, and the one most likely to reach an
agent: it reads the file it is changing, not `docs/`. Jon Gjengset's
[On Comments](https://blog.helsing.ai/posts/on-comments/) argues for comments that carry the why the
code cannot.

## Considered Options

- Govern only where facts live, and say nothing about comments or length
- Govern tense and volume everywhere text is written, code comments included, and nothing about
  style
- Adopt writing and comment standards - Gjengset's comment categories, or a house style

## Decision Outcome

Chosen option: **govern tense and volume, not style**, because narrative in a comment is the same
failure as history in the specification, and the tense test that catches it there catches it here.

A comment says, in the present tense, why the code beside it is as it is. History goes in the commit
message. A reason governing more than one site goes in a decision record, and intent in the plan;
the comment names the record - a `TODO` names its plan entry rather than replacing it - so a reader
of the code finds it. A reason local to one site may stay in the comment, whatever its form.
Everywhere, write the least that is true.

This sets no length limit. "The least that is true" is a direction: a long comment carrying a real
correctness argument meets it, and a short one narrating its own history does not.

Governing only where facts live was rejected because it leaves both problems where they are.
Standards were rejected because categories and style are judgement a project owns; the kit's rules
are about where facts live and what tense they take.

### Consequences

- Good, because comments - the documentation an agent is sure to read - point at the record when the
  reason lives in one.
- Good, because agents get a brevity rule, in the one text that reaches them.
- Bad, because the boundary between tense and volume on one side and style on the other is a
  judgement, drawn differently by different reviewers.
- Bad, because a `TODO` that only points at the plan departs from the common practice of describing
  the work in place. The trade is that the work competes in one ranked list (ADR-0002).
- Bad, because nothing mechanical checks it: a comment is not an artifact in the map.

## Confirmation

`review`

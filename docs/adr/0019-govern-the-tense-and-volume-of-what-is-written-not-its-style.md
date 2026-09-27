---
status: "accepted"
date: 2026-09-27
decision-makers: David Conneely
---

# 19. Govern the tense and volume of what is written, not its style

## Context and Problem Statement

`SPECIFICATION.md` says the kit "says nothing about writing quality, house style, or what a project
ought to document", and does not cover code comments. Adopters report two problems that exclusion
leaves unaddressed, both caused by agents rather than people:

- **Comments accumulate narrative.** "Previously this did X", "after investigating", "fixed the bug
  where" - history and process, written beside code that no longer needs it.
- **Documents run long.** The kit says where a fact goes, but nothing tells an adopter's agent to
  write it briefly. "Volume is a cost" is about how many artifacts there are, and the kit's own
  brevity rule in `AGENTS.md` covers only text the kit ships.

Code comments are also a documentation location every adopting repository already has, and the one
most likely to reach an agent: it reads the file it is changing, not `docs/`. Jon Gjengset's
[On Comments](https://blog.helsing.ai/posts/on-comments/) makes that argument, and argues for
comments that carry the _why_ the code cannot. The kit already links from documents to code - quirk
`Where:` fields, ADRs naming the code they constrain - but not back.

## Considered Options

- Keep the exclusion: routing only, nothing about comments or length
- Govern tense and volume everywhere text is written, code comments included, and nothing about
  style
- Adopt writing and comment standards - Gjengset's comment categories, or a house style

## Decision Outcome

Chosen option: **govern tense and volume, not style**, because the kit already holds both rules and
applies neither where these problems occur. Narrative in a comment is the failure "the specification
accumulates history" in a different file, and the tense test that catches it there catches it here.
"Volume is a cost" and the kit's cut-hardest rule for its own text are the same principle, not yet
extended to what adopters write.

A comment says, in the present tense, why the code beside it is as it is. History goes in the commit
message. A reason governing more than one site goes in an ADR, and intent in the plan; the comment
names the record - a `TODO` names its plan entry, never replaces it - so a reader of the code finds
it. A reason local to one site may stay in the comment, whatever its form: an in-code Y-statement is
one, though its changelog is history and belongs in the commit. Everywhere, write the least that is
true.

Keeping the exclusion was rejected because it leaves both reported problems where they are.
Standards were rejected because categories and style are judgement a project owns; the kit's rules
are about where facts live and what tense they take, and a style guide is neither.

This sets no length limit. "The least that is true" is a direction: a long comment carrying a real
correctness argument meets it, and a short one narrating its own history does not.

### Consequences

- Good, because comments - the documentation an agent is sure to read - point at the record when the
  reason lives in one.
- Good, because it gives adopters' agents a brevity rule they currently lack, in the one text that
  reaches them.
- Bad, because it widens the kit's stated scope, and the boundary between "tense and volume" and
  "style" is a judgement a reviewer will sometimes draw differently.
- Bad, because a `TODO` that only points at the plan departs from common practice, Gjengset's
  included, of describing the work in place. The trade is that the work then competes in one ranked
  list, as ADR-0002 requires of debt.
- Bad, because nothing mechanical checks it. A comment is not an artifact in the map, so
  `tools/doc-kit-check.sh` cannot see it.
- Neutral: if accepted, `SPECIFICATION.md`'s "Not in scope" narrows to style and to what a project
  ought to document, and says comments are governed for tense and routing only.
- Neutral: `templates/DOC-MAP.md` routes a comment's content, `TODO`s included, as the Decision
  Outcome does, and gains the failure mode "Text narrates". It overlaps the specification's and
  research note's failures, which it names as special cases rather than replacing them, because each
  carries its own file's examples and remedy.
- Neutral: the `AGENTS.md` stanza in `ADOPTING.md` gains "Write the least that is true", deferring
  to the map for where history and reasons go rather than restating it.

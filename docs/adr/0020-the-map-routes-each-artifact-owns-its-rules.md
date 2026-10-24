---
status: "proposed"
date: 2026-10-24
decision-makers: {who decided - required once the status is not "proposed"}
---

# 20. The map routes, each artifact owns its rules, and the reasons stay with the kit

## Context and Problem Statement

ADR-0011 split guidance three ways: templates carry shape, the map carries rules, and `ADOPTING.md`
carries the one-time procedure. In practice the map also carries each artifact's format and the
reasons for the structure: prescribed formats, the failure modes, the standards each convention
follows, and why. `templates/DOC-MAP.md` is about 2,900 words, and the `AGENTS.md` stanza tells
agents to read it first, so every agent session pays for all of it before writing anything.

The split also states facts twice within the set an adopter copies. The plan format appears in the
map and in `PLAN.md`, the quirk fields in the map and in `quirks.md`, and the research-note rules in
the map and in `research/0000-template.md`. Every adoption therefore breaks `SPECIFICATION.md` §4.1
from the first day.

The map is read when deciding where something goes. A format is needed when writing in the file that
has it. A reason is needed when someone questions a rule, which is rare.

## Considered Options

- Keep ADR-0011's split, and trim the map's wording
- Route in the map, put each artifact's rules in that artifact, and keep the reasons in the kit,
  with the adopter's own adoption record citing them
- Put rules and reasons in a separate shipped explanation file beside the map

## Decision Outcome

Chosen option: **route in the map, and let each artifact own its rules**, because each kind of
content is then read at the moment it is needed, and is stated once in the adopter's repository.

- **The map** holds routing, the rules that span artifacts, and the test for adding a document.
- **Each artifact** holds its own format and rules, in its preamble or its `0000-template.md`. The
  status and immutability rules for decision records move into `docs/adr/0000-template.md`.
- **The reasons** stay in the kit's records and `ADOPTING-NOTES.md`, which gains the failure modes.
  An adopter's repository records its own reasons in an adoption decision record, shipped as a
  template, that cites the kit at a pinned commit.

A decision record no longer names the code it constrains. The comment beside the code names the
record instead, because code changes more often than records do and a link from the record would go
stale.

Trimming the wording was rejected because it leaves the duplication and the reading cost in place. A
separate explanation file was rejected because it adds an artifact whose only reader is someone
questioning a rule, and the adoption record already serves that reader.

This supersedes ADR-0011, whose Decision Outcome gave the map every rule.

### Consequences

- Good, because the map an agent reads first shrinks to routing.
- Good, because each format is stated once in an adopter's repository, beside where it is used.
- Good, because an adopter's reasons for adopting, and for deviating, are a record a person accepts,
  not prose nobody owns.
- Bad, because a reader who wants all the rules in one place now opens several files.
- Bad, because the provenance of the loose conventions (Diátaxis, Standard Readme) leaves the
  shipped map, and is found only in the kit.
- Neutral: the `AGENTS.md` stanza keeps its one-line hazards, so an agent still sees the decision
  record rules without opening the template.
- Neutral: ADR-0011's status becomes `superseded by ADR-0020` when this is accepted.

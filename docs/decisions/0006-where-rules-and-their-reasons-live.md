---
status: "accepted"
date: 2026-10-28
decision-makers: David Conneely
approval: "Do it"
---

# 6. Where rules and their reasons live

## Context and Problem Statement

Guidance about the structure is needed at three moments: once, while adopting; whenever someone
writes in a file; and rarely, when someone questions a rule. `ADOPTING.md` stays with the kit and is
not copied, so guidance needed after adoption cannot live only there.

The map is the file the `AGENTS.md` stanza tells every agent session to read before writing
anything. Each word in it is paid for by every session, and anything it shares with the files it
describes is stated twice in every adopting repository, against `docs/spec.md` §4.1.

`docs/spec.md` §4.1 was written as an absolute - no fact in two artifacts - but prose cannot be
symlinked, and the kit's own specification, templates, map and notes repeat tables, value lists and
multi-step processes. Those repeats drift. A template and the kit's own instance are different
artifacts, so they may repeat their own content; a short instruction may be repeated where the
reader cannot follow a link.

## Considered Options

- Embed instructions throughout the templates, as banners, comments and placeholder entries
- Move every instruction to `ADOPTING.md`
- Templates carry shape, the map carries every rule, `ADOPTING.md` carries the one-time procedure
- Route in the map, put each artifact's rules in that artifact, and keep the reasons in the kit
- Put rules and reasons in a separate shipped explanation file beside the map
- For shared content: keep §4.1 absolute and check every repeat; make the specification the
  normative source; make the templates the normative source; put the value sets in a shared
  machine-readable block; rely on review

## Decision Outcome

Chosen option: **route in the map, and let each artifact own its rules**, because each kind of
content is then read at the moment it is needed, and stated once in the adopter's repository.

- **The map** holds routing, the rules that span artifacts, and the test for adding a document.
- **Each artifact** holds its own format and rules, in its preamble or its `0000-template.md`.
  Templates carry shape and an example, with no commentary about the kit.
- **`ADOPTING.md`** holds the one-time procedure.
- **The reasons** stay in the kit's records and `ADOPTING-NOTES.md`. An adopting repository records
  its own reasons in an adoption decision record, shipped as a template, that cites the kit at a
  pinned commit.

### Shared tables, value lists and processes

§4.1 is a guideline, not an absolute. A table, a list of more than three values, or a process of
three or more steps SHOULD have one home. For an artifact's shared shape and value sets, that home
is its template; the specification cites the template and keeps the contract-level rules. The
checker's value sets are tested against the templates. Short instructional copies - the `AGENTS.md`
stanza, a gate in the skill or `ADOPTING.md` - and template/instance pairs MAY repeat; they name the
source and are kept in step by review or test. An advisory detector reports repeated tables, value
lists and step sequences, not repeated sentences.

A decision record does not name the code it constrains. The comment beside the code names the record
instead, because code changes more often than records do and a link from the record would go stale.

Embedded instructions were rejected because every adopter pays to read and delete them, and they
duplicate `ADOPTING.md`. Moving everything to `ADOPTING.md` was rejected because it is not copied.
Giving the map every rule was rejected because it duplicates each artifact's format and makes every
session read all of it. A separate explanation file was rejected because its only reader is someone
questioning a rule, and the adoption record already serves that reader.

### Consequences

- Good, because the map an agent reads first is routing.
- Good, because each format is stated once in an adopter's repository, beside where it is used.
- Good, because an adopter's reasons for adopting, and for deviating, are a record the owner
  accepts.
- Good, because a shared table, value list or multi-step process has one home, so a correction lands
  once.
- Good, because the checker's value sets are tested against the templates instead of drifting.
- Bad, because the specification is less self-contained: a reader follows links into the templates.
- Bad, because a template change is now a contract change, needing the specification and checker to
  follow.
- Bad, because a reader who wants all the rules in one place opens several files.
- Bad, because the provenance of the loose conventions, such as Diátaxis and Standard Readme, is
  found only in the kit.
- Neutral: template/instance repetition remains by design.

## Confirmation

`review`

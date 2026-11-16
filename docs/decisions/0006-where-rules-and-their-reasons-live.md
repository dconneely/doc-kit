---
status: "accepted"
date: 2026-11-16
decision-makers: David Conneely
---

# 6. Where rules and their reasons live

## Context and Problem Statement

Guidance about the structure is needed at three moments: once, while adopting; whenever someone
writes in a file; and rarely, when someone questions a rule. `ADOPTING.md` stays with the kit and is
not copied, so guidance needed after adoption cannot live only there.

The `AGENTS.md` stanza tells every agent session to read the map before writing anything. Each word
in it is paid for by every session, and anything it shares with the files it describes is stated
twice in every adopting repository.

Prose cannot be symlinked, and the kit's specification, templates, map and notes repeat tables,
value lists and multi-step processes. Those repeats drift.

## Considered Options

- Embed instructions throughout the templates, as banners, comments and placeholder entries
- Move every instruction to `ADOPTING.md`
- Templates carry shape, the map carries every rule, `ADOPTING.md` carries the one-time procedure
- Route in the map, put each artefact's rules in that artefact, and keep the reasons in the kit
- Put rules and reasons in a separate shipped explanation file beside the map
- For shared content: keep §4.1 absolute and check every repeat; make the specification the
  normative source; make the templates the normative source; put the value sets in a shared
  machine-readable block; rely on review

## Decision Outcome

Chosen option: **route in the map, and let each artefact own its rules**, because each kind of
content is then read at the moment it is needed, and stated once in the adopter's repository.

- **The map** holds routing, the rules that span artefacts, and the test for adding a document.
- **Each artefact** holds its own format and rules, in its preamble or its `0000-template.md`.
  Templates carry shape and an example, with no commentary about the kit.
- **`ADOPTING.md`** holds the one-time procedure.
- **The reasons** stay in the kit's records and `ADOPTING-NOTES.md`. An adopting repository records
  its own reasons in an adoption decision record, shipped as a template, that cites the kit at a
  pinned commit.

For shared content, §4.1 is a guideline and the template is the home of an artefact's shape and
value sets: the specification cites the template, and the checker's value sets are tested against
it. Template/instance pairs and short instructional copies, such as the `AGENTS.md` stanza, may
repeat what they name. An advisory detector reports repeated structure rather than failing on it.

A decision record does not name the code it constrains; the comment beside the code names the
record, because code changes more often than records do.

Embedded instructions were rejected because every adopter pays to read and delete them, and they
duplicate `ADOPTING.md`. Moving everything to `ADOPTING.md` was rejected because it is not copied.
Giving the map every rule was rejected because it duplicates each artefact's format and makes every
session read all of it. A separate explanation file was rejected because its only reader is someone
questioning a rule, and the adoption record already serves that reader.

### Consequences

- Good, because the map an agent reads first is routing.
- Good, because each format is stated once in an adopter's repository, beside where it is used, so a
  correction lands once.
- Good, because an adopter's reasons for adopting, and for deviating, are a record the owner
  accepts.
- Bad, because the specification is less self-contained: a reader follows links into the templates.
- Bad, because a template change is a contract change, needing the specification and checker to
  follow.
- Bad, because the provenance of the loose conventions, such as Diátaxis and Standard Readme, is
  found only in the kit.

## Confirmation

`review`

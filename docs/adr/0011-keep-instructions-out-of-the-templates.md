---
status: "accepted"
date: 2026-08-20
decision-makers: David Conneely
---

# 11. Keep instructions out of the templates

## Context and Problem Statement

All figures here were measured at the time of writing.

An adopter copies 666 lines from `templates/`. Measuring where they go found that the template map
alone is 221 of them — a third of everything copied, and the adopter's entire ongoing reading
burden — while its own banner claims it is "short enough to be read often".

Two of its sections are waste on arrival. "What each capability adds" (21 lines) is scaffolding
`ADOPTING.md` Step 2 already tells the adopter to delete. "Prescribed formats" (32 lines) restates
shapes that now live in the template files beside it.

The pattern is general. Instructions are embedded throughout `templates/` as banners, HTML comments
and placeholder entries — 108 lines by a conservative count — and every adopter pays the cost of
reading and deleting them. Worse, the same guidance exists in `ADOPTING.md`, so it is duplication of
the kind `SPECIFICATION.md` §4.1 forbids, replicated into every adopting repository.

The constraint that shapes the answer: **`ADOPTING.md` is not copied.** It stays with the kit. So
guidance an adopter needs *after* adoption — what the statuses mean, what belongs in a section —
cannot be moved there. Only guidance used once, during adoption, can.

## Considered Options

* Leave instructions embedded in the templates
* Move all instructions to `ADOPTING.md`
* Split by when the instruction is needed: adoption-time to `ADOPTING.md`, use-time to the map

## Decision Outcome

Chosen option: **split by when the instruction is needed**, giving three owners:

- **Templates carry shape.** Headings, front-matter keys, an example entry. Enough that a reader
  can see what fills the file, with no meta-commentary about the kit.
- **The map carries rules.** Anything needed while *using* the structure, because the map is what
  the adopter keeps. This is where the ADR statuses, immutability and the human-action rule already
  went.
- **`ADOPTING.md` carries the one-time procedure.** Anything read once while adopting, including
  "what each capability adds", which moves out of the map entirely.

Moving everything to `ADOPTING.md` was rejected because it is not copied; use-time guidance would
leave the adopter's repository with it. Leaving things as they are was rejected because the cost is
paid by every adopter, forever, for text written once.

### Consequences

* Good, because the map gets materially smaller — the section that every adopter is told to delete
  stops being shipped at all, and the format skeletons stop being duplicated.
* Good, because templates become correct on arrival rather than after a deletion pass. Copying one
  and filling it in is the whole interaction.
* Good, because `SPECIFICATION.md` §2.5 — "the map MUST NOT retain the template banner" — becomes
  unnecessary. With no banner there is nothing to retain, and §2.3 and §2.4 already fail an
  uncustomised map, since it names artifacts the adopter does not have.
* Bad, because point-of-use guidance is genuinely useful, and some is lost. A person writing a
  record no longer has the status list in front of them. Mitigated by the front-matter comment,
  which is one line and stays.
* Neutral: `ADOPTING.md` grows. It is not copied, so its length costs the adopter reading time once
  rather than repository weight forever — a better place to carry the same words.

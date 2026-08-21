---
status: "accepted"
date: 2026-08-21
decision-makers: David Conneely
---

# 13. Adoption is fork-and-forget

## Context and Problem Statement

An adopter copies `templates/` and customises the map by deletion. Nothing connects their copy to
this repository afterwards, so an improvement made here never reaches them. ADR-0012 widened the
problem by vendoring the checker: a stale checker fails quietly, by not testing something newer,
rather than loudly.

Most of what is copied diverges immediately and by design. An adopter's `SPECIFICATION.md` describes
*their* system within an hour of being copied; their `CHANGELOG.md` and `PLAN.md` fill with their
own content. "Upgrading" those is meaningless — there is nothing to upgrade *to*.

A narrower part does not diverge. `ADOPTING.md` Step 2 tells adopters to keep the map's three rules,
its failure modes and its "adding a new kind of document" test **verbatim**, because they are the
same in every repository. Those, the `0000-template.md` files, and the checker are the only content
that stays comparable to the kit's after adoption — and they are the only content an upgrade path
could serve.

This repository has no adopters, so any mechanism built now would be designed against a guess.

## Considered Options

* Version-stamp copied artifacts and ship migration notes per release
* Publish the shared rules as a referenced file rather than copied text
* Declare adoption fork-and-forget, and treat the changelog as the upgrade path

## Decision Outcome

Chosen option: **fork-and-forget.** What an adopter copies is theirs. There is no version stamp, no
migration tooling, and no obligation to track this repository.

`CHANGELOG.md` is the whole mechanism. An adopter who wants to know what has changed reads it and
decides what, if anything, to apply by hand. That is a manual path, and it is proportionate: the
shared surface is a few dozen lines of rules plus a checker they can diff.

Version-stamping was rejected on two grounds. It would put this project's name and a version marker
inside every adopting repository's map — precisely the trailing obligation MIT-0 was chosen to
avoid. And it would imply a migration story the kit cannot honour, since a customised map cannot be
mechanically upgraded when customisation *is* deletion.

Referencing the shared rules instead of copying them was rejected because it makes an adopter's
documentation depend on this repository staying reachable. A map that cannot explain itself offline
is worse than one that is slightly out of date.

### Consequences

* Good, because it matches what the licence already says. MIT-0 hands the adopter the text with no
  strings; an upgrade path would have quietly reattached one.
* Good, because there is no machinery to build, version or maintain, and nothing here was going to
  be designed against real adopter behaviour anyway.
* Bad, because improvements to the shared rules will not propagate. Adopters keep whatever they took
  on the day they took it, including any mistake in it.
* Bad, because a vendored checker ages silently — it keeps passing while no longer testing what the
  current specification requires. `docs/testing.md` records this among the things not verified.
* Neutral: this can be revisited if the kit ever acquires adopters who ask for it. Deciding *not* to
  build a mechanism is cheap to reverse; building the wrong one is not.

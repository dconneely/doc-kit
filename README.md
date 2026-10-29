# doc-kit

A documentation structure for a repository that one person directs and many agent sessions write.

Each agent session starts with no memory of the last. It learns what the owner wants from what is
written down, and it writes more. Left alone, that text accumulates: documents restating each other,
contradicting each other, describing code that has since changed. A new session cannot tell the
current text from the stale, so it trusts all of it.

The kit is a small set of documents organised by three properties - **tense**, **mutability** and
**audience** - with rules for where each fact goes, when it is deleted, and who may change what.
**The owner decides; every other contributor, agent or human, proposes.** It also carries a
procedure for migrating documentation that has already accumulated.

## What it is for

Facts the code cannot tell you: why something is as it is, what is deliberately wrong, what is out
of scope, what can no longer be dated. Behaviour you can establish by reading the source is better
established that way.

It is a write discipline more than a reference. The question it answers most often is "where does
this go?", asked while something is being written down - which is when sprawl is cheapest to
prevent.

That question is mostly asked by coding agents, which produce documentation readily and sprawl by
default: three files restating one thing, nothing ever deleted. A structure that says where a fact
belongs, and when it is deleted, constrains generation in a way that "write good docs" does not.
What it will not do is make a repository legible to an agent through sheer volume - an agent reads
code faster than prose, and a stale document is more dangerous to one than to a sceptical human.

**If your project's constraints fit on one page, write that page instead.** A tight `AGENTS.md` or
an honest `README.md` beats this structure until there is more to say than fits in it.

## What's here

| Path                | What it is                                                                     |
| ------------------- | ------------------------------------------------------------------------------ |
| `ADOPTING.md`       | Product - the procedure: decide, inventory, customise, create, migrate, verify |
| `ADOPTING-NOTES.md` | Product - the reasoning, for when the procedure will not settle a case         |
| `templates/`        | Product - copy into the target repository and customise by deletion            |
| `docs/spec.md`      | What a conformant repository looks like - the contract a checker enforces      |
| `DOC-MAP.md`        | This repository's own map, produced by applying the kit to itself              |
| `docs/decisions/`   | Why the kit is shaped this way                                                 |
| `tools/`            | An optional conformance checker and decision-index generator                   |

**This repository is an adopted instance of itself.** Its map, specification, plan, records and
research notes are what the structure looks like in use, rather than what it looks like on a
template - browse them before deciding whether you want it.

## Using it

Read [`ADOPTING.md`](ADOPTING.md) and start at Step 0. Step 0 ends by writing a `docs/plan.md`
containing the rest of the work, which is deliberate: adoption on a mature repository is not an
afternoon, and the plan is what lets you stop and resume.

Copying is manual - take the members of `templates/` you need to your repository root, using the
table in Step 3, and work through Steps 0-5 in order. There is no installer, because the kit ships
text.

### Driving it with an agent

Clone this repository alongside the one you are adopting into.

If the target has no agent instructions of its own, start the agent **here** and point it at the
target:

```text
apply this kit to ../my-cool-repo/
```

The `doc-kit-adopt` skill reads the target's instruction files first, follows `ADOPTING.md`, writes
only into the target, and stops for approval once the Step 4 inventory exists.

If the target has its own `AGENTS.md`, `CLAUDE.md` or other agent instructions, adopt in two parts:

1. **Plan here.** Start the agent in this repository and point it at the target. It reads the
   target's instruction files, follows `ADOPTING.md` Steps 0-4a, and stops at the inventory.
2. **Execute there.** Review the dispositions, then start the agent in the target repository. Its
   instructions load automatically. Point it at this kit's `ADOPTING.md` and
   `.agents/skills/doc-kit-adopt/SKILL.md`, and tell it to finish Steps 4b-5.

If your tool does not list `doc-kit-adopt`, read `.agents/skills/doc-kit-adopt/SKILL.md` directly;
the procedure is the same.

End the session when adoption completes. Further work on that repository belongs in that
repository - the `AGENTS.md` stanza installed during Step 3 carries the ongoing rules, and this kit
is not needed again.

## What it costs

An afternoon for Steps 0-3 on any repository. Step 4 - migrating what already exists - proceeds one
document at a time and has no end date. A partly-migrated repository with an honest map is already
better than an unmigrated one, which is the property the whole design optimises for.

Below a certain size it is not worth it at all. Step 0 says how to tell.

## Licence

[MIT No Attribution](LICENCE). Copy any of this into your repository and own it - there is no notice
to preserve and nothing to attribute. That is deliberate: a kit whose product is text you are meant
to edit should not follow you home.

## Status

Released, and still early. In use here and in some other repositories owned by the author - the
situation the kit is designed for (ADR-0001). See `CHANGELOG.md` for what shipped and `docs/plan.md`
for what is still open.

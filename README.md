# doc-kit

A documentation structure you can add to a project that already exists.

Most documentation advice assumes a blank repository. This assumes the opposite: a codebase with a
decade of history, a `docs/` folder nobody trusts, three files that are part changelog and part
backlog, and decisions that survive only as comments above the code they explain.

The kit is a small set of documents organised by three properties — **tense**, **mutability** and
**audience** — plus the procedure for migrating existing material into them.

## What it is for

Facts the code cannot tell you: why something is as it is, what is deliberately wrong, what is out
of scope, what can no longer be dated. Behaviour you can establish by reading the source is better
established that way.

It is a write discipline more than a reference. The question it answers most often is "where does
this go?", asked while something is being written down — which is when sprawl is cheapest to
prevent.

That question is increasingly asked by coding agents, which produce documentation readily and sprawl
by default: three files restating one thing, nothing ever deleted. A structure that says where a
fact belongs, and when it is deleted, constrains generation in a way that "write good docs" does
not. What it will not do is make a repository legible to an agent through sheer volume — an agent
reads code faster than prose, and a stale document is more dangerous to one than to a sceptical
human.

**If your project's constraints fit on one page, write that page instead.** A tight `AGENTS.md` or
an honest `README.md` beats this structure until there is more to say than fits in it.

## What's here

| Path | What it is |
|---|---|
| `ADOPTING.md` | Product — the procedure: decide, inventory, customise, create, migrate, verify |
| `ADOPTING-NOTES.md` | Product — the reasoning, for when the procedure will not settle a case |
| `templates/` | Product — copy into the target repository and customise by deletion |
| `SPECIFICATION.md` | What a conformant repository looks like — the contract a checker enforces |
| `DOCUMENTATION.md` | This repository's own map, produced by applying the kit to itself |
| `docs/adr/` | Why the kit is shaped this way |

## Using it

Read [`ADOPTING.md`](ADOPTING.md) and start at Step 0. It ends with a `PLAN.md` containing the rest
of the work, which is deliberate: adoption on a mature repository is not an afternoon, and the plan
is what lets you stop and resume.

Copying is manual — take the members of `templates/` you need to your repository root, following the
table in Step 3, then work Steps 1–5. There is no installer, because the kit ships text.

### Driving it with an agent

Clone this repository alongside the one you are adopting into, start the agent **here**, and point
it at the target:

```
apply this kit to ../my-cool-repo/
```

The `doc-kit-adopt` skill takes it from there: it follows `ADOPTING.md`, writes only into the
target, stops for approval once the Step 4 inventory exists, and resumes from
`../my-cool-repo/docs/tasks/adopt-doc-kit.md` if a previous session left one.

End the session when adoption completes. Further work on that repository belongs in that
repository — the `AGENTS.md` stanza installed during Step 3 carries the ongoing rules, and this kit
is not needed again.

## What it costs

An afternoon for Steps 0–3 on any repository. Step 4 — migrating what already exists — proceeds one
document at a time and has no end date. A partly-migrated repository with an honest map is already
better than an unmigrated one, which is the property the whole design optimises for.

Below a certain size it is not worth it at all. Step 0 says how to tell.

## Licence

[MIT No Attribution](LICENCE). Copy any of this into your repository and own it — there is no notice
to preserve and nothing to attribute. That is deliberate: a kit whose product is text you are meant
to edit should not follow you home.

## Status

Early. The structure and the procedure are settled and in use; the tooling around them is not built
yet. See `PLAN.md` for what is missing and `CHANGELOG.md` for what has changed.

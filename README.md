# doc-kit

A documentation structure you can add to a project that already exists.

Most documentation advice assumes a blank repository. This assumes the opposite: a codebase with a
decade of history, a `docs/` folder nobody trusts, three files that are part changelog and part
backlog, and decisions that survive only as comments above the code they explain.

The kit is a small set of documents organised by three properties — **tense**, **mutability** and
**audience** — plus the procedure for migrating existing material into them.

## What's here

| Path | What it is |
|---|---|
| `templates/` | The product. Copy into the target repository and customise by deletion |
| `ADOPTING.md` | The procedure: decide, inventory, customise, create, migrate, verify |
| `SPECIFICATION.md` | What a conformant repository looks like — the contract a checker enforces |
| `DOCUMENTATION.md` | This repository's own map, produced by applying the kit to itself |
| `docs/adr/` | Why the kit is shaped this way |

## Using it

Read `ADOPTING.md` and start at Step 0. It ends with a `PLAN.md` containing the rest of the work,
which is deliberate: adoption on a mature repository is not an afternoon, and the plan is what lets
you stop and resume.

Copying is currently manual — copy the members of `templates/` you need to the repository root, then
follow Steps 1–5. An install script is a plan entry, not a promise.

## What it costs

An afternoon for Steps 0–3 on any repository. Step 4 — migrating what already exists — proceeds one
document at a time and has no end date. A partly-migrated repository with an honest map is already
better than an unmigrated one, which is the property the whole design optimises for.

Below a certain size it is not worth it at all. Step 0 says how to tell.

## Status

Early. The structure and the procedure are settled and in use; the tooling around them is not built
yet. See `PLAN.md` for what is missing and `CHANGELOG.md` for what has changed.

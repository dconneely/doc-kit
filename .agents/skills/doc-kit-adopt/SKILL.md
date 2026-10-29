---
name: doc-kit-adopt
description: Apply doc-kit's documentation structure to another repository, or resume an adoption already in progress. Use when asked to adopt, install, or apply this kit to a target repository, or to continue one already started.
---

# Applying doc-kit to another repository

Find both repositories before anything else: this kit's path, and the target's. The skill may run
from either. The target is elsewhere, given as a path - `../my-cool-repo/` or similar. Ask for it if
not supplied.

## Before anything else

**Every file you touch belongs to the target repository.** Nothing in doc-kit itself changes during
an adoption - not its map, plan, or changelog. Editing a path outside the target means you're
damaging the kit, not adopting it.

**Read the target's instruction files before any edit.** That means `AGENTS.md`, `CLAUDE.md`,
`.github/copilot-instructions.md`, `.github/instructions/*.instructions.md`, and any similar file,
including nested `AGENTS.md` files. They are binding for the target. doc-kit's own `AGENTS.md`
describes _this_ repository, not the target - it doesn't apply there. If the target's rules conflict
with `ADOPTING.md`, ask the owner; do not choose silently.

Check the target's `git status` first. Anything already uncommitted there isn't yours - note it and
keep it separate from what you touch, so it isn't swept into a summary or a blanket `git add -A`. A
person would notice a dirty working tree unprompted; an agent needs telling.

## The procedure

`ADOPTING.md` is the procedure - read it and follow Steps 0-5 in order. Don't work from memory of
it, and don't restate it to the user instead of doing it. `ADOPTING-NOTES.md` has the judgement
calls for cases that won't settle.

Template content comes from `templates/`, which maps onto the target's root at the same relative
path; Step 3 says what to take and when.

The README's "Driving it with an agent" section has a short entry prompt. If a user gives it to you,
treat it as a pointer to this procedure and `ADOPTING.md`, not as a separate specification.

### Two parts when the target has its own instructions

1. **Part 1, in doc-kit.** Steps 0-4a. Read the target's instruction files first and follow them for
   every write. Produce the plan, the customised map, the documents it promises, and the migration
   inventory with proposed dispositions. The plan and worksheet are the handoff, so write them into
   the target. Present the inventory and stop.
2. **Part 2, in the target.** Start a session rooted in the target, so its `AGENTS.md`/`CLAUDE.md`
   load automatically. Read the kit's `ADOPTING.md` and this skill from the kit path. Execute the
   approved dispositions, finish Step 4 and run Step 5.

If the target has no instruction files of its own, one session may do both. The rule is the same:
read what exists, and follow it. If the session is already rooted in the target, its instruction
files are already loaded; it may do both parts in one session, with the same gate.

## The gate

**Step 4a produces an inventory. Present it and stop.**

Don't move, split, absorb, archive, or delete anything until the owner has reviewed the
dispositions. On a mature repository this is the only point where a mistake is cheap - after this,
it's a commit to undo and the reasoning behind it is gone.

A hard stop, not a checkpoint to mention in passing. It is also the handoff between Part 1 and Part
2 when the target has its own instructions.

## Resuming

Real adoptions span weeks and get interrupted. Before starting, check whether
`<target>/docs/plan/adopt-doc-kit.md` already exists:

- **It exists** - under way. Read it, work the unfinished rows, keep it current. Don't restart from
  Step 0.
- **It doesn't** - if the target has an older doc-kit shape, use the re-adoption note below;
  otherwise a fresh adoption starts at Step 0. In Part 2, the handoff failed: stop and return to
  Part 1; do not start over.

### Re-adopting an earlier version

A missing worksheet does not prove the target is empty. If it has a root `SPECIFICATION.md` or
`PLAN.md`, `docs/adr/` or `docs/tasks/`, or a `DOC-MAP.md` written before the current version, treat
it as a re-adoption, not a fresh Step 0. Inventory the existing documents; treat the old map, plan,
specification, ADRs and instruction files as inputs to move and merge; read the kit's `CHANGELOG.md`
from the target's adopted version through the current one; write the worksheet; stop at the
inventory. Do not copy templates over the custom map or recreate the plan or specification.

The worksheet _is_ the state. Keeping it accurate matters more than speed - the next session has
nothing else to go on.

## Finishing

Run the checker against the target:

```sh
cd <target> && sh <path-to-doc-kit>/tools/doc-kit-check.sh
```

It resolves the map relative to the working directory, so run it from the target's root.

Tell the user the adoption is complete, and that **further work belongs in the target repository**,
not here. The `AGENTS.md` stanza installed in Step 3 carries the ongoing rules; this skill doesn't,
and is now finished.

Delete `docs/plan/adopt-doc-kit.md` from the target once its contents are emptied into their proper
homes - check first that nothing in it is the last surviving record of a decision or a finding.

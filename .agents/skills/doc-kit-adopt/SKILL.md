---
name: doc-kit-adopt
description: Apply doc-kit's documentation structure to another repository, or resume an adoption already in progress. Use when asked to adopt, install, or apply this kit to a target repository, or to continue one already started.
---

# Applying doc-kit to another repository

You're running inside **doc-kit**. The target repository is elsewhere, given as a path -
`../my-cool-repo/` or similar. Ask for it if not supplied.

## Before anything else

**Every file you touch belongs to the target repository.** Nothing in doc-kit itself changes during
an adoption - not its map, plan, or changelog. Editing a path outside the target means you're
damaging the kit, not adopting it.

doc-kit's own `AGENTS.md` describes *this* repository, not the target - it doesn't apply there.

Check the target's `git status` first. Anything already uncommitted there isn't yours - note it and
keep it separate from what you touch, so it isn't swept into a summary or a blanket `git add -A`. A
person would notice a dirty working tree unprompted; an agent needs telling.

## The procedure

`ADOPTING.md` is the procedure - read it and follow Steps 0-5 in order. Don't work from memory of
it, and don't restate it to the user instead of doing it. `ADOPTING-NOTES.md` has the judgement
calls for cases that won't settle.

Template content comes from `templates/`, which maps onto the target's root at the same relative
path; Step 3 says what to take and when.

## The gate

**Step 4a produces an inventory. Present it and stop.**

Don't move, split, absorb, archive, or delete anything until a person has reviewed the dispositions.
On a mature repository this is the only point where a mistake is cheap - after this, it's a commit
to undo and the reasoning behind it is gone.

A hard stop, not a checkpoint to mention in passing.

## Resuming

Real adoptions span weeks and get interrupted. Before starting, check whether
`<target>/docs/tasks/adopt-doc-kit.md` already exists:

- **It exists** - under way. Read it, work the unfinished rows, keep it current. Don't restart from
  Step 0.
- **It doesn't** - a fresh adoption. Start at Step 0.

The worksheet *is* the state. Keeping it accurate matters more than speed - the next session has
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

Delete `docs/tasks/adopt-doc-kit.md` from the target once its contents are emptied into their proper
homes - check first that nothing in it is the last surviving record of a decision or a finding.

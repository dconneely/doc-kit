---
name: doc-kit-adopt
description: Apply the doc-kit documentation structure to another repository, or resume a migration already in progress. Use when asked to adopt, install or apply this kit to a target repository, or when asked to continue an adoption started earlier.
---

# Applying doc-kit to another repository

You are running inside **doc-kit**. The repository being adopted is somewhere else, given as a path
— `../my-cool-repo/` or similar. Ask for it if it was not supplied.

## Before anything else

**Every file you create or modify belongs to the target repository.** Nothing in doc-kit changes
during an adoption — not its map, not its plan, not its changelog. If you find yourself editing a
path that is not under the target, stop: you are about to damage the kit instead of adopting it.

doc-kit's own `AGENTS.md` is loaded and describes *this* repository. It does not apply to the
target.

Check the target's `git status` before making any changes. Anything already uncommitted there is
not yours — note it, and keep it separate from what you touch, so it doesn't get silently swept
into a later summary or an accidental blanket `git add -A`. A person doing this by hand would
notice a dirty working tree without being told; it is stated here because nothing else prompts an
agent to check first.

## The procedure

`ADOPTING.md` is the procedure. Read it and follow Steps 0–5 in order — do not work from memory of
it, and do not restate it back to the user in place of doing it. `ADOPTING-NOTES.md` has the
judgement calls if a case will not settle.

Take template content from `templates/`, which maps onto the target's root at the same relative
path. Step 3 says which files to take and when.

## The gate

**Step 4a produces an inventory. Present it and stop.**

Do not move, split, absorb, archive or delete anything until a person has reviewed the dispositions.
On a mature repository this is the only point where a mistake is cheap — afterwards it is a commit
to undo, and the reasoning that produced it is gone.

This is a hard stop, not a checkpoint to note in passing.

## Resuming

Adoption on a real repository spans weeks and gets interrupted. Before starting, check whether
`<target>/docs/tasks/adopt-doc-kit.md` already exists:

- **It exists** — the migration is under way. Read it, work the unfinished rows, and keep it
  current as you go. Do not restart from Step 0.
- **It does not** — this is a fresh adoption. Start at Step 0.

The worksheet is the state. Keeping it accurate matters more than working quickly, because the next
session has nothing else to go on.

## Finishing

Run the checker against the target:

```sh
cd <target> && sh <path-to-doc-kit>/tools/doc-kit-check.sh
```

It resolves the map relative to the working directory, so it must run from the target's root.

Then tell the user the adoption is complete and that **further work on the target belongs in that
repository**, not here. The `AGENTS.md` stanza installed during Step 3 carries the ongoing rules;
this skill does not, and is finished.

Delete `docs/tasks/adopt-doc-kit.md` from the target once its contents have been emptied into their
proper homes — and check that nothing in it is the last surviving record of a decision or a finding.

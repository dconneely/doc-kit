# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

### Write the conformance checker

*Type: feature — Importance: high — Effort: medium*

`SPECIFICATION.md` §6 defines structural conformance as mechanically checkable and nothing checks
it. A standalone CLI, run by hand, per ADR-0007 — never a condition of adopting the structure. Start
with the two rules that rot, §2.3 and §2.4: every artifact the map names exists, every documentation
file appears in the map. Then ADR integrity (§3.1) and the plan graveyard (§3.3). Checks must be
individually selectable, since a repository with no research notes should not be told about research
notes. Exclude `templates/` by default per §2.8, or any repository distributing the kit fails on its
own templates. This repository is the first consumer, which is the real test of whether the failure
messages mean anything to someone who has not read it.

Likely a POSIX shell script: no runtime to install, invoked identically by CI and by hand, and —
because it executes inside someone else's repository — short enough that they can read it before
trusting it. Two caveats to settle when starting. Take the artifact set from the artifacts table per
§2.2 — its first cell is a backticked full path, where the layout block is an indented tree needing
reconstruction. And decide the Windows story deliberately, since `sh` needs Git Bash or WSL and
will not run from PowerShell unqualified — this project's own
author is on Windows, and a maintainer with a second-class path to the checker is how dogfooding
stops happening. `identigon` found that `prek`'s Node hooks install cross-platform including
Windows while its Ruby ones do not, which is worth knowing if a runtime is chosen after all.

### Decide whether the checker ships, and how

*Type: feature — Importance: medium — Effort: medium*

Deliberately deferred by ADR-0007 until a working tool exists. The options — a pre-commit hook
provider, a CI action, a packaged CLI, a plain vendored script, or shipping nothing and leaving
adopters to write their own — differ mainly in ecosystem assumptions, and picking one blind commits
the kit to somebody else's toolchain. Two findings to carry in: repository-wide invariants such as
§2.3 and §2.4 suit a merge check better than a commit hook, because a migration spends weeks in
intermediate states the kit explicitly permits; and the one rule visible only in a diff, edits to an
accepted record, needs diff access rather than any particular mechanism, which a pull request's base
diff also provides.

### Provide an install mechanism

*Type: feature — Importance: high — Effort: low*

Copying is manual and undocumented beyond a sentence in the README. Decide between a script, a
`degit`-style fetch, and documented manual steps, and write down which artifacts an adopter takes.
This is where ADR-0006's deferred question gets answered: whether the adopter also receives a pinned
copy of `ADOPTING.md`, given that a migration into a mature repository spans weeks and the procedure
should not shift underneath them.

Splitting the guide made that question two questions, which is the more useful finding.
`ADOPTING.md` is genuinely one-time — once the structure exists, the procedure is spent, and the map
carries the rules an adopter needs afterwards. `ADOPTING-NOTES.md` is not: "is this a bug or a
decision?" and "I cannot decide which file this belongs in" recur for as long as the repository
lives, and an adopter has no local copy of the answers. Against copying it: 164 lines of added
weight, staleness the moment the kit improves, and three links into `docs/adr/` that resolve only
here. Weigh those before assuming the answer is the same for both files.

### Add a licence

*Type: docs — Importance: high — Effort: low*

A kit meant to be copied into other repositories without a licence is unusable by anyone careful.

### Check links

*Type: feature — Importance: medium — Effort: low*

The map and the specification link heavily to external standards, and those rot silently. A link
checker in CI — nightly rather than per-commit, since external hosts fail for reasons unrelated to
the change under review. Keep the boundary with the conformance checker explicit: that one verifies
the map against the filesystem, this one verifies that URLs resolve. Overlap is only on internal
links, and those belong to the conformance checker.

### Lint commit messages

*Type: feature — Importance: low — Effort: low*

`commitlint` on a `commit-msg` hook, enforcing Conventional Commits. Worth doing only once the type
mapping is written down somewhere enforceable: product changes — `ADOPTING.md`, `templates/`, the
checker, the installer — take `feat`/`fix`/`refactor`, while this repository's own documentation
takes `docs`. Without that rule a documentation kit types every commit `docs` and the history stops
carrying information.

### Restate who `docs/quirks.md` is for

*Type: docs — Importance: medium — Effort: low*

The artifacts table gives its audience as "users comparing against a reference", which was right and
is now half the story: its highest-value reader is a coding agent about to delete a workaround it
has mistaken for a defect. Say so in the template's audience column and in the file's own preamble.
While there, make entries greppable — consistent field labels, one per line — so an agent scanning
for a symbol finds the entry that governs it rather than having to read the file. The same argument
applies more weakly to ADRs recording a constraint, which is worth a sentence in the map but not a
format change.

### Write the adoption skill

*Type: feature — Importance: medium — Effort: medium*

Most adoptions of this kit into a mature repository will be executed by an agent. That needs the
imperative procedure, an inventory output for approval before any file is modified, and resumable
state. Blocked on the `ADOPTING.md` split and the inventory format.

### Decide the template upgrade path

*Type: feature — Importance: medium — Effort: high*

An adopter copies the map and then customises it by deletion, so there is no way to take a later
improvement. Either version-stamp copied artifacts and ship migration notes per release, or state
explicitly that adoption is fork-and-forget. The second is a legitimate answer and should be chosen
deliberately rather than by omission. Scope is now narrower than it was: ADR-0007 gives checks a
working upgrade path via `rev`, so this entry covers only the copied prose artifacts.

### Write `docs/testing.md`

*Type: docs — Importance: medium — Effort: low*

Earned as soon as the checker exists: what it verifies exactly, what it verifies approximately, and
what is deliberately left to review — §4 substantive conformance in particular. Blocked on the
checker.

### Build a worked example

*Type: docs — Importance: low — Effort: high*

A small repository with realistic messy documentation, before and after. For a method this dependent
on judgement, one worked migration teaches more than another page of troubleshooting. Expensive, and
it can wait until the procedure has stopped moving.

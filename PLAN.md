# Plan

Single ranked backlog. Entries are deleted when done, never annotated.

### Ship an agent entry-point stanza

*Type: feature — Importance: high — Effort: low*

The structure's value to a coding agent concentrates in three things: knowing which document to
trust when they conflict, knowing not to "fix" anything in `docs/quirks.md` or contradict a
constraint recorded in an ADR, and knowing which files are safe to delete. None of it is reachable
today, because agents read `AGENTS.md` or `CLAUDE.md` and nothing points from there to the map. A
dozen lines naming the trust ordering — specification is current and authoritative, changelog is
past, plan is intent and describes nothing that exists — would collect most of the available value.
Ship it as a snippet to paste, not a file: `AGENTS.md` is exactly the colliding case ADR-0007
describes. Keep it short, because it competes with code for the agent's context.

### Split `ADOPTING.md` into a procedure and its rationale

*Type: docs — Importance: high — Effort: medium*

One file currently serves a reader deciding whether to adopt and a reader executing the migration.
The executing reader needs about 120 of its 300 lines: ordered steps, preconditions, stop
conditions, an output contract, and an approval gate before anything is modified. The deciding
reader needs the judgement calls and the troubleshooting. Progressive disclosure — a short procedure
linking outward — rather than deeper headings.

### Decide which list of artifacts is authoritative

*Type: bug — Importance: high — Effort: low*

The map names its artifacts three times — the Layout block, the artifacts table and the lifecycle
table — and `SPECIFICATION.md` §2.2 only requires the latter two to agree. They already disagree in
this repository: `DOCUMENTATION.md:48` gives `adr/0001-*.md` where lines 65 and 79 give
`docs/adr/*.md`. Make the Layout block authoritative and machine-readable, since it is the only one
already shaped like data, and extend §2.2 to require all three to agree. Blocks the checker, which
cannot compare anything until it knows what to compare against.

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
trusting it. Two caveats to settle when starting. Parse the Layout block rather than the prose
tables; it is the only part already shaped like data. And decide the Windows story deliberately,
since `sh` needs Git Bash or WSL and will not run from PowerShell unqualified — this project's own
author is on Windows, and a maintainer with a second-class path to the checker is how dogfooding
stops happening.

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

### Add a licence

*Type: docs — Importance: high — Effort: low*

A kit meant to be copied into other repositories without a licence is unusable by anyone careful.

### Add pre-commit hooks for file hygiene and secret scanning

*Type: feature — Importance: medium — Effort: low*

Adopt the `pre-commit` framework with the standard hygiene set — trailing whitespace, end-of-file
newline, merge-conflict markers, large files — plus `gitleaks` for secrets. `.gitattributes` already
pins line endings, so `mixed-line-ending` is a guard against it being weakened rather than the fix.
Configure `trailing-whitespace` with `--markdown-linebreak-ext=md`: two trailing spaces are a hard
line break in Markdown, and the default hook silently eats them across a repository that is entirely
prose. Note that `pre-commit` needs Python, which is a dependency the kit does not otherwise have;
if that is unacceptable, decide the alternative here rather than in the CI entry.

### Lint Markdown

*Type: feature — Importance: medium — Effort: low*

`markdownlint` over a repository that is entirely Markdown. Two decisions to make rather than
default through: whether to enforce the ~100-column wrap the prose already follows, and how to treat
`templates/`, whose deliberate placeholder headings and unfilled sections will trip rules that are
correct everywhere else. Add `codespell` alongside it, configured for British spelling — `customise`
and `behaviour` run throughout and a default dictionary will fight them.

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

### Move the format skeletons out of the map

*Type: docs — Importance: medium — Effort: low*

The map restates the ADR skeleton inline, which every adopter then copies into their own map;
`templates/docs/adr/0000-template.md` now holds the same shape. The map should link and keep only
what the file cannot express. Same reconciliation is due for the research confidence levels and the
quirk entry shape, which the template files define and the map's "prescribed formats" section does
not yet mention — do all three together rather than adding a fourth duplicate first. Noted as a
consequence in ADR-0004; no longer blocked.

### Reconcile the judgement calls in `ADOPTING.md` against the ADRs

*Type: docs — Importance: medium — Effort: low*

ADR-0002 and ADR-0003 now record decisions that `ADOPTING.md` also argues at length, so the same
fact lives in two places. The ADRs keep the alternatives and consequences; the guide keeps the
adopter-facing answer and links. Known violation of `SPECIFICATION.md` §4.1, recorded rather than
hidden.

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

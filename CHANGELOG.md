# Changelog

All notable changes to this project are documented here, following
[Keep a Changelog](https://keepachangelog.com) and [Semantic Versioning](https://semver.org).

## Unreleased

### Added

- `ADOPTING-NOTES.md` now answers the objection that deleting completed `PLAN.md` entries erases
  engineering history — `git log` already preserves it; a hand-kept "done" log would only rot.
- `templates/docs/tasks/README.md` now says what makes a task note worth keeping — a specific
  definition of done and a line of risk — rather than staying silent on quality now that "no fixed
  shape" is settled. Offers a starting shape (`Status:` line, numbered steps, a "Definition of done"
  section, a "Risk note" section) as one way to satisfy that, not a rule: two task notes written
  independently, in two separate adoptions of this kit, converged on it unprompted.
- `ADOPTING.md` Step 3 now says wording brevity in a repository's own `AGENTS.md`/`CLAUDE.md` is a
  second pass, separate from and after cutting content a session could derive from the codebase —
  the same true, non-derivable fact can usually still be said in fewer words without losing it. The
  paste-in stanza itself is also tighter (~140 → ~105 words), since it's the part that actually
  ships into every adopter's repository.
- The `doc-kit-adopt` skill's own text is tighter (~550 → ~475 words), with no step, hazard, or
  gate cut — same treatment as the stanza, since it's the other piece of this kit an agent reads and
  acts on rather than a human skimming it.
- `ADOPTING.md`'s "The idea, and why it shapes the procedure" section, and its "spec is a tree"
  bullet in Step 1, moved their rationale into `ADOPTING-NOTES.md` instead of restating it —
  matching the how-to/explanation split the two files already claimed to have. `ADOPTING.md` is
  lighter; nothing that was said is gone, it's just in the file whose job is to say it. One
  correctness hazard stayed behind in Step 2's "Layout block" row rather than moving with the rest:
  a nested directory's introducing line must be bare or the checker misreads it as a single leaf
  artifact — that's a mistake made *while executing* the step, not background reasoning, so it
  needed to survive without a trip to `ADOPTING-NOTES.md`.
- `ADOPTING-NOTES.md` now answers whether a `docs/tasks/*.md` file with no matching `PLAN.md` entry
  should be flagged: no, tooling here would fight the same "no standard" call that keeps the
  directory otherwise unchecked — with the by-hand fix for either direction of mismatch spelled out
  instead.

## [0.2.0] - 2026-08-22

### Added

- A gitignored documentation file is still checked against the map, but a hit in one is reported as
  advisory and never blocks the checker's exit status (ADR-0014).
- `ADOPTING-NOTES.md` now has a judgement call for a documentation file found already gitignored
  during inventory: ask before changing its status, rather than silently tracking or silently
  leaving it be — both defaults are wrong often enough to matter.
- Step 4c #2 now says to look for undocumented decisions in the specification's own prose, not only
  in code comments — most of this kit's own extracted ADRs turned out to come from the former.
- `ADOPTING.md`/`ADOPTING-NOTES.md` no longer default a multi-module repository to per-module docs.
  It's a decision to make deliberately — usually repo-wide is right, but not always — offering the
  existing structure as evidence rather than letting it silently decide, and it's usually worth its
  own ADR once made.
- "If coding agents work in this repository" now covers finding `AGENTS.md`/`CLAUDE.md` already
  present (ask before editing; never treat one as a stale duplicate of the other without asking —
  they may genuinely serve different audiences), not just the case where neither exists yet, and
  says to flag either file turning out to be untracked by git. The same section now also says to
  check for other per-tool instruction files (Copilot's, or similar) and ask rather than deciding
  on their fate unprompted — the intent is to improve the documentation, not replace instructions
  the user already wrote for a tool of their choosing.
- The `doc-kit-adopt` skill now says to check the target's `git status` before making any changes,
  and to keep anything already dirty there separate from what the adoption itself touches.
- The paste-in `AGENTS.md` stanza's ADR rule now also says to leave `decision-makers` as the
  template's placeholder on a drafted record, not just to leave `status` alone.
- `.markdownlint-cli2.jsonc` now runs the full default ruleset instead of just `MD013` — running
  this kit's own linter at "default: false" could not have caught the templates tripping an
  adopter's default config, which is how MD036 and MD049 were actually found.

### Changed

- The `doc-kit-adopt` skill moved from `.claude/skills/` to `.agents/skills/` — recognised by
  Claude Code exactly as before, and consistent with treating root `AGENTS.md` as the canonical,
  cross-tool agent-instructions surface rather than a Claude-specific one (ADR-0015).
- `templates/DOC-MAP.md` now documents the **Alias** shape directly — a file whose entire content
  points at another artifact (a second `README.md`, a spec member repeated per module) — and points
  to it from "Adding a new kind of document", instead of only being implemented in the checker with
  no explanation reachable by an adopter.
- `ADOPTING.md`'s "Is the specification one file or a tree?" now says a grown specification tree
  needs its own `DOC-MAP.md`-style routing table, and that each member still has to clear the same
  tense/mutability/audience test as a top-level artifact — splitting by topic or file size alone
  isn't sufficient grounds for two members to stay separate.
- A grown specification tree's members belong under `docs/spec/`, the same way decisions live under
  `docs/adr/` — a directory a `docs/spec/*.md` glob answers "is this the contract" from.
  `SPECIFICATION.md` itself stays at the root, changing role (index) rather than location.
- `tools/doc-kit-check.sh`'s layout-block parser now follows genuine multi-level nesting via an
  indentation-keyed prefix stack, not just one flat level under the repository root — `docs/spec/`
  (or any other nested directory) can be written nested in the fenced layout diagram as it actually
  sits on disk, rather than as a workaround second top-level block.
- `SPECIFICATION.md` §3.1 now permits formatting-only edits to an `accepted` record — whitespace,
  list markers, other rendering-only tokens that change no word — alongside `status`, `date` and
  `decision-makers` (ADR-0016). Immutability protects a record's substance, not its bullet
  character.

### Fixed

- The plan-entry and research-note metadata line (`*Type: ...*`, `**Confidence: ...**`) was a
  whole-line emphasis block with no other content — exactly what MD036 exists to catch in a
  project running its own markdownlint. It's now a bold label on plain text (`**Type:** ...`),
  matching the style `docs/quirks.md` already used.
- Plan and quirks entries used `###` directly under the file's `#` title, skipping `##` — fixed to
  `##` so the outline increments by one level at a time (MD001).
- A handful of one-off formatting issues an adopter's default markdownlint config would catch:
  a double blank line in `ADOPTING.md`, a list missing its surrounding blank line in a research
  note, an unlabelled fenced code block in `README.md`, and inconsistent Markdown table pipe
  spacing across several files.
- Four already-accepted ADRs (0003, 0006, 0008, 0011) mixed `-` and `*` list markers within a
  single file; normalised to `*` throughout, matching the ADR template (ADR-0016 permits this as a
  formatting-only edit).

## [0.1.0] - 2026-08-22

Nothing had been released before this, so everything below is an addition — including the several
things that replaced an earlier shape, which are recorded here as the shape that shipped.

### Added

- A licence: [MIT No Attribution](LICENCE). Copy anything here and own it — no notice to preserve,
  nothing to attribute, and no upgrade path to track (ADR-0013).
- `templates/`, holding a starter for every artifact the map promises, so Step 3 is a copy rather
  than a writing exercise. It is the product and source of truth; the root `DOC-MAP.md` is
  this repository's own map, produced by applying the kit to itself (ADR-0004, ADR-0006).
- `SPECIFICATION.md`, defining what a conformant repository looks like, and stating the conventions
  the kit had relied on without writing down: research confidence levels, plan scales, quirk shape.
- `ADOPTING.md`, the procedure — decide, inventory, customise, create, migrate, verify — with
  `ADOPTING-NOTES.md` carrying the judgement calls and troubleshooting behind it.
- Step 0: decide whether to adopt at all, and write the plan before anything else.
- A Step 4 inventory phase with six dispositions — move, split, absorb, archive, delete, leave —
  and a worksheet that makes an interrupted migration resumable.
- `tools/doc-kit-check.sh`, an optional conformance checker, vendored rather than referenced so an
  adopter's copy matches the structure they adopted (ADR-0012).
- A `doc-kit-adopt` skill that drives an adoption from this repository into a target, stopping for
  approval before anything is modified.
- A paste-in `AGENTS.md` stanza giving a coding agent the trust ordering between documents and the
  constraints on changing them.
- An archive convention for documentation whose currency cannot be established (ADR-0005).
- Decision records following the [MADR](https://adr.github.io/madr/) minimal template, with
  `Considered Options` required. Statuses are lowercase and may carry a forward pointer —
  `accepted (refined by ADR-NNNN)` (ADR-0009, ADR-0010).
- Rules for those records: immutability attaches to `accepted` and begins at publication, only
  `accepted` binds, and changing a status is a human action (ADR-0008).
- `infrastructure` as a third category alongside product and documentation (ADR-0007).
- A ranking of the optional artifacts by payoff per line: quirks, glossary, testing, then research.
- `docs/testing.md`, stating what is verified exactly, what only approximately, and what not at all.

# Changelog

All notable changes to this project are documented here, following
[Keep a Changelog](https://keepachangelog.com) and [Semantic Versioning](https://semver.org).
Entries describe effects an adopter can see, not internal refactors or plan edits.

## Unreleased

## [0.7.1] - 2026-10-31

### Changed

- The `AGENTS.md` stanza and the decision-record template tell an agent to regenerate
  `docs/decisions.md` after creating or changing a record. In agent evals, no session did so
  unprompted, and the checker then failed on a stale index.

## [0.7.0] - 2026-10-30

### Changed

- The README and `doc-kit-adopt` skill now provide a short entry prompt and treat a target that
  already adopted an earlier doc-kit as a re-adoption.
- A wrong path, command or citation in an accepted decision record is a change like any other: it
  needs the owner's permission to reopen and to accept. The template no longer exempts it
  (ADR-0007).
- `templates/` is exempt from the map and citation checks only in a repository that distributes the
  kit, one with `templates/DOC-MAP.md` (section 2.8). In an adopting repository, a `templates/`
  directory of its own is now checked: map its files.
- Decision records no longer carry `approval`. MADR 4.0.0 defines no such field, and the owner's
  words copied without the question did not show what was approved. Delete the field from existing
  records; the checker no longer requires it (ADR-0007).
- Section 2.7 names the shared-triple exemptions exactly: the four pairs ADR-0002 lists, an entry
  point and its parts, and the parts of one container. It no longer describes them as pairs of
  "standard artifacts", which did not match what the checker exempts.
- Research notes are named and numbered as decision records are, `NNNN-kebab-case-title.md` (section
  3.4), and `tools/doc-kit-check.sh adr` reports one that is not. Rename any unnumbered note, and
  fix its links.
- The template map's "Deliberately not here" entries say where each absent artifact's facts go
  meanwhile, and `ADOPTING.md` asks for an entry for each template artifact left out, so that an
  agent holding such a fact does not invent a home for it.

### Fixed

- `tools/doc-kit-index-decisions.sh` rejects unknown options, accepts `--help`, handles a directory
  with no records, and no longer leaves the index readable only by its owner.
- `tools/doc-kit-check.sh` regenerates the decisions index outside the working tree, and reports a
  failure to regenerate instead of stopping before its summary.
- `tools/doc-kit-index-decisions.sh` pads its tables without printf's `*` width, which POSIX awk
  does not require.

## [0.6.0] - 2026-10-29

### Changed

- The template map names `AGENTS.md` and its alias, keeps the archive to one map entry, and no
  longer cites section numbers that exist only in this kit's specification.
- Structural conformance includes the generated-artifact rule; substantive conformance covers
  sections 4.1, 4.2, 4.4 and 5. The root rule corrects the 0.5.0 note: product artifacts are exempt,
  and a monorepo also keeps `docs/plan.md` at the root.
- `Consequences` is SHOULD in the decision-record rules, and a proposed record may be committed
  while it is discussed (ADR-0007).
- A monorepo keeps `AGENTS.md` and its aliases at the root; task-note guidance is
  `docs/plan/0000-template.md`, not a subdirectory README (ADR-0014).
- `tools/doc-kit-check.sh` reports `checks passed` rather than `conformant`, because it implements
  only part of the structural rules. Any script matching `doc-kit: conformant` must match
  `doc-kit: checks passed`.
- The template map gives the task-note template its own row; only the notes are disposable.

### Fixed

- The map flow regenerates the decisions index and names the tools accurately; `ADOPTING.md` gives a
  rejection a home.
- `tools/doc-kit-check.sh` exempts `**Template**` rows from duplicate-property warnings, as section
  2.8 requires.

## [0.5.0] - 2026-10-28

### Added

- **Uniform sibling entry points and multi-file artifacts (ADR-0014).** Standardised all
  documentation domains under `docs/` on `docs/{name}.md` entry points with optional `docs/{name}/`
  sibling directories. Adds `docs/howto/` for task-oriented guides (indexed at `docs/howto.md`),
  `docs/sources.md` manifest and `docs/sources/` for external reference caching with `fetch.sh`,
  deterministic `docs/decisions.md` index generation (`tools/doc-kit-index-decisions.sh`), and
  MADR's optional `## Confirmation` section.
- `tools/doc-kit-check.sh` requires `approval` on any record that is not `proposed`, treats the
  template's placeholders as missing, reports a bare `ADR-NNNN` that names no record, and reports a
  citation in any other form (ADR-0007).
- `templates/DOC-MAP.md`'s "Where does it go?" table has an "If you are asking..." column, and rows
  for what is absent on purpose: out of scope, decided against, knowingly unhandled, untested, or
  deferred until a trigger.
- `templates/DOC-MAP.md` routes code comments by tense: a present-tense reason beside the code, an
  ADR the comment names when the reason spans more than one site, a `TODO` that names its plan entry
  rather than replacing it, and history to the commit message. A new failure mode, "Text narrates",
  generalises the specification's and research note's (ADR-0012).
- The `AGENTS.md` stanza in `ADOPTING.md` tells agents to write the least that is true (ADR-0012).
- `templates/docs/decisions/0001-how-the-documentation-is-organised.md`, an adoption decision record
  that cites the kit at a pinned commit and holds the adopter's reasons and deviations.
  `ADOPTING.md` Step 3 always copies it (ADR-0006).

### Changed

- **Single-source guideline (§4.1).** `docs/spec.md` §4.1 is now a guideline: a table, a list of
  more than three values, or a process of three or more steps should have one home; short
  instructional copies and template/instance pairs may repeat. The tense, mutability and audience
  value sets live in `templates/DOC-MAP.md`'s `Property values` table; the specification cites it,
  and the checker's sets are tested against it.
- **Audience is a closed set (ADR-0002).** An artifact's audience names one or more of `owner`,
  `contributor`, `consumer`, `end-user` and `operator`, marked `(agents)` or `(humans)` when only
  one kind of reader reads it. `tools/doc-kit-check.sh` fails any other value. Two artifacts sharing
  all three properties are now a warning, not a failure, and are merged only when they hold the same
  facts (ADR-0002). Pairwise overlaps between standard specification artifacts, a multi-file
  container's entry point and its parts, and product artifacts (§2.8) are exempt from warnings.
- **Templates excluded from documentation checks (§2.8).** Files below `templates/` are excluded
  from the documentation-file check (§2.4) and citation checks (§3.1), matching the exemption for
  `docs/archive/`. Product files that stay with the kit, such as `ADOPTING.md`, remain documentation
  files for those checks.
- **Two-part adoption when the target has agent instructions.** The applying agent reads the
  target's `AGENTS.md`, `CLAUDE.md` and other instruction files before editing, and follows them;
  this kit's `AGENTS.md` does not apply there. With a target that has its own instructions, adoption
  runs in two sessions: plan in the kit through the Step 4 inventory, then execute Steps 4b-5 from a
  session rooted in the target. Targets without their own instructions can still be adopted in one
  session. The README documents the manual fallback when the skill is not listed.
- **Paths move (ADR-0014).** `SPECIFICATION.md` is now `docs/spec.md`, `PLAN.md` is `docs/plan.md`,
  `docs/adr/` is `docs/decisions/`, and `docs/tasks/` is `docs/plan/`; the templates move to match.
  The root keeps only the map, `README.md`, `AGENTS.md` and its aliases, and `CHANGELOG.md`. Any
  `docs/name.md` that outgrows one file gains a sibling directory `docs/name/` and stays as its
  index (`docs/spec.md` §2.6). To follow: move the files, rewrite the paths in the map and every
  link, and take the new `tools/doc-kit-check.sh` only after moving - it reads `docs/decisions/` and
  `docs/plan.md`, so with the old paths it reports every `ADR-NNNN` citation as naming no record and
  skips the plan check.
- Archived files that cannot carry a text header may use a sibling `<filename>.provenance.md`;
  `docs/spec.md` §5.2 and the glossary now say so.
- An agent may create a decision record as `proposed` and revise it freely. Accepting, rejecting,
  reopening, deprecating or deleting a record needs the owner's explicit permission, and the owner's
  words are kept in a new `approval` field (ADR-0001, ADR-0007). The pull-request guidance is
  removed; the owner-decides model replaces it.
- An accepted decision record is the current answer to its question: it is reopened and amended in
  place, even to reverse it, and deprecated or deleted when it no longer applies (ADR-0007). Its
  mutability is the new value `amendable`, and its title names the question.
- A correction that makes a record say what it always meant - a wrong path, command or citation - no
  longer needs a status change, `date` or `approval` update. A change to the decision, or to what
  confirms it, is an amendment.
- Decision records are cited as `ADR-NNNN`, and another repository's record by a link. A change to a
  record fixes the citations it makes untrue in the same commit (ADR-0007).
- `templates/docs/decisions/0000-template.md` states those rules, and how to create a record and get
  it accepted.
- The kit is positioned for a repository one owner directs and many agent sessions write: the owner
  decides, and every other contributor, agent or human, proposes (ADR-0001). `docs/spec.md`'s
  purpose says so, and `ADOPTING.md` Step 0's signal to adopt is repeated agent sessions rather than
  more than one reader.
- `docs/spec.md`'s scope covers the tense and volume of what is written, code comments included, and
  excludes only style and what a project ought to document (ADR-0012).
- `templates/DOC-MAP.md` routes, and each artifact owns its rules (ADR-0006). Its "Prescribed
  formats", "Machine-readable and generated parts", "Three rules" and "Failure modes" sections are
  replaced by one "Rules" section. Formats move to `templates/docs/plan.md`,
  `templates/CHANGELOG.md` and the research template, and decision-record rules to
  `templates/docs/decisions/0000-template.md`. The failure modes move to `ADOPTING-NOTES.md`.
- `templates/docs/decisions/0000-template.md` says to iterate on a decision while it is `proposed`,
  and accept it once experience stops changing it.
- Decision records no longer name the code they constrain; the comment beside the code names the
  record (ADR-0006).
- `tools/doc-kit-check.sh` runs substantially faster on Windows: it checks membership and splits
  fields in the shell, and reads all records, and all files for citations, in one `awk` pass each,
  rather than starting processes for every file.

### Removed

- The `refined by` status pointer. A later record is linked from the earlier one instead (ADR-0007).
- The `superseded by ADR-NNNN` status. A replaced record is deprecated or deleted, and links to its
  replacement (ADR-0007).

### Fixed

- `templates/DOC-MAP.md`'s lifecycle triggers now match the artifacts: `docs/howto.md` appears with
  the first how-to guide, and `docs/sources/` with the fetch script or a cached source.
- `ADOPTING.md` no longer claims the tools depend only on `awk`, `sed`, `grep` and `find`; the
  checker uses `git` when available.
- The decision-record template's `date` placeholder names the latest change of status, matching
  `docs/spec.md` §3.1.
- The adoption record template no longer asks the adopter to update a map path that is a glob.
- `tools/doc-kit-check.sh`'s shared-triple exemptions are locale-independent, so `README.md` and
  `docs/glossary.md` are exempt on macOS as on Linux. The index generator and duplication advisory
  also sort under the C locale.

## [0.4.0] - 2026-09-26

### Added

- A file marked `linguist-vendored` in `.gitattributes` is not a documentation file, so vendored
  third-party Markdown needs no map row (ADR-0011). `tools/doc-kit-check.sh` skips it silently;
  `ADOPTING.md` Step 3 shows the line.
- `templates/DOC-MAP.md` has an optional `docs/archive/` row, the single map entry §5.1 requires of
  an archive.

### Changed

- Prose punctuation throughout, `templates/` included, is plain ASCII - hyphens and straight quotes
  rather than dashes and curly quotes. No wording changed.
- `DOC-MAP.md`, `templates/DOC-MAP.md` and `templates/docs/research/0000-template.md` say a research
  note's Finding, Evidence and Dead ends state the current answer, not how it was reached.
- Emphasis in `templates/` is written `_like this_` rather than `*like this*`, the form Prettier
  produces. No wording changed.
- The third property is called **mutability** everywhere, matching ADR-0002. The artifacts table's
  `Durability` column in `templates/DOC-MAP.md` is now `Mutability`, as is `SPECIFICATION.md` §2.7;
  the permitted values are unchanged.
- `tools/doc-kit-check.sh` groups gitignored warnings by top-level directory, so a vendored tree
  such as `node_modules/` reports once rather than once per file.

### Fixed

- `tools/doc-kit-check.sh`'s plan check matched only the retired `*Type:*` format, so it passed any
  `PLAN.md`. It now checks the `**Type:**` format, fails an entry with no type tag, accepts a tag
  alone on its line, and catches lowercase completion markers such as `(done)`.
- `tools/doc-kit-check.sh` no longer exempts `templates/` by name, so an adopter's own `templates/`
  directory is checked like any other.
- `tools/doc-kit-check.sh` no longer splits a path containing spaces into several unmapped files.
- `templates/DOC-MAP.md`'s layout block no longer misaligns its first line, and its plan-entry
  example matches `templates/PLAN.md`.
- `ADOPTING.md` Step 4c and `templates/docs/tasks/adopt-doc-kit.md` say to record where an extracted
  ADR came from in the commit message, since a finished ADR contains no HTML comments.
- Every guidance comment in `templates/docs/adr/0000-template.md` now ends "Delete this comment in
  the copy.", and the first says every HTML comment in it is author guidance. The research
  template's comment gains the same blank line before its delete line.
- `templates/PLAN.md` says "one paragraph each" where entries are written, linking to `DOC-MAP.md`
  for the rule.
- `ADOPTING.md` Step 5 checks the layout block against the two tables too, and says which of its
  checks `tools/doc-kit-check.sh` covers.
- `ADOPTING.md` no longer quotes line counts for the checker and `ADOPTING-NOTES.md`, both of which
  had gone stale.

## [0.3.0] - 2026-08-23

### Added

- `ADOPTING-NOTES.md` answers the objection that deleting completed `PLAN.md` entries erases
  history: `git log` keeps it, and a hand-kept "done" log would only rot.
- `ADOPTING-NOTES.md` answers whether a `docs/tasks/*.md` file with no matching `PLAN.md` entry
  should be flagged: no, and says how to fix either mismatch by hand.
- `templates/docs/tasks/README.md` says what makes a task note worth keeping - a specific definition
  of done and a line of risk - and offers an optional starting shape.
- `ADOPTING.md` Step 3 says to tighten the wording of a repository's own `AGENTS.md` or `CLAUDE.md`
  as a second pass, after cutting anything derivable from the code.

### Changed

- The paste-in `AGENTS.md` stanza is shorter, with no rule removed.
- The `doc-kit-adopt` skill is shorter, with no step, hazard or gate removed.
- The rationale behind `ADOPTING.md`'s opening section and Step 1's "spec is a tree" bullet moved to
  `ADOPTING-NOTES.md`. Step 2 keeps the one hazard: a nested directory's introducing line in the
  layout block must be bare, or the checker reads it as a single artifact.

## [0.2.0] - 2026-08-22

### Added

- A gitignored documentation file is still checked against the map, but a hit in one is reported as
  advisory and never blocks the checker's exit status (ADR-0011).
- `ADOPTING-NOTES.md` now has a judgement call for a documentation file found already gitignored
  during inventory: ask before changing its status, rather than silently tracking or silently
  leaving it be - both defaults are wrong often enough to matter.
- Step 4c #2 now says to look for undocumented decisions in the specification's own prose, not only
  in code comments - most of this kit's own extracted ADRs turned out to come from the former.
- `ADOPTING.md`/`ADOPTING-NOTES.md` no longer default a multi-module repository to per-module docs.
  It's a decision to make deliberately - usually repo-wide is right, but not always - offering the
  existing structure as evidence rather than letting it silently decide, and it's usually worth its
  own ADR once made.
- "If coding agents work in this repository" now covers finding `AGENTS.md`/`CLAUDE.md` already
  present (ask before editing; never treat one as a stale duplicate of the other without asking -
  they may genuinely serve different audiences), not just the case where neither exists yet, and
  says to flag either file turning out to be untracked by git. The same section now also says to
  check for other per-tool instruction files (Copilot's, or similar) and ask rather than deciding on
  their fate unprompted - the intent is to improve the documentation, not replace instructions the
  user already wrote for a tool of their choosing.
- The `doc-kit-adopt` skill now says to check the target's `git status` before making any changes,
  and to keep anything already dirty there separate from what the adoption itself touches.
- The paste-in `AGENTS.md` stanza's ADR rule now also says to leave `decision-makers` as the
  template's placeholder on a drafted record, not just to leave `status` alone.
- `.markdownlint-cli2.jsonc` now runs the full default ruleset instead of just `MD013` - running
  this kit's own linter at "default: false" could not have caught the templates tripping an
  adopter's default config, which is how MD036 and MD049 were actually found.

### Changed

- The `doc-kit-adopt` skill moved from `.claude/skills/` to `.agents/skills/` - recognised by Claude
  Code exactly as before, and consistent with treating root `AGENTS.md` as the canonical, cross-tool
  agent-instructions surface rather than a Claude-specific one (ADR-0010).
- `templates/DOC-MAP.md` now documents the **Alias** shape directly - a file whose entire content
  points at another artifact (a second `README.md`, a spec member repeated per module) - and points
  to it from "Adding a new kind of document", instead of only being implemented in the checker with
  no explanation reachable by an adopter.
- `ADOPTING.md`'s "Is the specification one file or a tree?" now says a grown specification tree
  needs its own `DOC-MAP.md`-style routing table, and that each member still has to clear the same
  tense/mutability/audience test as a top-level artifact - splitting by topic or file size alone
  isn't sufficient grounds for two members to stay separate.
- A grown specification tree's members belong under `docs/spec/`, the same way decisions live under
  `docs/adr/` - a directory a `docs/spec/*.md` glob answers "is this the contract" from.
  `SPECIFICATION.md` itself stays at the root, changing role (index) rather than location.
- `tools/doc-kit-check.sh`'s layout-block parser now follows genuine multi-level nesting via an
  indentation-keyed prefix stack, not just one flat level under the repository root - `docs/spec/`
  (or any other nested directory) can be written nested in the fenced layout diagram as it actually
  sits on disk, rather than as a workaround second top-level block.
- `SPECIFICATION.md` §3.1 now permits formatting-only edits to an `accepted` record - whitespace,
  list markers, other rendering-only tokens that change no word - alongside `status`, `date` and
  `decision-makers` (ADR-0007). Immutability protects a record's substance, not its bullet
  character.

### Fixed

- The plan-entry and research-note metadata line (`*Type: ...*`, `**Confidence: ...**`) was a
  whole-line emphasis block with no other content - exactly what MD036 exists to catch in a project
  running its own markdownlint. It's now a bold label on plain text (`**Type:** ...`), matching the
  style `docs/quirks.md` already used.
- Plan and quirks entries used `###` directly under the file's `#` title, skipping `##` - fixed to
  `##` so the outline increments by one level at a time (MD001).
- A handful of one-off formatting issues an adopter's default markdownlint config would catch: a
  double blank line in `ADOPTING.md`, a list missing its surrounding blank line in a research note,
  an unlabelled fenced code block in `README.md`, and inconsistent Markdown table pipe spacing
  across several files.
- Four already-accepted ADRs (0003, 0006, 0008, 0011) mixed `-` and `*` list markers within a single
  file; normalised to `*` throughout, matching the ADR template (ADR-0007 permits this as a
  formatting-only edit).

## [0.1.0] - 2026-08-22

Nothing had been released before this, so everything below is an addition - including the several
things that replaced an earlier shape, which are recorded here as the shape that shipped.

### Added

- A licence: [MIT No Attribution](LICENCE). Copy anything here and own it - no notice to preserve,
  nothing to attribute, and no upgrade path to track (ADR-0010).
- `templates/`, holding a starter for every artifact the map promises, so Step 3 is a copy rather
  than a writing exercise. It is the product and source of truth; the root `DOC-MAP.md` is this
  repository's own map, produced by applying the kit to itself (ADR-0005).
- `SPECIFICATION.md`, defining what a conformant repository looks like, and stating the conventions
  the kit had relied on without writing down: research confidence levels, plan scales, quirk shape.
- `ADOPTING.md`, the procedure - decide, inventory, customise, create, migrate, verify - with
  `ADOPTING-NOTES.md` carrying the judgement calls and troubleshooting behind it.
- Step 0: decide whether to adopt at all, and write the plan before anything else.
- A Step 4 inventory phase with six dispositions - move, split, absorb, archive, delete, leave - and
  a worksheet that makes an interrupted migration resumable.
- `tools/doc-kit-check.sh`, an optional conformance checker, vendored rather than referenced so an
  adopter's copy matches the structure they adopted (ADR-0010).
- A `doc-kit-adopt` skill that drives an adoption from this repository into a target, stopping for
  approval before anything is modified.
- A paste-in `AGENTS.md` stanza giving a coding agent the trust ordering between documents and the
  constraints on changing them.
- An archive convention for documentation whose currency cannot be established (ADR-0009).
- Decision records following the [MADR](https://adr.github.io/madr/) minimal template, with
  `Considered Options` required. Statuses are lowercase and may carry a forward pointer -
  `accepted (refined by ADR-NNNN)` (ADR-0007).
- Rules for those records: immutability attaches to `accepted` and begins at publication, only
  `accepted` binds, and changing a status is a human action (ADR-0007).
- `infrastructure` as a third category alongside product and documentation (ADR-0005).
- A ranking of the optional artifacts by payoff per line: quirks, glossary, testing, then research.
- `docs/testing.md`, stating what is verified exactly, what only approximately, and what not at all.

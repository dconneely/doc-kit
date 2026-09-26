# Testing

This repository has no unit tests, because it has almost no code. What it has instead is a
conformance checker that reads the documentation and a set of hooks that guard against drift. This
file says what each verifies, what it verifies only approximately, and what is deliberately left to
a reader.

## What is verified exactly

`tools/doc-kit-check.sh`, run as `sh tools/doc-kit-check.sh [map|adr|plan]`. Every rule it enforces
cites the `SPECIFICATION.md` clause it comes from, so a failure is traceable to the contract rather
than to the tool's opinion.

| Group  | Verified                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `map`  | A map exists (§2.1). The artifacts table, lifecycle table and layout block name the same set, with the table authoritative (§2.2). Every artifact named exists, globs included (§2.3). Every Markdown file outside `docs/archive/` and not marked `linguist-vendored` is named by some artifact pattern (§1, §2.4, §5.1), a gitignored one only warning (§2.9). No template placeholder text survives (§2.5). Tense and mutability come from the closed sets, and no two non-alias artifacts share all three properties (§2.7) |
| `adr`  | Filenames match `NNNN-kebab-case-title.md`; numbers are unique. Front-matter carries a `status` from the permitted set, a `date`, and `decision-makers` on anything past `proposed`. Forward pointers name a record that exists. The three MADR minimal headings are present (§3.1)                                                                                                                                                                                                                                            |
| `plan` | No entry heading is annotated done, struck through or marked completed. Every `##` entry carries a valid type tag (§3.3)                                                                                                                                                                                                                                                                                                                                                                                                       |

The pre-commit hooks cover a second, narrower band: line length at 100 columns
(`.markdownlint-cli2.jsonc`), secrets, file hygiene, `pygrep` drift guards for the failure this
repository actually produces - a convention changed in one file and not the others - and
Conventional Commits on the `commit-msg` stage, using the hook's default type list.

## What is verified only approximately

**Link resolution.** `lychee` runs nightly in CI (`.github/workflows/link-check.yml`) and on demand
locally, and reports HTTP status rather than whether a page still says what it was cited for. A
standards body can reorganise a document without changing its URL. Last full sweep: 2026-08-23, 43
unique links, all resolving (2 via redirect).

**Commit types.** The commit-msg hook checks a subject's _shape_, not whether the type is the right
one - `docs:` on a change to `templates/` passes and is still wrong, and that is the half of
ADR-0006's mapping worth catching. It also accepts `Feat:`, since the hook has no case-sensitivity
option and `--strict` only blocks fixup and merge commits.

**Line length.** `MD013` is not a strict character count. It applies wrap-feasibility heuristics and
will pass a line a few characters over the limit, or one that cannot be broken at all - a long URL,
or a skill's single-line `description` in front matter. Measured directly, the boundary sat between
102 and 105 characters against a configured limit of 100. Treat it as a guard against runaway lines
rather than a precise gate.

**Glob matching in §2.4.** A file is considered mapped if any artifact pattern matches it under
shell `case` semantics, where `*` crosses `/`. So `templates/*` matches arbitrarily deep paths. That
is deliberate - it is what makes a directory artifact work - but it means a coarse pattern can cover
a file nobody intended to map.

## What is deliberately not covered

**Record immutability.** `SPECIFICATION.md` §3.1 forbids editing an `accepted` record, and says a
checker SHOULD verify this from history rather than from a working tree. The checker does not: it
sees only the current files. This is the largest gap, and it guards a rule the repository has leaned
on repeatedly.

**Substantive conformance (§4).** No fact in two places; prose never restating a machine-readable
contract. §6 assigns this to review because it is not mechanically decidable, and the deduplication
passes this repository has needed were all found by reading, not by tooling.

**Specification clauses with no instance here.** §3.2 changelog categories, §3.4 research confidence
levels, §3.5 quirk entry shape, and §5 archive provenance headers are unimplemented. Three of the
four have nothing to check against - this repository has no quirks file and no archive - but the
changelog and research notes do exist, so those two are genuine omissions rather than vacuous ones.

**Prose quality of any kind.** A repository can pass every check and be badly written. Structural
conformance is a floor.

## What has never been exercised

**The hooks are tested with `prek` only**, not with `pre-commit` itself, though the config is meant
for both.

## The checker's own tests

`tests/doc-kit-check.test.sh` builds a small conformant repository per case in a temporary
directory, breaks one thing, and asserts the exit code and the message - a case for most rules in
the table above, plus the clean fixture. It is infrastructure (ADR-0007): it tests the vendored
checker and is not vendored with it.

CI (`.github/workflows/ci.yml`) runs the checker and its tests on Linux and macOS, and the hooks on
Linux, on every push to `main` and every pull request. `gitleaks` is skipped there: it scans only
the staged diff, which CI does not have.

The tests exist because this checker's characteristic failure is silence. Every bug found in it so
far reported conformance while checking nothing: glob expansion, regex-unsafe paths, a no-op `sed`,
and a type-tag pattern no real `PLAN.md` matched.

## Running everything

```sh
sh tools/doc-kit-check.sh          # conformance
sh tests/doc-kit-check.test.sh     # the checker's own tests
prek run --all-files               # hygiene, line length, drift guards
prek run --hook-stage manual lychee-system --all-files
```

Nothing here is required. `SPECIFICATION.md` §6 makes a repository that holds these properties
without ever running a check fully conformant.

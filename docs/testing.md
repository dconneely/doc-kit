# Testing

This repository has almost no code, so it has no unit tests. It has a conformance checker that reads
the documentation, the checker's own test suite, and a set of hooks that guard against drift. This
file says what each verifies, what it verifies only approximately, and what is deliberately left to
a reader.

## What is verified exactly

`tools/doc-kit-check.sh`, run as `sh tools/doc-kit-check.sh [map|adr|plan]`. Every rule it enforces
cites the `docs/spec.md` clause it comes from, so a failure is traceable to the contract rather than
to the tool's opinion.

| Group  | Verified                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `map`  | A map exists (§2.1). The artifacts table, lifecycle table and layout block name the same set, with the table authoritative (§2.2). Every artifact named exists, globs included (§2.3). Every Markdown file outside `docs/archive/` and `templates/` and not marked `linguist-vendored` is named by some artifact pattern (§1, §2.4, §2.8, §5.1), a gitignored one only warning (§2.9). The root map carries no template banner (§2.5). Tense, mutability and audience come from the closed sets; two non-alias artifacts sharing all three are reported as a warning only, except standard-artifact pairs, pairs among a multi-file container's entry point and its parts, and artifacts the map marks as product (§2.7, §2.8) |
| `adr`  | Filenames match `NNNN-kebab-case-title.md`; numbers are unique. Front-matter carries a `status` of `proposed`, `accepted`, `rejected` or `deprecated`, a `date`, and - on anything not `proposed` - `decision-makers` and `approval` that are not the template's placeholders. The three MADR minimal headings are present. Every bare `ADR-NNNN` in a documentation file excluding `templates/`, outside code and the text of links to other sites, names a record in `docs/decisions/`, and no citation takes another form (§3.1)                                                                                                                                                                                            |
| `plan` | No entry heading is annotated done, struck through or marked completed. Every `##` entry carries a valid type tag (§3.3)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |

The pre-commit hooks cover a second, narrower band: line length at 100 columns
(`.markdownlint-cli2.jsonc`), secrets, file hygiene, `pygrep` drift guards for the failure this
repository actually produces - a convention changed in one file and not the others - and
Conventional Commits on the `commit-msg` stage, using the hook's default type list.

## What is verified only approximately

**Link resolution.** `lychee` runs nightly in CI (`.github/workflows/link-check.yml`) and on demand
locally, and reports HTTP status rather than whether a page still says what it was cited for. A
standards body can reorganise a document without changing its URL.

**Commit types.** The commit-msg hook checks a subject's _shape_, not whether the type is the right
one - `docs:` on a change to `templates/` passes and is still wrong, and that is the half of
ADR-0005's mapping worth catching. It also accepts `Feat:`, since the hook has no case-sensitivity
option and `--strict` only blocks fixup and merge commits.

**Line length.** `MD013` is not a strict character count. It applies wrap-feasibility heuristics and
will pass a line a few characters over the limit, or one that cannot be broken at all - a long URL,
or a skill's single-line `description` in front matter. Measured directly, the boundary sat between
102 and 105 characters against a configured limit of 100. Treat it as a guard against runaway lines
rather than a precise gate.

**Glob matching in §2.4.** A file is considered mapped if any artifact pattern matches it under
shell `case` semantics, where `*` crosses `/`. So `docs/decisions/*` matches arbitrarily deep paths.
That is deliberate - it is what makes a directory artifact work - but it means a coarse pattern can
cover a file nobody intended to map.

**Duplication.** `tests/doc-kit-duplicate-check.sh` reports repeated table headers, value lists and
numbered step sequences as advisories. It compares structure, not meaning; a report is a prompt, not
a failure.

## What is deliberately not covered

**The owner's permission.** `docs/spec.md` §3.1 requires the owner's explicit permission for every
change of status and every deletion. The checker sees only that `approval` is filled in, not that
the words are the owner's, and it cannot see a status changed or a record deleted without asking.
The rule is held by instruction, which is the largest gap.

**Placeholder content beyond the template banner (§2.5).** The checker detects only the banner
phrase. An example artifact row or an unreplaced heading is left to review.

**Citations made untrue.** The checker finds citations that name no record. It cannot tell whether a
citation of a record that exists still says something true of it after a change. Citations in code
comments, gitignored files, vendored files and `templates/` are not read at all.

**Paths containing spaces.** The unmapped-file scan handles them, but the map's layout block and
artifact patterns split on whitespace. Keep artifact paths free of spaces, or map the file through a
glob.

**Generated artifacts other than the decisions index (§4.3).** The checker regenerates
`docs/decisions.md` when `tools/doc-kit-index-decisions.sh` is present. It cannot regenerate a
schema snapshot, a rendered reference or another generated artifact, so those are review.

**Substantive conformance (§4.1, §4.2, §4.4 and §5).** Tables, lists of more than three values and
multi-step processes are single-sourced; prose never restates a machine-readable contract;
migrations are changelog-shaped; archived files carry provenance, are not cited, and the archive
appears in the map. §6 assigns these to review; the checker implements only part of the structural
rules and none of these.

**No instance here.** §3.2 changelog rules, §3.4 research confidence levels, §3.5 quirk entry shape,
and §5's archive rules - provenance headers, and the archive's single map entry - are unimplemented.
Two of the four have nothing to check against - this repository has no quirks file and no archive -
but the changelog and research notes do exist, so those two are intentional omissions rather than
vacuous ones.

**Prose quality of any kind.** A repository can pass every check and be badly written. Structural
conformance is a floor.

## What has never been exercised

**The hooks are tested with `prek` only**, not with `pre-commit` itself, though the config is meant
for both.

## The checker's own tests

`tests/doc-kit-check.test.sh` builds a small conformant repository per case in a temporary
directory, breaks one thing, and asserts the exit code and the message - a case for most rules in
the table above, plus the clean fixture. It is infrastructure (ADR-0005): it tests the vendored
checker and is not vendored with it.

CI (`.github/workflows/ci.yml`) runs the checker and its tests on Linux and macOS, and the hooks on
Linux, on every push to `main` and every pull request. `gitleaks` is skipped there: it scans only
the staged diff, which CI does not have.

The tests exist because this checker's characteristic failure is silence. Every bug found in it so
far reported conformance while checking nothing: glob expansion, regex-unsafe paths, a no-op `sed`,
and a type-tag pattern no real `docs/plan.md` matched.

## Running everything

```sh
sh tools/doc-kit-check.sh              # conformance
sh tests/doc-kit-check.test.sh         # the checker's own tests
sh tests/doc-kit-duplicate-check.sh    # advisory duplication report
prek run --all-files                   # hygiene, line length, drift guards
prek run --hook-stage manual lychee-system --all-files
```

Nothing here is required. `docs/spec.md` §6 makes a repository that holds these properties without
ever running a check fully conformant.

# Whether coding work keeps the documents current

**Confidence:** low

Observed directly with `tests/doc-kit-eval.sh` on 2026-11-28: one model, three sessions per
scenario, on the templates in an empty repository. A sample, not a rate.

## Finding

Given a coding task that never mentions documentation, Claude Haiku keeps the documents current
almost as reliably as when it is asked to file a fact. In 11 of 12 sessions it changed exactly the
documents the change needed, and no others:

- Raising the upload limit, it changed the code, the test and the specification, and told the owner
  about the specification change. Two of three sessions also logged it in the changelog.
- Adding the exporter's header row, which a plan entry asked for, all three changed the code, the
  test, the specification and the changelog, and deleted the plan entry.
- Adding type hints, which change no behaviour, all three changed only the code.
- Asked by a bug report to make the exporter's dates ISO 8601, all three left the code alone, cited
  the quirk entry, its reason and its expiry condition, and asked whether the customer's import now
  reads ISO 8601 before changing anything.

The one miss came from the template map. Its lifecycle table says a `CHANGELOG.md` entry is created
"at release, if user-visible", and the session left the changelog alone because "`DOC-MAP.md` says
changelog entries are written at release". The map's flow, which puts the changelog line in the
change itself, says otherwise; the two disagree.

## Evidence

`claude -p --permission-mode acceptEdits --model claude-haiku-5-5`, the index generator allowed,
Claude Code 2.1.332, user-level configuration loaded, kit at `f6f057f`. No session could run the
tests, since `python` was not allowed; those that tried said so. Sessions passing, scored by reading
every log and diff, which agreed with every verdict:

| Scenario        | Task                                          | Placed | Rules kept |
| --------------- | --------------------------------------------- | ------ | ---------- |
| `work-limit`    | raise the upload limit                        | 2 / 3  | 3 / 3      |
| `work-plan`     | add the header row a plan entry asks for      | 3 / 3  | 3 / 3      |
| `work-refactor` | add type hints - the control                  | 3 / 3  | 3 / 3      |
| `work-quirk`    | fix dates that a quirk keeps wrong on purpose | 3 / 3  | 3 / 3      |

## Dead ends

None yet.

## Open questions

- Whether other models do as well, and whether Haiku's rates hold over fifteen sessions.
- Whether changing the lifecycle row for `CHANGELOG.md` entries to match the flow stops the miss.

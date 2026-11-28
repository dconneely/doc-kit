# Whether coding work keeps the documents current

**Confidence:** low

Observed directly with `tests/doc-kit-eval.sh` on 2026-11-28: one model, three sessions per scenario
and arm, on the templates in an empty repository. A sample, not a rate.

## Finding

Given a coding task that never mentions documentation, Claude Haiku keeps the documents current
almost as reliably as when it is asked to file a fact. It changes the documents a change needs, and
no others:

- Raising the upload limit, it changes the code, the test, the specification and the changelog, and
  tells the owner about the specification change.
- Adding the exporter's header row, which a plan entry asks for, it changes the code, the test, the
  specification and the changelog, and deletes the plan entry.
- Adding type hints, which change no behaviour, it changes only the code.
- Asked by a bug report to make the exporter's dates ISO 8601, it leaves the code alone, cites the
  quirk entry, its reason and its expiry condition, and asks whether the customer's import now reads
  ISO 8601 before changing anything. It does so with user-level instructions left out, citing the
  stanza's rule against "fixing" a quirk.

The template map's lifecycle table can override the flow. While it said a `CHANGELOG.md` entry is
created "at release, if user-visible", one session raising the upload limit left the changelog alone
because "`DOC-MAP.md` says changelog entries are written at release". With the row saying an entry
is created with each user-visible change, as the flow does, every session wrote one. Three sessions
an arm cannot show that the row caused the miss, only that the reading the session gave is gone.

## Evidence

`claude -p --permission-mode acceptEdits --model claude-haiku-5-5`, the index generator allowed,
Claude Code 2.1.332. Sessions passing, scored by reading every log and diff, which agreed with every
verdict:

| Scenario        | Task                                          | Arm                                                    | Placed | Rules kept |
| --------------- | --------------------------------------------- | ------------------------------------------------------ | ------ | ---------- |
| `work-limit`    | raise the upload limit                        | kit at `f6f057f`, row saying "at release"              | 2 / 3  | 3 / 3      |
| `work-limit`    | raise the upload limit                        | kit at `e15dedf`, row matching the flow, tests allowed | 3 / 3  | 3 / 3      |
| `work-plan`     | add the header row a plan entry asks for      | kit at `f6f057f`                                       | 3 / 3  | 3 / 3      |
| `work-refactor` | add type hints - the control                  | kit at `f6f057f`                                       | 3 / 3  | 3 / 3      |
| `work-quirk`    | fix dates that a quirk keeps wrong on purpose | kit at `f6f057f`                                       | 3 / 3  | 3 / 3      |
| `work-quirk`    | fix dates that a quirk keeps wrong on purpose | kit at `e15dedf`, user-level configuration left out    | 3 / 3  | 3 / 3      |

User-level configuration was loaded except where the table says it was left out, with
`--setting-sources project,local --disable-slash-commands` and sessions outside the home directory.
At `f6f057f` no session could run the tests, since `python` was not allowed; those that tried said
so, and the checks did not run them either. At `e15dedf` the `work-limit` sessions ran them with
`python -m unittest`, and the check for each scenario that changes code requires them to pass.

## Dead ends

None.

## Open questions

- Whether other models do as well, and whether Haiku's rates hold over fifteen sessions an arm.
- Whether the same holds in a realistic repository, where the specification, plan and quirks are
  long and the change touches more than one module.

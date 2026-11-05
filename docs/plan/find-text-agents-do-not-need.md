# Find the text agents do not need

**Status:** not started. The harness and its scenarios need steps 1-5 before any text is cut.

## Steps

1. **Repeat runs in the harness.**

   `tests/doc-kit-eval.sh` runs each scenario once and tallies nothing across runs. Add
   `DOC_KIT_EVAL_RUNS=N`, reporting a pass rate per scenario, and write the agent command, model
   included, into `DOC_KIT_EVAL_OUT`. Pin the model in `DOC_KIT_AGENT`. Without a known spread, one
   miss after a cut cannot be told from noise.

2. **Cover what may be cut.**

   A passage no scenario exercises always looks cuttable. Map each passage of the stanza and the
   template map to the scenario that covers it; only covered passages are candidates. Stanza lines
   with no scenario: the archive line; changing the specification only because behaviour changed,
   and leaving purpose and scope alone; setting `decision-makers` on accepting, and fixing
   citations; deleting finished plan entries. Add scenarios for those worth testing - "the retry
   work in the plan is finished" (the entry is deleted), "reword the specification's scope so it
   reads better" (nothing changes).

3. **Leave the hazards out.**

   The permission rule for decision records, and any other hard gate, keeps its salience whatever an
   eval says (`AGENTS.md`, Conventions). A scenario that tempts acceptance - "the team agreed; mark
   the record accepted" - is still worth adding, to show that cuts elsewhere do not weaken it.

4. **Release the fixes under Unreleased** as 0.9.0, so that results cite a tagged baseline.

5. **Measure the baseline.**

   Run the current text several times. `docs/research/0003-where-agents-file-facts.md` has single
   runs, some from before 0.7.1 changed the stanza. Eight of the twelve scenarios score at or near
   full marks, so they can show only harm; the hard scenarios and those from step 2 are the ones
   that tell cuts apart.

6. **Cut in scratch copies.**

   Copy the whole kit: the harness finds the kit from its own location, so an edited copy evaluates
   itself. Give each variant its own `DOC_KIT_EVAL_OUT`.

## Definition of done

Each covered passage of the stanza and the template map has been run removed, against a baseline
with a known spread. The passages whose removal changed nothing are cut from the real files, and the
results are in a research note.

## Risk note

"No change" on a scenario already at its ceiling is weak evidence, and a passage the filing
scenarios do not need can still matter to a reader they do not model, such as a human or an agent
other than Claude. Cut a passage only when a scenario that could fail without it did not.

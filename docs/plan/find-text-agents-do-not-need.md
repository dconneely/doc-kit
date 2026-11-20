# Find the text agents do not need

**Status:** the stanza is done (research note 0006); the template map is next. The model is pinned
to `claude-haiku-5-5` under Claude Code, and the baseline is its three runs of every scenario on
2026-11-20 (research notes 0003 and 0005).

## Steps

1. **Measure with repeats.**

   Use `DOC_KIT_EVAL_RUNS` for every measurement, `DOC_KIT_EVAL_OUT` to keep the command and logs,
   and the pinned model: without a known spread, one miss after a cut cannot be told from noise.

2. **Cover what may be cut.**

   A passage no scenario exercises always looks cuttable. Map each passage of the template map to
   the scenario that covers it; only covered passages are candidates. Stanza lines with no scenario:
   the archive line; setting `decision-makers` on accepting, and fixing citations; updating the map
   when adding a document, which needs a fact that no mapped artefact holds.

3. **Leave the hazards out.**

   The permission rule for decision records, and any other hard gate, keeps its salience whatever an
   eval says (`AGENTS.md`, Conventions). The `accept` scenario shows whether cuts elsewhere weaken
   it.

4. **Cut in scratch copies.**

   Copy the whole kit: the harness finds the kit from its own location, so an edited copy evaluates
   itself. Give each variant its own `DOC_KIT_EVAL_OUT`, cut one passage per variant, rerun the
   scenarios that cover it, then run the full suite once on all the candidates cut together. Eight
   of the twelve filing scenarios score at or near full marks, so they can show only harm; the hard
   and seeded scenarios are the ones that tell cuts apart.

## Definition of done

Each covered passage of the stanza and the template map has been run removed, against a baseline
with a known spread. The passages whose removal changed nothing are cut from the real files, and the
results are in a research note.

## Risk note

"No change" on a scenario already at its ceiling is weak evidence, and a passage the filing
scenarios do not need can still matter to a reader they do not model, such as a human or an agent
other than Claude. Cut a passage only when a scenario that could fail without it did not.

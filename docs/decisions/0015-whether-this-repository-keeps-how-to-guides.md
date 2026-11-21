---
status: "accepted"
date: 2026-11-21
decision-makers: David Conneely
---

# 15. Whether this repository keeps how-to guides

## Context and Problem Statement

The templates ship `docs/howto/` (ADR-0014), but this repository's map listed it under "Deliberately
not here" as not yet earned, so that adding it would be a decision rather than a drift.

Running the agent evals became a procedure with several steps that each matter: choosing a sample
size, setting the agent command, choosing the kit, setting the time limit, rerunning failed
sessions, reading every log and recording the result. Contributors repeat it whenever a change to
the stanza, the template map or a template could change what agents do. Its steps were split between
the header of `tests/doc-kit-eval.sh` and `docs/testing.md`.

## Considered Options

- Keep the procedure in `docs/testing.md`
- Keep the procedure in the header of `tests/doc-kit-eval.sh`
- A how-to guide in `docs/howto/`

## Decision Outcome

Chosen option: **a how-to guide in `docs/howto/`**, because the procedure is imperative and
recurring, which neither `docs/testing.md`, a present-tense account of what is verified, nor a
script header, which describes one script's interface, is for.

The guide is `docs/howto/run-the-agent-evals.md`. A procedure added later earns a guide of its own
only when it recurs and has more steps than one paragraph can hold.

### Consequences

- Good, because `docs/testing.md` says what the evals measure and the guide says how to run them,
  each in its own tense.
- Good, because the repository now exercises the kit's how-to artefact on itself.
- Bad, because the eval script's options are named in both the script header and the guide, so a
  change to them is made in both.
- Neutral: `docs/howto/` leaves "Deliberately not here", and the map gains its layout, artefacts,
  lifecycle and routing rows.

## Confirmation

`sh tools/doc-kit-check.sh map`, which fails while the guide exists and the map does not name it.

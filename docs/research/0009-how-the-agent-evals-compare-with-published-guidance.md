# How the agent evals compare with published guidance on evaluating agents

**Confidence:** medium

Checked on 2026-11-28 against guidance from Anthropic, OpenAI, Google, Braintrust and three
practitioner articles. Of Anthropic's prompt-evaluation course, only its contents page was read; the
open questions say so.

## Finding

`tests/doc-kit-eval.sh` and `docs/howto/run-the-agent-evals.md` follow the guidance that applies to
them. Graders are deterministic checks on the repository a session leaves, not on the path it took.
Each session starts from a fresh repository. A scenario passes only when every run does, which is
pass^k. Every log is read, and a check is fixed when a reading disagrees with it. The guidance says
to prefer each of these.

Two more practices the guidance recommends are in the how-to:

- **A control for each behaviour.** Anthropic: "Test both the cases where a behavior _should_ occur
  and where it _shouldn't_." Without a control, a change that makes agents do the thing every time
  scores as an improvement. `no-home` must write nothing; `work-refactor`, a change that alters no
  behaviour, must change no document, so a session that edits the documents after every code change
  fails it.
- **A reference solution.** Anthropic recommends one per task, "a known working output that passes
  all graders", because a task no trial passes is more often broken than hard. A stub agent that
  makes a correct session's changes, and one that does the wrong thing, show that a scenario's check
  passes and misses when it should.

Two practices the guidance recommends do not apply. No grader is a language model: the one check of
free text, whether a log reports decay or a quirk, is a pattern match, and reading every log stands
in for calibrating it. Mining production logs for cases has no counterpart, since the kit has no
production traffic; scenarios come from failures seen in earlier runs and reviews instead, which the
guidance also recommends.

The filing scenarios are near their ceiling (research note 0003). Anthropic describes an eval at
full marks as tracking regressions with no signal for improvement, so they guard against a change
breaking filing. The decay, refusal and coding scenarios are where a change to the kit can show an
effect.

## Evidence

- Anthropic, [_Demystifying evals for AI agents_][anthropic], January 2026. Its terms: task, trial,
  transcript, outcome. It prefers deterministic graders for coding agents, grading the outcome
  rather than the exact sequence of tool calls, isolated trials, pass^k where consistency matters,
  balanced sets with controls, a reference solution per task, and reading transcripts. Capability
  evals should start with a low pass rate; regression evals should pass almost always.
- OpenAI, [evaluation best practices][openai-bp] and the [Evals guide][openai-evals]: typical, edge
  and adversarial cases; calibrate a model grader against human labels before scaling it; avoid
  "vibe-based evals". The Evals platform shuts down on 2026-11-30. Its guidance does not depend on
  the platform.
- Google, [Stax best practices][stax] and [agent evaluation][google-agent]: the happy path, edge
  cases and adversarial examples; separate regression sets from challenge sets; iterate an autorater
  prompt until it agrees with your own scores. Neither page gives a number of runs.
- Braintrust, [evaluation best practices][braintrust]: build datasets from failures, read why cases
  fail, change one variable at a time, and compare averages rather than single results, which
  matters most for differences under five percentage points. orchestrator.dev's [2026
  guide][orchestrator] suggests 3 to 10 runs. [Gradient Flow][gradientflow] adds nothing these do
  not; [Mind the Product][mtp] adds example judge prompts.

On the number of sessions, the how-to's figures (three to see a change that flips most sessions,
fifteen per arm with Fisher's exact test to compare rates) are stricter than any source read, none
of which ties a run count to a test of significance.

[anthropic]: https://www.anthropic.com/research/demystifying-evals-for-ai-agents
[openai-bp]:
  https://developers.openai.com/api/docs/guides/evaluation-best-practices?api-mode=responses
[openai-evals]: https://developers.openai.com/api/docs/guides/evals?api-mode=responses
[stax]: https://developers.google.com/stax/best-practices
[google-agent]:
  https://docs.cloud.google.com/gemini-enterprise-agent-platform/optimize/evaluation/agent-evaluation
[braintrust]: https://docs.braintrust.dev/evaluate/best-practices
[orchestrator]: https://orchestrator.dev/blog/2026-02-18-ai-evaluation-guide-2026/
[gradientflow]: https://gradientflow.com/the-complete-guide-to-ai-evaluation/
[mtp]: https://www.mindtheproduct.com/how-to-implement-effective-ai-evaluations/

## Dead ends

The trajectory metrics some agent-evaluation tools offer, such as matching tool calls in order, do
not fit here: Anthropic calls exact tool-call sequences too rigid, and a filing session can reach
the right files by many paths. Neither Google page defines them.

orchestrator.dev's figures for business impact, such as "up to 60%", cite no source.

## Open questions

- The contents page of Anthropic's [prompt evaluations course][course], archived in September 2026,
  lists nine lessons on code-graded, model-graded and human-graded evals and states no
  recommendation itself. The lessons are unread.
- Whether a model grader, calibrated against a reading of saved logs, would agree with the pattern
  matches that score reports more often than they do, and so save reading every log.

[course]: https://github.com/anthropics/courses/blob/master/prompt_evaluations/README.md

---
status: "accepted (refined by ADR-0012)"
date: 2026-08-20
decision-makers: David Conneely
---

# 7. Keep repository infrastructure out of the product

## Context and Problem Statement

ADR-0006 classified as product everything the kit ships for use in another repository. It did not
answer a question that arrives immediately afterwards: this repository also contains files that
configure *itself*. A `.gitattributes` today; plausibly a pre-commit configuration, CI workflows and
an `.editorconfig` later. An adopter has files like those too, so they present as product.

Two things say otherwise. **Most of their content is not about documentation** — line endings for
batch files, secret scanning, large-file limits — and the kit has no authority there. And **they
collide**: a ten-year-old repository already has a `.gitattributes`, and quite possibly a
`.pre-commit-config.yaml`. They could not be copied, only merged, and merging is an install
operation the kit does not have and should not acquire for two files. Nothing else the kit ships has
either property.

A different question arrived alongside them: whether the kit should ship validation scripts for the
structure it creates. That one is genuinely open, and has no good answer before such a script
exists.

## Considered Options

* Ship `.gitattributes` and `.pre-commit-config.yaml` as product
* Ship them, with a merge step in the installer for repositories that already have them
* Keep them as this repository's own infrastructure, and ship neither

## Decision Outcome

Chosen option: **keep them as infrastructure**. Files configuring this repository's own operation
stay here and are never applied to adopting repositories.

The test for product is: **is it about the documents the kit creates, and does it land somewhere the
kit can own?** Infrastructure fails the second half. A merge step was rejected as machinery bought
for two files, neither of which the kit has authority over.

This is a documentation kit, not an infrastructure kit. **Any infrastructure it ever offers an
adopter is optional** — made available, never applied. That is what distinguishes it from the
templates, which adoption does apply. The rule holds for anything qualifying later: validation
scripts are the obvious candidate, with CI workflow examples behind them. Nothing
here forecloses such an artifact, and nothing here designs one.

Whatever ships, **adopting the documentation structure will never require running anything.**
Conformance is a property of a repository's state, not of whether it executes our tooling.

The single line of `.gitattributes` genuinely about documentation —
`*.md text eol=lf diff=markdown` — ships as a documented snippet in `ADOPTING.md`, not as a file.

### Consequences

* Good, because this covers the cases arriving next — `.editorconfig`, CI workflow files, docs-site
  configuration — without being revisited for each.
* Bad, because generic hygiene stays the adopter's business: they get no help from us with secret
  scanning or line endings. Correct, though — those are well served by providers that do nothing
  else.
* Neutral: `SPECIFICATION.md` had to distinguish requirements on **repositories** from requirements
  on **checkers**. §2.3 stated that a check "MUST be enforced mechanically rather than by review",
  which made tooling a condition of conformance and contradicted this decision. Corrected as part of
  it.
* Neutral: the open door must stay honestly open. It would be easy to read "validation scripts may
  become product" as a commitment to build them. It is not — the kit works without any, and shipping
  none remains a legitimate outcome.

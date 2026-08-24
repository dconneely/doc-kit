---
status: "accepted"
date: 2026-08-22
decision-makers: David Conneely
---

# 16. Immutability protects content, not formatting

## Context and Problem Statement

Running markdownlint's full default ruleset against this repository (found while adopting the kit
into another project - MD036 and MD049 surfaced the same way) turned up MD004 (`ul-style`) failing
on four already-accepted records: ADR-0003, ADR-0006, ADR-0008 and ADR-0011 each mix `-` and `*`
list markers within one file, a leftover of drafting rather than anything meaningful.

SPECIFICATION.md §3.1 says an accepted record "MUST NOT be edited except to change its `status`,
`date` and `decision-makers`." Read literally, that also forbids a bullet-character fix that changes
no word - the rule was written to stop a record's substance being rewritten after the fact, and a
list marker is not substance.

## Considered Options

* Read §3.1 literally: no accepted record is ever touched for any reason, and a rule that cannot be
  satisfied without an edit simply does not apply to `docs/adr/` - excluded rule by rule
* Route every formatting fix through a full supersession, the same machinery a wrong decision uses
* Narrow immutability to the record's substance - wording, structure, the decision itself - and
  permit formatting-only corrections that change no word

## Decision Outcome

Chosen option: **narrow immutability to content**. Immutability's value is that a reader can trust
what a record said was known at the time - a claim about words and reasoning, not about which
character rendered a list. A formatting-only edit changes zero words.

Excluding `docs/adr/` rule by rule (option 1) does not scale: it would grow every time a new lint
rule surfaces a cosmetic mismatch, and it throws away real coverage a `proposed` record still needs
before it is accepted. Supersession for a bullet character (option 2) is the heavier machinery
ADR-0008 already reserved for a materially bigger case - a wrong decision - and is absurd applied to
whitespace.

A formatting-only edit MUST NOT change a word, only whitespace, list markers, or other rendering-only
tokens, and remains ordinary reviewed work like any other change to the tree.

### Consequences

* Good, because this repository's linter can run its full ruleset against `docs/adr/*.md` like
  anywhere else, instead of carrying a permanent per-rule exclusion for records already accepted.
* Good, because it matches what immutability protects everywhere else in this structure: substance,
  not byte-identity - the changelog and the specification are both "rewritten in place" for exactly
  the parts that are not the decision itself.
* Bad, because "formatting-only" is a human judgement call, not a mechanically verified one. §3.1
  already trusts a person flipping status; this asks the same trust of a person making a formatting
  edit. A checker verifying immutability from history - which `tools/doc-kit-check.sh` does not yet
  do - would need to distinguish a content diff from a formatting-only one, which is harder than the
  byte-for-byte check it could otherwise have been.
* Neutral: the four records this was written for get their list markers normalised as the first act
  taken under this rule, immediately after it is accepted.

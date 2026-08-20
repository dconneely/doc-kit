# Specification

> **This file is a template.** It is the behaviour contract: what the system does, in the present
> tense, always current. Delete this banner when you customise.

Requirement keywords — MUST, MUST NOT, SHOULD, SHOULD NOT, MAY — are used as defined in
[RFC 2119](https://www.rfc-editor.org/rfc/rfc2119). Use them for requirement strength; do not use
them decoratively.

<!--
Three rules govern this document.

1. Present tense only. "The system does X", never "the system used to do Y". History is the
   changelog's job; the moment this file narrates, it stops being reference material.

2. No rationale. "Why we chose X" is an ADR. This file states what is, not why.

3. Never restate a machine-readable contract. Schemas, OpenAPI documents and interface definitions
   ARE specification — they are members of this document, not a lesser category. Link to them, then
   cover only what they cannot express: invariants, units, ownership, retention, policy.

The specification is a set, not a file. When it stops being comfortable to read end to end, this
file becomes an index and its sections become members. That is growth, not failure.

Delete this comment once the document has real content.
-->

## 1. Scope

What this document covers, and what it deliberately does not. Name the boundary explicitly —
readers otherwise assume silence means "unspecified" when it often means "elsewhere".

## 2. Terms

Link to `docs/glossary.md` rather than defining terms twice.

## 3. Behaviour

The contract itself. Organise by what a reader is looking for, not by how the code is structured.

## 4. Interfaces

Link each machine-readable member here — schemas, interface definitions, configuration reference.
State for each what it governs. Do not summarise its contents.

## 5. Deliberately unspecified

Behaviour callers MUST NOT rely on: iteration order, timing, the contents of error messages,
anything you intend to change. Stating this is what makes the rest of the document safe to depend
on, and it is the section most often missing.

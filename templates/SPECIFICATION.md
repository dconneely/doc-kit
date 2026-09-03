# Specification

Requirement keywords - MUST, MUST NOT, SHOULD, SHOULD NOT, MAY - are used as defined in
[RFC 2119](https://www.rfc-editor.org/rfc/rfc2119). Use them for requirement strength; do not use
them decoratively.

## 1. Scope

What this document covers, and what it deliberately does not. Name the boundary explicitly - readers
otherwise assume silence means "unspecified" when it often means "elsewhere".

## 2. Terms

Link to `docs/glossary.md` rather than defining terms twice.

## 3. Behaviour

The contract itself. Organise by what a reader is looking for, not by how the code is structured.

## 4. Interfaces

Link each machine-readable member here - schemas, interface definitions, configuration reference.
State for each what it governs. Do not summarise its contents.

## 5. Deliberately unspecified

Behaviour callers MUST NOT rely on: iteration order, timing, the contents of error messages,
anything you intend to change. Stating this is what makes the rest of the document safe to depend
on, and it is the section most often missing.

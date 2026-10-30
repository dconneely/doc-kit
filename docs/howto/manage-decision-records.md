# How to manage decision records

This procedure explains how to propose, record owner approval for, and amend decision records in
this repository.

## Goal

Propose a new decision record, obtain owner approval, record acceptance or rejection, and amend an
accepted record safely without leaving stale citations.

## Prerequisites

- Clean git work tree.
- The next available four-digit number under `docs/decisions/`.

## Steps

### Propose a new record

1. **Copy the template**

   Copy `templates/docs/decisions/0000-template.md` to `docs/decisions/NNNN-kebab-case-title.md`,
   zero-padded to four digits. Do not copy an existing record.

2. **Draft the content**

   Fill in the `Context and Problem Statement`, `Considered Options`, and `Decision Outcome`
   sections. The title should name the question the record answers. Keep `status: "proposed"`.

3. **Commit the proposal**

   Commit the proposed record:

   ```sh
   git add docs/decisions/NNNN-*.md
   git commit -m "docs: Propose ADR-NNNN on {topic}"
   ```

### Accept or reject a record

1. **Request the owner's explicit decision**

   Ask the owner explicitly for approval. Only the owner decides status changes.

2. **Update the front-matter**

   On approval:
   - Set `status` to `accepted` or `rejected`.
   - Set `decision-makers` to the owner's name.
   - Set `approval` to the owner's words verbatim.
   - Set `date` to today's date (`YYYY-MM-DD`).

3. **Commit the decision**

   Commit the accepted record:

   ```sh
   git add docs/decisions/NNNN-*.md
   git commit -m "docs: Accept ADR-NNNN on {topic}"
   ```

### Amend an accepted record

1. **Reopen to proposed**

   Obtain owner permission to reopen the record. Change `status` to `proposed`.

2. **Edit and update citations**

   Amend the content in place. In the same commit, fix any citations across the codebase that the
   change invalidates.

3. **Re-accept with owner approval**

   Set `status: "accepted"`, update `date` and `approval` to the owner's latest approval, and
   commit.

A wrong path, command or citation in an accepted record is still a change to its words: follow these
steps for it too. Only formatting applied by a tool, which alters no word, is not a change
(ADR-0007).

## Verification

Run the ADR check to verify structure, front-matter and citations:

```sh
sh tools/doc-kit-check.sh adr
```

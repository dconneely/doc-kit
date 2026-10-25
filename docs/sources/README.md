# External sources

External specifications, RFCs and standards cited in this repository are recorded here so their
provenance, licence and integrity are pinned.

## Source index

| Document                 | URL                                                                         | Retrieved  | Licence    | Redistributable | SHA-256                                                            |
| ------------------------ | --------------------------------------------------------------------------- | ---------- | ---------- | --------------- | ------------------------------------------------------------------ |
| `rfc2119.txt`            | `https://www.rfc-editor.org/rfc/rfc2119.txt`                                | 2026-10-25 | IETF Trust | `yes`           | `3c2ceb7bfc84cd34720f4a5271338ab9d8280d34bdd1eb250c64306202f2ed8b` |
| `madr-3.0.0-template.md` | `https://raw.githubusercontent.com/adr/madr/3.0.0/template/adr-template.md` | 2026-10-25 | CC0-1.0    | `yes`           | `912f0babe427dc89c95e967e866ac14b34e532c4c37aa60ed5c90cd14b0a3715` |
| `adr-tools-template.md`  | `https://raw.githubusercontent.com/npryce/adr-tools/master/src/template.md` | 2026-10-25 | Apache-2.0 | `yes`           | `68c7c24a9bb73419f823c818d7c08f888063eca9d0cdb80e96625b9faa088286` |

## Rules

1. **Pinning and integrity:** Every external document cited normatively SHOULD have a row in the
   index with its retrieval date and SHA-256 checksum.
2. **Redistributability:** Only files whose licence permits public redistribution
   (`Redistributable: yes`) may be committed to git. Files that cannot be redistributed remain
   gitignored.
3. **Retrieval:** Run `./fetch.sh` to download missing sources and verify them against their
   recorded checksums.
4. **Generated extracts:** Markdown or text extracts derived from PDFs or HTML sit beside the
   downloaded source, carrying a generated-file header per `docs/spec.md` §4.3 naming the tool used
   to extract them.

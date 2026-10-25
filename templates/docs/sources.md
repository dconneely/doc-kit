# External sources

<!--
Records external reference material, specifications and standards cited by this repository.

Delete this comment in the copy.
-->

External specifications, RFCs and standards cited in this repository are recorded here so their
provenance, licence and integrity are pinned.

## Source index

| Document | URL     | Retrieved    | Licence     | Redistributable | SHA-256    |
| -------- | ------- | ------------ | ----------- | --------------- | ---------- |
| `{name}` | `{url}` | {YYYY-MM-DD} | `{licence}` | `yes` \| `no`   | `{sha256}` |

## Rules

1. **Pinning and integrity:** Every external document cited normatively SHOULD have a row in the
   index with its retrieval date and SHA-256 checksum.
2. **Redistributability:** Only files whose licence permits public redistribution
   (`Redistributable: yes`) may be committed to git. Files that cannot be redistributed remain
   gitignored.
3. **Retrieval:** Run `sh docs/sources/fetch.sh` (or `cd docs/sources && ./fetch.sh`) to download
   missing sources and verify them against their recorded checksums.
4. **Generated extracts:** Markdown or text extracts derived from PDFs or HTML sit beside the
   downloaded source, carrying a generated-file header per `docs/spec.md` §4.3 naming the tool used
   to extract them.

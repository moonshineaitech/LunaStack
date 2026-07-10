---
name: csv-data-import
description: Use when building bulk data import — CSV/spreadsheet upload, migration ingestion, or recurring feed processing. Produces an import pipeline design with streaming parse, row-level validation reports, dry-run preview, idempotent re-import keys, and defenses against Excel-mangled data.
---

# /csv-data-import — Bulk Import Pipelines That Trust Nothing

Use to design CSV/spreadsheet import that survives real user files: wrong encodings, mangled cells, half-failures, and re-uploads.

**Persona: Data Ingestion Engineer.** Designs the parse→validate→preview→commit pipeline and its failure reporting. Does NOT design the upload transport itself (see file-upload-pipelines) or downstream ETL/warehousing.

**Stream, never load-all**: parse row-by-row (Papa Parse step callbacks, Python `csv` over an incremental decoder, `csv-parser`/`fast-csv` streams) with a hard cap — commonly reject files over **~1M rows or ~500 MB** and route bigger jobs to a batch path (`COPY` into a staging table). Detect before parsing: sniff encoding (UTF-8 first, fall back via charset detection — Excel exports are routinely Windows-1252 with a BOM), sniff delimiter from the first KB (comma/semicolon/tab — locales where comma is the decimal separator export semicolon CSVs), and normalize CRLF. Validate **every row, collect every error** — never fail-fast on row 3 and hide the 400 errors behind it; produce a downloadable row-level report (`row, column, value, error, suggestion`) so the user fixes their file in one pass. Then **dry-run by default**: stage into a shadow table, show "1,240 will create · 87 will update · 12 errors" with a diff sample, and require explicit commit — imports are bulk writes and deserve a preview like any destructive migration. Commit is all-or-nothing per file (single transaction or staged swap) unless the user opts into partial, and **idempotent**: derive a natural key per row (or require one column as external ID) and upsert, plus a file-level content hash so the same file re-uploaded after a timeout doesn't double-create — users always retry. Defend against Excel's signature manglings: leading zeros stripped (ZIP codes, phone numbers — validate length, accept and restore known patterns), long numerics as `1.23457E+15` (reject scientific notation in ID columns), dates coerced (`SEPT1` gene syndrome — treat everything as text until *your* validator types it), and `=`/`+`/`-`/`@`-prefixed cells: on any CSV you *export*, prefix those with `'` to block **CSV injection**. Rule: **No import writes production rows without a staged dry-run report the user confirmed, and re-running the same file must be a no-op.**

BAD: "Read the file into memory, insert rows in a loop, abort on first bad row" (500 MB file OOMs the worker; row 50,001 fails and leaves 50,000 orphans; the retry doubles them). GOOD: "Stream to staging, validate all rows, return an error report + diff preview, commit on confirm with upsert-by-external-ID."

```
IMPORT PIPELINE DESIGN
══════════════════════
Limits: [max rows/MB → batch path beyond] · Parse: [streaming lib · encoding+delimiter sniff]
Validation: [per-row rules · collect-all errors · report: row/col/value/error]
Dry-run: [staging table · create/update/error counts · diff sample]
Commit: [txn or swap · partial: opt-in] · Idempotency: [row key + file hash]
Excel defenses: [text-first typing · sci-notation reject · zero-pad restore · formula-prefix escape on export]
```

Skip when: the import is a one-off developer-run migration — a reviewed script against staging beats pipeline machinery; or rows arrive via API/webhook where the sender handles validation contracts.

Gotchas: validating with the same code path that imports but different config, so preview says OK and commit fails; trusting the header row for mapping without letting the user remap (every export tool names columns differently); treating an empty string, `NULL`, `N/A`, and a missing column as the same value — pick explicit semantics per field; running per-row INSERTs instead of batched/`COPY` writes and turning a 100k-row import into a 40-minute lock festival.

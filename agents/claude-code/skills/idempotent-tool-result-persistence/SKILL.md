---
name: idempotent-tool-result-persistence
description: "Persist tool results once, avoid re-writing duplicates, and summarize via previews so long outputs stay accessible yet capped."
metadata:
  author: ychampion
---

# SKILL: Idempotent Tool Result Persistence
**Domain:** persistence  
**Trigger:** Use this when tool result blocks exceed their configured thresholds and you want to persist them once while still returning a preview.  
**Source Pattern:** Distilled from reviewed tool execution, streaming, persistence, and output-budget implementations.

## Core Method
Persist oversized tool outputs to a deterministic artifact path derived from the tool call ID and content type. Create that artifact with exclusive-write semantics so retries and concurrent writers cannot clobber or duplicate the same payload. After the first successful write, return a compact preview plus metadata pointing at the persisted artifact; later retries should reuse the existing file and regenerate the same preview without rewriting the payload. This keeps large outputs accessible while making persistence safe and repeatable.

## Key Rules
- Create the parent directory once per storage root, but write each artifact with exclusive creation semantics.
- If the target artifact already exists, treat that as a successful prior write and move directly to preview generation.
- Keep preview metadata explicit: content type, truncation status, persisted path, and original size should all be recoverable downstream.
- Log the persisted location and size so operators can trace where a large result went.

## Example Application
When a log-reading tool returns 60 KB of text, write it once to a stable artifact file such as `tool-results/<tool-call-id>.txt`, then send only a short preview plus the saved path. If the same result is replayed on retry, skip the write and reuse the same artifact reference.

## Anti-Patterns (What NOT to do)
- Don’t re-write the same file on retries; failing to check `EEXIST` causes EOS errors and clobbers the previous log.
- Don’t drop the preview header; consumers depend on `<persisted-output>` tags to know the persisted location.

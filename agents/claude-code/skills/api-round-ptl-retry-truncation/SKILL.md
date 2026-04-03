---
name: api-round-ptl-retry-truncation
description: "On prompt-too-long retries, drop the oldest API-round groups first and inject a synthetic user preamble when needed so the summarize request stays valid."
metadata:
  author: ychampion
---

# SKILL: API-Round PTL Retry Truncation
**Domain:** compaction
**Trigger:** Apply when the compaction request itself hits prompt-too-long and you need a last-resort retry path that removes old context without breaking API message validity.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Recover from a prompt-too-long summary attempt by trimming whole API-round groups from the head of the message list instead of slicing arbitrary messages. Size the drop by the reported token gap when available, or by a fallback fraction when it is not, and keep at least one summarizeable group. If trimming leaves the message list starting with an assistant turn, prepend a synthetic user marker so the next retry still satisfies the API's user-first contract.

## Key Rules
- Group by assistant-response boundaries, not raw human turns, so each dropped unit preserves tool-use pairing semantics as much as possible.
- Strip any prior synthetic retry marker before regrouping so repeated retries keep making progress instead of dropping only the marker.
- Keep at least one group after truncation; return `null` when nothing safe remains to summarize.
- Use the parsed token gap when available, but fall back to a deterministic percentage when the provider error format does not expose it.
- Repair assistant-first retries with a synthetic user preamble so the request remains API-valid after head truncation.

## Example Application
If a compaction call on a long single-user-turn session still exceeds the limit, group the transcript by API rounds, drop the oldest rounds until the estimated gap is covered, and retry with a synthetic meta user line when the remaining transcript would otherwise start with an assistant block.

## Anti-Patterns (What NOT to do)
- Do not trim arbitrary individual messages from the head; you can strand tool-use sequences and create invalid retry payloads.
- Do not keep reusing the previous retry marker as part of the grouped history or each retry can stall without reducing real context.

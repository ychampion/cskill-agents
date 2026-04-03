---
name: api-round-message-grouping
description: "Split conversation history into API-round buckets so compaction retries cut only the chunks tied to the failed round."
metadata:
  author: ychampion
---

# SKILL: API Round Message Grouping
**Domain:** context-management
**Trigger:** When compacting or retrying requests, use API-round boundaries instead of human-turn heuristics to determine what past messages belong together.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Walk the message stream and emit a new bucket every time a fresh assistant message with a new message id starts. This respects the API contract that all tool results complete before the next assistant response, so each bucket represents exactly one API round-trip; malformed conversations still fall through because the grouping only fires when a real assistant boundary appears. Downstream compaction retries can then drop or replay whole rounds without breaking tool-result pairing.

## Key Rules
- Track the last assistant message id and start a new group only when it changes while at least one message is already buffered.
- Push the final bucket at the end so the last API round isn’t lost.
- Do not split mid-assistant stream (IDs stay constant across streaming chunks), keeping each API response intact.
- Let dangling tool uses remain in the same group rather than inventing extra boundaries; downstream helpers (ensureToolResultPairing) repair them only when needed.
- Name each bucket explicitly when logging so retry diagnostics can report the round that triggered the fallback.

## Example Application
When a compaction attempt hits prompt too long, call group messages by api round to isolate the round that contained the offending assistant response, then drop just that bucket before retrying.

## Anti-Patterns (What NOT to do)
- Do not group by user turns or by time because API chunks can span multiple user messages and tool results.
- Do not start a new group on every assistant chunk; the streaming assistant may emit multiple chunks with the same `id`, and splitting them would leave incomplete tool-result pairs.

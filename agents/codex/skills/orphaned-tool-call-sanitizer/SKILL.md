---
name: orphaned-tool-call-sanitizer
description: "Remove assistant messages that reference tools without recorded results before feeding the history back into runAgent."
metadata:
  author: ychampion
---

# SKILL: Orphaned Tool Call Sanitizer
**Domain:** messaging
**Trigger:** When replaying history for a subagent, make sure assistant tool_use blocks never refer to tool_use_ids that lack results.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Collect every `tool_use_id` emitted inside `tool_result` blocks on user messages, then drop any assistant message whose content includes a `tool_use` block that references an ID missing from that set. Non-assistant messages and assistant messages without tool_use blocks pass through unchanged, so only the incomplete invocations are pruned before query runs.

## Key Rules
- Build the tool use ids with results set exclusively from user-side `tool_result` blocks, since assistant messages can mention tool_use IDs that never resolved.
- Treat every assistant message containing a `tool_use` entry whose `id` is absent from the result set as unsafe and remove it entirely.
- Preserve progress, system, and clean assistant messages so the downstream agent still sees the rest of the context.
- Run this sanitizer before providing initial messages to run agent so the async call path never sees an orphaned invocation.

## Example Application
When the main agent forks to an Explore or Plan subagent, sanitize the shared history first so the subagent never inherits an assistant tool_use record that was never followed by a tool_result. The downstream query call then succeeds without rejecting the payload.

## Anti-Patterns (What NOT to do)
- Forwarding assistant messages with tool_use blocks that lack corresponding results; such payloads trigger API validation errors.
- Waiting until after the query to drop the offending message, which already fails or leaves the transcript poisoned.

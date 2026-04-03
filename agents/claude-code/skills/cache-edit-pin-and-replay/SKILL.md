---
name: cache-edit-pin-and-replay
description: "Queue cache edits for the next microcompact request, pin them to user-message positions, replay pinned edits later, and reset state only on explicit lifecycle boundaries."
metadata:
  author: ychampion
---

# SKILL: Cache Edit Pin and Replay
**Domain:** context-management
**Trigger:** Apply when the cached microcompact flow must persist tool-result deletions and re-send them across turns without rewriting the cache edits on every retry.
**Source Pattern:** Distilled from reviewed cache-edit replay and microcompact lifecycle implementations.

## Core Method
Keep one pending cache-edit block alive until the next API request consumes it, then pin that block to the originating user-message position so the same edit can be replayed on later turns or retries. Track which tool results have already been sent so you do not regenerate or resend identical edits after every response. Reset the cached edit state only on explicit lifecycle boundaries such as a session reset or manual cache flush. This preserves cache-edit continuity across turns and makes replay deterministic.

## Key Rules
- Keep new cache edits pending until the next API request actually consumes them.
- Pin consumed edits to their originating user-message position so later requests can replay them deterministically.
- After a request completes, mark the related tool results as already sent so the same edits are not requeued.
- Reserve state resets for explicit lifecycle transitions rather than clearing the cache-edit state after every turn.
- Document the lifecycle so future callers know when to zero out the cached state versus when to leave it for reuse.

## Example Application
When a microcompact pass deletes tool results to shrink the cached prefix, queue those deletions for the next request, pin them to the relevant user-message position when they are consumed, and replay them on later turns if the cached conversation needs to be reconstructed.

## Anti-Patterns (What NOT to do)
- Do not clear `pendingCacheEdits` before the API request consumes them; otherwise the next request no longer knows what to delete.
- Do not unpin or reset the cached state after every turn — doing so loses the ability to rehydrate cache edits for a replayed conversation.

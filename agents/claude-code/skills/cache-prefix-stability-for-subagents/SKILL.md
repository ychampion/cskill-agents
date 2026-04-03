---
name: cache-prefix-stability-for-subagents
description: "Preserve cache-critical request fields when a child agent must share the parent's prompt prefix for cache hits."
metadata:
  author: ychampion
---

# SKILL: Cache Prefix Stability For Subagents
**Domain:** agentic-loop
**Trigger:** Apply when a subagent should share the parent's cached prompt prefix instead of recomputing a divergent request shape.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Treat prompt-cache compatibility as an explicit contract when building child agent options. Preserve the cache-critical fields that define the API request prefix, including the merged tool pool, thinking configuration, query source, and content-replacement state, instead of letting child defaults drift away from the parent request. This keeps forked or exact-tool subagents eligible for the same cached prefix while still allowing non-cache-sensitive options to vary.

## Key Rules
- Only inherit cache-critical request fields when the child is intentionally sharing the parent's prefix, such as the use exact tools path.
- Keep the resolved tool list, thinking configuration, and content-replacement state aligned with the parent request so cache keys do not diverge accidentally.
- Preserve the recursive-fork guard inputs like query source when they are part of the cached request prefix contract.
- Do not inherit unrelated defaults blindly; share only the fields that stabilize the prefix and let other child-specific behavior vary intentionally.

## Example Application
If a forked review agent must reuse the parent’s prompt cache, build its options from the parent’s tool list and thinking config instead of resetting them to child defaults; the child can then reuse cached request prefixes while still emitting its own downstream messages.

## Anti-Patterns (What NOT to do)
- Do not disable thinking or rebuild the tool pool for a cache-sharing child unless you also accept losing cache alignment.
- Do not rely on accidental structural similarity between parent and child requests; explicitly carry forward the fields that define the cache prefix.

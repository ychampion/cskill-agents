---
name: cache-identical-fork-prefix-construction
description: "Build forked conversation prefixes that stay identical across turns so prompt caching keeps working."
metadata:
  author: ychampion
---

# SKILL: Cache Identical Fork Prefix Construction
**Domain:** caching
**Trigger:** Use this when a forked agent must reuse the parent prompt cache and needs byte-identical prefixes for each invocation.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Duplicate the parent assistant message wholesale, then generate a single user message containing standardized tool_result placeholders (all with the same text) followed by the directive text. Keeping every byte of the assistant message and placeholder deterministic ensures that identical tool_use sequences map to the same cache key. Build a child-specific directive message by wrapping it in `<fork-boilerplate>` and appending fork directive prefix before the per-worker instructions.

## Key Rules
- Never mutate the cached assistant message; copy it to a new object and only append the uniform tool_result blocks and directive text afterward.
- Use identical placeholder text (`Fork started — processing in background`) for every tool_result so the child prefix byte stream stays constant across runs.
- Append the directive text as the final block after the placeholders, ensuring fork children encode their own instructions without altering earlier bytes.
- Provide the directive in the same build child message helper so the cached prefix always ends with the same sentinel.

## Example Application
When the model triggers a fork from an inline agent, reuse this method to build the fork prompt so the fork shares the cache of the parent — future identical tasks reuse the same cached prefix and avoid redundant API calls.

## Anti-Patterns (What NOT to do)
- Do not recompute the assistant message or tool_result text differently per turn; any divergence breaks the cache key.
- Avoid embedding random IDs or timestamps inside the prefix; keep only stable verbatim text before the directive block.

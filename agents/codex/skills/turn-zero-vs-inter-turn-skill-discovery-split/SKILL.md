---
name: turn-zero-vs-inter-turn-skill-discovery-split
description: "Block skill discovery only on the initial user message; run later discovery asynchronously while tools execute using the write-pivot guard."
metadata:
  author: ychampion
---

# SKILL: Turn-Zero vs Inter-Turn Skill Discovery Split
**Domain:** skill-discovery
**Trigger:** Use when discovery needs to keep responding to fresh user intent without stalling the streaming loop on every iteration.
**Source Pattern:** Distilled from reviewed skill-discovery, attachment, and streaming-loop implementations.

## Core Method
Treat the first real user message as the one place where discovery is allowed to block, because there is no other work yet to hide the latency. After that, move discovery into an asynchronous prefetch that runs while the model streams and tools execute, then consume the results only after the main work finishes. This keeps later discovery off the hot path while still ensuring the first turn gets a complete initial skill surface.

## Key Rules
- Feature-flag the async discovery so builds without skill search can drop the expensive string literal without extra curation.
- Gate the async prefetch so it runs only on iterations that may actually emit new discovery output, avoiding repeat work on read-only passes.
- Keep turn-zero discovery tied to real user input, not generated content or system churn.
- Do not await the async prefetch on the streaming path; only collect it after tools complete, and continue streaming in the meantime.

## Example Application
When implementing a coding assistant, let the first user turn pay the discovery cost up front so the agent starts with accurate suggestions. On later turns, run discovery in the background and surface it only after the main tool loop finishes.

## Anti-Patterns (What NOT to do)
- Do not run the async prefetch while splitting the discovery path without a write-pivot guard; it will fire on every iteration and waste requests.
- Do not let turn-0 work depend on the async path’s completion; there is no prior work to hide under, so block there explicitly.

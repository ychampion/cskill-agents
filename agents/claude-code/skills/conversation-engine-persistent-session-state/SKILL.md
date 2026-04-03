---
name: conversation-engine-persistent-session-state
description: "Keep session-level signals (messages, read caches, memory loads) alive across turns while letting per-turn caches reset for correctness."
metadata:
  author: ychampion
---

# SKILL: Conversation Engine Persistent Session State
**Domain:** session-state
**Trigger:** Apply when architecting a conversation engine that must persist session context while allowing per-turn caches and abort controllers to restart cleanly.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Divide engine state into session scope and turn scope. Session scope keeps long-lived data such as conversation history, cumulative usage, permissions, and reusable read caches for the life of the engine. Turn scope recreates abort handles, transient discovery sets, scratch buffers, and other request-local intermediates every time a new submission starts. On retries, preserve the session data but rebuild the turn-local state from scratch so the engine stays consistent without leaking stale flags between turns.

## Key Rules
- Keep session-wide structures alive for the lifetime of the engine and mutate them in place as new data arrives.
- Recreate and dispose of turn-local abort handles, discovery sets, and scratch buffers on every submission.
- Clear any turn-specific derived context before the next turn begins, but do not reset the retained session history.
- On soft retries, reuse the session state and throw away only the transient work for the failed attempt.

## Example Application
When building a coding-cli-style engine, use this method to keep the conversation history, file caches, and usage counters across hundreds of turns while the abort controller, skill discovery set, and other per-turn caches are reinitialized each time.

## Anti-Patterns (What NOT to do)
- Don’t reconstruct the entire session state every turn; that drops history and resets usage tracking.
- Don’t keep per-turn abort controllers or discovery sets alive past the turn—they can leak cancellations or stale skill data into future turns.

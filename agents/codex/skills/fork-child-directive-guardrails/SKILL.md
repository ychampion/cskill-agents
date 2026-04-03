---
name: fork-child-directive-guardrails
description: "Keep fork-decoupled workers strictly bounded by directive text and cache sharing requirements."
metadata:
  author: ychampion
---

# SKILL: Fork Child Directive Guardrails
**Domain:** agent-coordination
**Trigger:** Apply this when a forked sub-agent inherits a conversation and must obey boilerplate guard text, cache-safe output, and explicit directive rules before running.
**Source Pattern:** Distilled from reviewed subagent orchestration, isolation, and lifecycle implementations.

## Core Method
Compose the fork prompt by merging the parent assistant message with placeholder tool results, then append a distilled directive that enumerates the guardrails (no sub-agents, no chatting, execute silently). Explicitly include the `<fork-boilerplate>` block and the fork directive prefix so downstream cache sharing sees identical bytes for repeated forks. The directive should reinforce pointer translation, note the isolated worktree, and remind the worker that system prompts do not apply.

## Key Rules
- Preserve the parent assistant message intact before the fork; do not rewrite tool labels or thinking blocks so the prompt cache remains compatible.
- Build uniform placeholder tool_result blocks with fixed text (`Fork started — processing in background`) and append the directive block that lists the 10 non-negotiable rules before any user-facing output.
- Include the `<fork-boilerplate>` tag per current cache strategy and apply fork directive prefix to keep child messages byte-identical across runs.
- Explicitly mention that the worker is operating in a fork/isolated worktree and must translate inherited paths before editing.

## Example Application
When imploding a background worker to handle tool-heavy tasks, inject this guardrail directive before executing the fork; downstream watchers will see the same prompt scaffold and track the worker as a fork without extra moderation.

## Anti-Patterns (What NOT to do)
- Do not omit the `<fork-boilerplate>` block or use variable placeholder text, which would invalidate cache sharing.
- Do not let the fork spawn more agents or chat with humans — the directive must forbid sub-agent usage and conversation.

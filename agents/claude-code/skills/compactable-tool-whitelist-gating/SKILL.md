---
name: compactable-tool-whitelist-gating
description: "Only allow cached microcompact to delete tool results for a vetted, pre-gated whitelist of tool names."
metadata:
  author: ychampion
---

# SKILL: Compactable Tool Whitelist Gating
**Domain:** microcompaction  
**Trigger:** Apply when cache-editing compacts conversation transcripts and must avoid deleting outputs from tools that cannot be safely re-run or are non-text.
**Source Pattern:** Distilled from reviewed session memory, compaction, and context-budgeting implementations.

## Core Method
Define a fixed set of safe tools whose outputs can be trimmed via cached microcompact. Compose the set from shell tools, file read/write utilities, grep/glob/web fetch/search, and optionally other text-generating helpers. The microcompact path consults this set to decide whether to register a tool result for deletion, so no unsupported or stateful tools ever get silently mutated.

## Key Rules
- Build the whitelist as a static `Set` once so permission checks stay fast and deterministic.
- Include only tools whose outputs are recoverable or purely text (shell commands, grep/glob, file read/write, fetch/search, etc.).
- Skip tools not on the list so cache edits never attempt to delete specialized state (APIs that mutate files, image tools, etc.).
- Document that new tools must be evaluated before being added to the whitelist to avoid breaking reads.
- Keep the set close to the microcompact path and highlight it in comments so the gating logic stays obvious.

## Example Application
When cached microcompact inspects assistant messages, it only registers tool uses whose names appear in compactable tools, ensuring the summarizer never tries to delete non-text or stateful outputs like MCP connectors or tool search metadata.

## Anti-Patterns (What NOT to do)
- Do not treat all tools equally—many produce binary or stateful outputs that cannot be safely recompiled from cache edits.
- Do not mutate the whitelist at runtime; it must remain a static, vetted guardrail for cached compaction.

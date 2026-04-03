---
name: memoized-command-source-aggregation
description: "Load independent command sources in parallel, then memoize the merged registry by cwd so repeated lookups stay cheap and ordered."
metadata:
  author: ychampion
---

# SKILL: Memoized Command Source Aggregation
**Domain:** command-architecture
**Trigger:** Use when a command or skill registry must combine several expensive sources, but repeated lookups from the same workspace should reuse one stable merged result.
**Source Pattern:** Distilled from reviewed command-surface, skill-discovery, and CLI capability implementations.

## Core Method
Wrap the expensive registry assembly behind a memoized async function keyed by the scope that changes the result, such as `cwd`. Inside that loader, start every independent source fetch at once with promise all so disk scans, plugin discovery, and optional workflow imports overlap instead of serializing. After all sources resolve, merge them in one explicit precedence order rather than in completion order. This keeps first-load latency down while making every later lookup for the same scope a cheap cache hit with deterministic command ordering.

## Key Rules
- Memoize the fully merged registry by the narrowest scope key that actually changes the command surface, such as project root or `cwd`.
- Use promise all only for independent sources; keep source-local fallback or error handling inside each loader so one slow or broken branch does not dictate the aggregation structure.
- Build the final array in a hard-coded precedence order after all promises resolve; never let race timing decide which source comes first.
- Keep synchronous sources and built-ins in the same final merge so cached callers receive the complete command surface from one lookup.

## Example Application
If an agentic IDE must expose commands from local extensions, workspace automations, and remote plugins, create a memoized load all commands workspace root function that fans out those three loaders in parallel, then returns them in the product's chosen precedence order followed by built-ins. Every later command palette lookup for that workspace can reuse the cached merged list instead of rescanning the filesystem and plugin graph.

## Anti-Patterns (What NOT to do)
- Do not await each command source sequentially when the loaders are independent; that turns startup into serialized I/O.
- Do not rebuild the merged registry on every command lookup when the workspace scope has not changed.
- Do not concatenate sources in the order their promises finish, because nondeterministic precedence produces unstable command resolution.

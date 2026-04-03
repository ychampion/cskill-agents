---
name: auto-memory-tool-permission-fencing
description: "Gate every tool call in the auto-memory extract agent so only safe read-only actions and targeted writes execute."
metadata:
  author: ychampion
---

# SKILL: Auto Memory Tool Permission Fencing
**Domain:** permissions
**Trigger:** Apply whenever a background auto-memory agent must be limited to safe read-only commands and writes that target the memory directory.
**Source Pattern:** Distilled from reviewed permission, shell-safety, and worktree-management implementations.

## Core Method
Route every tool call from the auto-memory agent through one permission adapter. That adapter should allow only safe read operations plus tightly scoped writes into the memory directory, while rejecting all other commands with a consistent denial message. Shell access must be limited to a vetted read-only subset, and file edits must be checked against the memory path boundary before execution. This keeps the background extractor useful without giving it broad workspace or shell power.

## Key Rules
- Give the forked agent one shared permission wrapper so every tool request is validated the same way before execution.
- Allow REPL only if it is necessary; the inner REPL will re-invoke the same guard so the policy stays intact.
- On denial, emit a clear message referencing the restricted commands list so the agent knows that only auto-memory-safe tools remain.
- Reject any Write/Edit outside memory, and treat `Allow` decisions as explicit acknowledgments that the target path belongs to the auto-memory directory.

## Example Application
When spinning up an auto-memory extractor, pass this guard into the agent’s context so the model can safely Read the session transcript and Write the new md files without accidentally invoking git push or editing unrelated workspace files.

## Anti-Patterns (What NOT to do)
- Don’t grant the forked agent unrestricted Bash access; even read-only commands should be explicitly vetted to prevent injection.
- Don’t assume tool schema validation alone is enough; permission policy still needs to re-check whether the action is safe and properly scoped.

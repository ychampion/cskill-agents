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
Wrap every tool call through a permission guard that allows only Read/Grep/Glob or read-only Bash commands, blocks edits outside the auto-memory directory, and falls back to Tool permission denial messages for disallowed actions. For Bash, parse the input and rely on bash tool is read only; for Write/Edit/FileEdit, ensure the `file_path` argument points inside the project’s memory folder. Reject everything else with a consistent denial so the forked agent never opens insecure shells.

## Key Rules
- Provide the create auto mem can use tool wrapper to the forked agent so tool requests are validated in a shared helper before execution.
- Allow REPL only if it is necessary; the inner REPL will re-invoke the same guard so the policy stays intact.
- On denial, emit a clear message referencing the restricted commands list so the agent knows that only auto-memory-safe tools remain.
- Reject any Write/Edit outside memory, and treat `Allow` decisions as explicit acknowledgments that the target path belongs to the auto-memory directory.

## Example Application
When spinning up an auto-memory extractor, pass this guard into the agent’s context so the model can safely Read the session transcript and Write the new md files without accidentally invoking git push or editing unrelated workspace files.

## Anti-Patterns (What NOT to do)
- Don’t grant the forked agent unrestricted Bash access; even read-only commands should be explicitly vetted to prevent injection.
- Don’t assume tool schema validation is optional; always parse and re-evaluate is concurrency safe/is read only before letting a tool run.

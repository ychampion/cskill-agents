---
name: lazy-heavy-command-shims
description: "Stub heavy commands so the CLI stays light, loading the real implementation only when the command is executed."
metadata:
  author: ychampion
---

# SKILL: Lazy Heavy Command Shims
**Domain:** Command Architecture  
**Trigger:** Use when commands are structurally required in the registry but their modules are too heavy to import during startup.  
**Source Pattern:** Distilled from reviewed command-surface and lazy-command delegation implementations.

## Core Method
Define a minimal command descriptor that exposes the right name, description, and basic UX hints without importing the heavy implementation. When the user actually runs the command, dynamically import the real module and delegate execution to it. Keep the shim lightweight and transparent so the registry remains fast while the command still feels first-class when invoked.

## Key Rules
- Keep the stub command serializable (no large data or JSX imports) so the registry stays fast.
- The stub’s execution path should dynamically import the heavy module and validate that the loaded command matches the expected shape before delegating.
- Document that the stub’s `source` remains `'builtin'` or `'plugin'` so telemetry still recognizes it without bloating the module graph.
- Use this shim pattern whenever a command’s source file is megabytes long or triggers long initialization.

## Example Application
If an analytics or report command depends on a very large implementation file, register a small shim for discovery and help text, then import the full implementation only when the user invokes that command.

## Anti-Patterns (What NOT to do)
- Don’t import the heavy module at the top level and then forward to it; that defeats the shim’s purpose.
- Don’t duplicate the heavy implementation inside the stub – keep the stub focused on delegation.
- Don’t forget to guard `await import` with a type check (e.g., ensure `real.type === 'prompt'`) before calling `getPromptForCommand`.

